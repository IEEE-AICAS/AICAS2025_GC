import numpy as np
from tqdm import tqdm
import torch
import os
from constants import *
from typing import Union, List

def compare_tensor_numpy(_x, _y, info=""):
    # apply data type promotion
    _x = np.squeeze(_x)
    _y = np.squeeze(_y)
    print("--------------------------------------compare tensor--------------------------------------")
    num = 10
    
    formatted_x = [f"{__x:8d}" for __x in _x.flatten()[:num]]
    formatted_y = [f"{__y:8d}" for __y in _y.flatten()[:num]]
    print(f"{info:30s} shape: {_x.shape}, min_x: {_x.min():.5e}, max_x: {_x.max():.5e}, elems: {formatted_x}")
    print(f"{info:30s} shape: {_y.shape}, min_y: {_y.min():.5e}, max_y: {_y.max():.5e}, elems: {formatted_y}")
    # compute average abs diff ratio
    diff = np.abs(_x - _y)
    avg_diff = np.mean(diff)
    avg_x = np.abs(_x).mean()
    avg_y = np.abs(_y).mean()
    allclose = np.allclose(_x, _y, rtol=1e-3)
    print(f"{info:30s}      Average diff: {avg_diff:.4f},           Average x: {avg_x:.4f},             Average y:{avg_y:.4f},            allclose: {allclose}")
    # assert allclose
    print("------------------------------------------------------------------------------------------")


class Quantizer(torch.nn.Module):
    
    def __init__(
            self, 
            n_bits      =8, 
            granularity ="per_group", 
            group_size  =128, 
            is_weight   =False,
            pot_scale   =False, 
            apot_scale  =False
        ):

        super().__init__()
        self.n_bits         = n_bits
        self.granularity    = granularity
        self.group_size     = group_size
        self.is_weight      = is_weight
        self.pot_scale      = pot_scale
        self.apot_scale     = apot_scale
        
        # cannot use pot_scale and apot_scale at the same time
        assert not (pot_scale and apot_scale)

        self.q_min = -2 ** (self.n_bits - 1)
        self.q_max = +2 ** (self.n_bits - 1) - 1
        
    def forward(self, t, fused=False, W_SCALE_BITS=3, A_SCALE_BITS=4):
        # store t shape
        t_shape = t.shape

        # for quantization, reshape the tensor to 2D
        if self.granularity == "per_tensor":
            t = t.view(1, -1)
        elif self.granularity == "per_channel":
            CI = t.shape[-1]
            t = t.view(-1, CI)
        elif self.granularity == "per_group":
            t = t.view(-1, self.group_size)
        
        t_max = t.abs().max(dim=-1, keepdim=True)[0]
        
        s, s1, s2 = None, None, None

        if self.is_weight:
            scale = t_max.div(self.q_max)
        else:
            scale = t_max.div(self.q_max+1)
        
        if self.pot_scale:
            # PoT implementation
            s = scale.log2().ceil().long()
        elif self.apot_scale:
            # APoT implementation
            s1 = scale.log2().floor()
            s2 = scale - 2 ** s1
            s2 = s2.log2().round() # round might cause overflow!
            # s2 = torch.zeros_like(s1)
            
        SCALE_BITS = W_SCALE_BITS if self.is_weight else A_SCALE_BITS
        
        if SCALE_BITS is not None:
            if self.pot_scale:
                s = s.clamp(min=0, max=2**SCALE_BITS - 1)
            elif self.apot_scale:
                s1 = s1.clamp(min=0, max=2**SCALE_BITS - 1)
                # s2 = s2.clamp(min=0, max=2**(SCALE_BITS-1) - 1)
                s2 = s2.clamp(min=0, max=2**(SCALE_BITS-0) - 1)

        # if pot or apot, reconstruct scale
        if self.pot_scale:
            scale = 2 ** s
        elif self.apot_scale:
            scale = 2 ** s1 + 2 ** s2

        # scale should be half
        scale = scale.half()

        if self.is_weight:
            t = t.div(scale).round()
        else:
            mask = (s != 0)
            t = torch.where(mask,
                ((t >> (s - 1)) + 1) >> 1,
                t
            )

        t = t.clamp(min=self.q_min, max=self.q_max) 

        # to integer domain
        t       = t.to(torch.int8)
        scale   = scale.to(torch.float32)
        if s is not None:
            s       = s.to(torch.int8)
        if s1 is not None:
            s1      = s1.to(torch.int8)
            s2      = s2.to(torch.int8)
            
        if not fused:
            # return t, scale, s, s1, s2
            if not self.apot_scale and not self.pot_scale:
                return t, scale
            elif self.apot_scale:
                return t, s1, s2
            else:
                return t, s
        else:
            t = t.mul(scale).reshape(t_shape)
            return t.float()
        
# some aux funcs
def save_tensor(t: Union[np.array, List], dtype, path, name):
    if not os.path.exists(path):
        os.makedirs(path)
    if isinstance(t, list):
        t = torch.tensor(t)
    print(f"Saving {name}, shape: {t.shape}, dtype: {t.dtype}")

    # only integer values
    t = t.astype(dtype)
    t_str = np.array2string(t[:5], separator=", ", formatter={"int": lambda x: f"{x:12d}"})
    print(f"First 5 elements: {t_str}")
    # concat path
    filename = f"{path}/{name}.bin"
    t.tofile(filename)


