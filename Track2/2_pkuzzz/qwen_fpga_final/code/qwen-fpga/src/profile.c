#include "profile.h"
#include <stdio.h>
#include <sys/resource.h>

profile_states_t profile_states;

void init_profile()
{
#ifdef PROFILE
    for (int i = 0; i < MAX_SEGMENTS; i++)
    {
        profile_segment_t *s = &profile_states.segments[i];
        s->valid = 0;
        s->start_time = 0;
        s->end_time = 0;
        s->duration = 0.0;
        s->idx_ref = -1;
        s->name = NULL;
    }

    name_segment(GEMV_INIT, "gemv_init");
    name_segment(GEMV_BO_SYNC_A, "gemv_bo_sync_a");
    name_segment(GEMV_BO_SYNC_W, "gemv_bo_sync_w");
    name_segment(GEMV_SET_ARGS, "gemv_set_args");
    name_segment(GEMV_RUN_START, "gemv_run_start");
    name_segment(GEMV_RUN_WAIT, "gemv_run_wait");
    name_segment(GEMV_BO_SYNC_R, "gemv_bo_sync_r");
    name_segment(GEMM_INIT, "gemm_init");
    name_segment(GEMM_BO_SYNC_A, "gemm_bo_sync_a");
    name_segment(GEMM_BO_SYNC_W, "gemm_bo_sync_w");
    name_segment(GEMM_SET_ARGS, "gemm_set_args");
    name_segment(GEMM_RUN_START, "gemm_run_start");
    name_segment(GEMM_RUN_WAIT, "gemm_run_wait");
    name_segment(GEMM_BO_SYNC_R, "gemm_bo_sync_r");
    name_segment(XRT_PTR_TO_BO, "xrt_ptr_to_bo");
    name_segment(XRT_BO_SUB_ALLOC, "xrt_bo_sub_alloc");
    name_segment(MHA_DECODE_ATTN, "mha_decode_attn");
    name_segment(PREFILL, "prefill");
    name_segment(DECODE, "decode");
    name_segment(PREFILL_MEMCPY_EMBED, "prefill_memcpy_embed");
    name_segment(PREFILL_FINAL_LOGITS, "prefill_final_logits");

    // MHA Prefill Operators
    name_segment(MHA_PREFILL, "mha_prefill");
    name_segment(MHA_PREFILL_RMSNORM, "mha_prefill_rmsnorm");
    name_segment(MHA_PREFILL_ROPE, "mha_prefill_rope");
    name_segment(MHA_PREFILL_ATTN, "mha_prefill_attn");
    name_segment(MHA_PREFILL_GEMM_Q, "mha_prefill_gemm_q");
    name_segment(MHA_PREFILL_GEMM_K, "mha_prefill_gemm_k");
    name_segment(MHA_PREFILL_GEMM_V, "mha_prefill_gemm_v");
    name_segment(MHA_PREFILL_GEMM_O, "mha_prefill_gemm_o");
    name_segment(MHA_PREFILL_ADD_BIAS, "mha_prefill_add_bias");
    name_segment(MHA_PREFILL_ADD_RESIDUAL, "mha_prefill_add_residual");
    name_segment(MHA_PREFILL_ACT_QUANT, "mha_prefill_act_quant");
    name_segment(MHA_PREFILL_ACT_DEQUANT, "mha_prefill_act_dequant");

    set_reference(MHA_PREFILL_RMSNORM, MHA_PREFILL);
    set_reference(MHA_PREFILL_ROPE, MHA_PREFILL);
    set_reference(MHA_PREFILL_ATTN, MHA_PREFILL);
    set_reference(MHA_PREFILL_GEMM_Q, MHA_PREFILL);
    set_reference(MHA_PREFILL_GEMM_K, MHA_PREFILL);
    set_reference(MHA_PREFILL_GEMM_V, MHA_PREFILL);
    set_reference(MHA_PREFILL_GEMM_O, MHA_PREFILL);
    set_reference(MHA_PREFILL_ADD_BIAS, MHA_PREFILL);
    set_reference(MHA_PREFILL_ADD_RESIDUAL, MHA_PREFILL);
    set_reference(MHA_PREFILL_ACT_QUANT, MHA_PREFILL);
    set_reference(MHA_PREFILL_ACT_DEQUANT, MHA_PREFILL);

    // MLP Prefill Operators
    name_segment(MLP_PREFILL, "mlp_prefill");
    name_segment(MLP_PREFILL_RMSNORM, "mlp_prefill_rmsnorm");
    name_segment(MLP_PREFILL_GEMM_W1, "mlp_prefill_gemm_w1");
    name_segment(MLP_PREFILL_GEMM_W3, "mlp_prefill_gemm_w3");
    name_segment(MLP_PREFILL_GEMM_W2, "mlp_prefill_gemm_w2");
    name_segment(MLP_PREFILL_QUANT_W1_W3, "mlp_prefill_quant_w1_w3");
    name_segment(MLP_PREFILL_QUANT_W2, "mlp_prefill_quant_w2");
    name_segment(MLP_PREFILL_DEQUANT_W1, "mlp_prefill_dequant_w1");
    name_segment(MLP_PREFILL_DEQUANT_W3, "mlp_prefill_dequant_w3");
    name_segment(MLP_PREFILL_DEQUANT_W2, "mlp_prefill_dequant_w2");
    name_segment(MLP_PREFILL_SWIGLU, "mlp_prefill_swiglu");
    name_segment(MLP_PREFILL_ADD_RESIDUAL, "mlp_prefill_add_residual");
    name_segment(MLP_PREFILL_W1D_W3_SWIGLU, "mlp_prefill_w1d_w3_swiglu");
    // name_segment(MLP_PREFILL_DEQUANT_W1_W3_SWIGLU, "mlp_prefill_dequant_w1_w3_swiglu");

    set_reference(MLP_PREFILL_RMSNORM, MLP_PREFILL);
    set_reference(MLP_PREFILL_GEMM_W1, MLP_PREFILL);
    set_reference(MLP_PREFILL_GEMM_W3, MLP_PREFILL);
    set_reference(MLP_PREFILL_GEMM_W2, MLP_PREFILL);
    set_reference(MLP_PREFILL_QUANT_W1_W3, MLP_PREFILL);
    set_reference(MLP_PREFILL_QUANT_W2, MLP_PREFILL);
    set_reference(MLP_PREFILL_DEQUANT_W1, MLP_PREFILL);
    set_reference(MLP_PREFILL_DEQUANT_W3, MLP_PREFILL);
    set_reference(MLP_PREFILL_DEQUANT_W2, MLP_PREFILL);
    set_reference(MLP_PREFILL_SWIGLU, MLP_PREFILL);
    set_reference(MLP_PREFILL_ADD_RESIDUAL, MLP_PREFILL);
    set_reference(MLP_PREFILL_W1D_W3_SWIGLU, MLP_PREFILL);
    // set_reference(MLP_PREFILL_DEQUANT_W1_W3_SWIGLU, MLP_PREFILL);

    set_reference(MHA_PREFILL, PREFILL);
    set_reference(MLP_PREFILL, PREFILL);

    // MHA Decode Operators
    name_segment(MHA_DECODE, "mha_decode");
    name_segment(MHA_DECODE_RMSNORM, "mha_decode_rmsnorm");
    name_segment(MHA_DECODE_ROPE, "mha_decode_rope");
    name_segment(MHA_DECODE_ATTN, "mha_decode_attn");
    name_segment(MHA_DECODE_GEMV_Q, "mha_decode_gemv_q");
    name_segment(MHA_DECODE_GEMV_K, "mha_decode_gemv_k");
    name_segment(MHA_DECODE_GEMV_V, "mha_decode_gemv_v");
    name_segment(MHA_DECODE_GEMV_O, "mha_decode_gemv_o");
    name_segment(MHA_DECODE_ADD_BIAS, "mha_decode_add_bias");
    name_segment(MHA_DECODE_ADD_RESIDUAL, "mha_decode_add_residual");
    name_segment(MHA_DECODE_ACT_QUANT, "mha_decode_act_quant");
    name_segment(MHA_DECODE_ACT_DEQUANT, "mha_decode_act_dequant");

    set_reference(MHA_DECODE_RMSNORM, MHA_DECODE);
    set_reference(MHA_DECODE_ROPE, MHA_DECODE);
    set_reference(MHA_DECODE_ATTN, MHA_DECODE);
    set_reference(MHA_DECODE_GEMV_Q, MHA_DECODE);
    set_reference(MHA_DECODE_GEMV_K, MHA_DECODE);
    set_reference(MHA_DECODE_GEMV_V, MHA_DECODE);
    set_reference(MHA_DECODE_GEMV_O, MHA_DECODE);
    set_reference(MHA_DECODE_ADD_BIAS, MHA_DECODE);
    set_reference(MHA_DECODE_ADD_RESIDUAL, MHA_DECODE);
    set_reference(MHA_DECODE_ACT_QUANT, MHA_DECODE);
    set_reference(MHA_DECODE_ACT_DEQUANT, MHA_DECODE);

    // MLP Decode Operators
    name_segment(MLP_DECODE, "mlp_decode");
    name_segment(MLP_DECODE_RMSNORM, "mlp_decode_rmsnorm");
    name_segment(MLP_DECODE_GEMV_W1, "mlp_decode_gemv_w1");
    name_segment(MLP_DECODE_GEMV_W3, "mlp_decode_gemv_w3");
    name_segment(MLP_DECODE_GEMV_W2, "mlp_decode_gemv_w2");
    name_segment(MLP_DECODE_QUANT_W1_W3, "mlp_decode_quant_w1_w3");
    name_segment(MLP_DECODE_QUANT_W2, "mlp_decode_quant_w2");
    name_segment(MLP_DECODE_DEQUANT_W1, "mlp_decode_dequant_w1");
    name_segment(MLP_DECODE_DEQUANT_W3, "mlp_decode_dequant_w3");
    name_segment(MLP_DECODE_DEQUANT_W2, "mlp_decode_dequant_w2");
    name_segment(MLP_DECODE_SWIGLU, "mlp_decode_swiglu");
    name_segment(MLP_DECODE_ADD_RESIDUAL, "mlp_decode_add_residual");
    name_segment(MLP_DECODE_W1D_W3_SWIGLU, "mlp_decode_w1d_w3_swiglu");
    // name_segment(MLP_DECODE_DEQUANT_W1_W3_SWIGLU, "mlp_decode_dequant_w1_w3_swiglu");

    set_reference(MLP_DECODE_RMSNORM, MLP_DECODE);
    set_reference(MLP_DECODE_GEMV_W1, MLP_DECODE);
    set_reference(MLP_DECODE_GEMV_W3, MLP_DECODE);
    set_reference(MLP_DECODE_GEMV_W2, MLP_DECODE);
    set_reference(MLP_DECODE_QUANT_W1_W3, MLP_DECODE);
    set_reference(MLP_DECODE_QUANT_W2, MLP_DECODE);
    set_reference(MLP_DECODE_DEQUANT_W1, MLP_DECODE);
    set_reference(MLP_DECODE_DEQUANT_W3, MLP_DECODE);
    set_reference(MLP_DECODE_DEQUANT_W2, MLP_DECODE);
    set_reference(MLP_DECODE_SWIGLU, MLP_DECODE);
    set_reference(MLP_DECODE_ADD_RESIDUAL, MLP_DECODE);
    set_reference(MLP_DECODE_W1D_W3_SWIGLU, MLP_DECODE);
    // set_reference(MLP_DECODE_DEQUANT_W1_W3_SWIGLU, MLP_DECODE);

    // Token attn operators
    name_segment(TOKEN_ATTN, "token_attn");
    name_segment(TOKEN_ATTN_QKMATMUL, "token_attn_qkmatmul");
    name_segment(TOKEN_ATTN_PVMATMUL, "token_attn_pvmatmul");
    name_segment(TOKEN_ATTN_SOFTMAX, "token_attn_softmax");
    
    set_reference(TOKEN_ATTN_QKMATMUL, TOKEN_ATTN);
    set_reference(TOKEN_ATTN_PVMATMUL, TOKEN_ATTN);
    set_reference(TOKEN_ATTN_SOFTMAX, TOKEN_ATTN);

    // flash attention operators
    name_segment(FLASH_ATTN, "flash_attn");
    name_segment(FLASH_ATTN_INIT_BUFFER, "flash_attn_init_buffer");
    name_segment(FLASH_ATTN_MATMUL_QK, "flash_attn_matmul_qk");
    name_segment(FLASH_ATTN_UPDATE_ML, "flash_attn_update_ml");
    name_segment(FLASH_ATTN_MATMUL_PV, "flash_attn_matmul_pv");
    name_segment(FLASH_ATTN_UPDATE_O, "flash_attn_update_o");
    name_segment(FLASH_ATTN_COPY_O, "flash_attn_copy_o");

    set_reference(FLASH_ATTN_INIT_BUFFER, FLASH_ATTN);
    set_reference(FLASH_ATTN_MATMUL_QK, FLASH_ATTN);
    set_reference(FLASH_ATTN_UPDATE_ML, FLASH_ATTN);
    set_reference(FLASH_ATTN_MATMUL_PV, FLASH_ATTN);
    set_reference(FLASH_ATTN_UPDATE_O, FLASH_ATTN);
    set_reference(FLASH_ATTN_COPY_O, FLASH_ATTN);

    set_reference(MHA_DECODE, DECODE);
    set_reference(MLP_DECODE, DECODE);

    // operators
    name_segment(OP_QUANTIZE_PREFILL_RESHAPE,"OP_QUANTIZE_PREFILL_RESHAPE");
    name_segment(OP_QUANTIZE_DECODE_RESHAPE,"OP_QUANTIZE_DECODE_RESHAPE");
    name_segment(OP_DEQUANTIZE_PREFILL_RESHAPE,"OP_DEQUANTIZE_PREFILL_RESHAPE");
    name_segment(OP_DEQUANTIZE_DECODE_RESHAPE,"OP_DEQUANTIZE_DECODE_RESHAPE");
    name_segment(OP_GEMM,"OP_GEMM");
    name_segment(OP_GEMV,"OP_GEMV");
#endif
}

