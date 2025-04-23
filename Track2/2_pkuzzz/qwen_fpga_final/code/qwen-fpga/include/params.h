#ifndef _PARAMS_H
#define _PARAMS_H

#define MAX_XRT_BUFFER_NUM 256

#define WO_GRID_PER_BUF 16
#define WO_ELEM_PER_GRID 8
#ifndef WI_GRID_PER_BUF
#define WI_GRID_PER_BUF 8
#endif
#ifndef WI_ELEM_PER_GRID
#define WI_ELEM_PER_GRID 8
#endif

#define PREFILL_GRID_PER_BUF 8
#define PREFILL_ELEM_PER_GRID 8
#define DECODE_GRID_PER_BUF 1
#define DECODE_ELEM_PER_GRID 1

#define ACTIVE_BO_SIZE (PREFILL_GRID_PER_BUF * PREFILL_ELEM_PER_GRID * WI_GRID_PER_BUF * WI_ELEM_PER_GRID * sizeof(int8_t))
#define WEIGHT_BO_SIZE (WO_GRID_PER_BUF * WO_ELEM_PER_GRID * WI_GRID_PER_BUF * WI_ELEM_PER_GRID * sizeof(int8_t) / 2)
#define RESULT_BO_SIZE (PREFILL_GRID_PER_BUF * PREFILL_ELEM_PER_GRID * WO_GRID_PER_BUF * WO_ELEM_PER_GRID * sizeof(int32_t))
#define D_ACTIVE_BO_SIZE (DECODE_GRID_PER_BUF * DECODE_ELEM_PER_GRID * WI_GRID_PER_BUF * WI_ELEM_PER_GRID * sizeof(int8_t))
#define D_WEIGHT_BO_SIZE (WO_GRID_PER_BUF * WO_ELEM_PER_GRID * WI_GRID_PER_BUF * WI_ELEM_PER_GRID * sizeof(int8_t) / 2)
#define D_RESULT_BO_SIZE (DECODE_GRID_PER_BUF * DECODE_ELEM_PER_GRID * WO_GRID_PER_BUF * WO_ELEM_PER_GRID * sizeof(int32_t))

#define MAX_SEQ_LEN 4096
#define HEAD_SIZE 64

#define NHEAD_PER_QPROJ 2  // make sure (n_head * head_size) % (WO_GRID_PER_BUF * WO_ELEM_PER_GRID) == 0
#define NHEAD_PER_W1PROJ 38 

// Flash attention parameters
#define FLASH_ATTENTION
#define FA_Q_BLOCK_SIZE 32
#define FA_K_BLOCK_SIZE 32
#define ENABLE_PREFILL_STREAMING  // Make sure Q/K block size is equal
// #define STREAMING_PERFECT_DIAGONAL  // huge impact on accuracy, probably buggy

// Exp. Approximation
#define FAST_EXP_11F
#define FAST_SIGMOID_STACKOVERFLOW

// RoPE Precomputation
#define ROPE_PRECOMPUTE

#ifndef XCLBIN_PATH
#define XCLBIN_PATH "w4a8_infer_v2.xclbin"
#endif
#ifndef GEMM_KERNEL_NAME
#define GEMM_KERNEL_NAME "w4a8_gemm"
#endif
#ifndef GEMV_KERNEL_NAME
#define GEMV_KERNEL_NAME "w4a8_gemv"
#endif

#endif // _PARAMS_H