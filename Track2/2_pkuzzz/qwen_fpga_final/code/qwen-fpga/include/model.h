#ifndef _MODEL_H
#define _MODEL_H

#include <stdint.h>
#include <unistd.h>


typedef struct
{
    int8_t *q; // quantized values
    float *s;  // scaling factors
    enum
    {
        INT8 = 0,
        INT4 = 1
    } dtype;
} QuantizedTensor;

typedef struct {
    int dim;        // transformer dimension
    int hidden_dim; // for ffn layers
    int n_layers;   // number of layers
    int n_heads;    // number of query heads
    int n_kv_heads; // number of key/value heads (can be < query heads because of multiquery)
    int vocab_size; // vocabulary size, usually 4096 (byte-level)
    int seq_len;    // max sequence length
  } Config;
  
  typedef struct {
    // token embedding table
    QuantizedTensor *q_tokens;    // (vocab_size, dim)
    float *token_embedding_table; // (vocab_size, dim)
    // weights for rmsnorms
    float *rms_att_weight; // (layer, dim) rmsnorm weights
    float *rms_ffn_weight; // (layer, dim)
    // weights for matmuls. note dim == n_heads * head_size
    QuantizedTensor *wq; // (layer, dim, n_heads * head_size)
    QuantizedTensor *wk; // (layer, dim, n_kv_heads * head_size)
    QuantizedTensor *wv; // (layer, dim, n_kv_heads * head_size)
    QuantizedTensor *wo; // (layer, n_heads * head_size, dim)
    // bias
    float *bq;  // p->n_heads * head_size
    float *bk;  // p->n_kv_heads * head_size
    float *bv;  // p->n_kv_heads * head_size
    // weights for ffn
    QuantizedTensor *w1; // (layer, hidden_dim, dim)
    QuantizedTensor *w2; // (layer, dim, hidden_dim)
    QuantizedTensor *w3; // (layer, hidden_dim, dim)
    // final rmsnorm
    float *rms_final_weight; // (dim,)
    // (optional) classifier weights for the logits, on the last layer
    QuantizedTensor *wcls;
  } TransformerWeights;
  
  typedef struct {
    // current wave of activations
    float *x;      // activation at current time stamp (seq_len, dim,) for prefill, (dim,) for forward
    float *xb;     // same, but inside a residual branch (seq_len, dim,) for prefill, (dim,) for forward
    float *xb2;    // an additional buffer just for convenience (seq_len, dim,) for prefill, (dim,) for forward
    float *hb;     // buffer for hidden dimension in the ffn (seq_len, hidden_dim,) for prefill, (hidden_dim,) for forward
    float *hb2;    // buffer for hidden dimension in the ffn (seq_len, hidden_dim,) for prefill, (hidden_dim,) for forward
    QuantizedTensor xq; // quantized x (seq_len, dim,) for prefill, (dim,) for forward
    QuantizedTensor hq; // quantized hb (seq_len, hidden_dim,) for prefill, (hidden_dim,) for forward
    float *q;      // query (seq_len, dim,) for prefill, (dim,) for forward
    float *k;      // key (dim,)
    float *v;      // value (dim,)
    float *att;    // buffer for scores/attention values (n_heads, seq_len, seq_len)
    float *logits; // output logits
    // kv cache
    float *key_cache;   // (layer, seq_len, kv_dim)
    float *value_cache; // (layer, seq_len, kv_dim)
    int32_t *cq;    // an additional buffer for the quantized output of the matmul (seq_len, hidden_dim) for prefill, (dim,) for forward
    int32_t *cq2;    // an additional buffer for the quantized output of the matmul (seq_len, hidden_dim) for prefill, (dim,) for forward
    // flash attention
    float *fa_s;   // (num_heads, FA_Q_BLOCK_SIZE, FA_K_BLOCK_SIZE) to store attention block
    float *fa_o;   // (num_heads, FA_Q_BLOCK_SIZE, head_size) to store output results
    float *fa_pv;  // (num_heads, FA_Q_BLOCK_SIZE, head_size) to store P @ V results
  } RunState;
  
  typedef struct {
    Config config;              // the hyperparameters of the architecture (the blueprint)
    TransformerWeights weights; // the weights of the model
    RunState state;             // buffers for the "wave" of activations in the forward pass
    // some more state needed to properly clean up the memory mapping (sigh)
    int fd;            // file descriptor for memory mapping
    float *data;       // memory mapped data pointer
    ssize_t file_size; // size of the checkpoint file in bytes
  } Transformer;

#endif // _MODEL_H