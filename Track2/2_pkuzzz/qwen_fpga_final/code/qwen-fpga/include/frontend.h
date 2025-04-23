#ifndef _FRONTEND_H
#define _FRONTEND_H

/* 
    Frontend operators for `runq.c`
    We use the operators with multiple backend implementations from `ir.h`,
    and other operators with cpu-only implementations.
*/

#include <stdbool.h>

#include "model.h"
#include "ir.h"
#include "cpu.h"

void token_attn(float *q, float *att, float *k, float *v, float *xb, int pos, int kv_dim, int head_size);

void prefill_attn(float *q, float *att, float *k, float *v, float *xb, int prompt_token_num, int dim, int kv_dim, int head_size);

void mha_prefill(Transformer *transformer, int layer, int prompt_token_num, bool need_bias);

void mlp_prefill(Transformer *transformer, int layer, int prompt_token_num, bool need_bias);

void mlp_decode(Transformer *transformer, int layer, int pos, bool need_bias);

void mha_decode(Transformer *transformer, int layer, int pos, bool need_bias);


#endif // _FRONTEND_H