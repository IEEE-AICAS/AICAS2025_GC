import torch
from torch import nn
from functools import partial
from devkit.sparse_ops import Sparse
from typing import Optional
from smoothquant.bmm import symmetric_quantize_per_channel,symmetric_quantize_per_token,StaticQuantizedBMM1,StaticQuantizedBMM2

@torch.no_grad()
def quantize_weight_per_channel_absmax(w, n_bits=8):
    """Per-channel quantization for weights"""
    w = w.float()
    # 计算每个输出通道的scale
    qmax=2 ** (n_bits - 1) - 1
    scale = (w.abs().max(dim=1, keepdim=True)[0] / qmax)
    # 量化，转换为int8
    w_q = torch.clamp(torch.round(w / scale), -qmax, qmax)*scale
    return w_q


@torch.no_grad()
def quantize_weight_per_tensor_absmax(w, n_bits=8):
    # w: (out_features, in_features)
    scales = w.abs().max()
    q_max = 2 ** (n_bits - 1) - 1
    scales.clamp_(min=1e-5).div_(q_max)
    w.div_(scales).round_().mul_(scales)
    return w


@torch.no_grad()
def quantize_activation_per_token_absmax(t, n_bits=8):
    t_shape = t.shape
    t.view(-1, t_shape[-1])
    scales = t.abs().max(dim=-1, keepdim=True)[0]
    q_max = 2 ** (n_bits - 1) - 1
    scales.clamp_(min=1e-5).div_(q_max)
    t.div_(scales).round_().mul_(scales)
    return t


@torch.no_grad()
def quantize_activation_per_tensor_absmax(t, n_bits=8):
    t_shape = t.shape
    t.view(-1, t_shape[-1])
    scales = t.abs().max()
    q_max = 2 ** (n_bits - 1) - 1
    scales.clamp_(min=1e-5).div_(q_max)
    t.div_(scales).round_().mul_(scales)
    return t


class W8A8Linear(nn.Module):
    def __init__(
        self,
        in_features,
        out_features,
        bias=True,
        act_quant="per_token",
        quantize_output=False,
    ):
        super().__init__()
        self.in_features = in_features
        self.out_features = out_features

        self.register_buffer(
            "weight",
            torch.randn(
                self.out_features,
                self.in_features,
                dtype=torch.float16,
                requires_grad=False,
            ),
        )
        if bias:
            self.register_buffer(
                "bias",
                torch.zeros(
                    (1, self.out_features), dtype=torch.float16, requires_grad=False
                ),
            )
        else:
            self.register_buffer("bias", None)

        if act_quant == "per_token":
            self.act_quant_name = "per_token"
            self.act_quant = partial(quantize_activation_per_token_absmax, n_bits=8)
        elif act_quant == "per_tensor":
            self.act_quant_name = "per_tensor"
            self.act_quant = partial(quantize_activation_per_tensor_absmax, n_bits=8)
        else:
            raise ValueError(f"Invalid act_quant: {act_quant}")

        if quantize_output:
            self.output_quant_name = self.act_quant_name
            self.output_quant = self.act_quant
        else:
            self.output_quant_name = "None"
            self.output_quant = lambda x: x

    def to(self, *args, **kwargs):
        super(W8A8Linear, self).to(*args, **kwargs)
        self.weight = self.weight.to(*args, **kwargs)
        if self.bias is not None:
            self.bias = self.bias.to(*args, **kwargs)
        return self

    @torch.no_grad()
    def forward(self, x):
        q_x = self.act_quant(x)
        y = torch.functional.F.linear(q_x, self.weight, self.bias)
        q_y = self.output_quant(y)
        return q_y

    @staticmethod
    def from_float(
        module, weight_quant="per_channel", act_quant="per_token", quantize_output=False
    ):
        assert isinstance(module, torch.nn.Linear)
        new_module = W8A8Linear(
            module.in_features,
            module.out_features,
            module.bias is not None,
            act_quant=act_quant,
            quantize_output=quantize_output,
        )
        if weight_quant == "per_channel":
            new_module.weight = quantize_weight_per_channel_absmax(
                module.weight, n_bits=8
            )  # use 8-bit integer for weight
        elif weight_quant == "per_tensor":
            new_module.weight = quantize_weight_per_tensor_absmax(
                module.weight, n_bits=8
            )
        else:
            raise ValueError(f"Invalid weight_quant: {weight_quant}")
        new_module.weight_quant_name = weight_quant
        if module.bias is not None:
            new_module.bias = module.bias
        return new_module

    def __repr__(self):
        return f"W8A8Linear({self.in_features}, {self.out_features}, bias={self.bias is not None}, weight_quant={self.weight_quant_name}, act_quant={self.act_quant_name}, output_quant={self.output_quant_name})"

