from transformers import AutoTokenizer, Qwen2ForSequenceClassification,set_seed
import datasets
from torch import nn
import torch
from smoothquant.smooth import smooth_lm
from smoothquant.real_quant import get_act_scales_per_token,quantize_qwen2_static,unpack_int8_to_int4,pack_int4_in_int8
import smoothquant.rope as rope
def remove_linear_bias(model):
    """
    移除模型中所有Linear层的bias
    Args:
        model: 预训练模型
    """
    for name, module in model.named_children():
        if isinstance(module, nn.Linear):
            # 创建新的没有bias的Linear层
            new_linear = nn.Linear(
                in_features=module.in_features,
                out_features=module.out_features,
                bias=False  # 强制不使用bias
            )
            
            # 只复制权重
            new_linear.weight.data = module.weight.data.clone()
            
            # 替换原始层
            setattr(model, name, new_linear)
        else:
            # 递归处理子模块
            remove_linear_bias(module)
    
    return model
# 加载模型和分词器
# 假设你的模型保存在本地路径 "path/to/your/model"
set_seed(42)
model_path = "/lamport/makkapakka/lilinqi/Qwen2"
tokenizer = AutoTokenizer.from_pretrained(model_path)
model = Qwen2ForSequenceClassification.from_pretrained(model_path,torch_dtype=torch.float32)
model=remove_linear_bias(model)
path_to_data = '/lamport/makkapakka/lilinqi/glue/'+'wnli'

act_scales_path = "/lamport/makkapakka/lilinqi/smoothquant/act_scales/Qwen2.5-0.5B.pt"
act_scales=torch.load(act_scales_path)
alpha=0.5

model=model.half()
# smooth_lm(model, act_scales, alpha)

raw_datasets = datasets.load_dataset(path_to_data)
val_datasets=raw_datasets["validation"]
act_scales_per_token=get_act_scales_per_token(model,tokenizer,val_datasets)
for k,v in act_scales_per_token.items():
    print(f"{k}:{v.shape}")
path='/lamport/makkapakka/lilinqi/smoothquant/static_scale.pt'
torch.save(act_scales_per_token,path)