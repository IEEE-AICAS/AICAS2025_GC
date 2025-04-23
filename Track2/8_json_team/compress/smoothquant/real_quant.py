import torch
import torch.nn as nn
import torch.nn.functional as F
from tqdm import tqdm
import functools
from functools import partial
from datasets import load_dataset
from smoothquant.bmm import symmetric_quantize_per_channel,symmetric_quantize_per_token,StaticQuantizedBMM1,StaticQuantizedBMM2

def quantize_activation_per_token(x, qmax):
    """Per-token quantization for activations"""
    orig_dtype = x.dtype
    x = x.float()
    # 计算每个token的scale
    scale = (x.abs().max(dim=-1, keepdim=True)[0] / qmax)
    # 量化，转换为int8
    x_q = torch.clamp(torch.round(x / scale), -qmax, qmax).to(torch.int8)
    return x_q, scale.to(orig_dtype)

def quantize_activation_per_tensor(x, qmax):
    """Per-tensor quantization for activations"""
    orig_dtype = x.dtype
    x = x.float()
    # 计算整个tensor的scale
    scale = (x.abs().max() / qmax)
    # 量化，转换为int8
    x_q = torch.clamp(torch.round(x / scale), -qmax, qmax).to(torch.int8)
    return x_q, scale.to(orig_dtype).view(1, 1)

def quantize_weight_per_channel(w, qmax):
    """Per-channel quantization for weights"""
    w = w.float()
    # 计算每个输出通道的scale
    scale = (w.abs().max(dim=1, keepdim=True)[0] / qmax)
    # 量化，转换为int8
    w_q = torch.clamp(torch.round(w / scale), -qmax, qmax).to(torch.int8)
    return w_q, scale

def quantize_weight_per_tensor(w, qmax):
    """Per-tensor quantization for weights"""
    w = w.float()
    # 计算整个tensor的scale
    scale = (w.abs().max() / qmax)
    # 量化，转换为int8
    w_q = torch.clamp(torch.round(w / scale), -qmax, qmax).to(torch.int8)
    return w_q, scale.view(-1, 1)

def pack_int4_in_int8(x: torch.Tensor) -> torch.Tensor:
    """
    Pack two int4 values into one int8.
    Input shape: (..., N)
    Output shape: (..., N//2) if N is even, (..., N//2 + 1) if N is odd
    """
    assert x.dtype == torch.int8
    # Ensure values are in int4 range (-8 to 7)
    assert torch.all((x >= -8) & (x <= 7)), "Values must be in int4 range (-8 to 7)"
    
    # Handle odd dimension by padding
    orig_shape = x.shape
    if x.shape[-1] % 2 != 0:
        x = torch.nn.functional.pad(x, (0, 1), value=0)
    
    x = x.view(*x.shape[:-1], -1, 2)
    # Pack two int4 values into one int8
    # First value uses lower 4 bits, second value uses upper 4 bits
    packed = (x[..., 0] & 0xF) | ((x[..., 1] & 0xF) << 4)
    return packed.view(*orig_shape[:-1], -1)

def unpack_int8_to_int4(x: torch.Tensor) -> torch.Tensor:
    """
    Unpack one int8 into two int4 values.
    Input shape: (..., N)
    Output shape: (..., N*2)
    """
    # Extract lower 4 bits and upper 4 bits
    lower = (x & 0xF).view(*x.shape[:-1], -1, 1)
    upper = ((x >> 4) & 0xF).view(*x.shape[:-1], -1, 1)
    
    # Convert to signed int4 (-8 to 7)
    lower = lower - ((lower & 0x8) << 1)
    upper = upper - ((upper & 0x8) << 1)
    
    # Combine and reshape
    unpacked = torch.cat([lower, upper], dim=-1)
    return unpacked.reshape(*x.shape[:-1], -1)