W_QUANT_PARAMS = {
    "n_bits":       5,
    "granularity":  "per_group",
    "group_size":   8,
    "is_weight":    True,
    "pot_scale":    False,
    "apot_scale":   True,
}

w_quantizer = Quantizer(**W_QUANT_PARAMS)


# load all tensors
embedding = np.fromfile(f"./unpack/PRUNED_EMBEDDING.bin", dtype=np.int16).reshape(VOCAB, C)
embedding = torch.tensor(embedding)
print(f"embedding shape: {embedding.shape}")

cls_wq, cls_ws1, cls_ws2 = w_quantizer(embedding * 2**-3,    fused=False)

del embedding

# convert back to numpy
cls_wq  = cls_wq .cpu().detach().numpy().reshape(-1)
cls_ws1 = cls_ws1.cpu().detach().numpy().reshape(-1)
cls_ws2 = cls_ws2.cpu().detach().numpy().reshape(-1)

# make G*G packs
cls_wq  = cls_wq .reshape(VOCABT, G, CT, G).transpose(0, 2, 1, 3).ravel()
cls_ws1 = cls_ws1.reshape(VOCABT, G, CT, 1).transpose(0, 2, 1, 3).ravel()
cls_ws2 = cls_ws2.reshape(VOCABT, G, CT, 1).transpose(0, 2, 1, 3).ravel()


WQ_CYCS             = 20
WS_CYCS             = 3
BYTE_PER_PACK       = DW_MAXI // 8
WQ_PACK_PER_LOOP    = WQ_CYCS*DW_MAXI // (DW_WQ*G*G)
WS_PACK_PER_LOOP    = WS_CYCS*DW_MAXI // (DW_WS*2*G)

CLS_NUM_WQ          = VOCAB*C
CLS_NUM_WS          = CLS_NUM_WQ // G
CLS_W_CYCS          = (CLS_NUM_WQ*DW_WQ + CLS_NUM_WS*DW_WS*2) // DW_MAXI
CLS_LOOPS           = CLS_W_CYCS // (WQ_CYCS + WS_CYCS)


def compose_tile(tile, i_bits):
    mask = (1 << i_bits) - 1
    result = 0
    for num in reversed(tile):
        num = int(num)
        numBigInt = num if num >= 0 else (1 << i_bits) + num
        result = (result << i_bits) | (numBigInt & mask)
    return result


def resolve_tile(tile_int, o_bits, P, is_signed):
    local_array = np.zeros(P, dtype=np.int64)
    mask = (1 << o_bits) - 1
    for p in range(P):
        part_val = (tile_int >> (o_bits * p)) & mask
        sign_bit = (part_val >> (o_bits - 1)) & 1 if is_signed else 0
        local_array[p] = part_val - (sign_bit << o_bits)
    return local_array.astype(np.int8)


condensed_w = np.zeros(CLS_W_CYCS * BYTE_PER_PACK, dtype=np.int8)
for loop in tqdm(range(CLS_LOOPS)):
    loop_wq = cls_wq[loop * WQ_PACK_PER_LOOP * G * G : (loop + 1) * WQ_PACK_PER_LOOP * G * G]
    loop_ws = np.concatenate([
        cls_ws1[loop * WS_PACK_PER_LOOP * G : (loop + 1) * WS_PACK_PER_LOOP * G],
        cls_ws2[loop * WS_PACK_PER_LOOP * G : (loop + 1) * WS_PACK_PER_LOOP * G]
    ]).reshape(2, -1).transpose().ravel()
    loop_wq_bigint = compose_tile(loop_wq, DW_WQ)
    loop_ws_bigint = compose_tile(loop_ws, DW_WS)
    loop_wq_resolved = resolve_tile(loop_wq_bigint, 8, WQ_CYCS * BYTE_PER_PACK, is_signed=False)
    loop_ws_resolved = resolve_tile(loop_ws_bigint, 8, WS_CYCS * BYTE_PER_PACK, is_signed=False)
    condensed_w[loop * (WQ_CYCS + WS_CYCS) * BYTE_PER_PACK : loop * (WQ_CYCS + WS_CYCS) * BYTE_PER_PACK + WQ_CYCS * BYTE_PER_PACK] = loop_wq_resolved
    condensed_w[loop * (WQ_CYCS + WS_CYCS) * BYTE_PER_PACK + WQ_CYCS * BYTE_PER_PACK : (loop + 1) * (WQ_CYCS + WS_CYCS) * BYTE_PER_PACK] = loop_ws_resolved



# make interleaving
# 256 bit = 32 bytes
# every 32 bytes, split into lo and hi
condensed_w = condensed_w.reshape(-1, 2, 16).transpose(1, 0, 2).reshape(-1)

# save tensor to binaries
save_tensor(condensed_w, np.byte, "./unpack", "all_cls_w_tied")