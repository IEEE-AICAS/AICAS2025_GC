from transformers import AutoModelForCausalLM, AutoTokenizer
from basic import quant_model_abs, fp_model_path, SEED, model_name
from basic import output_model, base_quantization_config
from basic import my_set_seed
from auto_round import AutoRound
import auto_round
import torch

print(auto_round.__file__)
import os
from transformers import set_seed

set_seed(SEED)
my_set_seed(SEED)


gguf_model_path = os.path.join(quant_model_abs, model_name + "_8bit_200iters_256samples")

model = AutoModelForCausalLM.from_pretrained(fp_model_path)
output_model(model)

tokenizer = AutoTokenizer.from_pretrained(fp_model_path)

mixed_precision = False
embed_quant = True


def get_module(module, key):
    """Get module from model by key name.

    Args:
        module (torch.nn.Module): original model
        key (str): module name to be replaced
    """
    name_list = key.split(".")
    for name in name_list:
        module = getattr(module, name, None)
    return module


def EmbeddingRTN(bits=8, sym=True, group_size=32, inplace=False):
    from auto_round.data_type.utils import reshape_pad_tensor_by_group_size
    print("quantizing embed_tokens...")
    my_layer = get_module(model, "model.embed_tokens")
    my_layer_weight = my_layer.weight.data.clone()
    ori_shape = my_layer_weight.shape
    my_layer_weight, _, _ = reshape_pad_tensor_by_group_size(my_layer_weight, group_size)
    if not (bits == 8 and sym):
        raise RuntimeError("embed_tokens should be 8bit sym")
    my_max_val = torch.clamp(my_layer_weight.max(-1)[0], min=0)
    my_min_val = torch.clamp(my_layer_weight.min(-1)[0], max=0)
    my_max_q = torch.tensor(2 ** (bits - 1) - 1).to(my_max_val.device)
    my_max_v = torch.max(torch.abs(my_max_val), torch.abs(my_min_val))
    # scale 是正数
    scale = my_max_v / my_max_q
    zp = torch.zeros_like(my_max_v)

    if inplace:
        print(my_layer_weight.shape, scale.shape)
        q_weight = torch.clamp(torch.round(my_layer_weight / scale.reshape(-1, 1)), -my_max_q, my_max_q - 1)
        dq_weight = q_weight * scale.reshape(-1, 1)
        my_layer.weight.data = dq_weight.reshape(ori_shape)

    print("quantizing embed_tokens done")
    return scale, zp

def EmbeddingMSEQuant(name="model.embed_tokens", bits=8, sym=True, group_size=32, inplace=True):
    from auto_round.data_type.utils import reshape_pad_tensor_by_group_size
    from embedding_quant_cuda import quant_block

    print("quantizing embed_tokens...")
    model.cuda()
    my_layer = get_module(model, name)
    print(name, my_layer)
    if my_layer is None:
        raise ValueError("wrong module name")

    my_layer_weight = my_layer.weight.data.clone()
    ori_shape = my_layer_weight.shape
    my_layer_weight, _, _ = reshape_pad_tensor_by_group_size(my_layer_weight, group_size)

    block_count = my_layer_weight.shape[0]
    scale = torch.zeros(block_count).to(my_layer_weight.device)
    zp = torch.zeros(block_count).to(my_layer_weight.device)
    quant_block(my_layer_weight, scale, zp, bits, sym)
    print(scale)
    print(zp)

    if sym:
        zp = torch.zeros_like(scale)
        q_min = - 2 ** (bits - 1) + 1
        q_max = 2 ** (bits - 1) - 1
    else:
        q_min = 0
        q_max = 2 ** bits - 1

    # scale 是正数

    if inplace:
        print(my_layer_weight.shape, scale.shape, zp.shape)
        q_weight = torch.clamp(torch.round(my_layer_weight / scale.reshape(-1, 1)) + zp.reshape(-1, 1), q_min, q_max)
        dq_weight = (q_weight - zp.reshape(-1, 1)) * scale.reshape(-1, 1)
        my_layer.weight.data = dq_weight.reshape(ori_shape)

    print("quantizing embed_tokens done")
    return scale.cpu(), zp.cpu()

def SearchBestModelPercentile(bits=8, sym=True, group_size=32, inplace=True):
    from embedding_quant_cuda import best_percentile
    from auto_round.data_type.utils import reshape_pad_tensor_by_group_size
    result_dict = {

    }
    for name, module in model.named_modules():
        if not isinstance(module, torch.nn.Linear):
            continue
        weight_data = module.weight.data.clone()
        weight_data.cuda()

        group_data, _, _ = reshape_pad_tensor_by_group_size(weight_data, group_size)
        group_data = group_data.to("cuda:0")
        percentile_data = torch.zeros(group_data.shape[0]).to("cuda:0")
        best_percentile(group_data, percentile_data, bits, sym)
        print(torch.sum(percentile_data < 0.99999), torch.amin(percentile_data))
        result_dict.update({
            name: percentile_data
        })
    print(result_dict)
    return result_dict