long long time_in_ns()
{
    // return time in milliseconds, for benchmarking the model speed
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC, &time);
    return time.tv_sec * 1000000000LL + time.tv_nsec;
}

void start_segment(int idx)
{
#ifdef PROFILE
    assert(idx < MAX_SEGMENTS);
    profile_segment_t *s = &profile_states.segments[idx];
    s->valid = 1;
    s->start_time = time_in_ns();
#endif
}

void end_segment(int idx)
{
#ifdef PROFILE
    assert(idx < MAX_SEGMENTS);
    profile_segment_t *s = &profile_states.segments[idx];
    // assert(s->valid);  // multi-thread profiling is not accurate!
    s->valid = 0;
    s->end_time = time_in_ns();
    s->duration += s->end_time - s->start_time;
#endif
}

void name_segment(int idx, const char *name)
{
#ifdef PROFILE
    assert(idx < MAX_SEGMENTS);
    profile_segment_t *s = &profile_states.segments[idx];
    s->name = name;
#endif
}

void set_reference(int idx, int idx_ref)
{
#ifdef PROFILE
    assert(idx < MAX_SEGMENTS);
    assert(idx_ref < MAX_SEGMENTS);
    profile_segment_t *s = &profile_states.segments[idx];
    s->idx_ref = idx_ref;
#endif
}

void display_profile()
{
#ifdef PROFILE
    printf("Performance Profiling Summary:\n");
    printf("-----------------\n");

    for (int i = 0; i < MAX_SEGMENTS; i++)
    {
        profile_segment_t *s = &profile_states.segments[i];
        if (s->name == NULL)
            continue;

        printf("Segment: %s\n", s->name);
        printf("  Duration: %20lld ns\n", s->duration);
        if (s->idx_ref >= 0)
        {
            profile_segment_t *s_ref = &profile_states.segments[s->idx_ref];
            const float ratio = (float)s->duration / (float)s_ref->duration;
            printf("  Ratio (%s): %.2f%%\n", s_ref->name, ratio * 100);
        }
        printf("-----------------\n");
    }
#endif
}