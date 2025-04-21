import torch
from auto_round import AutoRoundConfig

import random
import os
import numpy as np

base_quantization_config = {
    "sym": True,
    "bits": 8,
    "group_size": 32,
}

os.environ["HF_DATASETS_OFFLINE"] = "1"


SEED = 42
trust_remote_code = True


def my_set_seed(seed):
    os.environ["CUBLAS_WORKSPACE_CONFIG"] = ":4096:8"
    random.seed(seed)
    os.environ['PYTHONHASHSEED'] = str(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)  # if you are using multi-GPU.
    torch.backends.cudnn.benchmark = False
    torch.backends.cudnn.deterministic = True

    torch.use_deterministic_algorithms(True, warn_only=True)


my_set_seed(SEED)

fp_model_path = "./models/Qwen2.5-0.5B"
model_name = "Qwen2.5-0.5B"
quant_model_abs = "./models/quant/"


class LLMShapeInfHook:
    """
    用于在 forward hook 中获取输入和输出的 shape
    """

    def __init__(self, name, module, to_file=None):
        self.name = name
        self.module = module
        self.to_file = to_file
        first_name = None

    def __call__(self, module, input, output):
        print(f"{self.name}:")
        if isinstance(input, tuple):
            for i, inp in enumerate(input):
                if isinstance(inp, torch.Tensor):
                    print(f"\t input {i}: {inp.shape}")
                else:
                    print(f"\t input {i}: Not Tensor Type {type(inp)}")
        else:
            if isinstance(input, torch.Tensor):
                print(f"\t input: {input.shape}")
            else:
                print(f"\t input: Not Tensor Type {type(input)}")
        if isinstance(output, tuple):
            for i, out in enumerate(output):
                if isinstance(out, torch.Tensor):
                    print(f"\t output {i}: {out.shape}")
                else:
                    print(f"\t output {i}: Not Tensor Type {type(out)}")
        else:
            if isinstance(output, torch.Tensor):
                print(f"\t output: {output.shape}")
            else:
                print(f"\t output: Not Tensor Type {type(output)}")


def output_model(model):
    with open("model.txt", "w") as f:
        for name, module in model.named_modules():
            try:
                f.write(f"{name}, {module}, {type(module)}, {module.weight.shape}\n")
            except:
                f.write(f"{name}, {module}, {type(module)}, None\n")

