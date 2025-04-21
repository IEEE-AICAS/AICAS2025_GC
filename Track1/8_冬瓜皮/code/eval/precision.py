import torch
from transformers import AutoModelForCausalLM, AutoTokenizer
from lm_eval.models.huggingface import HFLM
from lm_eval import simple_evaluate
from lm_eval import tasks
from basic import SEED, fp_model_path
from basic import trust_remote_code
import json
from transformers import set_seed

set_seed(SEED)


model_name = fp_model_path

quantization_config.backend = "cuda"
result_path = "results.json"


model = AutoModelForCausalLM.from_pretrained(model_name, device_map="auto",
                                                trust_remote_code=trust_remote_code).eval()

tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=trust_remote_code)


lm = HFLM(pretrained=model, tokenizer=tokenizer, batch_size=16, device="gpu:0")

results = simple_evaluate(model=lm, tasks=["arc_challenge", "hellaswag", "ceval-valid"])

# 将results中的数据导出到json文件中

filtered_results = results.copy()

filtered_results = {key: value for key, value in results.items() if key == "results"}

json_filtered_results = json.dumps(filtered_results, indent=4)

with open(result_path, "w") as json_file:
    json_file.write(json_filtered_results)
