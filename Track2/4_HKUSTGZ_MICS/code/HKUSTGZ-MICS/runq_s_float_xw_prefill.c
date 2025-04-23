/* Inference for Llama-3 Transformer model in pure C, int8 quantized forward
 * pass. */

#include <ctype.h>
#include <fcntl.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#if defined _WIN32
#include "win.h"
#else
#include <sys/mman.h>
#include <unistd.h>
#endif
#include <stdbool.h>

// #include <stdio.h>
// #include <stdlib.h>
// #include <string.h>
#include <inttypes.h>
// #include <time.h>
#include "pynq_api.h"

//  #define A0020000 0xA0020000 // 32 * 896 int8 矩阵地址
//  #define A0040000 0xA0040000 // 896 * 64 int8 矩阵地址
//  #define A0030000 0xA0030000 // 32 * 64 int32 矩阵地址
//  #define B0000000 0XB0000000 // 64 * int 32 Register 访问
//  #define A0060000 0xA0060000 // scale Buffer地址

// pre03241
//   #define A0020000 0xA0020000  // act int8 矩阵地址
//  #define A0040000 0x80040000  // weight int8 矩阵地址
//  #define A0030000 0x80030000  // result int32 矩阵地址
//  #define A0060000 0xA0060000  // scale Buffer地址
//  #define B0000000 0XB0000000  // 64 * int 32 Register 访问

// pre03261
#define A0020000 0xA0020000
#define A0040000 0x80040000
#define A0030000 0xB0030000
#define A0060000 0xA0060000
#define B0000000 0XA0000000

#define ROWS_A 128
#define COLS_A 1
#define ROWS_B 128
#define COLS_B 128

// ----------------------------------------------------------------------------
// Globals
int GS = 128;  // group size global for quantization of the weights

// ----------------------------------------------------------------------------
// Transformer model

typedef struct {
  int dim;         // transformer dimension
  int hidden_dim;  // for ffn layers
  int n_layers;    // number of layers
  int n_heads;     // number of query heads //14
  int n_kv_heads;  // number of key/value heads (can be < query heads because of
                   // multiquery) //2
  int vocab_size;  // vocabulary size, usually 4096 (byte-level)
  int seq_len;     // max sequence length
} Config;

typedef struct {
  int8_t *q;  // quantized values
  float *s;   // scaling factors // s[0-6]group
} QuantizedTensor;

typedef struct {
  // token embedding table
  QuantizedTensor *q_tokens;     // (vocab_size, dim)
  float *token_embedding_table;  // same, but dequantized

  // weights for rmsnorms
  float *rms_att_weight;  // (layer, dim) rmsnorm weights
  float *rms_ffn_weight;  // (layer, dim)
  // weights for matmuls. note dim == n_heads * head_size
  QuantizedTensor *wq;  // (layer, dim, n_heads * head_size)
  QuantizedTensor *wk;  // (layer, dim, n_kv_heads * head_size)
  QuantizedTensor *wv;  // (layer, dim, n_kv_heads * head_size)
  QuantizedTensor *wo;  // (layer, n_heads * head_size, dim)
  // weights for ffn
  QuantizedTensor *w1;  // (layer, hidden_dim, dim)
  QuantizedTensor *w2;  // (layer, dim, hidden_dim)
  QuantizedTensor *w3;  // (layer, hidden_dim, dim)
  // final rmsnorm
  float *rms_final_weight;  // (dim,)
  // (optional) classifier weights for the logits, on the last layer
  QuantizedTensor *wcls;
  // (optional) bias values
  QuantizedTensor *bq;  // (layer, n_heads * head_size)
  QuantizedTensor *bk;  // (layer, n_kv_heads * head_size)
  QuantizedTensor *bv;  // (layer, n_kv_heads * head_size)
  float *dbq;
  float *dbk;
  float *dbv;
} TransformerWeights;

typedef struct {
  // current wave of activations
  float *x;            // activation at current time stamp (dim,)
  float *xb;           // same, but inside a residual branch (dim,)
  float *xb2;          // an additional buffer just for convenience (dim,)
  float *hb;           // buffer for hidden dimension in the ffn (hidden_dim,)
  float *hb2;          // buffer for hidden dimension in the ffn (hidden_dim,)
  QuantizedTensor xq;  // quantized x (dim,)
  QuantizedTensor hq;  // quantized hb (hidden_dim,)
  float *q;            // query (dim,)
  float *k;            // key (dim,)
  float *v;            // value (dim,)
  float *att;          // buffer for scores/attention values (n_heads, seq_len)
  float *logits;       // output logits
  // kv cache
  float *key_cache;    // (layer, seq_len, dim)
  float *value_cache;  // (layer, seq_len, dim)

  QuantizedTensor xq0;
} RunState;

typedef struct {
  Config config;  // the hyperparameters of the architecture (the blueprint)
  TransformerWeights weights;  // the weights of the model
  RunState state;  // buffers for the "wave" of activations in the forward pass
  // some more state needed to properly clean up the memory mapping (sigh)
  int fd;             // file descriptor for memory mapping
  float *data;        // memory mapped data pointer
  ssize_t file_size;  // size of the checkpoint file in bytes
} Transformer;

// void malloc_run_state(RunState *s, Config *p) {
//   // we calloc instead of malloc to keep valgrind happy
//   int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
//   s->x = calloc(p->dim, sizeof(float));
//   s->xb = calloc(p->dim, sizeof(float));
//   s->xb2 = calloc(p->dim, sizeof(float));
//   s->hb = calloc(p->hidden_dim, sizeof(float));
//   s->hb2 = calloc(p->hidden_dim, sizeof(float));
//   s->xq = (QuantizedTensor){.q = calloc(p->dim, sizeof(int8_t)),
//                             .s = calloc(p->dim, sizeof(float))};
//   s->hq = (QuantizedTensor){.q = calloc(p->hidden_dim, sizeof(int8_t)),
//                             .s = calloc(p->hidden_dim, sizeof(float))};
//   s->q = calloc(p->dim, sizeof(float));
//   s->k = calloc(kv_dim, sizeof(float));
//   s->v = calloc(kv_dim, sizeof(float));
//   s->att = calloc(p->n_heads * p->seq_len, sizeof(float));
//   s->logits = calloc(p->vocab_size, sizeof(float));
//   s->key_cache = calloc(p->n_layers * p->seq_len * kv_dim, sizeof(float));
//   s->value_cache = calloc(p->n_layers * p->seq_len * kv_dim, sizeof(float));
//   // ensure all mallocs went fine
//   if (!s->x || !s->xb || !s->xb2 || !s->hb || !s->hb2 || !s->q || !s->k ||
//       !s->v || !s->att || !s->logits || !s->key_cache || !s->value_cache) {
//     fprintf(stderr, "malloc failed!\n");
//     exit(EXIT_FAILURE);
//   }
// }

void malloc_run_state(RunState *s, Config *p) {
  // we calloc instead of malloc to keep valgrind happy
  int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
  s->x = calloc(p->dim * 32768, sizeof(float));
  s->xb = calloc(p->dim * 32768, sizeof(float));
  s->xb2 = calloc(p->dim * 32768, sizeof(float));
  s->hb = calloc(p->hidden_dim * 32768, sizeof(float));
  s->hb2 = calloc(p->hidden_dim * 32768, sizeof(float));
  s->xq = (QuantizedTensor){.q = calloc(p->dim * 32768, sizeof(int8_t)),
                            .s = calloc(p->dim * 32768 / 128, sizeof(float))};
  s->hq = (QuantizedTensor){
      .q = calloc(p->hidden_dim * 32768, sizeof(int8_t)),
      .s = calloc(p->hidden_dim * 32768 / 128, sizeof(float))};
  s->q = calloc(p->dim * 32768, sizeof(float));
  s->k = calloc(kv_dim * 32768, sizeof(float));
  s->v = calloc(kv_dim * 32768, sizeof(float));
  s->att = calloc(p->n_heads * p->seq_len * 1000, sizeof(float));
  s->logits = calloc(p->vocab_size, sizeof(float));
  s->key_cache = calloc(p->n_layers * p->seq_len * kv_dim, sizeof(float));
  s->value_cache = calloc(p->n_layers * p->seq_len * kv_dim, sizeof(float));
  // ensure all mallocs went fine
  if (!s->x || !s->xb || !s->xb2 || !s->hb || !s->hb2 || !s->q || !s->k ||
      !s->v || !s->att || !s->logits || !s->key_cache || !s->value_cache) {
    fprintf(stderr, "malloc failed!\n");
    exit(EXIT_FAILURE);
  }
}

void free_run_state(RunState *s) {
  free(s->x);
  free(s->xb);
  free(s->xb2);
  free(s->hb);
  free(s->hb2);
  free(s->xq.q);
  free(s->xq.s);
  free(s->hq.q);
  free(s->hq.s);
  free(s->q);
  free(s->k);
  free(s->v);
  free(s->att);
  free(s->logits);
  free(s->key_cache);
  free(s->value_cache);
  // printf("free run state is right.\n");
}

long time_in_ms() {
  // return time in milliseconds, for benchmarking the model speed
  struct timespec time;
  clock_gettime(CLOCK_REALTIME, &time);
  return time.tv_sec * 1000 + time.tv_nsec / 1000000;
}

long TimeInMs() {
  // return time in milliseconds, for benchmarking the model speed
  struct timespec time;
  clock_gettime(CLOCK_REALTIME, &time);
  return time.tv_sec * 1000 + time.tv_nsec / 1000000;
}

long long TimeInUs() {
  // return time in microseconds, for benchmarking the model speed
  struct timespec time;
  clock_gettime(CLOCK_REALTIME, &time);
  return time.tv_sec * 1000000 + time.tv_nsec / 1000;
}

long long TimeInNs() {
  // return time in nanoseconds, for benchmarking the model speed
  struct timespec time;
  clock_gettime(CLOCK_REALTIME, &time);
  return time.tv_sec * 1000000000 + time.tv_nsec;
}

// ----------------------------------------------------------------------------
// Quantization functions

void dequantize(QuantizedTensor *qx, float *x, int n) {
  for (int i = 0; i < n; i++) {
    x[i] = qx->q[i] * qx->s[i / GS];
  }
}

void quantize(QuantizedTensor *qx, float *x, int n, int group_size) {
  int num_groups = n / group_size;
  float Q_MAX = 127.0f;

  for (int group = 0; group < num_groups; group++) {
    // find the max absolute value in the current group
    float wmax = 0.0;
    for (int i = 0; i < group_size; i++) {
      float val = fabs(x[group * group_size + i]);
      if (val > wmax) {
        wmax = val;
      }
    }

    // calculate and write the scaling factor
    float scale = wmax / Q_MAX;
    qx->s[group] = scale;

    // calculate and write the quantized values
    for (int i = 0; i < group_size; i++) {
      float quant_value = x[group * group_size + i] / scale;  // scale
      int8_t quantized = (int8_t)round(quant_value);          // round and clamp
      qx->q[group * group_size + i] = quantized;
    }
  }
}

void quantize_prefill(QuantizedTensor *qx, float *x, int n, int group_size,
                      int prompt_token_num) {
  int num_groups = n / group_size;
  float Q_MAX = 127.0f;

  int k;
#pragma omp parallel for private(k)
  for (k = 0; k < prompt_token_num; k++) {
    for (int group = 0; group < num_groups; group++) {
      // find the max absolute value in the current group
      float wmax = 0.0;
      for (int i = 0; i < group_size; i++) {
        float val = fabs(x[k * n + group * group_size + i]);
        if (val > wmax) {
          wmax = val;
        }
      }

      // calculate and write the scaling factor
      float scale = wmax / Q_MAX;
      qx->s[k * num_groups + group] = scale;

      // calculate and write the quantized values
      for (int i = 0; i < group_size; i++) {
        float quant_value = x[k * n + group * group_size + i] / scale;  // scale
        int8_t quantized = (int8_t)round(quant_value);  // round and clamp
        qx->q[k * n + group * group_size + i] = quantized;
      }
    }
  }
}

/* initialize `n` x quantized tensor (with `size_each` elements), starting from
 * memory pointed at *ptr */
QuantizedTensor *init_quantized_tensors(void **ptr, int n, int size_each,
                                        int group_size) {
  void *p = *ptr;
  QuantizedTensor *res = malloc(n * sizeof(QuantizedTensor));
  for (int i = 0; i < n; i++) {
    /* map quantized int8 values*/
    res[i].q = (int8_t *)p;
    p = (int8_t *)p + size_each;
    /* map scale factors */
    res[i].s = (float *)p;
    p = (float *)p + size_each / group_size;
  }
  *ptr = p;  // advance ptr to current position
  return res;
}

void memory_map_weights(TransformerWeights *w, Config *p, void *ptr,
                        uint8_t shared_classifier, bool bias) {
  int head_size = p->dim / p->n_heads;
  // first are the parameters that are kept in fp32 (the rmsnorm (1D) weights)
  float *fptr = (float *)ptr;  // cast our pointer to float*
  w->rms_att_weight = fptr;
  fptr += p->n_layers * p->dim;
  w->rms_ffn_weight = fptr;
  fptr += p->n_layers * p->dim;
  w->rms_final_weight = fptr;
  fptr += p->dim;

  // now read all the quantized weights
  ptr = (void *)fptr;  // now cast the pointer back to void*
  w->q_tokens = init_quantized_tensors(&ptr, 1, p->vocab_size * p->dim, 128);
  // dequantize token embedding table
  w->token_embedding_table = malloc(p->vocab_size * p->dim * sizeof(float));
  dequantize(w->q_tokens, w->token_embedding_table, p->vocab_size * p->dim);

  w->wq = init_quantized_tensors(&ptr, p->n_layers,
                                 p->dim * (p->n_heads * head_size), 128);
  w->wk = init_quantized_tensors(&ptr, p->n_layers,
                                 p->dim * (p->n_kv_heads * head_size), 128);
  w->wv = init_quantized_tensors(&ptr, p->n_layers,
                                 p->dim * (p->n_kv_heads * head_size), 128);
  w->wo = init_quantized_tensors(&ptr, p->n_layers,
                                 (p->n_heads * head_size) * p->dim, 128);

  w->w1 =
      init_quantized_tensors(&ptr, p->n_layers, p->dim * p->hidden_dim, 128);
  w->w2 =
      init_quantized_tensors(&ptr, p->n_layers, p->hidden_dim * p->dim, 128);
  w->w3 =
      init_quantized_tensors(&ptr, p->n_layers, p->dim * p->hidden_dim, 128);

  w->wcls = shared_classifier
                ? w->q_tokens
                : init_quantized_tensors(&ptr, 1, p->dim * p->vocab_size, 128);

  if (bias) {
    // read in the bias values
    w->bq = init_quantized_tensors(&ptr, p->n_layers, (p->n_heads * head_size),
                                   128);
    w->bk = init_quantized_tensors(&ptr, p->n_layers,
                                   (p->n_kv_heads * head_size), 128);
    w->bv = init_quantized_tensors(&ptr, p->n_layers,
                                   (p->n_kv_heads * head_size), 128);
    w->dbq = malloc(p->n_heads * head_size * sizeof(float));
    w->dbk = malloc(p->n_kv_heads * head_size * sizeof(float));
    w->dbv = malloc(p->n_kv_heads * head_size * sizeof(float));
  }
}

