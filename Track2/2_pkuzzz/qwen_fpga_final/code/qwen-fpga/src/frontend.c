#include <math.h>
#include <string.h>
#include <assert.h>

#include "frontend.h"
#include "model.h"
#include "params.h"
#include "profile.h"

// #ifdef BLAS
#include "cblas.h"
// #endif

/* Original version from runq.c */
void token_attn(float *q, float *att, float *k, float *v, float *xb, int pos, int kv_dim, int head_size)
{
    start_segment(TOKEN_ATTN);
    start_segment(TOKEN_ATTN_QKMATMUL);
#ifdef BLAS
    float scale = 1.0f / sqrtf(head_size);
    // calculate the attention score as the dot product of q and k
    cblas_sgemv(CblasRowMajor, CblasNoTrans,
                pos + 1,   // 行数（时间步数）
                head_size, // 列数（特征维度）
                scale,     // 缩放因子
                k,         // K矩阵指针
                kv_dim,    // K矩阵的列间距（原始维度）
                q,         // 查询向量
                1,         // 查询向量步长
                0.0f,      // beta
                att,       // 输出注意力分数
                1);        // 分数向量步长
#else
    for (int t = 0; t <= pos; t++)
    {
        // get the key vector for this head and at this timestep
        float *kt = k + t * kv_dim;
        // calculate the attention score as the dot product of q and k
        float score = 0.0f;
        for (int i = 0; i < head_size; i++)
        {
            score += q[i] * kt[i];
        }
        score /= sqrtf(head_size);
        // save the score to the attention buffer
        att[t] = score;
    }
#endif
    end_segment(TOKEN_ATTN_QKMATMUL);

    // softmax the scores to get attention weights, from 0..pos inclusively
    start_segment(TOKEN_ATTN_SOFTMAX);
    softmax(att, pos + 1);
    end_segment(TOKEN_ATTN_SOFTMAX);

    start_segment(TOKEN_ATTN_PVMATMUL);
#ifdef BLAS
    cblas_sgemv(CblasRowMajor, CblasTrans,
                pos + 1,   // 源矩阵行数（时间步数）
                head_size, // 源矩阵列数（特征维度）
                1.0f,      // alpha
                v,         // V矩阵指针
                kv_dim,    // V矩阵的列间距
                att,       // 注意力权重
                1,         // 权重向量步长
                0.0f,      // beta
                xb,        // 输出向量
                1);        // 输出向量步长
#else
    // weighted sum of the values, store back into xb
    memset(xb, 0, head_size * sizeof(float));

    for (int t = 0; t <= pos; t++)
    {
        // get the value vector for this head and at this timestep
        float *vt = v + t * kv_dim;
        // get the attention weight for this timestep
        float a = att[t];
        // accumulate the weighted value into xb
        for (int i = 0; i < head_size; i++)
        {
            xb[i] += a * vt[i];
        }
    }
#endif
    end_segment(TOKEN_ATTN_PVMATMUL);
    end_segment(TOKEN_ATTN);
}

/* sgemm for GQA */
void grouped_query_attn(float *q, float *att, float *k, float *v, float *xb, int pos, int kv_dim, int head_size, int num_query, int seq_len)
{
    // start_segment(TOKEN_ATTN);
    // start_segment(TOKEN_ATTN_QKMATMUL);
#ifdef BLAS
    // First calculate Q @ K^T
    // Shape: [num_query, head_size] @ [seq_len, head_size]^T
    cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasTrans,
                num_query, pos + 1, head_size, 1.0f / sqrtf(head_size),
                q, head_size,
                k, kv_dim,
                0.0f, att, seq_len);
#else
    for (int h = 0; h < num_query; h++)
    {
        for (int t = 0; t <= pos; t++)
        {
            float *qh = q + h * head_size;
            float *kt = k + t * kv_dim;
            float score = 0.0f;
            for (int i = 0; i < head_size; i++)
            {
                score += qh[i] * kt[i];
            }
            score /= sqrtf(head_size);
            float *atth = att + h * seq_len;
            atth[t] = score;
        }
    }
#endif
    // end_segment(TOKEN_ATTN_QKMATMUL);

    // start_segment(TOKEN_ATTN_SOFTMAX);
    for (int h = 0; h < num_query; h++)
    {
        float *atth = att + h * seq_len;
        softmax(atth, pos + 1);
    }
    // end_segment(TOKEN_ATTN_SOFTMAX);

    // start_segment(TOKEN_ATTN_PVMATMUL);
#ifdef BLAS
    // First calculate P @ V
    // Shape: [num_query, seq_len] @ [seq_len, head_size]
    cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
                num_query, head_size, seq_len, 1.0f,
                att, seq_len,
                v, kv_dim,
                0.0f, xb, head_size);
#else
    memset(xb, 0, num_query * head_size * sizeof(float));
    for (int h = 0; h < num_query; h++)
    {
        for (int t = 0; t <= pos; t++)
        {
            float *atth = att + h * seq_len;
            float a = atth[t];
            float *vt = v + t * kv_dim;
            float *xbh = xb + h * head_size;
            for (int i = 0; i < head_size; i++)
            {
                xbh[i] += a * vt[i];
            }
        }
    }
#endif
    // end_segment(TOKEN_ATTN_PVMATMUL);
    // end_segment(TOKEN_ATTN);
}

