import torch
import torch.nn as nn
from typing import Tuple, Optional
from dataclasses import dataclass

def symmetric_quantize_per_token(x, num_bits=8):
    """
    对score进行per-token方向的对称量化
    shape: [batch, heads, seq_len, seq_len]
    """
    B, H, L, S = x.shape
    
    # 在token维度上计算最大绝对值
    x_abs_max = torch.abs(x).amax(dim=-1, keepdim=True)  # [B, H, L, 1]
    
    # 计算量化参数 (对称量化，范围为 [-2^(num_bits-1), 2^(num_bits-1)-1])
    scale = x_abs_max / (2 ** (num_bits - 1) - 1)
    scale = torch.max(scale, torch.tensor(1e-8, device=x.device))  # 防止除零
    
    # 量化
    x_int = torch.round(x / scale)
    x_int = torch.clamp(x_int, -2 ** (num_bits - 1) + 1, 2 ** (num_bits - 1) - 1)
    
    return x_int, scale

def symmetric_quantize_per_channel(x, num_bits=8):
    """
    对value进行per-channel方向的对称量化
    shape: [batch, heads, seq_len, dim]
    """
    B, H, L, D = x.shape
    
    # 在sequence length维度上计算最大绝对值
    x_abs_max = torch.abs(x).amax(dim=2, keepdim=True)  # [B, H, 1, D]
    
    # 计算量化参数
    scale = x_abs_max / (2 ** (num_bits - 1) - 1)
    scale = torch.max(scale, torch.tensor(1e-8, device=x.device))  # 防止除零
    
    # 量化
    x_int = torch.round(x / scale)
    x_int = torch.clamp(x_int, -2 ** (num_bits - 1) + 1, 2 ** (num_bits - 1) - 1)
    
    return x_int, scale

def quantized_matmul(score, value, num_bits=8):
    """
    对称量化的矩阵乘法函数
    score: [batch, heads, seq_len, seq_len]
    value: [batch, heads, seq_len, dim]
    """
    # 1. 对称量化score和value
    score_int, score_scale = symmetric_quantize_per_token(score, num_bits)
    value_int, value_scale = symmetric_quantize_per_channel(value, num_bits)
    
    # 2. 整数矩阵乘法
    output_int = torch.matmul(score_int, value_int)
    
    final_scale = score_scale * value_scale
    
    # 反量化得到浮点数结果
    output = output_int * final_scale
    
    return output


class StaticQuantizedBMM1(nn.Module):
    def __init__(self, num_bits: int = 8,query_scale=None,key_scale=None):
        super().__init__()
        self.num_bits = num_bits
        self.max_int = 2 ** (num_bits - 1) - 1
        self.min_int = -(2 ** (num_bits - 1)) - 1 
        
        # 存储计算好的量化参数
        self.register_buffer("query_scale", query_scale)
        
        self.register_buffer("key_scale",key_scale)
        

    def _quantize_score(self, x: torch.Tensor) -> torch.Tensor:
        """对score进行量化"""
        x_int = torch.round(x / self.query_scale)
        return torch.clamp(x_int, self.min_int, self.max_int)
    
    def _quantize_value(self, x: torch.Tensor) -> torch.Tensor:
        """对value进行量化"""
        x_int = torch.round(x / self.key_scale)
        return torch.clamp(x_int, self.min_int, self.max_int)
    
    def forward(self, score: torch.Tensor, value: torch.Tensor) -> torch.Tensor:
        """
        执行量化矩阵乘法
        Args:
            score: shape [batch, heads, seq_len, seq_len]
            value: shape [batch, heads, seq_len, dim]
        Returns:
            output: shape [batch, heads, seq_len, dim]
        """
            
        # 量化
        score_int = self._quantize_score(score)
        value_int = self._quantize_value(value)
        
        # 整数矩阵乘法
        output_int = torch.matmul(score_int, value_int)
        
        # 反量化，考虑累加影响
        final_scale = self.query_scale * self.key_scale
        output = output_int * final_scale
        
        return output

class StaticQuantizedBMM2(nn.Module):
    def __init__(self, num_bits: int = 8,score_scale=None,value_scale=None):
        super().__init__()
        self.num_bits = num_bits
        self.max_int = 2 ** (num_bits - 1) - 1
        self.min_int = -(2 ** (num_bits - 1)) - 1 
        
        # 存储计算好的量化参数
        self.register_buffer("score_scale", score_scale)
        
        self.register_buffer("value_scale",value_scale)
        

    def _quantize_score(self, x: torch.Tensor) -> torch.Tensor:
        """对score进行量化"""
        x_int = torch.round(x / self.score_scale)
        return torch.clamp(x_int, self.min_int, self.max_int)
    
    def _quantize_value(self, x: torch.Tensor) -> torch.Tensor:
        """对value进行量化"""
        x_int = torch.round(x / self.value_scale)
        return torch.clamp(x_int, self.min_int, self.max_int)
    
    def forward(self, score: torch.Tensor, value: torch.Tensor) -> torch.Tensor:
        """
        执行量化矩阵乘法
        Args:
            score: shape [batch, heads, seq_len, seq_len]
            value: shape [batch, heads, seq_len, dim]
        Returns:
            output: shape [batch, heads, seq_len, dim]
        """
            
        # 量化
        score_int = self._quantize_score(score)
        value_int = self._quantize_value(value)
        
        # 整数矩阵乘法
        output_int = torch.matmul(score_int, value_int)
        
        # 反量化，考虑累加影响
        final_scale = self.score_scale * self.value_scale
        output = output_int * final_scale
        
        return output

# 测试和验证函数
def test_quantized_matmul():
    print('hello')
    # 创建示例输入
    batch_size, num_heads = 1, 14
    seq_len, dim = 192, 64
    
    score = torch.randn(batch_size, num_heads, seq_len, seq_len)
    value = torch.randn(batch_size, num_heads, seq_len, dim)
    
    # 执行量化矩阵乘法
    quantized_output = quantized_matmul(score, value)
    
    # 原始矩阵乘法
    original_output = torch.matmul(score, value)
    
    # 计算相对误差
    rel_error = torch.abs(quantized_output - original_output) / (torch.abs(original_output) + 1e-8)
    avg_rel_error = rel_error.mean()
    
    print(f"Output shape: {quantized_output.shape}")
    print(f"Average relative error: {avg_rel_error:.6f}")
    
    # 检查数值范围
    print(f"Original output range: [{original_output.min():.4f}, {original_output.max():.4f}]")
    print(f"Quantized output range: [{quantized_output.min():.4f}, {quantized_output.max():.4f}]")

if __name__ == "__main__":
    test_quantized_matmul()