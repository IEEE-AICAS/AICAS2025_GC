#include "cpu.h"
#include "params.h"
#include "profile.h"
#include <stddef.h>
#include <math.h>

#include <stdio.h>
#include <string.h>

void quantize_prefill_reshape(
    QuantizedTensor *qx, const float *x, int seq_len, int dim)
{
    start_segment(OP_QUANTIZE_PREFILL_RESHAPE);
    quantize_reshape(qx, x, seq_len, dim,
                     PREFILL_GRID_PER_BUF, PREFILL_ELEM_PER_GRID);
    end_segment(OP_QUANTIZE_PREFILL_RESHAPE);
}

void quantize_decode_reshape(
    QuantizedTensor *qx, const float *x, int dim)
{
    start_segment(OP_QUANTIZE_DECODE_RESHAPE);
    quantize_reshape(qx, x, 1, dim,
                     DECODE_GRID_PER_BUF, DECODE_ELEM_PER_GRID);
    end_segment(OP_QUANTIZE_DECODE_RESHAPE);
}

void dequantize_prefill_reshape(
    float *c_mat, const const float *as, const float *bs, const int32_t *cq_mat,
    int seq_len, int dim)
{
    start_segment(OP_DEQUANTIZE_PREFILL_RESHAPE);
    dequantize_reshape(c_mat, as, bs, cq_mat, seq_len, dim,
                       PREFILL_GRID_PER_BUF, PREFILL_ELEM_PER_GRID);
    end_segment(OP_DEQUANTIZE_PREFILL_RESHAPE);
}

void dequantize_decode_reshape(
    float *c_vec, const const float *as, const float *bs, const int32_t *cq_vec,
    int dim)
{
    start_segment(OP_DEQUANTIZE_DECODE_RESHAPE);
    dequantize_reshape(c_vec, as, bs, cq_vec, 1, dim,
                       DECODE_GRID_PER_BUF, DECODE_ELEM_PER_GRID);
    end_segment(OP_DEQUANTIZE_DECODE_RESHAPE);
}

void dequantize_embedding_reshape(
    const QuantizedTensor *qw, float *w, int vocab_size, int dim)
{
    const int num_obuf = vocab_size / (WO_GRID_PER_BUF * WO_ELEM_PER_GRID);
    const int num_ibuf = dim / (WI_GRID_PER_BUF * WI_ELEM_PER_GRID);

#pragma omp parallel for collapse(6)
    for (int obuf = 0; obuf < num_obuf; obuf++)
    {
        for (int ibuf = 0; ibuf < num_ibuf; ibuf++)
        {
            for (int ogrid = 0; ogrid < WO_GRID_PER_BUF; ogrid++)
            {
                for (int igrid = 0; igrid < WI_GRID_PER_BUF; igrid++)
                {
                    for (int oelem = 0; oelem < WO_ELEM_PER_GRID; oelem++)
                    {
                        for (int ielem = 0; ielem < WI_ELEM_PER_GRID; ielem++)
                        {

                            int old_idx = obuf;
                            old_idx = old_idx * num_ibuf + ibuf;
                            old_idx = old_idx * WO_GRID_PER_BUF + ogrid;
                            old_idx = old_idx * WI_GRID_PER_BUF + igrid;
                            old_idx = old_idx * WO_ELEM_PER_GRID + oelem;
                            old_idx = old_idx * WI_ELEM_PER_GRID + ielem;

                            int new_idx = obuf;
                            new_idx = new_idx * WO_GRID_PER_BUF + ogrid;
                            new_idx = new_idx * WO_ELEM_PER_GRID + oelem;
                            new_idx = new_idx * num_ibuf + ibuf;
                            new_idx = new_idx * WI_GRID_PER_BUF + igrid;
                            new_idx = new_idx * WI_ELEM_PER_GRID + ielem;

                            int s_idx = obuf;
                            s_idx = s_idx * WO_GRID_PER_BUF + ogrid;
                            s_idx = s_idx * WO_ELEM_PER_GRID + oelem;

                            float val = get_4b(qw->q, old_idx) * qw->s[s_idx];
                            w[new_idx] = val;
                        }
                    }
                }
            }
        }
    }
}

