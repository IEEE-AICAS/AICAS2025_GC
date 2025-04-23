import torch
import torch.nn as nn
import torch.nn.functional as F

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

class QuantLinear(nn.Module):
    def __init__(
        self,
        in_features,
        out_features,
        bias=True,
        weight_bits=8,
        act_bits=8,
        act_quant="per_token",
        dtype=None,
    ):
        super().__init__()
        self.in_features = in_features
        self.out_features = out_features
        self.weight_bits = weight_bits
        self.act_bits = act_bits
        
        # 计算量化范围
        self.weight_qmax = 2 ** (weight_bits - 1) - 1
        self.act_qmax = 2 ** (act_bits - 1) - 1
        
        # 注册权重和scale
        self.register_buffer(
            "weight",
            torch.empty(
                self.out_features,
                self.in_features,
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

    @torch.no_grad()
    def forward(self, x):
        # 保存原始数据类型
        orig_dtype = x.dtype
        # 量化激活
        x_q, act_scale = self.act_quant(x)
        # 整数矩阵乘法
        y_q = F.linear(x_q.to(torch.float32), self.weight.to(torch.float32))
        # 反量化并恢复原始数据类型
        weight_scale=self.weight_scale.transpose(0,1)
        y = (y_q * (act_scale * weight_scale)).to(orig_dtype)
        # 添加bias (如果存在)
        if self.bias is not None:
            y = y + self.bias.view(1, -1)
        
        return y

    @classmethod
    def from_float(
        cls, 
        module, 
        weight_bits=8,
        act_bits=8,
        weight_quant="per_channel", 
        act_quant="per_token",
    ):
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
            
        # 将量化后的权重转换为int8存储
        new_module.weight.copy_(w_q.to(torch.int8))
        new_module.weight_scale.copy_(scale.to(dtype))
        new_module.weight_quant_name = weight_quant
        
        # 复制bias (如果存在)
        if module.bias is not None:
            new_module.bias.copy_(module.bias)
            
        return new_module

    def __repr__(self):
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