// void read_checkpoint(char *checkpoint, Config *config,
//                      TransformerWeights *weights, int *fd, float **data,
//                      ssize_t *file_size) {
//   FILE *file = fopen(checkpoint, "rb");
//   if (!file) {
//     fprintf(stderr, "Couldn't open file %s, it may not exist.\n",
//     checkpoint); exit(EXIT_FAILURE);
//   }
//   // read in the config header
//   if (fread(config, sizeof(Config), 1, file) != 1) {
//     exit(EXIT_FAILURE);
//   }
//   // negative vocab size is hacky way of signaling unshared weights. bit
//   yikes. int shared_weights = config->vocab_size > 0 ? 1 : 0;
//   config->vocab_size = abs(config->vocab_size);
//   // figure out the file size
// #if defined _WIN32
//   _fseeki64(file, 0, SEEK_END);  // move file pointer to end of file
//   *file_size = _ftelli64(file);  // get the file size, in bytes
// #else
//   fseek(file, 0, SEEK_END);  // move file pointer to end of file
//   *file_size = ftell(file);  // get the file size, in bytes
// #endif
//   fclose(file);
//   // memory map the Transformer weights into the data pointer
//   *fd = open(checkpoint, O_RDONLY);  // open in read only mode
//   if (*fd == -1) {
//     fprintf(stderr, "open failed!\n");
//     exit(EXIT_FAILURE);
//   }
//   *data = mmap(NULL, *file_size, PROT_READ, MAP_PRIVATE, *fd, 0);
//   if (*data == MAP_FAILED) {
//     fprintf(stderr, "mmap failed!\n");
//     exit(EXIT_FAILURE);
//   }
//   float *weights_ptr = *data + sizeof(Config) / sizeof(float);
//   memory_map_weights(weights, config, weights_ptr, shared_weights, true);
// }

void read_checkpoint(char *checkpoint, Config *config,
                     TransformerWeights *weights, int *fd, float **data,
                     ssize_t *file_size) {
  FILE *file = fopen(checkpoint, "rb");
  if (!file) {
    fprintf(stderr, "Couldn't open file %s\n", checkpoint);
    exit(EXIT_FAILURE);
  }
  // read in magic number (uint32), has to be 0x616b3432, i.e. "ak42" in ASCII
  uint32_t magic_number;
  if (fread(&magic_number, sizeof(uint32_t), 1, file) != 1) {
    exit(EXIT_FAILURE);
  }
  if (magic_number != 0x616b3432) {
    fprintf(stderr, "Bad magic number\n");
    exit(EXIT_FAILURE);
  }

  // read in the version number (uint32), has to be 6
  int version;
  if (fread(&version, sizeof(int), 1, file) != 1) {
    exit(EXIT_FAILURE);
  }
  if (version != 6) {
    fprintf(stderr, "Bad version %d, need version 6\n", version);
    exit(EXIT_FAILURE);
  }
  int header_size = 256;  // the header size for version 6 in bytes
  // read in the Config
  if (fread(config, sizeof(Config), 1, file) != 1) {
    exit(EXIT_FAILURE);
  }
  // read in flags
  uint8_t shared_classifier;  // a byte to indicate if the classifier is shared
  if (fread(&shared_classifier, sizeof(uint8_t), 1, file) != 1) {
    exit(EXIT_FAILURE);
  }
  int group_size;  // the group size used in quantization
  if (fread(&group_size, sizeof(int), 1, file) != 1) {
    exit(EXIT_FAILURE);
  }
  GS = group_size;  // set as global, as it will be used in many places
                    // figure out the file size
#if defined _WIN32
  _fseeki64(file, 0, SEEK_END);  // move file pointer to end of file
  *file_size = _ftelli64(file);  // get the file size, in bytes
#else
  fseek(file, 0, SEEK_END);  // move file pointer to end of file
  *file_size = ftell(file);  // get the file size, in bytes
#endif
  fclose(file);
  // memory map the Transformer weights into the data pointer
  *fd = open(checkpoint, O_RDONLY);  // open in read only mode
  if (*fd == -1) {
    fprintf(stderr, "open failed!\n");
    exit(EXIT_FAILURE);
  }
  *data = mmap(NULL, *file_size, PROT_READ, MAP_PRIVATE, *fd, 0);
  if (*data == MAP_FAILED) {
    fprintf(stderr, "mmap failed!\n");
    exit(EXIT_FAILURE);
  }
  void *weights_ptr =
      ((char *)*data) + header_size;  // skip header bytes. char is 1 byte
  memory_map_weights(weights, config, weights_ptr, shared_classifier, true);
}

void build_transformer(Transformer *t, char *checkpoint_path) {
  // read in the Config and the Weights from the checkpoint
  read_checkpoint(checkpoint_path, &t->config, &t->weights, &t->fd, &t->data,
                  &t->file_size);
  // allocate the RunState buffers
  malloc_run_state(&t->state, &t->config);
}

void free_transformer(Transformer *t) {
  // free QuantizedTensors
  free(t->weights.q_tokens);
  free(t->weights.token_embedding_table);
  free(t->weights.wq);
  free(t->weights.wk);
  free(t->weights.wv);
  free(t->weights.wo);
  free(t->weights.w1);
  free(t->weights.w2);
  free(t->weights.w3);
  if (t->weights.wcls != t->weights.q_tokens) {
    free(t->weights.wcls);
  }
  free(t->weights.bq);
  free(t->weights.bk);
  free(t->weights.bv);
  free(t->weights.dbq);
  free(t->weights.dbk);
  free(t->weights.dbv);
  // close the memory mapping
  if (t->data != MAP_FAILED) {
    munmap(t->data, t->file_size);
  }
  if (t->fd != -1) {
    close(t->fd);
  }
  // free the RunState buffers
  free_run_state(&t->state);
}

// ----------------------------------------------------------------------------
// neural net blocks; the dynamics of the Transformer

void rmsnorm(float *o, float *x, float *weight, int size) {
  // calculate sum of squares
  float ss = 0.0f;
  for (int j = 0; j < size; j++) {
    ss += x[j] * x[j];
  }
  ss /= size;
  ss += 1e-5f;
  ss = 1.0f / sqrtf(ss);
  // normalize and scale
  for (int j = 0; j < size; j++) {
    o[j] = weight[j] * (ss * x[j]);
  }
}

void rmsnorm_prefill(float *o, float *x, float *weight, int size,
                     int prompt_token_num) {
  // calculate sum of squares
  float *ss = (float *)malloc(sizeof(float) * prompt_token_num);
  memset(ss, 0.0f, sizeof(float) * prompt_token_num);

  int i;
#pragma omp parallel for private(i)
  for (i = 0; i < prompt_token_num; i++) {
    // float ss = 0.0f;
    for (int j = 0; j < size; j++) {
      ss[i] += x[i * size + j] * x[i * size + j];
    }
    ss[i] /= size;
    ss[i] += 1e-5f;
    ss[i] = 1.0f / sqrtf(ss[i]);
    // normalize and scale
    for (int j = 0; j < size; j++) {
      o[i * size + j] = weight[j] * (ss[i] * x[i * size + j]);
    }
  }
}

void softmax(float *x, int size) {
  // find max value (for numerical stability)
  float max_val = x[0];
  for (int i = 1; i < size; i++) {
    if (x[i] > max_val) {
      max_val = x[i];
    }
  }
  // exp and sum
  float sum = 0.0f;
  for (int i = 0; i < size; i++) {
    x[i] = expf(x[i] - max_val);
    sum += x[i];
  }
  // normalize
  for (int i = 0; i < size; i++) {
    x[i] /= sum;
  }
}

void matmul(float *xout, QuantizedTensor *x, QuantizedTensor *w, int n, int d,
            int group_size) {
  // W (d,n) @ x (n,) -> xout (d,)
  // by far the most amount of time is spent inside this little function
  // inputs to this function are both quantized

  int i;
#pragma omp parallel for private(i)
  for (i = 0; i < d; i++) {
    float val = 0.0f;
    int32_t ival = 0;
    int in = i * n;

    // do the matmul in groups of GS
    int j;
    for (j = 0; j <= n - group_size; j += group_size) {
      for (int k = 0; k < group_size; k++) {
        ival += ((int32_t)x->q[j + k]) * ((int32_t)w->q[in + j + k]);
      }
      val += ((float)ival) * w->s[(in + j) / group_size] * x->s[j / group_size];
      ival = 0;
    }

    xout[i] = val;
  }
}

void matmul_prefill(float *xout, QuantizedTensor *x, QuantizedTensor *w, int n,
                    int d, int k, int group_size) {
  // W (d,n) @ x (n,k) -> xout (d,k)
  // by far the most amount of time is spent inside this little function
  // inputs to this function are both quantized

  int m;
#pragma omp parallel for private(m)
  for (m = 0; m < k; m++) {
    int i;
#pragma omp parallel for private(i)
    for (i = 0; i < d; i++) {
      float val = 0.0f;
      int32_t ival = 0;
      int in = i * n;

      // do the matmul in groups of GS
      int j;
      for (j = 0; j <= n - group_size; j += group_size) {
        for (int k = 0; k < group_size; k++) {
          ival += ((int32_t)x->q[m * n + j + k]) * ((int32_t)w->q[in + j + k]);
        }
        val += ((float)ival) * w->s[(in + j) / group_size] *
               x->s[m * n / 128 + j / group_size];
        ival = 0;
      }

      xout[m * d + i] = val;
    }
  }
}

void dequantize_vector(float *out, QuantizedTensor *x, int n) {
  // x(n,) -> out(n,)
  // printf("n/GS: %d ", n / GS);
  for (int i = 0; i < n / GS; i++) {
    // printf("i*GS: %d ,(i+1)*GS: %d", i * GS, (i + 1) * GS);
    for (int j = i * GS; j < (i + 1) * GS; j++) {
      out[j] = x->s[i] * (float)x->q[j];
    }
  }
}

void dequantize_vector_128_prefill(float *out, QuantizedTensor *x, int n,
                                   int m) {
  // x(n,m) -> out(n,m)
  // printf("n/GS: %d ", n / GS);
  int k;
#pragma omp parallel for private(k)
  for (k = 0; k < m; k++) {
    for (int i = 0; i < n / 128; i++) {
      // printf("i*GS: %d ,(i+1)*GS: %d", i * GS, (i + 1) * GS);
      for (int j = i * 128; j < (i + 1) * 128; j++) {
        out[k * n + j] = x->s[k * n / 128 + i] * (float)x->q[k * n + j];
      }
    }
  }
}

void dequantize_vector_128(float *out, QuantizedTensor *x, int n) {
  // x(n,) -> out(n,)
  // printf("n/GS: %d ", n / GS);
  for (int i = 0; i < n / 128; i++) {
    // printf("i*GS: %d ,(i+1)*GS: %d", i * GS, (i + 1) * GS);
    for (int j = i * 128; j < (i + 1) * 128; j++) {
      out[j] = x->s[i] * (float)x->q[j];
    }
  }
}

void dequantize_vector_896(float *out, QuantizedTensor *x, int n) {
  // x(n,) -> out(n,)
  // printf("n/GS: %d ", n / GS);
  for (int i = 0; i < n / 896; i++) {
    // printf("i*GS: %d ,(i+1)*GS: %d", i * GS, (i + 1) * GS);
    for (int j = i * 896; j < (i + 1) * 896; j++) {
      out[j] = x->s[i] * (float)x->q[j];
    }
  }
}

void dequantize_vector_4096(float *out, QuantizedTensor *x, int n) {
  // x(n,) -> out(n,)
  // printf("n/GS: %d ", n / GS);
  for (int i = 0; i < n / 4096; i++) {
    // printf("i*GS: %d ,(i+1)*GS: %d", i * GS, (i + 1) * GS);
    for (int j = i * 4096; j < (i + 1) * 4096; j++) {
      out[j] = x->s[i] * (float)x->q[j];
    }
  }
}

// Write Act Function
void write_matrix_to_mmio(PYNQ_MMIO_WINDOW *mmio, int nums, int8_t *matrix) {
  PYNQ_writeMMIO(mmio, matrix, 0x0, sizeof(int8_t) * nums);
}

// Read Function
void read_matrix_from_mmio(PYNQ_MMIO_WINDOW *mmio, int nums, int32_t *matrix) {
  PYNQ_readMMIO(mmio, matrix, 0x0, sizeof(int32_t) * nums);
}