# percentile_dict = SearchBestModelPercentile()

eleShape = (896, 151936)
eleCount = 896 * 151936
blockShape = (eleShape[0], eleShape[1] // 32)

layer_config = {

}

params = {
    "bits": base_quantization_config["bits"],
    "group_size": base_quantization_config["group_size"],
    "sym": base_quantization_config["sym"],
    "nsamples": 256,
    "iters": 200,
    # "nsamples": 1,
    # "iters": 1,
    "low_gpu_mem_usage": True,  # 512 个样本要开启，否则显存不够
    "enable_norm_bias_tuning": False,  # 对 LLM 没什么用
    "batch_size": 8,
    "amp": True,
    "enable_quanted_input": True,  # 启用量化误差积累
    "enable_minmax_tuning": True,  # 对超参数敏感, 不启用
    "not_use_best_mse": False,  # 使用平均 MSE
    "sampler": "notRand",  # 每次迭代不使用随机采样
    "seed": SEED,
}

fp_format = {'data_type': 'float',
            'bits': 16,
            'group_size': None,
            'sym': None,
            'scale_dtype': torch.float16,
            'act_bits': 16,
            'act_group_size': 32,
            'act_sym': True,
            'act_dynamic': True,
            'act_data_type': 'int'}

q_format = {'data_type': 'int',
            'bits': 8,
            'group_size': base_quantization_config["group_size"],
            'sym': base_quantization_config["sym"],
            'scale_dtype': torch.float16,
            'act_bits': 16,
            'act_group_size': 32,
            'act_sym': True,
            'act_dynamic': True,
            'act_data_type': 'int',
            # 'scale': torch.zeros(blockShape),
            # 'zp': torch.zeros(blockShape)
            }

if mixed_precision:
    block_count = 24
    block_names_max = ["gate", "up", "down"]
    block_names_middle = ["q", "o"]
    block_names_min = ["k", "v"]
    max_names = ["mlp." + i + "_proj" for i in block_names_max]
    middle_names = ["self_attn." + i + "_proj" for i in block_names_middle]
    min_names = ["self_attn." + i + "_proj" for i in block_names_min]
    bits_config = {
        "max": {
            "bits": 8,
            "names": max_names
        },
        "middle": {
            "bits": 8,
            "names": middle_names
        },
        "min": {
            "bits": 16,
            "names": min_names
        }
    }
    for i in range(block_count):
        for k, v in bits_config.items():
            if v["bits"] == 16:
                for name in v["names"]:
                    key = "model.layers." + str(i) + "." + name
                    layer_config[key] = fp_format


if embed_quant:
    layer_config.update({
        'model.embed_tokens': {
            'data_type': 'int',
            'bits': 8,
            'group_size': base_quantization_config["group_size"],
            'sym': base_quantization_config["sym"],
            'scale_dtype': torch.float16,
            'act_bits': 16,
            'act_group_size': 32,
            'act_sym': True,
            'act_dynamic': True,
            'act_data_type': 'int',
            # 'scale': torch.zeros(blockShape),
            # 'zp': torch.zeros(blockShape),
        }})
    scale, zp = EmbeddingMSEQuant(bits=8, sym=True, group_size=base_quantization_config["group_size"], inplace=False)
    for n, m in model.named_modules():
        if n == "model.embed_tokens":
            m.scale = scale
            m.zp = zp

    layer_config['model.embed_tokens'].update({
        'scale': scale,
        'zp': zp,
    })

params.update({
    'layer_config': layer_config,
})
auto_round = AutoRound(model, tokenizer, **params)


# auto_round.quantize(percentile_dict)
auto_round.quantize(None)


gguf_suffix = None
if params["bits"] == 8 and params["sym"]:
    gguf_suffix = "q8_0"
elif params["bits"] == 4:
    gguf_suffix = "q4_0" if params["sym"] else "q4_1"
else:
    raise ValueError("Invalid bits or sym value")

if params["sym"]:
    auto_round.save_quantized(gguf_model_path, format='gguf:{}'.format(gguf_suffix), inplace=False)
else:
    auto_round.save_quantized(gguf_model_path, format='gguf:{}'.format(gguf_suffix), inplace=False)
