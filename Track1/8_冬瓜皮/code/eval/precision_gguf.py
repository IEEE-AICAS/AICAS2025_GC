import torch
from transformers import AutoModelForCausalLM, AutoTokenizer
from lm_eval.models.huggingface import HFLM
from lm_eval import simple_evaluate
from lm_eval import tasks
from basic import SEED, my_set_seed
from basic import trust_remote_code
from basic import my_set_seed, fp_model_path, quant_model_abs, model_name
import json
from transformers import set_seed
import os

set_seed(SEED)


gguf_model_path = os.path.join(quant_model_abs, model_name + "_8bit_200iters_256samples")

quant_model_name = "Qwen2.5-0.5B-494M-Q8_0.gguf"

result_path = "results.json"

print(gguf_model_path, quant_model_name)

model = AutoModelForCausalLM.from_pretrained(gguf_model_path, gguf_file=quant_model_name, device_map="auto",
                                            trust_remote_code=trust_remote_code).eval()

tokenizer = AutoTokenizer.from_pretrained(gguf_model_path, gguf_file=quant_model_name, trust_remote_code=trust_remote_code)


lm = HFLM(pretrained=model, tokenizer=tokenizer, batch_size=16, device="gpu:0")

results = simple_evaluate(model=lm, tasks=["arc_challenge", "hellaswag", "ceval-valid"])

# 将results中的数据导出到json文件中

filtered_results = results.copy()

filtered_results = {key: value for key, value in results.items() if key == "results"}

json_filtered_results = json.dumps(filtered_results, indent=4)

with open(result_path, "w") as json_file:
    json_file.write(json_filtered_results)
