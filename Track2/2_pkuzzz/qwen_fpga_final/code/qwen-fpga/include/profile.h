#ifndef _PROFILE_H
#define _PROFILE_H

#include <stdbool.h>
#include <time.h>
#include <assert.h>

#define MAX_SEGMENTS 200

typedef struct
{
    bool valid;
    long long start_time;
    long long end_time;
    long long duration;
    int idx_ref;
    const char *name;
} profile_segment_t;

typedef struct
{
    profile_segment_t segments[MAX_SEGMENTS];
} profile_states_t;

enum SegmentID {
    GEMV_INIT,
    GEMV_BO_SYNC_A,
    GEMV_BO_SYNC_W,
    GEMV_BO_SYNC_R,
    GEMV_SET_ARGS,
    GEMV_RUN_START,
    GEMV_RUN_WAIT,

    GEMM_INIT,
    GEMM_BO_SYNC_A,
    GEMM_BO_SYNC_W,
    GEMM_BO_SYNC_R,
    GEMM_SET_ARGS,
    GEMM_RUN_START,
    GEMM_RUN_WAIT,

    XRT_PTR_TO_BO,
    XRT_BO_SUB_ALLOC,

    PREFILL_MEMCPY_EMBED,
    PREFILL_FINAL_LOGITS,
    
    // MHA Prefill Operators
    MHA_PREFILL,
    MHA_PREFILL_RMSNORM,
    MHA_PREFILL_ROPE,
    MHA_PREFILL_ATTN,
    MHA_PREFILL_GEMM_Q,
    MHA_PREFILL_GEMM_K,
    MHA_PREFILL_GEMM_V,
    MHA_PREFILL_GEMM_O,
    MHA_PREFILL_ADD_BIAS,
    MHA_PREFILL_ADD_RESIDUAL,
    MHA_PREFILL_ACT_QUANT,
    MHA_PREFILL_ACT_DEQUANT,

    // MLP Prefill Operators
    MLP_PREFILL,
    MLP_PREFILL_RMSNORM,
    MLP_PREFILL_GEMM_W1,
    MLP_PREFILL_GEMM_W3,
    MLP_PREFILL_GEMM_W2,
    MLP_PREFILL_QUANT_W1_W3,
    MLP_PREFILL_QUANT_W2,
    MLP_PREFILL_DEQUANT_W1,
    MLP_PREFILL_DEQUANT_W3,
    MLP_PREFILL_DEQUANT_W2,
    MLP_PREFILL_SWIGLU,
    MLP_PREFILL_ADD_RESIDUAL,
    MLP_PREFILL_W1D_W3_SWIGLU,
    // MLP_PREFILL_DEQUANT_W1_W3_SWIGLU,

    // MHA Decode Operators
    MHA_DECODE,
    MHA_DECODE_RMSNORM,
    MHA_DECODE_ROPE,
    MHA_DECODE_ATTN,
    MHA_DECODE_GEMV_Q,
    MHA_DECODE_GEMV_K,
    MHA_DECODE_GEMV_V,
    MHA_DECODE_GEMV_O,
    MHA_DECODE_ADD_BIAS,
    MHA_DECODE_ADD_RESIDUAL,
    MHA_DECODE_ACT_QUANT,
    MHA_DECODE_ACT_DEQUANT,

    // MLP Decoce Operators
    MLP_DECODE,
    MLP_DECODE_RMSNORM,
    MLP_DECODE_GEMV_W1,
    MLP_DECODE_GEMV_W3,
    MLP_DECODE_GEMV_W2,
    MLP_DECODE_QUANT_W1_W3,
    MLP_DECODE_QUANT_W2,
    MLP_DECODE_DEQUANT_W1,
    MLP_DECODE_DEQUANT_W3,
    MLP_DECODE_DEQUANT_W2,
    MLP_DECODE_SWIGLU,
    MLP_DECODE_ADD_RESIDUAL,
    MLP_DECODE_W1D_W3_SWIGLU,

    // token attn
    TOKEN_ATTN,
    TOKEN_ATTN_QKMATMUL,
    TOKEN_ATTN_PVMATMUL,
    TOKEN_ATTN_SOFTMAX,

    // flash attention
    FLASH_ATTN,
    FLASH_ATTN_INIT_BUFFER,
    FLASH_ATTN_MATMUL_QK,
    FLASH_ATTN_UPDATE_ML,
    FLASH_ATTN_MATMUL_PV,
    FLASH_ATTN_UPDATE_O,
    FLASH_ATTN_COPY_O,

    PREFILL,
    DECODE,

    // GEMM & GEMV operations
    OP_QUANTIZE_PREFILL_RESHAPE,
    OP_QUANTIZE_DECODE_RESHAPE,
    OP_DEQUANTIZE_PREFILL_RESHAPE,
    OP_DEQUANTIZE_DECODE_RESHAPE,
    OP_GEMM,
    OP_GEMV,
};


void init_profile();

void start_segment(int idx);

void end_segment(int idx);

void name_segment(int idx, const char* name);

void set_reference(int idx, int idx_ref);

void display_profile();

#endif // _PROFILE_H