/* Flash attention, support GQA and casual masking */
void flash_attention(float *q, float *k, float *v, float *xb, float *fa_s, float *fa_o, float *fa_pv, int seq_len, int h_dim, int kv_dim, int head_size)
{
    start_segment(FLASH_ATTN);
    const int num_heads = h_dim / head_size;
    const int kv_mul = h_dim / kv_dim;

    // Set block size (Algo line 1)
    const int B_r = FA_Q_BLOCK_SIZE; // Query block size
    const int B_c = FA_K_BLOCK_SIZE; // Key block size

#ifdef ENABLE_PREFILL_STREAMING
    // these assertions makes it easier to 
    assert(seq_len % B_r == 0);
    assert(seq_len % B_c == 0);
    assert(B_r == B_c);
#endif

    openblas_set_num_threads(1);

#pragma omp parallel for
    for (int h = 0; h < num_heads; ++h)
    {

        // initialize on-chip buffers (Algo line 2~4)
        float *priv_s = fa_s + h * B_r * B_c;         // B_r * B_c = 64 * 64
        float *priv_o = fa_o + h * B_r * head_size;   // B_r * head_size
        float *priv_pv = fa_pv + h * B_r * head_size; // B_r * head_size
        float priv_m[FA_Q_BLOCK_SIZE] = {0};          // B_r = 64
        float priv_l[FA_Q_BLOCK_SIZE] = {0};          // B_r = 64

        // Different from the paper, we iterate through B_r first (Algo line 7)
        for (int i_start = 0; i_start < seq_len; i_start += B_r)
        {
            const int i_end = (i_start + B_r) < seq_len ? (i_start + B_r) : seq_len;
            const int i_size = i_end - i_start;

            // Initialize the buffers
            start_segment(FLASH_ATTN_INIT_BUFFER);
            memset(priv_l, 0, FA_Q_BLOCK_SIZE * sizeof(float));
            memset(priv_o, 0, FA_Q_BLOCK_SIZE * head_size * sizeof(float));
            // Can't memset 0xFF800000 (clipped to unsigned char)
            for (int k = 0; k < FA_Q_BLOCK_SIZE; k++)
            {
                priv_m[k] = -INFINITY;
            }
            end_segment(FLASH_ATTN_INIT_BUFFER);

            // The corresponding kv head for q head
            const int h_kv = h / kv_mul;

            // Iterate through kv blocks (Algo line 5)
            for (int j_start = 0; j_start < i_end; j_start += B_c)
            {
                const int j_end = (j_start + B_c) < i_end ? (j_start + B_c) : i_end;
                const int j_size = j_end - j_start;

#ifdef ENABLE_PREFILL_STREAMING
                if (j_start > 0 && j_start < i_end - 2 * B_c)
                    continue;
#endif

                // Compute Score S_ij (Algo line 8)
                // First calculate Q_i @ K_j^T
                // Shape: [i_size, head_size] @ [j_size, head_size]^T
                start_segment(FLASH_ATTN_MATMUL_QK);
#ifdef BLAS
                cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasTrans,
                            i_size, j_size, head_size, 1.0 / sqrtf(head_size),
                            q + h * head_size + i_start * h_dim, h_dim,
                            k + h_kv * head_size + j_start * kv_dim, kv_dim,
                            0.0f, priv_s, j_size);
#else
                for (int ii = 0; ii < i_size; ii++)
                {
                    for (int jj = 0; jj < j_size; jj++)
                    {
                        float s_val = 0.0;
                        for (int hh = 0; hh < head_size; hh++)
                        {
                            const float q_val = q[(i_start + ii) * h_dim + h * head_size + hh];
                            const float k_val = k[(j_start + jj) * kv_dim + h_kv * head_size + hh];
                            s_val += q_val * k_val;
                        }
                        priv_s[ii * j_size + jj] = s_val / sqrtf(head_size);
                    }
                }
#endif
                end_segment(FLASH_ATTN_MATMUL_QK);

                // Compute block-wise m, P and l (Algo line 10, 11)
                float priv_m_tilde[FA_Q_BLOCK_SIZE] = {0};
                float priv_l_tilde[FA_Q_BLOCK_SIZE] = {0};
                float priv_m_new[FA_Q_BLOCK_SIZE] = {0};
                float priv_l_new[FA_Q_BLOCK_SIZE] = {0};

                // Handle each row
                start_segment(FLASH_ATTN_UPDATE_ML);
                for (int i = 0; i < i_size; ++i)
                {
                    float *ss = priv_s + i * j_size;
                    const float m_old = priv_m[i];
                    const float l_old = priv_l[i];

                    // Casual masking before calculating m, l and P
                    const int current_query_idx = i_start + i;

                    // effective key tokens to take care of
                    int j_eff_end;
                    if (current_query_idx >= j_end)
                        j_eff_end = j_size;
                    else if (current_query_idx >= j_start)
                        j_eff_end = current_query_idx - j_start + 1;
                    else
                        j_eff_end = 0;
                    for (int j = j_eff_end; j < j_size; j++)
                    {
                        ss[j] = 0;
                    }

                    // effective query tokens to take care of
                    int j_eff_start = 0;
#ifdef ENABLE_PREFILL_STREAMING
#ifdef STREAMING_PERFECT_DIAGONAL
                    // This attention block is upper triangle
                    if ((j_start == i_end - 2 * B_c) && (j_start != 0))
                    {
                        j_eff_start = i_size;
                        for (int j = 0; j < j_eff_start; j++)
                        {
                            ss[j] = 0;
                        }
                    }
#endif
#endif

                    // compute rowmax m_tilde and m_new
                    float m_tilde = -INFINITY;
                    for (int j = j_eff_start; j < j_eff_end; ++j)
                    {
                        m_tilde = fmaxf(ss[j], m_tilde);
                    }
                    float m_new = fmaxf(m_tilde, m_old);
                    priv_m_tilde[i] = m_tilde;
                    priv_m_new[i] = m_new;

                    // compute pointwise P_tilde (stored in-situ) and rowsum l_tilde
                    float l_tilde = 0.0f;
                    for (int j = j_eff_start; j < j_eff_end; ++j)
                    {
                        ss[j] = fast_exp(ss[j] - m_tilde);  // gives exactly 0 for -INF
                        l_tilde += ss[j];
                    }
                    float l_new = fast_exp(m_old - m_new) * l_old + fast_exp(m_tilde - m_new) * l_tilde;
                    priv_l_tilde[i] = l_tilde;
                    priv_l_new[i] = fmaxf(l_new, 1e-10); // set l_new >= epsilon for numerical stability
                }
                end_segment(FLASH_ATTN_UPDATE_ML);

                // Update O_i (Algo line 12)
                // First calculate P_tilde @ V_j
                // Shape: [i_size, j_size] @ [j_size, head_size]
                start_segment(FLASH_ATTN_MATMUL_PV);
#ifdef BLAS
#ifdef ENABLE_PREFILL_STREAMING
                if (j_start == 0) // the first block should be full sgemm
                {
                    cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
                                i_size, head_size, j_size, 1.0f,
                                priv_s, j_size,
                                v + h_kv * head_size + j_start * kv_dim, kv_dim,
                                0.0f, priv_pv, head_size);
                }
                else // use trmm t6 accelerate
                {
                    if (j_start == i_end - 2 * B_c) // uppder trmm
                    {
#ifdef STREAMING_PERFECT_DIAGONAL
                        // move B matrix to destination
                        for (int j = 0; j < j_size; j++)
                        {
                            memcpy(priv_pv + j * head_size, v + h_kv * head_size + (j_start + j) * kv_dim, head_size * sizeof(float));
                        }
                        cblas_strmm(CblasRowMajor, CblasLeft, CblasUpper, CblasNoTrans, CblasNonUnit,
                            i_size, head_size, 1.0f,
                            priv_s, j_size,
                            priv_pv, head_size);
#else
                        cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
                            i_size, head_size, j_size, 1.0f,
                            priv_s, j_size,
                            v + h_kv * head_size + j_start * kv_dim, kv_dim,
                            0.0f, priv_pv, head_size);
#endif
                    }
                    else // lower trmm
                    {
                        // move B matrix to destination
                        for (int j = 0; j < j_size; j++)
                        {
                            memcpy(priv_pv + j * head_size, v + h_kv * head_size + (j_start + j) * kv_dim, head_size * sizeof(float));
                        }
                        cblas_strmm(CblasRowMajor, CblasLeft, CblasLower, CblasNoTrans, CblasNonUnit,
                                    i_size, head_size, 1.0f,
                                    priv_s, j_size,
                                    priv_pv, head_size);
                    }
                }
#else
                cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
                            i_size, head_size, j_size, 1.0f,
                            priv_s, j_size,
                            v + h_kv * head_size + j_start * kv_dim, kv_dim,
                            0.0f, priv_pv, head_size);
#endif
#else
                for (int ii = 0; ii < i_size; ii++)
                {
                    for (int hh = 0; hh < head_size; hh++)
                    {
                        float pv_val = 0.0;
                        for (int jj = 0; jj < j_size; jj++)
                        {
                            const float p_val = priv_s[ii * j_size + jj];
                            const float v_val = v[(j_start + jj) * kv_dim + h_kv * head_size + hh];
                            pv_val += p_val * v_val;
                        }
                        priv_pv[ii * head_size + hh] = pv_val;
                    }
                }
#endif
                end_segment(FLASH_ATTN_MATMUL_PV);

                // the elementwise version might be more straight-forward than original FA paper
                start_segment(FLASH_ATTN_UPDATE_O);
                for (int i = 0; i < i_size; i++)
                {
                    const float m_old = priv_m[i];
                    const float l_old = priv_l[i];
                    const float m_new = priv_m_new[i];
                    const float l_new = priv_l_new[i];
                    const float m_tilde = priv_m_tilde[i];

                    const float o_scale = fast_exp(m_old - m_new) * l_old / l_new;
                    const float pv_scale = fast_exp(m_tilde - m_new) / l_new;

                    float *o_r = priv_o + i * head_size;
                    float *pv_r = priv_pv + i * head_size;

                    for (int k = 0; k < head_size; k++)
                    {
                        o_r[k] = o_r[k] * o_scale + pv_r[k] * pv_scale;
                    }
                }

                // Update global m and l (Algo line 13)
                for (int i = 0; i < i_size; i++)
                {
                    priv_m[i] = priv_m_new[i];
                    priv_l[i] = priv_l_new[i];
                }
                end_segment(FLASH_ATTN_UPDATE_O);
            }

            // Finally, copy O buffer to xb (which is not contiguous)
            // cblas_scopy(head_size, priv_o, 1,
            //             xb + h * head_size + i_start * h_dim, h_dim);
            start_segment(FLASH_ATTN_COPY_O);
            for (int ii = 0; ii < i_size; ii++)
            {
                memcpy(xb + h * head_size + (ii + i_start) * h_dim, priv_o + ii * head_size, head_size * sizeof(float));
            }
            end_segment(FLASH_ATTN_COPY_O);
        }
    }
    end_segment(FLASH_ATTN);
}

/* Replace token_attn with BLAS gemm */
void prefill_attn(float *q, float *att, float *k, float *v, float *xb, int prompt_token_num, int dim, int kv_dim, int head_size)
{
#ifdef BLAS
    float scale = 1.0f / sqrtf(head_size);
    // calculate the attention score as the dot product of q and k
    cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasTrans,
                prompt_token_num,  // 行数（时间步数）
                prompt_token_num,  // 列数（时间步数）
                head_size,         // K矩阵的列数（特征维度）
                scale,             // 缩放因子
                q,                 // Q矩阵指针
                dim,               // Q矩阵的列间距（原始维度）
                k,                 // K矩阵指针
                kv_dim,            // K矩阵的列间距（原始维度）
                0.0f,              // beta
                att,               // 输出注意力分数
                prompt_token_num); // 输出注意力分数的列间距
#else
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        float *q_pos = q + pos * dim;
        float *att_pos = att + pos * prompt_token_num;
        for (int t = 0; t < prompt_token_num; t++)
        {
            float *kt = k + t * kv_dim;
            float score = 0.0f;
            for (int i = 0; i < head_size; i++)
            {
                score += q_pos[i] * kt[i];
            }
            score /= sqrtf(head_size);
            // save the score to the attention buffer
            att_pos[t] = score;
        }
    }
#endif
    softmax_casual_triangle(att, prompt_token_num);
#ifdef BLAS
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        cblas_scopy(head_size, v + pos * kv_dim, 1, xb + pos * dim, 1);
    }
    cblas_strmm(CblasRowMajor, CblasLeft, CblasLower, CblasNoTrans, CblasNonUnit,
                prompt_token_num, // 行数（时间步数）
                head_size,        // 列数（特征维度）
                1.0f,             // alpha
                att,              // attn矩阵指针
                prompt_token_num, // attn矩阵的列间距（原始维度）
                xb,               // 输出向量
                dim);             // 输出向量的列间距
#else
    // weighted sum of the values, store back into xb
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        float *att_pos = att + pos * prompt_token_num;
        float *xb_pos = xb + pos * dim;
        memset(xb_pos, 0, head_size * sizeof(float));
        for (int t = 0; t < prompt_token_num; t++)
        {
            float *vt = v + t * kv_dim;
            float a = att_pos[t];
            for (int i = 0; i < head_size; i++)
            {
                xb_pos[i] += a * vt[i];
            }
        }
    }
#endif
}

