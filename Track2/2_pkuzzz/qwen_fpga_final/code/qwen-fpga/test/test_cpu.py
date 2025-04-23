import ctypes
from typing import Tuple
import numpy as np
import torch
import argparse

def gen_data(shape, dtype) -> torch.Tensor:
    # return torch.ones(shape, dtype=dtype)
    # block = torch.randint(0, 8, (8, 8), dtype=dtype)
    # return torch.tile(block, (shape[0] // 8, shape[1] // 8))
    return torch.randint(-7, 7, shape, dtype=dtype)

def pack(int4val: torch.Tensor) -> torch.Tensor:
    int4val = int4val.reshape(-1, 2)
    return (int4val[:, 0] & 0xf) | (int4val[:, 1] << 4)
    
def unpack(int8val: torch.Tensor) -> torch.Tensor:
    int8val = int8val.reshape(-1, 1)
    return torch.cat([((int8val & 0xf) << 4) >> 4, int8val >> 4], dim=1).reshape(-1)

def quantize_8b(x: torch.Tensor) -> Tuple[torch.Tensor, torch.Tensor]:
    x = x.float()
    wmax = torch.abs(x).max(dim=1).values
    scale = wmax / 127.0
    quant = x / scale[:, None]
    quant = torch.round(quant).to(torch.int8)
    return quant, scale

def quantize_4b(x: torch.Tensor) -> Tuple[torch.Tensor, torch.Tensor]:
    x = x.float()
    wmax = torch.abs(x).max(dim=1).values
    scale = wmax / 7.0
    quant = x / scale[:, None]
    quant = torch.round(quant).to(torch.int8)
    quant = pack(quant)
    return quant, scale

