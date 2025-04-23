/* Inference for Llama-3 Transformer model in pure C */

#include <ctype.h>
#include <fcntl.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdbool.h>

// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Transformer model

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
  float *token_embedding_table; // (vocab_size, dim)
  // weights for rmsnorms
  float *rms_att_weight; // (layer, dim) rmsnorm weights
  float *rms_ffn_weight; // (layer, dim)
  // weights for matmuls. note dim == n_heads * head_size
  float *wq; // (layer, dim, n_heads * head_size)
  float *wk; // (layer, dim, n_kv_heads * head_size)
  float *wv; // (layer, dim, n_kv_heads * head_size)
  float *wo; // (layer, n_heads * head_size, dim)
  // bias
  float *bq;  // p->n_heads * head_size
  float *bk;  // p->n_kv_heads * head_size
  float *bv;  // p->n_kv_heads * head_size
  // weights for ffn
  float *w1; // (layer, hidden_dim, dim)
  float *w2; // (layer, dim, hidden_dim)
  float *w3; // (layer, hidden_dim, dim)
  // final rmsnorm
  float *rms_final_weight; // (dim,)
  // (optional) classifier weights for the logits, on the last layer
  float *wcls;
} TransformerWeights;

typedef struct {
  // current wave of activations
  float *x;      // activation at current time stamp (dim,)
  float *xb;     // same, but inside a residual branch (dim,)
  float *xb2;    // an additional buffer just for convenience (dim,)
  float *hb;     // buffer for hidden dimension in the ffn (hidden_dim,)
  float *hb2;    // buffer for hidden dimension in the ffn (hidden_dim,)
  float *q;      // query (dim,)
  float *k;      // key (dim,)
  float *v;      // value (dim,)
  float *att;    // buffer for scores/attention values (n_heads, seq_len)
  float *logits; // output logits
  // kv cache
  float *key_cache;   // (layer, seq_len, dim)
  float *value_cache; // (layer, seq_len, dim)
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

void malloc_run_state(RunState *s, Config *p) {
  // we calloc instead of malloc to keep valgrind happy
  int kv_dim = (p->dim * p->n_kv_heads) / p->n_heads;
  s->x = calloc(p->dim, sizeof(float));
  s->xb = calloc(p->dim, sizeof(float));
  s->xb2 = calloc(p->dim, sizeof(float));
  s->hb = calloc(p->hidden_dim, sizeof(float));
  s->hb2 = calloc(p->hidden_dim, sizeof(float));
  s->q = calloc(p->dim, sizeof(float));
  s->key_cache = calloc(p->n_layers * p->seq_len * kv_dim, sizeof(float));
  s->value_cache = calloc(p->n_layers * p->seq_len * kv_dim, sizeof(float));
  s->att = calloc(p->n_heads * p->seq_len, sizeof(float));
  s->logits = calloc(p->vocab_size, sizeof(float));
  // ensure all mallocs went fine
  if (!s->x || !s->xb || !s->xb2 || !s->hb || !s->hb2 || !s->q || !s->key_cache || !s->value_cache || !s->att || !s->logits) {
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
  free(s->q);
  free(s->att);
  free(s->logits);
  free(s->key_cache);
  free(s->value_cache);
}

void memory_map_weights(TransformerWeights *w, Config *p, float *ptr, int shared_weights, bool bias) {
  int head_size = p->dim / p->n_heads;
  // make sure the multiplications below are done in 64bit to fit the parameter counts of 13B+ models
  unsigned long long n_layers = p->n_layers;

  // embed_tokens
  w->token_embedding_table = ptr;
  ptr += p->vocab_size * p->dim;

  // input_layer_norm_weight
  w->rms_att_weight = ptr;
  ptr += n_layers * p->dim;

  // Q weight
  w->wq = ptr;
  ptr += n_layers * p->dim * (p->n_heads * head_size);

  // Q bias
  if(bias){
    w->bq = ptr;
    ptr += n_layers * (p->n_heads * head_size);
  }

  // K weight
  w->wk = ptr;
  ptr += n_layers * p->dim * (p->n_kv_heads * head_size);

  // K bias
  if(bias){
    w ->bk = ptr;
    ptr += n_layers * (p->n_kv_heads * head_size);
  }
  
  // V weight
  w->wv = ptr;
  ptr += n_layers * p->dim * (p->n_kv_heads * head_size);

  // V bias
  if(bias){
    w->bv = ptr;
    ptr += n_layers * (p->n_kv_heads * head_size);
  }

  // O weight
  w->wo = ptr;
  ptr += n_layers * (p->n_heads * head_size) * p->dim;

  // post_attention_layernorm
  w->rms_ffn_weight = ptr;
  ptr += n_layers * p->dim;

  // mlp.gate_proj
  w->w1 = ptr;
  ptr += n_layers * p->dim * p->hidden_dim;

  // mlp.down_proj
  w->w2 = ptr;
  ptr += n_layers * p->hidden_dim * p->dim;

  // mlp.up_proj
  w->w3 = ptr;
  ptr += n_layers * p->dim * p->hidden_dim;

  // model.norm.weight
  w->rms_final_weight = ptr;
  ptr += p->dim;

  ptr += p->seq_len * head_size / 2; // skip what used to be freq_cis_real (for RoPE)
  ptr += p->seq_len * head_size / 2; // skip what used to be freq_cis_imag (for RoPE)
  w->wcls = shared_weights ? w->token_embedding_table : ptr;
}

void read_checkpoint(char *checkpoint, Config *config, TransformerWeights *weights, int *fd, float **data, ssize_t *file_size) {
  FILE *file = fopen(checkpoint, "rb");
  if (!file) {
    fprintf(stderr, "Couldn't open file %s, it may not exist.\n", checkpoint);
    exit(EXIT_FAILURE);
  }
  // read in the config header
  if (fread(config, sizeof(Config), 1, file) != 1) {
    exit(EXIT_FAILURE);
  }
  // negative vocab size is hacky way of signaling unshared weights. bit yikes.
  int shared_weights = config->vocab_size > 0 ? 1 : 0;
  config->vocab_size = abs(config->vocab_size);
  // figure out the file size
#if defined _WIN32
  _fseeki64(file, 0, SEEK_END); // move file pointer to end of file
  *file_size = _ftelli64(file); // get the file size, in bytes
#else
  fseek(file, 0, SEEK_END); // move file pointer to end of file
  *file_size = ftell(file); // get the file size, in bytes
#endif
  fclose(file);
  // memory map the Transformer weights into the data pointer
  *fd = open(checkpoint, O_RDONLY); // open in read only mode
  if (*fd == -1) {
    fprintf(stderr, "open failed!\n");
    exit(EXIT_FAILURE);
  }
  *data = mmap(NULL, *file_size, PROT_READ, MAP_PRIVATE, *fd, 0);
  if (*data == MAP_FAILED) {
    fprintf(stderr, "mmap failed!\n");
    exit(EXIT_FAILURE);
  }
  float *weights_ptr = *data + sizeof(Config) / sizeof(float);
  memory_map_weights(weights, config, weights_ptr, shared_weights,true);
}

void build_transformer(Transformer *t, char *checkpoint_path){
  // read in the Config and the Weights from the checkpoint
  read_checkpoint(checkpoint_path, &t->config, &t->weights, &t->fd, &t->data, &t->file_size);
  // allocate the RunState buffers
  malloc_run_state(&t->state, &t->config);
}

void free_transformer(Transformer *t) {
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
  ss += 1e-6f;
  ss = 1.0f / sqrtf(ss);
  // normalize and scale
  for (int j = 0; j < size; j++) {
    o[j] = weight[j] * (ss * x[j]);
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
//matmul(s->logits, x, w->wcls, p->dim, p->vocab_size);
void matmul(float *xout, float *x, float *w, int n, int d) {
  // W (d,n) @ x (n,) -> xout (d,)
  // by far the most amount of time is spent inside this little function
  int i;
#pragma omp parallel for private(i)
  for (i = 0; i < d; i++) {
    float val = 0.0f;
    for (int j = 0; j < n; j++) {
      val += w[i * n + j] * x[j];
    }
    xout[i] = val;
  }
}

float *forward(Transformer *transformer, int token, int pos,bool need_bias) {

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

  // copy the token embedding into x
  float *content_row = w->token_embedding_table + token * dim;
  memcpy(x, content_row, dim * sizeof(*x));

  // forward all the layers
  for (unsigned long long l = 0; l < p->n_layers; l++) {

    // attention rmsnorm
    rmsnorm(s->xb, x, w->rms_att_weight + l * dim, dim);

    // key and value point to the kv cache
    int loff = l * p->seq_len * kv_dim; // kv cache layer offset for convenience
    s->k = s->key_cache + loff + pos * kv_dim;
    s->v = s->value_cache + loff + pos * kv_dim;

    // qkv matmuls for this position
    matmul(s->q, s->xb, w->wq + l * dim * dim, dim, dim);
    matmul(s->k, s->xb, w->wk + l * dim * kv_dim, dim, kv_dim);
    matmul(s->v, s->xb, w->wv + l * dim * kv_dim, dim, kv_dim);

    // bias
    if(need_bias)
    {
      for(int ptr=0;ptr<dim;ptr++)
      {
        s->q[ptr] += *(w->bq+l*dim+ptr);
      }

      for(int ptr=0;ptr<kv_dim;ptr++)
      {
        s->k[ptr] += *(w->bk+l*kv_dim+ptr);
        s->v[ptr] += *(w->bv+l*kv_dim+ptr);
      }
    }


    for(int i = 0; i < p->dim; i+=head_size)
    {
      for(int head_dim = i%head_size; head_dim  <  head_size / 2; head_dim ++)
      {
          float freq =
            1.0f / powf(1000000.0f, (float)(head_dim*2) / (float)head_size);
          float val = pos * freq;
          float fci= sinf(val);
          float fcr= cosf(val);

          float q0 = s->q[i + head_dim];
          float q1 = s->q[i + head_dim + head_size / 2];
          s->q[i + head_dim] = q0 * fcr - q1 * fci;
          s->q[i + head_dim + head_size / 2] = q0 * fci + q1 * fcr;
          if (i < p->n_kv_heads*head_size) {
            float k0 = s->k[i + head_dim];
            float k1 = s->k[i + head_dim + head_size / 2];
            s->k[i + head_dim] = k0 * fcr - k1 * fci;
            s->k[i + head_dim + head_size / 2] = k0 * fci + k1 * fcr;
          }
      }
    }

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
        float *v = s->value_cache + loff + t * kv_dim + (h / kv_mul) * head_size;
        // get the attention weight for this timestep
        float a = att[t];
        // accumulate the weighted value into xb
        for (int i = 0; i < head_size; i++) {
          xb[i] += a * v[i];
        }
      }
    }

    // final matmul to get the output of the attention
    matmul(s->xb2, s->xb, w->wo + l * dim * dim, dim, dim);

    // residual connection back into x
    for (int i = 0; i < dim; i++) {
      x[i] += s->xb2[i];
    }

    // ffn rmsnorm
    rmsnorm(s->xb, x, w->rms_ffn_weight + l * dim, dim);

    // Now for FFN in PyTorch we have: self.w2(F.silu(self.w1(x)) * self.w3(x))
    // first calculate self.w1(x) and self.w3(x)
    matmul(s->hb, s->xb, w->w1 + l * dim * hidden_dim, dim, hidden_dim);
    matmul(s->hb2, s->xb, w->w3 + l * dim * hidden_dim, dim, hidden_dim);

    // SwiGLU non-linearity
    for (int i = 0; i < hidden_dim; i++) {
      float val = s->hb[i];
      // silu(x)=x*σ(x), where σ(x) is the logistic sigmoid
      val *= (1.0f / (1.0f + expf(-val)));
      // elementwise multiply with w3(x)
      val *= s->hb2[i];
      s->hb[i] = val;
    }

    // final matmul to get the output of the ffn
    matmul(s->xb, s->hb, w->w2 + l * dim * hidden_dim, hidden_dim, dim);

    // residual connection
    for (int i = 0; i < dim; i++) {
      x[i] += s->xb[i];
    }
  }

  // final rmsnorm
  rmsnorm(x, x, w->rms_final_weight, dim);

  // classifier into logits
  matmul(s->logits, x, w->wcls, p->dim, p->vocab_size);
  return s->logits;
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
  unsigned char byte_pieces[512]; // stores all single-byte strings
} Tokenizer;

int compare_tokens(const void *a, const void *b) { return strcmp(((TokenIndex *)a)->str, ((TokenIndex *)b)->str); }

void build_tokenizer(Tokenizer *t, char *tokenizer_path, int vocab_size) {
  // i should have written the vocab_size into the tokenizer file... sigh
  t->vocab_size = vocab_size;
  // malloc space to hold the scores and the strings
  t->vocab = (char **)malloc(vocab_size * sizeof(char *));
  t->vocab_scores = (float *)malloc(vocab_size * sizeof(float));
  t->sorted_vocab = NULL; // initialized lazily
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
  clock_t start_time = clock();
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
    t->vocab[i][len] = '\0'; // add the string terminating token
  }
  fclose(file);
  clock_t end_time = clock();
  double time_taken = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;
  printf("Load voacb time taken: %.6f seconds\n", time_taken);
}

void free_tokenizer(Tokenizer *t) {
  for (int i = 0; i < t->vocab_size; i++) {
    free(t->vocab[i]);
  }
  free(t->vocab);
  free(t->vocab_scores);
  free(t->sorted_vocab);
}

void decode(Tokenizer *t, int token, char* string) {
  char *piece = t->vocab[token];
  int piece_ori_len=0;
  int string_len=0;

  // blank and new line
  char* blank_char = "Ġ"; // 2 bytes: 0xC4 0xA0 (UTF-8 representation of 'Ġ')
  char* new_line_char = "Ċ"; // 2 bytes: 0xC4 0x8A (UTF-8 representation of 'Ċ')

  while(piece[piece_ori_len]!='\0')
  {
    // blank
    if(piece[piece_ori_len]==blank_char[0])
    {
      if(piece[piece_ori_len+1]==blank_char[1])
      {string[string_len++] = ' ';}
      else
      {string[string_len++] = '\n';}
      piece_ori_len++;
    }
    else
    {string[string_len++]=piece[piece_ori_len];}
    piece_ori_len++;
  }
  string[string_len++]='\0';
}

void safe_printf(char *piece) {
  // piece might be a raw byte token, and we only want to print printable chars or whitespace
  // because some of the other bytes can be various control codes, backspace, etc.
  if (piece == NULL) {
    return;
  }
  if (piece[0] == '\0') {
    return;
  }
  if (piece[1] == '\0') {
    unsigned char byte_val = piece[0];
    if (!(isprint(byte_val) || isspace(byte_val))) {
      return; // bad byte, don't print it
    }
  }
  printf("%s", piece);
}

int str_lookup(char *str, TokenIndex *sorted_vocab, int vocab_size) {
  // efficiently find the perfect match for str in vocab, return its index or -1 if not found
  TokenIndex tok = {.str = str}; // acts as the key to search for
  TokenIndex *res = bsearch(&tok, sorted_vocab, vocab_size, sizeof(TokenIndex), compare_tokens);
  return res != NULL ? res->id : -1;
}

void encode(Tokenizer *t, char *text, int8_t bos, int8_t eos, int *tokens, int *n_tokens) {
  // encode the string text (input) into an upper-bound preallocated tokens[] array
  // bos != 0 means prepend the BOS token (=1), eos != 0 means append the EOS token (=2)
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

  // create a temporary buffer that will store merge candidates of always two consecutive tokens
  // *2 for concat, +1 for null terminator +2 for UTF8 (in case max_token_length is 1)
  char *str_buffer = malloc((t->max_token_length * 2 + 1 + 2) * sizeof(char));
  size_t str_len = 0;

  // start at 0 tokens
  *n_tokens = 0;

  // add optional BOS (=128000) token, if desired
  if (bos)
  {
    tokens[(*n_tokens)++] = 128000;
  }

  // add_dummy_prefix is true by default
  // so prepend a dummy prefix token to the input string, but only if text != ""
  // TODO: pretty sure this isn't correct in the general case but I don't have the
  // energy to read more of the sentencepiece code to figure out what it's doing

  // Okay UTF-8 time. This will get messy. Here is the reference from Wikipedia:
  // Code point ↔ UTF-8 conversion
  // First code point	Last code point	Byte 1	Byte 2	Byte 3	Byte 4
  // U+0000	U+007F	    0xxxxxxx
  // U+0080	U+07FF	    110xxxxx	10xxxxxx
  // U+0800	U+FFFF	    1110xxxx	10xxxxxx	10xxxxxx
  // U+10000	U+10FFFF    11110xxx	10xxxxxx	10xxxxxx	10xxxxxx

  // process the raw (UTF-8) byte sequence of the input string
  for (char *c = text; *c != '\0'; c++) {
    // reset buffer if the current byte is ASCII or a leading byte
    // 0xC0 is 11000000, so (*c & 0xC0) keeps the first 2 bits and zeros the rest
    // 0x80 is 10000000
    // in UTF-8, all continuation bytes start with "10" in first two bits
    // so in English this is: "if this byte is not a continuation byte"
    if ((*c & 0xC0) != 0x80) {
      // this byte must be either a leading byte (11...) or an ASCII char (0x...)
      // => reset our location, as we're starting a new UTF-8 codepoint
      str_len = 0;
    }

    // append the current byte to the buffer
    str_buffer[str_len++] = *c; // ++ is post-increment, incremented after this line
    str_buffer[str_len] = '\0';

    // while the next character is a continuation byte, continue appending
    // but if there are too many of them, just stop to avoid overruning str_buffer size.
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
    str_len = 0; // protect against a sequence of stray UTF8 continuation bytes
  }

  // merge the best consecutive pair or triple each iteration, according to the scores in vocab_scores
  while (1) {
    float best_score = -1e10;
    int best_id = -1;
    int best_idx = -1;
    int best_len = 2; // length of the best merge sequence (2 for pair, 3 for triple)

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
        // check if we can merge the triple (tokens[i], tokens[i+1], tokens[i+2])
        sprintf(str_buffer, "%s%s%s", t->vocab[tokens[i]], t->vocab[tokens[i + 1]], t->vocab[tokens[i + 2]]);
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
      break; // we couldn't find any more pairs or triples to merge, so we're done
    }

    // merge the consecutive pair or triple (best_idx, best_idx+1[, best_idx+2]) into new token best_id
    tokens[best_idx] = best_id;
    // delete token(s) at position best_idx+1 (and optionally best_idx+2), shift the entire sequence back
    for (int i = best_idx + 1; i < (*n_tokens - best_len + 1); i++) {
      tokens[i] = tokens[i + best_len - 1];
    }
    (*n_tokens) -= (best_len - 1); // token length decreased by the number of merged tokens minus one
  }

  // add optional EOS (=128001) token, if desired
  if (eos)
    tokens[(*n_tokens)++] = 128001;

  free(str_buffer);
}

