import pexpect
import time
import json
import re
import subprocess
from transformers import AutoTokenizer
from settings import *

def get_conda_environment():
    command = "conda info --envs"
    output = subprocess.check_output(command, shell=True).decode('utf-8')
    lines = output.strip().split('\n')
    for line in lines:
        if '*' in line:
            environment = line.split('*')[1].strip()
            return environment
    return None

def extract_number(text):
    # 定义正则表达式来匹配数字
    pattern = r"\d+"
    # 在字符串中搜索匹配的数字
    match = re.search(pattern, text)
    # 如果找到匹配，返回提取的数字，否则返回None
    if match:
        return int(match.group())  # 将匹配的字符串转换为整数并返回
    else:
        return None  # 没有找到数字时返回None

current_environment = get_conda_environment()
print(current_environment)

tokenizer = AutoTokenizer.from_pretrained(tokenizer_path, trust_remote_code=True)

cmd_decode = f"{main_path} -m {gguf_path} \
        -f prompt.txt \
        -c 620 -n 50 -t 8 -tb 8 \
        --ignore-eos\
        -ub 128 --no-mmap"
print("cmd_decode:", cmd_decode)

cmd_prefill = f"{main_path} -m {gguf_path} \
        -f prompt.txt \
        -c 620 -n 1 --ignore-eos -t 8 -tb 8 --predict -2\
        -ub 128 --no-mmap"
print("cmd_prefill:", cmd_prefill)



total_prompts = 10
times = []
tokens = []

print("--------------------start test decode-----------------")
child = pexpect.spawn(cmd_decode)
num=0
# 排除掉非decode输出部分,之前恰好有47个'>'
for _ in range(47):#47
    child.expect('>', timeout=None)
    

for _ in range(total_prompts + 1):
    # 模拟按下回车键
    print("press enter")
    child.sendline('\n')
    # 记录开始时间
    start_time = time.time()
    # 等待输出完成
    child.expect('>', timeout=None)
    # 记录结束时间
    end_time = time.time()
    #print(child.before.decode('utf-8'))
    inputs = tokenizer(child.before.decode('utf-8'), return_tensors='pt')  
    total_tokens = inputs['input_ids'].shape[1] 
    # 计算生成的token数量
    # 对prompt实际使用的分词器是llama.cpp的分词器
    # 这里只是为了展示确实生成了不少于50个token，所以使用transformers的分词器，和官方代码对齐
    print(f"生成的token数量为:{total_tokens}")  
    
    # tokens.append(total_tokens)
    tokens.append(50)# 为了和官方代码对齐，这里固定为50

    print("-------------------------------------------------")
    # 计算并存储生成token的时间
    times.append(end_time - start_time)

child.terminate()
# 计算平均生成token的时间
# 一共测试十一次，除去第一次的时间，来减少可能的误差
average_time = (sum(times) - times[0]) / total_prompts
decode_speed = (sum(tokens) - tokens[0]) / (sum(times) - times[0])
print(f"Average time to generate 50 tokens: {average_time} seconds")
print(f"decode throughout: {decode_speed}tokens / seconds")

#Prefill部分只进行一次测试
print("--------------------start test prefill-----------------")


child = pexpect.spawn(cmd_prefill)
# 排除掉prefill之前的输出部分,恰好有9个'>'
for _ in range(46):
    child.expect('>', timeout=None)
child.expect("<", timeout=None)
# 记录开始的时间
start_time = time.time()
child.expect(">", timeout=None)
# 记录结束的时间
end_time = time.time()
child.sendline('\n')
# 提取prefill的token数量
child.expect("T", timeout=None)
child.expect(">", timeout=None)
output_before_match = child.before.decode('utf-8') 
prefill_tokens = extract_number(output_before_match)
prefill_speed = prefill_tokens / (end_time - start_time)
print(f"total prefill tokens: {prefill_tokens}")
print(f"total time to prefill: {end_time - start_time} seconds") 
print(f"prefill throught: {prefill_speed:.2f} tokens / seconds")  

results = {
    "prefill_throughput": prefill_speed,  
    "decode_throughput": decode_speed
}

results_record = {  
    "env": current_environment,
    "prefill_throughput": prefill_speed,  
    "decode_throughput": decode_speed,
    "test_file": gguf_path,
    "test_date": time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())  
}  

with open('throughput_results.json', 'w') as output_file:  
    json.dump(results, output_file, indent=4)

with open('throughput_results_record.json', 'a') as output_file:  
    json.dump(results_record, output_file, indent=4)  
print("\n已成功将吞吐量结果保存至 'throughput_results.json' 文件中.") 