void gemm_n128_128896_scale(float *out_n_896, int8_t *x, int8_t *w,
                            float *sca_xi, float *sca_w, int prompt_token_num,
                            PYNQ_MMIO_WINDOW *my_window_act,
                            PYNQ_MMIO_WINDOW *my_window_wgt,
                            PYNQ_MMIO_WINDOW *my_window_result,
                            PYNQ_MMIO_WINDOW *my_window_reg,
                            PYNQ_MMIO_WINDOW *my_window_scale) {
  // printf("789\n");
  //  x(n,128) w(128*896) sca(904)[0-15,16+0-895,]
  float *out_temp = (float *)malloc(sizeof(float) * 10 * 896);
  float *sca_x_in = (float *)malloc(sizeof(float) * 16);
  memset(sca_x_in, 0.0f, sizeof(float) * 16);
  // memset(out_temp, 0.0f, sizeof(float) * 10*896);

  long long start;
  long long end;

  int8_t *data = (int8_t *)malloc(sizeof(int8_t) * 64);
  int8_t *back = (int8_t *)malloc(sizeof(int8_t) * 64);
  memset(data, 0, sizeof(int8_t) * 64);
  memset(back, 0, sizeof(int8_t) * 64);

  // int8_t x_in_10_128= (int8_t *)malloc(sizeof(int8_t) * 10*128);
  //     memset(data, 0, sizeof(int8_t) * 64);
  int8_t *x_in_32 = (int8_t *)malloc(sizeof(int8_t) * 32);
  int8_t *weight_in_1024 = (int8_t *)malloc(sizeof(int8_t) * 1024);

  PYNQ_writeMMIO(my_window_scale, sca_w, 0x0 + 16 * sizeof(float),
                 sizeof(float) * 896);
  // start = TimeInNs();
  // Function of Weight(128 times)
  int times_3 = 0;
  // printf("811\n");
  for (int i3 = 0; i3 < 28; i3++) {
    for (int j1 = 0; j1 < 4; j1++) {
      for (int k = 0; k < 32; k++) {
        for (int m1 = 0; m1 < 32; m1++) {
          weight_in_1024[k * 32 + m1] = w[896 * (32 * j1 + m1) + (k + 32 * i3)];
        }
      }
      PYNQ_writeMMIO(my_window_wgt, weight_in_1024,
                     0x0 + sizeof(int8_t) * 1024 * times_3,
                     sizeof(int8_t) * 1024);
      times_3++;
    }
  }
  end = TimeInNs();
  // printf("time for write weight,%lld\n", end - start);

  // PYNQ_writeMMIO(my_window_wgt, w, 0x0, sizeof(int8_t) * 128 * 896);

  // Split n to 10 for each
  for (int i = 0; i < (prompt_token_num + 10 - 1) / 10; i++) {
    // data[16] = 1;
    // PYNQ_writeMMIO(my_window_reg, data, 0x0, sizeof(int8_t) * 32);

    // start = TimeInNs();
    //  Function of input(40 times) 10*128=32*40
    int times_1 = 0;
    for (int i1 = 0; i1 < 4; i1++) {
      for (int j = 0; j < 10; j++) {
        for (int k = 0; k < 32; k++) {
          if ((896 * j + 32 * i1 + k + i * 10 * 896) >
              (prompt_token_num) * 896) {
            x_in_32[k] = 0;
          } else {
            x_in_32[k] = x[896 * j + 32 * i1 + k + i * 10 * 896];
          }
        }
        PYNQ_writeMMIO(my_window_act, x_in_32,
                       0x0 + sizeof(int8_t) * 32 * times_1,
                       sizeof(int8_t) * 32);
        times_1++;
      }
    }
    // end = TimeInNs();
    // printf("time for write act for %d time,%lld\n", i,end - start);

    // PYNQ_writeMMIO(my_window_act, x, 0x0, sizeof(int8_t) * 128);
    //  write_matrix_to_mmio(my_window_wgt, 128 * 896, w); // 128 times
    for (int sin = 0; sin < 10; sin++) {
      sca_x_in[sin] = sca_xi[sin * 7];
    }
    PYNQ_writeMMIO(my_window_scale, sca_x_in, 0x0, sizeof(float) * 16);

    data[24] = 1;
    PYNQ_writeMMIO(my_window_reg, data, 0x0, sizeof(int8_t) * 32);

    // end = TimeInNs();
    // printf("time for writemmio,%lld\n", end - start);
    // start = TimeInNs();
    // printf("857\n");
    while (1) {
      PYNQ_readMMIO(my_window_reg, back, 0x0, sizeof(int8_t) * 64);
      if (back[32] == 2) {
        // printf("Matrix Multiplication Finished! Continuing the
        // program...\n");
        data[24] = 0;
        PYNQ_writeMMIO(my_window_reg, data, 0x0, sizeof(int8_t) * 32);
        break;
      }
    }
    // printf("870\n");
    // end = TimeInNs();
    // printf("time for while for time %d,%lld\n",i, end - start);
    // start = TimeInNs();

    // PYNQ_readMMIO(my_window_result, out_896, 0x0, sizeof(float) * 896);

    int times_2 = 0;
    for (int i2 = 0; i2 < 28; i2++) {
      for (int j = 0; j < 10; j++) {
        // PYNQ_readMMIO(&my_window_result, result_read, 0x0 + sizeof(float) *
        // 32 * (j * 28 + i), sizeof(float) * 32);
        if ((i + 1) * 10 > prompt_token_num) {
          // printf("884,in time%d\n",times_2);
          PYNQ_readMMIO(my_window_result, out_temp + 32 * (j * 28 + i2),
                        0x0 + sizeof(float) * 32 * times_2, sizeof(float) * 32);
        } else {
          // printf("887in time %d\n", times_2);
          PYNQ_readMMIO(my_window_result,
                        out_n_896 + 32 * (j * 28 + i2) + i * 896 * 10,
                        0x0 + sizeof(float) * 32 * times_2, sizeof(float) * 32);
        }
        times_2++;
      }
    }

    // printf("892\n");
    if ((i + 1) * 10 > prompt_token_num) {
      for (int x = 0; x < (prompt_token_num - i * 10); x++) {
        for (int y = 0; y < 896; y++) {
          out_n_896[i * 896 * 10 + x * 896 + y] = out_temp[x * 896 + y];
        }
      }
    }
    // end = TimeInNs();
    // printf("time for read for %d ,%lld\n", i, end - start);

    // if((i+1)*10>prompt_token_num){
    //     PYNQ_readMMIO(my_window_result, out_n_896+ i*896*10, 0x0,
    //     sizeof(float) * 896*(prompt_token_num-10*i));
    // }
    // else
    // {
    //     PYNQ_readMMIO(my_window_result, out_n_896+ i*896*10, 0x0,
    //     sizeof(float) * 896*10);
    // }
    // printf("884\n");
    // read_matrix_from_mmio(my_window_result, 128, out_128);
    // end = TimeInNs();
    // printf("time for read,%lld\n", end - start);
  }
  free(data);
  free(back);
  free(sca_x_in);
  free(x_in_32);
  free(weight_in_1024);
  free(out_temp);
}

void gemm_128(int32_t *out_128, int8_t *x, int8_t *w,
              PYNQ_MMIO_WINDOW *my_window_act, PYNQ_MMIO_WINDOW *my_window_wgt,
              PYNQ_MMIO_WINDOW *my_window_result,
              PYNQ_MMIO_WINDOW *my_window_reg) {
  int8_t *data = (int8_t *)malloc(sizeof(int8_t) * 64);
  int8_t *back = (int8_t *)malloc(sizeof(int8_t) * 64);
  memset(data, 0, sizeof(int8_t) * 64);
  memset(back, 0, sizeof(int8_t) * 64);

  data[16] = 1;
  PYNQ_writeMMIO(my_window_reg, data, 0x0, sizeof(int8_t) * 32);

  write_matrix_to_mmio(my_window_act, 128, x);    // 1 time
  write_matrix_to_mmio(my_window_wgt, 16384, w);  // 128 times

  data[24] = 1;
  PYNQ_writeMMIO(my_window_reg, data, 0x0, sizeof(int8_t) * 32);

  // printf("begin while\n");

  while (1) {
    PYNQ_readMMIO(my_window_reg, back, 0x0, sizeof(int8_t) * 64);
    if (back[32] == 2) {
      // printf("Matrix Multiplication Finished! Continuing the program...\n");
      data[24] = 0;
      PYNQ_writeMMIO(my_window_reg, data, 0x0, sizeof(int8_t) * 32);
      break;
    }
  }

  // printf("end while\n");

  // if Finished
  data[8] = 3;
  PYNQ_writeMMIO(my_window_reg, data, 0x0, sizeof(int8_t) * 32);
  read_matrix_from_mmio(my_window_result, 128, out_128);

  free(data);
  free(back);
}

void gemm_scale_prefill(float *xout, QuantizedTensor *x, QuantizedTensor *w,
                        int n, int d, int prompt_token_num, int group_size,
                        PYNQ_MMIO_WINDOW *my_window_act,
                        PYNQ_MMIO_WINDOW *my_window_wgt,
                        PYNQ_MMIO_WINDOW *my_window_result,
                        PYNQ_MMIO_WINDOW *my_window_reg,
                        PYNQ_MMIO_WINDOW *my_window_scale) {
  long long start;
  long long end;

  memset(xout, 0.0f, d * prompt_token_num * sizeof(float));
  float *out_n_896 = (float *)malloc(896 * prompt_token_num * sizeof(float));
  int8_t *input_896_128 = (int8_t *)malloc(896 * 128 * sizeof(int8_t));
  float *scale_w = (float *)malloc(896 * sizeof(float));
  memset(scale_w, 0.0f, 896 * sizeof(float));
  // W (d,n)

  // for (int p = 0; p<(prompt_token_num+10-1)/10; p=p++){
  for (int i = 0; i < n / group_size; i++) {
    // scale[0] = x->s[i];

    int n1;
    int m1;
#pragma omp parallel for private(n1)
    for (n1 = 0; n1 < 896; n1++) {
      scale_w[n1] = w->s[i + n1 * 7];

      start = TimeInNs();
#pragma omp parallel for private(m1)
      for (m1 = 0; m1 < 128; m1++) {
        input_896_128[m1 * 896 + n1] = (int8_t)(w->q[n1 * 896 + i * 128 + m1]);
      }
    }
    // end = TimeInNs();
    // printf("Transpose gemm_n128_128896_scale time of %d is, %lld\n",i, end -
    // start); printf("gemm 896 scale begin"); start = TimeInNs();
    gemm_n128_128896_scale(out_n_896, x->q + i * group_size, input_896_128,
                           x->s + i, scale_w, prompt_token_num, my_window_act,
                           my_window_wgt, my_window_result, my_window_reg,
                           my_window_scale);
    end = TimeInNs();
    // printf("gemm_n128_128896_scale time is, %lld\n", end - start);
    // printf("gemm 896 scale end");

    int k1;
#pragma omp parallel for private(k1)
    for (k1 = 0; k1 < prompt_token_num; k1++) {
      int j1;
#pragma omp parallel for private(j1)
      for (j1 = 0; j1 < d; j1++) {
        xout[k1 * d + j1] += (out_n_896[k1 * d + j1]);
      }
    }
    // for (int j = 0; j < group_size; j++)
    // {
    //     xout[j] += ((float)out_128[j]) * w->s[i + j * 896 / 128] * x->s[i];
    // }
  }

  free(out_n_896);
  free(input_896_128);
  free(scale_w);
}
//}

//  void gemm_scale(float *xout, QuantizedTensor *x, QuantizedTensor *w, int n,
//  int d,
//                  int group_size, PYNQ_MMIO_WINDOW *my_window_act,
//                  PYNQ_MMIO_WINDOW *my_window_wgt, PYNQ_MMIO_WINDOW
//                  *my_window_result, PYNQ_MMIO_WINDOW *my_window_reg,
//                  PYNQ_MMIO_WINDOW *my_window_scale)
//  {
//      long long start;
//      long long end;

//      memset(xout, 0.0f, d * sizeof(float));
//      float *out_896 = (float *)malloc(896 * sizeof(float));
//      int8_t *input_896_128 = (int8_t *)malloc(896 * 128 * sizeof(int8_t));
//      float *scale = (float *)malloc(904 * sizeof(float));
//      memset(scale, 0.0f, 904 * sizeof(float));
//      // W (d,n)

//      for (int i = 0; i < n / group_size; i++)
//      {
//          scale[0] = x->s[i];

//          int n;
//          int m;
//  #pragma omp parallel for private(n)
//          for (n = 0; n < 896; n++)
//          {
//              scale[n + 1] = w->s[i + n * 896 / 128];

//  #pragma omp parallel for private(m)
//              for (m = 0; m < 128; m++)
//              {
//                  input_896_128[n * 128 + m] = (int8_t)(w->q[n * 896 + i * 128
//                  + m]);
//              }
//          }
//          // printf("gemm 896 scale begin");
//          start = TimeInNs();
//          gemm_896_scale(out_896, x->q + i * group_size, input_896_128, scale,
//                         my_window_act,
//                         my_window_wgt, my_window_result, my_window_reg,
//                         my_window_scale);
//          end = TimeInNs();
//          printf("gemm_896_scale time is, %lld\n", end - start);
//          // printf("gemm 896 scale end");
//          int j;
//  #pragma omp parallel for private(j)
//          for (j = 0; j < d; j++)
//          {
//              xout[j] += ((float)out_896[j]);
//          }
//          // for (int j = 0; j < group_size; j++)
//          // {
//          //     xout[j] += ((float)out_128[j]) * w->s[i + j * 896 / 128] *
//          x->s[i];
//          // }
//      }
//      free(out_896);
//      free(input_896_128);
//      free(scale);
//  }

void gemm(float *xout, QuantizedTensor *x, QuantizedTensor *w, int n, int d,
          int group_size, PYNQ_MMIO_WINDOW *my_window_act,
          PYNQ_MMIO_WINDOW *my_window_wgt, PYNQ_MMIO_WINDOW *my_window_result,
          PYNQ_MMIO_WINDOW *my_window_reg) {
  memset(xout, 0.0f, d * sizeof(float));
  int32_t *out_128 = (int32_t *)malloc(128 * sizeof(int32_t));
  int8_t *input_128_128 = (int8_t *)malloc(128 * 128 * sizeof(int8_t));

  // W (d,n) -> W (n,d)
  // transpose_int(w->q, n, d);

  for (int i = 0; i < n / group_size; i++) {
    int n;
    int m;
#pragma omp parallel for private(n)

    for (n = 0; n < 128; n++) {
#pragma omp parallel for private(m)
      for (m = 0; m < 128; m++) {
        input_128_128[n * 128 + m] = (int8_t)(w->q[n * 896 + i * 128 + m]);
      }
    }

    // gemm_128(out_128, x->q + i * group_size, w->q + (i)*group_size *
    // group_size,
    //         &my_window_act, &my_window_wgt, &my_window_result,
    //         &my_window_reg);
    // printf("begin gemm_128 in %d time\n", i);
    gemm_128(out_128, x->q + i * group_size, input_128_128, my_window_act,
             my_window_wgt, my_window_result, my_window_reg);
    // printf("end gemm_128 in %d time\n", i);
    //  for (int j = 0; j < group_size; j++)
    //  {
    //      xout[j] += ((float)out_128[j]) * w->s[i * group_size + j] * x->s[i];
    //  }
    for (int j = 0; j < group_size; j++) {
      xout[j] += ((float)out_128[j]) * w->s[i + j * 896 / 128] * x->s[i];
    }
  }
  // transpose_float(xout, n, d);

  free(out_128);
  free(input_128_128);
}

