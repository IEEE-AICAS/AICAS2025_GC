
#include <ctype.h>
#include <fcntl.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#if defined _WIN32
    #include "win.h"
#else
    #include <unistd.h>
    #include <sys/mman.h>
#endif
#include <stdbool.h>
#include <assert.h>
#include <chrono>
#include <iostream>

#include <unistd.h>
#include <cstring>


#include <xrt/xrt_device.h>
#include <xrt/xrt_kernel.h>
#include <xrt/xrt_bo.h>
// ----------------------------------------------------------------------------
// Globals
int GS = 0; // group size global for quantization of the weights
#define MAX_BLOCK_D 128
#define MAX_BLOCK_N 896
#define MAX_LAYERS 14

typedef struct {
    // Input/output host pointers
    float*  xout_ptr;
    int8_t* x_ptr;
    float*  xs_ptr;

    // XRT BOs for input/output
    xrt::bo xout_bo;
    xrt::bo x_bo;
    xrt::bo xs_bo;

    // Flat pointer arrays for weights (host-side hugepage memory)
    // int8_t** wq0_ptr;
    // int8_t** wq1_ptr;
    // float**  wqs_ptr;

    // int8_t** wk0_ptr;
    // int8_t** wk1_ptr;
    // float**  wks_ptr;

    // int8_t** wv0_ptr;
    // int8_t** wv1_ptr;
    // float**  wvs_ptr;


    // Flat arrays of XRT BOs (device buffers)
    xrt::bo* wq0_bo;
    xrt::bo* wq1_bo;
    xrt::bo* wqs_bo;
    
    xrt::bo* wk0_bo;
    xrt::bo* wk1_bo;
    xrt::bo* wks_bo;

    xrt::bo* wv0_bo;
    xrt::bo* wv1_bo;
    xrt::bo* wvs_bo;

    xrt::bo* wo0_bo;
    xrt::bo* wo1_bo;
    xrt::bo* wos_bo;

    xrt::bo* w10_bo;
    xrt::bo* w11_bo;
    xrt::bo* w1s_bo;

    xrt::bo* w30_bo;
    xrt::bo* w31_bo;
    xrt::bo* w3s_bo;


    xrt::bo* w20_bo;
    xrt::bo* w21_bo;
    xrt::bo* w2s_bo;

    xrt::bo* wcls0_bo;
    xrt::bo* wcls1_bo;
    xrt::bo* wclss_bo;

    // ... other weight types 
} MatmulAccelerator;


enum WeightType {
    WQ,WK,WV,WO,
    W1,W2,W3,
    WCLS
};

// ----------------------------------------------------------------------------
// Transformer model

typedef struct {
    int dim; // transformer dimension
    int hidden_dim; // for ffn layers
    int n_layers; // number of layers
    int n_heads; // number of query heads
    int n_kv_heads; // number of key/value heads (can be < query heads because of multiquery)
    int vocab_size; // vocabulary size, usually 256 (byte-level)
    int seq_len; // max sequence length
} Config;

typedef struct {
    int8_t* q;    // quantized values
    float* s; // scaling factors
} QuantizedTensor;

typedef struct {
    // token embedding table
    QuantizedTensor *q_tokens; // (vocab_size, dim)
    float* token_embedding_table; // same, but dequantized

    // weights for rmsnorms
    float* rms_att_weight; // (layer, dim) rmsnorm weights
    float* rms_ffn_weight; // (layer, dim)
    // weights for matmuls. note dim == n_heads * head_size
    QuantizedTensor *wq; // (layer, dim, n_heads * head_size)
    QuantizedTensor *wk; // (layer, dim, n_kv_heads * head_size)
    QuantizedTensor *wv; // (layer, dim, n_kv_heads * head_size)
    QuantizedTensor *wo; // (layer, n_heads * head_size, dim)
    // q,k,v bias
    float *bq;  // p->n_heads * head_size 
    float *bk;  // p->n_kv_heads * head_size
    float *bv;  // p->n_kv_heads * head_size
    // weights for ffn
    QuantizedTensor *w1; // (layer, hidden_dim, dim)
    QuantizedTensor *w2; // (layer, dim, hidden_dim)
    QuantizedTensor *w3; // (layer, hidden_dim, dim)
    // final rmsnorm
    float* rms_final_weight; // (dim,)
    //  classifier weights for the logits, on the last layer
    QuantizedTensor *wcls;
    //float *wcls;
} TransformerWeights;

typedef struct {
    // current wave of activations
    float *x; // activation at current time stamp (dim,)
    float *xb; // same, but inside a residual branch (dim,)
    float *xb2; // an additional buffer just for convenience (dim,)
    float *hb; // buffer for hidden dimension in the ffn (hidden_dim,)
    float *hb2; // buffer for hidden dimension in the ffn (hidden_dim,)
    QuantizedTensor xq; // quantized x (dim,)
    QuantizedTensor hq; // quantized hb (hidden_dim,)
    float *q; // query (dim,)
    float *k; // key (dim,)
    float *v; // value (dim,)
    float *att; // buffer for scores/attention values (n_heads, seq_len)
    float *logits; // output logits
    // kv cache
    float* key_cache;   // (layer, seq_len, dim)
    float* value_cache; // (layer, seq_len, dim)
} RunState;  

typedef struct {
    Config config; // the hyperparameters of the architecture (the blueprint)
    TransformerWeights weights; // the weights of the model
    RunState state; // buffers for the "wave" of activations in the forward pass
    // some more state needed to properly clean up the memory mapping (sigh)
    int fd; // file descriptor for memory mapping
    float* data; // memory mapped data pointer
    ssize_t file_size; // size of the checkpoint file in bytes
} Transformer;

void malloc_run_state(RunState* s, Config* p) {

    int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
    s->x = (float*)calloc(p->dim, sizeof(float));
    s->xb = (float*)calloc(p->dim, sizeof(float));
    s->xb2 = (float*)calloc(p->dim, sizeof(float));
    s->hb = (float*)calloc(p->hidden_dim, sizeof(float));
    s->hb2 = (float*)calloc(p->hidden_dim, sizeof(float));
    s->xq = (QuantizedTensor) { .q = (int8_t*)calloc(p->dim, sizeof(int8_t)), .s = (float*)calloc(p->dim, sizeof(float)) };
    s->hq = (QuantizedTensor) { .q = (int8_t*)calloc(p->hidden_dim, sizeof(int8_t)), .s = (float*)calloc(p->hidden_dim, sizeof(float)) };
    s->q = (float*)calloc(p->dim, sizeof(float));
    s->k = (float*)calloc(kv_dim, sizeof(float));
    s->v = (float*)calloc(kv_dim, sizeof(float));
    s->att = (float*)calloc(p->n_heads * p->seq_len, sizeof(float));
    s->logits = (float*)calloc(p->vocab_size, sizeof(float));
    s->key_cache =(float*)calloc(p->n_layers * p->seq_len * kv_dim, sizeof(float));
    s->value_cache = (float*)calloc(p->n_layers * p->seq_len * kv_dim, sizeof(float));
    // ensure all mallocs went fine
    if (!s->x || !s->xb || !s->xb2 || !s->hb || !s->hb2 || !s->q
     || !s->att || !s->logits || !s->key_cache
     || !s->value_cache) {
        fprintf(stderr, "malloc failed!\n");
        exit(EXIT_FAILURE);
    }
}


void free_run_state(RunState* s) {
    free(s->x);
    free(s->xb);
    free(s->xb2);
    free(s->hb);
    free(s->hb2);
    free(s->xq.q);
    free(s->xq.s);
    free(s->hq.q);
    free(s->hq.s);
    free(s->q);
    //free(s->k);
    //free(s->v);
    free(s->att);
    free(s->logits);
    free(s->key_cache);
    free(s->value_cache);
}

// ----------------------------------------------------------------------------
// Quantization functions

void dequantize(QuantizedTensor *qx, float* x, int n) {
    for (int i = 0; i < n; i++) {
        x[i] = qx->q[i] * qx->s[i / GS];
    }
}

void quantize(QuantizedTensor *qx, float* x, int n) {
    int num_groups = n / GS;  //GS is the number of quantization elements in a group
    float Q_MAX = 127.0f;

    for (int group = 0; group < num_groups; group++) {

        // find the max absolute value in the current group
        float wmax = 0.0;
        for (int i = 0; i < GS; i++) {
            float val = fabs(x[group * GS + i]);
            // if (val > wmax) {
            //     wmax = val;
            // }
            wmax = fmaxf(wmax, val); 
        }

        // calculate and write the scaling factor
        float scale = (wmax + 1e-8f) / Q_MAX;  //Here, we added an eclipse to avoid imprecision
        qx->s[group] = scale;

        // calculate and write the quantized values
        for (int i = 0; i < GS; i++) {
            float quant_value = x[group * GS + i] / scale; // scale
            //int8_t quantized = (int8_t) round(quant_value); // round and clamp
            int8_t quantized = (int8_t) floorf(quant_value + 0.5f); // ?floorf???round???????????

            qx->q[group * GS + i] = quantized;
        }
    }
}