void dequantize_prefill_reshape_swiglu(
    float *c_mat,
    const const float *a1s, const float *b1s, const int32_t *c1q_mat,
    const const float *a2s, const float *b2s, const int32_t *c2q_mat,
    int seq_len, int dim)
{
    dequantize_reshape_swiglu(
        c_mat, a1s, b1s, c1q_mat,
        a2s, b2s, c2q_mat, seq_len, dim,
        PREFILL_GRID_PER_BUF, PREFILL_ELEM_PER_GRID);
}

void dequantize_decode_reshape_swiglu(
    float *c_vec,
    const const float *a1s, const float *b1s, const int32_t *c1q_vec,
    const const float *a2s, const float *b2s, const int32_t *c2q_vec,
    int dim)
{
    dequantize_reshape_swiglu(
        c_vec, a1s, b1s, c1q_vec,
        a2s, b2s, c2q_vec, 1, dim,
        DECODE_GRID_PER_BUF, DECODE_ELEM_PER_GRID);
}

/* Interface for exp function */
inline float fast_exp(float x)
{
#ifdef FAST_EXP_11F
    return fast_exp_11f(x);
#elif FAST_EXP_21F
    return fast_exp_21f(x);
#else
    return expf(x);
#endif
}

/* From Moroz  Simple Multiple Precision Algorithms for Exponential Functions
   max. rel. error <= 2.98e-2 (good enough for softmax) */
inline float fast_exp_11f(float x)
{
    int z = x * 0xb8aa3b + 0x3f7a68c7;
    float y = *(float *)&z;
    return y;
}

/*  From Moroz  Simple Multiple Precision Algorithms for Exponential Functions
    exp_21f, max. rel. error <= 1.73e-3 */
inline float fast_exp_21f(float x)
{
    int z = x * 0x00b8aa3b + 0x3f800000;
    int zii = z & 0x7f800000;
    int zif = z & 0x007fffff;
    float d1 = 0.40196114e-7f;
    float d2 = 0xf94ee7 + zif;
    float d3 = 0x560e + zif;
    d2 = d1 * d2;
    zif = d2 * d3;
    zii |= zif;
    float y = *(float *)&zii;
    return y;
}

/* Interface for fast sigmoid function */
inline float fast_sigmoid(float v)
{
#ifdef FAST_SIGMOID_STACKOVERFLOW
    return fast_sigmoid_stackoverflow(v);
#elif FAST_SIGMOID_EXP
    return (1.0f / (1.0f + fast_exp(-v)));
#else
    return (1.0f / (1.0f + expf(-v)));
#endif
}

/* From stack-overflow: fast-sigmoid-algorithm
   A highly accurate version with max rel. error <= 6.55651e-07
   Similar performance with using fast_exp_11f
*/
inline float fast_sigmoid_stackoverflow(float v)
{
    const float c1 = 0.03138777F;
    const float c2 = 0.276281267F;
    const float c_log2f = 1.442695022F;
    v *= c_log2f * 0.5;
    int intPart = (int)v;
    float x = (v - intPart);
    float xx = x * x;
    float v1 = c_log2f + c2 * xx;
    float v2 = x + xx * c1 * x;
    float v3 = (v2 + v1);
    *((int *)&v3) += intPart << 24;
    float v4 = v2 - v1;
    float res = v3 / (v3 - v4); // for tanh change to (v3 + v4)/ (v3 - v4)
    return res;
}

void rmsnorm(float *o, float *x, float *weight, int size)
{
    // calculate sum of squares
    float ss = 0.0f;
    for (int j = 0; j < size; j++)
    {
        ss += x[j] * x[j];
    }
    ss /= size;
    ss += 1e-6f;
    ss = 1.0f / sqrtf(ss);
    // normalize and scale
    for (int j = 0; j < size; j++)
    {
        o[j] = weight[j] * (ss * x[j]);
    }
}

void softmax(float *x, int size)
{
    // find max value (for numerical stability)
    float max_val = x[0];
    for (int i = 1; i < size; i++)
    {
        if (x[i] > max_val)
        {
            max_val = x[i];
        }
    }
    // exp and sum
    float sum = 0.0f;
    for (int i = 0; i < size; i++)
    {
        // x[i] = expf(x[i] - max_val);
        x[i] = fast_exp(x[i] - max_val);
        sum += x[i];
    }
    // normalize
    for (int i = 0; i < size; i++)
    {
        x[i] /= sum;
    }
}

