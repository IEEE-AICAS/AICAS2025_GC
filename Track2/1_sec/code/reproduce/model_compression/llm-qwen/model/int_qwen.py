""" Int Qwen model."""
from typing import List, Optional, Tuple, Union
import math
import torch
from torch.nn import functional as F
import tqdm
import torch
import torch.utils.checkpoint
from torch import nn
from matplotlib import pyplot as plt

import triton
import triton.language as tl

from transformers.cache_utils import Cache
from transformers import Qwen2Config

from utils.ppl_eval import minmax
from model.fake_quant import Quantizer



W_QUANT_PARAMS = {
    "n_bits":       5,
    "granularity":  "per_group",
    "group_size":   8,
    "is_weight":    True,
    "pot_scale":    False,
    "apot_scale":   True,
}

A_QUANT_PARAMS = {
    "n_bits":       8,
    "granularity":  "per_group",
    "group_size":   8,
    "is_weight":    False,
    "pot_scale":    True,
    "apot_scale":   False
}

R_QUANT_PARAMS = {
    "n_bits":       8,
    "granularity":  "per_group",
    "group_size":   8,
    "is_weight":    False,
    "pot_scale":    True,
    "apot_scale":   False
}

w_quantizer = Quantizer(**W_QUANT_PARAMS)
a_quantizer = Quantizer(**A_QUANT_PARAMS)
r_quantizer = Quantizer(**R_QUANT_PARAMS)


# TODO: check the data type
# TODO: for evaluation: use bf16
# TODO: for saving, use float32
# matmul_dtype = torch.bfloat16
# matmul_dtype = torch.float32
matmul_dtype = torch.float64

def shift_matmul(x_q, x_s, w_q, w_s1, w_s2, CI, CO, GA, GW):
    # # check shape
    assert len(x_q .shape) == 2 and x_q .shape[1] == GA
    assert len(x_s .shape) == 2 and x_s .shape[1] == 1
    assert len(w_q .shape) == 2 and w_q .shape[1] == GW
    assert len(w_s1.shape) == 2 and w_s1.shape[1] == 1
    assert len(w_s2.shape) == 2 and w_s2.shape[1] == 1
    # check value, shift must be non-negative
    assert x_s .min() >= 0
    assert w_s1.min() >= 0
    assert w_s2.min() >= 0
    # align shape
    x_q     = x_q .view(-1, GA).int()
    w_q     = w_q .view(-1, GW).int()
    x_s     = x_s .view(-1, 1)
    w_s1    = w_s1.view(-1, 1)
    w_s2    = w_s2.view(-1, 1)
    # restore values
    x = ( x_q << x_s                  ).view(-1, CI)
    w = ((w_q << w_s1) + (w_q << w_s2)).view(-1, CI)
    # since int64 doesn't support matmul
    x = x.to(matmul_dtype)
    w = w.to(matmul_dtype)
    y = torch.nn.functional.linear(x, w).long()
    return y



def shift_qk_matmul(q_q, q_s, k_q, k_s, B, H, T, S, HC, GA):
    # The shape of q should be [B, H, T, HC]
    # The shape of k should be [B, H, S, HC]
    # check shape
    assert len(q_q.shape) == 2 and q_q.shape[1] == GA
    assert len(k_q.shape) == 2 and k_q.shape[1] == GA
    assert len(q_s.shape) == 2 and q_s.shape[1] == 1
    assert len(k_s.shape) == 2 and k_s.shape[1] == 1
    # check value
    assert q_s.min() >= 0
    assert k_s.min() >= 0
    # align shape
    q_q = q_q.view(-1, GA).int()
    k_q = k_q.view(-1, GA).int()
    q_s = q_s.view(-1, 1)
    k_s = k_s.view(-1, 1)
    q   = (q_q << q_s).view(B, H, T, HC)
    k   = (k_q << k_s).view(B, H, S, HC)
    # since int64 doesn't support matmul
    q   = q.to(matmul_dtype)
    k   = k.to(matmul_dtype)
    r   = q @ k.transpose(-2, -1)
    r   = r.long()
    return r    


def shift_rv_matmul(r_q, r_s, vt_q, vt_s, B, H, T, S, HC, GR):
    # The shape of r  should be [B, H, T, S]
    # The shape of vt should be [B, H, HC, S]
    # check shape
    assert len(r_q.shape)   == 2 and r_q .shape[1] == GR
    assert len(vt_q.shape)  == 2 and vt_q.shape[1] == GR
    assert len(r_s.shape)   == 2 and r_s .shape[1] == 1
    assert len(vt_s.shape)  == 2 and vt_s.shape[1] == 1
    # check value
    assert r_s .min() >= 0
    assert vt_s.min() >= 0
    # align shape
    r_q  = r_q .view(-1, GR).int()
    vt_q = vt_q.view(-1, GR).int()
    r_s  = r_s .view(-1, 1)
    vt_s = vt_s.view(-1, 1)
    # restore values
    r    = (r_q  << r_s ).view(B, H, T,  S)
    vt   = (vt_q << vt_s).view(B, H, HC, S)
    # since int64 doesn't support matmul
    r    = r .to(matmul_dtype)
    vt   = vt.to(matmul_dtype)
    a    = r @ vt.transpose(-2, -1)
    a    = a.long()
    return a



