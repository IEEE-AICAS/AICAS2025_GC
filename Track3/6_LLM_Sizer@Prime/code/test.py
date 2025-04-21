import ollama
import threading

models = ["qwen2.5:0.5b", "qwen2.5:0.5b", "qwen2.5:1.5b"]

with open("./prompt/generate_size.txt", "r") as f:
    prompt1 = f.read()
with open("./prompt/calculate_sizes.txt", "r") as f:
    prompt2 = f.read()
with open("./prompt/get_mults.txt", "r") as f:
    prompt3 = f.read()

prompts = [
    prompt1,
    prompt2,    
    prompt3
]

def call_model(model_name, prompt):
    response = ollama.generate(
        model=model_name,
        prompt=prompt,
        stream=False
    )
    print(f"模型: {model_name}\nPrompt: {prompt}\nResponse: {response['response']}\n")

# 创建并启动多个线程
threads = []
for model, prompt in zip(models, prompts):
    thread = threading.Thread(target=call_model, args=(model, prompt))
    threads.append(thread)
    thread.start()

# 等待所有线程完成
for thread in threads:
    thread.join()

print("所有模型调用完成！")