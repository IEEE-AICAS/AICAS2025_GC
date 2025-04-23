#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <math.h>

#include "params.h"
#include "cpu.h"
#include "fpga.h"
#include "xrt_utils.h"

#define EPS 1e-4
#define FPGA_TEST_SUCCESS 0
#define FPGA_TEST_FAILURE 1

/* Helper functions */

int allclose_int32_tensor(int32_t *a, int32_t *b, uint32_t seq_len)
{
    int status = FPGA_TEST_SUCCESS;
    for (uint32_t i = 0; i < seq_len; i++)
    {
        if (a[i] != b[i])
        {
            printf("int32 tensor mismatch: a[%d] = %d, b[%d] = %d\n", i, a[i], i, b[i]);
            status = FPGA_TEST_FAILURE;
        }
    }
    return status;
}

int allclose_float32_tensor(float *a, float *b, uint32_t seq_len)
{
    int status = FPGA_TEST_SUCCESS;
    for (uint32_t i = 0; i < seq_len; i++)
    {
        if (fabs(a[i] - b[i]) > EPS)
        {
            printf("float32 tensor mismatch: a[%d] = %f, b[%d] = %f\n", i, a[i], i, b[i]);
            status = FPGA_TEST_FAILURE;
        }
    }
    return status;
}

void init_random_int8_tensor(int8_t *t, uint32_t seq_len)
{
    for (uint32_t i = 0; i < seq_len; i++)
    {
        t[i] = rand() % 256 - 128;
    }
}

void init_zero_int32_tensor(int32_t *t, uint32_t seq_len)
{
    for (uint32_t i = 0; i < seq_len; i++)
    {
        t[i] = 0;
    }
}

/* Test functions */

/* Test X (1xK) @ W (KxN) = C (1xN) */
int test_fpga_gemv_w4a8(uint32_t N, uint32_t K)
{
    assert(N % (WO_GRID_PER_BUF * WO_ELEM_PER_GRID) == 0);
    assert(K % (WI_GRID_PER_BUF * WI_ELEM_PER_GRID) == 0);

    uint32_t C_N = N / (WO_GRID_PER_BUF * WO_ELEM_PER_GRID);
    uint32_t C_K = K / (WI_GRID_PER_BUF * WI_ELEM_PER_GRID);
    int8_t *xq_ptr = xrt_malloc(K * sizeof(int8_t));
    int8_t *wq_ptr = xrt_malloc(K * N / 2 * sizeof(int8_t));
    int32_t *cq_cpu_ptr = xrt_malloc(N * sizeof(int32_t));
    int32_t *cq_fpga_ptr = xrt_malloc(N * sizeof(int32_t));

    init_random_int8_tensor(xq_ptr, K);
    init_random_int8_tensor(wq_ptr, K * N / 2);
    init_zero_int32_tensor(cq_cpu_ptr, N);
    init_zero_int32_tensor(cq_fpga_ptr, N);

    cpu_gemv_w4a8(C_N, C_K, xq_ptr, wq_ptr, cq_cpu_ptr);
    fpga_gemv_w4a8(C_N, C_K, xq_ptr, wq_ptr, cq_fpga_ptr);

    return allclose_int32_tensor(cq_cpu_ptr, cq_fpga_ptr, N);
}

/* Test X (MxK) @ W (KxN) = C (MxN) */
int test_fpga_gemm_w4a8(uint32_t M, uint32_t N, uint32_t K)
{
    assert(M % (PREFILL_GRID_PER_BUF * PREFILL_ELEM_PER_GRID) == 0);
    assert(N % (WO_GRID_PER_BUF * WO_ELEM_PER_GRID) == 0);
    assert(K % (WI_GRID_PER_BUF * WI_ELEM_PER_GRID) == 0);

    uint32_t C_M = M / (PREFILL_GRID_PER_BUF * PREFILL_ELEM_PER_GRID);
    uint32_t C_N = N / (WO_GRID_PER_BUF * WO_ELEM_PER_GRID);
    uint32_t C_K = K / (WI_GRID_PER_BUF * WI_ELEM_PER_GRID);
    int8_t *xq_ptr = xrt_malloc(M * K * sizeof(int8_t));
    int8_t *wq_ptr = xrt_malloc(K * N / 2 * sizeof(int8_t));
    int32_t *cq_cpu_ptr = xrt_malloc(M * N * sizeof(int32_t));
    int32_t *cq_fpga_ptr = xrt_malloc(M * N * sizeof(int32_t));

    init_random_int8_tensor(xq_ptr, M * K);
    init_random_int8_tensor(wq_ptr, K * N / 2);
    init_zero_int32_tensor(cq_cpu_ptr, M * N);
    init_zero_int32_tensor(cq_fpga_ptr, M * N);

    cpu_gemm_w4a8(C_M, C_N, C_K, xq_ptr, wq_ptr, cq_cpu_ptr);
    fpga_gemm_w4a8(C_M, C_N, C_K, xq_ptr, wq_ptr, cq_fpga_ptr);

    return allclose_int32_tensor(cq_cpu_ptr, cq_fpga_ptr, M * N);
}

int main()
{
    const char *xclbin_file = XCLBIN_PATH;
    const int device_index = 0;
    const char *gemm_name = GEMM_KERNEL_NAME;
    const char *gemv_name = GEMV_KERNEL_NAME;
    xrt_setup(xclbin_file, device_index, gemm_name, gemv_name);

    int status = FPGA_TEST_SUCCESS;

    for (int i = 0; i < 10; i++)
    {
        status |= test_fpga_gemv_w4a8(256, 256);
    }

    for (int i = 0; i < 10; i++)
    {
        status |= test_fpga_gemm_w4a8(256, 256, 256);
    }

    if (status == FPGA_TEST_SUCCESS)
    {
        printf("All FPGA tests passed!\n");
    }

    xrt_cleanup();
    return 0;
}