class IntLUT(nn.Module):
    # general lookup table
    def __init__(self, fn, r, addrwidth, bits):
        super().__init__()
        self.alpha, self.beta   = r
        self.addrwidth          = addrwidth
        self.entries            = 2**self.addrwidth
        self.bits               = bits
        # always unsigned
        table_min       = 0
        table_max       = +2**self.bits - 1
        # ". / denom" converts data to index
        self.denom      = (self.beta - self.alpha) / (self.entries - 1)
        self.log2denom  = int(math.ceil(math.log2(self.denom)))
        # PoT index approximation
        self.denom      = 2 ** self.log2denom
        self.beta       = self.alpha + self.denom * (self.entries - 1)
        # backward pass, from range to index
        indices = torch.arange(self.entries, dtype=torch.float32)
        x = indices * self.denom + self.alpha
        # create table
        self.table = fn(x)
        # always unsigned
        self.O_out = self.bits - self.table.max().log2().ceil().to(torch.int64)
        # make fixed
        self.table = self.table.mul(1 << self.O_out).round().clamp(table_min, table_max).to(torch.int64)
        
    def forward(self, t):
        # float input, float output
        t = t.to(torch.float32)
        # forward pass
        indices = ((t - self.alpha) / self.denom).floor().to(torch.int64)
        indices = torch.clamp(indices, 0, self.entries - 1)
        # lookup
        self.table = self.table.to(t.device)
        t = self.table[indices]
        t = t / 2**self.O_out
        return t.float()

    
class IntSegmentedLUT(nn.Module):
    # for high dynamic range
    def __init__(self, fn, rs, addrwidth, bits):
        # rs is a tuple of ranges
        super().__init__()
        self.rs             = rs
        self.addrwidth      = addrwidth
        self.entries        = 2**self.addrwidth
        self.bits           = bits
        self.luts = {i: IntLUT(fn, r, addrwidth, bits) for i, r in enumerate(self.rs)}
        
    def forward(self, t, **kwargs):
        # calculate result on all tables
        masks   = []
        outputs = []
        # compute all outputs for all tables
        for i, r in enumerate(self.rs):
            if i == 0:
                mask = t <= r[1]
            elif i == len(self.rs) - 1:
                mask = t >= r[0]
            else:
                mask = (t >= r[0]) & (t <= r[1])
            masks.append(mask)
            outputs.append(self.luts[i](t, **kwargs))
        # combine outputs
        t = torch.zeros_like(outputs[0])
        for i, output in enumerate(outputs):
            t = torch.where(masks[i], output, t)
        
        return t.float()

        
class IntSiLU(nn.Module):
    def __init__(self, O_in):
        super(IntSiLU, self).__init__()
        self.O_in = O_in
        # since alpha is exact 0, don't need to shift alpha and beta
        self.alpha          = 0
        self.beta           = +5
        self.lut_addrwidth  = 9
        self.lut_bits       = 8
        self.lut            = IntLUT(lambda x: torch.nn.functional.relu(x) - torch.nn.functional.silu(x), (self.alpha, self.beta), self.lut_addrwidth, self.lut_bits)
        self.entries        = self.lut.entries
        # need to shift more, which is O_in
        self.log2denom      = self.lut.log2denom + self.O_in
        self.O_back         = self.O_in - self.lut.O_out
        # register table
        self.register_buffer("table", self.lut.table)
        
    def forward(self, t):
        # relu
        t_relu = torch.nn.functional.relu(t)
        # step by step
        indices = (t.abs() - self.alpha) >> self.log2denom
        indices = torch.clamp(indices, 0, self.entries - 1)
        t_diff = self.table[indices]
        t_silu = t_relu - (t_diff << self.O_back)
        return t_silu