/* initialize `n` x quantized tensor (with `size_each` elements), starting from memory pointed at *ptr */
QuantizedTensor *init_quantized_tensors(void **ptr, int n, int size_each) {
    void *p = *ptr;
    QuantizedTensor *res = (QuantizedTensor *)malloc(n * sizeof(QuantizedTensor));
    if (!res) {
        fprintf(stderr, "Error: Failed to allocate memory for QuantizedTensor!\n");
        exit(EXIT_FAILURE);
    }
    for(int i=0; i<n; i++) {
        /* map quantized int8 values*/
        res[i].q = (int8_t*)p;
        p = (int8_t*)p + size_each;
        /* map scale factors */
        res[i].s = (float*)p;
        p = (float*)p + size_each / GS;
    }
    *ptr = p; 
    return res;
}


void free_transformer(Transformer* t) {

    free(t->weights.q_tokens);
    free(t->weights.token_embedding_table);
    // free(t->weights.wq);
    // free(t->weights.wk);
    // free(t->weights.wv);
    // free(t->weights.wo);
    // free(t->weights.w1);
    // free(t->weights.w2);
    // free(t->weights.w3);
    if(t->weights.wcls != t->weights.q_tokens) { free(t->weights.wcls); }

    if (t->data != MAP_FAILED) { munmap(t->data, t->file_size); }
    if (t->fd != -1) { close(t->fd); }

    free_run_state(&t->state);
}
void free_transformer_fpga_version(Transformer* t) {

    free(t->weights.wq);
    free(t->weights.wk);
    free(t->weights.wv);
    free(t->weights.wo);
    free(t->weights.w1);
    free(t->weights.w2);
    free(t->weights.w3);

}


// void* alloc_aligned_or_hugepage(size_t size, const std::string& label) {
//     // Try mmap with hugepage first
//     void* ptr = mmap(nullptr, size, PROT_READ | PROT_WRITE,
//                      MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
//     if (ptr != MAP_FAILED) {
//         std::memset(ptr, 0, size);
//         std::cout << "✅ Hugepage allocated: " << label << " size=" << size << " @ " << ptr << "\n";
//         return ptr;
//     }

//     // Fallback to posix_memalign
//     std::cerr << "❌ Hugepage allocation failed for " << label << " (" << size << " bytes). Falling back...\n";
//     void* aligned_ptr = nullptr;
//     if (posix_memalign(&aligned_ptr, 4096, size) != 0 || !aligned_ptr) {
//         perror("posix_memalign");
//         throw std::bad_alloc();
//     }
//     std::memset(aligned_ptr, 0, size);
//     std::cout << "✅ Fallback page allocated: " << label << " size=" << size << " @ " << aligned_ptr << "\n";
//     return aligned_ptr;
// }


void allocate_existing_weights(
    xrt::bo*& w0_bo, xrt::bo*& w1_bo, xrt::bo*& ws_bo,
    xrt::device& device, xrt::kernel& kernel,
    QuantizedTensor* w, int n_layers, int n, int dim)
{
    const int d_blocks = (dim + MAX_BLOCK_D - 1) / MAX_BLOCK_D;
    const int n_blocks = (n + MAX_BLOCK_N - 1) / MAX_BLOCK_N;
    const int total_blocks = n_layers * d_blocks * n_blocks;

    // const int raw_half_block = MAX_BLOCK_D * MAX_BLOCK_N / 2;
    // const int half_block_size = ((raw_half_block + 4095) / 4096) * 4096;
    // const int raw_scale_size = MAX_BLOCK_D * (MAX_BLOCK_N / GS) * sizeof(float);
    // const int scale_block_size = ((raw_scale_size + 4095) / 4096) * 4096;

    const int half_block_size = MAX_BLOCK_D * MAX_BLOCK_N / 2;
    const int scale_block_size  = MAX_BLOCK_D * (MAX_BLOCK_N / GS) * sizeof(float);

    w0_bo = new xrt::bo[total_blocks];
    w1_bo = new xrt::bo[total_blocks];
    ws_bo = new xrt::bo[total_blocks];

    for (int l = 0; l < n_layers; l++) {
        const int8_t* w_data;
        const float*  s_data;

        if (n_layers == 1) {
            w_data = w->q;
            s_data = w->s;
        } else {
            w_data = w[l].q;
            s_data = w[l].s;

        }

        for (int db = 0; db < d_blocks; db++) {
            for (int nb = 0; nb < n_blocks; nb++) {
                int idx = l * d_blocks * n_blocks + db * n_blocks + nb;

                // Create XRT BOs (XRT-managed memory)
                w0_bo[idx] = xrt::bo(device, half_block_size, kernel.group_id(2));
                w1_bo[idx] = xrt::bo(device, half_block_size, kernel.group_id(3));
                ws_bo[idx] = xrt::bo(device, scale_block_size, kernel.group_id(4));

                int8_t* w0_ptr = w0_bo[idx].map<int8_t*>();
                int8_t* w1_ptr = w1_bo[idx].map<int8_t*>();
                float*  ws_ptr = ws_bo[idx].map<float*>();

                std::memset(w0_ptr, 0, half_block_size);
                std::memset(w1_ptr, 0, half_block_size);
                std::memset(ws_ptr,  0, scale_block_size);

                // Copy weights
                for (int i = 0; i < MAX_BLOCK_D; i++) {
                    int gi = db * MAX_BLOCK_D + i;
                    if (gi >= dim) continue;
                    for (int j = 0; j < MAX_BLOCK_N; j++) {
                        int gj = nb * MAX_BLOCK_N + j;
                        int8_t val = (gj < n) ? w_data[gi * n + gj] : 0;

                        int flat_idx = i * MAX_BLOCK_N + j;
                        if (flat_idx < half_block_size)
                            w0_ptr[flat_idx] = val;
                        else
                            w1_ptr[flat_idx - half_block_size] = val;
                    }
                }

                // Copy scales
                for (int i = 0; i < MAX_BLOCK_D; i++) {
                    int gi = db * MAX_BLOCK_D + i;
                    if (gi >= dim) continue;
                    for (int j = 0; j < MAX_BLOCK_N / GS; j++) {
                        int gj = nb * (MAX_BLOCK_N / GS) + j;
                        float val = (gj < (n / GS)) ? s_data[gi * (n / GS) + gj] : 0.0f;
                        ws_ptr[i * (MAX_BLOCK_N / GS) + j] = val;
                    }
                }

                w0_bo[idx].sync(XCL_BO_SYNC_BO_TO_DEVICE);
                w1_bo[idx].sync(XCL_BO_SYNC_BO_TO_DEVICE);
                ws_bo[idx].sync(XCL_BO_SYNC_BO_TO_DEVICE);
            }
        }
    }
}






void allocate_fpga_buffers(Transformer *transformer, 
                            MatmulAccelerator* accel,
                           xrt::device& device, xrt::kernel& kernel,
                           TransformerWeights *w, Config* p) {
    accel->x_bo = xrt::bo(device, MAX_BLOCK_N * sizeof(int8_t), kernel.group_id(0));
    accel->xs_bo = xrt::bo(device, (MAX_BLOCK_N / GS) * sizeof(float), kernel.group_id(1));
    accel->xout_bo = xrt::bo(device, MAX_BLOCK_D * sizeof(float), kernel.group_id(0));
    int dim = p->dim;
    int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
    // Split w into two equal parts: w0 and w1    accel->xout_bo = xrt::bo(device, MAX_BLOCK_D * sizeof(float), kernel.group_id(0));
    accel->x_ptr = accel->x_bo.map<int8_t*>();
    accel->xs_ptr = accel->xs_bo.map<float*>();
    accel->xout_ptr = accel->xout_bo.map<float*>();

    allocate_existing_weights(accel->wq0_bo, accel->wq1_bo, accel->wqs_bo, device, kernel, w->wq, p->n_layers, p->dim, p->dim);
    allocate_existing_weights(accel->wk0_bo, accel->wk1_bo, accel->wks_bo, device, kernel, w->wk, p->n_layers, p->dim, kv_dim);
    allocate_existing_weights(accel->wv0_bo, accel->wv1_bo, accel->wvs_bo, device, kernel, w->wv, p->n_layers, p->dim, kv_dim);
    allocate_existing_weights(accel->wo0_bo, accel->wo1_bo, accel->wos_bo, device, kernel, w->wo, p->n_layers, p->dim, p->dim);
    //allocate_existing_weights(accel->wcls0_bo, accel->wcls1_bo, accel->wclss_bo, device, kernel, w->wcls, 1, dim, p->vocab_size);
    allocate_existing_weights(accel->w10_bo, accel->w11_bo, accel->w1s_bo, device, kernel, w->w1, p->n_layers, p->dim, p->hidden_dim);
    allocate_existing_weights(accel->w30_bo, accel->w31_bo, accel->w3s_bo, device, kernel, w->w3, p->n_layers, p->dim, p->hidden_dim);
    allocate_existing_weights(accel->w20_bo, accel->w21_bo, accel->w2s_bo, device, kernel, w->w2, p->n_layers, p->hidden_dim, p->dim);
    printf("finished allocating w\n");


    free_transformer_fpga_version(transformer);

}