class QuantLinear(nn.Module):
    def __init__(
        self,
        in_features: int,
        out_features: int,
        bias: bool = True,
        weight_bits: int = 8,
        act_bits: int = 8,
        act_quant: str = "per_token",
        dtype: torch.dtype = None,
    ):
        super().__init__()
        self.in_features = in_features
        self.out_features = out_features
        self.weight_bits = weight_bits
        self.act_bits = act_bits
        
        # 计算量化范围
        self.weight_qmax = 2 ** (weight_bits - 1) - 1
        self.act_qmax = 2 ** (act_bits - 1) - 1
        
        # 计算压缩后的输入特征数
        packed_in_features = (in_features + 1) // 2 if weight_bits == 4 else in_features
        
        # 注册权重和scale
        self.register_buffer(
            "weight",
            torch.empty(
                self.out_features,
                packed_in_features,
                dtype=torch.int8,
                requires_grad=False,
            ),
        )
        self.register_buffer(
            "weight_scale",
            torch.empty(
                self.out_features,
                1,
                dtype=dtype or torch.float32,
                requires_grad=False,
            ),
        )
        
        if bias:
            self.register_buffer(
                "bias",
                torch.zeros(
                    self.out_features,
                    dtype=dtype or torch.float32,
                    requires_grad=False
                ),
            )
        else:
            self.register_buffer("bias", None)

        # 设置激活量化方法
        self.act_quant_name = act_quant
        if act_quant == "per_token":
            self.act_quant = lambda x: quantize_activation_per_token(x, self.act_qmax)
        elif act_quant == "per_tensor":
            self.act_quant = lambda x: quantize_activation_per_tensor(x, self.act_qmax)
        else:
            raise ValueError(f"Invalid act_quant: {act_quant}")
            
        self.dtype = dtype
        self.weight_quant_name = None  # 将在from_float中设置

    @torch.no_grad()
    def forward(self, x: torch.Tensor) -> torch.Tensor:
        # 保存原始数据类型
        orig_dtype = x.dtype
        # 量化激活
        x_q, act_scale = self.act_quant(x)
        # 如果是4bit权重，需要解包
        if self.weight_bits == 4:
            weight = unpack_int8_to_int4(self.weight)
            # 如果有padding，裁剪到原始大小
            weight = weight[..., :self.in_features]
        else:
            weight = self.weight
        # 整数矩阵乘法
        y_q = F.linear(x_q.to(torch.float32), weight.to(torch.float32))
        
        # 反量化并恢复原始数据类型
        weight_scale = self.weight_scale.transpose(0, 1)
        y = (y_q * (act_scale * weight_scale)).to(orig_dtype)
        
        # 添加bias (如果存在)
        if self.bias is not None:
            y = y + self.bias.view(1, -1)
        
        return y

    @classmethod
    def from_float(
        cls, 
        module: nn.Linear,
        weight_bits: int = 8,
        act_bits: int = 8,
        weight_quant: str = "per_channel",
        act_quant: str = "per_token",
    ) -> 'QuantLinear':
        assert isinstance(module, torch.nn.Linear)
        
        # 创建新模块
        dtype = module.weight.dtype
        new_module = cls(
            module.in_features,
            module.out_features,
            module.bias is not None,
            weight_bits=weight_bits,
            act_bits=act_bits,
            act_quant=act_quant,
            dtype=dtype,
        )
        
        # 计算量化范围
        qmax = 2 ** (weight_bits - 1) - 1
        
        # 量化权重
        if weight_quant == "per_channel":
            w_q, scale = quantize_weight_per_channel(module.weight, qmax)
        elif weight_quant == "per_tensor":
            w_q, scale = quantize_weight_per_tensor(module.weight, qmax)
        else:
            raise ValueError(f"Invalid weight_quant: {weight_quant}")
        
        # 如果是4bit权重，进行打包
        if weight_bits == 4:
            w_q = pack_int4_in_int8(w_q)
            
        # 将量化后的权重转换为int8存储
        new_module.weight.copy_(w_q.to(torch.int8))
        new_module.weight_scale.copy_(scale.to(dtype))
        new_module.weight_quant_name = weight_quant
        
        # 复制bias (如果存在)
        if module.bias is not None:
            new_module.bias.copy_(module.bias)
            
        return new_module

    def __repr__(self) -> str:
        return (f"QuantLinear(in_features={self.in_features}, "
                f"out_features={self.out_features}, "
                f"bias={self.bias is not None}, "
                f"weight_bits={self.weight_bits}, "
                f"act_bits={self.act_bits}, "
                f"weight_quant={self.weight_quant_name}, "
                f"act_quant={self.act_quant_name}, "
                f"dtype={self.dtype})")

