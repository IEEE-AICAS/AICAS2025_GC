from transformers import AutoTokenizer, Qwen2ForSequenceClassification,set_seed
import datasets
from torch.utils.data import DataLoader
from torch import nn
import torch
from smoothquant.smooth import smooth_lm
from smoothquant.real_quant import quantize_qwen2,get_act_scales_per_token,quantize_qwen2_static
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
model_path = "/lamport/makkapakka/lilinqi/wnli/full/1.28e-5"
save_path='/lamport/makkapakka/lilinqi/smoothquant/saved'
tokenizer = AutoTokenizer.from_pretrained(model_path)
model = Qwen2ForSequenceClassification.from_pretrained(model_path)
model=remove_linear_bias(model)
path_to_data = '/lamport/makkapakka/lilinqi/glue/'+'wnli'
act_scales_path = "/lamport/makkapakka/lilinqi/smoothquant/act_scales/Qwen2.5-0.5B.pt"
act_scales=torch.load(act_scales_path)
alpha=0.5
raw_datasets = datasets.load_dataset(path_to_data)
val_datasets=raw_datasets["validation"]
# 将模型设置为评估模式
model=model.half()
smooth_lm(model, act_scales, alpha)#smooth之后再量化
model = quantize_qwen2(
        model,
        weight_quant="per_channel",
        act_quant="per_token",
        weight_bits=4,
        act_bits=8
    )
model.eval()

correct=0
total=0
model.to("cuda:0")
for i in val_datasets:
    text=i["sentence1"]+i["sentence2"]
    inputs = tokenizer(text, return_tensors="pt", padding="max_length", truncation=True, max_length=192).to("cuda:0")
    with torch.no_grad():
        outputs = model(**inputs)
        predictions = outputs.logits
        predicted_class = torch.argmax(predictions, dim=1)
    print(f"prediction:{predictions},predicted_class:{predicted_class.item()}")
    if(predicted_class.item()==int(i["label"])):
        correct+=1
    total+=1
print(f"total:{total}\tcorrect:{correct}\taccracy:{correct/total}")