//map the weights to the memory pointed at by `ptr`
void memory_map_weights(TransformerWeights *w, Config* p, void* ptr, uint8_t shared_classifier, bool bias) {
    int head_size = p->dim / p->n_heads;

    float* fptr = (float*) ptr; 

    w->rms_att_weight = fptr;
    fptr += p->n_layers * p->dim;
    w->rms_ffn_weight = fptr;
    fptr += p->n_layers * p->dim;
    w->rms_final_weight = fptr;
    fptr += p->dim;

    if (bias){
        w->bq = fptr;
        fptr += p->n_layers * (p->n_heads * head_size);
        w ->bk = fptr;
        fptr += p->n_layers * (p->n_kv_heads * head_size);
        w->bv = fptr;
        fptr += p->n_layers * (p->n_kv_heads * head_size);
    }

    // now read all the quantized weights
    ptr = (void*)fptr; // now cast the pointer back to void*
    w->q_tokens = init_quantized_tensors(&ptr, 1, p->vocab_size * p->dim);

    w->token_embedding_table = (float*)malloc(p->vocab_size * p->dim * sizeof(float));
    dequantize(w->q_tokens, w->token_embedding_table, p->vocab_size * p->dim);

    w->wq = init_quantized_tensors(&ptr, p->n_layers, p->dim * (p->n_heads * head_size));

    w->wk = init_quantized_tensors(&ptr, p->n_layers, p->dim * (p->n_kv_heads * head_size));

    w->wv = init_quantized_tensors(&ptr, p->n_layers, p->dim * (p->n_kv_heads * head_size));

    w->wo = init_quantized_tensors(&ptr, p->n_layers, (p->n_heads * head_size) * p->dim);

    w->w1 = init_quantized_tensors(&ptr, p->n_layers, p->dim * p->hidden_dim);
    w->w2 = init_quantized_tensors(&ptr, p->n_layers, p->hidden_dim * p->dim);
    w->w3 = init_quantized_tensors(&ptr, p->n_layers, p->dim * p->hidden_dim);

    w->wcls = shared_classifier ? w->q_tokens : init_quantized_tensors(&ptr, 1, p->dim * p->vocab_size);

}





//read checkpoint model file
void read_checkpoint(const char* checkpoint, Config* config, TransformerWeights* weights,
                     int* fd, float** data, ssize_t* file_size) {
    FILE *file = fopen(checkpoint, "rb");
    if (!file) { fprintf(stderr, "Couldn't open file %s\n", checkpoint); exit(EXIT_FAILURE); }
    // read in magic number (uint32), has to be 0x616b3432, i.e. "ak42" in ASCII
    uint32_t magic_number;
    if (fread(&magic_number, sizeof(uint32_t), 1, file) != 1) { exit(EXIT_FAILURE); }
    if (magic_number != 0x616b3432) { fprintf(stderr, "Bad magic number\n"); exit(EXIT_FAILURE); }
    // read in the version number (uint32), has to be 2
    int version;
    if (fread(&version, sizeof(int), 1, file) != 1) { exit(EXIT_FAILURE); }
    if (version != 2) { fprintf(stderr, "Bad version %d, need version 2\n", version); exit(EXIT_FAILURE); }
    int header_size = 256; // the header size for version 2 in bytes
    // read in the Config
    if (fread(config, sizeof(Config), 1, file) != 1) { exit(EXIT_FAILURE); }
    // read in flags
    uint8_t shared_classifier; // a byte to indicate if the classifier is shared
    if (fread(&shared_classifier, sizeof(uint8_t), 1, file) != 1) { exit(EXIT_FAILURE); }
    int group_size; // the group size used in quantization
    if (fread(&group_size, sizeof(int), 1, file) != 1) { exit(EXIT_FAILURE); }
    GS = group_size; // set as global, as it will be used in many places
    // figure out the file size
    #if defined _WIN32
        _fseeki64(file, 0, SEEK_END); // move file pointer to end of file
        *file_size = _ftelli64(file); // get the file size, in bytes
    #else
        fseek(file, 0, SEEK_END); // move file pointer to end of file
        *file_size = ftell(file); // get the file size, in bytes
    #endif
    fclose(file);
    // memory map the Transformer weights into the data pointer
    *fd = open(checkpoint, O_RDONLY);
    if (*fd == -1) { fprintf(stderr, "open failed!\n"); exit(EXIT_FAILURE); }

    *data =(float*) mmap(NULL, *file_size, PROT_READ, MAP_PRIVATE, *fd, 0);
    if (*data == MAP_FAILED) { fprintf(stderr, "mmap failed!\n"); exit(EXIT_FAILURE); }
    void* weights_ptr = ((char*)*data) + header_size; // skip header bytes. char is 1 byte
    memory_map_weights(weights, config, weights_ptr, shared_classifier,true);
}

void build_transformer(Transformer *t, const char* checkpoint_path) {
    // read in the Config and the Weights from the checkpoint
    read_checkpoint(checkpoint_path, &t->config, &t->weights, &t->fd, &t->data, &t->file_size);
    // allocate the RunState buffers
    malloc_run_state(&t->state, &t->config);
}

//calculate rmsnorm in parallel
void rmsnorm(float *o, float *x, float *weight, int size) {
    float ss = 0.0f;

    //  OpenMP + SIMD 
    #pragma omp simd reduction(+:ss)
    for (int j = 0; j < size; j++) {
        ss += x[j] * x[j];
    }


    ss = 1.0f / sqrtf(ss / size + 1e-6f);


    #pragma omp simd
    for (int j = 0; j < size; j++) {
        o[j] = weight[j] * (ss * x[j]);
    }
}


void softmax(float *x, int size) {
    float max_val = x[0];
    #pragma omp simd reduction(max:max_val) // SIMD ????
    for (int i = 0; i < size; i++) {
        max_val = fmaxf(max_val, x[i]);
    }

    float sum = 0.0f;
    #pragma omp simd reduction(+:sum) 
    for (int i = 0; i < size; i++) {
        x[i] = expf(x[i] - max_val);
        sum += x[i];
    }

    sum = fmaxf(sum, 1e-6f); 
    for (int i = 0; i < size; i++) {
        x[i] /= sum;
    }
}



// matmul function of quantized tensors
void matmul(float* xout, QuantizedTensor *x, QuantizedTensor *w, int n, int d) {
    // W (d,n) @ x (n,) -> xout (d,)

    int i;
    #pragma omp parallel for private(i)
    for (i = 0; i < d; i++) {

        float val = 0.0f;
        int32_t ival = 0;
        int in = i * n;

        // do the matmul in groups of GS
        int j;
        for (j = 0; j <= n - GS; j += GS) {
            for (int k = 0; k < GS; k++) {
                ival += ((int32_t) x->q[j + k]) * ((int32_t) w->q[in + j + k]);
            }
            val += ((float) ival) * w->s[(in + j) / GS] * x->s[j / GS];
            ival = 0;
        }

        xout[i] = val;
    }
}


