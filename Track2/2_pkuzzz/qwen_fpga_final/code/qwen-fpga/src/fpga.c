#include <stdint.h>
#include <assert.h>

#include "xrt_utils.h"
#include "fpga.h"
#include "params.h"
#include "profile.h"

void fpga_gemv_w4a8_start(
    uint32_t C_N, uint32_t C_K,
    const int8_t *xq_vec, const int8_t *wq_mat, int32_t *cq_vec)
{
    start_segment(GEMV_INIT);

    static uint32_t last_C_M = 0;
    static uint32_t last_C_N = 0;
    static uint32_t last_C_K = 0;
    static size_t last_active_ptr = 0;
    static size_t last_weight_ptr = 0;
    static size_t last_result_ptr = 0;

    uint32_t C_M = 1;

    const size_t xq_size = C_M * C_K * D_ACTIVE_BO_SIZE;
    const size_t wq_size = C_N * C_K * D_WEIGHT_BO_SIZE;
    const size_t cq_size = C_M * C_N * D_RESULT_BO_SIZE;

    const void *active_ptr = xq_vec;
    xrtBufferHandle active = xrt_ptr_to_bo(active_ptr);
    const void *weight_ptr = wq_mat;
    xrtBufferHandle weight = xrt_ptr_to_bo(weight_ptr);
    void *result_ptr = cq_vec;
    xrtBufferHandle result = xrt_ptr_to_bo(result_ptr);

    end_segment(GEMV_INIT);

    xrtRunHandle run = xrt_states.gemv_run;

    start_segment(GEMV_BO_SYNC_W);
    // xrtBOSync(weight, XCL_BO_SYNC_BO_TO_DEVICE, wq_size, 0);
    end_segment(GEMV_BO_SYNC_W);

    start_segment(GEMV_SET_ARGS);
    if (C_M != last_C_M)
    {
        xrtRunSetArg(run, 1, C_M);
        last_C_M = C_M;
    }
    if (C_N != last_C_N)
    {
        xrtRunSetArg(run, 2, C_N);
        last_C_N = C_N;
    }
    if (C_K != last_C_K)
    {
        xrtRunSetArg(run, 3, C_K);
        last_C_K = C_K;
    }
    if (active_ptr != (void *)last_active_ptr)
    {
        start_segment(GEMV_BO_SYNC_A);
        xrtBOSync(active, XCL_BO_SYNC_BO_TO_DEVICE, xq_size, 0);
        end_segment(GEMV_BO_SYNC_A);

        xrtRunSetArg(run, 4, active);
        last_active_ptr = (size_t)active_ptr;
    }
    if (weight_ptr != (void *)last_weight_ptr)
    {
        xrtRunSetArg(run, 5, weight);
        last_weight_ptr = (size_t)weight_ptr;
    }
    if (result_ptr != (void *)last_result_ptr)
    {
        xrtRunSetArg(run, 6, result);
        last_result_ptr = (size_t)result_ptr;
    }
    end_segment(GEMV_SET_ARGS);

    start_segment(GEMV_RUN_START);
    xrtRunStart(run);
    end_segment(GEMV_RUN_START);
}

void fpga_gemv_w4a8_wait(uint32_t C_N, int32_t *cq_vec)
{
    uint32_t C_M = 1;
    const size_t cq_size = C_M * C_N * D_RESULT_BO_SIZE;

    void *result_ptr = cq_vec;
    xrtBufferHandle result = xrt_ptr_to_bo(result_ptr);

    xrtRunHandle run = xrt_states.gemv_run;

    start_segment(GEMV_RUN_WAIT);
    xrtRunWait(run);
    end_segment(GEMV_RUN_WAIT);

    start_segment(GEMV_BO_SYNC_R);
    xrtBOSync(result, XCL_BO_SYNC_BO_FROM_DEVICE, cq_size, 0);
    end_segment(GEMV_BO_SYNC_R);
}

