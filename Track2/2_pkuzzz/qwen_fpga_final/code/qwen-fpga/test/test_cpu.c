#include <stdio.h>

#include "cpu.h"

void print_bits(int8_t value)
{
    for (int i = 7; i >= 0; i--)
    {
        printf("%d", (value >> i) & 1);
    }
}

void test_pack_unpack()
{
    // Test pack and unpack functions
    printf("----------------- Test pack() & unpack() -----------------\n");
    int8_t package = 0;
    pack(&package, 0, 5);
    pack(&package, 1, 7);
    printf("Packed value: ");
    print_bits(package);
    printf("\n");
    printf("Unpacked values: %d %d\n", unpack(package, 0), unpack(package, 1));
    pack(&package, 0, -3);
    pack(&package, 1, -5);
    printf("Packed value: ");
    print_bits(package);
    printf("\n");
    printf("Unpacked values: %d %d\n", unpack(package, 0), unpack(package, 1));
}

void test_set_get_4b()
{
    // Test set_4b and get_4b functions
    printf("----------------- Test set_4b() & get_4b() -----------------\n");
    int8_t arr[2] = {0, 0};
    set_4b(arr, 0, 5);
    set_4b(arr, 1, 7);
    set_4b(arr, 2, -3);
    set_4b(arr, 3, -5);
    printf("Array after set_4b: ");
    for (int i = 0; i < 2; i++)
    {
        print_bits(arr[i]);
        printf(" ");
    }
    printf("\n");
    printf("Get values: %d %d %d %d\n", get_4b(arr, 0), get_4b(arr, 1), get_4b(arr, 2), get_4b(arr, 3));
}

void test_reshape_4b(
    const int8_t *src, int8_t *dst, int o_dim, int i_dim,
    const int m_grid_per_buf, const int m_elem_per_grid,
    const int n_grid_per_buf, const int n_elem_per_grid)
{
    reshape_for_fpga(src, dst, o_dim, i_dim, set_4b, get_4b,
                     m_grid_per_buf, m_elem_per_grid,
                     n_grid_per_buf, n_elem_per_grid);
}

void test_reshape_8b(
    const int8_t *src, int8_t *dst, int o_dim, int i_dim,
    const int m_grid_per_buf, const int m_elem_per_grid,
    const int n_grid_per_buf, const int n_elem_per_grid)
{
    reshape_for_fpga(src, dst, o_dim, i_dim, set_8b, get_8b,
                     m_grid_per_buf, m_elem_per_grid,
                     n_grid_per_buf, n_elem_per_grid);
}

void test_cpu_w4a8(
    uint32_t C_M, uint32_t C_N, uint32_t C_K,
    const int8_t *aq_mat, const int8_t *bq_mat, int32_t *cq_mat,
    const int grid_per_buf, const int elem_per_grid)
{
    cpu_w4a8(C_M, C_N, C_K,
             aq_mat, bq_mat, cq_mat,
             grid_per_buf, elem_per_grid);
}

void test_v3_kernel_cpu(
    const int8_t *aq_buf, const int8_t *bq_buf, int32_t *cq_buf,
    const int grid_per_buf, const int elem_per_grid)
{
    v3_kernel_cpu(aq_buf, bq_buf, cq_buf,
                  grid_per_buf, elem_per_grid);
}

void test_quantize_reshape(
    QuantizedTensor *qx, const float *x, int seq_len, int dim,
    const int seq_grid_per_buf, const int seq_elem_per_grid)
{
    quantize_reshape(qx, x, seq_len, dim,
                     seq_grid_per_buf, seq_elem_per_grid);
}

void test_dequantize_reshape(
    float *c, const const float *as, const float *bs, const int32_t *cq_mat,
    int seq_len, int dim, const int seq_grid_per_buf, const int seq_elem_per_grid)
{
    dequantize_reshape(c, as, bs, cq_mat, seq_len, dim,
                       seq_grid_per_buf, seq_elem_per_grid);
}