class SparseW8A8Linear(W8A8Linear):
    def __init__(
        self,
        in_features,
        out_features,
        bias=True,
        act_quant="per_token",
        quantize_output=False,
        N=2,
        M=4,
        decay=0.0002
    ):
        super().__init__(
            in_features,
            out_features,
            bias=bias,
            act_quant=act_quant,
            quantize_output=quantize_output
        )
        self.N = N
        self.M = M
        self.decay = decay

    def get_sparse_weights(self):
        return Sparse.apply(self.weight, self.N, self.M, self.decay)

    @torch.no_grad()
    def forward(self, x):
        # 量化输入
        q_x = self.act_quant(x)
        # 获取稀疏量化权重
        w = self.get_sparse_weights()
        # 线性计算
        # print(f"q_x:{q_x.dtype},w:{w.dtype},self.bias:{self.bias.dtype}")
        
        y = torch.functional.F.linear(q_x, w, self.bias)
        # 输出量化
        q_y = self.output_quant(y)
        return q_y

    @staticmethod
    def from_float(
        module, 
        weight_quant="per_channel", 
        act_quant="per_token", 
        quantize_output=False,
        N=96,
        M=128
    ):
        assert isinstance(module, torch.nn.Linear)
        new_module = SparseW8A8Linear(
            module.in_features,
            module.out_features,
            module.bias is not None,
            act_quant=act_quant,
            quantize_output=quantize_output,
            N=N,
            M=M
        )
        if weight_quant == "per_channel":
            new_module.weight = quantize_weight_per_channel_absmax(
                module.weight, n_bits=8
            )
        elif weight_quant == "per_tensor":
            new_module.weight = quantize_weight_per_tensor_absmax(
                module.weight, n_bits=8
            )
        else:
            raise ValueError(f"Invalid weight_quant: {weight_quant}")
        new_module.weight_quant_name = weight_quant
        if module.bias is not None:
            new_module.bias = module.bias
        return new_module

    def __repr__(self):
        return f"SparseW8A8Linear({self.in_features}, {self.out_features}, bias={self.bias is not None}, N={self.N}, M={self.M}, weight_quant={self.weight_quant_name}, act_quant={self.act_quant_name}, output_quant={self.output_quant_name})"