/* Original version from runq.c */
void mha_prefill_v1(Transformer *transformer, int layer, int prompt_token_num, bool need_bias)
{
    start_segment(MHA_PREFILL);
    // a few convenience variables
    Config *p = &transformer->config;
    TransformerWeights *w = &transformer->weights;
    RunState *s = &transformer->state;
    float *x = s->x;
    int dim = p->dim;
    int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
    int kv_mul = p->n_heads / p->n_kv_heads; // integer multiplier of the kv sharing in multiquery
    int hidden_dim = p->hidden_dim;
    int head_size = dim / p->n_heads;
    int l = layer;
    const int seq_block_size = PREFILL_ELEM_PER_GRID * PREFILL_GRID_PER_BUF;
    int pad_prompt_token_num = (prompt_token_num + seq_block_size - 1) / seq_block_size * seq_block_size;

    // attention rmsnorm
    start_segment(MHA_PREFILL_RMSNORM);
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        rmsnorm(s->xb + pos * dim, x + pos * dim, w->rms_att_weight + l * dim, dim);
    }
    end_segment(MHA_PREFILL_RMSNORM);

    // key and value point to the kv cache
    int loff = l * p->seq_len * kv_dim; // kv cache layer offset for convenience
    float *k = s->key_cache + loff;
    float *v = s->value_cache + loff;
    start_segment(MHA_PREFILL_ACT_QUANT);
    quantize_prefill_reshape(&s->xq, s->xb, pad_prompt_token_num, dim);
    end_segment(MHA_PREFILL_ACT_QUANT);
    // s->q^T = w->wq @ s->xb^T  => s->q = s->xb @ w->wq^T, s->q (prompt_token_num, dim), s->xb (prompt_token_num, dim), w->wq (dim, dim)
    start_segment(MHA_PREFILL_GEMM_Q);
    gemm(s->cq, &s->xq, w->wq + l, pad_prompt_token_num, dim, dim);
    end_segment(MHA_PREFILL_GEMM_Q);
    start_segment(MHA_PREFILL_ACT_DEQUANT);
    dequantize_prefill_reshape(s->q, s->xq.s, (w->wq + l)->s, s->cq, pad_prompt_token_num, dim);
    end_segment(MHA_PREFILL_ACT_DEQUANT);
    // s->k^T = w->wk @ s->xb^T  => s->k = s->xb @ w->wk^T, s->k (prompt_token_num, kv_dim), s->xb (prompt_token_num, dim), w->wk (kv_dim, dim)
    start_segment(MHA_PREFILL_GEMM_K);
    gemm(s->cq, &s->xq, w->wk + l, pad_prompt_token_num, kv_dim, dim);
    end_segment(MHA_PREFILL_GEMM_K);
    start_segment(MHA_PREFILL_ACT_DEQUANT);
    dequantize_prefill_reshape(k, s->xq.s, (w->wk + l)->s, s->cq, pad_prompt_token_num, kv_dim);
    end_segment(MHA_PREFILL_ACT_DEQUANT);
    // s->v^T = w->wv @ s->xb^T  => s->v = s->xb @ w->wv^T, s->v (prompt_token_num, kv_dim), s->xb (prompt_token_num, dim), w->wv (kv_dim, dim)
    start_segment(MHA_PREFILL_GEMM_V);
    gemm(s->cq, &s->xq, w->wv + l, pad_prompt_token_num, kv_dim, dim);
    end_segment(MHA_PREFILL_GEMM_V);
    start_segment(MHA_PREFILL_ACT_DEQUANT);
    dequantize_prefill_reshape(v, s->xq.s, (w->wv + l)->s, s->cq, pad_prompt_token_num, kv_dim);
    end_segment(MHA_PREFILL_ACT_DEQUANT);

    // bias
    start_segment(MHA_PREFILL_ADD_BIAS);
    if (need_bias)
    {
#pragma omp parallel for
        for (int pos = 0; pos < prompt_token_num; pos++)
        {
            elementwise_add(s->q + pos * dim, w->bq + l * dim, dim);
            elementwise_add(k + pos * kv_dim, w->bk + l * kv_dim, kv_dim);
            elementwise_add(v + pos * kv_dim, w->bv + l * kv_dim, kv_dim);
        }
    }
    end_segment(MHA_PREFILL_ADD_BIAS);

    // RoPE
    start_segment(MHA_PREFILL_ROPE);
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        rope(s->q + pos * dim, k + pos * kv_dim, dim, head_size, p->n_kv_heads, pos);
    }
    end_segment(MHA_PREFILL_ROPE);

// #pragma omp parallel for
//     for (int h = 0; h < p->n_heads; h++)
//     {
//         quantize_8b_fake(s->q + h * head_size, pad_prompt_token_num, head_size, dim);
//     }
// #pragma omp parallel for
//     for (int h = 0; h < p->n_kv_heads; h++)
//     {
//         quantize_8b_fake(k + h * head_size, pad_prompt_token_num, head_size, kv_dim);
//         quantize_8b_fake(v + h * head_size, pad_prompt_token_num, head_size, kv_dim);
//     }

    // multihead attention.
    start_segment(MHA_PREFILL_ATTN);
#ifndef FLASH_ATTENTION
#pragma omp parallel for
        for (int h = 0; h < p->n_heads; h++)
        {
            // float *q = s->q + h * head_size;
            // float *att = s->att + h * p->seq_len * p->seq_len;
            // float *k = s->key_cache + loff + (h / kv_mul) * head_size;
            // float *xb = s->xb + h * head_size;
            // float *v = s->value_cache + loff + (h / kv_mul) * head_size;
            // prefill_attn(q, att, k, v, xb, prompt_token_num, dim, kv_dim, head_size);
            for (int pos = 0; pos < prompt_token_num; pos++)
            {
                // get the query vector for this head
                float *q = s->q + pos * dim + h * head_size;
                // attention scores for this head
                float *att = s->att + h * p->seq_len;
                // get the key vector for this head
                float *k = s->key_cache + loff + (h / kv_mul) * head_size;
                // weighted sum of the values, store back into xb
                float *xb = s->xb + pos * dim + h * head_size;
                // get the value vector for this head
                float *v = s->value_cache + loff + (h / kv_mul) * head_size;
                // calculate the attention
                token_attn(q, att, k, v, xb, pos, kv_dim, head_size);
            }
        }
#else
    int fa_prompt_token_num = prompt_token_num;
    #ifdef ENABLE_PREFILL_STREAMING
        fa_prompt_token_num = (prompt_token_num + FA_Q_BLOCK_SIZE - 1) / FA_Q_BLOCK_SIZE * FA_Q_BLOCK_SIZE;
    #endif
    flash_attention(s->q, s->key_cache + loff, s->value_cache + loff, s->xb, s->fa_s, s->fa_o, s->fa_pv, fa_prompt_token_num, dim, kv_dim, head_size);
#endif
    end_segment(MHA_PREFILL_ATTN);

    // final gemm to get the output of the attention
    // quantize(&s->xq, s->xb, prompt_token_num * dim);
    start_segment(MHA_PREFILL_ACT_QUANT);
    quantize_prefill_reshape(&s->xq, s->xb, pad_prompt_token_num, dim);
    end_segment(MHA_PREFILL_ACT_QUANT);
    // s->xb2^T = w->wo @ s->xb^T  => s->xb2 = s->xb @ w->wo^T, s->xb2 (prompt_token_num, dim), s->xb (prompt_token_num, dim), w->wo (dim, dim)
    start_segment(MHA_PREFILL_GEMM_O);
    gemm(s->cq, &s->xq, w->wo + l, pad_prompt_token_num, dim, dim);
    end_segment(MHA_PREFILL_GEMM_O);
    start_segment(MHA_PREFILL_ACT_DEQUANT);
    dequantize_prefill_reshape(s->xb2, s->xq.s, (w->wo + l)->s, s->cq, pad_prompt_token_num, dim);
    end_segment(MHA_PREFILL_ACT_DEQUANT);

    // residual connection back into x
    start_segment(MHA_PREFILL_ADD_RESIDUAL);
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        elementwise_add(x + pos * dim, s->xb2 + pos * dim, dim);
    }
    end_segment(MHA_PREFILL_ADD_RESIDUAL);

    end_segment(MHA_PREFILL);
}