void matmul_fpga(
    float* xout,
    QuantizedTensor* x,
    int layer,
    int n,
    int d,
    WeightType type,
    xrt::kernel& kernel,
    MatmulAccelerator* accel,
    xrt::device& device
) {
    //auto t_start = std::chrono::high_resolution_clock::now();
    std::fill(xout, xout + d, 0.0f);

    const int d_blocks = (d + MAX_BLOCK_D - 1) / MAX_BLOCK_D;
    const int n_blocks = (n + MAX_BLOCK_N - 1) / MAX_BLOCK_N;
    auto W_INDEX = [&](int l, int db, int nb) {
        return l * d_blocks * n_blocks + db * n_blocks + nb;
    };
    
    // Select device BOs for this weight type
    xrt::bo* w0_bo = nullptr;
    xrt::bo* w1_bo = nullptr;
    xrt::bo* ws_bo = nullptr;

    switch (type) {
        case WQ:   w0_bo = accel->wq0_bo; w1_bo = accel->wq1_bo; ws_bo = accel->wqs_bo; break;
        case WK:   w0_bo = accel->wk0_bo; w1_bo = accel->wk1_bo; ws_bo = accel->wks_bo; break;
        case WV:   w0_bo = accel->wv0_bo; w1_bo = accel->wv1_bo; ws_bo = accel->wvs_bo; break;
        case WO:   w0_bo = accel->wo0_bo; w1_bo = accel->wo1_bo; ws_bo = accel->wos_bo; break;
        case W1:   w0_bo = accel->w10_bo; w1_bo = accel->w11_bo; ws_bo = accel->w1s_bo; break;
        case W2:   w0_bo = accel->w20_bo; w1_bo = accel->w21_bo; ws_bo = accel->w2s_bo; break;
        case W3:   w0_bo = accel->w30_bo; w1_bo = accel->w31_bo; ws_bo = accel->w3s_bo; break;
        //case WCLS: w0_bo = accel->wcls0_bo; w1_bo = accel->wcls1_bo; ws_bo = accel->wclss_bo; break;
        default:
            std::cerr << "❌ Invalid WeightType in matmul_fpga()\n";
            std::abort();
    }

    for (int nb = 0; nb < n_blocks; nb++) {
        int n_size = std::min(MAX_BLOCK_N, n - nb * MAX_BLOCK_N);
        int x_scale_count = (n_size + GS - 1) / GS;

        // Load sliced x and xs into FPGA input buffers

        std::memcpy(accel->x_ptr, &x->q[nb * MAX_BLOCK_N], n_size * sizeof(int8_t));
        std::memcpy(accel->xs_ptr, &x->s[nb * (MAX_BLOCK_N / GS)], x_scale_count * sizeof(float));



        accel->x_bo.sync(XCL_BO_SYNC_BO_TO_DEVICE);
        accel->xs_bo.sync(XCL_BO_SYNC_BO_TO_DEVICE);

        for (int db = 0; db < d_blocks; db++) {
            int d_size = std::min(MAX_BLOCK_D, d - db * MAX_BLOCK_D);
            int idx = W_INDEX(layer, db, nb);  // Flat index


            // Sync weights (assumes already loaded into memory during init)
            // w0_bo[idx].sync(XCL_BO_SYNC_BO_TO_DEVICE);
            // w1_bo[idx].sync(XCL_BO_SYNC_BO_TO_DEVICE);
            // ws_bo[idx].sync(XCL_BO_SYNC_BO_TO_DEVICE);

            // Launch kernel
            auto run = kernel(accel->xout_bo,accel->x_bo,accel->xs_bo,w0_bo[idx],w1_bo[idx],ws_bo[idx]);
            
            // run.set_event(xrt::event::complete);  // Tell XRT to wait via interrupt
            // run.start();                          // 🚀 Non-blocking start
            run.wait();                           
        
            accel->xout_bo.sync(XCL_BO_SYNC_BO_FROM_DEVICE);

            // Accumulate output
            for (int i = 0; i < d_size; i++) {
                xout[db * MAX_BLOCK_D + i] += accel->xout_ptr[i];
            }
        }
    }
    // auto t_end = std::chrono::high_resolution_clock::now();
    // auto time_ms = std::chrono::duration_cast<std::chrono::microseconds>(t_end - t_start).count() / 1000.0;
    // std::cout << "[FPGA]  time: " << time_ms << " ms\n";
    // getchar();
}


#include <chrono>
using Clock = std::chrono::high_resolution_clock;

double time_us(std::function<void()> fn) {
    auto start = Clock::now();
    fn();
    auto end = Clock::now();
    return std::chrono::duration<double, std::micro>(end - start).count();
}


float* forward(Transformer* transformer, int token, int pos,bool need_bias, xrt::kernel& kernel, 
            MatmulAccelerator* accel, xrt::device& device) {

  // a few convenience variables
    Config *p = &transformer->config;
    TransformerWeights *w = &transformer->weights;
    RunState *s = &transformer->state;
    float *x = s->x;
    int dim = p->dim;
    int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
    int kv_mul = p->n_heads / p->n_kv_heads; // integer multiplier of the kv sharing in multiquery
    int hidden_dim = p->hidden_dim;
    int head_size = dim / p->n_heads;

    // copy the token embedding into x  token_embedding_table + token bia = embedding of this token
    float *content_row = w->token_embedding_table + token * dim;
    memcpy(x, content_row, dim * sizeof(*x));

    // forward all the layers
    for(unsigned long long l = 0; l < p->n_layers; l++) {

        // attention rmsnorm
        rmsnorm(s->xb, x, w->rms_att_weight + l * dim, dim);

        //key and value point to the kv cache
        int loff = l * p->seq_len * kv_dim; // kv cache layer offset for convenience
        s->k = s->key_cache + loff + pos * kv_dim;
        s->v = s->value_cache + loff + pos * kv_dim;

        // qkv matmuls for this position
        quantize(&s->xq, s->xb, dim);
        matmul_fpga(s->q, &s->xq, l, dim, dim, WQ, kernel, accel, device);

        
        matmul_fpga(s->k, &s->xq, l, dim, kv_dim, WK, kernel, accel, device);
        matmul_fpga(s->v, &s->xq, l, dim, kv_dim, WV, kernel, accel, device);



        // bias


        for(int ptr=0;ptr<dim;ptr++)
        {
            s->q[ptr] += *(w->bq+l*dim+ptr);
        }

        for(int ptr=0;ptr<kv_dim;ptr++)
        {
            s->k[ptr] += *(w->bk+l*kv_dim+ptr);
            s->v[ptr] += *(w->bv+l*kv_dim+ptr);
        }


        // // RoPE relative positional encoding: complex-valued rotate q and k in each head

        for(int i = 0; i < p->dim; i+=head_size)
        {
        for(int head_dim = i%head_size; head_dim  <  head_size / 2; head_dim ++)
        {
            float freq =
                1.0f / powf(1000000.0f, (float)(head_dim*2) / (float)head_size);
            float val = pos * freq;
            float fci= sinf(val);
            float fcr= cosf(val);

            float q0 = s->q[i + head_dim];
            float q1 = s->q[i + head_dim + head_size / 2];
            s->q[i + head_dim] = q0 * fcr - q1 * fci;
            s->q[i + head_dim + head_size / 2] = q0 * fci + q1 * fcr;
            if (i < p->n_kv_heads*head_size) {
                float k0 = s->k[i + head_dim];
                float k1 = s->k[i + head_dim + head_size / 2];
                s->k[i + head_dim] = k0 * fcr - k1 * fci;
                s->k[i + head_dim + head_size / 2] = k0 * fci + k1 * fcr;
            }
        }
        }


        int h;
    #pragma omp parallel for private(h)
        for (h = 0; h < p->n_heads; h++) {
        // get the query vector for this head
        float *q = s->q + h * head_size;
        // attention scores for this head
        float *att = s->att + h * p->seq_len;
        // iterate over all timesteps, including the current one
        for (int t = 0; t <= pos; t++) {
            // get the key vector for this head and at this timestep
            float *k = s->key_cache + loff + t * kv_dim + (h / kv_mul) * head_size;
            // calculate the attention score as the dot product of q and k
            float score = 0.0f;
            for (int i = 0; i < head_size; i++) {
            score += q[i] * k[i];
            }
            score /= sqrtf(head_size);
            // save the score to the attention buffer
            att[t] = score;
        }

        // softmax the scores to get attention weights, from 0..pos inclusively
        softmax(att, pos + 1);

        // weighted sum of the values, store back into xb
        float *xb = s->xb + h * head_size;
        memset(xb, 0, head_size * sizeof(float));
        for (int t = 0; t <= pos; t++) {
            // get the value vector for this head and at this timestep
            float *v = s->value_cache + loff + t * kv_dim + (h / kv_mul) * head_size;
            // get the attention weight for this timestep
            float a = att[t];
            // accumulate the weighted value into xb
            for (int i = 0; i < head_size; i++) {
            xb[i] += a * v[i];
            }
        }
        }



        // final matmul to get the output of the attention
        quantize(&s->xq, s->xb, dim);
        matmul_fpga(s->xb2, &s->xq, l, dim, dim, WO, kernel, accel, device);

        //residual connection
        for (int i = 0; i < dim; i++) {
            x[i] += s->xb2[i];
        }


        rmsnorm(s->xb, x, w->rms_ffn_weight + l * dim, dim);


        quantize(&s->xq, s->xb, dim);
        matmul_fpga(s->hb, &s->xq, l, dim, hidden_dim, W1, kernel, accel, device);
        matmul_fpga(s->hb2, &s->xq, l, dim, hidden_dim, W3,kernel, accel, device);

        // SwiGLU non-linearity
        for (int i = 0; i < hidden_dim; i++) {
            float val = s->hb[i];

            val *= (1.0f / (1.0f + expf(-val)));
            val *= s->hb2[i];
            s->hb[i] = val;
        }

        // final matmul to get the output of the ffn
        quantize(&s->hq, s->hb, hidden_dim);
        matmul_fpga(s->xb, &s->hq, l, hidden_dim, dim,  W2, kernel, accel,device);

        for (int i = 0; i < dim; i++) {
            x[i] += s->xb[i];
        }
    }

    // final rmsnorm
    rmsnorm(x, x, w->rms_final_weight, dim);

    // classifier into logits
    quantize(&s->xq, x, dim);
    matmul(s->logits, &s->xq, w->wcls, dim, p->vocab_size);
    return s->logits;
}