class W4A8Linear(nn.Module):
    def __init__(
        self,
        in_features,
        out_features,
        bias=True,
        act_quant="per_token",
        quantize_output=False,
    ):
        super().__init__()
        self.in_features = in_features
        self.out_features = out_features

        self.register_buffer(
            "weight",
            torch.randn(
                self.out_features,
                self.in_features,
                dtype=torch.float16,
                requires_grad=False,
            ),
        )
        if bias:
            self.register_buffer(
                "bias",
                torch.zeros(
                    (1, self.out_features), dtype=torch.float16, requires_grad=False
                ),
            )
        else:
            self.register_buffer("bias", None)

        if act_quant == "per_token":
            self.act_quant_name = "per_token"
            self.act_quant = partial(quantize_activation_per_token_absmax, n_bits=8)
        elif act_quant == "per_tensor":
            self.act_quant_name = "per_tensor"
            self.act_quant = partial(quantize_activation_per_tensor_absmax, n_bits=8)
        else:
            raise ValueError(f"Invalid act_quant: {act_quant}")

        if quantize_output:
            self.output_quant_name = self.act_quant_name
            self.output_quant = self.act_quant
        else:
            self.output_quant_name = "None"
            self.output_quant = lambda x: x

    def to(self, *args, **kwargs):
        super(W4A8Linear, self).to(*args, **kwargs)
        self.weight = self.weight.to(*args, **kwargs)
        if self.bias is not None:
            self.bias = self.bias.to(*args, **kwargs)
        return self

    @torch.no_grad()
    def forward(self, x):
        q_x = self.act_quant(x)
        y = torch.functional.F.linear(q_x, self.weight, self.bias)
        q_y = self.output_quant(y)
        return q_y

    @staticmethod
    def from_float(
        module, weight_quant="per_channel", act_quant="per_token", quantize_output=False
    ):
        assert isinstance(module, torch.nn.Linear)
        new_module = W4A8Linear(
            module.in_features,
            module.out_features,
            module.bias is not None,
            act_quant=act_quant,
            quantize_output=quantize_output,
        )
        if weight_quant == "per_channel":
            new_module.weight = quantize_weight_per_channel_absmax(
                module.weight, n_bits=4
            )  # use 4-bit integer for weight
        elif weight_quant == "per_tensor":
            new_module.weight = quantize_weight_per_tensor_absmax(
                module.weight, n_bits=4
            )
        else:
            raise ValueError(f"Invalid weight_quant: {weight_quant}")
        new_module.weight_quant_name = weight_quant
        if module.bias is not None:
            new_module.bias = module.bias
        return new_module

    def __repr__(self):
        return f"W4A8Linear({self.in_features}, {self.out_features}, bias={self.bias is not None}, weight_quant={self.weight_quant_name}, act_quant={self.act_quant_name}, output_quant={self.output_quant_name})"

class SparseW4A8Linear(W4A8Linear):
    def __init__(
        self,
        in_features,
        out_features, 
        bias=True,
        act_quant="per_token",
        quantize_output=False,
        N=2,
        M=4,
        decay=0.0002
    ):
        super().__init__(
            in_features,
            out_features,
            bias=bias,
            act_quant=act_quant, 
            quantize_output=quantize_output
        )
        self.N = N
        self.M = M
        self.decay = decay

    def get_sparse_weights(self):
        return Sparse.apply(self.weight, self.N, self.M, self.decay)

    @torch.no_grad()
    def forward(self, x):
        # 量化输入
        q_x = self.act_quant(x)
        # 获取稀疏量化权重
        w = self.get_sparse_weights()
        # 线性计算
        y = torch.functional.F.linear(q_x, w, self.bias)
        # 输出量化
        q_y = self.output_quant(y)
        return q_y

    @staticmethod
    def from_float(
        module,
        weight_quant="per_channel",
        act_quant="per_token",
        quantize_output=False,
        N=110,
        M=128 
    ):
        assert isinstance(module, torch.nn.Linear)
        new_module = SparseW4A8Linear(
            module.in_features,
            module.out_features,
            module.bias is not None,
            act_quant=act_quant,
            quantize_output=quantize_output,
            N=N,
            M=M
        )
        if weight_quant == "per_channel":
            new_module.weight = quantize_weight_per_channel_absmax(
                module.weight, n_bits=4
            )
        elif weight_quant == "per_tensor":
            new_module.weight = quantize_weight_per_tensor_absmax(
                module.weight, n_bits=4
            )
        else:
            raise ValueError(f"Invalid weight_quant: {weight_quant}")
        new_module.weight_quant_name = weight_quant
        if module.bias is not None:
            new_module.bias = module.bias
        return new_module

    def __repr__(self):
        return f"SparseW4A8Linear({self.in_features}, {self.out_features}, bias={self.bias is not None}, N={self.N}, M={self.M}, weight_quant={self.weight_quant_name}, act_quant={self.act_quant_name}, output_quant={self.output_quant_name})"