void softmax_casual(float *att, int prompt_token_num)
{
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        float *att_pos = att + pos * prompt_token_num;
        // printf("\npos = %d\n", pos);
        softmax(att_pos, pos + 1);
        for (int t = pos + 1; t < prompt_token_num; t++)
        {
            att_pos[t] = 0.0f;
        }
    }
}

void softmax_casual_triangle(float *att, int prompt_token_num)
{
    for (int pos = 0; pos < prompt_token_num; pos++)
    {
        float *att_pos = att + pos * prompt_token_num;
        softmax(att_pos, pos + 1);
    }
}

void elementwise_add(float *x, float *y, int size)
{
    for (int i = 0; i < size; i++)
    {
        x[i] += y[i];
    }
}

static float fci_tab[MAX_SEQ_LEN * HEAD_SIZE / 2] = {0};
static float fcr_tab[MAX_SEQ_LEN * HEAD_SIZE / 2] = {0};

void init_rope(int head_size)
{
#ifdef ROPE_PRECOMPUTE
    for (int pos = 0; pos < MAX_SEQ_LEN; pos++)
    {
        for (int head_dim = 0; head_dim < head_size / 2; head_dim++)
        {
            float freq =
                1.0f / powf(1000000.0f, (float)(head_dim * 2) / (float)HEAD_SIZE);
            float val = pos * freq;
            float fci = sinf(val);
            float fcr = cosf(val);
            fci_tab[pos * HEAD_SIZE / 2 + head_dim] = fci;
            fcr_tab[pos * HEAD_SIZE / 2 + head_dim] = fcr;
        }
    }
#endif
}


void rope(float *q, float *k, int dim, int head_size, int n_kv_heads, int pos)
{
    for (int i = 0; i < dim; i += head_size)
    {
        for (int head_dim = i % head_size; head_dim < head_size / 2; head_dim++)
        {
#ifndef ROPE_PRECOMPUTE
            float freq =
                1.0f / powf(1000000.0f, (float)(head_dim * 2) / (float)head_size);
            float val = pos * freq;
            float fci = sinf(val);
            float fcr = cosf(val);
#else
            float fci = fci_tab[pos * head_size / 2 + head_dim];
            float fcr = fcr_tab[pos * head_size / 2 + head_dim];
#endif

            float q0 = q[i + head_dim];
            float q1 = q[i + head_dim + head_size / 2];
            q[i + head_dim] = q0 * fcr - q1 * fci;
            q[i + head_dim + head_size / 2] = q0 * fci + q1 * fcr;
            if (i < n_kv_heads * head_size)
            {
                float k0 = k[i + head_dim];
                float k1 = k[i + head_dim + head_size / 2];
                k[i + head_dim] = k0 * fcr - k1 * fci;
                k[i + head_dim + head_size / 2] = k0 * fci + k1 * fcr;
            }
        }
    }
}

/* head-wise rope for q_head or v_head separately */
void rope_head(float *head, int head_size, int n_heads, int pos)
{
    const int dim = n_heads * head_size;

    for (int i = 0; i < dim; i += head_size)
    {
        for (int head_dim = 0; head_dim < head_size / 2; head_dim++)
        {
            float freq =
                1.0f / powf(1000000.0f, (float)(head_dim * 2) / (float)head_size);
            float val = pos * freq;
            float fci = sinf(val);
            float fcr = cosf(val);

            float h0 = head[i + head_dim];
            float h1 = head[i + head_dim + head_size / 2];
            head[i + head_dim] = h0 * fcr - h1 * fci;
            head[i + head_dim + head_size / 2] = h0 * fci + h1 * fcr;
        }
    }
}

void swiglu(float *hb, float *hb2, int hidden_dim)
{
    for (int i = 0; i < hidden_dim; i++)
    {
        float val = hb[i];
        // silu(x)=x*σ(x), where σ(x) is the logistic sigmoid
        // val *= (1.0f / (1.0f + expf(-val)));
        val *= fast_sigmoid(val);
        // elementwise multiply with w3(x)
        val *= hb2[i];
        hb[i] = val;
    }
}