// ----------------------------------------------------------------------------
// The Sampler, which takes logits and returns a sampled token
// sampling can be done in a few ways: greedy argmax, sampling, top-p sampling

typedef struct {
  float prob;
  int index;
} ProbIndex; // struct used when sorting probabilities during top-p sampling

typedef struct {
  int vocab_size;
  ProbIndex *probindex; // buffer used in top-p sampling
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
  return n - 1; // in case of rounding errors
}

int compare(const void *a, const void *b) {
  ProbIndex *a_ = (ProbIndex *)a;
  ProbIndex *b_ = (ProbIndex *)b;
  if (a_->prob > b_->prob)
    return -1;
  if (a_->prob < b_->prob)
    return 1;
  return 0;
}

int sample_topp(float *probabilities, int n, float topp, ProbIndex *probindex, float coin) {
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
  int last_idx = n0 - 1; // in case of rounding errors consider all elements
  for (int i = 0; i < n0; i++) {
    cumulative_prob += probindex[i].prob;
    if (cumulative_prob > topp) {
      last_idx = i;
      break; // we've exceeded topp by including last_idx
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
  return probindex[last_idx].index; // in case of rounding errors
}

void build_sampler(Sampler *sampler, int vocab_size, float temperature, float topp, unsigned long long rng_seed) {
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
float random_f32(unsigned long long *state) { // random float32 in [0,1)
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
      next = sample_topp(logits, sampler->vocab_size, sampler->topp, sampler->probindex, coin);
    }
  }
  return next;
}

// ----------------------------------------------------------------------------
// utilities: time

long time_in_ms() {
  // return time in milliseconds, for benchmarking the model speed
  struct timespec time;
  clock_gettime(CLOCK_REALTIME, &time);
  return time.tv_sec * 1000 + time.tv_nsec / 1000000;
}


void read_stdin(const char *guide, char *buffer, size_t bufsize) {
  // read a line from stdin, up to but not including \n
  printf("%s", guide);
  if (fgets(buffer, bufsize, stdin) != NULL) {
    size_t len = strlen(buffer);
    if (len > 0 && buffer[len - 1] == '\n') {
      buffer[len - 1] = '\0'; // strip newline
    }
  }
}

void replace_spaces_with_G(char* system_prompt_ori, char* system_prompt_dealed) {
    char* blank_char = "Ġ"; // 2 bytes: 0xC4 0xA0 (UTF-8 representation of 'Ġ')
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

// ----------------------------------------------------------------------------
// chat loop
// I manually inspected the tokens for a few chat conversations compared to
// python reference and that seemed ok, but this was not thoroughly tested and
// is not safely implemented, it's more a proof of concept atm.

int promote_to_token(Tokenizer *tokenizer, char *user_prompt, char *system_prompt,int *prompt_tokens) {

  // buffers for reading the system prompt and user prompt from stdin
  int num_prompt_tokens = 0;
  int *system_prompt_tokens = (int *)malloc(32768 * sizeof(int));
  int *user_prompt_tokens = (int *)malloc(32768 * sizeof(int));

  // ----------------- System promot ----------------------
  prompt_tokens[num_prompt_tokens++] = 151644; // "<|im_start|>"
  prompt_tokens[num_prompt_tokens++] = 8948; // "system"
  prompt_tokens[num_prompt_tokens++] = 198;   // "\n"

  char* system_prompt_dealed = (char *)malloc(32768 * sizeof(char));
  char* blank_char="Ġ";
  // replace blank to Ġ (two bytes) Ġ = 0xC4(LSB) 0xA0(HSB)
  replace_spaces_with_G(system_prompt,system_prompt_dealed);

  int num_system_prompt_tokens=0;
  encode(tokenizer, system_prompt_dealed, 0, 0, system_prompt_tokens, &num_system_prompt_tokens);

  // copy system_prompt_tokens to prompt_tokens
  for(int ptr=0;ptr<num_system_prompt_tokens;ptr++)
  {prompt_tokens[num_prompt_tokens++]=system_prompt_tokens[ptr];}

  // end
  prompt_tokens[num_prompt_tokens++]=151645; // "<|im_end|>"
  prompt_tokens[num_prompt_tokens++] = 198;   // "\n"
 
  // ----------------- User promot ----------------------
  prompt_tokens[num_prompt_tokens++] = 151644; // "<|im_start|>"
  prompt_tokens[num_prompt_tokens++] = 872; // "user"
  prompt_tokens[num_prompt_tokens++] = 198;   // "\n"

  char *user_prompt_dealed = (char *)malloc(32768 * sizeof(char));
  replace_spaces_with_G(user_prompt,user_prompt_dealed);

  int num_user_prompt_tokens = 0;
  encode(tokenizer, user_prompt_dealed, 0, 0, user_prompt_tokens, &num_user_prompt_tokens);

  // Copy to prompt_tokens
  for (int i = 0; i < num_user_prompt_tokens; i++) {
      prompt_tokens[num_prompt_tokens++] = user_prompt_tokens[i];
  }

  // user promot end
  prompt_tokens[num_prompt_tokens++]=151645; // "<|im_end|>"
  prompt_tokens[num_prompt_tokens++]=198; // "\n"

  // assistent
  prompt_tokens[num_prompt_tokens++] = 151644; // "<|im_start|>"
  prompt_tokens[num_prompt_tokens++]=77091; // "assistant"
  prompt_tokens[num_prompt_tokens++]=198; // "\n"

  // free(string_out);
  free(system_prompt_tokens);
  free(user_prompt_tokens);
  free(system_prompt_dealed);
  free(user_prompt_dealed);

  return num_prompt_tokens;
}


void chat(Transformer *transformer, Tokenizer *tokenizer, Sampler *sampler, 
          char *user_prompt, char *system_prompt, 
          float *prefill_throughput, float *decode_throughput,
          int steps)
{
  printf("\nUser prompt: \n%s\n",user_prompt);
  printf("\nAnswer: \n");
  

  // promote string -> token numbers
  int *prompt_tokens = (int *)malloc(32768 * sizeof(int));
  int prompt_token_num=0;
  prompt_token_num=promote_to_token(tokenizer,user_prompt,system_prompt,prompt_tokens);

  // Time
  long start=0;
  long end=0;
  long prefill=0;

  // Inference loop
  int next;             // will store the next token in the sequence
  int token=prompt_tokens[0];       // stores the current token to feed into the transformer
  char* decoded_string = (char *)malloc(32768 * sizeof(char));

  int pos = 0; // position in the sequence
  int promot_idx = 0;
  while (pos < steps) 
  {

    if (start == 0) {start = time_in_ms();}

    float *logits = forward(transformer, token, pos,true);

    if(pos<prompt_token_num-1)
    {
      next=prompt_tokens[pos+1];
    } 
    else
    {
      next = sample(sampler, logits);
    }

    pos++;

    if (pos>steps)
      break;


    // Show decoded string
    if(pos>=prompt_token_num)
    {
      // End  <|endoftext|> 
      if(next==151645)
      {
        printf("\n");
        break;
      }

      decode(tokenizer, next, decoded_string);
      safe_printf(decoded_string);
      fflush(stdout);
    }

    if(pos==prompt_token_num)
    {
      // prefill end
      prefill=time_in_ms()-start;
      start=0;
    }

    token = next;
  }

  if (pos > 1) {
    long end = time_in_ms();
    *prefill_throughput = prompt_token_num / (double)(prefill) * 1000;
    *decode_throughput= (pos - prompt_token_num) / (double)(end - start) * 1000;
    fprintf(stderr, "achieved prefill tok/s: %f\n", *prefill_throughput);
    fprintf(stderr, "achieved decode tok/s: %f\n", *decode_throughput);
  }

  free(prompt_tokens);
  free(decoded_string);

}

#ifdef NORMAL

int main(int argc, char *argv[]) {
  // default parameters
  char *checkpoint_path = QWEN_BIN_MODEL_PATH; // e.g. out/model.bin
  char *tokenizer_path = QWEN_BIN_TOKEN_PATH;
  // float temperature = 1.0f;        // 0.0 = greedy deterministic. 1.0 = original. don't set higher
  float temperature = 0.0f;        // 0.0 = greedy deterministic. 1.0 = original. don't set higher
  float topp = 0.9f;               // top-p in nucleus sampling. 1.0 = off. 0.9 works well, but slower
  int steps = 600;                // number of steps to run for
  char *prompt = (argc > 1) ? argv[1] : "Introduce the car including its history.";
  unsigned long long rng_seed = 0; // seed rng with time by default
  char *system_prompt = "You are Qwen, created by Alibaba Cloud. You are a helpful assistant.";      // the (optional) system prompt to use in chat mode

  // parameter validation/overrides
  if (rng_seed <= 0)
    rng_seed = (unsigned int)time(NULL);
  if (temperature < 0.0)
    temperature = 0.0;
  if (topp < 0.0 || 1.0 < topp)
    topp = 0.9;
  if (steps < 0)
    steps = 0;

  // build the Transformer via the model .bin file
  Transformer transformer;
  build_transformer(&transformer, checkpoint_path);
  if (steps == 0 || steps > transformer.config.seq_len)
    steps = transformer.config.seq_len; // override to ~max length

  // build the Tokenizer via the tokenizer .bin file
  Tokenizer tokenizer;
  build_tokenizer(&tokenizer, tokenizer_path, transformer.config.vocab_size);

  // build the Sampler
  Sampler sampler;
  build_sampler(&sampler, transformer.config.vocab_size, temperature, topp, rng_seed);

  float *prefill_throughput;
  float *decode_throughput;
  chat(&transformer,&tokenizer,&sampler, 
        prompt, system_prompt, 
        prefill_throughput,decode_throughput,
        steps);
  
  // memory and file handles cleanup
  free_sampler(&sampler);
  free_tokenizer(&tokenizer);
  free_transformer(&transformer);
  return 0;
}

#elif WITHOUT_C_EN_DECODE

void chat_without_encode_decode(Transformer *transformer, Sampler *sampler, 
                                int *prompt_tokens,int prompt_token_num,
                                int *gen ,int *gen_token_num ,
                                bool show_print,int steps)
{
  // Inference loop
  int next;             // will store the next token in the sequence
  int token=prompt_tokens[0];       // stores the current token to feed into the transformer

  int gen_ptr=0;
  // gen[gen_ptr++]=prompt_tokens[0];

  long start=0;
  long prefill=0;

  int pos = 0; // position in the sequence
  int promot_idx = 0;
  while (pos < steps) 
  {
    if (start == 0) {start = time_in_ms();}

    float *logits = forward(transformer, token, pos,true);

    if(pos<prompt_token_num-1)
    {
      next=prompt_tokens[pos+1];
    } 
    else
    {
      next = sample(sampler, logits);
    }

    pos++;

    // End
    if (pos>=steps)
      break;

    // Show decoded string
    if(pos>=prompt_token_num)
    {
      gen[gen_ptr++]=next;

      // End  <|endoftext|> 
      if(next==151645)
      {
        // printf("\n");
        break;
      }
    }

    if(pos==prompt_token_num)
    {
      // prefill end
      prefill=time_in_ms()-start;
      start=0;
    }

    token = next;
  }

  if (pos > 1) {
    long end = time_in_ms();
    if(show_print)
    {
      fprintf(stderr, "achieved prefill tok/s: %f\n", prompt_token_num / (double)(prefill) * 1000);
      fprintf(stderr, "achieved decode tok/s: %f\n", (pos - prompt_token_num) / (double)(end - start) * 1000);
    }
  }

  *gen_token_num=gen_ptr;
}

void run_without_encode_decode(int *prompt_tokens,int prompt_token_num,
                              int *gen,int *gen_token_num,
                              bool show_print,int max_steps)
{
  // printf("prompt_token_num=%d\n",prompt_token_num);
  char *checkpoint_path = QWEN_BIN_MODEL_PATH; 

  float temperature = 0.0f;        // 0.0 = greedy deterministic. 1.0 = original. don't set higher
  float topp = 0.9f;               // top-p in nucleus sampling. 1.0 = off. 0.9 works well, but slower
  int steps = max_steps;                // number of steps to run for
  unsigned long long rng_seed = 0; // seed rng with time by default

  // parameter validation/overrides
  if (rng_seed <= 0)
    rng_seed = (unsigned int)time(NULL);
  if (temperature < 0.0)
    temperature = 0.0;
  if (topp < 0.0 || 1.0 < topp)
    topp = 0.9;
  if (steps < 0)
    steps = 0;

  // build the Transformer via the model .bin file
  Transformer transformer;
  build_transformer(&transformer,checkpoint_path);
  if (steps == 0 || steps > transformer.config.seq_len)
    steps = transformer.config.seq_len; // override to ~max length

  // build the Sampler
  Sampler sampler;
  build_sampler(&sampler, transformer.config.vocab_size, temperature, topp, rng_seed);
  chat_without_encode_decode(&transformer,&sampler, 
                                      prompt_tokens,prompt_token_num,gen,gen_token_num,
                                      show_print,steps);
  
  // memory and file handles cleanup
  free_sampler(&sampler);
  free_transformer(&transformer);
}

#elif WITH_C_EN_DECODE

void run_with_encode_decode(char *prompt,
                            float *prefill_throughput, float *decode_throughput,
                            int max_steps)
{
  // default parameters
  char *checkpoint_path = QWEN_BIN_MODEL_PATH; // e.g. out/model.bin
  char *tokenizer_path = QWEN_BIN_TOKEN_PATH;
  // float temperature = 1.0f;        // 0.0 = greedy deterministic. 1.0 = original. don't set higher
  float temperature = 0.0f;        // 0.0 = greedy deterministic. 1.0 = original. don't set higher
  float topp = 0.9f;               // top-p in nucleus sampling. 1.0 = off. 0.9 works well, but slower
  unsigned long long rng_seed = 0; // seed rng with time by default
  int steps=max_steps;
  char *system_prompt = "You are Qwen, created by Alibaba Cloud. You are a helpful assistant.";      // the (optional) system prompt to use in chat mode

  // parameter validation/overrides
  if (rng_seed <= 0)
    rng_seed = (unsigned int)time(NULL);
  if (temperature < 0.0)
    temperature = 0.0;
  if (topp < 0.0 || 1.0 < topp)
    topp = 0.9;
  if (steps < 0)
    steps = 0;

  // build the Transformer via the model .bin file
  Transformer transformer;
  build_transformer(&transformer, checkpoint_path);
  if (steps == 0 || steps > transformer.config.seq_len)
    steps = transformer.config.seq_len; // override to ~max length

  // build the Tokenizer via the tokenizer .bin file
  Tokenizer tokenizer;
  build_tokenizer(&tokenizer, tokenizer_path, transformer.config.vocab_size);

  // build the Sampler
  Sampler sampler;
  build_sampler(&sampler, transformer.config.vocab_size, temperature, topp, rng_seed);


  chat(&transformer,&tokenizer,&sampler, 
        prompt, system_prompt, 
        prefill_throughput,decode_throughput,
        max_steps);

  
  // memory and file handles cleanup
  free_sampler(&sampler);
  free_tokenizer(&tokenizer);
  free_transformer(&transformer);
}

#endif