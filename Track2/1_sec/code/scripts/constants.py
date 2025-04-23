"""Calculate hyperparameters"""
IS_LONG_CONTEXT = False

# model hyperparameters
QWEN_L          = 24
G               = 8
C               = 896
CM              = 4864
FULL_VOCAB      = 151936
VOCAB           = FULL_VOCAB // 4
# design hyperparameters
DW_WQ           = 5
DW_WS           = 3
T               = 8
TP              = 1
S               = 1024 if IS_LONG_CONTEXT else 192  # context length
SP              = G
CP              = G
DW_MAXI         = 256 # main gmem axi width
DW_CACHE_PACK   = 128 # packed KV cache
BYTES_PER_X     = 32 // 8
# derived hyperparameters
TT              = T     // TP
CT              = C     // CP
VOCABT          = VOCAB // CP
# decoder weight
DECODER_NUM_WQ  = 3*C*C + C*C + 2*CM*C + C*CM
DECODER_NUM_WS  = DECODER_NUM_WQ // G
DECODER_W_BYTES = (DECODER_NUM_WQ*DW_WQ + DECODER_NUM_WS*DW_WS*2) // 8
DECODER_W_BYTES_HALF = DECODER_W_BYTES // 2
# cls weight
CLS_NUM_WQ      = VOCAB * C
CLS_NUM_WS      = CLS_NUM_WQ // G
CLS_W_BYTES     = (CLS_NUM_WQ*DW_WQ + CLS_NUM_WS*DW_WS*2) // 8
CLS_W_BYTES_HALF = CLS_W_BYTES // 2
# decoder x
DECODER_NUM_X   = T * C
DECODER_X_BITS  = DECODER_NUM_X * 32
DECODER_X_BYTES = DECODER_X_BITS // 8
# cls y
CLS_NUM_Y       = T * VOCAB
CLS_Y_BITS      = CLS_NUM_Y * 32
CLS_Y_BYTES     = CLS_Y_BITS // 8
# kv cache
K_CACHE_BYTES   = QWEN_L * (S*C) // CP * DW_CACHE_PACK // 8
V_CACHE_BYTES   = QWEN_L * (S*C) // SP * DW_CACHE_PACK // 8
KV_CACHE_BYTES  = K_CACHE_BYTES + V_CACHE_BYTES
# embedding
EMBEDDING_BYTES = VOCAB * C * 16 // 8
# total weight to load per run
TOTAL_BYTES     = DECODER_W_BYTES*QWEN_L + CLS_W_BYTES