/* Coarse-grained overlapping */
void mha_prefill_v3(Transformer *transformer, int layer, int prompt_token_num, bool need_bias)
{
    start_segment(MHA_PREFILL);

    // a few convenience variables
    Config *p = &transformer->config;
    TransformerWeights *w = &transformer->weights;
    RunState *s = &transformer->state;
    float *x = s->x;
    int dim = p->dim;
    int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
    int kv_mul = p->n_heads / p->n_kv_heads; // integer multiplier of the kv sharing in multiquery
    int hidden_dim = p->hidden_dim;
    int head_size = dim / p->n_heads;
    int l = layer;
    const int seq_block_size = PREFILL_ELEM_PER_GRID * PREFILL_GRID_PER_BUF;
    int pad_prompt_token_num = (prompt_token_num + seq_block_size - 1) / seq_block_size * seq_block_size;

    // Step 0: rmsnorm + quant + reshape (CPU)
    // attention rmsnorm
    start_segment(MHA_PREFILL_RMSNORM);
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        rmsnorm(s->xb + pos * dim, x + pos * dim, w->rms_att_weight + l * dim, dim);
    }
    end_segment(MHA_PREFILL_RMSNORM);

    // key and value point to the kv cache
    int loff = l * p->seq_len * kv_dim; // kv cache layer offset for convenience
    float *k = s->key_cache + loff;
    float *v = s->value_cache + loff;

    start_segment(MHA_PREFILL_ACT_QUANT);
    quantize_prefill_reshape(&s->xq, s->xb, pad_prompt_token_num, dim);
    end_segment(MHA_PREFILL_ACT_QUANT);

    // Step 1: Q_proj (FPGA)
    start_segment(MHA_PREFILL_GEMM_Q);
    gemm(s->cq, &s->xq, w->wq + l, pad_prompt_token_num, dim, dim);
    end_segment(MHA_PREFILL_GEMM_Q);

    // Step 2: K_proj (FPGA), Q_dequ + Q_bias (CPU)
    start_segment(MHA_PREFILL_GEMM_K);
    gemm_start(s->cq2, &s->xq, w->wk + l, pad_prompt_token_num, kv_dim, dim);
    dequantize_prefill_reshape(s->q, s->xq.s, (w->wq + l)->s, s->cq, pad_prompt_token_num, dim);
    if (need_bias)
    {
#pragma omp parallel for
        for (int pos = 0; pos < prompt_token_num; pos++)
        {
            elementwise_add(s->q + pos * dim, w->bq + l * dim, dim);
        }
    }
    gemm_wait(s->cq2, pad_prompt_token_num, kv_dim);
    end_segment(MHA_PREFILL_GEMM_K);

    // Step 3: V_proj (FPGA), K_dequ + K_bias + QK_rope (CPU)
    start_segment(MHA_PREFILL_GEMM_V);
    gemm_start(s->cq, &s->xq, w->wv + l, pad_prompt_token_num, kv_dim, dim);
    dequantize_prefill_reshape(k, s->xq.s, (w->wk + l)->s, s->cq2, pad_prompt_token_num, kv_dim);
    if (need_bias)
    {
#pragma omp parallel for
        for (int pos = 0; pos < prompt_token_num; pos++)
        {
            elementwise_add(k + pos * kv_dim, w->bk + l * kv_dim, kv_dim);
        }
    }
// RoPE
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        rope(s->q + pos * dim, k + pos * kv_dim, dim, head_size, p->n_kv_heads, pos);
    }
    gemm_wait(s->cq, pad_prompt_token_num, kv_dim);
    end_segment(MHA_PREFILL_GEMM_V);

    // s->v^T = w->wv @ s->xb^T  => s->v = s->xb @ w->wv^T, s->v (prompt_token_num, kv_dim), s->xb (prompt_token_num, dim), w->wv (kv_dim, dim)
    start_segment(MHA_PREFILL_ACT_DEQUANT);
    dequantize_prefill_reshape(v, s->xq.s, (w->wv + l)->s, s->cq, pad_prompt_token_num, kv_dim);
    end_segment(MHA_PREFILL_ACT_DEQUANT);

    // bias
    start_segment(MHA_PREFILL_ADD_BIAS);
    if (need_bias)
    {
#pragma omp parallel for
        for (int pos = 0; pos < prompt_token_num; pos++)
        {
            elementwise_add(v + pos * kv_dim, w->bv + l * kv_dim, kv_dim);
        }
    }
    end_segment(MHA_PREFILL_ADD_BIAS);

    start_segment(MHA_PREFILL_ATTN);
    // multihead attention.
    int fa_prompt_token_num = prompt_token_num;
#ifdef ENABLE_PREFILL_STREAMING
    fa_prompt_token_num = (prompt_token_num + FA_Q_BLOCK_SIZE - 1) / FA_Q_BLOCK_SIZE * FA_Q_BLOCK_SIZE;
#endif
    flash_attention(s->q, s->key_cache + loff, s->value_cache + loff, s->xb, s->fa_s, s->fa_o, s->fa_pv, fa_prompt_token_num, dim, kv_dim, head_size);

    // #pragma omp parallel for
    //     for (int h = 0; h < p->n_heads; h++)
    //     {
    //         for (int pos = 0; pos < prompt_token_num; pos++)
    //         {
    //             // get the query vector for this head
    //             float *q = s->q + pos * dim + h * head_size;
    //             // attention scores for this head
    //             float *att = s->att + h * p->seq_len;
    //             // get the key vector for this head
    //             float *k = s->key_cache + loff + (h / kv_mul) * head_size;
    //             // weighted sum of the values, store back into xb
    //             float *xb = s->xb + pos * dim + h * head_size;
    //             // get the value vector for this head
    //             float *v = s->value_cache + loff + (h / kv_mul) * head_size;
    //             // calculate the attention
    //             token_attn(q, att, k, v, xb, pos, kv_dim, head_size);
    //         }
    //     }

    // // test if xb equals to xb2
    // // put flash-attention results to xb2 for debugging
    // for (int h = 0; h < p->n_heads; h++)
    // {
    //     for (int pos = 0; pos < prompt_token_num; pos++)
    //     {
    //         const int idx = pos * dim + h * head_size;
    //         const float err = fabs(s->xb[idx] - s->xb2[idx]);
    //         if (err > 1e-4)
    //         {
    //             printf("h=%d, pos=%d, err=%f\n", h, pos, err);
    //         }
    //     }
    // }
    end_segment(MHA_PREFILL_ATTN);

    // final gemm to get the output of the attention
    // quantize(&s->xq, s->xb, prompt_token_num * dim);
    start_segment(MHA_PREFILL_ACT_QUANT);
    quantize_prefill_reshape(&s->xq, s->xb, pad_prompt_token_num, dim);
    end_segment(MHA_PREFILL_ACT_QUANT);
    // s->xb2^T = w->wo @ s->xb^T  => s->xb2 = s->xb @ w->wo^T, s->xb2 (prompt_token_num, dim), s->xb (prompt_token_num, dim), w->wo (dim, dim)
    start_segment(MHA_PREFILL_GEMM_O);
    gemm(s->cq, &s->xq, w->wo + l, pad_prompt_token_num, dim, dim);
    end_segment(MHA_PREFILL_GEMM_O);
    start_segment(MHA_PREFILL_ACT_DEQUANT);
    dequantize_prefill_reshape(s->xb2, s->xq.s, (w->wo + l)->s, s->cq, pad_prompt_token_num, dim);
    end_segment(MHA_PREFILL_ACT_DEQUANT);

    // residual connection back into x
    start_segment(MHA_PREFILL_ADD_RESIDUAL);
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        elementwise_add(x + pos * dim, s->xb2 + pos * dim, dim);
    }
    end_segment(MHA_PREFILL_ADD_RESIDUAL);
    end_segment(MHA_PREFILL);
}

/* Using BLAS gemm in prefill attn */
void mha_prefill_v4(Transformer *transformer, int layer, int prompt_token_num, bool need_bias)
{
    // a few convenience variables
    Config *p = &transformer->config;
    TransformerWeights *w = &transformer->weights;
    RunState *s = &transformer->state;
    float *x = s->x;
    int dim = p->dim;
    int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
    int kv_mul = p->n_heads / p->n_kv_heads; // integer multiplier of the kv sharing in multiquery
    int hidden_dim = p->hidden_dim;
    int head_size = dim / p->n_heads;
    int l = layer;
    const int seq_block_size = PREFILL_ELEM_PER_GRID * PREFILL_GRID_PER_BUF;
    int pad_prompt_token_num = (prompt_token_num + seq_block_size - 1) / seq_block_size * seq_block_size;

    // Step 0: rmsnorm + quant + reshape (CPU)
    // attention rmsnorm
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        rmsnorm(s->xb + pos * dim, x + pos * dim, w->rms_att_weight + l * dim, dim);
    }

    // key and value point to the kv cache
    int loff = l * p->seq_len * kv_dim; // kv cache layer offset for convenience
    float *k = s->key_cache + loff;
    float *v = s->value_cache + loff;

    quantize_prefill_reshape(&s->xq, s->xb, pad_prompt_token_num, dim);

    // Step 1: Q_proj (FPGA)
    gemm(s->cq, &s->xq, w->wq + l, pad_prompt_token_num, dim, dim);

    // Step 2: K_proj (FPGA), Q_dequ + Q_bias (CPU)
    gemm_start(s->cq2, &s->xq, w->wk + l, pad_prompt_token_num, kv_dim, dim);
    dequantize_prefill_reshape(s->q, s->xq.s, (w->wq + l)->s, s->cq, pad_prompt_token_num, dim);
    if (need_bias)
    {
#pragma omp parallel for
        for (int pos = 0; pos < prompt_token_num; pos++)
        {
            elementwise_add(s->q + pos * dim, w->bq + l * dim, dim);
        }
    }
    gemm_wait(s->cq2, pad_prompt_token_num, kv_dim);

    // Step 3: V_proj (FPGA), K_dequ + K_bias + QK_rope (CPU)
    gemm_start(s->cq, &s->xq, w->wv + l, pad_prompt_token_num, kv_dim, dim);
    dequantize_prefill_reshape(k, s->xq.s, (w->wk + l)->s, s->cq2, pad_prompt_token_num, kv_dim);
    if (need_bias)
    {
#pragma omp parallel for
        for (int pos = 0; pos < prompt_token_num; pos++)
        {
            elementwise_add(k + pos * kv_dim, w->bk + l * kv_dim, kv_dim);
        }
    }