inline float dequant_swiglu(
    float a1s, float b1s, int32_t c1q,
    float a2s, float b2s, int32_t c2q)
{
    float val = (float)c1q * a1s * b1s;
    val *= fast_sigmoid(val);
    val *= (float)c2q * a2s * b2s;
    return val;
}

void silu(float *hb, int hidden_dim)
{
    for (int i = 0; i < hidden_dim; i++)
    {
        float val = hb[i];
        // silu(x)=x*σ(x), where σ(x) is the logistic sigmoid
        // val *= (1.0f / (1.0f + expf(-val)));
        val *= fast_sigmoid(val);
        hb[i] = val;
    }
}

void elementwise_mul(float *x, float *y, int size)
{
    for (int i = 0; i < size; i++)
    {
        x[i] *= y[i];
    }
}

void cpu_map_quantized_weight(void **ptr, int8_t **q, size_t size)
{
    *q = (int8_t *)*ptr;
    *ptr = (int8_t *)*ptr + size;
}

void cpu_gemv_w4a8(
    uint32_t C_N, uint32_t C_K,
    const int8_t *xq_vec, const int8_t *wq_mat, int32_t *cq_vec)
{
    cpu_w4a8(
        1, C_N, C_K,
        xq_vec, wq_mat, cq_vec,
        DECODE_GRID_PER_BUF, DECODE_ELEM_PER_GRID);
}

void cpu_gemm_w4a8(
    uint32_t C_M, uint32_t C_N, uint32_t C_K,
    const int8_t *aq_mat, const int8_t *bq_mat, int32_t *cq_mat)
{
    cpu_w4a8(
        C_M, C_N, C_K,
        aq_mat, bq_mat, cq_mat,
        PREFILL_GRID_PER_BUF, PREFILL_ELEM_PER_GRID);
}

/* CPU kernel for QGemv */
void gemv_v3_kernel_cpu(
    const int8_t *aq_buf, const int8_t *bq_buf, int32_t *cq_buf)
{
    v3_kernel_cpu(aq_buf, bq_buf, cq_buf,
                  DECODE_GRID_PER_BUF, DECODE_ELEM_PER_GRID);
}

/* CPU kernel for QGemm */
void gemm_v3_kernel_cpu(
    const int8_t *aq_buf, const int8_t *bq_buf, int32_t *cq_buf)
{
    v3_kernel_cpu(aq_buf, bq_buf, cq_buf,
                  PREFILL_GRID_PER_BUF, PREFILL_ELEM_PER_GRID);
}

void gemv_reshape_active_for_fpga(
    const int8_t *src, int8_t *dst, int seq_len, int dim)
{
    reshape_for_fpga(src, dst, seq_len, dim, set_8b, get_8b,
                     DECODE_GRID_PER_BUF, DECODE_ELEM_PER_GRID,
                     WI_GRID_PER_BUF, WI_ELEM_PER_GRID);
}

void gemm_reshape_active_for_fpga(
    const int8_t *src, int8_t *dst, int seq_len, int dim)
{
    reshape_for_fpga(src, dst, seq_len, dim, set_8b, get_8b,
                     PREFILL_GRID_PER_BUF, PREFILL_ELEM_PER_GRID,
                     WI_GRID_PER_BUF, WI_ELEM_PER_GRID);
}