// ----------------------------------------------------------------------------
// The Byte Pair Encoding (BPE) Tokenizer that translates strings <-> tokens

typedef struct {
    char *str;
    int id;
} TokenIndex;

typedef struct {
    char** vocab;
    float* vocab_scores;
    TokenIndex *sorted_vocab;
    int vocab_size;
    unsigned int max_token_length;
    unsigned char byte_pieces[512]; // stores all single-byte strings
} Tokenizer;

int compare_tokens(const void *a, const void *b) {
    return strcmp(((TokenIndex*)a)->str, ((TokenIndex*)b)->str);
}

void build_tokenizer(Tokenizer* t, const char* tokenizer_path, int vocab_size) {
    // i should have written the vocab_size into the tokenizer file... sigh
    t->vocab_size = vocab_size;
    // malloc space to hold the scores and the strings
    t->vocab = (char**)malloc(vocab_size * sizeof(char*));
    t->vocab_scores = (float*)malloc(vocab_size * sizeof(float));
    t->sorted_vocab = NULL; // initialized lazily
    for (int i = 0; i < 256; i++) {
        t->byte_pieces[i * 2] = (unsigned char)i;
        t->byte_pieces[i * 2 + 1] = '\0';
    }
    // read in the file
    FILE *file = fopen(tokenizer_path, "rb");
    if (!file) { fprintf(stderr, "couldn't load %s\n", tokenizer_path); exit(EXIT_FAILURE); }
    if (fread(&t->max_token_length, sizeof(int), 1, file) != 1) { fprintf(stderr, "failed read\n"); exit(EXIT_FAILURE); }
    int len;
    clock_t start_time = clock();
    for (int i = 0; i < vocab_size; i++) {
        if (fread(t->vocab_scores + i, sizeof(float), 1, file) != 1) { fprintf(stderr, "failed read\n"); exit(EXIT_FAILURE);}
        if (fread(&len, sizeof(int), 1, file) != 1) { fprintf(stderr, "failed read\n"); exit(EXIT_FAILURE); }
        t->vocab[i] = (char *)malloc(len + 1);
        if (fread(t->vocab[i], len, 1, file) != 1) { fprintf(stderr, "failed read\n"); exit(EXIT_FAILURE); }
        t->vocab[i][len] = '\0'; 
    }
    fclose(file);
    clock_t end_time = clock();
    double time_taken = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;
  printf("Load voacb time taken: %.6f seconds\n", time_taken);
}

void free_tokenizer(Tokenizer* t) {
    for (int i = 0; i < t->vocab_size; i++) { free(t->vocab[i]); }
    free(t->vocab);
    free(t->vocab_scores);
    free(t->sorted_vocab);
}


void decode(Tokenizer *t, int token, char* string) {
  char *piece = t->vocab[token];
  int piece_ori_len=0;
  int string_len=0;

  // blank and new line
  const char* blank_char = "Ġ"; // 2 bytes: 0xC4 0xA0 (UTF-8 representation of '?')
  const char* new_line_char =  "Ċ"; // 2 bytes: 0xC4 0x8A (UTF-8 representation of '?')

  while(piece[piece_ori_len]!='\0')
  {
    // blank
    if(piece[piece_ori_len]==blank_char[0])
    {
      if(piece[piece_ori_len+1]==blank_char[1])
      {string[string_len++] = ' ';}
      else
      {string[string_len++] = '\n';}
      piece_ori_len++;
    }
    else
    {string[string_len++]=piece[piece_ori_len];}
    piece_ori_len++;
  }
  string[string_len++]='\0';
}





void safe_printf(char *piece) {
    // piece might be a raw byte token, and we only want to print printable chars or whitespace
    // because some of the other bytes can be various control codes, backspace, etc.
    if (piece == NULL) { return; }
    if (piece[0] == '\0') { return; }
    if (piece[1] == '\0') {
        unsigned char byte_val = piece[0];
        if (!(isprint(byte_val) || isspace(byte_val))) {
            return; // bad byte, don't print it
        }
    }
    printf("%s", piece);
}




int str_lookup(char *str, TokenIndex *sorted_vocab, int vocab_size) {
    // efficiently find the perfect match for str in vocab, return its index or -1 if not found
    TokenIndex tok = { .str = str }; // acts as the key to search for
    TokenIndex *res = (TokenIndex*)bsearch(&tok, sorted_vocab, vocab_size, sizeof(TokenIndex), compare_tokens);
    return res != NULL ? res->id : -1;
}

void encode(Tokenizer* t, char *text, int8_t bos, int8_t eos, int *tokens, int *n_tokens) {
    // encode the string text (input) into an upper-bound preallocated tokens[] array
    // bos != 0 means prepend the BOS token (=1), eos != 0 means append the EOS token (=2)
    if (text == NULL) { fprintf(stderr, "cannot encode NULL text\n"); exit(EXIT_FAILURE); }

    if (t->sorted_vocab == NULL) {
        // lazily malloc and sort the vocabulary
        t->sorted_vocab = (TokenIndex*)malloc(t->vocab_size * sizeof(TokenIndex));
        for (int i = 0; i < t->vocab_size; i++) {
            t->sorted_vocab[i].str = t->vocab[i];
            t->sorted_vocab[i].id = i;
        }
        qsort(t->sorted_vocab, t->vocab_size, sizeof(TokenIndex), compare_tokens);
    }

    // create a temporary buffer that will store merge candidates of always two consecutive tokens
    // *2 for concat, +1 for null terminator +2 for UTF8 (in case max_token_length is 1)
    char* str_buffer = (char*)malloc((t->max_token_length*2 +1 +2) * sizeof(char));
    size_t str_len = 0;

    // start at 0 tokens
    *n_tokens = 0;

    // add optional BOS (=1) token, if desired
    if (bos)
    {
      tokens[(*n_tokens)++] = 128000;
    }



    // process the raw (UTF-8) byte sequence of the input string
    for (char *c = text; *c != '\0'; c++) {

        if ((*c & 0xC0) != 0x80) {
            // this byte must be either a leading byte (11...) or an ASCII char (0x...)
            // => reset our location, as we're starting a new UTF-8 codepoint
            str_len = 0;
        }

        // append the current byte to the buffer
        str_buffer[str_len++] = *c; // ++ is post-increment, incremented after this line
        str_buffer[str_len] = '\0';

        // while the next character is a continuation byte, continue appending
        // but if there are too many of them, just stop to avoid overruning str_buffer size.
        if ((*(c+1) & 0xC0) == 0x80 && str_len < 4) {
            continue;
        }

        // ok c+1 is not a continuation byte, so we've read in a full codepoint
        int id = str_lookup(str_buffer, t->sorted_vocab, t->vocab_size);

        if (id != -1) {
            // we found this codepoint in vocab, add it as a token
            tokens[(*n_tokens)++] = id;
        } else {

            for (int i=0; i < str_len; i++) {
                tokens[(*n_tokens)++] = (unsigned char)str_buffer[i] + 3;
            }
        }
        str_len = 0; // protect against a sequence of stray UTF8 continuation bytes
    }

    // merge the best consecutive pair each iteration, according the scores in vocab_scores
    while (1) {
        float best_score = -1e10;
        int best_id = -1;
        int best_idx = -1;
        int best_len = 2; // length of the best merge sequence (2 for pair, 3 for triple)
        for (int i=0; i < (*n_tokens-1); i++) {
            // check if we can merge the pair (tokens[i], tokens[i+1])
            sprintf(str_buffer, "%s%s", t->vocab[tokens[i]], t->vocab[tokens[i+1]]);
            int id = str_lookup(str_buffer, t->sorted_vocab, t->vocab_size);
            if (id != -1 && t->vocab_scores[id] > best_score) {
                // this merge pair exists in vocab! record its score and position
                best_score = t->vocab_scores[id];
                best_id = id;
                best_idx = i;
            }
        }


    // if no pair was found, try to find the best triple to merge
        if (best_idx == -1) {
        for (int i = 0; i < (*n_tokens - 2); i++) {
            // check if we can merge the triple (tokens[i], tokens[i+1], tokens[i+2])
            sprintf(str_buffer, "%s%s%s", t->vocab[tokens[i]], t->vocab[tokens[i + 1]], t->vocab[tokens[i + 2]]);
            int id = str_lookup(str_buffer, t->sorted_vocab, t->vocab_size);
            if (id != -1 && t->vocab_scores[id] > best_score) {
            // this merge triple exists in vocab! record its score and position
            best_score = t->vocab_scores[id];
            best_id = id;
            best_idx = i;
            best_len = 3;
            }
        }
        }
        if (best_idx == -1) {
            break; // we couldn't find any more pairs or triples to merge, so we're done
        }

        // merge the consecutive pair (best_idx, best_idx+1) into new token best_id
        tokens[best_idx] = best_id;
        // delete token at position best_idx+1, shift the entire sequence back 1
        for (int i = best_idx+1; i < (*n_tokens-1); i++) {
            tokens[i] = tokens[i+1];
        }
        (*n_tokens)--; // token length decreased
    }

    // add optional EOS (=128001) token, if desired
    if (eos)
        tokens[(*n_tokens)++] = 128001;

    free(str_buffer);
}