def quantize_qwen2(
    model,weight_quant="per_channel", act_quant="per_token",weight_bits=8,act_bits=8
):
    from transformers.models.qwen2.modeling_qwen2 import(
        Qwen2Attention,
        Qwen2MLP
    )
    for name, m in model.model.named_modules():
        if isinstance(m, Qwen2MLP):
            m.gate_proj = QuantLinear.from_float(
                m.gate_proj, weight_quant=weight_quant, act_quant=act_quant,weight_bits=weight_bits,act_bits=act_bits
            )
            m.up_proj = QuantLinear.from_float(
                m.up_proj, weight_quant=weight_quant, act_quant=act_quant,weight_bits=weight_bits,act_bits=act_bits
            )
            m.down_proj = QuantLinear.from_float(
                m.down_proj, weight_quant=weight_quant, act_quant=act_quant,weight_bits=weight_bits,act_bits=act_bits
            )
        elif isinstance(m, Qwen2Attention):
            # Her we simulate quantizing BMM inputs by quantizing the output of q_proj, k_proj, v_proj
            m.q_proj = QuantLinear.from_float(
                m.q_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                weight_bits=weight_bits,
                act_bits=act_bits
            )
            m.k_proj = QuantLinear.from_float(
                m.k_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                weight_bits=weight_bits,
                act_bits=act_bits
            )
            m.v_proj = QuantLinear.from_float(
                m.v_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                weight_bits=weight_bits,
                act_bits=act_bits
            )
            m.o_proj = QuantLinear.from_float(
                m.o_proj, weight_quant=weight_quant, act_quant=act_quant,weight_bits=weight_bits,act_bits=act_bits
            )
    return model

def get_act_scales_per_token(model, tokenizer, dataset, seq_len=192):
    from transformers.models.qwen2.modeling_qwen2 import(
        Qwen2Attention,
        Qwen2MLP
    )
    model.eval()
    device="cuda:0"
    model.to(device)
    act_scales = {}

    def stat_tensor(name, tensor):
        _, act_scale = quantize_activation_per_token(tensor,127)
        act_scale=act_scale.abs().detach()
        if name in act_scales:
            act_scales[name] = torch.max(act_scales[name], act_scale)
        else:
            act_scales[name] = act_scale
    def stat_input_hook(m, x, y, name):
        if isinstance(x, tuple):
            x = x[0]
        stat_tensor(name, x)
    def get_scale_bmm1(score, value, num_bits=8,name='default'):
        """
        对称量化的矩阵乘法函数
        score: [batch, heads, seq_len, seq_len]
        value: [batch, heads, seq_len, dim]
        """
        _, score_scale = symmetric_quantize_per_token(score, num_bits)
        _, value_scale = symmetric_quantize_per_channel(value, num_bits)


        output = torch.matmul(score, value)

        if name+".query" in act_scales:
            act_scales[name+".query"] = torch.max(act_scales[name+".query"], score_scale)
        else:
            act_scales[name+".query"] = score_scale

        if name+".key" in act_scales:
            act_scales[name+".key"] = torch.max(act_scales[name+".key"], value_scale)
        else:
            act_scales[name+".key"] = value_scale    
        return output  
    def get_scale_bmm2(score, value, num_bits=8,name='default'):
        """
        对称量化的矩阵乘法函数
        score: [batch, heads, seq_len, seq_len]
        value: [batch, heads, seq_len, dim]
        """
        _, score_scale = symmetric_quantize_per_token(score, num_bits)
        _, value_scale = symmetric_quantize_per_channel(value, num_bits)


        output = torch.matmul(score, value)

        if name+".score" in act_scales:
            act_scales[name+".score"] = torch.max(act_scales[name+".score"], score_scale)
        else:
            act_scales[name+".score"] = score_scale

        if name+".value" in act_scales:
            act_scales[name+".value"] = torch.max(act_scales[name+".value"], value_scale)
        else:
            act_scales[name+".value"] = value_scale    
        return output    

    hooks = []
    for name, m in model.named_modules():
        if isinstance(m, nn.Linear):
            hooks.append(
                m.register_forward_hook(functools.partial(stat_input_hook, name=name))
            )
        if isinstance(m,Qwen2Attention):
            m.bmm1=functools.partial(get_scale_bmm1,name=name)
            m.bmm2=functools.partial(get_scale_bmm2,name=name)

    dataset = dataset.shuffle(seed=42)

    for i in tqdm(range(len(dataset))):
        sentence1=dataset[i]["sentence1"]
        sentence2=dataset[i]["sentence2"]
        text=f"Sentence 1: {sentence1} Sentence 2: {sentence2} Is the second sentence entailed by the first? (1 for yes, 0 for no) you can only output 1 or 0"
        # text=dataset[i]["sentence1"]+dataset[i]["sentence2"]
        inputs = tokenizer(text, return_tensors="pt", padding="max_length", truncation=True, max_length=seq_len).to(device)
        model(**inputs)

    for h in hooks:
        h.remove()
    return act_scales

