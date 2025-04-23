import torch
from torch import nn
from tqdm import tqdm

class Quantizer(nn.Module):
    
    call_times = 0
    
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

class QuantLinear(nn.Module):
    def __init__(
        self,
        i_features,
        o_features,

        w_bits              =8,
        w_granularity       ="per_channel",
        w_group_size        =None,
        w_pot_scale         =False,
        w_apot_scale        =False,

        a_bits              =8,
        a_granularity       ="per_token",
        a_group_size        =None,
        a_pot_scale         =False,
        a_apot_scale        =False,

        quantize_output     =False,
        fused               =False
    ):
        super().__init__()
        self.i_features     = i_features
        self.o_features     = o_features
        
        self.w_bits         = w_bits
        self.w_granularity  = w_granularity
        self.w_group_size   = w_group_size
        self.w_pot_scale    = w_pot_scale
        self.w_apot_scale   = w_apot_scale
        
        self.a_bits         = a_bits
        self.a_granularity  = a_granularity
        self.a_group_size   = a_group_size
        self.a_pot_scale    = a_pot_scale
        self.a_apot_scale   = a_apot_scale
        
        self.quantize_output= quantize_output
        self.fused          = fused
        
        # non fused
        if not fused:
            self.register_buffer("w_q", None)
            self.register_buffer("w_scale", None)
            self.register_buffer("w_s", None)
            self.register_buffer("w_s1", None)
            self.register_buffer("w_s2", None)
        else:
            # fused weight for faster inference
            self.register_buffer("w", None)

        assert a_granularity in ("per_token", "per_tensor", "per_group")
        assert w_granularity in ("per_token", "per_tensor", "per_group")

        self.a_granulairty = a_granularity
        self.w_granularity = w_granularity
        self.a_quant= Quantizer(n_bits=a_bits, granularity=a_granularity, group_size=a_group_size, is_weight=False, pot_scale=a_pot_scale, apot_scale=a_apot_scale)
        self.w_quant= Quantizer(n_bits=w_bits, granularity=w_granularity, group_size=w_group_size, is_weight=True,  pot_scale=w_pot_scale, apot_scale=w_apot_scale)
        self.o_quant= Quantizer(n_bits=a_bits, granularity=a_granularity, group_size=a_group_size, is_weight=False, pot_scale=a_pot_scale, apot_scale=a_apot_scale) if quantize_output else None

    def to(self, *args, **kwargs):
        super(QuantLinear, self).to(*args, **kwargs)
        # put all buffers to device
        for name, buffer in self.named_buffers():
            buffer.to(*args, **kwargs)
        return self


    @torch.no_grad()
    def forward(self, x):
        x_shape = x.shape
        *_, CI = x.shape

        assert self.w_group_size == self.a_group_size
        G = self.w_group_size
        NG = CI // G

        if not self.fused:
            # inference in integer domain
            x_q, x_scale, x_s, x_s1, x_s2 = self.a_quant(x, fused=False)
            w_q, w_scale, w_s, w_s1, w_s2 = self.w_q, self.w_scale, self.w_s, self.w_s1, self.w_s2
            
            CO = w_q.numel() // CI

            # check the shape, should be [num_groups, self.group_size], scale should be [num_groups, 1]
            assert len(x_q.shape) == 2 and x_q.shape[1] == self.a_group_size
            assert len(w_q.shape) == 2 and w_q.shape[1] == self.w_group_size

            assert len(x_scale.shape) == 2 and x_scale.shape[1] == 1
            assert len(w_scale.shape) == 2 and w_scale.shape[1] == 1
            
            # align shape
            x_q = x_q.view(-1, NG, G)
            w_q = w_q.view(CO, NG, G)

            
            # # impl 1
            # # do grouped matmul
            # # (B, NG, G) x (CO, NG, G) -> (B, CO, NG)
            # y_q = torch.einsum('ikl,jkl->ijk', x_q, w_q)
            
            # # apply scale
            # x_scale = x_scale.view(-1, 1, NG)
            # w_scale = w_scale.view(1, -1, NG)
            # y_q = y_q.mul(x_scale).mul(w_scale)
            # # reduce NG dim
            # y_q = y_q.sum(dim=-1)
            
            # impl 2
            x_scale = x_scale.view(-1, NG, 1)
            w_scale = w_scale.view(-1, NG, 1)
            x_q = x_q * x_scale
            w_q = w_q * w_scale
            x_q = x_q.view(-1, CI)
            w_q = w_q.view(CO, CI)
            y_q = torch.nn.functional.linear(x_q, w_q)
        else:
            # inference in float domain, with fused
            x_hat = self.a_quant(x, fused=True)
            w_hat = self.w
            CO = w_hat.shape[0]

            y_q = torch.nn.functional.linear(x_hat, w_hat)
        
        if self.o_quant is not None:
            y_q = self.o_quant(y_q, fused=True)
            
        # reshape
        y_q = y_q.view(*x_shape[:-1], CO)
        
        return y_q

    def __repr__(self):
        return f"W{self.w_bits}A{self.a_bits}Linear({self.i_features}, {self.o_features}, w_granularity={self.w_granularity}, a_granularity={self.a_granulairty})"

    @staticmethod
    def from_float(
        module, 

        w_bits          = 8,
        w_granularity   = "per_channel",
        w_group_size    = None,
        w_pot_scale     = False,
        w_apot_scale    = False,
        
        a_bits          = 8,
        a_granularity   = "per_token",
        a_group_size    = None,
        a_pot_scale     = False,
        a_apot_scale    = False,
        
        quantize_output =False,
        fused           =False
    ):
        assert isinstance(module, torch.nn.Linear), f"module must be a torch.nn.Linear, got {type(module)}"

        # get rank
        if torch.distributed.is_initialized():
            rank = torch.distributed.get_rank()
            device = f"cuda:{rank}"
        else:
            device = module.weight.device

        new_module = QuantLinear(
            module.in_features,
            module.out_features,
            
            w_bits          = w_bits,
            w_granularity   = w_granularity,
            w_group_size    = w_group_size,
            w_pot_scale     = w_pot_scale,
            w_apot_scale    = w_apot_scale,
            
            a_bits          = a_bits,
            a_granularity   = a_granularity,
            a_group_size    = a_group_size,
            a_pot_scale     = a_pot_scale,
            a_apot_scale    = a_apot_scale,
            
            quantize_output = quantize_output,
            fused           = fused
        )
        
        # get quantized weight
        if fused:
            w = new_module.w_quant(module.weight, fused=True)
            # assign attributes
            new_module.w = w
        else:
            w_q, w_scale, w_s, w_s1, w_s2 = new_module.w_quant(module.weight, fused=False)
            # assign attributes
            new_module.w_q      = w_q
            new_module.w_scale  = w_scale
            new_module.w_s      = w_s
            new_module.w_s1     = w_s1
            new_module.w_s2     = w_s2
        
        new_module.to(device)

        return new_module
    