class IntSoftmax(nn.Module):
    # my own softmax implementation, with LUT
    def __init__(self, head_dim, O_in):
        super(IntSoftmax, self).__init__()
        self.O_in = O_in
        self.scale = 1 / math.sqrt(head_dim)
        # exp table
        self.exp_alpha          = 0
        self.exp_beta           = +200
        self.exp_addrwidth      = 8
        self.exp_bits           = 8
        self.exp_lut            = IntLUT(lambda x: torch.exp(-x * self.scale), (self.exp_alpha, self.exp_beta), self.exp_addrwidth, self.exp_bits)
        self.exp_log2denom      = self.exp_lut.log2denom + self.O_in
        self.exp_entries        = self.exp_lut.entries
        # register table
        self.register_buffer("exp_table", self.exp_lut.table)
        # something special about exp_lut: its max value must be 0
        self.exp_table[-1]      = 0
        # recip table
        self.recip_rs = (
            (2**+0, 2**+3),
            (2**+3, 2**+6),
            (2**+6, 2**+9),
            (2**+9, 2**+12), # max
        )
        O_recip = self.exp_lut.O_out
        self.recip_rs = tuple(
            (int(r[0] * 2**O_recip), r[1] * 2**O_recip) for r in self.recip_rs
        )
        self.recip_addrwidth    = 8
        self.recip_bits         = 8
        self.recip_entries      = 1 << self.recip_addrwidth
        self.recip_lut          = IntSegmentedLUT(lambda x: 2**O_recip / x, self.recip_rs, self.recip_addrwidth, self.recip_bits)
        # register tables 
        self.recip_num_tables   = len(self.recip_lut.luts)
        self.register_buffer("recip_log2denoms", torch.tensor([self.recip_lut.luts[i].log2denom         for i in range(self.recip_num_tables)], dtype=torch.int64))
        self.register_buffer("recip_offsets",    torch.tensor([self.recip_lut.luts[i].O_out             for i in range(self.recip_num_tables)], dtype=torch.int64))
        self.register_buffer("recip_alphas",     torch.tensor([self.recip_lut.luts[i].alpha             for i in range(self.recip_num_tables)], dtype=torch.int64))
        self.register_buffer("recip_betas",      torch.tensor([self.recip_lut.luts[i].beta              for i in range(self.recip_num_tables)], dtype=torch.int64))
        self.register_buffer("recip_tables",     torch.cat([self.recip_lut.luts[i].table.unsqueeze(0)   for i in range(self.recip_num_tables)], dim=0).to(torch.int32))
        # for segmented table, get the biggest offsets
        self.recip_offset = self.recip_offsets.max().item()
        # compute offsets diff
        self.register_buffer("recip_offsets_diff", self.recip_offset - self.recip_offsets)
        self.O_out = self.exp_lut.O_out + self.recip_offset
        # truncate multiplication
        self.Trunc_mul = 12
        self.O_out = self.O_out - self.Trunc_mul

    def forward(self, t, mask):
        # make mask int
        if mask is not None:
            mask = mask.int()
            t    = t + mask
        # softmax
        t_max   = t.max(dim=-1, keepdim=True).values
        # index computation
        indices = (t_max - t) >> self.exp_log2denom
        indices = torch.clamp(indices, 0, self.exp_entries - 1)
        # lookup
        t      = self.exp_table[indices]
        # sum of exp results
        t_sum  = t.sum(dim=-1, keepdim=True)
        # recip
        recip_lut_indices = torch.zeros_like(t_sum, dtype=torch.int32)
        for i in range(self.recip_num_tables):
            mask = (t_sum >= self.recip_alphas[i]) & (t_sum < self.recip_betas[i])
            recip_lut_indices = torch.where(mask, i, recip_lut_indices)
        # calculate indices
        recip_indices = (t_sum - self.recip_alphas[recip_lut_indices]) >> (self.recip_log2denoms[recip_lut_indices])
        recip_indices = torch.clamp(recip_indices, 0, self.recip_entries - 1)
        # lookup
        t_recip = torch.zeros_like(t_sum, dtype=torch.int32)
        for i in range(self.recip_num_tables):
            t_recip = torch.where(recip_lut_indices == i, self.recip_tables[i][recip_indices], t_recip)
        # compensate offsets
        t_recip <<= self.recip_offsets_diff[recip_lut_indices]
        # mul
        t_softmax = (t * t_recip) >> self.Trunc_mul

        return t_softmax
    
        
class IntRMSNorm(nn.Module):
    def __init__(self, C, eps, O_in, lnw):
        super().__init__()
        self.eps        = eps
        self.C          = C
        self.O_in       = O_in
        # truncate layernorm weight
        self.O_lnw      = 11
        # truncate two muls
        self.Trunc_mul1 = 12
        self.Trunc_mul2 = 13
        # truncate lnw
        self.register_buffer("lnw", lnw.to(torch.float64))
        self.lnw = torch.round(self.lnw * 2**self.O_lnw).to(torch.int32)
        # rsqrt fn
        fn = lambda x: torch.rsqrt(x/self.C + self.eps*2**(2*self.O_in))
        
        # a table with coarser granularity, from -3 to 22, 4 tables
        self.rsqrt_rs = (
            (2**-3, 2**+3),
            (2**+3, 2**+9),
            (2**+9, 2**+15),
            (2**+15, 2**+22)
        )
            
        # integer ranges
        self.rsqrt_rs = tuple(
            (r[0] * 2.0**(2*self.O_in), r[1] * 2.0**(2*self.O_in)) for r in self.rsqrt_rs
        )
        # create segmented table
        self.rsqrt_addrwidth    = 9
        self.rsqrt_bits         = 8
        self.entries            = 1 << self.rsqrt_addrwidth
        self.rsqrt_lut          = IntSegmentedLUT(fn, self.rsqrt_rs, self.rsqrt_addrwidth, self.rsqrt_bits)
        # explicit implementation
        self.num_tables         = len(self.rsqrt_lut.luts)
        self.register_buffer("log2denoms", torch.tensor([self.rsqrt_lut.luts[i].log2denom       for i in range(self.num_tables)], dtype=torch.int64))
        self.register_buffer("offsets",    torch.tensor([self.rsqrt_lut.luts[i].O_out           for i in range(self.num_tables)], dtype=torch.int64))
        self.register_buffer("alphas",     torch.tensor([self.rsqrt_lut.luts[i].alpha           for i in range(self.num_tables)], dtype=torch.int64))
        self.register_buffer("betas",      torch.tensor([self.rsqrt_lut.luts[i].beta            for i in range(self.num_tables)], dtype=torch.int64))
        self.register_buffer("tables",     torch.cat([self.rsqrt_lut.luts[i].table.unsqueeze(0) for i in range(self.num_tables)], dim=0).to(torch.int32))
        # get the biggest offsets
        self.offset     = self.offsets.max().item()
        # # compute offsets diff
        self.register_buffer("offsets_diff", self.offset - self.offsets)
        # compensate quantization s
        self.O_out = int(self.O_lnw + self.offset - self.Trunc_mul1 - self.Trunc_mul2)

    def forward(self, x):
        # sum
        x_sum = x.pow(2).sum(dim=-1, keepdim=True)
        # determine which table to use
        x_lut_idx = torch.zeros_like(x, dtype=torch.int32)
        for lut_idx in range(self.num_tables):
            mask = (x_sum >= self.alphas[lut_idx]) & (x_sum < self.betas[lut_idx])
            x_lut_idx = torch.where(mask, lut_idx, x_lut_idx)
        # calculate indices
        indices = (x_sum - self.alphas[x_lut_idx]) >> (self.log2denoms[x_lut_idx])
        indices = torch.clamp(indices, 0, self.entries - 1)
        # lookup
        x_rsqrt = torch.zeros_like(x, dtype=torch.int32)
        for lut_idx in range(self.num_tables):
            x_rsqrt = torch.where(x_lut_idx == lut_idx, self.tables[lut_idx][indices], x_rsqrt)
        # compensate offsets
        x_rsqrt <<= self.offsets_diff[x_lut_idx]
        # truncate two muls
        x = (x * x_rsqrt)   >> self.Trunc_mul1
        x = (x * self.lnw)  >> self.Trunc_mul2

        return x
        
        
