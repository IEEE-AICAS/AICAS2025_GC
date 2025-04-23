import struct
import torch
import numpy as np
from safetensors.torch import save_file


##----convert bin back to safetensor to evaluate compression model----##
#author : Tong Hu
#date : 2025.2.10

def load_version2_bin_FP32(filepath):
    """ 读取 .bin 文件，并转换回 （int8 + FP32） """
    state_dict = {}

    with open(filepath, "rb") as f:
        # 读取 Magic 和 Version
        magic, version = struct.unpack("I i", f.read(8))
        assert magic == 0x616b3432, "Invalid magic number, not a valid bin file!"
        assert version == 2, "Unsupported version!"

        # 读取模型参数
        dim, hidden_dim, n_layers, n_heads, n_kv_heads, vocab_size, max_seq_len = struct.unpack("iiiiiii", f.read(28))
        shared_classifier = struct.unpack("B", f.read(1))[0]
        group_size = struct.unpack("i", f.read(4))[0]


        pad_bytes = 256 - f.tell()
        f.read(pad_bytes)

        print(f" 解析 .bin 文件: dim={dim}, hidden_dim={hidden_dim}, n_layers={n_layers}, n_heads={n_heads}, vocab_size={vocab_size}, group_size={group_size}")


        def read_tensor(f, shape):
  
            num_elements = np.prod(shape)
            data = np.frombuffer(f.read(num_elements * 4), dtype=np.float32)
            return torch.tensor(data.reshape(shape), dtype=torch.float32)


        for i in range(n_layers):
            state_dict[f"layer_{i}.attention_norm.weight"] = read_tensor(f, (dim,))
        for i in range(n_layers):
            state_dict[f"layer_{i}.ffn_norm.weight"] = read_tensor(f, (dim,))
        state_dict["model.norm.weight"] = read_tensor(f, (dim,))


        for i in range(n_layers):
            state_dict[f"layer_{i}.attention.wq.bias"] = read_tensor(f, (dim,))
        for i in range(n_layers):
            state_dict[f"layer_{i}.attention.wk.bias"] = read_tensor(f, (dim,))
        for i in range(n_layers):
            state_dict[f"layer_{i}.attention.wv.bias"] = read_tensor(f, (dim,))

        # **存储 int8 量化权重和 scale factor（FP32）**
        def read_quantized_tensor(f, shape, group_size):
            """ 读取 Q8_0 量化张量，存 `int8 + FP32`，不反量化 """
            num_elements = np.prod(shape)
            q_data = np.frombuffer(f.read(num_elements), dtype=np.int8)  # **直接存储 int8**
            scale_data = np.frombuffer(f.read(num_elements // group_size), dtype=np.float32)  # 读取 scale factors

            return torch.tensor(q_data, dtype=torch.int8), torch.tensor(scale_data, dtype=torch.float32)


        state_dict["model.tok_embeddings.weight"], state_dict["model.tok_embeddings.scale"] = read_quantized_tensor(f, (vocab_size, dim), group_size)

        for i in range(n_layers):
            state_dict[f"layer_{i}.attention.wq.weight"], state_dict[f"layer_{i}.attention.wq.scale"] = read_quantized_tensor(f, (dim, dim), group_size)
        for i in range(n_layers):
            state_dict[f"layer_{i}.attention.wk.weight"], state_dict[f"layer_{i}.attention.wk.scale"] = read_quantized_tensor(f, (dim, dim), group_size)
        for i in range(n_layers):
            state_dict[f"layer_{i}.attention.wv.weight"], state_dict[f"layer_{i}.attention.wv.scale"] = read_quantized_tensor(f, (dim, dim), group_size)
        for i in range(n_layers):
            state_dict[f"layer_{i}.attention.wo.weight"], state_dict[f"layer_{i}.attention.wo.scale"] = read_quantized_tensor(f, (dim, dim), group_size)
        # 逐层解析 FFN 量化权重
        for i in range(n_layers):
            state_dict[f"layer_{i}.feed_forward.w1.weight"], state_dict[f"layer_{i}.feed_forward.w1.scale"] = read_quantized_tensor(f, (dim, hidden_dim), group_size)
        for i in range(n_layers):
            state_dict[f"layer_{i}.feed_forward.w2.weight"], state_dict[f"layer_{i}.feed_forward.w2.scale"] = read_quantized_tensor(f, (hidden_dim, dim), group_size)
        for i in range(n_layers):
            state_dict[f"layer_{i}.feed_forward.w3.weight"], state_dict[f"layer_{i}.feed_forward.w3.scale"] = read_quantized_tensor(f, (dim, hidden_dim), group_size)

        # 如果 classifier 不共享，读取 output.weight
        if not shared_classifier:
            state_dict["model.output.weight"], state_dict["model.output.scale"] = read_quantized_tensor(f, (vocab_size, dim), group_size)

        # 读取 `DEADBEEF` 结尾标志
        # flag = struct.unpack("I", f.read(4))[0]
        # assert flag == 0xDEADBEEF, "Error: Missing debug flag at the end of the file!"
        # print(f" Debug flag {hex(flag)} 找到，读取正确")

    return state_dict




# **执行转换**
bin_filepath = "Qwen2.5-0.5B-Instruct.bin"
safetensors_filepath = "Qwen2.5-0.5B-Instruct-INT8.safetensors"

state_dict = load_version2_bin_FP32(bin_filepath) 
save_file(state_dict, safetensors_filepath)

print(f" 转换为 safetensors：{safetensors_filepath}")
