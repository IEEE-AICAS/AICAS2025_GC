#ifndef _CPU_H
#define _CPU_H

#include <stdint.h>
#include "model.h"

typedef void (*set_fn_t)(int8_t *arr, int index, int8_t value);

typedef int8_t (*get_fn_t)(const int8_t *arr, int index);

void quantize_prefill_reshape(
    QuantizedTensor *qx, const float *x, int seq_len, int dim);

void quantize_decode_reshape(
    QuantizedTensor *qx, const float *x, int dim);

void dequantize_prefill_reshape(
    float *c_mat, const const float *as, const float *bs, const int32_t *cq_mat,
    int seq_len, int dim);

void dequantize_decode_reshape(
    float *c_vec, const const float *as, const float *bs, const int32_t *cq_vec,
    int dim);

void dequantize_embedding_reshape(
    const QuantizedTensor *qw, float *w, int vocab_size, int dim);

void dequantize_prefill_reshape_swiglu(
    float *c_mat,
    const const float *a1s, const float *b1s, const int32_t *c1q_mat,
    const const float *a2s, const float *b2s, const int32_t *c2q_mat,
    int seq_len, int dim);

void dequantize_decode_reshape_swiglu(
    float *c_vec,
    const const float *a1s, const float *b1s, const int32_t *c1q_vec,
    const const float *a2s, const float *b2s, const int32_t *c2q_vec,
    int dim);

float fast_exp(float x);

float fast_exp_11f(float x);

float fast_exp_21f(float x);

float fast_sigmoid(float x);

float fast_sigmoid_stackoverflow(float x);

void rmsnorm(float *o, float *x, float *weight, int size);

void softmax(float *x, int size);

void softmax_casual(float *x, int prompt_token_num);

void softmax_casual_triangle(float *att, int prompt_token_num);

void elementwise_add(float *x, float *y, int size);

void init_rope(int head_size);

void rope(float *q, float *k, int dim, int head_size, int n_kv_heads, int pos);

void rope_head(float *head, int head_size, int n_heads, int pos);

void swiglu(float *hb, float *hb2, int hidden_dim);

void silu(float *hb, int hidden_dim);

void elementwise_mul(float *x, float *y, int size);

void cpu_map_quantized_weight(void **ptr, int8_t **q, size_t size);

void cpu_gemv_w4a8(
    uint32_t C_N, uint32_t C_K,
    const int8_t *xq_vec, const int8_t *wq_mat, int32_t *cq_vec);

void cpu_gemm_w4a8(
    uint32_t C_M, uint32_t C_N, uint32_t C_K,
    const int8_t *aq_mat, const int8_t *bq_mat, int32_t *cq_mat);

void gemv_v3_kernel_cpu(
    const int8_t *aq_buf, const int8_t *bq_buf, int32_t *cq_buf);

void gemm_v3_kernel_cpu(
    const int8_t *aq_buf, const int8_t *bq_buf, int32_t *cq_buf);

void gemv_reshape_active_for_fpga(
    const int8_t *src, int8_t *dst, int M, int N);

void gemm_reshape_active_for_fpga(
    const int8_t *src, int8_t *dst, int M, int N);

void cpu_w4a8(
    uint32_t C_M, uint32_t C_N, uint32_t C_K,
    const int8_t *aq_mat, const int8_t *bq_mat, int32_t *cq_mat,
    const int grid_per_buf, const int elem_per_grid);

void v3_kernel_cpu(
    const int8_t *aq_buf, const int8_t *bq_buf, int32_t *cq_buf,
    const int grid_per_buf, const int elem_per_grid);

void quantize_reshape(
    QuantizedTensor *qx, const float *x, int seq_len, int dim,
    const int seq_grid_per_buf, const int seq_elem_per_grid);

void dequantize_reshape(
    float *c, const float *as, const float *bs, const int32_t *cq_mat,
    int seq_len, int dim, const int seq_grid_per_buf, const int seq_elem_per_grid);

void dequantize_reshape_swiglu(
    float *c,
    const float *a1s, const float *b1s, const int32_t *c1q,
    const float *a2s, const float *b2s, const int32_t *c2q,
    int seq_len, int dim, const int seq_grid_per_buf, const int seq_elem_per_grid);

void reshape_for_fpga(
    const int8_t *src, int8_t *dst, int M, int N,
    set_fn_t set_fn, get_fn_t get_fn,
    const int m_grid_per_buf, const int m_elem_per_grid,
    const int n_grid_per_buf, const int n_elem_per_grid);

void pack(int8_t *package, int offset, int8_t value);

int8_t unpack(int8_t package, int offset);

void set_4b(int8_t *arr, int index, int8_t value);

int8_t get_4b(const int8_t *arr, int index);

void set_8b(int8_t *arr, int index, int8_t value);

int8_t get_8b(const int8_t *arr, int index);

void quantize_4b_fake(float *a, int row, int col, int lc);

void quantize_8b_fake(float *a, int row, int col, int lc);

#endif // _CPU_H