void cpu_w4a8(
    uint32_t C_M, uint32_t C_N, uint32_t C_K,
    const int8_t *aq_mat, const int8_t *bq_mat, int32_t *cq_mat,
    const int grid_per_buf, const int elem_per_grid)
{
    const int aq_buf_size = grid_per_buf * elem_per_grid * WI_GRID_PER_BUF * WI_ELEM_PER_GRID;
    const int bq_buf_size = WO_GRID_PER_BUF * WI_GRID_PER_BUF * WO_ELEM_PER_GRID * WI_ELEM_PER_GRID / 2;
    const int cq_buf_size = grid_per_buf * elem_per_grid * WO_GRID_PER_BUF * WO_ELEM_PER_GRID;

// compute 1 output buffer at a time
#pragma omp parallel for collapse(2)
    for (int sbuf = 0; sbuf < C_M; sbuf++)
    {
        for (int obuf = 0; obuf < C_N; obuf++)
        {
            const int cq_buf_offset = (sbuf * C_N + obuf) * cq_buf_size;
            memset(cq_mat + cq_buf_offset, 0, cq_buf_size * sizeof(int32_t));
            for (int hbuf = 0; hbuf < C_K; hbuf++)
            {
                // use v3 kernel to compute one of the partial sum of C buffer
                const int aq_buf_offset = (sbuf * C_K + hbuf) * aq_buf_size;
                const int bq_buf_offset = (obuf * C_K + hbuf) * bq_buf_size;
                v3_kernel_cpu(
                    aq_mat + aq_buf_offset, bq_mat + bq_buf_offset, cq_mat + cq_buf_offset,
                    grid_per_buf, elem_per_grid);
            }
        }
    }
}

void v3_kernel_cpu(
    const int8_t *aq_buf, const int8_t *bq_buf, int32_t *cq_buf,
    const int grid_per_buf, const int elem_per_grid)
{
    // aq_buf (GRID_PER_BUF * WI_GRID_PER_BUF * ELEM_PER_GRID * WI_ELEM_PER_GRID)
    // bq_buf (WO_GRID_PER_BUF * WI_GRID_PER_BUF * WO_ELEM_PER_GRID * WI_ELEM_PER_GRID / 2)
    // cq_buf (GRID_PER_BUF * WO_GRID_PER_BUF * ELEM_PER_GRID * WO_ELEM_PER_GRID)
    // Notice that each element in cq_buf has a different scaling factor
    for (int sgrid = 0; sgrid < grid_per_buf; sgrid++)
    {
        for (int ogrid = 0; ogrid < WO_GRID_PER_BUF; ogrid++)
        {
            for (int selem = 0; selem < elem_per_grid; selem++)
            {
                for (int oelem = 0; oelem < WO_ELEM_PER_GRID; oelem++)
                {

                    int32_t sum = 0;

                    for (int igrid = 0; igrid < WI_GRID_PER_BUF; igrid++)
                    {
                        for (int ielem = 0; ielem < WI_ELEM_PER_GRID; ielem++)
                        {

                            int aq_idx = sgrid;
                            aq_idx = aq_idx * WI_GRID_PER_BUF + igrid;
                            aq_idx = aq_idx * elem_per_grid + selem;
                            aq_idx = aq_idx * WI_ELEM_PER_GRID + ielem;

                            int bq_idx = ogrid;
                            bq_idx = bq_idx * WI_GRID_PER_BUF + igrid;
                            bq_idx = bq_idx * WO_ELEM_PER_GRID + oelem;
                            bq_idx = bq_idx * WI_ELEM_PER_GRID + ielem;

                            sum += ((int32_t)aq_buf[aq_idx]) * ((int32_t)get_4b(bq_buf, bq_idx));
                        }
                    }

                    // update the result to C grid
                    const int cq_offset = sgrid * WO_GRID_PER_BUF + ogrid;
                    int32_t *cq_grid = cq_buf + cq_offset * elem_per_grid * WO_ELEM_PER_GRID;
                    int cq_idx = selem * WO_ELEM_PER_GRID + oelem;
                    cq_grid[cq_idx] += sum;
                }
            }
        }
    }
}