class W4A4Linear(nn.Module):
    def __init__(
        self,
        in_features,
        out_features,
        bias=True,
        act_quant="per_token",
        quantize_output=False,
    ):
        super().__init__()
        self.in_features = in_features
        self.out_features = out_features

        self.register_buffer(
            "weight",
            torch.randn(
                self.out_features,
                self.in_features,
                dtype=torch.float16,
                requires_grad=False,
            ),
        )
        if bias:
            self.register_buffer(
                "bias",
                torch.zeros(
                    (1, self.out_features), dtype=torch.float16, requires_grad=False
                ),
            )
        else:
            self.register_buffer("bias", None)

        if act_quant == "per_token":
            self.act_quant_name = "per_token"
            self.act_quant = partial(quantize_activation_per_token_absmax, n_bits=4)
        elif act_quant == "per_tensor":
            self.act_quant_name = "per_tensor"
            self.act_quant = partial(quantize_activation_per_tensor_absmax, n_bits=4)
        else:
            raise ValueError(f"Invalid act_quant: {act_quant}")

        if quantize_output:
            self.output_quant_name = self.act_quant_name
            self.output_quant = self.act_quant
        else:
            self.output_quant_name = "None"
            self.output_quant = lambda x: x

    def to(self, *args, **kwargs):
        super(W4A4Linear, self).to(*args, **kwargs)
        self.weight = self.weight.to(*args, **kwargs)
        if self.bias is not None:
            self.bias = self.bias.to(*args, **kwargs)
        return self

    @torch.no_grad()
    def forward(self, x):
        q_x = self.act_quant(x)
        y = torch.functional.F.linear(q_x, self.weight, self.bias)
        q_y = self.output_quant(y)
        return q_y

    @staticmethod
    def from_float(
        module, weight_quant="per_channel", act_quant="per_token", quantize_output=False
    ):
        assert isinstance(module, torch.nn.Linear)
        new_module = W4A4Linear(
            module.in_features,
            module.out_features,
            module.bias is not None,
            act_quant=act_quant,
            quantize_output=quantize_output,
        )
        if weight_quant == "per_channel":
            new_module.weight = quantize_weight_per_channel_absmax(
                module.weight, n_bits=4
            )  # use 4-bit integer for weight
        elif weight_quant == "per_tensor":
            new_module.weight = quantize_weight_per_tensor_absmax(
                module.weight, n_bits=4
            )
        else:
            raise ValueError(f"Invalid weight_quant: {weight_quant}")
        new_module.weight_quant_name = weight_quant
        if module.bias is not None:
            new_module.bias = module.bias
        return new_module

    def __repr__(self):
        return f"W4A4Linear({self.in_features}, {self.out_features}, bias={self.bias is not None}, weight_quant={self.weight_quant_name}, act_quant={self.act_quant_name}, output_quant={self.output_quant_name})"