float *forward(Transformer *transformer, int token, int pos, bool bias,
               PYNQ_MMIO_WINDOW *my_window_act, PYNQ_MMIO_WINDOW *my_window_wgt,
               PYNQ_MMIO_WINDOW *my_window_result,
               PYNQ_MMIO_WINDOW *my_window_reg,
               PYNQ_MMIO_WINDOW *my_window_scale) {
  long long start = 0;
  long long end = 0;
  long long start1 = 0;
  long long end1 = 0;
  long long sum = 0;

  // a few convenience variables
  Config *p = &transformer->config;
  TransformerWeights *w = &transformer->weights;
  RunState *s = &transformer->state;
  float *x = s->x;
  int dim = p->dim;
  int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
  int kv_mul =
      p->n_heads /
      p->n_kv_heads;  // integer multiplier of the kv sharing in multiquery
  int hidden_dim = p->hidden_dim;
  int head_size = dim / p->n_heads;  // 896/14=64

  // copy the token embedding into x
  memcpy(x, w->token_embedding_table + token * dim, dim * sizeof(float));

  // forward all the layers
  for (unsigned long long l = 0; l < p->n_layers; l++) {
    // printf("910\n");
    //  attention rmsnorm
    rmsnorm(s->xb, x, w->rms_att_weight + l * dim, dim);
    // printf("913\n");

    // qkv matmuls for this position
    quantize(&s->xq, s->xb, dim, 128);  // 128
    // start1 = TimeInNs();
    //  gemm_scale(s->q, &s->xq, w->wq + l, dim, dim, 128, my_window_act,
    //             my_window_wgt, my_window_result, my_window_reg,
    //             my_window_scale);
    //  // W (d=dim, n=dim) @ x (n=dim,) -> xout (d,)
    // end1 = TimeInNs();
    // sum += end1 - start1;
    // printf("the time in l==%d is, %lld\n", (int8_t)l, (end1 - start1));
    // printf("sum time in l==%d is, %lld\n", (int8_t)l, sum);

    // start = TimeInNs();
    matmul(s->q, &s->xq, w->wq + l, dim, dim, 128);

    // end = TimeInNs();
    // sum += end - start;
    // printf("the time in l==%d is, %lld\n", (int8_t)l, (end - start));
    // printf("sum time in l==%d is, %lld\n", (int8_t)l, sum);

    // printf("gemm_scale begin\n");
    // gemm_scale(s->q, &s->xq, w->wq + l, dim, dim,
    //     128, my_window_act,
    //       my_window_wgt, my_window_result, my_window_reg, my_window_scale);
    // printf("gemm_scale end\n");

    // printf("begin gemm\n");
    matmul(s->k, &s->xq, w->wk + l, dim, kv_dim,
           128);  // W (d=kvdim, n=dim) @ x (n=dim,) -> xout (d,)
    // gemm(s->k, &s->xq, w->wk + l, dim, kv_dim, 128, my_window_act,
    //      my_window_wgt, my_window_result, my_window_reg);
    // printf("end gemm\n");
    matmul(s->v, &s->xq, w->wv + l, dim, kv_dim, 128);
    // gemm(s->v, &s->xq, w->wv + l, dim, kv_dim, 128, my_window_act,
    // my_window_wgt, my_window_result, my_window_reg);

    if (bias) {
      // float *bq = calloc(dim, sizeof(float));
      // float *bk = calloc(kv_dim, sizeof(float));
      // float *bv = calloc(kv_dim, sizeof(float));
      // dequantize_vector(bq, w->bq + l, dim);
      // dequantize_vector(bk, w->bk + l, kv_dim);
      // dequantize_vector(bv, w->bv + l, kv_dim);
      dequantize_vector_128(w->dbq, w->bq + l, dim);
      dequantize_vector_128(w->dbk, w->bk + l, kv_dim);
      dequantize_vector_128(w->dbv, w->bv + l, kv_dim);
      for (int i = 0; i < dim; i++) {
        s->q[i] += w->dbq[i];
      }
      for (int i = 0; i < kv_dim; i++) {
        s->k[i] += w->dbk[i];
        s->v[i] += w->dbv[i];
      }
      // free(bq);
      // free(bk);
      // free(bv);
    }

    // // RoPE relative positional encoding: complex-valued rotate q and k in
    // each
    // // head
    // for (int i = 0; i < p->n_heads; i++) {
    //   for (int j = 0; j < head_size; j += 2) {
    //     float freq = 1.0f / powf(500000.0f, (float)j / (float)head_size);
    //     float val = pos * freq;
    //     float fcr = cosf(val);
    //     float fci = sinf(val);
    //     float q0 = s->q[i * head_size + j];
    //     float q1 = s->q[i * head_size + j + 1];
    //     s->q[i * head_size + j] = q0 * fcr - q1 * fci;
    //     s->q[i * head_size + j + 1] = q0 * fci + q1 * fcr;
    //     if (i < p->n_kv_heads) {
    //       float k0 = s->k[i * head_size + j];
    //       float k1 = s->k[i * head_size + j + 1];
    //       s->k[i * head_size + j] = k0 * fcr - k1 * fci;
    //       s->k[i * head_size + j + 1] = k0 * fci + k1 * fcr;
    //     }
    //   }
    // }
    for (int i = 0; i < p->dim; i += head_size) {
      for (int head_dim = i % head_size; head_dim < head_size / 2; head_dim++) {
        float freq =
            1.0f / powf(1000000.0f, (float)(head_dim * 2) / (float)head_size);
        float val = pos * freq;
        float fci = sinf(val);
        float fcr = cosf(val);

        float q0 = s->q[i + head_dim];
        float q1 = s->q[i + head_dim + head_size / 2];
        s->q[i + head_dim] = q0 * fcr - q1 * fci;
        s->q[i + head_dim + head_size / 2] = q0 * fci + q1 * fcr;
        if (i < p->n_kv_heads * head_size) {
          float k0 = s->k[i + head_dim];
          float k1 = s->k[i + head_dim + head_size / 2];
          s->k[i + head_dim] = k0 * fcr - k1 * fci;
          s->k[i + head_dim + head_size / 2] = k0 * fci + k1 * fcr;
        }
      }
    }

    // save key,value at this time step (pos) to our kv cache
    int loff =
        l * p->seq_len * kv_dim;  // kv cache layer offset for convenience
    float *key_cache_row = s->key_cache + loff + pos * kv_dim;
    float *value_cache_row = s->value_cache + loff + pos * kv_dim;
    memcpy(key_cache_row, s->k, kv_dim * sizeof(*key_cache_row));
    memcpy(value_cache_row, s->v, kv_dim * sizeof(*value_cache_row));

    // multihead attention. iterate over all heads
    int h;
#pragma omp parallel for private(h)
    for (h = 0; h < p->n_heads; h++) {
      // get the query vector for this head
      float *q = s->q + h * head_size;
      // attention scores for this head
      float *att = s->att + h * p->seq_len;
      // iterate over all timesteps, including the current one
      for (int t = 0; t <= pos; t++) {
        // get the key vector for this head and at this timestep
        float *k = s->key_cache + loff + t * kv_dim + (h / kv_mul) * head_size;
        // calculate the attention score as the dot product of q and k
        float score = 0.0f;
        for (int i = 0; i < head_size; i++) {
          score += q[i] * k[i];
        }
        score /= sqrtf(head_size);
        // save the score to the attention buffer
        att[t] = score;
      }

      // softmax the scores to get attention weights, from 0..pos inclusively
      softmax(att, pos + 1);

      // weighted sum of the values, store back into xb
      float *xb = s->xb + h * head_size;
      memset(xb, 0, head_size * sizeof(float));
      for (int t = 0; t <= pos; t++) {
        // get the value vector for this head and at this timestep
        float *v =
            s->value_cache + loff + t * kv_dim + (h / kv_mul) * head_size;
        // get the attention weight for this timestep
        float a = att[t];
        // accumulate the weighted value into xb
        for (int i = 0; i < head_size; i++) {
          xb[i] += a * v[i];
        }
      }
    }

    // final matmul to get the output of the attention
    quantize(&s->xq, s->xb, dim, 128);
    matmul(s->xb2, &s->xq, w->wo + l, dim, dim,
           128);  // W (d=dim, n=dim) @ x (n=dim,) -> xout (d,)

    // residual connection back into x
    for (int i = 0; i < dim; i++) {
      x[i] += s->xb2[i];
    }

    // ffn rmsnorm
    rmsnorm(s->xb, x, w->rms_ffn_weight + l * dim, dim);

    // Now for FFN in PyTorch we have: self.w2(F.silu(self.w1(x)) * self.w3(x))
    // first calculate self.w1(x) and self.w3(x)
    quantize(&s->xq, s->xb, dim, 128);
    matmul(s->hb, &s->xq, w->w1 + l, dim, hidden_dim,
           128);  // W (d=hidden_dim, n=dim) @ x (n=dim,) -> xout (d,)
    matmul(s->hb2, &s->xq, w->w3 + l, dim, hidden_dim,
           128);  // W (d=hidden_dim, n=dim) @ x (n=dim,) -> xout (d,)

    // SwiGLU non-linearity
    for (int i = 0; i < hidden_dim; i++) {
      float val = s->hb[i];
      // silu(x)=x*s(x), where s(x) is the logistic sigmoid
      val *= (1.0f / (1.0f + expf(-val)));
      // elementwise multiply with w3(x)
      val *= s->hb2[i];
      s->hb[i] = val;
    }

    // final matmul to get the output of the ffn
    quantize(&s->hq, s->hb, hidden_dim, 128);
    matmul(s->xb, &s->hq, w->w2 + l, hidden_dim, dim,
           128);  // W (d=dim, n=hiddendim) @ x (n=hiddendim,) -> xout (d,)

    // residual connection
    for (int i = 0; i < dim; i++) {
      x[i] += s->xb[i];
    }
  }

  // final rmsnorm
  rmsnorm(x, x, w->rms_final_weight, dim);

  // classifier into logits
  quantize(&s->xq, x, dim, 128);
  matmul(s->logits, &s->xq, w->wcls, dim, p->vocab_size,
         128);  // W (d=vocab_size, n=dim) @ x (n=dim,) -> xout (d,)
  return s->logits;
}

float *forward_prefill(Transformer *transformer, int *prompt_tokens,
                       int prompt_token_num, bool bias,
                       PYNQ_MMIO_WINDOW *my_window_act,
                       PYNQ_MMIO_WINDOW *my_window_wgt,
                       PYNQ_MMIO_WINDOW *my_window_result,
                       PYNQ_MMIO_WINDOW *my_window_reg,
                       PYNQ_MMIO_WINDOW *my_window_scale) {
  //    printf("1112\n");
  //    printf("%d\n",prompt_token_num);
  // a few convenience variables
  long long start;
  long long end;
  Config *p = &transformer->config;
  TransformerWeights *w = &transformer->weights;
  RunState *s = &transformer->state;
  float *x = s->x;
  int dim = p->dim;
  int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
  int kv_mul =
      p->n_heads /
      p->n_kv_heads;  // integer multiplier of the kv sharing in multiquery
  int hidden_dim = p->hidden_dim;
  int head_size = dim / p->n_heads;  // 896/14=64

  // copy the token embedding into x
  for (int i = 0; i < prompt_token_num; i++) {
    memcpy(x + i * dim, w->token_embedding_table + prompt_tokens[i] * dim,
           dim * sizeof(float));
  }
  // memcpy(x, w->token_embedding_table + token * dim, dim * sizeof(float));

  // forward all the layers
  for (unsigned long long l = 0; l < p->n_layers-1; l++) {
    // attention rmsnorm
    // check in 2.26
    rmsnorm_prefill(s->xb, x, w->rms_att_weight + l * dim, dim,
                    prompt_token_num);

    // qkv matmuls for this position
    quantize_prefill(&s->xq, s->xb, dim, 128, prompt_token_num);  // 128

    // start = TimeInNs();
    gemm_scale_prefill(s->q, &s->xq, w->wq + l, dim, dim, prompt_token_num, 128,
                       my_window_act, my_window_wgt, my_window_result,
                       my_window_reg, my_window_scale);
    //  matmul_prefill(s->q, &s->xq, w->wq + l, dim, dim, prompt_token_num,
    //                 128); // W (d=dim, n=dim) @ x (n=dim,) -> xout (d,)

    // end = TimeInNs();
    // printf("gemm_scale_prefill for q time is, %lld\n", end - start);

    // printf("begin gemm\n");
    matmul_prefill(s->k, &s->xq, w->wk + l, dim, kv_dim, prompt_token_num,
                   128);  // W (d=kvdim, n=dim) @ x (n=dim,) -> xout (d,)
    // gemm(s->k, &s->xq, w->wk + l, dim, kv_dim, 128, my_window_act,
    // my_window_wgt, my_window_result, my_window_reg); printf("end gemm\n");
    matmul_prefill(s->v, &s->xq, w->wv + l, dim, kv_dim, prompt_token_num, 128);
    // gemm(s->v, &s->xq, w->wv + l, dim, kv_dim, 128, my_window_act,
    // my_window_wgt, my_window_result, my_window_reg);

    if (bias) {
      // float *bq = calloc(dim, sizeof(float));
      // float *bk = calloc(kv_dim, sizeof(float));
      // float *bv = calloc(kv_dim, sizeof(float));
      // dequantize_vector(bq, w->bq + l, dim);
      // dequantize_vector(bk, w->bk + l, kv_dim);
      // dequantize_vector(bv, w->bv + l, kv_dim);
      // printf("1129\n");
      dequantize_vector_128(w->dbq, w->bq + l, dim);
      dequantize_vector_128(w->dbk, w->bk + l, kv_dim);
      dequantize_vector_128(w->dbv, w->bv + l, kv_dim);
      // printf("1133\n");
      int k1;
#pragma omp parallel for private(k1)
      for (k1 = 0; k1 < prompt_token_num; k1++) {
        for (int i = 0; i < dim; i++) {
          s->q[k1 * dim + i] += w->dbq[i];
        }
        for (int i = 0; i < kv_dim; i++) {
          s->k[k1 * kv_dim + i] += w->dbk[i];
          s->v[k1 * kv_dim + i] += w->dbv[i];
        }
      }
      // free(bq);
      // free(bk);
      // free(bv);
    }

    // // RoPE relative positional encoding: complex-valued rotate q and k in
    // each
    // // head
    // for (int i = 0; i < p->n_heads; i++) {
    //   for (int j = 0; j < head_size; j += 2) {
    //     float freq = 1.0f / powf(500000.0f, (float)j / (float)head_size);
    //     float val = pos * freq;
    //     float fcr = cosf(val);
    //     float fci = sinf(val);
    //     float q0 = s->q[i * head_size + j];
    //     float q1 = s->q[i * head_size + j + 1];
    //     s->q[i * head_size + j] = q0 * fcr - q1 * fci;
    //     s->q[i * head_size + j + 1] = q0 * fci + q1 * fcr;
    //     if (i < p->n_kv_heads) {
    //       float k0 = s->k[i * head_size + j];
    //       float k1 = s->k[i * head_size + j + 1];
    //       s->k[i * head_size + j] = k0 * fcr - k1 * fci;
    //       s->k[i * head_size + j + 1] = k0 * fci + k1 * fcr;
    //     }
    //   }
    // }
    int k;
#pragma omp parallel for private(k)
    for (k = 0; k < prompt_token_num; k++) {
      for (int i = 0; i < p->dim; i += head_size) {
        for (int head_dim = i % head_size; head_dim < head_size / 2;
             head_dim++) {
          float freq =
              1.0f / powf(1000000.0f, (float)(head_dim * 2) / (float)head_size);
          float val = (k)*freq;  // pos*freq
          float fci = sinf(val);
          float fcr = cosf(val);

          float q0 = s->q[k * p->dim + i + head_dim];
          float q1 = s->q[k * p->dim + i + head_dim + head_size / 2];
          s->q[k * p->dim + i + head_dim] = q0 * fcr - q1 * fci;
          s->q[k * p->dim + i + head_dim + head_size / 2] = q0 * fci + q1 * fcr;
          if (i < p->n_kv_heads * head_size) {
            float k0 = s->k[k * p->dim / 7 + i + head_dim];
            float k1 = s->k[k * p->dim / 7 + i + head_dim + head_size / 2];
            s->k[k * p->dim / 7 + i + head_dim] = k0 * fcr - k1 * fci;
            s->k[k * p->dim / 7 + i + head_dim + head_size / 2] =
                k0 * fci + k1 * fcr;
          }
        }
      }
    }

    // printf("end rope\n");
    //  save key,value at this time step (pos) to our kv cache
    int loff =
        l * p->seq_len * kv_dim;  // kv cache layer offset for convenience
    int t;
#pragma omp parallel for private(t)
    for (t = 0; t < prompt_token_num; t++) {
      float *key_cache_row = s->key_cache + loff + t * kv_dim;
      float *value_cache_row = s->value_cache + loff + t * kv_dim;
      memcpy(key_cache_row, s->k + t * kv_dim, kv_dim * sizeof(*key_cache_row));
      memcpy(value_cache_row, s->v + t * kv_dim,
             kv_dim * sizeof(*value_cache_row));
    }

    int num;
    // need to correct, cannot be parallel
#pragma omp parallel for private(num)
    // printf("1217, %d\n", prompt_token_num); 644
    for (num = 0; num < prompt_token_num; num++) {
      // multihead attention. iterate over all heads
      int h;
#pragma omp parallel for private(h)
      for (h = 0; h < p->n_heads; h++) {
        // get the query vector for this head
        float *q = s->q + num * p->dim + h * head_size;
        // attention scores for this head
        float *att = s->att + h * p->seq_len + num * p->seq_len * p->n_heads;
        // iterate over all timesteps, including the current one
        for (int t = 0; t <= num; t++) {
          // get the key vector for this head and at this timestep
          float *k =
              s->key_cache + loff + t * kv_dim + (h / kv_mul) * head_size;
          // calculate the attention score as the dot product of q and k
          float score = 0.0f;
          for (int i = 0; i < head_size; i++) {
            score += q[i] * k[i];
          }
          score /= sqrtf(head_size);
          // save the score to the attention buffer
          att[t] = score;
        }

        // softmax the scores to get attention weights, from 0..pos inclusively
        softmax(att, num + 1);

        // weighted sum of the values, store back into xb
        float *xb = s->xb + h * head_size + num * p->dim;
        memset(xb, 0, head_size * sizeof(float));
        for (int t = 0; t <= num; t++) {
          // get the value vector for this head and at this timestep
          float *v =
              s->value_cache + loff + t * kv_dim + (h / kv_mul) * head_size;
          // get the attention weight for this timestep
          float a = att[t];
          // accumulate the weighted value into xb
          for (int i = 0; i < head_size; i++) {
            xb[i] += a * v[i];
          }
        }
      }
    }
    // printf("1258\n");

    // final matmul to get the output of the attention
    quantize_prefill(&s->xq, s->xb, dim, 128, prompt_token_num);
    matmul_prefill(s->xb2, &s->xq, w->wo + l, dim, dim, prompt_token_num,
                   128);  // W (d=dim, n=dim) @ x (n=dim,) -> xout (d,)

    // residual connection back into x
    int i1;
#pragma omp parallel for private(i1)
    for (i1 = 0; i1 < dim * prompt_token_num; i1++) {
      x[i1] += s->xb2[i1];
    }

    // printf("ffn rmsnorm begin\n");
    //  ffn rmsnorm
    rmsnorm_prefill(s->xb, x, w->rms_ffn_weight + l * dim, dim,
                    prompt_token_num);

    // Now for FFN in PyTorch we have: self.w2(F.silu(self.w1(x)) * self.w3(x))
    // first calculate self.w1(x) and self.w3(x)
    quantize_prefill(&s->xq, s->xb, dim, 128, prompt_token_num);
    matmul_prefill(s->hb, &s->xq, w->w1 + l, dim, hidden_dim, prompt_token_num,
                   128);  // W (d=hidden_dim, n=dim) @ x (n=dim,) -> xout (d,)
    matmul_prefill(s->hb2, &s->xq, w->w3 + l, dim, hidden_dim, prompt_token_num,
                   128);  // W (d=hidden_dim, n=dim) @ x (n=dim,) -> xout (d,)

    int t1;
#pragma omp parallel for private(t1)
    for (t1 = 0; t1 < prompt_token_num; t1++) {
      // SwiGLU non-linearity
      for (int i = 0; i < hidden_dim; i++) {
        float val = s->hb[i + t1 * hidden_dim];
        // silu(x)=x*s(x), where s(x) is the logistic sigmoid
        val *= (1.0f / (1.0f + expf(-val)));
        // elementwise multiply with w3(x)
        val *= s->hb2[i + t1 * hidden_dim];
        s->hb[i + t1 * hidden_dim] = val;
      }
    }

    // printf("1289\n");
    //  final matmul to get the output of the ffn
    quantize_prefill(&s->hq, s->hb, hidden_dim, 128, prompt_token_num);
    // printf("1291\n");
    matmul_prefill(
        s->xb, &s->hq, w->w2 + l, hidden_dim, dim, prompt_token_num,
        128);  // W (d=dim, n=hiddendim) @ x (n=hiddendim,) -> xout (d,)

    // printf("1296\n");
    int t2;
#pragma omp parallel for private(t2)
    for (t2 = 0; t2 < prompt_token_num; t2++) {
      // residual connection
      for (int i = 0; i < dim; i++) {
        x[i + t2 * dim] += s->xb[i + t2 * dim];
      }
    }
  }

  // // final rmsnorm
  // rmsnorm(x, x, w->rms_final_weight, dim);

  // // classifier into logits
  // quantize(&s->xq, x, dim, 128);
  // matmul(s->logits, &s->xq, w->wcls, dim, p->vocab_size, 128); // W
  // (d=vocab_size, n=dim) @ x (n=dim,) -> xout (d,) return s->logits;

  return 0;
}