void quantize_reshape(
    QuantizedTensor *qx, const float *x, int seq_len, int dim,
    const int seq_grid_per_buf, const int seq_elem_per_grid)
{
    const float Q_MAX = 127.0f;

    const int num_sbuf = seq_len / (seq_grid_per_buf * seq_elem_per_grid);
    const int num_hbuf = dim / (WI_GRID_PER_BUF * WI_ELEM_PER_GRID);

#pragma omp parallel for collapse(3)
    for (int sbuf = 0; sbuf < num_sbuf; sbuf++)
    {
        for (int sgrid = 0; sgrid < seq_grid_per_buf; sgrid++)
        {
            for (int selem = 0; selem < seq_elem_per_grid; selem++)
            {

                // find the max absolute value in the current channel
                float wmax = 0.0;

                for (int hbuf = 0; hbuf < num_hbuf; hbuf++)
                {
                    for (int hgrid = 0; hgrid < WI_GRID_PER_BUF; hgrid++)
                    {
                        for (int helem = 0; helem < WI_ELEM_PER_GRID; helem++)
                        {
                            int idx = sbuf;
                            idx = idx * seq_grid_per_buf + sgrid;
                            idx = idx * seq_elem_per_grid + selem;
                            idx = idx * num_hbuf + hbuf;
                            idx = idx * WI_GRID_PER_BUF + hgrid;
                            idx = idx * WI_ELEM_PER_GRID + helem;
                            float val = fabsf(x[idx]);
                            wmax = fmaxf(wmax, val);
                        }
                    }
                }

                // calculate and write the scaling factor
                float scale = wmax / Q_MAX;
                int scale_idx = sbuf;
                scale_idx = scale_idx * seq_grid_per_buf + sgrid;
                scale_idx = scale_idx * seq_elem_per_grid + selem;
                qx->s[scale_idx] = scale;

                // calculate and write the quantized values
                for (int hbuf = 0; hbuf < num_hbuf; hbuf++)
                {
                    for (int hgrid = 0; hgrid < WI_GRID_PER_BUF; hgrid++)
                    {
                        for (int helem = 0; helem < WI_ELEM_PER_GRID; helem++)
                        {
                            int old_idx = sbuf;
                            old_idx = old_idx * seq_grid_per_buf + sgrid;
                            old_idx = old_idx * seq_elem_per_grid + selem;
                            old_idx = old_idx * num_hbuf + hbuf;
                            old_idx = old_idx * WI_GRID_PER_BUF + hgrid;
                            old_idx = old_idx * WI_ELEM_PER_GRID + helem;

                            int new_idx = sbuf;
                            new_idx = new_idx * num_hbuf + hbuf;
                            new_idx = new_idx * seq_grid_per_buf + sgrid;
                            new_idx = new_idx * WI_GRID_PER_BUF + hgrid;
                            new_idx = new_idx * seq_elem_per_grid + selem;
                            new_idx = new_idx * WI_ELEM_PER_GRID + helem;

                            float quant_value = x[old_idx] / scale;        // scale
                            int8_t quantized = (int8_t)round(quant_value); // round and clamp
                            qx->q[new_idx] = quantized;
                        }
                    }
                }
            }
        }
    }
}

void dequantize_reshape(
    float *c, const float *as, const float *bs, const int32_t *cq_mat,
    int seq_len, int dim, const int seq_grid_per_buf, const int seq_elem_per_grid)
{
    const int num_sbuf = seq_len / (seq_grid_per_buf * seq_elem_per_grid);
    const int num_obuf = dim / (WO_GRID_PER_BUF * WO_ELEM_PER_GRID);

#pragma omp parallel for collapse(4)
    for (int sbuf = 0; sbuf < num_sbuf; sbuf++)
    {
        for (int sgrid = 0; sgrid < seq_grid_per_buf; sgrid++)
        {
            for (int selem = 0; selem < seq_elem_per_grid; selem++)
            {
                for (int obuf = 0; obuf < num_obuf; obuf++)
                {
                    for (int ogrid = 0; ogrid < WO_GRID_PER_BUF; ogrid++)
                    {
                        for (int oelem = 0; oelem < WO_ELEM_PER_GRID; oelem++)
                        {

                            int cq_idx = sbuf;
                            cq_idx = cq_idx * num_obuf + obuf;
                            cq_idx = cq_idx * seq_grid_per_buf + sgrid;
                            cq_idx = cq_idx * WO_GRID_PER_BUF + ogrid;
                            cq_idx = cq_idx * seq_elem_per_grid + selem;
                            cq_idx = cq_idx * WO_ELEM_PER_GRID + oelem;

                            int c_idx = sbuf;
                            c_idx = c_idx * seq_grid_per_buf + sgrid;
                            c_idx = c_idx * seq_elem_per_grid + selem;
                            c_idx = c_idx * num_obuf + obuf;
                            c_idx = c_idx * WO_GRID_PER_BUF + ogrid;
                            c_idx = c_idx * WO_ELEM_PER_GRID + oelem;

                            int as_idx = sbuf;
                            as_idx = sbuf * seq_grid_per_buf + sgrid;
                            as_idx = as_idx * seq_elem_per_grid + selem;

                            int bs_idx = obuf;
                            bs_idx = obuf * WO_GRID_PER_BUF + ogrid;
                            bs_idx = bs_idx * WO_ELEM_PER_GRID + oelem;

                            c[c_idx] = ((float)cq_mat[cq_idx]) * as[as_idx] * bs[bs_idx];
                        }
                    }
                }
            }
        }
    }
}