class W4A8Linear_QAT(nn.Module):
    def __init__(
        self,
        in_features,
        out_features,
        bias=None,
        act_quant="static",  # 改为默认使用static量化
        quantize_output=False,
        act_scale=None,  # 新增act_scale参数
    ):
        super().__init__()
        self.in_features = in_features
        self.out_features = out_features

        # 将weight改为Parameter，启用梯度
        self.weight = nn.Parameter(
            torch.randn(
                self.out_features,
                self.in_features,
                dtype=torch.float,
            )
        )
        
        if bias:
            # 将bias改为Parameter，启用梯度
            self.bias = nn.Parameter(
                torch.zeros((1, self.out_features), dtype=torch.float)
            )
        else:
            self.register_parameter('bias', None)

        # 注册固定的activation scale，不参与训练
        self.register_buffer(
            "act_scale",
            act_scale.to(torch.float),
            persistent=False
        )


        if act_quant == "per_token":
            self.act_quant_name = "per_token"
            self.act_quant = partial(quantize_activation_per_token_absmax, n_bits=8)
        elif act_quant == "per_tensor":
            self.act_quant_name = "per_tensor"
            self.act_quant = partial(quantize_activation_per_tensor_absmax, n_bits=8)
        elif act_quant == "static":
            self.act_quant_name = "static"
            self.act_quant = self.quantize_activation_static
        else:
            raise ValueError(f"Invalid act_quant: {act_quant}")

        if quantize_output:
            self.output_quant_name = self.act_quant_name
            self.output_quant = self.act_quant
        else:
            self.output_quant_name = "None"
            self.output_quant = lambda x: x

    def quantize_activation_static(self, x):
        x_q = torch.clamp(torch.round(x / self.act_scale), -127, 127)
        x_q=x_q*self.act_scale
        return x_q

    def to(self, *args, **kwargs):
        super(W4A8Linear_QAT, self).to(*args, **kwargs)
        return self

    def forward(self, x):
        q_x = self.act_quant(x)
        y = torch.functional.F.linear(q_x, self.weight, self.bias)
        q_y = self.output_quant(y)
        return q_y

    @staticmethod
    def from_float(
        module,
        weight_quant="per_channel",
        act_quant="static",  # 默认使用static量化
        quantize_output=False,
        act_scale=None,  # 新增act_scale参数
    ):
        assert isinstance(module, torch.nn.Linear)
        new_module = W4A8Linear_QAT(
            module.in_features,
            module.out_features,
            module.bias is not None,
            act_quant=act_quant,
            quantize_output=quantize_output,
            act_scale=act_scale,  # 传入act_scale
        )
        
        # 复制权重和偏置
        with torch.no_grad():
            if weight_quant == "per_channel":
                new_module.weight.copy_(
                    quantize_weight_per_channel_absmax(module.weight, n_bits=4)
                )
            elif weight_quant == "per_tensor":
                new_module.weight.copy_(
                    quantize_weight_per_tensor_absmax(module.weight, n_bits=4)
                )
            else:
                raise ValueError(f"Invalid weight_quant: {weight_quant}")
            
            new_module.weight_quant_name = weight_quant
            if module.bias is not None:
                new_module.bias.copy_(module.bias.view(1, -1))
        
        return new_module

    def __repr__(self):
        return (f"W4A8Linear({self.in_features}, {self.out_features}, "
                f"bias={self.bias is not None}, weight_quant={self.weight_quant_name}, "
                f"act_quant={self.act_quant_name}, output_quant={self.output_quant_name})")

class W8A8Linear_QAT(nn.Module):
    def __init__(
        self,
        in_features,
        out_features,
        bias=None,
        act_quant="static",  # 改为默认使用static量化
        quantize_output=False,
        act_scale=None,  # 新增act_scale参数
    ):
        super().__init__()
        self.in_features = in_features
        self.out_features = out_features

        # 将weight改为Parameter，启用梯度
        self.weight = nn.Parameter(
            torch.randn(
                self.out_features,
                self.in_features,
                dtype=torch.float,
            )
        )
        
        if bias:
            # 将bias改为Parameter，启用梯度
            self.bias = nn.Parameter(
                torch.zeros((1, self.out_features), dtype=torch.float)
            )
        else:
            self.register_parameter('bias', None)

        # 注册固定的activation scale，不参与训练
        self.register_buffer(
            "act_scale",
            act_scale.to(torch.float),
            persistent=False
        )


        if act_quant == "per_token":
            self.act_quant_name = "per_token"
            self.act_quant = partial(quantize_activation_per_token_absmax, n_bits=8)
        elif act_quant == "per_tensor":
            self.act_quant_name = "per_tensor"
            self.act_quant = partial(quantize_activation_per_tensor_absmax, n_bits=8)
        elif act_quant == "static":
            self.act_quant_name = "static"
            self.act_quant = self.quantize_activation_static
        else:
            raise ValueError(f"Invalid act_quant: {act_quant}")

        if quantize_output:
            self.output_quant_name = self.act_quant_name
            self.output_quant = self.act_quant
        else:
            self.output_quant_name = "None"
            self.output_quant = lambda x: x

    def quantize_activation_static(self, x):
        x_q = torch.clamp(torch.round(x / self.act_scale), -127, 127)
        x_q=x_q*self.act_scale
        return x_q

    def to(self, *args, **kwargs):
        super(W4A8Linear_QAT, self).to(*args, **kwargs)
        return self

    def forward(self, x):
        q_x = self.act_quant(x)
        y = torch.functional.F.linear(q_x, self.weight, self.bias)
        q_y = self.output_quant(y)
        return q_y

    @staticmethod
    def from_float(
        module,
        weight_quant="per_channel",
        act_quant="static",  # 默认使用static量化
        quantize_output=False,
        act_scale=None,  # 新增act_scale参数
    ):
        assert isinstance(module, torch.nn.Linear)
        new_module = W4A8Linear_QAT(
            module.in_features,
            module.out_features,
            module.bias is not None,
            act_quant=act_quant,
            quantize_output=quantize_output,
            act_scale=act_scale,  # 传入act_scale
        )
        
        # 复制权重和偏置
        with torch.no_grad():
            if weight_quant == "per_channel":
                new_module.weight.copy_(
                    quantize_weight_per_channel_absmax(module.weight, n_bits=8)
                )
            elif weight_quant == "per_tensor":
                new_module.weight.copy_(
                    quantize_weight_per_tensor_absmax(module.weight, n_bits=8)
                )
            else:
                raise ValueError(f"Invalid weight_quant: {weight_quant}")
            
            new_module.weight_quant_name = weight_quant
            if module.bias is not None:
                new_module.bias.copy_(module.bias.view(1, -1))
        
        return new_module

    def __repr__(self):
        return (f"W4A8Linear({self.in_features}, {self.out_features}, "
                f"bias={self.bias is not None}, weight_quant={self.weight_quant_name}, "
                f"act_quant={self.act_quant_name}, output_quant={self.output_quant_name})")
