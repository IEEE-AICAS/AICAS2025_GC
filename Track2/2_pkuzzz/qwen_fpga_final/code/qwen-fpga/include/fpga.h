#ifndef _FPGA_H
#define _FPGA_H

#include <stdint.h>

void fpga_gemv_w4a8(
    uint32_t C_N, uint32_t C_K,
    const int8_t *xq_vec, const int8_t *wq_mat, int32_t *cq_vec);

void fpga_gemm_w4a8(
    uint32_t C_M, uint32_t C_N, uint32_t C_K,
    const int8_t *aq_mat, const int8_t *bq_mat, int32_t *cq_mat);

void fpga_gemv_w4a8_start(
    uint32_t C_N, uint32_t C_K,
    const int8_t *xq_vec, const int8_t *wq_mat, int32_t *cq_vec);

void fpga_gemm_w4a8_start(
    uint32_t C_M, uint32_t C_N, uint32_t C_K,
    const int8_t *aq_mat, const int8_t *bq_mat, int32_t *cq_mat);

void fpga_gemv_w4a8_wait(uint32_t C_N, int32_t *cq_vec);

void fpga_gemm_w4a8_wait(uint32_t C_M, uint32_t C_N, int32_t *cq_mat);

void fpga_copy_quantized_weight(void **ptr, int8_t *q, size_t size);

#endif // _FPGA_H