class StaticQuantLinear(nn.Module):
    def __init__(
        self,
        in_features: int,
        out_features: int,
        act_scale: torch.Tensor,  # 新增: 1x192x1的静态act_scale
        bias: bool = True,
        weight_bits: int = 8,
        act_bits: int = 8,
        dtype: torch.dtype = None,
    ):
        super().__init__()
        self.in_features = in_features
        self.out_features = out_features
        self.weight_bits = weight_bits
        self.act_bits = act_bits
        
        # 计算量化范围
        self.weight_qmax = 2 ** (weight_bits - 1) - 1
        self.act_qmax = 2 ** (act_bits - 1) - 1
        
        # 计算压缩后的输入特征数
        packed_in_features = (in_features + 1) // 2 if weight_bits == 4 else in_features
        
        # 注册权重和scale
        self.register_buffer(
            "weight",
            torch.empty(
                self.out_features,
                packed_in_features,
                dtype=torch.int8,
                requires_grad=False,
            ),
        )
        self.register_buffer(
            "weight_scale",
            torch.empty(
                self.out_features,
                1,
                dtype=dtype or torch.float32,
                requires_grad=False,
            ),
        )
        
        # 注册静态act_scale
        self.register_buffer(
            "act_scale",
            act_scale.to(dtype=dtype or torch.float32),
        )
        
        if bias:
            self.register_buffer(
                "bias",
                torch.zeros(
                    self.out_features,
                    dtype=dtype or torch.float32,
                    requires_grad=False
                ),
            )
        else:
            self.register_buffer("bias", None)

        self.dtype = dtype
        self.weight_quant_name = None  # 将在from_float中设置

    def quantize_input(self, x: torch.Tensor) -> torch.Tensor:
        """静态量化输入"""
        orig_dtype = x.dtype
        x = x.float()
        # 量化，转换为int8
        x_scaled = x / self.act_scale
        x_q = torch.clamp(torch.round(x_scaled), -self.act_qmax, self.act_qmax).to(torch.int8)
        return x_q

    @torch.no_grad()
    def forward(self, x: torch.Tensor) -> torch.Tensor:
        # 保存原始数据类型
        orig_dtype = x.dtype
        
        # 静态量化激活
        x_q = self.quantize_input(x)
        
        # 如果是4bit权重，需要解包
        if self.weight_bits == 4:
            weight = unpack_int8_to_int4(self.weight)
            # 如果有padding，裁剪到原始大小
            weight = weight[..., :self.in_features]
        else:
            weight = self.weight
            
        # 整数矩阵乘法
        y_q = F.linear(x_q.to(torch.float32), weight.to(torch.float32))
        
        # 反量化并恢复原始数据类型
        weight_scale = self.weight_scale.transpose(0, 1)
        y = (y_q * (self.act_scale * weight_scale)).to(orig_dtype)
        
        # 添加bias (如果存在)
        if self.bias is not None:
            y = y + self.bias.view(1, -1)
        
        return y

    @classmethod
    def from_float(
        cls, 
        module: nn.Linear,
        act_scale: torch.Tensor,  # 新增：传入静态act_scale
        weight_bits: int = 8,
        act_bits: int = 8,
        weight_quant: str = "per_channel",
    ) -> 'StaticQuantLinear':
        assert isinstance(module, torch.nn.Linear)
        
        # 创建新模块
        dtype = module.weight.dtype
        new_module = cls(
            module.in_features,
            module.out_features,
            act_scale,  # 传入act_scale
            module.bias is not None,
            weight_bits=weight_bits,
            act_bits=act_bits,
            dtype=dtype,
        )
        
        # 计算量化范围
        qmax = 2 ** (weight_bits - 1) - 1
        
        # 量化权重
        if weight_quant == "per_channel":
            w_q, scale = quantize_weight_per_channel(module.weight, qmax)
        elif weight_quant == "per_tensor":
            w_q, scale = quantize_weight_per_tensor(module.weight, qmax)
        else:
            raise ValueError(f"Invalid weight_quant: {weight_quant}")
        
        # 如果是4bit权重，进行打包
        if weight_bits == 4:
            w_q = pack_int4_in_int8(w_q)
            
        # 将量化后的权重转换为int8存储
        new_module.weight.copy_(w_q.to(torch.int8))
        new_module.weight_scale.copy_(scale.to(dtype))
        new_module.weight_quant_name = weight_quant
        
        # 复制bias (如果存在)
        if module.bias is not None:
            new_module.bias.copy_(module.bias)
            
        return new_module

    def __repr__(self) -> str:
        return (f"StaticQuantLinear(in_features={self.in_features}, "
                f"out_features={self.out_features}, "
                f"bias={self.bias is not None}, "
                f"weight_bits={self.weight_bits}, "
                f"act_bits={self.act_bits}, "
                f"weight_quant={self.weight_quant_name}, "
                f"dtype={self.dtype})")
        