// RoPE
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        rope(s->q + pos * dim, k + pos * kv_dim, dim, head_size, p->n_kv_heads, pos);
    }
    gemm_wait(s->cq, pad_prompt_token_num, kv_dim);

    // s->v^T = w->wv @ s->xb^T  => s->v = s->xb @ w->wv^T, s->v (prompt_token_num, kv_dim), s->xb (prompt_token_num, dim), w->wv (kv_dim, dim)
    dequantize_prefill_reshape(v, s->xq.s, (w->wv + l)->s, s->cq, pad_prompt_token_num, kv_dim);

    // bias
    if (need_bias)
    {
#pragma omp parallel for
        for (int pos = 0; pos < prompt_token_num; pos++)
        {
            elementwise_add(v + pos * kv_dim, w->bv + l * kv_dim, kv_dim);
        }
    }

    // multihead attention.
    start_segment(MHA_PREFILL_ATTN);
#pragma omp parallel for
    for (int h = 0; h < p->n_heads; h++)
    {
        float *q = s->q + h * head_size;
        float *att = s->att + h * p->seq_len * p->seq_len;
        float *k = s->key_cache + loff + (h / kv_mul) * head_size;
        float *xb = s->xb + h * head_size;
        float *v = s->value_cache + loff + (h / kv_mul) * head_size;
        prefill_attn(q, att, k, v, xb, prompt_token_num, dim, kv_dim, head_size);
    }
    end_segment(MHA_PREFILL_ATTN);

    // final gemm to get the output of the attention
    // quantize(&s->xq, s->xb, prompt_token_num * dim);
    start_segment(MHA_PREFILL_ACT_QUANT);
    quantize_prefill_reshape(&s->xq, s->xb, pad_prompt_token_num, dim);
    end_segment(MHA_PREFILL_ACT_QUANT);
    // s->xb2^T = w->wo @ s->xb^T  => s->xb2 = s->xb @ w->wo^T, s->xb2 (prompt_token_num, dim), s->xb (prompt_token_num, dim), w->wo (dim, dim)
    gemm(s->cq, &s->xq, w->wo + l, pad_prompt_token_num, dim, dim);
    start_segment(MHA_PREFILL_ACT_DEQUANT);
    dequantize_prefill_reshape(s->xb2, s->xq.s, (w->wo + l)->s, s->cq, pad_prompt_token_num, dim);
    end_segment(MHA_PREFILL_ACT_DEQUANT);

    // residual connection back into x
    start_segment(MHA_PREFILL_ADD_RESIDUAL);
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        elementwise_add(x + pos * dim, s->xb2 + pos * dim, dim);
    }
    end_segment(MHA_PREFILL_ADD_RESIDUAL);
}

/* Original implementation from runq.c */
void mlp_prefill_v1(Transformer *transformer, int layer, int prompt_token_num, bool need_bias)
{
    start_segment(MLP_PREFILL);

    // a few convenience variables
    Config *p = &transformer->config;
    TransformerWeights *w = &transformer->weights;
    RunState *s = &transformer->state;
    float *x = s->x;
    int dim = p->dim;
    int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
    int kv_mul = p->n_heads / p->n_kv_heads; // integer multiplier of the kv sharing in multiquery
    int hidden_dim = p->hidden_dim;
    int head_size = dim / p->n_heads;
    int l = layer;
    const int seq_block_size = PREFILL_ELEM_PER_GRID * PREFILL_GRID_PER_BUF;
    int pad_prompt_token_num = (prompt_token_num + seq_block_size - 1) / seq_block_size * seq_block_size;

    // ffn rmsnorm
    start_segment(MLP_PREFILL_RMSNORM);
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        rmsnorm(s->xb + pos * dim, x + pos * dim, w->rms_ffn_weight + l * dim, dim);
    }
    end_segment(MLP_PREFILL_RMSNORM);

    // Now for FFN in PyTorch we have: self.w2(F.silu(self.w1(x)) * self.w3(x))
    // first calculate self.w1(x) and self.w3(x)
    start_segment(MLP_PREFILL_QUANT_W1_W3);
    quantize_prefill_reshape(&s->xq, s->xb, pad_prompt_token_num, dim);
    end_segment(MLP_PREFILL_QUANT_W1_W3);
    // s->hb^T = w->w1 @ s->xb^T  => s->hb = s->xb @ w->w1^T, s->hb (prompt_token_num, hidden_dim), s->xb (prompt_token_num, dim), w->w1 (hidden_dim, dim)
    start_segment(MLP_PREFILL_GEMM_W1);
    gemm(s->cq, &s->xq, w->w1 + l, pad_prompt_token_num, hidden_dim, dim);
    end_segment(MLP_PREFILL_GEMM_W1);
    start_segment(MLP_PREFILL_W1D_W3_SWIGLU);
    start_segment(MLP_PREFILL_DEQUANT_W1);
    dequantize_prefill_reshape(s->hb, s->xq.s, (w->w1 + l)->s, s->cq, pad_prompt_token_num, hidden_dim);
    end_segment(MLP_PREFILL_DEQUANT_W1);
    // s->hb2^T = w->w3 @ s->xb^T  => s->hb2 = s->xb @ w->w3^T, s->hb2 (prompt_token_num, hidden_dim), s->xb (prompt_token_num, dim), w->w3 (hidden_dim, dim)
    start_segment(MLP_PREFILL_GEMM_W3);
    gemm(s->cq, &s->xq, w->w3 + l, pad_prompt_token_num, hidden_dim, dim);
    end_segment(MLP_PREFILL_GEMM_W3);
    start_segment(MLP_PREFILL_DEQUANT_W3);
    dequantize_prefill_reshape(s->hb2, s->xq.s, (w->w3 + l)->s, s->cq, pad_prompt_token_num, hidden_dim);
    end_segment(MLP_PREFILL_DEQUANT_W3);

    // SwiGLU non-linearity
    start_segment(MLP_PREFILL_SWIGLU);
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        swiglu(s->hb + pos * hidden_dim, s->hb2 + pos * hidden_dim, hidden_dim);
    }
    end_segment(MLP_PREFILL_SWIGLU);
    end_segment(MLP_PREFILL_W1D_W3_SWIGLU);

    // final gemm to get the output of the ffn
    start_segment(MLP_PREFILL_QUANT_W2);
    quantize_prefill_reshape(&s->hq, s->hb, pad_prompt_token_num, hidden_dim);
    end_segment(MLP_PREFILL_QUANT_W2);
    // s->xb2^T = w->w2 @ s->hb^T  => s->xb2 = s->hb @ w->w2^T, s->xb2 (prompt_token_num, dim), s->hb (prompt_token_num, hidden_dim), w->w2 (dim, hidden_dim)
    start_segment(MLP_PREFILL_GEMM_W2);
    gemm(s->cq, &s->hq, w->w2 + l, pad_prompt_token_num, dim, hidden_dim);
    end_segment(MLP_PREFILL_GEMM_W2);
    start_segment(MLP_PREFILL_DEQUANT_W2);
    dequantize_prefill_reshape(s->xb2, s->hq.s, (w->w2 + l)->s, s->cq, pad_prompt_token_num, dim);
    end_segment(MLP_PREFILL_DEQUANT_W2);

    // residual connection
    start_segment(MLP_PREFILL_ADD_RESIDUAL);
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        elementwise_add(x + pos * dim, s->xb2 + pos * dim, dim);
    }
    end_segment(MLP_PREFILL_ADD_RESIDUAL);
    end_segment(MLP_PREFILL);
}

/* Coarse-grained overlapping */
void mlp_prefill_v3(Transformer *transformer, int layer, int prompt_token_num, bool need_bias)
{
    start_segment(MLP_PREFILL);

    // a few convenience variables
    Config *p = &transformer->config;
    TransformerWeights *w = &transformer->weights;
    RunState *s = &transformer->state;
    float *x = s->x;
    int dim = p->dim;
    int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
    int kv_mul = p->n_heads / p->n_kv_heads; // integer multiplier of the kv sharing in multiquery
    int hidden_dim = p->hidden_dim;
    int head_size = dim / p->n_heads;
    int l = layer;
    const int seq_block_size = PREFILL_ELEM_PER_GRID * PREFILL_GRID_PER_BUF;
    int pad_prompt_token_num = (prompt_token_num + seq_block_size - 1) / seq_block_size * seq_block_size;

    // Step 0: rmsnorm + quant + reshape (CPU)
    // ffn rmsnorm
    start_segment(MLP_PREFILL_RMSNORM);
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        rmsnorm(s->xb + pos * dim, x + pos * dim, w->rms_ffn_weight + l * dim, dim);
    }
    end_segment(MLP_PREFILL_RMSNORM);
    start_segment(MLP_PREFILL_QUANT_W1_W3);
    quantize_prefill_reshape(&s->xq, s->xb, pad_prompt_token_num, dim);
    end_segment(MLP_PREFILL_QUANT_W1_W3);

    // Step 1: W1_proj (FPGA)
    start_segment(MLP_PREFILL_GEMM_W1);
    gemm(s->cq, &s->xq, w->w1 + l, pad_prompt_token_num, hidden_dim, dim);
    end_segment(MLP_PREFILL_GEMM_W1);

    start_segment(MLP_PREFILL_W1D_W3_SWIGLU);
    // Step 2: W3_proj (FPGA), W1_dequ + W1_silu (CPU)
    start_segment(MLP_PREFILL_GEMM_W3);
    gemm_start(s->cq2, &s->xq, w->w3 + l, pad_prompt_token_num, hidden_dim, dim);
    dequantize_prefill_reshape(s->hb, s->xq.s, (w->w1 + l)->s, s->cq, pad_prompt_token_num, hidden_dim);
