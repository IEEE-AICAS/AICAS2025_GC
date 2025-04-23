#ifndef _IR_H
#define _IR_H

#include "cpu.h"

/* sync APIs */

void gemv(int32_t *xout, QuantizedTensor *x, QuantizedTensor *w, int n, int d);

void gemm(int32_t *C, QuantizedTensor *A, QuantizedTensor *B, int M, int N, int K);

/* Async APIs (for CPU it's still sync) */

void gemv_start(int32_t *xout, QuantizedTensor *x, QuantizedTensor *w, int n, int d);

void gemm_start(int32_t *C, QuantizedTensor *A, QuantizedTensor *B, int M, int N, int K);

void gemv_wait(int32_t *xout, int d);

void gemm_wait(int32_t *C, int M, int N);

void malloc_quantized_active(QuantizedTensor *q, int seq_len, int dim);

void malloc_quantized_weight(QuantizedTensor *q, size_t size);

int32_t *malloc_quantized_result(size_t size);

void free_quantized_active(QuantizedTensor *q);

void free_quantized_weight(QuantizedTensor *q);

void free_quantized_result(int32_t *q);

void set_quantized_weight(void **ptr, QuantizedTensor *q, int dim_in, int dim_out);

/* initialize `n` x quantized tensor (with `size_each` elements), starting from memory pointed at *ptr */
QuantizedTensor *init_quantized_weights(void **ptr, int n, int dim_in, int dim_out);

#endif // _IR_H