def quantize_opt(
    model, weight_quant="per_tensor", act_quant="per_tensor", quantize_bmm_input=True
):
    from transformers.models.opt.modeling_opt import (
        OPTAttention,
        OPTDecoderLayer,
    )

    for name, m in model.model.named_modules():
        if isinstance(m, OPTDecoderLayer):
            m.fc1 = W8A8Linear.from_float(
                m.fc1, weight_quant=weight_quant, act_quant=act_quant
            )
            m.fc2 = W8A8Linear.from_float(
                m.fc2, weight_quant=weight_quant, act_quant=act_quant
            )
        elif isinstance(m, OPTAttention):
            # Her we simulate quantizing BMM inputs by quantizing the output of q_proj, k_proj, v_proj
            m.q_proj = W8A8Linear.from_float(
                m.q_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                quantize_output=quantize_bmm_input,
            )
            m.k_proj = W8A8Linear.from_float(
                m.k_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                quantize_output=quantize_bmm_input,
            )
            m.v_proj = W8A8Linear.from_float(
                m.v_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                quantize_output=quantize_bmm_input,
            )
            m.out_proj = W8A8Linear.from_float(
                m.out_proj, weight_quant=weight_quant, act_quant=act_quant
            )
    return model


def quantize_llama_like(
    model, weight_quant="per_channel", act_quant="per_token", quantize_bmm_input=False
):
    from transformers.models.llama.modeling_llama import (
        LlamaAttention,
        LlamaMLP,
    )

    from transformers.models.mistral.modeling_mistral import (
        MistralAttention,
        MistralMLP,
    )

    for name, m in model.model.named_modules():
        if isinstance(m, (LlamaMLP, MistralMLP)):
            m.gate_proj = W8A8Linear.from_float(
                m.gate_proj, weight_quant=weight_quant, act_quant=act_quant
            )
            m.up_proj = W8A8Linear.from_float(
                m.up_proj, weight_quant=weight_quant, act_quant=act_quant
            )
            m.down_proj = W8A8Linear.from_float(
                m.down_proj, weight_quant=weight_quant, act_quant=act_quant
            )
        elif isinstance(m, (LlamaAttention, MistralAttention)):
            # Her we simulate quantizing BMM inputs by quantizing the output of q_proj, k_proj, v_proj
            m.q_proj = W8A8Linear.from_float(
                m.q_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                quantize_output=quantize_bmm_input,
            )
            m.k_proj = W8A8Linear.from_float(
                m.k_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                quantize_output=quantize_bmm_input,
            )
            m.v_proj = W8A8Linear.from_float(
                m.v_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                quantize_output=quantize_bmm_input,
            )
            m.o_proj = W8A8Linear.from_float(
                m.o_proj, weight_quant=weight_quant, act_quant=act_quant
            )
    return model


