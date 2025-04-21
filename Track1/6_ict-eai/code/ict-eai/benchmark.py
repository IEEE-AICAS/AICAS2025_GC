import os
import socket
import torch  
import time  
from transformers import AutoModelForCausalLM, AutoTokenizer  
from transformers.generation import GenerationConfig  
import json
import datetime


time_str = datetime.datetime.now().strftime(r"%m%d-%H%M")
filepath = "./out_eval/temp-"+time_str+"/"
if not os.path.exists(filepath):
    os.mkdir(filepath)

#加载模型以及分词器  
print("加载模型\r\n")  
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_ip = '127.0.0.1'  # 替换为实际的服务器 IP
server_port = 5712  # 替换为实际的服务器端口
client_socket.connect((server_ip, server_port))

#加载指定文本作为prompt  
print("加载prompt\r\n")  
with open('prompt.txt', 'r', encoding='utf-8') as file:  
    prompt = file.read()  
#对prmopt进行分词  
print("分词器分词\r\n")  
prompt = "0" + prompt
print(prompt)
prompt_bytes = prompt.encode('utf-8', 'ignore')
client_socket.sendall(prompt_bytes)  
response = client_socket.recv(1024)
total_tokens = int.from_bytes(response, byteorder='little')
print(total_tokens)
# inputs = tokenizer(prompt, return_tensors='pt')  
# inputs = inputs.to(model.device)
# time.sleep(5)

# warmup
# print("warmup:\r\n")  
# prefill_type_byte = b"1"
# batch_size = 1  # 单个prompt，批次大小为1  
# total_prompts = 2  # 测试10次，可以根据实际情况调整，最少为10  
# total_prompts_byte = total_prompts.to_bytes(length=1, byteorder='little')
# client_socket.sendall(prefill_type_byte + total_prompts_byte)  
# response = client_socket.recv(1024)





#prefill阶段吞吐量测试,对inputs进行一次推理，并统计推理时间，计算公式为（测试次数*输入inputs的token总数/总推理时长）  
print("prefill阶段吞吐量测试:\r\n")  
prefill_type_byte = b"1"
batch_size = 1  # 单个prompt，批次大小为1  
total_prompts = 10  # 测试10次，可以根据实际情况调整，最少为10  
total_prompts_byte = total_prompts.to_bytes(length=1, byteorder='little')
# 发起请求，开始跑 prefill
start_time_prefill = time.time()  
client_socket.sendall(prefill_type_byte + total_prompts_byte)  
# 等待跑完
response = client_socket.recv(1024)
end_time_prefill = time.time()  
elapsed_time_prefill = end_time_prefill - start_time_prefill#推理总时长
throughput_prefill = total_prompts * total_tokens / elapsed_time_prefill  #prefill吞吐量，每秒处理的token数  
print(f"tokens总数为 {total_tokens}")  
print(f"测试次数为 {total_prompts}")  
print(f"总时长为 {elapsed_time_prefill * 1000:.2f} ms")  
print(f"模型prefill阶段的吞吐量: {throughput_prefill:.2f} tokens/s\r\n")  
print("prefill阶段吞吐量测试完成\r\n")  
# time.sleep(5)
#decode阶段吞吐量测试，输入inputs，推理出指定个数的新token，并统计推理时间，计算公式为（推理出的新token个数/总推理时长）  
print("decode阶段吞吐量测试:\r\n")  
decode_type_bytes = b"2"
max_new_tokens=50 #要推理的新token总数  
total_prompts = 10  # 测试10次，可以根据实际情况调整，最少为10  
total_prompts_byte = total_prompts.to_bytes(length=1, byteorder='little')
max_new_tokens_byte = max_new_tokens.to_bytes(length=2, byteorder='little')
start_time_decode = time.time()  
#发起 decode 请求
client_socket.sendall(decode_type_bytes + total_prompts_byte + max_new_tokens_byte)  
#等待跑完
response = client_socket.recv(1024)
end_time_decode= time.time()  
elapsed_time_decode = end_time_decode - start_time_decode               #推理总时长
throughput_decode = total_prompts * max_new_tokens/ elapsed_time_decode #decode吞吐量，每秒生成的新token数  
print(f"生成新tokens数为 {max_new_tokens}")  
print(f"测试次数为 {total_prompts}")  
print(f"总时长为 {elapsed_time_decode * 1000:.2f} ms")  
print(f"模型decode的吞吐量: {throughput_decode:.2f} tokens/s\r\n")  
print("decode阶段吞吐量测试完成\r\n")  
  
results = {  
    "prefill_throughput": throughput_prefill,  
    "decode_throughput": throughput_decode  
}  
with open(filepath+"throughput_result.json", 'w') as output_file:  
    json.dump(results, output_file, indent=4)  
print("\n已成功将吞吐量结果保存至 'throughput_result.json' 文件中.")