// #pragma omp parallel for
//     for (int pos = 0; pos < prompt_token_num; pos++)
//     {
//         silu(s->hb + pos * hidden_dim, hidden_dim);
//     }
    gemm_wait(s->cq2, pad_prompt_token_num, hidden_dim);
    end_segment(MLP_PREFILL_GEMM_W3);

    // Step 2: W3_dequ + finish SwiGLU (CPU)
    start_segment(MLP_PREFILL_DEQUANT_W3);
    dequantize_prefill_reshape(s->hb2, s->xq.s, (w->w3 + l)->s, s->cq2, pad_prompt_token_num, hidden_dim);
    end_segment(MLP_PREFILL_DEQUANT_W3);
    start_segment(MLP_PREFILL_SWIGLU);
// #pragma omp parallel for
//     for (int pos = 0; pos < prompt_token_num; pos++)
//     {
//         elementwise_mul(s->hb + pos * hidden_dim, s->hb2 + pos * hidden_dim, hidden_dim);
//     }
    // don't separate swiglu when CPU becomes bottleneck
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        swiglu(s->hb + pos * hidden_dim, s->hb2 + pos * hidden_dim, hidden_dim);
    }
    end_segment(MLP_PREFILL_SWIGLU);
    end_segment(MLP_PREFILL_W1D_W3_SWIGLU);

    // final gemm to get the output of the ffn
    start_segment(MLP_PREFILL_QUANT_W2);
    quantize_prefill_reshape(&s->hq, s->hb, pad_prompt_token_num, hidden_dim);
    end_segment(MLP_PREFILL_QUANT_W2);
    // s->xb2^T = w->w2 @ s->hb^T  => s->xb2 = s->hb @ w->w2^T, s->xb2 (prompt_token_num, dim), s->hb (prompt_token_num, hidden_dim), w->w2 (dim, hidden_dim)
    start_segment(MLP_PREFILL_GEMM_W2);
    gemm(s->cq, &s->hq, w->w2 + l, pad_prompt_token_num, dim, hidden_dim);
    end_segment(MLP_PREFILL_GEMM_W2);
    start_segment(MLP_PREFILL_DEQUANT_W2);
    dequantize_prefill_reshape(s->xb2, s->hq.s, (w->w2 + l)->s, s->cq, pad_prompt_token_num, dim);
    end_segment(MLP_PREFILL_DEQUANT_W2);

    // residual connection
    start_segment(MLP_PREFILL_ADD_RESIDUAL);
#pragma omp parallel for
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        elementwise_add(x + pos * dim, s->xb2 + pos * dim, dim);
    }
    end_segment(MLP_PREFILL_ADD_RESIDUAL);
    end_segment(MLP_PREFILL);
}

/* Original implementation from runq.c */
void mha_decode_v1(Transformer *transformer, int layer, int pos, bool need_bias)
{
    start_segment(MHA_DECODE);
    // a few convenience variables
    Config *p = &transformer->config;
    TransformerWeights *w = &transformer->weights;
    RunState *s = &transformer->state;
    float *x = s->x;
    int dim = p->dim;
    int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
    int kv_mul = p->n_heads / p->n_kv_heads; // integer multiplier of the kv sharing in multiquery
    int hidden_dim = p->hidden_dim;
    int head_size = dim / p->n_heads;
    int l = layer;

    // attention rmsnorm
    start_segment(MHA_DECODE_RMSNORM);
    rmsnorm(s->xb, x, w->rms_att_weight + l * dim, dim);
    end_segment(MHA_DECODE_RMSNORM);

    // key and value point to the kv cache
    int loff = l * p->seq_len * kv_dim; // kv cache layer offset for convenience
    s->k = s->key_cache + loff + pos * kv_dim;
    s->v = s->value_cache + loff + pos * kv_dim;

    // qkv matmuls for this position
    start_segment(MHA_DECODE_ACT_QUANT);
    quantize_decode_reshape(&s->xq, s->xb, dim);
    end_segment(MHA_DECODE_ACT_QUANT);
    start_segment(MHA_DECODE_GEMV_Q);
    gemv(s->cq, &s->xq, w->wq + l, dim, dim);
    end_segment(MHA_DECODE_GEMV_Q);
    start_segment(MHA_DECODE_ACT_DEQUANT);
    dequantize_decode_reshape(s->q, s->xq.s, (w->wq + l)->s, s->cq, dim);
    end_segment(MHA_DECODE_ACT_DEQUANT);
    start_segment(MHA_DECODE_GEMV_K);
    gemv(s->cq, &s->xq, w->wk + l, dim, kv_dim);
    end_segment(MHA_DECODE_GEMV_K);
    start_segment(MHA_DECODE_ACT_DEQUANT);
    dequantize_decode_reshape(s->k, s->xq.s, (w->wk + l)->s, s->cq, kv_dim);
    end_segment(MHA_DECODE_ACT_DEQUANT);
    start_segment(MHA_DECODE_GEMV_V);
    gemv(s->cq, &s->xq, w->wv + l, dim, kv_dim);
    end_segment(MHA_DECODE_GEMV_V);
    start_segment(MHA_DECODE_ACT_DEQUANT);
    dequantize_decode_reshape(s->v, s->xq.s, (w->wv + l)->s, s->cq, kv_dim);
    start_segment(MHA_DECODE_ACT_DEQUANT);

    // bias
    start_segment(MHA_DECODE_ADD_BIAS);
    if (need_bias)
    {
        elementwise_add(s->q, w->bq + l * dim, dim);
        elementwise_add(s->k, w->bk + l * kv_dim, kv_dim);
        elementwise_add(s->v, w->bv + l * kv_dim, kv_dim);
    }
    end_segment(MHA_DECODE_ADD_BIAS);

    // RoPE
    start_segment(MHA_DECODE_ROPE);
    rope(s->q, s->k, dim, head_size, p->n_kv_heads, pos);
    end_segment(MHA_DECODE_ROPE);

// #pragma omp parallel for
//     for (int h = 0; h < p->n_heads; h++)
//     {
//         quantize_8b_fake(s->q + h * head_size, 1, head_size, dim);
//     }
// #pragma omp parallel for
//     for (int h = 0; h < p->n_kv_heads; h++)
//     {
//         quantize_4b_fake(s->k + h * head_size, 1, head_size, kv_dim);
//         quantize_4b_fake(s->v + h * head_size, 1, head_size, kv_dim);
//     }

    // multihead attention. iterate over all heads
    start_segment(MHA_DECODE_ATTN);
// #pragma omp parallel for
//     for (int h = 0; h < p->n_heads; h += kv_mul)
//     {
//         // get the query vector for this head
//         float *q = s->q + h * head_size;
//         // attention scores for this head
//         float *att = s->att + h * p->seq_len;
//         // get the key vector for this head
//         float *k = s->key_cache + loff + (h / kv_mul) * head_size;
//         // weighted sum of the values, store back into xb
//         float *xb = s->xb + h * head_size;
//         // get the value vector for this head
//         float *v = s->value_cache + loff + (h / kv_mul) * head_size;
//         // calculate the attention
//         grouped_query_attn(q, att, k, v, xb, pos, kv_dim, head_size, kv_mul, p->seq_len);
//     }
   int h;
#pragma omp parallel for private(h)
    for (h = 0; h < p->n_heads; h++)
    {
        // get the query vector for this head
        float *q = s->q + h * head_size;
        // attention scores for this head
        float *att = s->att + h * p->seq_len;
        // get the key vector for this head
        float *k = s->key_cache + loff + (h / kv_mul) * head_size;
        // weighted sum of the values, store back into xb
        float *xb = s->xb + h * head_size;
        // get the value vector for this head
        float *v = s->value_cache + loff + (h / kv_mul) * head_size;
        // calculate the attention
        token_attn(q, att, k, v, xb, pos, kv_dim, head_size);
    }
    end_segment(MHA_DECODE_ATTN);

    // final matmul to get the output of the attention
    start_segment(MHA_DECODE_ACT_QUANT);
    quantize_decode_reshape(&s->xq, s->xb, dim);
    end_segment(MHA_DECODE_ACT_QUANT);
    start_segment(MHA_DECODE_GEMV_O);
    gemv(s->cq, &s->xq, w->wo + l, dim, dim);
    end_segment(MHA_DECODE_GEMV_O);
    start_segment(MHA_DECODE_ACT_DEQUANT);
    dequantize_decode_reshape(s->xb2, s->xq.s, (w->wo + l)->s, s->cq, dim);
    end_segment(MHA_DECODE_ACT_DEQUANT);

    // residual connection back into x
    start_segment(MHA_DECODE_ADD_RESIDUAL);
    elementwise_add(x, s->xb2, dim);
    end_segment(MHA_DECODE_ADD_RESIDUAL);
    end_segment(MHA_DECODE);
}

