import os
import math
import numpy as np
from typing import Union, List


def unpack_rows_optimized(packed: np.ndarray, bitwidth: int, unsigned: bool) -> np.ndarray:
    """
    优化版向量化解包，不会创建 [B, M, 8] 的临时数组，从而显著减少内存占用。
    
    参数:
      packed: shape [B, M], 每个元素是一个字节 (0~255)
      bitwidth: 每个数值占多少位
      unsigned: 是否是无符号
    
    返回:
      解包后的数组，shape [B, N], dtype=int32
    """
    B, M = packed.shape
    total_bits = M * 8
    N = total_bits // bitwidth  # 解包后的数目

    # 准备输出
    out = np.zeros((B, N), dtype=np.int32)

    # 逐字节解析（对批量 B 并行）
    #   - 每字节包含 8个 bit
    #   - 对于在整体 bit 流中的第 linear_bit_index = (byte_idx * 8 + bit_idx)
    #     => 对应到 out 里的第 j = linear_bit_index // bitwidth
    #     => 以及在 j 这个值的内部 bitPos = linear_bit_index % bitwidth
    for byte_idx in range(M):
        # current_byte shape: [B]
        current_byte = packed[:, byte_idx]  # 并行读取所有行的第 byte_idx 个字节
        
        for bit_idx in range(8):
            linear_bit_index = byte_idx * 8 + bit_idx
            j = linear_bit_index // bitwidth     # 第几个数
            bitPos = linear_bit_index % bitwidth # 该数的第几位

            # 提取该bit（针对所有B行并行）
            # bits shape: [B], 值只在 {0,1} 内
            bits = ((current_byte >> bit_idx) & 1).astype(np.int32)

            # 加到输出
            out[:, j] += bits << bitPos
    
    # 若是有符号，则处理补码
    if not unsigned:
        sign_bit = 1 << (bitwidth - 1)
        neg_mask = (out & sign_bit) != 0
        out[neg_mask] -= (1 << bitwidth)

    return out

def load_packed_tensor(
    bitwidth: int,
    unsigned: bool,
    name: str
) -> np.ndarray:
    """
    从二进制文件中读取数据并解包还原（使用优化后的解包函数）
    """
    filename = f"{name}.bin"
    
    print("loading", filename)
    if not os.path.exists(filename):
        raise FileNotFoundError(f"{filename} not found.")
    fsize = os.path.getsize(filename)

    # 根据文件大小推算 size
    size = fsize * 8 // bitwidth

    # chunk 大小 N
    import math
    g = math.gcd(8, bitwidth)
    N = 8 // g
    M = (bitwidth * N) // 8
    if size % N != 0:
        raise ValueError(f"size ({size}) is not a multiple of chunk N ({N}).")

    # 读出
    raw = np.fromfile(filename, dtype=np.uint8)
    num_batches = size // N
    raw = raw.reshape(num_batches, M)

    # 调用优化版解包
    out_arr = unpack_rows_optimized(raw, bitwidth, unsigned)  # shape: [num_batches, N]
    out_arr = out_arr.reshape(-1)  # flatten => [size]
    return out_arr.astype(np.int16)