// ----------------------------------------------------------------------------
// The Byte Pair Encoding (BPE) Tokenizer that translates strings <-> tokens

typedef struct {
  char *str;
  int id;
} TokenIndex;

typedef struct {
  char **vocab;
  float *vocab_scores;
  TokenIndex *sorted_vocab;
  int vocab_size;
  unsigned int max_token_length;
  unsigned char byte_pieces[512];  // stores all single-byte strings
} Tokenizer;

int compare_tokens(const void *a, const void *b) {
  return strcmp(((TokenIndex *)a)->str, ((TokenIndex *)b)->str);
}

void build_tokenizer(Tokenizer *t, char *tokenizer_path, int vocab_size) {
  // i should have written the vocab_size into the tokenizer file... sigh
  t->vocab_size = vocab_size;
  // malloc space to hold the scores and the strings
  t->vocab = (char **)malloc(vocab_size * sizeof(char *));
  t->vocab_scores = (float *)malloc(vocab_size * sizeof(float));
  t->sorted_vocab = NULL;  // initialized lazily
  for (int i = 0; i < 256; i++) {
    t->byte_pieces[i * 2] = (unsigned char)i;
    t->byte_pieces[i * 2 + 1] = '\0';
  }
  // read in the file
  FILE *file = fopen(tokenizer_path, "rb");
  if (!file) {
    fprintf(stderr, "couldn't load %s\n", tokenizer_path);
    exit(EXIT_FAILURE);
  }
  if (fread(&t->max_token_length, sizeof(int), 1, file) != 1) {
    fprintf(stderr, "failed read\n");
    exit(EXIT_FAILURE);
  }
  int len;
  for (int i = 0; i < vocab_size; i++) {
    if (fread(t->vocab_scores + i, sizeof(float), 1, file) != 1) {
      fprintf(stderr, "failed read\n");
      exit(EXIT_FAILURE);
    }
    if (fread(&len, sizeof(int), 1, file) != 1) {
      fprintf(stderr, "failed read\n");
      exit(EXIT_FAILURE);
    }
    t->vocab[i] = (char *)malloc(len + 1);
    if (fread(t->vocab[i], len, 1, file) != 1) {
      fprintf(stderr, "failed read\n");
      exit(EXIT_FAILURE);
    }
    t->vocab[i][len] = '\0';  // add the string terminating token
  }
  fclose(file);
}

void free_tokenizer(Tokenizer *t) {
  for (int i = 0; i < t->vocab_size; i++) {
    free(t->vocab[i]);
  }
  free(t->vocab);
  free(t->vocab_scores);
  free(t->sorted_vocab);
}

// char *decode(Tokenizer *t, int prev_token, int token) {
//   char *piece = t->vocab[token];

//   // careful, some tokens designate raw bytes, and look like e.g. '<0x01>'
//   // parse this and convert and return the actual byte
//   unsigned char byte_val;
//   if (sscanf(piece, "<0x%02hhX>", &byte_val) == 1) {
//     piece = (char *)t->byte_pieces + byte_val * 2;
//   }
//   return piece;
// }
void decode(Tokenizer *t, int token, char *string) {
  char *piece = t->vocab[token];
  int piece_ori_len = 0;
  int string_len = 0;

  // blank and new line
  char *blank_char = "Ġ";  // 2 bytes: 0xC4 0xA0 (UTF-8 representation of 'Ġ')
  char *new_line_char =
      "Ċ";  // 2 bytes: 0xC4 0x8A (UTF-8 representation of 'Ċ')

  while (piece[piece_ori_len] != '\0') {
    // blank
    if (piece[piece_ori_len] == blank_char[0]) {
      if (piece[piece_ori_len + 1] == blank_char[1]) {
        string[string_len++] = ' ';
      } else {
        string[string_len++] = '\n';
      }
      piece_ori_len++;
    } else {
      string[string_len++] = piece[piece_ori_len];
    }
    piece_ori_len++;
  }
  string[string_len++] = '\0';
}

void safe_printf(char *piece) {
  // piece might be a raw byte token, and we only want to print printable chars
  // or whitespace because some of the other bytes can be various control codes,
  // backspace, etc.
  if (piece == NULL) {
    return;
  }
  if (piece[0] == '\0') {
    return;
  }
  if (piece[1] == '\0') {
    unsigned char byte_val = piece[0];
    if (!(isprint(byte_val) || isspace(byte_val))) {
      return;  // bad byte, don't print it
    }
  }
  printf("%s", piece);
}

int str_lookup(char *str, TokenIndex *sorted_vocab, int vocab_size) {
  // efficiently find the perfect match for str in vocab, return its index or -1
  // if not found
  TokenIndex tok = {.str = str};  // acts as the key to search for
  TokenIndex *res = bsearch(&tok, sorted_vocab, vocab_size, sizeof(TokenIndex),
                            compare_tokens);
  return res != NULL ? res->id : -1;
}

void encode(Tokenizer *t, char *text, int8_t bos, int8_t eos, int *tokens,
            int *n_tokens) {
  // encode the string text (input) into an upper-bound preallocated tokens[]
  // array bos != 0 means prepend the BOS token (=1), eos != 0 means append the
  // EOS token (=2)
  if (text == NULL) {
    fprintf(stderr, "cannot encode NULL text\n");
    exit(EXIT_FAILURE);
  }

  if (t->sorted_vocab == NULL) {
    // lazily malloc and sort the vocabulary
    t->sorted_vocab = malloc(t->vocab_size * sizeof(TokenIndex));
    for (int i = 0; i < t->vocab_size; i++) {
      t->sorted_vocab[i].str = t->vocab[i];
      t->sorted_vocab[i].id = i;
    }
    qsort(t->sorted_vocab, t->vocab_size, sizeof(TokenIndex), compare_tokens);
  }

  // create a temporary buffer that will store merge candidates of always two
  // consecutive tokens *2 for concat, +1 for null terminator +2 for UTF8 (in
  // case max_token_length is 1)
  char *str_buffer = malloc((t->max_token_length * 2 + 1 + 2) * sizeof(char));
  size_t str_len = 0;

  // start at 0 tokens
  *n_tokens = 0;

  // add optional BOS (=128000) token, if desired
  if (bos) tokens[(*n_tokens)++] = 128000;

  // add_dummy_prefix is true by default
  // so prepend a dummy prefix token to the input string, but only if text != ""
  // TODO: pretty sure this isn't correct in the general case but I don't have
  // the energy to read more of the sentencepiece code to figure out what it's
  // doing

  // Okay UTF-8 time. This will get messy. Here is the reference from Wikipedia:
  // Code point ? UTF-8 conversion
  // First code point	Last code point	Byte 1	Byte 2	Byte 3	Byte 4
  // U+0000	U+007F	    0xxxxxxx
  // U+0080	U+07FF	    110xxxxx	10xxxxxx
  // U+0800	U+FFFF	    1110xxxx	10xxxxxx	10xxxxxx
  // U+10000	U+10FFFF    11110xxx	10xxxxxx	10xxxxxx	10xxxxxx

  // process the raw (UTF-8) byte sequence of the input string
  for (char *c = text; *c != '\0'; c++) {
    // reset buffer if the current byte is ASCII or a leading byte
    // 0xC0 is 11000000, so (*c & 0xC0) keeps the first 2 bits and zeros the
    // rest 0x80 is 10000000 in UTF-8, all continuation bytes start with "10" in
    // first two bits so in English this is: "if this byte is not a continuation
    // byte"
    if ((*c & 0xC0) != 0x80) {
      // this byte must be either a leading byte (11...) or an ASCII char
      // (0x...)
      // => reset our location, as we're starting a new UTF-8 codepoint
      str_len = 0;
    }

    // append the current byte to the buffer
    str_buffer[str_len++] =
        *c;  // ++ is post-increment, incremented after this line
    str_buffer[str_len] = '\0';

    // while the next character is a continuation byte, continue appending
    // but if there are too many of them, just stop to avoid overruning
    // str_buffer size.
    if ((*(c + 1) & 0xC0) == 0x80 && str_len < 4) {
      continue;
    }

    // ok c+1 is not a continuation byte, so we've read in a full codepoint
    int id = str_lookup(str_buffer, t->sorted_vocab, t->vocab_size);

    if (id != -1) {
      // we found this codepoint in vocab, add it as a token
      tokens[(*n_tokens)++] = id;
    } else {
      // byte_fallback encoding: just encode each byte as a token
      // +3 is here because the first 3 vocab elements are <unk>, <s>, </s>
      // so the individual bytes only start at index 3
      for (int i = 0; i < str_len; i++) {
        tokens[(*n_tokens)++] = (unsigned char)str_buffer[i] + 3;
      }
    }
    str_len = 0;  // protect against a sequence of stray UTF8 continuation bytes
  }

  // merge the best consecutive pair or triple each iteration, according to the
  // scores in vocab_scores
  while (1) {
    float best_score = -1e10;
    int best_id = -1;
    int best_idx = -1;
    int best_len =
        2;  // length of the best merge sequence (2 for pair, 3 for triple)

    // first, try to find the best pair to merge
    for (int i = 0; i < (*n_tokens - 1); i++) {
      // check if we can merge the pair (tokens[i], tokens[i+1])
      sprintf(str_buffer, "%s%s", t->vocab[tokens[i]], t->vocab[tokens[i + 1]]);
      int id = str_lookup(str_buffer, t->sorted_vocab, t->vocab_size);
      if (id != -1 && t->vocab_scores[id] > best_score) {
        // this merge pair exists in vocab! record its score and position
        best_score = t->vocab_scores[id];
        best_id = id;
        best_idx = i;
      }
    }

    // if no pair was found, try to find the best triple to merge
    if (best_idx == -1) {
      for (int i = 0; i < (*n_tokens - 2); i++) {
        // check if we can merge the triple (tokens[i], tokens[i+1],
        // tokens[i+2])
        sprintf(str_buffer, "%s%s%s", t->vocab[tokens[i]],
                t->vocab[tokens[i + 1]], t->vocab[tokens[i + 2]]);
        int id = str_lookup(str_buffer, t->sorted_vocab, t->vocab_size);
        if (id != -1 && t->vocab_scores[id] > best_score) {
          // this merge triple exists in vocab! record its score and position
          best_score = t->vocab_scores[id];
          best_id = id;
          best_idx = i;
          best_len = 3;
        }
      }
    }

    if (best_idx == -1) {
      break;  // we couldn't find any more pairs or triples to merge, so we're
              // done
    }

    // merge the consecutive pair or triple (best_idx, best_idx+1[, best_idx+2])
    // into new token best_id
    tokens[best_idx] = best_id;
    // delete token(s) at position best_idx+1 (and optionally best_idx+2), shift
    // the entire sequence back
    for (int i = best_idx + 1; i < (*n_tokens - best_len + 1); i++) {
      tokens[i] = tokens[i + best_len - 1];
    }
    (*n_tokens) -=
        (best_len -
         1);  // token length decreased by the number of merged tokens minus one
  }

  // add optional EOS (=128001) token, if desired
  if (eos) tokens[(*n_tokens)++] = 128001;

  free(str_buffer);
}

// ----------------------------------------------------------------------------
// The Sampler, which takes logits and returns a sampled token
// sampling can be done in a few ways: greedy argmax, sampling, top-p sampling

typedef struct {
  float prob;
  int index;
} ProbIndex;  // struct used when sorting probabilities during top-p sampling

typedef struct {
  int vocab_size;
  ProbIndex *probindex;  // buffer used in top-p sampling
  float temperature;
  float topp;
  unsigned long long rng_state;
} Sampler;