void dequantize_reshape_swiglu(
    float *c,
    const float *a1s, const float *b1s, const int32_t *c1q,
    const float *a2s, const float *b2s, const int32_t *c2q,
    int seq_len, int dim, const int seq_grid_per_buf, const int seq_elem_per_grid)
{
    const int num_sbuf = seq_len / (seq_grid_per_buf * seq_elem_per_grid);
    const int num_obuf = dim / (WO_GRID_PER_BUF * WO_ELEM_PER_GRID);

#pragma omp parallel for collapse(4)
    for (int sbuf = 0; sbuf < num_sbuf; sbuf++)
    {
        for (int sgrid = 0; sgrid < seq_grid_per_buf; sgrid++)
        {
            for (int selem = 0; selem < seq_elem_per_grid; selem++)
            {
                for (int obuf = 0; obuf < num_obuf; obuf++)
                {
                    for (int ogrid = 0; ogrid < WO_GRID_PER_BUF; ogrid++)
                    {
                        for (int oelem = 0; oelem < WO_ELEM_PER_GRID; oelem++)
                        {

                            int cq_idx = sbuf;
                            cq_idx = cq_idx * num_obuf + obuf;
                            cq_idx = cq_idx * seq_grid_per_buf + sgrid;
                            cq_idx = cq_idx * WO_GRID_PER_BUF + ogrid;
                            cq_idx = cq_idx * seq_elem_per_grid + selem;
                            cq_idx = cq_idx * WO_ELEM_PER_GRID + oelem;

                            int c_idx = sbuf;
                            c_idx = c_idx * seq_grid_per_buf + sgrid;
                            c_idx = c_idx * seq_elem_per_grid + selem;
                            c_idx = c_idx * num_obuf + obuf;
                            c_idx = c_idx * WO_GRID_PER_BUF + ogrid;
                            c_idx = c_idx * WO_ELEM_PER_GRID + oelem;

                            int as_idx = sbuf;
                            as_idx = sbuf * seq_grid_per_buf + sgrid;
                            as_idx = as_idx * seq_elem_per_grid + selem;

                            int bs_idx = obuf;
                            bs_idx = obuf * WO_GRID_PER_BUF + ogrid;
                            bs_idx = bs_idx * WO_ELEM_PER_GRID + oelem;

                            c[c_idx] = dequant_swiglu(
                                a1s[as_idx], b1s[bs_idx], c1q[cq_idx],
                                a2s[as_idx], b2s[bs_idx], c2q[cq_idx]);
                        }
                    }
                }
            }
        }
    }
}