void fpga_gemm_w4a8_start(
    uint32_t C_M, uint32_t C_N, uint32_t C_K,
    const int8_t *aq_mat, const int8_t *bq_mat, int32_t *cq_mat)
{
    start_segment(GEMM_INIT);

    static uint32_t last_C_M = 0;
    static uint32_t last_C_N = 0;
    static uint32_t last_C_K = 0;
    static size_t last_active_ptr = 0;
    static size_t last_weight_ptr = 0;
    static size_t last_result_ptr = 0;

    const size_t xq_size = C_M * C_K * ACTIVE_BO_SIZE;
    const size_t wq_size = C_N * C_K * WEIGHT_BO_SIZE;
    const size_t cq_size = C_M * C_N * RESULT_BO_SIZE;

    const void *active_ptr = aq_mat;
    xrtBufferHandle active = xrt_ptr_to_bo(active_ptr);
    const void *weight_ptr = bq_mat;
    xrtBufferHandle weight = xrt_ptr_to_bo(weight_ptr);
    void *result_ptr = cq_mat;
    xrtBufferHandle result = xrt_ptr_to_bo(result_ptr);

    end_segment(GEMM_INIT);

    xrtRunHandle run = xrt_states.gemm_run;

    start_segment(GEMM_BO_SYNC_W);
    // xrtBOSync(weight, XCL_BO_SYNC_BO_TO_DEVICE, wq_size, 0);
    end_segment(GEMM_BO_SYNC_W);

    start_segment(GEMM_SET_ARGS);
    if (C_M != last_C_M)
    {
        xrtRunSetArg(run, 1, C_M);
        last_C_M = C_M;
    }
    if (C_N != last_C_N)
    {
        xrtRunSetArg(run, 2, C_N);
        last_C_N = C_N;
    }
    if (C_K != last_C_K)
    {
        xrtRunSetArg(run, 3, C_K);
        last_C_K = C_K;
    }
    if (active_ptr != (void *)last_active_ptr)
    {
        start_segment(GEMM_BO_SYNC_A);
        xrtBOSync(active, XCL_BO_SYNC_BO_TO_DEVICE, xq_size, 0);
        end_segment(GEMM_BO_SYNC_A);

        xrtRunSetArg(run, 4, active);
        last_active_ptr = (size_t)active_ptr;
    }
    if (weight_ptr != (void *)last_weight_ptr)
    {
        xrtRunSetArg(run, 5, weight);
        last_weight_ptr = (size_t)weight_ptr;
    }
    if (result_ptr != (void *)last_result_ptr)
    {
        xrtRunSetArg(run, 6, result);
        last_result_ptr = (size_t)result_ptr;
    }
    end_segment(GEMM_SET_ARGS);

    start_segment(GEMM_RUN_START);
    xrtRunStart(run);
    end_segment(GEMM_RUN_START);
}

void fpga_gemm_w4a8_wait(uint32_t C_M, uint32_t C_N, int32_t *cq_mat)
{
    const size_t cq_size = C_M * C_N * RESULT_BO_SIZE;

    void *result_ptr = cq_mat;
    xrtBufferHandle result = xrt_ptr_to_bo(result_ptr);

    xrtRunHandle run = xrt_states.gemm_run;

    start_segment(GEMM_RUN_WAIT);
    xrtRunWait(run);
    end_segment(GEMM_RUN_WAIT);

    start_segment(GEMM_BO_SYNC_R);
    xrtBOSync(result, XCL_BO_SYNC_BO_FROM_DEVICE, cq_size, 0);
    end_segment(GEMM_BO_SYNC_R);
}

void fpga_gemv_w4a8(
    uint32_t C_N, uint32_t C_K,
    const int8_t *xq_vec, const int8_t *wq_mat, int32_t *cq_vec)
{
    fpga_gemv_w4a8_start(C_N, C_K, xq_vec, wq_mat, cq_vec);
    fpga_gemv_w4a8_wait(C_N, cq_vec);
}

void fpga_gemm_w4a8(
    uint32_t C_M, uint32_t C_N, uint32_t C_K,
    const int8_t *aq_mat, const int8_t *bq_mat, int32_t *cq_mat)
{
    fpga_gemm_w4a8_start(C_M, C_N, C_K, aq_mat, bq_mat, cq_mat);
    fpga_gemm_w4a8_wait(C_M, C_N, cq_mat);
}

void fpga_copy_quantized_weight(void **ptr, int8_t *q, size_t size)
{
    void *p = *ptr;
    xrtBufferHandle bo = xrt_ptr_to_bo(q);
    xrtBOWrite(bo, p, size, 0);
    xrtBOSync(bo, XCL_BO_SYNC_BO_TO_DEVICE, size, 0);
    *ptr = (int8_t *)p + size;
}