def quantize_mixtral(
    model, weight_quant="per_channel", act_quant="per_token", quantize_bmm_input=False
):
    from transformers.models.mixtral.modeling_mixtral import (
        MixtralAttention,
        MixtralSparseMoeBlock,
        MixtralBLockSparseTop2MLP,
    )

    for name, m in model.model.named_modules():
        if isinstance(m, MixtralBLockSparseTop2MLP):
            m.w1 = W8A8Linear.from_float(
                m.w1, weight_quant=weight_quant, act_quant=act_quant
            )
            m.w2 = W8A8Linear.from_float(
                m.w2, weight_quant=weight_quant, act_quant=act_quant
            )
            m.w3 = W8A8Linear.from_float(
                m.w3, weight_quant=weight_quant, act_quant=act_quant
            )
        elif isinstance(m, MixtralAttention):
            # Her we simulate quantizing BMM inputs by quantizing the output of q_proj, k_proj, v_proj
            m.q_proj = W8A8Linear.from_float(
                m.q_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                quantize_output=quantize_bmm_input,
            )
            m.k_proj = W8A8Linear.from_float(
                m.k_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                quantize_output=quantize_bmm_input,
            )
            m.v_proj = W8A8Linear.from_float(
                m.v_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                quantize_output=quantize_bmm_input,
            )
            m.o_proj = W8A8Linear.from_float(
                m.o_proj, weight_quant=weight_quant, act_quant=act_quant
            )
        elif isinstance(m, MixtralSparseMoeBlock):
            m.gate = W8A8Linear.from_float(
                m.gate, weight_quant=weight_quant, act_quant=act_quant
            )
    return model


def quantize_falcon(
    model, weight_quant="per_channel", act_quant="per_token", quantize_bmm_input=True
):
    from transformers.models.falcon.modeling_falcon import (
        FalconAttention,
        FalconMLP,
    )

    for name, m in model.named_modules():
        if isinstance(m, FalconMLP):
            m.dense_h_to_4h = W8A8Linear.from_float(
                m.dense_h_to_4h, weight_quant=weight_quant, act_quant=act_quant
            )
            m.dense_4h_to_h = W8A8Linear.from_float(
                m.dense_4h_to_h, weight_quant=weight_quant, act_quant=act_quant
            )
        elif isinstance(m, FalconAttention):
            # Her we simulate quantizing BMM inputs by quantizing the output of q_proj, k_proj, v_proj
            m.query_key_value = W8A8Linear.from_float(
                m.query_key_value,
                weight_quant=weight_quant,
                act_quant=act_quant,
                quantize_output=quantize_bmm_input,
            )
            m.dense = W8A8Linear.from_float(
                m.dense, weight_quant=weight_quant, act_quant=act_quant
            )
    return model

def quantize_qwen2(
    model,weight_quant="per_channel", act_quant="per_token", quantize_bmm_input=True,mode="W8A8"
):
    from transformers.models.qwen2.modeling_qwen2 import(
        Qwen2Attention,
        Qwen2MLP
    )
    if mode == "W8A8":
        LinearClass = W8A8Linear
    elif mode == "W4A8":
        LinearClass = W4A8Linear
    elif mode == "W4A4":
        LinearClass = W4A4Linear
    elif mode == "SparseW8A8":
        LinearClass = SparseW8A8Linear
    elif mode == "SparseW4A8":
        LinearClass = SparseW4A8Linear
    else:
        raise ValueError(f"Invalid mode: {mode}")
    for name, m in model.model.named_modules():
        if isinstance(m, Qwen2MLP):
            m.gate_proj = LinearClass.from_float(
                m.gate_proj, weight_quant=weight_quant, act_quant=act_quant
            )
            m.up_proj = LinearClass.from_float(
                m.up_proj, weight_quant=weight_quant, act_quant=act_quant
            )
            m.down_proj = LinearClass.from_float(
                m.down_proj, weight_quant=weight_quant, act_quant=act_quant
            )
        elif isinstance(m, Qwen2Attention):
            # Her we simulate quantizing BMM inputs by quantizing the output of q_proj, k_proj, v_proj
            m.q_proj = LinearClass.from_float(
                m.q_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                quantize_output=quantize_bmm_input,
            )
            m.k_proj = LinearClass.from_float(
                m.k_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                quantize_output=quantize_bmm_input,
            )
            m.v_proj = LinearClass.from_float(
                m.v_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                quantize_output=quantize_bmm_input,
            )
            m.o_proj = LinearClass.from_float(
                m.o_proj, weight_quant=weight_quant, act_quant=act_quant
            )
    return model