int sample_argmax(float *probabilities, int n) {
  // return the index that has the highest probability
  int max_i = 0;
  float max_p = probabilities[0];
  for (int i = 1; i < n; i++) {
    if (probabilities[i] > max_p) {
      max_i = i;
      max_p = probabilities[i];
    }
  }
  return max_i;
}

int sample_mult(float *probabilities, int n, float coin) {
  // sample index from probabilities (they must sum to 1!)
  // coin is a random number in [0, 1), usually from random_f32()
  float cdf = 0.0f;
  for (int i = 0; i < n; i++) {
    cdf += probabilities[i];
    if (coin < cdf) {
      return i;
    }
  }
  return n - 1;  // in case of rounding errors
}

int compare(const void *a, const void *b) {
  ProbIndex *a_ = (ProbIndex *)a;
  ProbIndex *b_ = (ProbIndex *)b;
  if (a_->prob > b_->prob) return -1;
  if (a_->prob < b_->prob) return 1;
  return 0;
}

int sample_topp(float *probabilities, int n, float topp, ProbIndex *probindex,
                float coin) {
  // top-p sampling (or "nucleus sampling") samples from the smallest set of
  // tokens that exceed probability topp. This way we never sample tokens that
  // have very low probabilities and are less likely to go "off the rails".
  // coin is a random number in [0, 1), usually from random_f32()

  int n0 = 0;
  // quicksort indices in descending order of probabilities
  // values smaller than (1 - topp) / (n - 1) cannot be part of the result
  // so for efficiency we crop these out as candidates before sorting
  const float cutoff = (1.0f - topp) / (n - 1);
  for (int i = 0; i < n; i++) {
    if (probabilities[i] >= cutoff) {
      probindex[n0].index = i;
      probindex[n0].prob = probabilities[i];
      n0++;
    }
  }
  qsort(probindex, n0, sizeof(ProbIndex), compare);

  // truncate the list where cumulative probability exceeds topp
  float cumulative_prob = 0.0f;
  int last_idx = n0 - 1;  // in case of rounding errors consider all elements
  for (int i = 0; i < n0; i++) {
    cumulative_prob += probindex[i].prob;
    if (cumulative_prob > topp) {
      last_idx = i;
      break;  // we've exceeded topp by including last_idx
    }
  }

  // sample from the truncated list
  float r = coin * cumulative_prob;
  float cdf = 0.0f;
  for (int i = 0; i <= last_idx; i++) {
    cdf += probindex[i].prob;
    if (r < cdf) {
      return probindex[i].index;
    }
  }
  return probindex[last_idx].index;  // in case of rounding errors
}

void build_sampler(Sampler *sampler, int vocab_size, float temperature,
                   float topp, unsigned long long rng_seed) {
  sampler->vocab_size = vocab_size;
  sampler->temperature = temperature;
  sampler->topp = topp;
  sampler->rng_state = rng_seed;
  // buffer only used with nucleus sampling; may not need but it's ~small
  sampler->probindex = malloc(sampler->vocab_size * sizeof(ProbIndex));
}

void free_sampler(Sampler *sampler) { free(sampler->probindex); }

unsigned int random_u32(unsigned long long *state) {
  // xorshift rng: https://en.wikipedia.org/wiki/Xorshift#xorshift.2A
  *state ^= *state >> 12;
  *state ^= *state << 25;
  *state ^= *state >> 27;
  return (*state * 0x2545F4914F6CDD1Dull) >> 32;
}
float random_f32(unsigned long long *state) {  // random float32 in [0,1)
  return (random_u32(state) >> 8) / 16777216.0f;
}

int sample(Sampler *sampler, float *logits) {
  // sample the token given the logits and some hyperparameters
  int next;
  if (sampler->temperature == 0.0f) {
    // greedy argmax sampling: take the token with the highest probability
    next = sample_argmax(logits, sampler->vocab_size);
  } else {
    // apply the temperature to the logits
    for (int q = 0; q < sampler->vocab_size; q++) {
      logits[q] /= sampler->temperature;
    }
    // apply softmax to the logits to get the probabilities for next token
    softmax(logits, sampler->vocab_size);
    // flip a (float) coin (this is our source of entropy for sampling)
    float coin = random_f32(&sampler->rng_state);
    // we sample from this distribution to get the next token
    if (sampler->topp <= 0 || sampler->topp >= 1) {
      // simply sample from the predicted probability distribution
      next = sample_mult(logits, sampler->vocab_size, coin);
    } else {
      // top-p (nucleus) sampling, clamping the least likely tokens to zero
      next = sample_topp(logits, sampler->vocab_size, sampler->topp,
                         sampler->probindex, coin);
    }
  }
  return next;
}

// ----------------------------------------------------------------------------
// utilities: time

// long time_in_ms()
// {
//     // return time in milliseconds, for benchmarking the model speed
//     struct timespec time;
//     clock_gettime(CLOCK_REALTIME, &time);
//     return time.tv_sec * 1000 + time.tv_nsec / 1000000;
// }

// ----------------------------------------------------------------------------
// generation loop

// void generate(Transformer *transformer, Tokenizer *tokenizer, Sampler
// *sampler,
//               char *prompt, int steps) {
//   char *empty_prompt = "";
//   if (prompt == NULL) {
//     prompt = empty_prompt;
//   }

//   // encode the (string) prompt into tokens sequence
//   int num_prompt_tokens = 0;
//   int *prompt_tokens = (int *)malloc((strlen(prompt) + 3) *
//                                      sizeof(int));  // +3 for '\0', ?BOS,
//                                      ?EOS
//   encode(tokenizer, prompt, 1, 0, prompt_tokens, &num_prompt_tokens);
//   if (num_prompt_tokens < 1) {
//     fprintf(stderr, "something is wrong, expected at least 1 prompt
//     token\n"); exit(EXIT_FAILURE);
//   }

//   // start the main loop
//   long start =
//       0;     // used to time our code, only initialized after first iteration
//   int next;  // will store the next token in the sequence
//   int token = prompt_tokens[0];  // kick off with the first token in the
//   prompt int pos = 0;                   // position in the sequence

//   while (pos < steps) {
//     // forward the transformer to get logits for the next token
//     float *logits = forward(transformer, token, pos, true);

//     // advance the state machine
//     if (pos < num_prompt_tokens - 1) {
//       // if we are still processing the input prompt, force the next prompt
//       // token
//       next = prompt_tokens[pos + 1];
//     } else {
//       // otherwise sample the next token from the logits
//       next = sample(sampler, logits);
//     }
//     pos++;

//     // data-dependent terminating condition: the BOS (=1) token delimits
//     // sequences
//     if ((next == 128001 || next == 128009) && pos > num_prompt_tokens) break;
//     // print the token as string, decode it with the Tokenizer object
//     char *piece = decode(tokenizer, token, next);
//     safe_printf(
//         piece);  // same as printf("%s", piece), but skips "unsafe" bytes
//     fflush(stdout);
//     token = next;

//     // init the timer here because the first iteration can be slower
//     if (start == 0) {
//       start = time_in_ms();
//     }
//   }
//   printf("\n");

//   // report achieved tok/s (pos-1 because the timer starts after first
//   // iteration)
//   if (pos > 1) {
//     long end = time_in_ms();
//     fprintf(stderr, "achieved tok/s: %f\n",
//             (pos - 1) / (double)(end - start) * 1000);
//   }

//   free(prompt_tokens);
// }

void read_stdin(const char *guide, char *buffer, size_t bufsize) {
  // read a line from stdin, up to but not including \n
  printf("%s", guide);
  if (fgets(buffer, bufsize, stdin) != NULL) {
    size_t len = strlen(buffer);
    if (len > 0 && buffer[len - 1] == '\n') {
      buffer[len - 1] = '\0';  // strip newline
    }
  }
}

void replace_spaces_with_G(char *system_prompt_ori,
                           char *system_prompt_dealed) {
  char *blank_char = "Ġ";  // 2 bytes: 0xC4 0xA0 (UTF-8 representation of 'Ġ')
  int char_ptr_ori = 0;
  int char_ptr_dealed = 0;

  // Iterate through the original string
  while (system_prompt_ori[char_ptr_ori] != '\0') {
    if (system_prompt_ori[char_ptr_ori] != ' ') {
      // If it's not a space, copy the character to the new string
      system_prompt_dealed[char_ptr_dealed++] = system_prompt_ori[char_ptr_ori];
    } else {
      // If it's a space, replace it with 'Ġ' (2 bytes)
      system_prompt_dealed[char_ptr_dealed++] = blank_char[0];
      system_prompt_dealed[char_ptr_dealed++] = blank_char[1];
    }
    char_ptr_ori++;
  }
  // Null-terminate the resulting string
  system_prompt_dealed[char_ptr_dealed] = '\0';
}

int promote_to_token(Tokenizer *tokenizer, char *user_prompt,
                     char *system_prompt, int *prompt_tokens) {
  // buffers for reading the system prompt and user prompt from stdin
  int num_prompt_tokens = 0;
  int *system_prompt_tokens = (int *)malloc(32768 * sizeof(int));
  int *user_prompt_tokens = (int *)malloc(32768 * sizeof(int));

  // ----------------- System promot ----------------------
  prompt_tokens[num_prompt_tokens++] = 151644;  // "<|im_start|>"
  prompt_tokens[num_prompt_tokens++] = 8948;    // "system"
  prompt_tokens[num_prompt_tokens++] = 198;     // "\n"

  char *system_prompt_dealed = (char *)malloc(32768 * sizeof(char));
  char *blank_char = "Ġ";
  // replace blank to Ġ (two bytes) Ġ = 0xC4(LSB) 0xA0(HSB)
  replace_spaces_with_G(system_prompt, system_prompt_dealed);

  int num_system_prompt_tokens = 0;
  encode(tokenizer, system_prompt_dealed, 0, 0, system_prompt_tokens,
         &num_system_prompt_tokens);

  // copy system_prompt_tokens to prompt_tokens
  for (int ptr = 0; ptr < num_system_prompt_tokens; ptr++) {
    prompt_tokens[num_prompt_tokens++] = system_prompt_tokens[ptr];
  }

  // end
  prompt_tokens[num_prompt_tokens++] = 151645;  // "<|im_end|>"
  prompt_tokens[num_prompt_tokens++] = 198;     // "\n"

  // ----------------- User promot ----------------------
  prompt_tokens[num_prompt_tokens++] = 151644;  // "<|im_start|>"
  prompt_tokens[num_prompt_tokens++] = 872;     // "user"
  prompt_tokens[num_prompt_tokens++] = 198;     // "\n"

  char *user_prompt_dealed = (char *)malloc(32768 * sizeof(char));
  replace_spaces_with_G(user_prompt, user_prompt_dealed);

  int num_user_prompt_tokens = 0;
  encode(tokenizer, user_prompt_dealed, 0, 0, user_prompt_tokens,
         &num_user_prompt_tokens);

  // Copy to prompt_tokens
  for (int i = 0; i < num_user_prompt_tokens; i++) {
    prompt_tokens[num_prompt_tokens++] = user_prompt_tokens[i];
  }

  // user promot end
  prompt_tokens[num_prompt_tokens++] = 151645;  // "<|im_end|>"
  prompt_tokens[num_prompt_tokens++] = 198;     // "\n"

  // assistent
  prompt_tokens[num_prompt_tokens++] = 151644;  // "<|im_start|>"
  prompt_tokens[num_prompt_tokens++] = 77091;   // "assistant"
  prompt_tokens[num_prompt_tokens++] = 198;     // "\n"

  // free(string_out);
  free(system_prompt_tokens);
  free(user_prompt_tokens);
  free(system_prompt_dealed);
  free(user_prompt_dealed);

  return num_prompt_tokens;
}

// ----------------------------------------------------------------------------
// chat loop
// I manually inspected the tokens for a few chat conversations compared to
// python reference and that seemed ok, but this was not thoroughly tested and
// is not safely implemented, it's more a proof of concept atm.

void chat(Transformer *transformer, Tokenizer *tokenizer, Sampler *sampler,
          char *user_prompt, char *system_prompt, float *prefill_throughput,
          float *decode_throughput, int steps) {
  // PYNQ_loadBitstream("/home/ubuntu/AICAS/AICAS/PYNQ/aicas02163.bit");
  //  PYNQ_loadBitstream("/home/ubuntu/AICAS/AICAS/PYNQ/hardware/aicas03173.bit");
  // PYNQ_loadBitstream("/home/ubuntu/AICAS/AICAS/PYNQ/hardware/aicas03193.bit");
  // PYNQ_loadBitstream("/home/ubuntu/AICAS/AICAS/PYNQ/hardware/pre03241.bit");
  PYNQ_loadBitstream("/home/ubuntu/AICAS/AICAS/PYNQ/hardware/pre03261.bit");

  PYNQ_MMIO_WINDOW my_window_act;
  PYNQ_MMIO_WINDOW my_window_wgt;
  PYNQ_MMIO_WINDOW my_window_result;
  PYNQ_MMIO_WINDOW my_window_reg;
  PYNQ_MMIO_WINDOW my_window_scale;

  PYNQ_createMMIOWindow(&my_window_act, A0020000, 128 * 10 * sizeof(int8_t));
  PYNQ_createMMIOWindow(&my_window_wgt, A0040000, 128 * 896 * sizeof(int8_t));
  PYNQ_createMMIOWindow(&my_window_scale, A0060000, 912 * sizeof(float));
  PYNQ_createMMIOWindow(&my_window_result, A0030000, 896 * 10 * sizeof(float));
  PYNQ_createMMIOWindow(&my_window_reg, B0000000, 64 * sizeof(int));

  printf("\nUser prompt: \n%s\n", user_prompt);
  printf("\nAnswer: \n");

  // promote string -> token numbers
  int *prompt_tokens = (int *)malloc(32768 * sizeof(int));
  int prompt_token_num = 0;
  prompt_token_num =
      promote_to_token(tokenizer, user_prompt, system_prompt, prompt_tokens);

  // Time
  long start = 0;
  long end = 0;
  long prefill = 0;

  // Inference loop
  int next;                      // will store the next token in the sequence
  int token = prompt_tokens[0];  // stores the current token to feed into the
                                 // transformer
  char *decoded_string = (char *)malloc(32768 * sizeof(char));

  int pos = 0;  // position in the sequence
  int promot_idx = 0;
  while (pos < steps) {
    if (start == 0) {
      start = time_in_ms();
    }

    if (pos == 1) {
      printf("pos=1,pos 0 is done.\n");
    }

    // float *logits = forward(transformer, token, pos, true, &my_window_act,
    // &my_window_wgt, &my_window_result, &my_window_reg);

    if (pos == 0) {
      printf("pos==0 is begin.\n");
      float *logits =
          forward_prefill(transformer, prompt_tokens, prompt_token_num - 1,
                          true, &my_window_act, &my_window_wgt,
                          &my_window_result, &my_window_reg, &my_window_scale);
      printf("pos==0 is done.\n");
      pos = prompt_token_num - 2;
      next = prompt_tokens[pos + 1];
    } else if (pos >= prompt_token_num - 1) {
      // printf("pos in == %d is begin.\n", pos);
      float *logits =
          forward(transformer, token, pos, true, &my_window_act, &my_window_wgt,
                  &my_window_result, &my_window_reg, &my_window_scale);
      next = sample(sampler, logits);
    }
    // printf("pos == %d is begin.\n", pos);
    // printf("prompt token num == %d is begin.\n", prompt_token_num);
    //  if (pos < prompt_token_num - 1) {
    //    float *logits = forward_prefill(transformer, token, pos, true,
    //    &my_window_act, &my_window_wgt, &my_window_result, &my_window_reg);
    //    next = prompt_tokens[pos + 1];
    //  } else {
    //    float *logits = forward(transformer, token, pos, true, &my_window_act,
    //    &my_window_wgt, &my_window_result, &my_window_reg); next =
    //    sample(sampler, logits);
    //  }

    pos++;

    if (pos > steps) break;

    // Show decoded string
    if (pos >= prompt_token_num) {
      // End  <|endoftext|>
      if (next == 151645) {
        printf("\n");
        break;
      }

      decode(tokenizer, next, decoded_string);
      safe_printf(decoded_string);
      fflush(stdout);
    }

    if (pos == prompt_token_num) {
      // prefill end
      prefill = time_in_ms() - start;
      start = 0;
    }

    token = next;
  }

  if (pos > 1) {
    long end = time_in_ms();
    *prefill_throughput = prompt_token_num / (double)(prefill) * 1000;
    *decode_throughput =
        (pos - prompt_token_num) / (double)(end - start) * 1000;
    fprintf(stderr, "achieved prefill tok/s: %f\n", *prefill_throughput);
    fprintf(stderr, "achieved decode tok/s: %f\n", *decode_throughput);
  }

  free(prompt_tokens);
  free(decoded_string);

  // // Close MMIO window
  printf("closewindow");
  PYNQ_closeMMIOWindow(&my_window_act);
  PYNQ_closeMMIOWindow(&my_window_wgt);
  PYNQ_closeMMIOWindow(&my_window_result);
  PYNQ_closeMMIOWindow(&my_window_reg);
  PYNQ_closeMMIOWindow(&my_window_scale);
}
// void chat(Transformer *transformer, Tokenizer *tokenizer, Sampler *sampler,
//           char *cli_user_prompt, char *cli_system_prompt, int steps) {
//   // buffers for reading the system prompt and user prompt from stdin
//   // you'll notice they are somewhat haphazardly and unsafely set atm
//   char *system_prompt = (char *)malloc(32768 * sizeof(char));
//   char *user_prompt = (char *)malloc(32768 * sizeof(char));
//   int num_prompt_tokens = 0;
//   int *prompt_tokens = (int *)malloc(32768 * sizeof(int));
//   int *system_prompt_tokens = (int *)malloc(32768 * sizeof(int));
//   int *user_prompt_tokens = (int *)malloc(32768 * sizeof(int));
//   int user_idx = 0;