class IntCordic(nn.Module):
    def __init__(self, n_iter=16):
        super().__init__()
        self.O_angle = n_iter
        self.O_theta = 24
        self.O_K = 16
        self.N_ITER = n_iter
        self.PI = 3.14159265358979323846
        # Precomputed values
        self.CORDIC_THETAS  = torch.zeros(self.N_ITER + 1, dtype=torch.int64)
        self.K              = None
        self.FIXED_PI_2     = self.make_fixed(self.PI / 2,      self.O_angle)
        self.FIXED_PI       = self.make_fixed(self.PI,          self.O_angle)
        self.FIXED_3PI_2    = self.make_fixed(3 * self.PI / 2,  self.O_angle)
        self.FIXED_2PI      = self.make_fixed(2 * self.PI,      self.O_angle)
        self.FIXED_4_PI     = self.make_fixed(4 / self.PI,      self.O_angle)
        
        self.initialize_cordic_params()
    
    def make_fixed(self, _float, _bits):
        if isinstance(_float, torch.Tensor):
            return (_float * (1 << _bits)).long()
        else:
            return int(_float * (1 << _bits))
    
    def initialize_cordic_params(self):
        k = 1.0
        for i in range(1, self.N_ITER + 1):
            theta = torch.atan(torch.tensor(1.0 / (2 ** i)))
            self.CORDIC_THETAS[i] = self.make_fixed(theta.item(), self.O_angle)
            k *= 1.0 / torch.sqrt(torch.tensor(1 + 2 ** (-2 * i))).item()
        self.K = self.make_fixed(k, self.O_K)
    
    def forward(self, gamma):
        # compute circles
        N       = (gamma * self.FIXED_4_PI) >> (self.O_angle * 2)
        circles = N >> 3
        N       = N - (circles << 3)
        gamma = gamma - circles * self.FIXED_2PI
        # Preprocessing to bring gamma into range [0, pi/4]
        gamma   = torch.where(N == 1, self.FIXED_PI_2 - gamma,    gamma)
        gamma   = torch.where(N == 2, gamma - self.FIXED_PI_2,    gamma)
        gamma   = torch.where(N == 3, self.FIXED_PI - gamma,      gamma)
        gamma   = torch.where(N == 4, gamma - self.FIXED_PI,      gamma)
        gamma   = torch.where(N == 5, self.FIXED_3PI_2 - gamma,   gamma)
        gamma   = torch.where(N == 6, gamma - self.FIXED_3PI_2,   gamma)
        gamma   = torch.where(N == 7, self.FIXED_2PI - gamma,     gamma)
        cur_angle = gamma
        cur_cos = torch.full_like(gamma, self.make_fixed(1.0, self.O_angle))
        cur_sin = torch.zeros_like(gamma)
        # cordic iterations
        for i in range(1, self.N_ITER + 1):
            new_angle   = torch.where(cur_angle > 0, cur_angle - self.CORDIC_THETAS[i], cur_angle + self.CORDIC_THETAS[i])
            new_cos     = torch.where(cur_angle > 0, cur_cos - (cur_sin >> i), cur_cos + (cur_sin >> i))
            new_sin     = torch.where(cur_angle > 0, cur_sin + (cur_cos >> i), cur_sin - (cur_cos >> i))
            # update
            cur_angle   = new_angle
            cur_cos     = new_cos
            cur_sin     = new_sin
        # Apply K scale, therefore output is still O_angle
        cur_cos = (cur_cos * self.K) >> self.O_K
        cur_sin = (cur_sin * self.K) >> self.O_K
        # Post-processing
        cos_val, sin_val = cur_cos, cur_sin
        
        cos_val = torch.where(N == 1, +cur_sin, +cur_cos)
        sin_val = torch.where(N == 1, +cur_cos, +cur_sin)
        cos_val = torch.where(N == 2, -cur_sin, +cos_val)
        sin_val = torch.where(N == 2, +cur_cos, +sin_val)
        cos_val = torch.where(N == 3, -cur_cos, +cos_val)
        sin_val = torch.where(N == 3, +cur_sin, +sin_val)
        cos_val = torch.where(N == 4, -cur_cos, +cos_val)
        sin_val = torch.where(N == 4, -cur_sin, +sin_val)
        cos_val = torch.where(N == 5, -cur_sin, +cos_val)
        sin_val = torch.where(N == 5, -cur_cos, +sin_val)
        cos_val = torch.where(N == 6, +cur_sin, +cos_val)
        sin_val = torch.where(N == 6, -cur_cos, +sin_val)
        cos_val = torch.where(N == 7, +cur_cos, +cos_val)
        sin_val = torch.where(N == 7, -cur_sin, +sin_val)
        
        return cos_val, sin_val