void reshape_for_fpga(
    const int8_t *src, int8_t *dst, int M, int N,
    set_fn_t set_fn, get_fn_t get_fn,
    const int m_grid_per_buf, const int m_elem_per_grid,
    const int n_grid_per_buf, const int n_elem_per_grid)
{
    const int num_sbuf = M / (m_grid_per_buf * m_elem_per_grid);
    const int num_hbuf = N / (n_grid_per_buf * n_elem_per_grid);

    for (int sbuf = 0; sbuf < num_sbuf; sbuf++)
    {
        for (int sgrid = 0; sgrid < m_grid_per_buf; sgrid++)
        {
            for (int selem = 0; selem < m_elem_per_grid; selem++)
            {
                for (int hbuf = 0; hbuf < num_hbuf; hbuf++)
                {
                    for (int hgrid = 0; hgrid < n_grid_per_buf; hgrid++)
                    {
                        for (int helem = 0; helem < n_elem_per_grid; helem++)
                        {
                            int old_idx = sbuf;
                            old_idx = old_idx * m_grid_per_buf + sgrid;
                            old_idx = old_idx * m_elem_per_grid + selem;
                            old_idx = old_idx * num_hbuf + hbuf;
                            old_idx = old_idx * n_grid_per_buf + hgrid;
                            old_idx = old_idx * n_elem_per_grid + helem;

                            int new_idx = sbuf;
                            new_idx = new_idx * num_hbuf + hbuf;
                            new_idx = new_idx * m_grid_per_buf + sgrid;
                            new_idx = new_idx * n_grid_per_buf + hgrid;
                            new_idx = new_idx * m_elem_per_grid + selem;
                            new_idx = new_idx * n_elem_per_grid + helem;

                            int8_t value = get_fn(src, old_idx);
                            set_fn(dst, new_idx, value);
                        }
                    }
                }
            }
        }
    }
}

inline void pack(int8_t *package, int offset, int8_t value)
{
    *package = (*package & (0x0F << (4 * !offset))) | ((value & 0x0F) << (4 * !!offset));
    // if (offset)
    // {
    //     *package = (*package & 0b00001111) | ((value & 0b00001111) << 4);
    // }
    // else
    // {
    //     *package = (*package & 0b11110000) | (value & 0b00001111);
    // }
}

inline int8_t unpack(int8_t package, int offset)
{
    // uint8_t shift = 4 * (1 - index);
    // int8_t res = (x << shift) >> 4;
    int8_t res = 0;
    if (offset)
    {
        res = package >> 4;
    }
    else
    {
        int8_t lower = package & 0b00001111;
        if (lower & 0b1000)
        {
            lower = lower | 0b11110000;
        }
        res = lower;
    }
    // if (!(res >= -8 && res <= 7)) {
    //   printf("unpacking error: %d %d %d\n", x, index, res);
    //   assert(0);
    // }
    return res;
}

inline void set_4b(int8_t *arr, int index, int8_t value)
{
    pack(&arr[index / 2], index % 2, value);
}

inline int8_t get_4b(const int8_t *arr, int index)
{
    return unpack(arr[index / 2], index % 2);
}

inline void set_8b(int8_t *arr, int index, int8_t value)
{
    arr[index] = value;
}

inline int8_t get_8b(const int8_t *arr, int index)
{
    return arr[index];
}

void quantize_4b_fake(float *a, int row, int col, int lc)
{
    float c_max[128] = {0};
    const float Q_MAX = 7.0f;
    for (int i = 0; i < row; i++)
    {
        for (int j = 0; j < col; j++)
        {
            int idx = i * lc + j;
            float abs_v = fabsf(a[idx]);
            c_max[j] = fmaxf(c_max[j], abs_v);
        }
    }
    for (int i = 0; i < row; i++)
    {
        float rmax = 0.0f;
        for (int j = 0; j < col; j++)
        {
            int idx = i * lc + j;
            float val = fabsf(a[idx] / sqrtf(c_max[j]));
            rmax = fmaxf(rmax, val);
        }
        float scale = rmax / Q_MAX;
        for (int j = 0; j < col; j++)
        {
            int idx = i * lc + j;
            float quant_value = a[idx] / scale;
            int8_t quantized = (int8_t)round(quant_value);
            float fake_value = (float)quantized * scale * sqrtf(c_max[j]);
            a[idx] = fake_value;
        }
    }
}

void quantize_8b_fake(float *a, int row, int col, int lc)
{
    const float Q_MAX = 127.0f;
    for (int i = 0; i < row; i++)
    {
        float rmax = 0.0f;
        for (int j = 0; j < col; j++)
        {
            int idx = i * lc + j;
            float val = fabsf(a[idx]);
            rmax = fmaxf(rmax, val);
        }
        float scale = rmax / Q_MAX;
        for (int j = 0; j < col; j++)
        {
            int idx = i * lc + j;
            float quant_value = a[idx] / scale;
            int8_t quantized = (int8_t)round(quant_value);
            float fake_value = (float)quantized * scale;
            a[idx] = fake_value;
        }
    }
}