// ----------------------------------------------------------------------------
// The Sampler, which takes logits and returns a sampled token
// sampling can be done in a few ways: greedy argmax, sampling, top-p sampling

typedef struct {
    float prob;
    int index;
} ProbIndex; // struct used when sorting probabilities during top-p sampling

typedef struct {
    int vocab_size;
    ProbIndex* probindex; // buffer used in top-p sampling
    float temperature;
    float topp;
    unsigned long long rng_state;
} Sampler;

int sample_argmax(float* probabilities, int n) {
    // return the index that has the highest probability
    int max_i = 0;
    float max_p = probabilities[0];
    for (int i = 1; i < n; i++) {
        if (probabilities[i] > max_p) {
            max_i = i;
            max_p = probabilities[i];
        }
    }
    return max_i;
}

int sample_mult(float* probabilities, int n, float coin) {
    // sample index from probabilities (they must sum to 1!)
    // coin is a random number in [0, 1), usually from random_f32()
    float cdf = 0.0f;
    for (int i = 0; i < n; i++) {
        cdf += probabilities[i];
        if (coin < cdf) {
            return i;
        }
    }
    return n - 1; // in case of rounding errors
}

int compare(const void* a, const void* b) {
    ProbIndex* a_ = (ProbIndex*) a;
    ProbIndex* b_ = (ProbIndex*) b;
    if (a_->prob > b_->prob) return -1;
    if (a_->prob < b_->prob) return 1;
    return 0;
}

int sample_topp(float* probabilities, int n, float topp, ProbIndex* probindex, float coin) {
    // top-p sampling (or "nucleus sampling") samples from the smallest set of
    // tokens that exceed probability topp. This way we never sample tokens that
    // have very low probabilities and are less likely to go "off the rails".
    // coin is a random number in [0, 1), usually from random_f32()

    int n0 = 0;
    // quicksort indices in descending order of probabilities
    // values smaller than (1 - topp) / (n - 1) cannot be part of the result
    // so for efficiency we crop these out as candidates before sorting
    const float cutoff = (1.0f - topp) / (n - 1);
    for (int i = 0; i < n; i++) {
        if (probabilities[i] >= cutoff) {
            probindex[n0].index = i;
            probindex[n0].prob = probabilities[i];
            n0++;
        }
    }
    qsort(probindex, n0, sizeof(ProbIndex), compare);

    // truncate the list where cumulative probability exceeds topp
    float cumulative_prob = 0.0f;
    int last_idx = n0 - 1; // in case of rounding errors consider all elements
    for (int i = 0; i < n0; i++) {
        cumulative_prob += probindex[i].prob;
        if (cumulative_prob > topp) {
            last_idx = i;
            break; // we've exceeded topp by including last_idx
        }
    }

    // sample from the truncated list
    float r = coin * cumulative_prob;
    float cdf = 0.0f;
    for (int i = 0; i <= last_idx; i++) {
        cdf += probindex[i].prob;
        if (r < cdf) {
            return probindex[i].index;
        }
    }
    return probindex[last_idx].index; // in case of rounding errors
}

void build_sampler(Sampler* sampler, int vocab_size, float temperature, float topp, unsigned long long rng_seed) {
    sampler->vocab_size = vocab_size;
    sampler->temperature = temperature;
    sampler->topp = topp;
    sampler->rng_state = rng_seed;
    // buffer only used with nucleus sampling; may not need but it's ~small
    sampler->probindex = (ProbIndex*)malloc(sampler->vocab_size * sizeof(ProbIndex));
}

void free_sampler(Sampler* sampler) {
    free(sampler->probindex);
}

unsigned int random_u32(unsigned long long *state) {
    // xorshift rng: https://en.wikipedia.org/wiki/Xorshift#xorshift.2A
    *state ^= *state >> 12;
    *state ^= *state << 25;
    *state ^= *state >> 27;
    return (*state * 0x2545F4914F6CDD1Dull) >> 32;
}
float random_f32(unsigned long long *state) { // random float32 in [0,1)
    return (random_u32(state) >> 8) / 16777216.0f;
}




int sample(Sampler* sampler, float* logits) {
    // sample the token given the logits and some hyperparameters
    //printf("start sample");
    int next;
    //?????logits
    // print_top_logits(logits, sampler->vocab_size, 10);
    // system("pause");

    if (sampler->temperature == 0.0f) {
        // greedy argmax sampling: take the token with the highest probability
        next = sample_argmax(logits, sampler->vocab_size);
        // printf("Argmax token index: %d\n", next);
        // system("pause");
    } else {
        // apply the temperature to the logits
        for (int q=0; q<sampler->vocab_size; q++) { logits[q] /= sampler->temperature; }
        // apply softmax to the logits to get the probabilities for next token
        softmax(logits, sampler->vocab_size);


        // flip a (float) coin (this is our source of entropy for sampling)
        float coin = random_f32(&sampler->rng_state);
        // we sample from this distribution to get the next token
        if (sampler->topp <= 0 || sampler->topp >= 1) {
            // simply sample from the predicted probability distribution
            next = sample_mult(logits, sampler->vocab_size, coin);
        } else {
            // top-p (nucleus) sampling, clamping the least likely tokens to zero
            next = sample_topp(logits, sampler->vocab_size, sampler->topp, sampler->probindex, coin);
        }
    }
    return next;
}

// ----------------------------------------------------------------------------
// utilities: time

long time_in_ms() {
    // return time in milliseconds, for benchmarking the model speed
    struct timespec time;
    clock_gettime(CLOCK_REALTIME, &time);
    return time.tv_sec * 1000 + time.tv_nsec / 1000000;
}

// ----------------------------------------------------------------------------
// generation loop


void read_stdin(const char *guide, char *buffer, size_t bufsize) {
  // read a line from stdin, up to but not including \n
  printf("%s", guide);
  if (fgets(buffer, bufsize, stdin) != NULL) {
    size_t len = strlen(buffer);
    if (len > 0 && buffer[len - 1] == '\n') {
      buffer[len - 1] = '\0'; // strip newline
    }
  }
}

void replace_spaces_with_G(char* system_prompt_ori, char* system_prompt_dealed) {
	const char* blank_char = "Ġ"; // 2 bytes: 0xC4 0xA0 (UTF-8 representation of '?')
    int char_ptr_ori = 0;
    int char_ptr_dealed = 0;

    // Iterate through the original string
    while (system_prompt_ori[char_ptr_ori] != '\0') {
        if (system_prompt_ori[char_ptr_ori] != ' ') {
            // If it's not a space, copy the character to the new string
            system_prompt_dealed[char_ptr_dealed++] = system_prompt_ori[char_ptr_ori];
        } else {
            // If it's a space, replace it with 'Ġ' (2 bytes)
            system_prompt_dealed[char_ptr_dealed++] = blank_char[0];
            system_prompt_dealed[char_ptr_dealed++] = blank_char[1];
        }
        char_ptr_ori++;
    }
    // Null-terminate the resulting string
    system_prompt_dealed[char_ptr_dealed] = '\0';
}

