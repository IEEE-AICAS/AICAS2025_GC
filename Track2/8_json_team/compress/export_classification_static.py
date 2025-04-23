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
model_path = "/lamport/makkapakka/lilinqi/wnli/full/1e-4"
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
# smooth_lm(model, act_scales, alpha)#smooth之后再量化
act_scales_per_token=torch.load('/lamport/makkapakka/lilinqi/smoothquant/static_scale.pt')
model = quantize_qwen2_static(
        model,
        act_scales=act_scales_per_token,
        weight_quant="per_channel",
        weight_bits=4,
        act_bits=8
    )
model.eval()

para=model.state_dict()
export_state_dict={}
for name,v in para.items():
    # print(f"{name}:{v.shape}")
    if(name=="model.embed_tokens.weight"):
        export_state_dict[name]=v # cpu处理，不进行reshape
    elif(name=="score.weight"):
        export_state_dict[name]=v # 不进行处理
    elif(name.endswith("proj.weight")):
        weight=unpack_int8_to_int4(v) #展开为1个int8保存一个int4
        assert(len(weight.shape)==2)
        out=weight.shape[0]
        hid=weight.shape[1]
        if(name.endswith("down_proj.weight")):
            weight_tmp0=weight[:, 896*0:896*1].reshape([896//32, 32, 896]).permute([0, 2, 1]).flatten(0, 1)
            weight_tmp1=weight[:, 896*1:896*2].reshape([896//32, 32, 896]).permute([0, 2, 1]).flatten(0, 1)
            weight_tmp2=weight[:, 896*2:896*3].reshape([896//32, 32, 896]).permute([0, 2, 1]).flatten(0, 1)
            weight_tmp3=weight[:, 896*3:896*4].reshape([896//32, 32, 896]).permute([0, 2, 1]).flatten(0, 1)
            weight_tmp4=weight[:, 896*4:896*5].reshape([896//32, 32, 896]).permute([0, 2, 1]).flatten(0, 1)
            weight_tmp5=weight[:, 896*5:4864].reshape([896//32, 32, 384]).permute([0, 2, 1]).flatten(0, 1)
            weight=torch.concat((weight_tmp0, weight_tmp1, weight_tmp2, weight_tmp3, weight_tmp4, weight_tmp5), dim=0)
        else:
            weight=weight.reshape([out//32, 32, hid]).permute([0, 2, 1]) 
        weight=pack_int4_in_int8(weight) # 压缩回一个int8存两个int4
        export_state_dict[name]=weight
    elif(name.endswith("proj.weight_scale")):
        weight_scale=v.reshape([-1,64]) #马哥给的转换函数
        export_state_dict[name]=weight_scale*16
    elif(name.endswith("proj.act_scale")):

        act_scale=v.reshape([-1,64])
        # print(f"{name}:{v[:10]}")
        act_scale=act_scale*16
        export_state_dict[name]=act_scale
        
        act_scale_reciprocal=act_scale.clone()
        act_scale_reciprocal=torch.reciprocal(act_scale_reciprocal)
        export_state_dict[name+"_reciprocal"]=act_scale_reciprocal
    elif(name.endswith("norm.weight")):
        norm_weight=v.reshape([-1,64])
        export_state_dict[name]=norm_weight
    elif(name.endswith("score_scale")):
        score_scale=v.reshape(14, 6, 32).permute(1, 0, 2)
        score_scale=score_scale*16
        export_state_dict[name]=score_scale
        
        score_scale_reciprocal=score_scale.clone()
        score_scale_reciprocal=torch.reciprocal(score_scale_reciprocal)
        export_state_dict[name+"_reciprocal"]=score_scale_reciprocal
    elif(name.endswith("value_scale")):
        value_scale=torch.concat((v[:,0,:], v[:,7,:]), dim=1)
        value_scale=value_scale*16
        export_state_dict[name]=value_scale
        
        value_scale_reciprocal=value_scale.clone()
        value_scale_reciprocal=torch.reciprocal(value_scale_reciprocal)
        export_state_dict[name+"_reciprocal"]=value_scale_reciprocal
    elif(name.endswith("query_scale")):
        query_scale=v.reshape(14, 6, 32).permute(1, 0, 2)
        query_scale=query_scale*16
        export_state_dict[name]=query_scale
        
        query_scale_reciprocal=query_scale.clone()
        query_scale_reciprocal=torch.reciprocal(query_scale_reciprocal)
        export_state_dict[name+"_reciprocal"]=query_scale_reciprocal    
    elif(name.endswith("key_scale")):
        k_tmp=v.reshape(14, 6, 32)
        k=torch.concat((k_tmp[0,:,:], k_tmp[7,:,:]), dim=0)
        export_state_dict[name]=k
        
        k_tmp_for_recip=v.reshape(14, 6, 32).permute(1, 0, 2)
        k_for_recip=torch.concat((k_tmp_for_recip[:,0,:], k_tmp_for_recip[:,7,:]), dim=1)
        k_recip=torch.reciprocal(k_for_recip)
        export_state_dict[name+"_reciprocal"]=k_recip
    else:
        print(f"ERROR! Unexpected module {name}!")
        exit(0)

## ADD ROPE
rope_param=rope.reshape_rope_suparam(rope.generate_rope_suparam(1000000.0, 192, 64))
export_state_dict["rope_suparam"]=rope_param

## 输出meta
print("name\tshape\tdtype")
for name,v in export_state_dict.items():
    print(f"{name}\t{v.shape}\t{v.dtype}")
torch.save(export_state_dict,"pytorch_model.bin")