class IntRotaryEmbedding(nn.Module):
    # Class-level variables to hold shared cos_table and sin_table
    cos_table = None
    sin_table = None

    def __init__(self, dim, base=10000, device="cuda"):
        super().__init__()
        self.dim = dim
        self.base = base
        self.cordic = IntCordic(n_iter=12)
        # Thetas for each dimension in RoPE
        thetas = 1.0 / (base ** (torch.arange(0, dim, 2, dtype=torch.int64).to(torch.float64) / dim))
        thetas = self.cordic.make_fixed(thetas, self.cordic.O_theta).long()
        self.register_buffer("thetas", thetas, persistent=False)
        # Convert from theta domain to angle domain
        self.Trunc_mul = self.cordic.O_theta - self.cordic.O_angle

        # Compute cos_table and sin_table only once and share globally
        if IntRotaryEmbedding.cos_table is None or IntRotaryEmbedding.sin_table is None:
            max_position = 4096  # Positions from 0 to 4095
            positions = torch.arange(0, max_position).reshape(-1, 1)  # Shape: [4096, 1]
            thetas = self.thetas.reshape(1, -1)  # Shape: [1, dim/2]
            freqs = (thetas * positions) >> self.Trunc_mul  # Shape: [4096, dim/2]
            # Cordic computation
            cos_table, sin_table = self.cordic(freqs)  # Shape: [4096, dim/2]
            IntRotaryEmbedding.cos_table = cos_table.to(device)
            IntRotaryEmbedding.sin_table = sin_table.to(device)

    @torch.no_grad()
    def forward(self, x, position_ids):
        # Reshape to ensure position_ids has shape [B, T]
        position_ids = position_ids.view(position_ids.shape[0], -1)  # Shape: [B, T]
        # get device
        device = x.device
        # move table
        IntRotaryEmbedding.cos_table = IntRotaryEmbedding.cos_table.to(device)
        IntRotaryEmbedding.sin_table = IntRotaryEmbedding.sin_table.to(device)
        # Retrieve precomputed cos_val and sin_val
        cos_val = IntRotaryEmbedding.cos_table[position_ids]  # Shape: [B, T, dim/2]
        sin_val = IntRotaryEmbedding.sin_table[position_ids]  # Shape: [B, T, dim/2]
        # Add necessary dimensions to match expected output
        cos_val = cos_val.unsqueeze(1)  # Shape: [B, T, 1, dim/2]
        sin_val = sin_val.unsqueeze(1)  # Shape: [B, T, 1, dim/2]
        return cos_val, sin_val