//   // start the main loop
//   int8_t user_turn = 1;  // user starts
//   int next;              // will store the next token in the sequence
//   int token;  // stores the current token to feed into the transformer

//   int pos = 0;  // position in the sequence
//   while (pos < steps) {
//     // when it is the user's turn to contribute tokens to the dialog...
//     if (user_turn) {
//       // get the (optional) system prompt at position 0
//       if (pos == 0) {
//         // at position 0, the user can also contribute a system prompt
//         prompt_tokens[num_prompt_tokens++] = 128000;  // "<|begin_of_text|>"
//         prompt_tokens[num_prompt_tokens++] = 128006;  //
//         "<|start_header_id|>" prompt_tokens[num_prompt_tokens++] = 9125; //
//         "system" prompt_tokens[num_prompt_tokens++] = 128007;  //
//         "<|end_header_id|>" prompt_tokens[num_prompt_tokens++] = 271;     //
//         "\n\n" if (cli_system_prompt == NULL) {
//           // system prompt was not passed in, attempt to get it from stdin
//           read_stdin("Enter system prompt (optional): ", system_prompt,
//           32768);
//         } else {
//           // system prompt was passed in, use it
//           strcpy(system_prompt, cli_system_prompt);
//         }
//         if (system_prompt != NULL) {
//           int num_system_prompt_tokens = 0;
//           encode(tokenizer, system_prompt, 0, 0, system_prompt_tokens,
//                  &num_system_prompt_tokens);
//           for (int i = 0; i < num_system_prompt_tokens; i++) {
//             prompt_tokens[num_prompt_tokens++] = system_prompt_tokens[i];
//           }
//         }
//         prompt_tokens[num_prompt_tokens++] = 128009;  // "<|eot_id|>"
//       } else {
//         num_prompt_tokens = 0;
//       }
//       prompt_tokens[num_prompt_tokens++] = 128006;  // "<|start_header_id|>"
//       prompt_tokens[num_prompt_tokens++] = 882;     // "user"
//       prompt_tokens[num_prompt_tokens++] = 128007;  // "<|end_header_id|>"
//       prompt_tokens[num_prompt_tokens++] = 271;     // "\n\n"
//       // get the user prompt
//       if (pos == 0 && cli_user_prompt != NULL) {
//         // user prompt for position 0 was passed in, use it
//         strcpy(user_prompt, cli_user_prompt);
//       } else {
//         // otherwise get user prompt from stdin
//         read_stdin("User (or exit): ", user_prompt, 32768);
//         if (strcmp(user_prompt, "exit") == 0) break;
//       }
//       int num_user_prompt_tokens = 0;
//       // encode the user prompt into tokens
//       encode(tokenizer, user_prompt, 0, 0, user_prompt_tokens,
//              &num_user_prompt_tokens);
//       for (int i = 0; i < num_user_prompt_tokens; i++) {
//         prompt_tokens[num_prompt_tokens++] = user_prompt_tokens[i];
//       }
//       prompt_tokens[num_prompt_tokens++] = 128009;  // "<|eot_id|>"
//       prompt_tokens[num_prompt_tokens++] = 128006;  // "<|start_header_id|>"
//       prompt_tokens[num_prompt_tokens++] = 78191;   // "assistant"
//       prompt_tokens[num_prompt_tokens++] = 128007;  // "<|end_header_id|>"
//       prompt_tokens[num_prompt_tokens++] = 271;     // "\n\n"

//       user_idx = 0;  // reset the user index
//       user_turn = 0;
//       printf("Assistant: ");
//     }

//     // determine the token to pass into the transformer next
//     if (user_idx < num_prompt_tokens) {
//       // if we are still processing the input prompt, force the next prompt
//       // token
//       token = prompt_tokens[user_idx++];
//     } else {
//       // otherwise use the next token sampled from previous turn
//       token = next;
//     }
//     // EOS (=128009) token ends the Assistant turn
//     if (user_idx >= num_prompt_tokens && (token == 128009 || token ==
//     128001)) {
//       user_turn = 1;
//     }

//     // forward the transformer to get logits for the next token
//     float *logits = forward(transformer, token, pos, true);
//     next = sample(sampler, logits);
//     pos++;

//     if (user_idx >= num_prompt_tokens && next != 128009 && next != 128001 &&
//         next != 128006) {
//       // the Assistant is responding, so print its output
//       char *piece = decode(tokenizer, token, next);
//       safe_printf(
//           piece);  // same as printf("%s", piece), but skips "unsafe" bytes
//       fflush(stdout);
//     }
//     if (user_idx >= num_prompt_tokens && next == 128009 || next == 128001) {
//       printf("\n");
//     }
//   }
//   printf("\n");
//   free(prompt_tokens);
//   free(system_prompt_tokens);
//   free(user_prompt_tokens);
//   free(system_prompt);
//   free(user_prompt);
// }

// ----------------------------------------------------------------------------
// // CLI, include only if not testing
// #ifndef TESTING

// void error_usage() {
//   fprintf(stderr, "Usage:   run <checkpoint> [options]\n");
//   fprintf(stderr, "Example: run model.bin -n 4096 -i \"Once upon a
//   time\"\n"); fprintf(stderr, "Options:\n"); fprintf(stderr, "  -t <float>
//   temperature in [0,inf], default 1.0\n"); fprintf(stderr,
//           "  -p <float>  p value in top-p (nucleus) sampling in [0,1] default
//           " "0.9\n");
//   fprintf(stderr, "  -s <int>    random seed, default time(NULL)\n");
//   fprintf(stderr,
//           "  -n <int>    number of steps to run for, default 4096. 0 = "
//           "max_seq_len\n");
//   fprintf(stderr, "  -i <string> input prompt\n");
//   fprintf(stderr, "  -z <string> optional path to custom tokenizer\n");
//   fprintf(stderr, "  -m <string> mode: generate|chat, default: generate\n");
//   fprintf(stderr, "  -y <string> (optional) system prompt in chat mode\n");
//   exit(EXIT_FAILURE);
// }

// int main(int argc, char *argv[]) {
//   // default parameters
//   char *checkpoint_path = NULL;  // e.g. out/model.bin
//   char *tokenizer_path = "tokenizer.bin";
//   float temperature =
//       1.0f;  // 0.0 = greedy deterministic. 1.0 = original. don't set higher
//   float topp =
//       0.9f;  // top-p in nucleus sampling. 1.0 = off. 0.9 works well, but
//       slower
//   int steps = 4096;                 // number of steps to run for
//   char *prompt = NULL;              // prompt string
//   unsigned long long rng_seed = 0;  // seed rng with time by default
//   char *mode = "generate";          // generate|chat
//   char *system_prompt =
//       NULL;  // the (optional) system prompt to use in chat mode

//   // poor man's C argparse so we can override the defaults above from the
//   // command line
//   if (argc >= 2) {
//     checkpoint_path = argv[1];
//   } else {
//     error_usage();
//   }
//   for (int i = 2; i < argc; i += 2) {
//     // do some basic validation
//     if (i + 1 >= argc) {
//       error_usage();
//     }  // must have arg after flag
//     if (argv[i][0] != '-') {
//       error_usage();
//     }  // must start with dash
//     if (strlen(argv[i]) != 2) {
//       error_usage();
//     }  // must be -x (one dash, one letter)
//     // read in the args
//     if (argv[i][1] == 't') {
//       temperature = atof(argv[i + 1]);
//     } else if (argv[i][1] == 'p') {
//       topp = atof(argv[i + 1]);
//     } else if (argv[i][1] == 's') {
//       rng_seed = atoi(argv[i + 1]);
//     } else if (argv[i][1] == 'n') {
//       steps = atoi(argv[i + 1]);
//     } else if (argv[i][1] == 'i') {
//       prompt = argv[i + 1];
//     } else if (argv[i][1] == 'z') {
//       tokenizer_path = argv[i + 1];
//     } else if (argv[i][1] == 'm') {
//       mode = argv[i + 1];
//     } else if (argv[i][1] == 'y') {
//       system_prompt = argv[i + 1];
//     } else {
//       error_usage();
//     }
//   }

//   // parameter validation/overrides
//   if (rng_seed <= 0) rng_seed = (unsigned int)time(NULL);
//   if (temperature < 0.0) temperature = 0.0;
//   if (topp < 0.0 || 1.0 < topp) topp = 0.9;
//   if (steps < 0) steps = 0;

//   // build the Transformer via the model .bin file
//   Transformer transformer;
//   build_transformer(&transformer, checkpoint_path);
//   if (steps == 0 || steps > transformer.config.seq_len)
//     steps = transformer.config.seq_len;  // override to ~max length

//   // build the Tokenizer via the tokenizer .bin file
//   Tokenizer tokenizer;
//   build_tokenizer(&tokenizer, tokenizer_path, transformer.config.vocab_size);

//   // build the Sampler
//   Sampler sampler;
//   build_sampler(&sampler, transformer.config.vocab_size, temperature, topp,
//                 rng_seed);
//   float *prefill_throughput;
//   float *decode_throughput;
//   // run!
//   if (strcmp(mode, "generate") == 0) {
//     generate(&transformer, &tokenizer, &sampler, prompt, steps);
//   } else if (strcmp(mode, "chat") == 0) {
//     // chat(&transformer, &tokenizer, &sampler, prompt, system_prompt,
//     steps); chat(&transformer, &tokenizer, &sampler, prompt, system_prompt,
//          prefill_throughput, decode_throughput, steps);
//   } else {
//     fprintf(stderr, "unknown mode: %s\n", mode);
//     error_usage();
//   }

//   // memory and file handles cleanup
//   free_sampler(&sampler);
//   free_tokenizer(&tokenizer);
//   free_transformer(&transformer);
//   return 0;
// }
// #endif

// #ifdef NORMAL

// int main(int argc, char *argv[]) {
//   // default parameters
//   char *checkpoint_path = QWEN_BIN_MODEL_PATH;  // e.g. out/model.bin
//   char *tokenizer_path = QWEN_BIN_TOKEN_PATH;
//   // float temperature = 1.0f;        // 0.0 = greedy deterministic. 1.0 =
//   // original. don't set higher
//   float temperature =
//       0.0f;  // 0.0 = greedy deterministic. 1.0 = original. don't set higher
//   float topp =
//       0.9f;  // top-p in nucleus sampling. 1.0 = off. 0.9 works well, but
//       slower
//   int steps = 600;  // number of steps to run for
//   char *prompt =
//       (argc > 1) ? argv[1] : "Introduce the car including its history.";
//   unsigned long long rng_seed = 0;  // seed rng with time by default
//   char *system_prompt =
//       "You are Qwen, created by Alibaba Cloud. You are a helpful "
//       "assistant.";  // the (optional) system prompt to use in chat mode

//   // parameter validation/overrides
//   if (rng_seed <= 0) rng_seed = (unsigned int)time(NULL);
//   if (temperature < 0.0) temperature = 0.0;
//   if (topp < 0.0 || 1.0 < topp) topp = 0.9;
//   if (steps < 0) steps = 0;

//   // build the Transformer via the model .bin file
//   Transformer transformer;
//   build_transformer(&transformer, checkpoint_path);
//   if (steps == 0 || steps > transformer.config.seq_len)
//     steps = transformer.config.seq_len;  // override to ~max length

//   // build the Tokenizer via the tokenizer .bin file
//   Tokenizer tokenizer;
//   build_tokenizer(&tokenizer, tokenizer_path, transformer.config.vocab_size);

//   // build the Sampler
//   Sampler sampler;
//   build_sampler(&sampler, transformer.config.vocab_size, temperature, topp,
//                 rng_seed);

//   float *prefill_throughput;
//   float *decode_throughput;
//   chat(&transformer, &tokenizer, &sampler, prompt, system_prompt,
//        prefill_throughput, decode_throughput, steps);

//   // memory and file handles cleanup
//   free_sampler(&sampler);
//   free_tokenizer(&tokenizer);
//   free_transformer(&transformer);
//   return 0;
// }

// #elif WITHOUT_C_EN_DECODE

// void chat_without_encode_decode(Transformer *transformer, Sampler *sampler,
//                                 int *prompt_tokens, int prompt_token_num,
//                                 int *gen, int *gen_token_num, bool
//                                 show_print, int steps) {
//   // Inference loop
//   int next;                      // will store the next token in the sequence
//   int token = prompt_tokens[0];  // stores the current token to feed into the
//                                  // transformer

//   int gen_ptr = 0;
//   // gen[gen_ptr++]=prompt_tokens[0];

//   long start = 0;
//   long prefill = 0;

//   int pos = 0;  // position in the sequence
//   int promot_idx = 0;
//   while (pos < steps) {
//     if (start == 0) {
//       start = time_in_ms();
//     }

