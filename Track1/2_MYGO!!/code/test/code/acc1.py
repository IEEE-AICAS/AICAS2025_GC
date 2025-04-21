from transformers import AutoModelForCausalLM, AutoTokenizer    
from lm_eval.models.huggingface import HFLM    
from lm_eval import simple_evaluate    
from lm_eval import tasks
import json
import time
time0 = time.time()
model_id = "/home/yexiang/llama/model/"
filename = "qwen-q4_0.gguf"
tokenizer = AutoTokenizer.from_pretrained("./Qwen2.5-0.5B", trust_remote_code=True) 
model = AutoModelForCausalLM.from_pretrained(model_id, gguf_file=filename) 
#model = AutoModelForCausalLM.from_pretrained("./Qwen2.5-0.5B", device_map="auto", trust_remote_code=True).eval()    
#tokenizer = AutoTokenizer.from_pretrained("./Qwen2.5-0.5B", trust_remote_code=True)    
lm = HFLM(pretrained=model,tokenizer=tokenizer,batch_size=16,device="cpu")
#results = simple_evaluate(model=lm,tasks=["arc_challenge","hellaswag","piqa"])
results = simple_evaluate(model=lm,tasks=["piqa"])  
#将results中的数据导出到json文件中  
filtered_results = results.copy()  
filtered_results = {key: value for key, value in results.items() if key == "results"}  
json_filtered_results = json.dumps(filtered_results, indent=4)  
with open("result1s.json", "w") as json_file:  
    json_file.write(json_filtered_results) 
time1 = time.time()
time_cost = time1 - time0
print('results refreshed!')
print(f'Time cost for acc_test: {time_cost:.4f} seconds.')