def quantize_llama_like(
    model, 

    w_bits=8,
    w_granularity="per_channel",
    w_group_size=None,
    w_pot_scale=False,
    w_apot_scale=False,
    
    a_bits=8,
    a_granularity="per_token",
    a_group_size=None,
    a_pot_scale=False,
    a_apot_scale=False,
):
    with torch.no_grad():

        mlp_hot = False
        attn_hot = False

        for name, m in tqdm(model.named_modules()):
            
            shared_kwargs = {
                "w_bits": w_bits,
                "w_granularity": w_granularity,
                "w_group_size": w_group_size,
                "w_pot_scale": w_pot_scale,
                "w_apot_scale": w_apot_scale,
                
                "a_bits": a_bits,
                "a_granularity": a_granularity,
                "a_group_size": a_group_size,
                "a_pot_scale": a_pot_scale,
                "a_apot_scale": a_apot_scale,
            }
            
            bmm_kwargs  = { **shared_kwargs, "quantize_output": True}
            proj_kwargs = { **shared_kwargs, "quantize_output": False}
            
            # if isinstance(m, IntLlamaMLP):
            if "QuantLlamaMLP" in str(type(m)):
                if not mlp_hot:
                    print(f"Quantizing MLP: {name}")
                    mlp_hot = True
                m.gate_proj = QuantLinear.from_float(m.gate_proj,   **proj_kwargs)
                m.up_proj   = QuantLinear.from_float(m.up_proj,     **proj_kwargs)
                m.down_proj = QuantLinear.from_float(m.down_proj,   **proj_kwargs)
            # elif isinstance(m, IntLlamaSdpaAttention):
            elif "QuantLlamaMHA" in str(type(m)):
                if not attn_hot:
                    print(f"Quantizing Attention: {name}")
                    attn_hot = True
                m.q_proj    = QuantLinear.from_float(m.q_proj, **bmm_kwargs)
                m.k_proj    = QuantLinear.from_float(m.k_proj, **bmm_kwargs)
                m.v_proj    = QuantLinear.from_float(m.v_proj, **bmm_kwargs)
                m.o_proj    = QuantLinear.from_float(m.o_proj, **proj_kwargs)

    return model