/* Fine-grained overlapping */
void mha_decode_v2(Transformer *transformer, int layer, int pos, bool need_bias)
{
    // a few convenience variables
    Config *p = &transformer->config;
    TransformerWeights *w = &transformer->weights;
    RunState *s = &transformer->state;
    float *x = s->x;
    int dim = p->dim;
    int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
    int kv_mul = p->n_heads / p->n_kv_heads; // integer multiplier of the kv sharing in multiquery
    int hidden_dim = p->hidden_dim;
    int head_size = dim / p->n_heads;
    int l = layer;

    // Step 0: rmsnorm + quant + reshape (CPU)

    // attention rmsnorm
    rmsnorm(s->xb, x, w->rms_att_weight + l * dim, dim);

    // key and value point to the kv cache
    int loff = l * p->seq_len * kv_dim; // kv cache layer offset for convenience
    s->k = s->key_cache + loff + pos * kv_dim;
    s->v = s->value_cache + loff + pos * kv_dim;

    // qkv matmuls for this position
    quantize_decode_reshape(&s->xq, s->xb, dim);

    // Step 1: K_proj (FPGA)
    gemv(s->cq, &s->xq, w->wk + l, dim, kv_dim);

    dequantize_decode_reshape(s->k, s->xq.s, (w->wk + l)->s, s->cq, kv_dim);
    if (need_bias)
        elementwise_add(s->k, w->bk + l * kv_dim, kv_dim);

    // Step 2: V_proj (FPGA) + K_rope (CPU)
    gemv_start(s->cq, &s->xq, w->wv + l, dim, kv_dim);

    rope_head(s->k, head_size, p->n_kv_heads, pos);

    gemv_wait(s->cq, kv_dim);

    dequantize_decode_reshape(s->v, s->xq.s, (w->wv + l)->s, s->cq, kv_dim);
    if (need_bias)
        elementwise_add(s->v, w->bv + l * kv_dim, kv_dim);

    // Step 3: headwise Q_proj + rope & token_attn (CPU)
    const int qproj_nhead_size = NHEAD_PER_QPROJ * head_size;
    assert(p->n_heads % NHEAD_PER_QPROJ == 0);
    assert(qproj_nhead_size % (WO_ELEM_PER_GRID * WO_GRID_PER_BUF) == 0);

    // overlaps one iteration
    for (int i = 0; i <= p->n_heads; i += NHEAD_PER_QPROJ)
    {
        // compute Q_proj (FPGA)
        if (i < p->n_heads)
        {
            QuantizedTensor wq_head = {
                .q = (w->wq + l)->q + i * (head_size * dim / 2), // int4
                .s = (w->wq + l)->s + i * head_size,             // per-channel scale
                .dtype = INT4};
            // we spread the q_head in s->cq
            int32_t *q_head = s->cq + i * head_size;
            gemv_start(q_head, &s->xq, &wq_head, dim, qproj_nhead_size);
        }

        // Compute rope and token_attn of previous head
        if (i > 0)
        {
            int ii = i - NHEAD_PER_QPROJ;

            // dequantize previous q head
            float *q_vec = s->q + ii * head_size;
            const float *x_scale = s->xq.s;
            const float *w_scale = (w->wq + l)->s + ii * head_size;
            const int32_t *q_vec_int = s->cq + ii * head_size;

            dequantize_decode_reshape(q_vec, x_scale, w_scale, q_vec_int, qproj_nhead_size);

            // add bias
            if (need_bias)
            {
                float *q_bias = w->bq + l * dim + ii * head_size;
                elementwise_add(q_vec, q_bias, qproj_nhead_size);
            }

            // rope
            rope_head(q_vec, head_size, NHEAD_PER_QPROJ, pos);

            // token_attn
            int h;
// #pragma omp parallel for private(h)
            for (h = 0; h < NHEAD_PER_QPROJ; h++)
            {
                const int hh = ii + h;
                // get the query vector for this head
                float *q = s->q + hh * head_size;
                // attention scores for this head
                float *att = s->att + hh * p->seq_len;
                // get the key vector for this head
                float *k = s->key_cache + loff + (hh / kv_mul) * head_size;
                // weighted sum of the values, store back into xb
                float *xb = s->xb + hh * head_size;
                // get the value vector for this head
                float *v = s->value_cache + loff + (hh / kv_mul) * head_size;
                // calculate the attention
                token_attn(q, att, k, v, xb, pos, kv_dim, head_size);
            }
        }

        // wait for gemv
        if (i < p->n_heads)
        {
            gemv_wait(s->cq + i * qproj_nhead_size, qproj_nhead_size);
        }
    }

    // We haven't fused this part yet!

    // final matmul to get the output of the attention
    quantize_decode_reshape(&s->xq, s->xb, dim);
    gemv(s->cq, &s->xq, w->wo + l, dim, dim);
    dequantize_decode_reshape(s->xb2, s->xq.s, (w->wo + l)->s, s->cq, dim);

    // residual connection back into x
    elementwise_add(x, s->xb2, dim);
}

/* Coarse-grained overlapping */
void mha_decode_v3(Transformer *transformer, int layer, int pos, bool need_bias)
{
    // a few convenience variables
    Config *p = &transformer->config;
    TransformerWeights *w = &transformer->weights;
    RunState *s = &transformer->state;
    float *x = s->x;
    int dim = p->dim;
    int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
    int kv_mul = p->n_heads / p->n_kv_heads; // integer multiplier of the kv sharing in multiquery
    int hidden_dim = p->hidden_dim;
    int head_size = dim / p->n_heads;
    int l = layer;

    // Step 0: rmsnorm + quant + reshape (CPU)
    // attention rmsnorm
    rmsnorm(s->xb, x, w->rms_att_weight + l * dim, dim);

    // key and value point to the kv cache
    int loff = l * p->seq_len * kv_dim; // kv cache layer offset for convenience
    s->k = s->key_cache + loff + pos * kv_dim;
    s->v = s->value_cache + loff + pos * kv_dim;

    quantize_decode_reshape(&s->xq, s->xb, dim);

    // Step 1: Q_proj (FPGA)
    gemv(s->cq, &s->xq, w->wq + l, dim, dim);

    // Step 2: K_proj (FPGA), Q_dequ + Q_bias (CPU)
    gemv_start(s->cq2, &s->xq, w->wk + l, dim, kv_dim);
    dequantize_decode_reshape(s->q, s->xq.s, (w->wq + l)->s, s->cq, dim);
    if (need_bias)
    {
        elementwise_add(s->q, w->bq + l * dim, dim);
    }
    gemv_wait(s->cq2, kv_dim);

    // Step 3: V_proj (FPGA), K_dequ + K_bias + QK_rope (CPU)
    gemv_start(s->cq, &s->xq, w->wv + l, dim, kv_dim);
    dequantize_decode_reshape(s->k, s->xq.s, (w->wk + l)->s, s->cq2, kv_dim);
    if (need_bias)
    {
        elementwise_add(s->k, w->bk + l * kv_dim, kv_dim);
    }
    rope(s->q, s->k, dim, head_size, p->n_kv_heads, pos);
    gemv_wait(s->cq, kv_dim);

    dequantize_decode_reshape(s->v, s->xq.s, (w->wv + l)->s, s->cq, kv_dim);

    // bias
    if (need_bias)
    {
        elementwise_add(s->v, w->bv + l * kv_dim, kv_dim);
    }

    start_segment(MHA_DECODE_ATTN);
    // multihead attention. iterate over all heads
    int h;
#pragma omp parallel for private(h)
    for (h = 0; h < p->n_heads; h++)
    {
        // get the query vector for this head
        float *q = s->q + h * head_size;
        // attention scores for this head
        float *att = s->att + h * p->seq_len;
        // get the key vector for this head
        float *k = s->key_cache + loff + (h / kv_mul) * head_size;
        // weighted sum of the values, store back into xb
        float *xb = s->xb + h * head_size;
        // get the value vector for this head
        float *v = s->value_cache + loff + (h / kv_mul) * head_size;
        // calculate the attention
        token_attn(q, att, k, v, xb, pos, kv_dim, head_size);
    }
    end_segment(MHA_DECODE_ATTN);

    // final matmul to get the output of the attention
    quantize_decode_reshape(&s->xq, s->xb, dim);
    gemv(s->cq, &s->xq, w->wo + l, dim, dim);
    dequantize_decode_reshape(s->xb2, s->xq.s, (w->wo + l)->s, s->cq, dim);

    // residual connection back into x
    elementwise_add(x, s->xb2, dim);
}