//     float *logits = forward(transformer, token, pos, true);

//     if (pos < prompt_token_num - 1) {
//       next = prompt_tokens[pos + 1];
//     } else {
//       next = sample(sampler, logits);
//     }

//     pos++;

//     // End
//     if (pos >= steps) break;

//     // Show decoded string
//     if (pos >= prompt_token_num) {
//       gen[gen_ptr++] = next;

//       // End  <|endoftext|>
//       if (next == 151645) {
//         // printf("\n");
//         break;
//       }
//     }

//     if (pos == prompt_token_num) {
//       // prefill end
//       prefill = time_in_ms() - start;
//       start = 0;
//     }

//     token = next;
//   }

//   if (pos > 1) {
//     long end = time_in_ms();
//     if (show_print) {
//       fprintf(stderr, "achieved prefill tok/s: %f\n",
//               prompt_token_num / (double)(prefill) * 1000);
//       fprintf(stderr, "achieved decode tok/s: %f\n",
//               (pos - prompt_token_num) / (double)(end - start) * 1000);
//     }
//   }

//   *gen_token_num = gen_ptr;
// }
// // first python run 0107
// void run_without_encode_decode(int *prompt_tokens, int prompt_token_num,
//                                int *gen, int *gen_token_num, bool show_print,
//                                int max_steps) {
//   // printf("prompt_token_num=%d\n",prompt_token_num);
//   char *checkpoint_path = QWEN_BIN_MODEL_PATH;

//   float temperature =
//       0.0f;  // 0.0 = greedy deterministic. 1.0 = original. don't set higher
//   float topp =
//       0.9f;  // top-p in nucleus sampling. 1.0 = off. 0.9 works well, but
//       slower
//   int steps = max_steps;            // number of steps to run for
//   unsigned long long rng_seed = 0;  // seed rng with time by default

//   // parameter validation/overrides
//   if (rng_seed <= 0) rng_seed = (unsigned int)time(NULL);
//   if (temperature < 0.0) temperature = 0.0;
//   if (topp < 0.0 || 1.0 < topp) topp = 0.9;
//   if (steps < 0) steps = 0;

//   // build the Transformer via the model .bin file
//   Transformer transformer;
//   build_transformer(&transformer, checkpoint_path);
//   if (steps == 0 || steps > transformer.config.seq_len)
//     steps = transformer.config.seq_len;  // override to ~max length

//   // build the Sampler
//   Sampler sampler;
//   build_sampler(&sampler, transformer.config.vocab_size, temperature, topp,
//                 rng_seed);
//   chat_without_encode_decode(&transformer, &sampler, prompt_tokens,
//                              prompt_token_num, gen, gen_token_num,
//                              show_print, steps);

//   // memory and file handles cleanup
//   free_sampler(&sampler);
//   free_transformer(&transformer);
// }

// #elif WITH_C_EN_DECODE

// void run_with_encode_decode(char *prompt, float *prefill_throughput,
//                             float *decode_throughput, int max_steps) {
//   // default parameters
//   char *checkpoint_path = QWEN_BIN_MODEL_PATH;  // e.g. out/model.bin
//   char *tokenizer_path = QWEN_BIN_TOKEN_PATH;
//   // float temperature = 1.0f;        // 0.0 = greedy deterministic. 1.0 =
//   // original. don't set higher
//   float temperature =
//       0.0f;  // 0.0 = greedy deterministic. 1.0 = original. don't set higher
//   float topp =
//       0.9f;  // top-p in nucleus sampling. 1.0 = off. 0.9 works well, but
//       slower
//   unsigned long long rng_seed = 0;  // seed rng with time by default
//   int steps = max_steps;
//   char *system_prompt =
//       "You are Qwen, created by Alibaba Cloud. You are a helpful "
//       "assistant.";  // the (optional) system prompt to use in chat mode

//   // parameter validation/overrides
//   if (rng_seed <= 0) rng_seed = (unsigned int)time(NULL);
//   if (temperature < 0.0) temperature = 0.0;
//   if (topp < 0.0 || 1.0 < topp) topp = 0.9;
//   if (steps < 0) steps = 0;

//   // build the Transformer via the model .bin file
//   Transformer transformer;
//   build_transformer(&transformer, checkpoint_path);
//   if (steps == 0 || steps > transformer.config.seq_len)
//     steps = transformer.config.seq_len;  // override to ~max length

//   // build the Tokenizer via the tokenizer .bin file
//   Tokenizer tokenizer;
//   build_tokenizer(&tokenizer, tokenizer_path, transformer.config.vocab_size);

//   // build the Sampler
//   Sampler sampler;
//   build_sampler(&sampler, transformer.config.vocab_size, temperature, topp,
//                 rng_seed);

//   chat(&transformer, &tokenizer, &sampler, prompt, system_prompt,
//        prefill_throughput, decode_throughput, max_steps);

//   // memory and file handles cleanup
//   free_sampler(&sampler);
//   free_tokenizer(&tokenizer);
//   free_transformer(&transformer);
// }

// #endif
#ifdef NORMAL

int main(int argc, char *argv[]) {
  // default parameters
  char *checkpoint_path = QWEN_BIN_MODEL_PATH;  // e.g. out/model.bin
  char *tokenizer_path = QWEN_BIN_TOKEN_PATH;
  // float temperature = 1.0f;        // 0.0 = greedy deterministic. 1.0 =
  // original. don't set higher
  float temperature =
      0.0f;  // 0.0 = greedy deterministic. 1.0 = original. don't set higher
  float topp =
      0.9f;  // top-p in nucleus sampling. 1.0 = off. 0.9 works well, but slower
  int steps = 600;  // number of steps to run for
  char *prompt =
      (argc > 1) ? argv[1] : "Introduce the car including its history.";
  unsigned long long rng_seed = 0;  // seed rng with time by default
  char *system_prompt =
      "You are Qwen, created by Alibaba Cloud. You are a helpful "
      "assistant.";  // the (optional) system prompt to use in chat mode

  // parameter validation/overrides
  if (rng_seed <= 0) rng_seed = (unsigned int)time(NULL);
  if (temperature < 0.0) temperature = 0.0;
  if (topp < 0.0 || 1.0 < topp) topp = 0.9;
  if (steps < 0) steps = 0;

  // build the Transformer via the model .bin file
  Transformer transformer;
  build_transformer(&transformer, checkpoint_path);
  if (steps == 0 || steps > transformer.config.seq_len)
    steps = transformer.config.seq_len;  // override to ~max length

  // build the Tokenizer via the tokenizer .bin file
  Tokenizer tokenizer;
  build_tokenizer(&tokenizer, tokenizer_path, transformer.config.vocab_size);

  // build the Sampler
  Sampler sampler;
  build_sampler(&sampler, transformer.config.vocab_size, temperature, topp,
                rng_seed);

  float *prefill_throughput;
  float *decode_throughput;
  chat(&transformer, &tokenizer, &sampler, prompt, system_prompt,
       prefill_throughput, decode_throughput, steps);

  // memory and file handles cleanup
  free_sampler(&sampler);
  free_tokenizer(&tokenizer);
  free_transformer(&transformer);
  return 0;
}

#elif WITHOUT_C_EN_DECODE

void chat_without_encode_decode(Transformer *transformer, Sampler *sampler,
                                int *prompt_tokens, int prompt_token_num,
                                int *gen, int *gen_token_num, bool show_print,
                                int steps) {
  // PYNQ_loadBitstream("/root/jupyter_notebooks/AICAS/PYNQ/aicas02163.bit");

  // PYNQ_MMIO_WINDOW my_window_act;
  // PYNQ_MMIO_WINDOW my_window_wgt;
  // PYNQ_MMIO_WINDOW my_window_result;
  // PYNQ_MMIO_WINDOW my_window_reg;

  // PYNQ_createMMIOWindow(&my_window_act, A0020000, 128 * sizeof(int8_t));
  // PYNQ_createMMIOWindow(&my_window_wgt, A0040000, 16384 * sizeof(int8_t));
  // PYNQ_createMMIOWindow(&my_window_result, A0030000, 128 * sizeof(int32_t));
  // PYNQ_createMMIOWindow(&my_window_reg, B0000000, 64 * sizeof(int32_t));

  PYNQ_loadBitstream("/home/ubuntu/AICAS/AICAS/PYNQ/hardware/pre03261.bit");

  PYNQ_MMIO_WINDOW my_window_act;
  PYNQ_MMIO_WINDOW my_window_wgt;
  PYNQ_MMIO_WINDOW my_window_result;
  PYNQ_MMIO_WINDOW my_window_reg;
  PYNQ_MMIO_WINDOW my_window_scale;

  PYNQ_createMMIOWindow(&my_window_act, A0020000, 128 * 10 * sizeof(int8_t));
  PYNQ_createMMIOWindow(&my_window_wgt, A0040000, 128 * 896 * sizeof(int8_t));
  PYNQ_createMMIOWindow(&my_window_scale, A0060000, 912 * sizeof(float));
  PYNQ_createMMIOWindow(&my_window_result, A0030000, 896 * 10 * sizeof(float));
  PYNQ_createMMIOWindow(&my_window_reg, B0000000, 64 * sizeof(int));

  // Inference loop
  int next;                      // will store the next token in the sequence
  int token = prompt_tokens[0];  // stores the current token to feed into the
                                 // transformer

  int gen_ptr = 0;
  // gen[gen_ptr++]=prompt_tokens[0];

  long start = 0;
  long prefill = 0;

  int pos = 0;  // position in the sequence
  int promot_idx = 0;
  while (pos < steps) {
    if (start == 0) {
      start = time_in_ms();
    }

    if (pos == 0) {
      // printf("pos==0 is begin.\n");
      //  float *logits = forward_prefill(transformer, prompt_tokens,
      //                                  prompt_token_num - 1, true);
      float *logits =
          forward_prefill(transformer, prompt_tokens, prompt_token_num - 1,
                          true, &my_window_act, &my_window_wgt,
                          &my_window_result, &my_window_reg, &my_window_scale);

      // printf("pos==0 is done.\n");
      pos = prompt_token_num - 2;
      next = prompt_tokens[pos + 1];
    } else if (pos >= prompt_token_num - 1) {
      // printf("pos in == %d is begin.\n", pos);
      // float *logits = forward(transformer, token, pos, true);
      float *logits =
          forward(transformer, token, pos, true, &my_window_act, &my_window_wgt,
                  &my_window_result, &my_window_reg, &my_window_scale);

      next = sample(sampler, logits);
    }

    // float *logits = forward(transformer, token, pos, true);

    // if (pos < prompt_token_num - 1) {
    //   next = prompt_tokens[pos + 1];
    // } else {
    //   next = sample(sampler, logits);
    // }

    pos++;

    // End
    if (pos >= steps) break;

    // Show decoded string
    if (pos >= prompt_token_num) {
      gen[gen_ptr++] = next;

      // End  <|endoftext|>
      if (next == 151645) {
        // printf("\n");
        break;
      }
    }

    if (pos == prompt_token_num) {
      // prefill end
      prefill = time_in_ms() - start;
      start = 0;
    }

    token = next;
  }

  if (pos > 1) {
    long end = time_in_ms();
    if (show_print) {
      fprintf(stderr, "achieved prefill tok/s: %f\n",
              prompt_token_num / (double)(prefill) * 1000);
      fprintf(stderr, "achieved decode tok/s: %f\n",
              (pos - prompt_token_num) / (double)(end - start) * 1000);
    }
  }

  *gen_token_num = gen_ptr;
  // // Close MMIO window
  // printf("closewindow");
  // PYNQ_closeMMIOWindow(&my_window_act);
  // PYNQ_closeMMIOWindow(&my_window_wgt);
  // PYNQ_closeMMIOWindow(&my_window_result);
  // PYNQ_closeMMIOWindow(&my_window_reg);
}
// first python run 0107
void run_without_encode_decode(int *prompt_tokens, int prompt_token_num,
                               int *gen, int *gen_token_num, bool show_print,
                               int max_steps) {
  // printf("prompt_token_num=%d\n",prompt_token_num);
  char *checkpoint_path = QWEN_BIN_MODEL_PATH;

  float temperature =
      0.0f;  // 0.0 = greedy deterministic. 1.0 = original. don't set higher
  float topp =
      0.9f;  // top-p in nucleus sampling. 1.0 = off. 0.9 works well, but slower
  int steps = max_steps;            // number of steps to run for
  unsigned long long rng_seed = 0;  // seed rng with time by default

  // parameter validation/overrides
  if (rng_seed <= 0) rng_seed = (unsigned int)time(NULL);
  if (temperature < 0.0) temperature = 0.0;
  if (topp < 0.0 || 1.0 < topp) topp = 0.9;
  if (steps < 0) steps = 0;

  // build the Transformer via the model .bin file
  Transformer transformer;
  build_transformer(&transformer, checkpoint_path);
  if (steps == 0 || steps > transformer.config.seq_len)
    steps = transformer.config.seq_len;  // override to ~max length

  // build the Sampler
  Sampler sampler;
  build_sampler(&sampler, transformer.config.vocab_size, temperature, topp,
                rng_seed);
  chat_without_encode_decode(&transformer, &sampler, prompt_tokens,
                             prompt_token_num, gen, gen_token_num, show_print,
                             steps);

  // memory and file handles cleanup
  free_sampler(&sampler);
  free_transformer(&transformer);
}

#elif WITH_C_EN_DECODE

void run_with_encode_decode(char *prompt, float *prefill_throughput,
                            float *decode_throughput, int max_steps) {
  // default parameters
  char *checkpoint_path = QWEN_BIN_MODEL_PATH;  // e.g. out/model.bin
  char *tokenizer_path = QWEN_BIN_TOKEN_PATH;
  // float temperature = 1.0f;        // 0.0 = greedy deterministic. 1.0 =
  // original. don't set higher
  float temperature =
      0.0f;  // 0.0 = greedy deterministic. 1.0 = original. don't set higher
  float topp =
      0.9f;  // top-p in nucleus sampling. 1.0 = off. 0.9 works well, but slower
  unsigned long long rng_seed = 0;  // seed rng with time by default
  int steps = max_steps;
  char *system_prompt =
      "You are Qwen, created by Alibaba Cloud. You are a helpful "
      "assistant.";  // the (optional) system prompt to use in chat mode

  // parameter validation/overrides
  if (rng_seed <= 0) rng_seed = (unsigned int)time(NULL);
  if (temperature < 0.0) temperature = 0.0;
  if (topp < 0.0 || 1.0 < topp) topp = 0.9;
  if (steps < 0) steps = 0;

  // build the Transformer via the model .bin file
  Transformer transformer;
  build_transformer(&transformer, checkpoint_path);
  if (steps == 0 || steps > transformer.config.seq_len)
    steps = transformer.config.seq_len;  // override to ~max length

  // build the Tokenizer via the tokenizer .bin file
  Tokenizer tokenizer;
  build_tokenizer(&tokenizer, tokenizer_path, transformer.config.vocab_size);

  // build the Sampler
  Sampler sampler;
  build_sampler(&sampler, transformer.config.vocab_size, temperature, topp,
                rng_seed);

  chat(&transformer, &tokenizer, &sampler, prompt, system_prompt,
       prefill_throughput, decode_throughput, max_steps);

  // memory and file handles cleanup
  free_sampler(&sampler);
  free_tokenizer(&tokenizer);
  free_transformer(&transformer);
}

#endif