class IntQwenMHA(nn.Module):
    def __init__(self, config: Qwen2Config, O_res, fp_decoder):
        super().__init__()
        self.config         = config
        self.idx            = fp_decoder.self_attn.layer_idx
        # some global parameters
        self.C              = config.hidden_size
        self.H              = config.num_attention_heads
        self.HC             = self.C // self.H
        self.KVH            = config.num_key_value_heads
        # group size
        self.GA = A_QUANT_PARAMS["group_size"]
        self.GW = W_QUANT_PARAMS["group_size"]
        self.GR = R_QUANT_PARAMS["group_size"]
        # Offsets
        self.O_res          = O_res
        self.O_w            = 10
        # rmsnorm
        self.rmsnorm        = IntRMSNorm(self.C, config.rms_norm_eps, self.O_res, fp_decoder.input_layernorm.weight)
        self.rotary_emb     = IntRotaryEmbedding(self.HC, base=config.rope_theta, device=next(fp_decoder.parameters()).device) # a placeholder
        self.O_angle        = self.rotary_emb.cordic.O_angle
        # some offsets
        self.O_in           = self.rmsnorm.O_out
        self.Trunc_qk       = 12
        self.Trunc_v        = 6
        self.Trunc_rot      = 12
        self.O_qk           = self.O_in + self.O_w + self.O_angle - self.Trunc_qk - self.Trunc_rot
        self.O_v            = self.O_in + self.O_w - self.Trunc_v
        self.Trunc_r        = 12
        self.O_r            = self.O_qk + self.O_qk - self.Trunc_r
        # init softmax
        self.softmax        = IntSoftmax(head_dim=self.HC, O_in=self.O_r)
        self.O_softmax      = self.softmax.O_out
        self.Trunc_a        = 12
        self.O_a            = self.O_softmax + self.O_v - self.Trunc_a
        self.Trunc_o        = self.O_a + self.O_w - self.O_res

        # weight
        wq = fp_decoder.self_attn.q_proj.weight * 2**self.O_w
        wk = fp_decoder.self_attn.k_proj.weight * 2**self.O_w
        wv = fp_decoder.self_attn.v_proj.weight * 2**self.O_w
        wo = fp_decoder.self_attn.o_proj.weight * 2**self.O_w
        # bias
        bq = (fp_decoder.self_attn.q_proj.bias * 2**(self.O_in + self.O_w - self.Trunc_qk)).long()
        bk = (fp_decoder.self_attn.k_proj.bias * 2**(self.O_in + self.O_w - self.Trunc_qk)).long()
        bv = (fp_decoder.self_attn.v_proj.bias * 2**(self.O_in + self.O_w - self.Trunc_v )).long() 


        # rotate wq and wk
        wq = wq.reshape(self.H,   2, self.HC//2, self.C).transpose(1, 2).reshape(self.H  *self.HC, self.C)
        wk = wk.reshape(self.KVH, 2, self.HC//2, self.C).transpose(1, 2).reshape(self.KVH*self.HC, self.C)
        # rotate bq and bk
        bq = bq.reshape(self.H,   2, self.HC//2).transpose(1, 2).reshape(self.H  *self.HC)
        bk = bk.reshape(self.KVH, 2, self.HC//2).transpose(1, 2).reshape(self.KVH*self.HC)
        
        # register un-repeated bk and bv
        self.register_buffer("bk_raw", bk)
        self.register_buffer("bv_raw", bv)

        # repeat wk, wv, bk, bv, therefore make KVH=H
        repeat = self.H // self.KVH
        wk = wk.reshape(self.KVH, self.HC, self.C).repeat(1, repeat, 1).reshape(self.C, self.C)
        wv = wv.reshape(self.KVH, self.HC, self.C).repeat(1, repeat, 1).reshape(self.C, self.C)
        bk = bk.reshape(self.KVH, self.HC).repeat(1, repeat).reshape(self.C)
        bv = bv.reshape(self.KVH, self.HC).repeat(1, repeat).reshape(self.C)
        # then KVH=H
        self.KVH = self.H

        # quantize
        wq_q, wq_s1, wq_s2 = w_quantizer(wq, fused=False, W_SCALE_BITS=3)
        wk_q, wk_s1, wk_s2 = w_quantizer(wk, fused=False, W_SCALE_BITS=3)
        wv_q, wv_s1, wv_s2 = w_quantizer(wv, fused=False, W_SCALE_BITS=3)
        wo_q, wo_s1, wo_s2 = w_quantizer(wo, fused=False, W_SCALE_BITS=3)

        # register buffers
        self.register_buffer("wq_q",  wq_q)
        self.register_buffer("wq_s1", wq_s1)
        self.register_buffer("wq_s2", wq_s2)
        self.register_buffer("wk_q",  wk_q)
        self.register_buffer("wk_s1", wk_s1)
        self.register_buffer("wk_s2", wk_s2)
        self.register_buffer("wv_q",  wv_q)
        self.register_buffer("wv_s1", wv_s1)
        self.register_buffer("wv_s2", wv_s2)
        self.register_buffer("wo_q",  wo_q)
        self.register_buffer("wo_s1", wo_s1)
        self.register_buffer("wo_s2", wo_s2)

        self.register_buffer("bq", bq)
        self.register_buffer("bk", bk)
        self.register_buffer("bv", bv)

    def repeat_kv(self, kv: torch.Tensor, n: int) -> torch.Tensor:
        B, KVH, S, HC = kv.shape
        kv = kv[:, :, None, :, :].expand(B, KVH, n, S, HC)
        return kv.reshape(B, KVH * n, S, HC)
    

    def rotate(self, _x):
        """Rotate adjacent two dims"""
        _y = _x.clone()
        _y[..., 0::2] = -_x[..., 1::2]
        _y[..., 1::2] = +_x[..., 0::2]
        return _y

        
    # Adapted from QwenAttention.forward
    def forward(
        self,
        x:                      torch.Tensor,
        position_embeddings:    Tuple[torch.Tensor, torch.Tensor],
        mask:                   Optional[torch.Tensor]      = None,
        pos_ids:                Optional[torch.LongTensor]  = None,
        kv_cache:               Optional[Cache]             = None,
        cache_position:         Optional[torch.LongTensor]  = None,
    ) -> Tuple[torch.Tensor, Optional[torch.Tensor], Optional[Tuple[torch.Tensor]]]:
        # save residual
        residual = x
        # save shape
        B, T, _ = x.shape
        # rmsnorm
        xln = self.rmsnorm(x)
        # quantize
        xlnq, xlns = a_quantizer(xln, fused=False)
        # generate q, k, v
        q_trunc = shift_matmul(xlnq, xlns, self.wq_q, self.wq_s1, self.wq_s2, self.C, self.H  *self.HC, self.GA, self.GW) >> self.Trunc_qk
        k_trunc = shift_matmul(xlnq, xlns, self.wk_q, self.wk_s1, self.wk_s2, self.C, self.KVH*self.HC, self.GA, self.GW) >> self.Trunc_qk
        v_trunc = shift_matmul(xlnq, xlns, self.wv_q, self.wv_s1, self.wv_s2, self.C, self.KVH*self.HC, self.GA, self.GW) >> self.Trunc_v
        # bias
        q_trunc = q_trunc + self.bq
        k_trunc = k_trunc + self.bk
        v_trunc = v_trunc + self.bv
        # reshape q, k, v and truncate
        q_trunc = q_trunc.view(B, T, self.H,    self.HC).transpose(1, 2).contiguous() 
        k_trunc = k_trunc.view(B, T, self.KVH,  self.HC).transpose(1, 2).contiguous() 
        v_trunc = v_trunc.view(B, T, self.KVH,  self.HC).transpose(1, 2).contiguous() 
        # apply RoPE
        _cos, _sin = position_embeddings
        cos_val = torch.repeat_interleave(_cos, 2, dim=-1)
        sin_val = torch.repeat_interleave(_sin, 2, dim=-1)
        # rotate q and k
        qrot = (q_trunc * cos_val + self.rotate(q_trunc) * sin_val) >> self.Trunc_rot
        krot = (k_trunc * cos_val + self.rotate(k_trunc) * sin_val) >> self.Trunc_rot
        
        # update kv cache
        cache_kwargs = {"sin": _sin, "cos": _cos, "cache_position": cache_position}
        krot, v_trunc = kv_cache.update(krot, v_trunc, self.idx, cache_kwargs)
        # after updating the cache, the shape will change in the generation
        _B, _KVH, _S, _HC = krot.shape
        assert B == _B and self.KVH == _KVH and _HC == self.HC
        S = _S
        
        # there are two possibilities
        # 1. prefill, T == S: construct simple mask
        # 2. decode,  T == 1: skip mask
        if T == 1:
            mask = None
        else:
            assert T == S
            mask = torch.triu(torch.ones(T, T), diagonal=1).to(x.device)
            mask = mask.masked_fill(mask == 1, -1e9).int()
            mask = mask[None, None, :, :]
        
        # pad v, to next multiple of GR
        if S % self.GR != 0:
            pad_length = self.GR - (S % self.GR)
            S = S + pad_length
            krot    = F.pad(krot,     (0, 0, 0, pad_length), value=0)
            v_trunc = F.pad(v_trunc,  (0, 0, 0, pad_length), value=0)
            if mask is not None:
                mask = F.pad(mask, (0, pad_length), value=-1e9)
            assert qrot.shape == (B, self.H, T, self.HC)

        # GQA
        if self.H != self.KVH:
            krot    = self.repeat_kv(krot,      self.H // self.KVH)
            v_trunc = self.repeat_kv(v_trunc,   self.H // self.KVH)
        
        # quantize q, k
        q_q, q_s = a_quantizer(qrot, fused=False)
        k_q, k_s = a_quantizer(krot, fused=False)
        # calculate attention scores
        r        = shift_qk_matmul(q_q, q_s, k_q, k_s, B, self.H, T, S, self.HC, self.GA) >> self.Trunc_r

        r_softmax = self.softmax(r, mask)
        
        # fp version
        # r         = r.float() / 2.0**self.O_r / self.HC**0.5
        # if mask is not None:
        #     r = r + mask
        # r_softmax = F.softmax(r, dim=-1)
        # r_softmax = r_softmax * 2.0**self.O_softmax
        # r_softmax = r_softmax.round().to(torch.int64)

        r_q, r_s    = r_quantizer(r_softmax,                                fused=False)
        vt_q, vt_s  = r_quantizer(v_trunc.transpose(-1, -2).contiguous(),   fused=False)
        # calculate attention
        a           = shift_rv_matmul(r_q, r_s, vt_q, vt_s, B, self.H, T, S, self.HC, self.GR) >> self.Trunc_a
        a           = a.transpose(1, 2).contiguous()
        a_q, a_s    = a_quantizer(a, fused=False)
        # output projection
        o = shift_matmul(a_q, a_s, self.wo_q, self.wo_s1, self.wo_s2, self.C, self.C, self.GA, self.GW) >> self.Trunc_o
        # residual
        output = residual + o
        
        return output, kv_cache
        

class IntQwenMLP(nn.Module):
    def __init__(self, config, O_res, fp_decoder):
        super().__init__()
        self.config     = config
        self.C          = config.hidden_size
        self.CM         = config.intermediate_size
        self.GA         = A_QUANT_PARAMS["group_size"]
        self.GW         = W_QUANT_PARAMS["group_size"]
        self.O_res      = O_res
        self.O_w        = 11
        # rmsnorm
        self.rmsnorm    = IntRMSNorm(self.C, config.rms_norm_eps, self.O_res, fp_decoder.post_attention_layernorm.weight)
        self.O_in       = self.rmsnorm.O_out
        # silu, doesn't change scale
        self.O_silu     = self.O_w + self.O_in
        # elementwise mul
        self.Trunc_mul  = 28
        self.O_mul      = 2*self.O_silu - self.Trunc_mul
        # distribute trunc mul to xu and xg
        self.Trunc_ug   = 8
        self.Trunc_mul  -= self.Trunc_ug * 2
        self.O_silu     -= self.Trunc_ug
        self.Trunc_d    = self.O_mul + self.O_w - self.O_res
        # mlp
        wu         = fp_decoder.mlp.up_proj  .weight * 2**self.O_w
        wg         = fp_decoder.mlp.gate_proj.weight * 2**self.O_w
        wd         = fp_decoder.mlp.down_proj.weight * 2**self.O_w
        # silu
        self.silu       = IntSiLU(self.O_silu)
        # quantize
        wu_q, wu_s1, wu_s2 = w_quantizer(wu, fused=False, W_SCALE_BITS=3)
        wg_q, wg_s1, wg_s2 = w_quantizer(wg, fused=False, W_SCALE_BITS=3)
        wd_q, wd_s1, wd_s2 = w_quantizer(wd, fused=False, W_SCALE_BITS=3)
        # register buffers
        self.register_buffer("wu_q",    wu_q)
        self.register_buffer("wu_s1",   wu_s1)
        self.register_buffer("wu_s2",   wu_s2)
        self.register_buffer("wg_q",    wg_q)
        self.register_buffer("wg_s1",   wg_s1)
        self.register_buffer("wg_s2",   wg_s2)
        self.register_buffer("wd_q",    wd_q)
        self.register_buffer("wd_s1",   wd_s1)
        self.register_buffer("wd_s2",   wd_s2)

    def forward(self, x):
        residual    = x
        # rmsnorm
        xln           = self.rmsnorm(x)
        # mlp quantized
        xlnq, xlns    = a_quantizer(xln, fused=False)
        # up and proj
        xu = shift_matmul(xlnq, xlns, self.wu_q, self.wu_s1, self.wu_s2, self.C, self.CM, self.GA, self.GW)
        xg = shift_matmul(xlnq, xlns, self.wg_q, self.wg_s1, self.wg_s2, self.C, self.CM, self.GA, self.GW)
        # restore float
        xu = xu >> self.Trunc_ug
        xg = xg >> self.Trunc_ug
        # silu
        xg = self.silu(xg)
        # elementwise mul
        xm = (xg * xu) >> self.Trunc_mul
        xm_q, xm_s = a_quantizer(xm, fused=False)
        # down and proj
        xd = shift_matmul(xm_q, xm_s, self.wd_q, self.wd_s1, self.wd_s2, self.CM, self.C, self.GA, self.GW) >> self.Trunc_d

        # residual
        output      = residual + xd
        
        return output
    
    
class IntQwenHead(nn.Module):
    def __init__(self, config, fp_head, O_in):
        super().__init__()
        self.config     = config
        self.C          = config.hidden_size
        self.VOCAB      = config.vocab_size
        self.GA         = A_QUANT_PARAMS["group_size"]
        self.GW         = W_QUANT_PARAMS["group_size"]
        self.O_w        = 9
        self.O_in       = O_in
        self.Trunc_cls  = self.O_w
        self.O_out      = self.O_in + self.O_w - self.Trunc_cls
        # apply fused quantization on weights
        w_q, w_s1, w_s2 = w_quantizer(fp_head.weight   * 2**self.O_w,    fused=False)
        self.register_buffer("w_q",    w_q)
        self.register_buffer("w_s1",   w_s1)
        self.register_buffer("w_s2",   w_s2)

    def forward(self, x):
        x_shape     = x.shape
        y_shape     = x_shape[:-1] + (self.VOCAB,)

        x_q, x_s    = a_quantizer(x, fused=False)
        # proj
        y           = shift_matmul(x_q, x_s, self.w_q, self.w_s1, self.w_s2, self.C, self.VOCAB, self.GA, self.GW)
        # truncate
        y           = y >> self.Trunc_cls
        # restore float
        y           = y.float() * 2.0**-self.O_out

        return y.reshape(y_shape)


class IntDecoderLayer(nn.Module):
    def __init__(self, config: Qwen2Config, fp_decoder, O_res, is_begin=False, is_close=False):
        super().__init__()
        
        self.config = config
        self.O_res = O_res
        self.is_begin = is_begin
        self.is_close = is_close
        
        # components
        self.MHA = IntQwenMHA(config, O_res, fp_decoder)
        self.MLP = IntQwenMLP(config, O_res, fp_decoder)
        
        # self.rotary_emb = fp_decoder.rotary_emb

    # should be compatible with original decodef
    def forward(
        self,
        hidden_states: torch.Tensor,
        attention_mask: Optional[torch.Tensor] = None,
        position_ids: Optional[torch.LongTensor] = None,
        past_key_value: Optional[Tuple[torch.Tensor]] = None,
        output_attentions: Optional[bool] = False,
        use_cache: Optional[bool] = False,
        cache_position: Optional[torch.LongTensor] = None,
        position_embeddings: Optional[Tuple[torch.Tensor, torch.Tensor]] = None,
        **kwargs,
    ) -> Tuple[torch.FloatTensor, Optional[Tuple[torch.FloatTensor, torch.FloatTensor]]]:

        x = hidden_states

        if self.is_begin:
            x = x * 2**self.O_res
            x = x.round().to(torch.int64)

        # Self Attention
        x, present_key_value = self.MHA(
            x,
            position_embeddings,
            attention_mask,
            position_ids,
            past_key_value,
            cache_position,
        )

        # Fully Connected
        x = self.MLP(x)

        return x, present_key_value

DECODER_O_RES = 12

def replace_decoders(qwen_for_causal, device):
    # replace all decoders with int decoders
    qwen_model = qwen_for_causal.model
    qwen_config = qwen_model.config
    
    HC = qwen_config.hidden_size // qwen_config.num_attention_heads
    
    # replace rope embedding
    qwen_model.rotary_emb     = IntRotaryEmbedding(HC, base=qwen_config.rope_theta, device=next(qwen_model.layers[0].parameters()).device)
    
    with torch.no_grad():
        for idx, fp_decoder in tqdm.tqdm(enumerate(qwen_model.layers)):
            is_begin = idx == 0
            is_close = idx == len(qwen_model.layers) - 1
            qwen_model.layers[idx] = IntDecoderLayer(qwen_config, fp_decoder, DECODER_O_RES, is_begin, is_close).to(device)


def replace_norm(qwen_for_causal, device):
    # replace all norms with int norms
    qwen_model = qwen_for_causal.model
    qwen_config = qwen_model.config
    
    with torch.no_grad():
        fp_norm = qwen_model.norm
        qwen_model.norm = IntRMSNorm(qwen_config.hidden_size, qwen_config.rms_norm_eps, O_in=DECODER_O_RES, lnw=fp_norm.weight).to(device)
        del fp_norm
        
            
def replace_lm_head(qwen_for_causal, device):
    # replace lm head with int lm head
    qwen_config = qwen_for_causal.config
    
    with torch.no_grad():
        fp_lm_head = qwen_for_causal.lm_head
        O_in = qwen_for_causal.model.norm.O_out
        qwen_for_causal.lm_head = IntQwenHead(qwen_config, fp_lm_head, O_in=O_in).to(device)
        del fp_lm_head