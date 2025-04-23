import os
import pynq
from pynq import Overlay
from pynq import Clocks
import numpy as np
import json
from transformers import Qwen2Tokenizer
from rich.progress import Progress

from pack import load_packed_tensor

from constants import *
from ip import *

"""load overlay and tokenizer"""

bitfile = "design_1_pruned_long_context.bit" if IS_LONG_CONTEXT else "design_1_pruned.bit"
ol = Overlay(bitfile)
Clocks.fclk0_mhz = 400
print("Overlay loaded")

MODEL_PATH = "Qwen2.5-0.5B-Instruct"
tokenizer = Qwen2Tokenizer.from_pretrained(MODEL_PATH)

"""allocate memory"""
ddr_x          = pynq.allocate(shape=(DECODER_X_BYTES          // np.dtype(np.int32) .itemsize,), dtype=np.int32 )
ddr_y          = pynq.allocate(shape=(DECODER_X_BYTES          // np.dtype(np.int32) .itemsize,), dtype=np.int32 )
ddr_cls_y      = pynq.allocate(shape=(CLS_Y_BYTES              // np.dtype(np.int32) .itemsize,), dtype=np.int32 )
ddr_w          = pynq.allocate(shape=(DECODER_W_BYTES * QWEN_L // np.dtype(np.byte ) .itemsize,), dtype=np.byte  )
ddr_cls_w      = pynq.allocate(shape=(CLS_W_BYTES              // np.dtype(np.byte ) .itemsize,), dtype=np.byte  )
ddr_kv_cache   = pynq.allocate(shape=(KV_CACHE_BYTES           // np.dtype(np.uint64).itemsize,), dtype=np.uint64)


# clear kv cache
ddr_kv_cache[:] = 0
            

def load_weight():
    print("Loading weights...", end="")
    all_decoder_w = np.fromfile("./bin/all_decoder_w.bin", dtype=np.byte)
    assert all_decoder_w.size == DECODER_W_BYTES * QWEN_L
    ddr_w[:] = all_decoder_w
    print("done")
    
    print("Loading cls weights...", end="")
    all_cls_w = np.fromfile("./unpack/all_cls_w_tied.bin", dtype=np.byte)
    assert all_cls_w.size == CLS_W_BYTES
    ddr_cls_w[:] = all_cls_w
    print("done")


def load_embedding():
    global embedding
    print(f"EMBEDDING Read...", end="")
    embedding = np.fromfile(f"./unpack/PRUNED_EMBEDDING.bin", dtype=np.int16).reshape(VOCAB, C).clip(-2**9, 2**9-1)
    print(f"done")
    
# physical addresses
ADDR_DECODER_X      = ddr_x         .device_address
ADDR_DECODER_Y      = ddr_y         .device_address
ADDR_CLS_Y          = ddr_cls_y     .device_address
ADDR_DECODER_W_LO   = ddr_w         .device_address
ADDR_DECODER_W_HI   = ddr_w         .device_address + DECODER_W_BYTES_HALF * QWEN_L
ADDR_CLS_W_LO       = ddr_cls_w     .device_address
ADDR_CLS_W_HI       = ddr_cls_w     .device_address + CLS_W_BYTES_HALF
ADDR_K_CACHE        = ddr_kv_cache  .device_address

# load weight
load_weight              () 
load_embedding           ()


"""create hardware interface"""
# hardware control registers address
ADDR_L_BEGIN                = 0x0000
ADDR_L_CLOSE                = 0x0010
ADDR_MEMORY_DECODER_X       = 0x0020
ADDR_MEMORY_DECODER_Y       = 0x0030
ADDR_MEMORY_CLS_Y           = 0x0040
ADDR_MEMORY_DECODER_W_LO    = 0x0050
ADDR_MEMORY_DECODER_W_HI    = 0x0060
ADDR_MEMORY_CLS_W_LO        = 0x0070
ADDR_MEMORY_CLS_W_HI        = 0x0080
ADDR_MEMORY_KV_CACHE        = 0x0090
ADDR_POS                    = 0x00A0
ADDR_T                      = 0x00B0
ADDR_IDLE                   = 0x00C0
# create memory mapped hardware interface
qwen = AXI_IP(0x00_A000_0000,
  [
    ("L_BEGIN",             ADDR_L_BEGIN,               np.int64),
    ("L_CLOSE",             ADDR_L_CLOSE,               np.int64),
    ("MEMORY_DECODER_X",    ADDR_MEMORY_DECODER_X,      np.int64),
    ("MEMORY_DECODER_Y",    ADDR_MEMORY_DECODER_Y,      np.int64),
    ("MEMORY_CLS_Y",        ADDR_MEMORY_CLS_Y,          np.int64),
    ("MEMORY_DECODER_W_LO", ADDR_MEMORY_DECODER_W_LO,   np.int64),
    ("MEMORY_DECODER_W_HI", ADDR_MEMORY_DECODER_W_HI,   np.int64),
    ("MEMORY_CLS_W_LO",     ADDR_MEMORY_CLS_W_LO,       np.int64),
    ("MEMORY_CLS_W_HI",     ADDR_MEMORY_CLS_W_HI,       np.int64),
    ("MEMORY_KV_CACHE",     ADDR_MEMORY_KV_CACHE,       np.int64),
    ("POS",                 ADDR_POS,                   np.int64),
    ("T",                   ADDR_T,                     np.int64),
    ("IDLE",                ADDR_IDLE,                  np.int64),
  ]
)
# set fixed memory layout
qwen.MEMORY_DECODER_X       = ADDR_DECODER_X
qwen.MEMORY_DECODER_Y       = ADDR_DECODER_Y
qwen.MEMORY_CLS_Y           = ADDR_CLS_Y
qwen.MEMORY_DECODER_W_LO    = ADDR_DECODER_W_LO
qwen.MEMORY_DECODER_W_HI    = ADDR_DECODER_W_HI
qwen.MEMORY_CLS_W_LO        = ADDR_CLS_W_LO
qwen.MEMORY_CLS_W_HI        = ADDR_CLS_W_HI
qwen.MEMORY_KV_CACHE        = ADDR_K_CACHE
# set number of layers. for full decoding, from 0 to QWEN_L + 1 (inclusive)
qwen.L_BEGIN = 0
qwen.L_CLOSE = QWEN_L + 1



"""fpga accelerator driver code"""
class QWEN_ACCELERATOR:
    def __init__(self, hardware, tokenizer, max_context=S):
        self.hardware       = hardware
        self.tokenizer      = tokenizer
        self.max_context    = max_context
        
        self.all_keep       = np.load("all_keep.npy")
        self.pruned2full    = np.array(self.all_keep)
        self.full2pruned    = np.zeros(FULL_VOCAB, dtype=np.int32)
        self.full2pruned[self.all_keep] = np.arange(len(self.all_keep))

    def put_embedding(self, input_ids):
        assert len(input_ids) == T
        pruned_ids = self.full2pruned[input_ids]
        ddr_x[:DECODER_NUM_X] = embedding[pruned_ids].reshape(TT, TP, CT, CP).transpose((0, 2, 1, 3)).reshape(-1)

    def run_prefill(self, chunk):
        # set ctrl regs
        self.hardware.L_BEGIN = 0
        self.hardware.L_CLOSE = QWEN_L
        self.hardware.POS = chunk*T +T-1
        # launch, wait until idle
        self.hardware.T = 1
        while True:
            sleep(0.0001)
            if self.hardware.IDLE:
                break

    def run_hardware(self, pos):
        # set ctrl regs
        self.hardware.L_BEGIN = 0
        self.hardware.L_CLOSE = QWEN_L + 1
        self.hardware.POS = pos
        # launch, wait until idle
        self.hardware.T = 1
        while True:
            sleep(0.0001)
            if self.hardware.IDLE:
                break
        # get cls logits result
        return ddr_cls_y[:T]

    
    def generate_iter(self, input_ids, GL=None, include_prefill=False):
        GL = GL or self.max_context
        S  = len(input_ids)
        GL = min(self.max_context-S, GL)
        # align to multiple of T
        pre_chunks = (S    + (T-1)) // T
        gen_chunks = (S+GL + (T-1)) // T

        # add trailing 0s, until its length is S+generate_length
        input_ids += [0] * (gen_chunks*T - S)

        # prefill
        for chunk_id in range(0, pre_chunks):
            self.put_embedding(input_ids[chunk_id*T:(chunk_id+1)*T])
            self.run_prefill(chunk_id)
            if include_prefill:
                yield input_ids[chunk_id*T:min((chunk_id+1)*T, S)]
        
        # decode
        for gen_pos in range(S, S+GL):
            pos = gen_pos - 1
            # calculate chunk_id
            chunk_id  = pos // T  
            chunk_pos = pos % T
            # run corresponding chunk
            self.put_embedding(input_ids[chunk_id*T:(chunk_id+1)*T])
            logits = self.run_hardware(chunk_id*T +T-1)
            # get the next token
            pruned_next_token_id = logits[chunk_pos]
            next_token_id = self.pruned2full[pruned_next_token_id]
            yield [next_token_id]
            # overwrite padding
            input_ids[gen_pos] = next_token_id
            # break if eos
            if next_token_id == tokenizer.eos_token_id:
                break

    def generate(self, input_ids, GL=None, include_prefill=False):
        return [item for piece in self.generate_iter(input_ids, GL, include_prefill) for item in piece]