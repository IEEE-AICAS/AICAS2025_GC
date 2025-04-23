#include "cpu.h"
#include "frontend.h"

#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <math.h>

#define EPS 1e-4

int allclose_float32_tensor(float *a, float *b, uint32_t seq_len)
{
    for (uint32_t i = 0; i < seq_len; i++)
    {
        if (fabs(a[i] - b[i]) > EPS)
        {
            return 0;
        }
    }
    return 1;
}

float *init_random_float32_tensor(uint32_t seq_len)
{
    float *t = (float *)malloc(seq_len * sizeof(float));
    for (uint32_t i = 0; i < seq_len; i++)
    {
        t[i] = rand() % 10000 / 1000.0f;
        // printf("%f ", t[i]);
    }
    // printf("\n");
    return t;
}

int main()
{
    const int head_size = 2;
    const int seq_len = 3;
    const int n_heads = 6;
    const int n_kv_heads = 2;
    const int kv_mul = n_heads / n_kv_heads;

    const int dim = n_heads * head_size;
    const int kv_dim = n_kv_heads * head_size;

    const int prompt_token_num = 3;

    float *Q = init_random_float32_tensor(seq_len * dim);
    float *K = init_random_float32_tensor(seq_len * kv_dim);
    float *V = init_random_float32_tensor(seq_len * kv_dim);
    float *ATT = init_random_float32_tensor(n_heads * seq_len * seq_len);
    float *XB_gold = calloc(seq_len * dim, sizeof(float));
    float *XB_test = calloc(seq_len * dim, sizeof(float));

    printf("\nQ = \n");
    for (int i = 0; i < seq_len; i++)
    {
        for (int j = 0; j < dim; j++)
        {
            printf("%.4f ", Q[i * dim + j]);
        }
        printf("\n");
    }

    printf("\nK = \n");
    for (int i = 0; i < seq_len; i++)
    {
        for (int j = 0; j < kv_dim; j++)
        {
            printf("%.4f ", K[i * kv_dim + j]);
        }
        printf("\n");
    }

    printf("\nV = \n");
    for (int i = 0; i < seq_len; i++)
    {
        for (int j = 0; j < kv_dim; j++)
        {
            printf("%.4f ", V[i * kv_dim + j]);
        }
        printf("\n");
    }

    // #pragma omp parallel for
    for (int h = 0; h < n_heads; h++)
    {
        printf("\nATT[%d] = \n", h);
        for (int pos = 0; pos < prompt_token_num; pos++)
        {
            float *q = Q + pos * dim + h * head_size;
            float *att = ATT + h * seq_len;
            float *k = K + (h / kv_mul) * head_size;
            float *v = V + (h / kv_mul) * head_size;
            float *xb = XB_gold + pos * dim + h * head_size;

            token_attn(q, att, k, v, xb, pos, kv_dim, head_size);
            for (int t = 0; t <= pos; t++)
            {
                printf("%.4f ", att[t]);
            }
            printf("\n");
        }
    }
    printf("\nXB_gold = \n");
    for (int i = 0; i < seq_len; i++)
    {
        for (int j = 0; j < dim; j++)
        {
            printf("%.4f ", XB_gold[i * dim + j]);
        }
        printf("\n");
    }
    for (int h = 0; h < n_heads; h++)
    {
        float *q = Q + h * head_size;
        float *att = ATT + h * seq_len * seq_len;
        float *k = K + (h / kv_mul) * head_size;
        float *v = V + (h / kv_mul) * head_size;
        float *xb = XB_test + h * head_size;
        prefill_attn(q, att, k, v, xb, prompt_token_num, dim, kv_dim, head_size);
        printf("\nATT[%d] = \n", h);
        for (int pos = 0; pos < prompt_token_num; pos++)
        {
            for (int t = 0; t < prompt_token_num; t++)
            {
                printf("%.4f ", att[pos * prompt_token_num + t]);
            }
            printf("\n");
        }
    }
    printf("\nXB_test = \n");
    for (int i = 0; i < seq_len; i++)
    {
        for (int j = 0; j < dim; j++)
        {
            printf("%.4f ", XB_test[i * dim + j]);
        }
        printf("\n");
    }

    if (!allclose_float32_tensor(XB_gold, XB_test, seq_len * dim))
    {
        printf("Test failed!!!\n");
    }
    free(Q);
    free(K);
    free(V);
    free(ATT);
    free(XB_gold);
    free(XB_test);

    return 0;
}