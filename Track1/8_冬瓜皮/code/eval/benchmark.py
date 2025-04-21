import torch
import time
from transformers import AutoModelForCausalLM, AutoTokenizer
import json
import os

def is_arm():
    import platform
    machine = platform.machine().lower()

    if 'arm' in machine or 'aarch64' in machine:
        print("当前系统的 CPU 是 ARM 架构")
    else:
        print("当前系统的 CPU 不是 ARM 架构")
        raise ValueError("此评估代码需要在 arm 架构 cpu 上执行")

is_arm()


os.environ["CUDA_VISIBLE_DEVICES"] = "-1"

model_name_fp = "../models/Qwen2.5-0.5B"
tokenizer = AutoTokenizer.from_pretrained(model_name_fp, trust_remote_code=True)
model = AutoModelForCausalLM.from_pretrained(model_name_fp, device_map="cpu",
                                                  trust_remote_code=True).eval()


print("加载模型\r\n")

# 加载指定文本作为prompt
print("加载prompt\r\n")
with open('prompt.txt', 'r', encoding='utf-8') as file:
    prompt = file.read()

# 对prmopt进行分词
print("分词器分词\r\n")
inputs = tokenizer(prompt, return_tensors='pt')
inputs = inputs.to(model.device)


# prefill阶段吞吐量测试,对inputs进行一次推理，并统计推理时间，计算公式为（测试次数*输入inputs的token总数/总推理时长）
print("prefill阶段吞吐量测试:\r\n")
batch_size = 1  # 单个prompt，批次大小为1  
total_prompts = 1  # 测试10次，可以根据实际情况调整，最少为10  
total_tokens = inputs['input_ids'].shape[1]  # token数值为将prompt进行分词后的数量



start_time_prefill = time.time()
for _ in range(total_prompts):
    print(_)
    with torch.no_grad():  # 关闭梯度计算以提高推理性能
        outputs = model(**inputs)
        print("end")
end_time_prefill = time.time()
elapsed_time_prefill = end_time_prefill - start_time_prefill  # 推理总时长
throughput_prefill = total_prompts * total_tokens / elapsed_time_prefill  # prefill吞吐量，每秒处理的token数
print(f"tokens总数为{total_tokens}")
print(f"测试次数为{total_prompts}")
print(f"总时长为{elapsed_time_prefill}")
print(f"模型prefill阶段的吞吐量: {throughput_prefill:.2f} tokens/s\r\n")
print("prefill阶段吞吐量测试完成\r\n")

# decode阶段吞吐量测试，输入inputs，推理出指定个数的新token，并统计推理时间，计算公式为（推理出的新token个数/总推理时长）
print("decode阶段吞吐量测试:\r\n")
max_new_tokens = 50  # 要推理的新token总数
total_prompts = 10  # 测试10次，可以根据实际情况调整，最少为10  

start_time_decode = time.time()
for _ in range(total_prompts):
    with torch.no_grad():  # 关闭梯度计算以提高推理性能
        outputs = model.generate(**inputs, min_new_tokens=max_new_tokens, max_new_tokens=max_new_tokens)
        print(f"请确保生成new_tokens为50 {total_tokens} --> {outputs.shape}")
end_time_decode = time.time()
elapsed_time_decode = end_time_decode - start_time_decode  # 推理总时长
throughput_decode = total_prompts * max_new_tokens / elapsed_time_decode  # decode吞吐量，每秒生成的新token数
print(f"生成新tokens数为{max_new_tokens}")
print(f"测试次数为{total_prompts}")
print(f"总时长为{elapsed_time_decode}")
print(f"模型decode的吞吐量: {throughput_decode:.2f} tokens/s\r\n")
print("decode阶段吞吐量测试完成\r\n")

results = {
    "prefill_throughput": throughput_prefill,
    "decode_throughput": throughput_decode
}
with open('throughput_results.json', 'w') as output_file:
    json.dump(results, output_file, indent=4)
print("\n已成功将吞吐量结果保存至 'throughput_results.json' 文件中.")
