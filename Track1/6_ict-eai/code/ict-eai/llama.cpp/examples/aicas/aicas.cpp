#include "common.h"
#include "arg.h"
#include "console.h"
#include "log.h"
#include "sampling.h"
#include "llama.h"


#include <cassert>
#include <cinttypes>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <ctime>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>


#include <sys/socket.h>
#include <netinet/in.h>
#include <signal.h>
#include <unistd.h>
#include <arm_sve.h>


static llama_context           ** g_ctx;
static llama_model             ** g_model;
static common_sampler          ** g_smpl;
static common_params            * g_params;
static std::vector<llama_token> * g_input_tokens;
static std::ostringstream       * g_output_ss;
static std::vector<llama_token> * g_output_tokens;

static void print_usage(int argc, char ** argv) {
    (void) argc;

    LOG("\nexample usage:\n");
    LOG("\n  text generation:     %s -m your_model.gguf -p \"I believe the meaning of life is\" -n 128 -no-cnv\n", argv[0]);
    LOG("\n  chat (conversation): %s -m your_model.gguf -sys \"You are a helpful assistant\"\n", argv[0]);
    LOG("\n");
}


int main(int argc, char ** argv) {
    common_params params;
    g_params = &params;
    if (!common_params_parse(argc, argv, params, LLAMA_EXAMPLE_MAIN, print_usage)) {
        return 1;
    }

    common_init();
    auto & sparams = params.sampling;

    //socket
    int serverSocket = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in serverAddress;
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_addr.s_addr = INADDR_ANY;
    serverAddress.sin_port = htons(5712); // 端口号
    // 绑定地址和端口
    bind(serverSocket, (struct sockaddr *) &serverAddress, sizeof(serverAddress));
    // 监听连接
    listen(serverSocket, 5);
    struct sockaddr_in clientAddress;
    socklen_t clientAddressSize = sizeof(clientAddress);
    int client_socket = accept(serverSocket, (struct sockaddr *) &clientAddress, &clientAddressSize);



    console::init(params.simple_io, params.use_color);
    atexit([]() { console::cleanup(); });

    if (params.n_ctx != 0 && params.n_ctx < 8) {
        LOG_WRN("%s: warning: minimum context size is 8, using minimum size.\n", __func__);
        params.n_ctx = 8;
    }

    if (params.rope_freq_base != 0.0) {
        LOG_WRN("%s: warning: changing RoPE frequency base to %g.\n", __func__, params.rope_freq_base);
    }

    if (params.rope_freq_scale != 0.0) {
        LOG_WRN("%s: warning: scaling RoPE frequency by %g.\n", __func__, params.rope_freq_scale);
    }

    LOG_INF("%s: llama backend init\n", __func__);

    llama_backend_init();
    llama_numa_init(params.numa);

    llama_model * model = nullptr;
    llama_context * ctx = nullptr;
    common_sampler * smpl = nullptr;

    g_model = &model;
    g_ctx = &ctx;
    g_smpl = &smpl;

    LOG_INF("%s: load the model and apply lora adapter, if any\n", __func__);
    common_init_result llama_init = common_init_from_params(params);

    model = llama_init.model.get();
    ctx = llama_init.context.get();


    if (model == NULL) {
        LOG_ERR("%s: error: unable to load model\n", __func__);
        return 1;
    }

    const llama_vocab * vocab = llama_model_get_vocab(model);


    LOG_INF("%s: llama threadpool init, n_threads = %d\n", __func__, (int) params.cpuparams.n_threads);

    auto * reg = ggml_backend_dev_backend_reg(ggml_backend_dev_by_type(GGML_BACKEND_DEVICE_TYPE_CPU));
    auto * ggml_threadpool_new_fn = (decltype(ggml_threadpool_new) *) ggml_backend_reg_get_proc_address(reg, "ggml_threadpool_new");
    auto * ggml_threadpool_free_fn = (decltype(ggml_threadpool_free) *) ggml_backend_reg_get_proc_address(reg, "ggml_threadpool_free");

    struct ggml_threadpool_params tpp_batch =
            ggml_threadpool_params_from_cpu_params(params.cpuparams_batch);
    struct ggml_threadpool_params tpp =
            ggml_threadpool_params_from_cpu_params(params.cpuparams);

    set_process_priority(params.cpuparams.priority);

    struct ggml_threadpool * threadpool_batch = NULL;
    if (!ggml_threadpool_params_match(&tpp, &tpp_batch)) {
        threadpool_batch = ggml_threadpool_new_fn(&tpp_batch);
        if (!threadpool_batch) {
            LOG_ERR("%s: batch threadpool create failed : n_threads %d\n", __func__, tpp_batch.n_threads);
            return 1;
        }

        // Start the non-batch threadpool in the paused state
        tpp.paused = true;
    }

    struct ggml_threadpool * threadpool = ggml_threadpool_new_fn(&tpp);
    if (!threadpool) {
        LOG_ERR("%s: threadpool create failed : n_threads %d\n", __func__, tpp.n_threads);
        return 1;
    }

    llama_attach_threadpool(ctx, threadpool, threadpool_batch);

    const int n_ctx_train = llama_model_n_ctx_train(model);
    const int n_ctx = llama_n_ctx(ctx);


    const bool add_bos = llama_vocab_get_add_bos(vocab) && !params.use_jinja;
    if (!llama_model_has_encoder(model)) {
        GGML_ASSERT(!llama_vocab_get_add_eos(vocab));
    }

    LOG_DBG("n_ctx: %d, add_bos: %d\n", n_ctx, add_bos);

    
    
    smpl = common_sampler_init(model, sparams);
    if (!smpl) {
        LOG_ERR("%s: failed to initialize sampling subsystem\n", __func__);
        return 1;
    }

    LOG_INF("sampler seed: %u\n",     common_sampler_get_seed(smpl));
    LOG_INF("sampler params: \n%s\n", sparams.print().c_str());
    LOG_INF("sampler chain: %s\n",    common_sampler_print(smpl).c_str());
    LOG_INF("generate: n_ctx = %d, n_batch = %d, n_predict = %d, n_keep = %d\n", n_ctx, params.n_batch, params.n_predict, params.n_keep);
    std::vector<llama_token> embd_inp;
    // llama_model_load_gemm_weight(model);

    while (1) {
        char buffer[4096] = {0};
        ssize_t bytes_read = recv(client_socket, buffer, sizeof(buffer), 0);
        //设置 prompt 返回 token 数
        if (buffer[0] == '0') {
            char *prompt = buffer + 1;
            params.prompt = prompt;
            embd_inp = common_tokenize(ctx, prompt, add_bos, true);

            // LOG("prompt: \"%s\"\n", log_tostr(params.prompt));
            LOG_DBG("tokens: %s\n", string_from(ctx, embd_inp).c_str());

            // Should not run without any tokens
            if (embd_inp.empty()) {
                embd_inp.push_back(llama_vocab_bos(vocab));
                LOG_WRN("embd_inp was considered empty and bos was added: %s\n", string_from(ctx, embd_inp).c_str());
            }

            // number of tokens to keep when resetting context
            if (params.n_keep < 0 || params.n_keep > (int) embd_inp.size()) {
                params.n_keep = (int)embd_inp.size();
            } else {
                params.n_keep += add_bos; // always keep the BOS token
            }

            if (params.verbose_prompt) {
                LOG_INF("%s: prompt: '%s'\n", __func__, params.prompt.c_str());
                LOG_INF("%s: number of tokens in prompt = %zu\n", __func__, embd_inp.size());
                for (int i = 0; i < (int) embd_inp.size(); i++) {
                    LOG_INF("%6d -> '%s'\n", embd_inp[i], common_token_to_piece(ctx, embd_inp[i]).c_str());
                }

                if (params.n_keep > add_bos) {
                    LOG_INF("%s: static prompt based on n_keep: '", __func__);
                    for (int i = 0; i < params.n_keep; i++) {
                        LOG_CNT("%s", common_token_to_piece(ctx, embd_inp[i]).c_str());
                    }
                    LOG_CNT("'\n");
                }
                LOG_INF("\n");
            }
            int tocken_size = embd_inp.size();
            send(client_socket, &tocken_size, 4, 0);
        }
        // prefill 测试
        if (buffer[0] == '1') {
            int total_test = buffer[1];
            printf("begin prefill tokens %d test time %d\n", (int)embd_inp.size(), total_test);
            int n_input = embd_inp.size();
            for (int test = 0; test < total_test; test++) {
                llama_decode(ctx, llama_batch_get_one(embd_inp.data(), n_input));
                llama_kv_cache_clear(ctx);
            }
            int tocken_size = embd_inp.size();
            send(client_socket, &tocken_size, 4, 0);
            // llama_model_free_gemm_weight(model);
            // llama_model_load_gemv_weight(model);
        }
        // decode 测试
        if (buffer[0] == '2') {
            int total_test = buffer[1];
            int max_new_token = buffer[2];
            printf("begin decode new tokens %d test time %d\n", max_new_token, total_test);
            for (int i = 0; i < total_test; i++) {
                bool input_echo           = true;
                bool display              = true;

                int n_past             = 0;
                int n_remain           = params.n_predict;
                int n_consumed         = 0;

                std::vector<int>   input_tokens;  g_input_tokens  = &input_tokens;
                std::vector<int>   output_tokens; g_output_tokens = &output_tokens;
                std::ostringstream output_ss;     g_output_ss     = &output_ss;

                // the first thing we will do is to output the prompt, so set color accordingly
                console::set_display(console::prompt);
                display = params.display_prompt;
                params.n_batch = 1;
                std::vector<llama_token> embd;
                int n_predict = 0;
                while (n_predict <= max_new_token) {
                    // predict
                    if (!embd.empty()) {
                        // Note: (n_ctx - 4) here is to match the logic for commandline prompt handling via
                        // --prompt or --file which uses the same value.
                        // evaluate tokens in batches
                        // embd is typically prepared beforehand to fit within a batch, but not always
                        for (int i = 0; i < (int) embd.size(); i += params.n_batch) {
                            int n_eval = (int) embd.size() - i;
                            if (n_eval > params.n_batch) {
                                n_eval = params.n_batch;
                            }

                            if (llama_decode(ctx, llama_batch_get_one(&embd[i], n_eval))) {
                                LOG_ERR("%s : failed to eval\n", __func__);
                                return 1;
                            }

                            n_past += n_eval;
                        }
                    }

                    embd.clear();

                    if ((int) embd_inp.size() <= n_consumed) {
                        // const llama_token id = llama_sampling_sample(ctx_sampling, ctx, ctx_guidance);
                        const llama_token id = common_sampler_sample(smpl, ctx, -1);

                        common_sampler_accept(smpl, id, /* accept_grammar= */ true);

                        // LOG_DBG("last: %s\n", string_from(ctx, smpl->prev.to_vector()).c_str());

                        embd.push_back(id);

                        // echo this to console
                        input_echo = true;

                        // decrement remaining sampling budget
                        --n_remain;
                    } else {
                        // some user input remains from prompt or interaction, forward it to processing
                        // LOG("embd_inp.size(): %d, n_consumed: %d\n", (int) embd_inp.size(), n_consumed);
                        while ((int) embd_inp.size() > n_consumed) {
                            embd.push_back(embd_inp[n_consumed]);

                            // push the prompt in the sampling context in order to apply repetition penalties later
                            // for the prompt, we don't apply grammar rules
                            common_sampler_accept(smpl, embd_inp[n_consumed], /* accept_grammar= */ false);

                            ++n_consumed;
                            if ((int) embd.size() >= params.n_batch) {
                                break;
                            }
                        }
                    }

                    ++n_predict;
                }
                llama_kv_cache_clear(ctx);
            }
            send(client_socket, "ok", 2, 0);
            break;
        }
    }
    common_perf_print(ctx, smpl);
    common_sampler_free(smpl);

    llama_backend_free();

    ggml_threadpool_free_fn(threadpool);
    ggml_threadpool_free_fn(threadpool_batch);

    return 0;
}