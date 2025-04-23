#include "xrt_utils.h"

#include <assert.h>
#include <stdio.h>
#include <stdint.h>

int main() {
    const char *xclbin_file = XCLBIN_PATH;
    const int device_index = 0;
    const char *gemm_name = GEMM_KERNEL_NAME;
    const char *gemv_name = GEMV_KERNEL_NAME;
    xrt_setup(xclbin_file, device_index, gemm_name, gemv_name);

    int8_t *A = xrt_malloc(4096);
    int8_t *B = xrt_malloc(128);
    int32_t *C = xrt_malloc(1024);

    printf("A: %p, B: %p, C: %p\n", A, B, C);

    xrtBufferHandle A_bo = xrt_ptr_to_bo(A);
    xrtBufferHandle B_bo = xrt_ptr_to_bo(B + 5);
    xrtBufferHandle C_bo = xrt_ptr_to_bo(C + 16 * sizeof(int32_t));

    size_t A_phy_addr = xrtBOAddress(A_bo);
    size_t B_phy_addr = xrtBOAddress(B_bo);
    size_t C_phy_addr = xrtBOAddress(C_bo);

    printf("A_phy_addr: %p, B_phy_addr: %p, C_phy_addr: %p\n", (void *)A_phy_addr, (void *)B_phy_addr, (void *)C_phy_addr);

    xrt_cleanup();
    return 0;
}