/* Original implementation from runq.c */
void mlp_decode_v1(Transformer *transformer, int layer, int pos, bool need_bias)
{
    start_segment(MLP_DECODE);

    // a few convenience variables
    Config *p = &transformer->config;
    TransformerWeights *w = &transformer->weights;
    RunState *s = &transformer->state;
    float *x = s->x;
    int dim = p->dim;
    int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
    int kv_mul = p->n_heads / p->n_kv_heads; // integer multiplier of the kv sharing in multiquery
    int hidden_dim = p->hidden_dim;
    int head_size = dim / p->n_heads;
    int l = layer;

    // ffn rmsnorm
    start_segment(MLP_DECODE_RMSNORM);
    rmsnorm(s->xb, x, w->rms_ffn_weight + l * dim, dim);
    end_segment(MLP_DECODE_RMSNORM);

    // Now for FFN in PyTorch we have: self.w2(F.silu(self.w1(x)) * self.w3(x))
    // first calculate self.w1(x) and self.w3(x)
    start_segment(MLP_DECODE_QUANT_W1_W3);
    quantize_decode_reshape(&s->xq, s->xb, dim);
    end_segment(MLP_DECODE_QUANT_W1_W3);
    start_segment(MLP_DECODE_GEMV_W1);
    gemv(s->cq, &s->xq, w->w1 + l, dim, hidden_dim);
    end_segment(MLP_DECODE_GEMV_W1);
    start_segment(MLP_DECODE_W1D_W3_SWIGLU);
    start_segment(MLP_DECODE_DEQUANT_W1);
    dequantize_decode_reshape(s->hb, s->xq.s, (w->w1 + l)->s, s->cq, hidden_dim);
    end_segment(MLP_DECODE_DEQUANT_W1);
    start_segment(MLP_DECODE_GEMV_W3);
    gemv(s->cq, &s->xq, w->w3 + l, dim, hidden_dim);
    end_segment(MLP_DECODE_GEMV_W3);
    start_segment(MLP_DECODE_DEQUANT_W3);
    dequantize_decode_reshape(s->hb2, s->xq.s, (w->w3 + l)->s, s->cq, hidden_dim);
    end_segment(MLP_DECODE_DEQUANT_W3);

    // SwiGLU non-linearity
    start_segment(MLP_DECODE_SWIGLU);
    swiglu(s->hb, s->hb2, hidden_dim);
    end_segment(MLP_DECODE_SWIGLU);
    end_segment(MLP_DECODE_W1D_W3_SWIGLU);

    // final matmul to get the output of the ffn
    start_segment(MLP_DECODE_QUANT_W2);
    quantize_decode_reshape(&s->hq, s->hb, hidden_dim);
    end_segment(MLP_DECODE_QUANT_W2);
    start_segment(MLP_DECODE_GEMV_W2);
    gemv(s->cq, &s->hq, w->w2 + l, hidden_dim, dim);
    end_segment(MLP_DECODE_GEMV_W2);
    start_segment(MLP_DECODE_DEQUANT_W2);
    dequantize_decode_reshape(s->xb, s->hq.s, (w->w2 + l)->s, s->cq, dim);
    end_segment(MLP_DECODE_DEQUANT_W2);

    // residual connection
    start_segment(MLP_DECODE_ADD_RESIDUAL);
    elementwise_add(x, s->xb, dim);
    end_segment(MLP_DECODE_ADD_RESIDUAL);
    end_segment(MLP_DECODE);
}

/* Fine-grained overlapping */
void mlp_decode_v2(Transformer *transformer, int layer, int pos, bool need_bias)
{
    // a few convenience variables
    Config *p = &transformer->config;
    TransformerWeights *w = &transformer->weights;
    RunState *s = &transformer->state;
    float *x = s->x;
    int dim = p->dim;
    int hidden_dim = p->hidden_dim;
    int head_size = dim / p->n_heads;
    int n_hidden_heads = hidden_dim / head_size;
    int l = layer;

    // Step 0: rmsnorm + quant + reshape (CPU)
    rmsnorm(s->xb, x, w->rms_ffn_weight + l * dim, dim);
    quantize_decode_reshape(&s->xq, s->xb, dim);

    // Step 1: W1_proj & W3_proj (FPGA) + SwiGLU (CPU)
    const int w1proj_nhead_size = NHEAD_PER_W1PROJ * head_size;
    assert(hidden_dim % NHEAD_PER_W1PROJ == 0);
    assert(w1proj_nhead_size % (WO_ELEM_PER_GRID * WO_GRID_PER_BUF) == 0);

    // Step 1: W1_proj & W3_proj (FPGA) + SwiGLU (CPU)
    // We place integer accumulation result for x1 and x3 in s->cq sequentially
    for (int i = 0; i <= n_hidden_heads; i += NHEAD_PER_W1PROJ)
    {
        // compute W1_proj (FPGA)
        if (i < n_hidden_heads)
        {
            QuantizedTensor w1_head = {
                .q = (w->w1 + l)->q + i * (head_size * dim / 2), // int4
                .s = (w->w1 + l)->s + i * head_size,             // per-channel scale
                .dtype = INT4};
            // we spread the q_head in s->cq
            int32_t *x1_head = s->cq + i * head_size;
            gemv_start(x1_head, &s->xq, &w1_head, dim, w1proj_nhead_size);
        }

        // dequantize previous x1_head and x3_head
        if (i > 0)
        {
            int ii = i - NHEAD_PER_W1PROJ;

            // dequantize previous x1 head
            float *x1_vec = s->hb + ii * head_size;
            const float *x1_scale = s->xq.s;
            const float *w1_scale = (w->w1 + l)->s + ii * head_size;
            const int32_t *x1_vec_int = s->cq + ii * head_size;

            dequantize_decode_reshape(x1_vec, x1_scale, w1_scale, x1_vec_int, w1proj_nhead_size);

            // dequantize previous x3 head
            float *x3_vec = s->hb2 + ii * head_size;
            const float *x3_scale = s->xq.s;
            const float *w3_scale = (w->w3 + l)->s + ii * head_size;
            const int32_t *x3_vec_int = s->cq + hidden_dim + ii * head_size;

            dequantize_decode_reshape(x3_vec, x3_scale, w3_scale, x3_vec_int, w1proj_nhead_size);
        }

        // wait for W1_proj gemv
        if (i < n_hidden_heads)
        {
            gemv_wait(s->cq + i * w1proj_nhead_size, w1proj_nhead_size);
        }

        // Compute W3_proj (FPGA)
        if (i < n_hidden_heads)
        {
            QuantizedTensor w3_head = {
                .q = (w->w3 + l)->q + i * (head_size * dim / 2), // int4
                .s = (w->w3 + l)->s + i * head_size,             // per-channel scale
                .dtype = INT4};
            // we spread the q_head in s->cq
            int32_t *x3_head = s->cq + hidden_dim + i * head_size;
            gemv_start(x3_head, &s->xq, &w3_head, dim, w1proj_nhead_size);
        }

        // Compute SwiGLU
        if (i > 0)
        {
            int ii = i - NHEAD_PER_W1PROJ;

            swiglu(s->hb + ii * head_size, s->hb2 + ii * head_size, w1proj_nhead_size);
        }

        // wait for W3_proj gemv
        if (i < n_hidden_heads)
        {
            gemv_wait(s->cq + hidden_dim + i * w1proj_nhead_size, w1proj_nhead_size);
        }
    }

    // Step 2: W2_proj (FPGA)
    quantize_decode_reshape(&s->hq, s->hb, hidden_dim);
    gemv(s->cq, &s->hq, w->w2 + l, hidden_dim, dim);
    dequantize_decode_reshape(s->xb, s->hq.s, (w->w2 + l)->s, s->cq, dim);

    // residual connection
    elementwise_add(x, s->xb, dim);
}

/* Coarse-grained overlapping */
void mlp_decode_v3(Transformer *transformer, int layer, int pos, bool need_bias)
{
    // a few convenience variables
    Config *p = &transformer->config;
    TransformerWeights *w = &transformer->weights;
    RunState *s = &transformer->state;
    float *x = s->x;
    int dim = p->dim;
    int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
    int kv_mul = p->n_heads / p->n_kv_heads; // integer multiplier of the kv sharing in multiquery
    int hidden_dim = p->hidden_dim;
    int head_size = dim / p->n_heads;
    int l = layer;

    // Step 0: rmsnorm + quant + reshape (CPU)
    // ffn rmsnorm
    rmsnorm(s->xb, x, w->rms_ffn_weight + l * dim, dim);
    quantize_decode_reshape(&s->xq, s->xb, dim);

    // Step 1: W1_proj (FPGA)
    gemv(s->cq, &s->xq, w->w1 + l, dim, hidden_dim);

    // Step 2: W3_proj (FPGA), W1_dequ + W1_silu (CPU)
    gemv_start(s->cq2, &s->xq, w->w3 + l, dim, hidden_dim);
    dequantize_decode_reshape(s->hb, s->xq.s, (w->w1 + l)->s, s->cq, hidden_dim);
    silu(s->hb, hidden_dim);
    gemv_wait(s->cq2, hidden_dim);

    // Step 2: W3_dequ + finish SwiGLU (CPU)
    dequantize_decode_reshape(s->hb2, s->xq.s, (w->w3 + l)->s, s->cq2, hidden_dim);
    elementwise_mul(s->hb, s->hb2, hidden_dim);

    // final matmul to get the output of the ffn
    quantize_decode_reshape(&s->hq, s->hb, hidden_dim);
    gemv(s->cq, &s->hq, w->w2 + l, hidden_dim, dim);
    dequantize_decode_reshape(s->xb, s->hq.s, (w->w2 + l)->s, s->cq, dim);

    // residual connection
    elementwise_add(x, s->xb, dim);
}

/* Select the implementation version */

void mha_prefill(Transformer *transformer, int layer, int prompt_token_num, bool need_bias)
{
    mha_prefill_v3(transformer, layer, prompt_token_num, need_bias);
}

void mlp_prefill(Transformer *transformer, int layer, int prompt_token_num, bool need_bias)
{
    mlp_prefill_v3(transformer, layer, prompt_token_num, need_bias);
}

void mha_decode(Transformer *transformer, int layer, int pos, bool need_bias)
{
    mha_decode_v3(transformer, layer, pos, need_bias);
}

void mlp_decode(Transformer *transformer, int layer, int pos, bool need_bias)
{
    mlp_decode_v3(transformer, layer, pos, need_bias);
}