def quantize_qwen2_static(
    model,act_scales,weight_quant="per_channel", weight_bits=8,act_bits=8
):
    from transformers.models.qwen2.modeling_qwen2 import(
        Qwen2Attention,
        Qwen2MLP
    )
    for name, m in model.named_modules():
        if isinstance(m, Qwen2MLP):
            m.gate_proj = StaticQuantLinear.from_float(
                m.gate_proj,act_scale=act_scales[name+".gate_proj"],weight_quant=weight_quant, weight_bits=weight_bits,act_bits=act_bits
            )
            m.up_proj = StaticQuantLinear.from_float(
                m.up_proj, act_scale=act_scales[name+".up_proj"],weight_quant=weight_quant, weight_bits=weight_bits,act_bits=act_bits
            )
            m.down_proj = StaticQuantLinear.from_float(
                m.down_proj,act_scale=act_scales[name+".down_proj"], weight_quant=weight_quant, weight_bits=weight_bits,act_bits=act_bits
            )
        elif isinstance(m, Qwen2Attention):
            # Her we simulate quantizing BMM inputs by quantizing the output of q_proj, k_proj, v_proj
            m.q_proj = StaticQuantLinear.from_float(
                m.q_proj,
                act_scale=act_scales[name+".q_proj"],
                weight_quant=weight_quant,
                
                weight_bits=weight_bits,
                act_bits=act_bits
            )
            m.k_proj = StaticQuantLinear.from_float(
                m.k_proj,
                act_scale=act_scales[name+".k_proj"],
                weight_quant=weight_quant,
                
                weight_bits=weight_bits,
                act_bits=act_bits
            )
            m.v_proj = StaticQuantLinear.from_float(
                m.v_proj,
                act_scale=act_scales[name+".v_proj"],
                weight_quant=weight_quant,
                
                weight_bits=weight_bits,
                act_bits=act_bits
            )
            m.o_proj = StaticQuantLinear.from_float(
                m.o_proj,act_scale=act_scales[name+".o_proj"], weight_quant=weight_quant, weight_bits=weight_bits,act_bits=act_bits
            )
            m.bmm1 = StaticQuantizedBMM1(query_scale=act_scales[name+".query"],key_scale=act_scales[name+".key"])
            m.bmm2 = StaticQuantizedBMM2(score_scale=act_scales[name+".score"],value_scale=act_scales[name+".value"])
    return model