def test_reshape_4b_wrapper(src: torch.Tensor, M, N, BM, GM, BN, GN, so_to_invoke) -> torch.Tensor:
    invoked_c_func = so_to_invoke.test_reshape_4b
    
    src = pack(src)
    src = src.reshape(-1).numpy().ctypes.data_as(ctypes.POINTER(ctypes.c_int8))
    dst = (ctypes.c_int8 * (M * N // 2))()
    
    invoked_c_func.argtypes = [ctypes.POINTER(ctypes.c_int8), 
                               ctypes.POINTER(ctypes.c_int8), 
                               ctypes.c_int, ctypes.c_int,
                               ctypes.c_int, ctypes.c_int,
                               ctypes.c_int, ctypes.c_int]
    
    invoked_c_func.restype = None
    
    invoked_c_func(src, dst, M, N, BM, GM, BN, GN)
    
    dst = torch.tensor(np.frombuffer(dst, dtype=np.int8), dtype=torch.int8)
    dst = unpack(dst)
    return dst

def test_reshape_8b_wrapper(src: torch.Tensor, M, N, BM, GM, BN, GN, so_to_invoke) -> torch.Tensor:
    invoked_c_func = so_to_invoke.test_reshape_8b
    
    src = src.reshape(-1).numpy().ctypes.data_as(ctypes.POINTER(ctypes.c_int8))
    dst = (ctypes.c_int8 * (M * N))()
    
    invoked_c_func.argtypes = [ctypes.POINTER(ctypes.c_int8), 
                               ctypes.POINTER(ctypes.c_int8), 
                               ctypes.c_int, ctypes.c_int,
                               ctypes.c_int, ctypes.c_int,
                               ctypes.c_int, ctypes.c_int]
    
    invoked_c_func.restype = None
    
    invoked_c_func(src, dst, M, N, BM, GM, BN, GN)
        
    dst = torch.tensor(np.frombuffer(dst, dtype=np.int8), dtype=torch.int8)
    return dst

def test_cpu_w4a8_wrapper(
    M, N, K, BM, BN, BK, GM, GN, GK, active_rs: torch.Tensor, weight_rs: torch.Tensor,
    so_to_invoke) -> torch.Tensor:
    invoked_c_func = so_to_invoke.test_cpu_w4a8
    
    C_M = M // (BM * GM)
    C_N = N // (BN * GN)
    C_K = K // (BK * GK)
    
    active_rs = active_rs.reshape(-1).numpy().ctypes.data_as(ctypes.POINTER(ctypes.c_int8))
    weight_rs = pack(weight_rs).reshape(-1).numpy().ctypes.data_as(ctypes.POINTER(ctypes.c_int8))
    result_rs = (ctypes.c_int32 * (M * N))()
    
    invoked_c_func.argtypes = [ctypes.c_uint32, ctypes.c_uint32, ctypes.c_uint32,
                               ctypes.POINTER(ctypes.c_int8),
                               ctypes.POINTER(ctypes.c_int8),
                               ctypes.POINTER(ctypes.c_int32),
                               ctypes.c_int, ctypes.c_int]

    invoked_c_func.restype = None
    
    invoked_c_func(C_M, C_N, C_K, active_rs, weight_rs, result_rs, BM, GM)
    
    result_rs = torch.tensor(np.frombuffer(result_rs, dtype=np.int32), dtype=torch.int32)
    return result_rs

def test_quantize_reshape_wrapper(
    x: torch.Tensor, M, K, BM, GM, so_to_invoke) -> Tuple[torch.Tensor, torch.Tensor]:
    invoked_c_func = so_to_invoke.test_quantize_reshape
    
    class QuantizedTensor(ctypes.Structure):
        _fields_ = [
            ("q", ctypes.POINTER(ctypes.c_int8)),  # int8_t指针
            ("s", ctypes.POINTER(ctypes.c_float)), # float指针
            ("dtype", ctypes.c_int)         # 枚举用c_int表示
        ]
    
    x = x.reshape(-1).numpy().ctypes.data_as(ctypes.POINTER(ctypes.c_float))
    qx = QuantizedTensor()
    q_data = (ctypes.c_int8 * (M * K))()
    s_data = (ctypes.c_float * M)()
    qx.q = q_data
    qx.s = s_data
    qx.dtype = 0
    
    invoked_c_func.argtypes = [ctypes.POINTER(QuantizedTensor), ctypes.POINTER(ctypes.c_float),
                               ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int]
    
    invoked_c_func.restype = None
    
    invoked_c_func(qx, x, M, K, BM, GM)
    
    q = torch.tensor(np.frombuffer(q_data, dtype=np.int8), dtype=torch.int8)
    s = torch.tensor(np.frombuffer(s_data, dtype=np.float32), dtype=torch.float32)
    return q, s

def test_dequantize_reshape_wrapper(
    a_s: torch.Tensor, b_s: torch.Tensor, cq: torch.Tensor, 
    M, N, BM, GM, so_to_invoke) -> torch.Tensor:
    invoked_c_func = so_to_invoke.test_dequantize_reshape
    
    a_s = a_s.reshape(-1).numpy().ctypes.data_as(ctypes.POINTER(ctypes.c_float))
    b_s = b_s.reshape(-1).numpy().ctypes.data_as(ctypes.POINTER(ctypes.c_float))
    cq = cq.reshape(-1).numpy().ctypes.data_as(ctypes.POINTER(ctypes.c_int32))
    c = (ctypes.c_float * (M * N))()
    
    invoked_c_func.argtypes = [ctypes.POINTER(ctypes.c_float), ctypes.POINTER(ctypes.c_float),
                               ctypes.POINTER(ctypes.c_float), ctypes.POINTER(ctypes.c_int32),
                               ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int]
    
    invoked_c_func.restype = None
    
    invoked_c_func(c, a_s, b_s, cq, M, N, BM, GM)
    
    c = torch.tensor(np.frombuffer(c, dtype=np.float32), dtype=torch.float32)
    return c


def test_pack_unpack(so_invoke):
    so_invoke.test_pack_unpack.argtypes = None
    so_invoke.test_pack_unpack.restype = None
    so_invoke.test_pack_unpack()
    
def test_set_get_4b(so_invoke):
    so_invoke.test_set_get_4b.argtypes = None
    so_invoke.test_set_get_4b.restype = None
    so_invoke.test_set_get_4b()

def test_reshape(so_invoke):
    print("----------------- Test reshape -----------------")
    
    GM, GN = 8, 8
    BM, BN = 16, 8

    M = 256
    N = 128
    
    # Gen data
    src = gen_data((M, N), torch.int8)
    # Golden
    dst_gd = src.reshape((M // (BM * GM), BM, GM, N // (BN * GN), BN, GN))
    dst_gd = dst_gd.permute(0, 3, 1, 4, 2, 5)
    dst_gd = dst_gd.reshape((M // (BM * GM), N // (BN * GN), BM, BN, GM, GN))
    # Test 4b
    dst_4b = test_reshape_4b_wrapper(src, M, N, BM, GM, BN, GN, so_invoke)
    dst_4b = dst_4b.reshape((M // (BM * GM), N // (BN * GN), BM, BN, GM, GN))
    if not torch.allclose(dst_4b, dst_gd):
        print("Src:")
        print(src[0:GM, 0:GN])
        print("4b:")
        print(dst_4b[0, 0, 0, 0])
        print("Golden:")
        print(dst_gd[0, 0, 0, 0])
    assert torch.allclose(dst_4b, dst_gd)
    # Test 8b
    dst_8b = test_reshape_8b_wrapper(src, M, N, BM, GM, BN, GN, so_invoke)
    dst_8b = dst_8b.reshape((M // (BM * GM), N // (BN * GN), BM, BN, GM, GN))
    if not torch.allclose(dst_8b, dst_gd):
        print("Src:")
        print(src[0:GM, 0:GN])
        print("8b:")
        print(dst_8b[0, 0, 0, 0])
        print("Golden:")
        print(dst_gd[0, 0, 0, 0])
    assert torch.allclose(dst_8b, dst_gd)
    print("Test reshape passed!")

def test_cpu_w4a8(so_invoke):
    print("----------------- Test cpu_w4a8 -----------------")
    
    GM, GN, GK = 8, 8, 8
    BM, BN, BK = 8, 16, 8

    M = 256
    N = 512
    K = 128
    
    # Gen data
    active_nm: torch.Tensor = gen_data((M, K), torch.int8)
    weight_nm: torch.Tensor = gen_data((N, K), torch.int8)
    result_nm: torch.Tensor = torch.einsum("ik,jk->ij", 
                                           active_nm.to(torch.int32), 
                                           weight_nm.to(torch.int32))
    
    # Golden
    active_rs = active_nm.reshape((M // (BM * GM), BM, GM, K // (BK * GK), BK, GK))
    active_rs = active_rs.permute(0, 3, 1, 4, 2, 5)
    active_rs = active_rs.reshape((M // (BM * GM), K // (BK * GK), BM, BK, GM, GK))
    weight_rs = weight_nm.reshape((N // (BN * GN), BN, GN, K // (BK * GK), BK, GK))
    weight_rs = weight_rs.permute(0, 3, 1, 4, 2, 5)
    weight_rs = weight_rs.reshape((N // (BN * GN), K // (BK * GK), BN, BK, GN, GK))
    result_rs = result_nm.reshape((M // (BM * GM), BM, GM, N // (BN * GN), BN, GN))
    result_rs = result_rs.permute(0, 3, 1, 4, 2, 5)
    result_rs = result_rs.reshape((M // (BM * GM), N // (BN * GN), BM, BN, GM, GN))
    
    # Test
    result = test_cpu_w4a8_wrapper(M, N, K, BM, BN, BK, GM, GN, GK, 
                                   active_rs, weight_rs, so_invoke)
    result = result.reshape((M // (BM * GM), N // (BN * GN), BM, BN, GM, GN))
    if not torch.allclose(result_rs, result):
        print("active_rs:")
        print(active_rs[0, 0, 0, 0])
        print("weight_rs:")
        print(weight_rs[0, 0, 0, 0])
        print("result_rs:")
        print(result_rs[0, 0, 0, 0])
        print("result:")
        print(result[0, 0, 0, 0])
    assert torch.allclose(result_rs, result)
    print("Test cpu_w4a8 passed!")
    
def test_quantize_reshape(so_invoke):
    print("----------------- Test quantize_reshape -----------------")
    
    GM, GK = 8, 8
    BM, BK = 8, 8

    M = 256
    K = 128
    
    # Gen data
    x = gen_data((M, K), torch.float32)
    # Golden
    q_gold, s_gold = quantize_8b(x)
    q_gold = q_gold.reshape((M // (BM * GM), BM, GM, K // (BK * GK), BK, GK))
    q_gold = q_gold.permute(0, 3, 1, 4, 2, 5)
    q_gold = q_gold.reshape((M // (BM * GM), K // (BK * GK), BM, BK, GM, GK))
    # Test
    q_test, s_test = test_quantize_reshape_wrapper(x, M, K, BM, GM, so_invoke)
    q_test = q_test.reshape((M // (BM * GM), K // (BK * GK), BM, BK, GM, GK))
    if not torch.allclose(q_gold, q_test):
        print("x:")
        print(x[0:GM, 0:GK])
        print("q_gold:")
        print(q_gold[0, 0, 0, 0])
        print("q_test:")
        print(q_test[0, 0, 0, 0])
    assert torch.allclose(q_gold, q_test)
    if not torch.allclose(s_gold, s_test):
        print("s_gold:")
        print(s_gold[0:GM])
        print("s_test:")
        print(s_test[0:GM])
    assert torch.allclose(s_gold, s_test)
    print("Test quantize_reshape passed!")
    
def test_dequantize_reshape(so_invoke):
    print("----------------- Test dequantize_reshape -----------------")
    
    GM, GN, GK = 8, 8, 8
    BM, BN, BK = 8, 16, 8

    M = 256
    N = 512
    K = 128
    
    # Gen data
    a_s = gen_data((M,), torch.float32)
    b_s = gen_data((N,), torch.float32)
    cq = gen_data((M, N), torch.int32)
    cq_rs = cq.reshape((M // (BM * GM), BM, GM, N // (BN * GN), BN, GN))
    cq_rs = cq_rs.permute(0, 3, 1, 4, 2, 5)
    cq_rs = cq_rs.reshape((M // (BM * GM), N // (BN * GN), BM, BN, GM, GN))
    # Golden
    c_gold = torch.einsum("i,j,ij->ij", a_s, b_s, cq.to(torch.float32))
    # Test
    c_test = test_dequantize_reshape_wrapper(a_s, b_s, cq_rs, M, N, BM, GM, so_invoke)
    c_test = c_test.reshape(M, N)
    if not torch.allclose(c_gold, c_test):
        print("a_s:")
        print(a_s[0:GM])
        print("b_s:")
        print(b_s[0:GN])
        print("c_gold:")
        print(c_gold[0:GM, 0:GN])
        print("c_test:")
        print(c_test[0:GM, 0:GN])
    assert torch.allclose(c_gold, c_test)
    print("Test dequantize_reshape passed!")

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Test CPU')
    parser.add_argument('--so_path', type=str, default="libeva.so")
    args = parser.parse_args()

    so_path = args.so_path

    # Load shared library
    so_to_invoke = ctypes.CDLL(so_path)
    
    test_pack_unpack(so_to_invoke)
    test_set_get_4b(so_to_invoke)
    test_reshape(so_to_invoke)
    test_cpu_w4a8(so_to_invoke)
    test_quantize_reshape(so_to_invoke)
    test_dequantize_reshape(so_to_invoke)
        
    print("--------------------------------------")
    print("All tests passed!")