def quantize_qwen2_QAT(
    model,act_scales,weight_quant="per_channel",act_quant="static"
):
    from transformers.models.qwen2.modeling_qwen2 import(
        Qwen2Attention,
        Qwen2MLP
    )
    Linear_class=W8A8Linear_QAT
    for name, m in model.named_modules():
        if isinstance(m, Qwen2MLP):
            m.gate_proj = Linear_class.from_float(
                m.gate_proj, weight_quant=weight_quant, act_quant=act_quant,act_scale=act_scales[name+".gate_proj"]
            )
            m.up_proj = Linear_class.from_float(
                m.up_proj, weight_quant=weight_quant, act_quant=act_quant,act_scale=act_scales[name+".up_proj"]
            )
            m.down_proj = Linear_class.from_float(
                m.down_proj, weight_quant=weight_quant, act_quant=act_quant,act_scale=act_scales[name+".down_proj"]
            )
        elif isinstance(m, Qwen2Attention):
            # Her we simulate quantizing BMM inputs by quantizing the output of q_proj, k_proj, v_proj
            m.q_proj = Linear_class.from_float(
                m.q_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                act_scale=act_scales[name+".q_proj"]
            )
            m.k_proj = Linear_class.from_float(
                m.k_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                act_scale=act_scales[name+".k_proj"]
            )
            m.v_proj = Linear_class.from_float(
                m.v_proj,
                weight_quant=weight_quant,
                act_quant=act_quant,
                act_scale=act_scales[name+".v_proj"]
            )
            m.o_proj = Linear_class.from_float(
                m.o_proj, weight_quant=weight_quant, act_quant=act_quant,act_scale=act_scales[name+".o_proj"]
            )
            m.bmm1 = StaticQuantizedBMM1(query_scale=act_scales[name+".query"],key_scale=act_scales[name+".key"])
            m.bmm2 = StaticQuantizedBMM2(score_scale=act_scales[name+".score"],value_scale=act_scales[name+".value"])
    return model

def quantize_model(
    model, weight_quant="per_channel", act_quant="per_token", quantize_bmm_input=False
):
    from transformers.models.opt.modeling_opt import OPTPreTrainedModel
    from transformers.models.llama.modeling_llama import LlamaPreTrainedModel
    from transformers.models.mistral.modeling_mistral import MistralPreTrainedModel
    from transformers.models.mixtral.modeling_mixtral import MixtralPreTrainedModel
    from transformers.models.falcon.modeling_falcon import FalconPreTrainedModel
    from transformers.models.qwen2.modeling_qwen2 import Qwen2PreTrainedModel
    if isinstance(model, OPTPreTrainedModel):
        return quantize_opt(
            model,
            weight_quant=weight_quant,
            act_quant=act_quant,
            quantize_bmm_input=quantize_bmm_input,
        )
    elif isinstance(model, (LlamaPreTrainedModel, MistralPreTrainedModel)):
        return quantize_llama_like(
            model,
            weight_quant=weight_quant,
            act_quant=act_quant,
            quantize_bmm_input=quantize_bmm_input,
        )
    elif isinstance(model, MixtralPreTrainedModel):
        return quantize_mixtral(
            model,
            weight_quant=weight_quant,
            act_quant=act_quant,
            quantize_bmm_input=quantize_bmm_input,
        )
    elif isinstance(model, FalconPreTrainedModel):
        return quantize_falcon(
            model,
            weight_quant=weight_quant,
            act_quant=act_quant,
            quantize_bmm_input=quantize_bmm_input,
        )
    elif isinstance(model,Qwen2PreTrainedModel):
        return quantize_qwen2(
            model,
            weight_quant=weight_quant,
            act_quant=act_quant,
            quantize_bmm_input=quantize_bmm_input,
        )
    else:
        raise ValueError(f"Unsupported model type: {type(model)}")