// ----------------------------------------------------------------------------
// chat loop
// I manually inspected the tokens for a few chat conversations compared to
// python reference and that seemed ok, but this was not thoroughly tested and
// is not safely implemented, it's more a proof of concept atm.

int promote_to_token(Tokenizer *tokenizer, char *user_prompt, char *system_prompt,int *prompt_tokens) {

  // buffers for reading the system prompt and user prompt from stdin
  int num_prompt_tokens = 0;
  int *system_prompt_tokens = (int *)malloc(32768 * sizeof(int));
  int *user_prompt_tokens = (int *)malloc(32768 * sizeof(int));

  // ----------------- System promot ----------------------
  prompt_tokens[num_prompt_tokens++] = 151644; // "<|im_start|>"
  prompt_tokens[num_prompt_tokens++] = 8948; // "system"
  prompt_tokens[num_prompt_tokens++] = 198;   // "\n"

  char* system_prompt_dealed = (char *)malloc(32768 * sizeof(char));
  const char* blank_char="Ġ";
  // replace blank to Ġ (two bytes) Ġ = 0xC4(LSB) 0xA0(HSB)
  replace_spaces_with_G(system_prompt,system_prompt_dealed);

  int num_system_prompt_tokens=0;
  encode(tokenizer, system_prompt_dealed, 0, 0, system_prompt_tokens, &num_system_prompt_tokens);

  // copy system_prompt_tokens to prompt_tokens
  for(int ptr=0;ptr<num_system_prompt_tokens;ptr++)
  {prompt_tokens[num_prompt_tokens++]=system_prompt_tokens[ptr];}

  // end
  prompt_tokens[num_prompt_tokens++]=151645; // "<|im_end|>"
  prompt_tokens[num_prompt_tokens++] = 198;   // "\n"
 
  // ----------------- User promot ----------------------
  prompt_tokens[num_prompt_tokens++] = 151644; // "<|im_start|>"
  prompt_tokens[num_prompt_tokens++] = 872; // "user"
  prompt_tokens[num_prompt_tokens++] = 198;   // "\n"

  char *user_prompt_dealed = (char *)malloc(32768 * sizeof(char));
  replace_spaces_with_G(user_prompt,user_prompt_dealed);

  int num_user_prompt_tokens = 0;
  encode(tokenizer, user_prompt_dealed, 0, 0, user_prompt_tokens, &num_user_prompt_tokens);

  // Copy to prompt_tokens
  for (int i = 0; i < num_user_prompt_tokens; i++) {
      prompt_tokens[num_prompt_tokens++] = user_prompt_tokens[i];
  }

  // user promot end
  prompt_tokens[num_prompt_tokens++]=151645; // "<|im_end|>"
  prompt_tokens[num_prompt_tokens++]=198; // "\n"

  // assistent
  prompt_tokens[num_prompt_tokens++] = 151644; // "<|im_start|>"
  prompt_tokens[num_prompt_tokens++]=77091; // "assistant"
  prompt_tokens[num_prompt_tokens++]=198; // "\n"

  // free(string_out);
  free(system_prompt_tokens);
  free(user_prompt_tokens);
  free(system_prompt_dealed);
  free(user_prompt_dealed);

  return num_prompt_tokens;
}

//free xrt buffers
void free_existing_weights(MatmulAccelerator* accel,Config* p ) {
    auto free_array = [](xrt::bo*& ptr,  int n, int dim, int n_layers) {
        if (!ptr) return;

        delete[] ptr;
        ptr = nullptr;
    };
    int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
    free_array(accel->wq0_bo, p->dim, p->dim, p->n_layers);
    free_array(accel->wq1_bo, p->dim, p->dim, p->n_layers);
    free_array(accel->wqs_bo, p->dim, p->dim, p->n_layers);

    free_array(accel->wk0_bo, p->dim, kv_dim, p->n_layers);
    free_array(accel->wk1_bo, p->dim, kv_dim, p->n_layers);
    free_array(accel->wks_bo, p->dim, kv_dim, p->n_layers);


    free_array(accel->wv0_bo, p->dim,  kv_dim,     p->n_layers);
    free_array(accel->wv1_bo, p->dim,  kv_dim,     p->n_layers);
    free_array(accel->wvs_bo, p->dim,  kv_dim,     p->n_layers);

    // wo: [dim, dim]
    free_array(accel->wo0_bo, p->dim,     p->dim,     p->n_layers);
    free_array(accel->wo1_bo, p->dim,     p->dim,     p->n_layers);
    free_array(accel->wos_bo, p->dim,     p->dim,     p->n_layers);

    // w1: [hidden_dim, dim]
    free_array(accel->w10_bo, p->dim,  p->hidden_dim,   p->n_layers);
    free_array(accel->w11_bo, p->dim,  p->hidden_dim,   p->n_layers);
    free_array(accel->w1s_bo, p->dim,  p->hidden_dim,   p->n_layers);

    // w2: [dim, hidden_dim]
    free_array(accel->w20_bo, p->hidden_dim, p->dim,  p->n_layers);
    free_array(accel->w21_bo, p->hidden_dim, p->dim,  p->n_layers);
    free_array(accel->w2s_bo, p->hidden_dim, p->dim,  p->n_layers);

    // w3: [hidden_dim, dim]
    free_array(accel->w30_bo,  p->dim,  p->hidden_dim,   p->n_layers);
    free_array(accel->w31_bo,  p->dim,  p->hidden_dim,   p->n_layers);
    free_array(accel->w3s_bo,  p->dim,  p->hidden_dim,   p->n_layers);
}




void chat(Transformer *transformer, Tokenizer *tokenizer, Sampler *sampler, 
          char *user_prompt, char *system_prompt, 
          float *prefill_throughput, float *decode_throughput,
          int steps,const char *xclbin_path)
{
  printf("\nUser prompt: \n%s\n",user_prompt);


  
    xrt::device device(0);
    xrt::xclbin xclbin(xclbin_path);
    device.load_xclbin(xclbin);
    xrt::kernel kernel = xrt::kernel(device, xclbin.get_uuid(), "matmul");
    printf("FPGA kernel 'matmul' loaded from %s\n", xclbin_path);

 MatmulAccelerator accel;
 allocate_fpga_buffers(transformer,&accel, device, kernel,&transformer->weights,&transformer->config );

  printf("\nAnswer: \n");
  // promote string -> token numbers
  int *prompt_tokens = (int *)malloc(32768 * sizeof(int));
  int prompt_token_num=0;
  prompt_token_num=promote_to_token(tokenizer,user_prompt,system_prompt,prompt_tokens);


  // Time
  long start=0;
  long end=0;
  long prefill=0;

  // Inference loop
  int next;             // will store the next token in the sequence
  int token=prompt_tokens[0];       // stores the current token to feed into the transformer
  char* decoded_string = (char *)malloc(32768 * sizeof(char));

  int pos = 0; // position in the sequence
  int promot_idx = 0;
  while (pos < steps) 
  {

    if (start == 0) {start = time_in_ms();}

    float *logits = forward(transformer, token, pos, true, kernel, &accel, device);

    if(pos<prompt_token_num-1)
    {
      next=prompt_tokens[pos+1];
    } 
    else
    {
      next = sample(sampler, logits);
      
    }

    pos++;

    if (pos>steps)
      break;


    // Show decoded string
    if(pos>=prompt_token_num)
    {
      // End  <|endoftext|> 
      if(next==151645)
      {
        printf("\n");
        break;
      }

      decode(tokenizer, next, decoded_string);
      safe_printf(decoded_string);

      fflush(stdout);
    }

    if(pos==prompt_token_num)
    {
      // prefill end
      prefill=time_in_ms()-start;
      start=0;
    }

    token = next;
  }

  if (pos > 1) {
    long end = time_in_ms();
    *prefill_throughput = prompt_token_num / (double)(prefill) * 1000;
    *decode_throughput= (pos - prompt_token_num) / (double)(end - start) * 1000;
    fprintf(stderr, "achieved prefill tok/s: %f\n", *prefill_throughput);
    fprintf(stderr, "achieved decode tok/s: %f\n", *decode_throughput);
  }

  free(prompt_tokens);
  free(decoded_string);
  free_existing_weights(&accel,&transformer->config );
}



