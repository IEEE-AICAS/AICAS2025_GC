import llama_cpp

import time


def is_arm():
    import platform
    machine = platform.machine().lower()

    if 'arm' in machine or 'aarch64' in machine:
        print("当前系统的 CPU 是 ARM 架构")
    else:
        print("当前系统的 CPU 不是 ARM 架构")
        raise ValueError("此评估代码需要在 arm 架构 cpu 上执行")

is_arm()

params = {
    "n_ctx": 768,                      
    "n_batch": 64,                     
    "n_ubatch": 64,                    
    "n_threads": 8,                     
    "n_threads_batch": 8,               
    "type_k": 8,                        
    "type_v": 1,                     
    "verbose": False, 
}



model = llama_cpp.Llama(
    model_path="../models/quant/Qwen2.5-0.5B_8bit_200iters_256samples/Qwen2.5-0.5B-494M-Q8_0.gguf",
    **params
)

with open('prompt.txt', 'r', encoding='utf-8') as file:
    prompt = file.read()

print("prefill阶段吞吐量测试:\r\n")
batch_size = 1  # 单个prompt，批次大小为1  
total_prompts = 1  # 测试10次，可以根据实际情况调整，最少为10

total_tokens = 560
start_time_prefill = time.time()
for _ in range(total_prompts):
    outputs = model(prompt, max_tokens=1)
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

tokens = model.tokenize(str(prompt).encode("utf-8"))


class MinMaxNewTokensStoppingCriteria:
    def __init__(self, start_length: int, min_new_tokens: int, max_new_tokens: int):
        """
        :param min_new_tokens: 至少需要生成的新 token 数量
        :param max_new_tokens: 最多允许生成的新 token 数量
        """
        self.start_length = start_length
        self.min_new_tokens = min_new_tokens
        self.max_new_tokens = max_new_tokens

    def __call__(self, input_ids, logits) -> bool:
        # 当前整个序列的长度
        current_length = input_ids.shape[-1]
        # 已生成的新 token 数量
        generated_tokens = current_length - self.start_length

        # 如果还没有达到最小生成要求，永远不停止
        if generated_tokens < self.min_new_tokens:
            return False

        # 达到或超过最大新 token 数量时，停止生成
        if generated_tokens >= self.max_new_tokens:
            return True

        # 否则继续生成
        return False


min_max_criteria = MinMaxNewTokensStoppingCriteria(total_tokens, max_new_tokens, max_new_tokens)
stopping_criteria_list = min_max_criteria

start_time_decode = time.time()
for _ in range(total_prompts):
    count = sum(1 for _ in model.generate(tokens, stopping_criteria=stopping_criteria_list))
    # model.generate(tokens, stopping_criteria=stopping_criteria_list)
    print(f"请确保生成new_tokens为50 {total_tokens} --> {count}")
end_time_decode = time.time()
elapsed_time_decode = end_time_decode - start_time_decode  # 推理总时长
throughput_decode = total_prompts * max_new_tokens / elapsed_time_decode  # decode吞吐量，每秒生成的新token数
print(f"生成新tokens数为{max_new_tokens}")
print(f"测试次数为{total_prompts}")
print(f"总时长为{elapsed_time_decode}")
print(f"模型decode的吞吐量: {throughput_decode:.2f} tokens/s\r\n")
print("decode阶段吞吐量测试完成\r\n")

import json
results = {
    "prefill_throughput": throughput_prefill,
    "decode_throughput": throughput_decode
}
with open('throughput_results.json', 'w') as output_file:
    json.dump(results, output_file, indent=4)
print("\n已成功将吞吐量结果保存至 'throughput_results.json' 文件中.")
