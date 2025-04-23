#include <assert.h>
#include <stdlib.h>

#include "ir.h"
#include "params.h"
#include "profile.h"

#ifdef FPGA
#include "fpga.h"
#include "xrt_utils.h"
#endif

void gemv(int32_t *xout, QuantizedTensor *x, QuantizedTensor *w, int n, int d)
{
    start_segment(OP_GEMV);
    const int num_obuf = d / (WO_ELEM_PER_GRID * WO_GRID_PER_BUF);
    const int num_ibuf = n / (WI_ELEM_PER_GRID * WI_GRID_PER_BUF);

#ifdef FPGA
    fpga_gemv_w4a8(num_obuf, num_ibuf, x->q, w->q, xout);
#else
    cpu_gemv_w4a8(num_obuf, num_ibuf, x->q, w->q, xout);
#endif
    end_segment(OP_GEMV);
}

void gemm(int32_t *C, QuantizedTensor *A, QuantizedTensor *B, int M, int N, int K)
{
    start_segment(OP_GEMM);
    assert(A->dtype == INT8);
    assert(B->dtype == INT4);
    assert(M % (PREFILL_GRID_PER_BUF * PREFILL_ELEM_PER_GRID) == 0);
    assert(N % (WO_GRID_PER_BUF * WO_ELEM_PER_GRID) == 0);
    assert(K % (WI_GRID_PER_BUF * WI_ELEM_PER_GRID) == 0);

    const int num_sbuf = M / (PREFILL_GRID_PER_BUF * PREFILL_ELEM_PER_GRID);
    const int num_obuf = N / (WO_GRID_PER_BUF * WO_ELEM_PER_GRID);
    const int num_hbuf = K / (WI_GRID_PER_BUF * WI_ELEM_PER_GRID);

#ifdef FPGA
    fpga_gemm_w4a8(num_sbuf, num_obuf, num_hbuf, A->q, B->q, C);
#else
    cpu_gemm_w4a8(num_sbuf, num_obuf, num_hbuf, A->q, B->q, C);
#endif
    end_segment(OP_GEMM);
}

void malloc_quantized_active(QuantizedTensor *q, int seq_len, int dim)
{
    size_t size = seq_len * dim;
#ifdef FPGA
    q->q = xrt_malloc(size);
#else
    q->q = calloc(size, sizeof(int8_t));
#endif
    q->s = calloc(seq_len, sizeof(float));
    q->dtype = INT8;
}

void malloc_quantized_weight(QuantizedTensor *q, size_t size)
{
#ifdef FPGA
    q->q = xrt_malloc(size);
#else
    // weight only need map
#endif
}

int32_t *malloc_quantized_result(size_t size)
{
#ifdef FPGA
    return xrt_malloc(size * sizeof(int32_t));
#else
    return calloc(size, sizeof(int32_t));
#endif
}

void free_quantized_active(QuantizedTensor *q)
{
#ifdef FPGA
    // nothing to do, free when xrt_clean()
#else
    free(q->q);
#endif
    free(q->s);
}

void free_quantized_weight(QuantizedTensor *q)
{
#ifdef FPGA
    // nothing to do, free when xrt_clean()
#else
    // nothing to do, only map
#endif
}

void free_quantized_result(int32_t *q)
{
#ifdef FPGA
    // nothing to do, free when xrt_clean()
#else
    free(q);
#endif
}


void set_quantized_weight(void **ptr, QuantizedTensor *q, int dim_in, int dim_out)
{
    void *p = *ptr;
    size_t size = dim_in * dim_out / 2;
/* copy (FPGA) or map (CPU) quantized int8 values*/
#ifdef FPGA
    fpga_copy_quantized_weight(&p, q->q, size);
#else
    cpu_map_quantized_weight(&p, &q->q, size);
#endif
    /* map scale factors */
    q->s = (float *)p;
    p = (float *)p + dim_out;
    q->dtype = INT4;
    *ptr = p; // advance ptr to current position
}

QuantizedTensor *init_quantized_weights(void **ptr, int n, int dim_in, int dim_out)
{
    void *p = *ptr;
    QuantizedTensor *res = malloc(n * sizeof(QuantizedTensor));
    for (int i = 0; i < n; i++)
    {
        malloc_quantized_weight(&res[i], dim_in * dim_out / 2);
        set_quantized_weight(&p, &res[i], dim_in, dim_out);
    }
    *ptr = p; // advance ptr to current position
    return res;
}

void gemv_start(int32_t *xout, QuantizedTensor *x, QuantizedTensor *w, int n, int d)
{
    const int num_obuf = d / (WO_ELEM_PER_GRID * WO_GRID_PER_BUF);
    const int num_ibuf = n / (WI_ELEM_PER_GRID * WI_GRID_PER_BUF);

#ifdef FPGA
    fpga_gemv_w4a8_start(num_obuf, num_ibuf, x->q, w->q, xout);
#else
    cpu_gemv_w4a8(num_obuf, num_ibuf, x->q, w->q, xout);
#endif
}

void gemm_start(int32_t *C, QuantizedTensor *A, QuantizedTensor *B, int M, int N, int K)
{
    assert(A->dtype == INT8);
    assert(B->dtype == INT4);
    assert(M % (PREFILL_GRID_PER_BUF * PREFILL_ELEM_PER_GRID) == 0);
    assert(N % (WO_GRID_PER_BUF * WO_ELEM_PER_GRID) == 0);
    assert(K % (WI_GRID_PER_BUF * WI_ELEM_PER_GRID) == 0);

    const int num_sbuf = M / (PREFILL_GRID_PER_BUF * PREFILL_ELEM_PER_GRID);
    const int num_obuf = N / (WO_GRID_PER_BUF * WO_ELEM_PER_GRID);
    const int num_hbuf = K / (WI_GRID_PER_BUF * WI_ELEM_PER_GRID);

#ifdef FPGA
    fpga_gemm_w4a8_start(num_sbuf, num_obuf, num_hbuf, A->q, B->q, C);
#else
    cpu_gemm_w4a8(num_sbuf, num_obuf, num_hbuf, A->q, B->q, C);
#endif
}

void gemv_wait(int32_t *xout, int d)
{
#ifdef FPGA
    const int num_obuf = d / (WO_ELEM_PER_GRID * WO_GRID_PER_BUF);
    fpga_gemv_w4a8_wait(num_obuf, xout);
#endif
}

void gemm_wait(int32_t *C, int M, int N)
{
#ifdef FPGA
    const int num_obuf = N / (WO_ELEM_PER_GRID * WO_GRID_PER_BUF);
    const int num_sbuf = M / (PREFILL_GRID_PER_BUF * PREFILL_ELEM_PER_GRID);
    fpga_gemm_w4a8_wait(num_sbuf, num_obuf, C);
#endif
}