void chat_without_encode_decode(Transformer *transformer, Sampler *sampler, 
                                int *prompt_tokens,int prompt_token_num,
                                int *gen ,int *gen_token_num ,
                                bool show_print,int steps,const char *xclbin_path)
{

   
    xrt::device device(0);
    xrt::xclbin xclbin(xclbin_path);
    device.load_xclbin(xclbin);
    xrt::kernel kernel = xrt::kernel(device, xclbin.get_uuid(), "matmul");
    printf("FPGA kernel 'matmul' loaded from %s\n", xclbin_path);

    MatmulAccelerator accel;
    allocate_fpga_buffers(transformer, &accel, device, kernel,&transformer->weights,&transformer->config );

  // Inference loop
  int next;             // will store the next token in the sequence
  int token=prompt_tokens[0];       // stores the current token to feed into the transformer

  int gen_ptr=0;
  // gen[gen_ptr++]=prompt_tokens[0];

  long start=0;
  long prefill=0;

  int pos = 0; // position in the sequence
  int promot_idx = 0;
  while (pos < steps) 
  {
    if (start == 0) {start = time_in_ms();}

    float *logits = forward(transformer, token, pos, true, kernel, &accel, device);

    if(pos<prompt_token_num-1)
    {
      next=prompt_tokens[pos+1];
    } 
    else
    {
      next = sample(sampler, logits);
    }

    pos++;

    // End
    if (pos>=steps){
      printf("overstep!");
      break;
    }

    // Show decoded string
    if(pos>=prompt_token_num)
    {
      gen[gen_ptr++]=next;

      // End  <|endoftext|> 
      if(next==151645)
      {
        //printf("blankspace\n");
        break;
      }
    }

    if(pos==prompt_token_num)
    {
      // prefill end
      prefill=time_in_ms()-start;
      start=0;
    }
    
    //printf("pos:%d, token:%d, next:%d\n", pos, token, next);
    token = next;
  }

  if (pos > 1) {
    long end = time_in_ms();
    if(show_print)
    {
      fprintf(stderr, "achieved prefill tok/s: %f\n", prompt_token_num / (double)(prefill) * 1000);
      fprintf(stderr, "achieved decode tok/s: %f\n", (pos - prompt_token_num) / (double)(end - start) * 1000);
    }
  }

  free_existing_weights(&accel,&transformer->config );
  *gen_token_num=gen_ptr; /
}





// int main(int argc, char *argv[]) {
//   // default parameters
//   char *checkpoint_path = QWEN_BIN_MODEL_PATH; // e.g. out/model.bin
//   char *tokenizer_path = QWEN_BIN_TOKEN_PATH;
//   char *xclbin_path = XCLBIN_PATH;
//   // float temperature = 1.0f;        // 0.0 = greedy deterministic. 1.0 = original. don't set higher
//   float temperature = 0.0f;        // 0.0 = greedy deterministic. 1.0 = original. don't set higher
//   float topp = 0.9f;               // top-p in nucleus sampling. 1.0 = off. 0.9 works well, but slower
//   int steps = 600;                // number of steps to run for
//   char *prompt = (argc > 1) ? argv[1] : "Introduce the car including its history.";
//   unsigned long long rng_seed = 0; // seed rng with time by default
//   char *system_prompt = "You are Qwen, created by Alibaba Cloud. You are a helpful assistant.";      // the (optional) system prompt to use in chat mode

//   // parameter validation/overrides
//   if (rng_seed <= 0)
//     rng_seed = (unsigned int)time(NULL);
//   if (temperature < 0.0)
//     temperature = 0.0;
//   if (topp < 0.0 || 1.0 < topp)
//     topp = 0.9;
//   if (steps < 0)
//     steps = 0;

//   // build the Transformer via the model .bin file
//   Transformer transformer;
//   build_transformer(&transformer, checkpoint_path);
//   if (steps == 0 || steps > transformer.config.seq_len)
//     steps = transformer.config.seq_len; // override to ~max length

//   // build the Tokenizer via the tokenizer .bin file
//   Tokenizer tokenizer;
//   build_tokenizer(&tokenizer, tokenizer_path, transformer.config.vocab_size);

//   // build the Sampler
//   Sampler sampler;
//   build_sampler(&sampler, transformer.config.vocab_size, temperature, topp, rng_seed);

//   float *prefill_throughput;
//   float *decode_throughput;
//   chat(&transformer,&tokenizer,&sampler, 
//         prompt, system_prompt, 
//         prefill_throughput,decode_throughput,
//         steps,xclbin_path);
   
//   // memory and file handles cleanup
//   free_sampler(&sampler);
//   free_tokenizer(&tokenizer);
//   free_transformer(&transformer);
//   return 0;
// }



extern "C"  void run_with_encode_decode(char *prompt,
                            float *prefill_throughput, float *decode_throughput,
                            int max_steps)
{
  // default parameters
  const char *checkpoint_path = QWEN_BIN_MODEL_PATH; // e.g. out/model.bin
  const char *tokenizer_path = QWEN_BIN_TOKEN_PATH;
  const char *xclbin_path = XCLBIN_PATH;
  // float temperature = 1.0f;        // 0.0 = greedy deterministic. 1.0 = original. don't set higher
  float temperature = 0.0f;        // 0.0 = greedy deterministic. 1.0 = original. don't set higher
  float topp = 0.9f;               // top-p in nucleus sampling. 1.0 = off. 0.9 works well, but slower
  unsigned long long rng_seed = 0; // seed rng with time by default
  int steps=max_steps;
  char *system_prompt = "You are Qwen, created by Alibaba Cloud. You are a helpful assistant.";      // the (optional) system prompt to use in chat mode

  // parameter validation/overrides
  if (rng_seed <= 0)
    rng_seed = (unsigned int)time(NULL);
  if (temperature < 0.0)
    temperature = 0.0;
  if (topp < 0.0 || 1.0 < topp)
    topp = 0.9;
  if (steps < 0)
    steps = 0;

  // build the Transformer via the model .bin file
  Transformer transformer;
  build_transformer(&transformer, checkpoint_path);
  if (steps == 0 || steps > transformer.config.seq_len)
    steps = transformer.config.seq_len; // override to ~max length

  // build the Tokenizer via the tokenizer .bin file
  Tokenizer tokenizer;
  build_tokenizer(&tokenizer, tokenizer_path, transformer.config.vocab_size);

  // build the Sampler
  Sampler sampler;
  build_sampler(&sampler, transformer.config.vocab_size, temperature, topp, rng_seed);


  chat(&transformer,&tokenizer,&sampler, 
        prompt, system_prompt, 
        prefill_throughput,decode_throughput,
        max_steps, xclbin_path);
  
  // memory and file handles cleanup
  free_sampler(&sampler);
  free_tokenizer(&tokenizer);
  free_transformer(&transformer);
}





extern "C"  void run_without_encode_decode(int *prompt_tokens,int prompt_token_num,
                              int *gen,int *gen_token_num,
                              bool show_print,int max_steps)
{
   printf("prompt_token_num=%d\n",prompt_token_num);
  const char *checkpoint_path = QWEN_BIN_MODEL_PATH; // e.g. out/model.bin
  const char *tokenizer_path = QWEN_BIN_TOKEN_PATH;
  const char *xclbin_path = XCLBIN_PATH;

  float temperature = 0.0f;        // 0.0 = greedy deterministic. 1.0 = original. don't set higher
  float topp = 0.9f;               // top-p in nucleus sampling. 1.0 = off. 0.9 works well, but slower
  int steps = max_steps;                // number of steps to run for
  unsigned long long rng_seed = 0; // seed rng with time by default

  // parameter validation/overrides
  if (rng_seed <= 0)
    rng_seed = (unsigned int)time(NULL);
  if (temperature < 0.0)
    temperature = 0.0;
  if (topp < 0.0 || 1.0 < topp)
    topp = 0.9;
  if (steps < 0)
    steps = 0;

  // build the Transformer via the model .bin file
  Transformer transformer;
  build_transformer(&transformer,checkpoint_path);
  if (steps == 0 || steps > transformer.config.seq_len)
    steps = transformer.config.seq_len; // override to ~max length

  // build the Sampler
  Sampler sampler;
  build_sampler(&sampler, transformer.config.vocab_size, temperature, topp, rng_seed);
  chat_without_encode_decode(&transformer,&sampler, 
                                      prompt_tokens,prompt_token_num,gen,gen_token_num,
                                      show_print,steps, xclbin_path);
  
  // memory and file handles cleanup
  free_sampler(&sampler);
  free_transformer(&transformer);
}