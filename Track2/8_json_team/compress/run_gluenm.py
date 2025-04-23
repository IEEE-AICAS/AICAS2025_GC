

import torch
import torch.nn as nn
from transformers import AutoTokenizer, AutoModelForCausalLM,set_seed
from smoothquant.smooth import smooth_lm
from smoothquant.fake_quant import quantize_qwen2
import pandas as pd

def load_data(file_path):
    return pd.read_csv(file_path, sep='\t')

def evaluate_model(model,tokenizer,dataset):
    correct_predictions = 0
    total_predictions = len(dataset)
    print(f"total_predictions={total_predictions}")
    
    
    for _, data in dataset.iterrows():
        sentence1 = data['sentence1']
        sentence2 = data['sentence2']
        label = data['label']
        # prompt
        prompt = f"Sentence 1: {sentence1} Sentence 2: {sentence2} Is the second sentence entailed by the first? (1 for yes, 0 for no) you can only output 1 or 0"
        
        # Tokenize the prompt
        messages = [
            {"role": "system", "content": "You are Qwen, created by Alibaba Cloud. You are a helpful assistant."},
            {"role": "user", "content": prompt}
        ]
        text = tokenizer.apply_chat_template(
            messages,
            tokenize=False,
            add_generation_prompt=True
        )
        model_inputs = tokenizer([text], return_tensors="pt").to(model.device)

        generated_ids = model.generate(
            **model_inputs,
            max_new_tokens=512
        )
        generated_ids = [
            output_ids[len(input_ids):] for input_ids, output_ids in zip(model_inputs.input_ids, generated_ids)
        ]

        out = tokenizer.batch_decode(generated_ids, skip_special_tokens=True)[0]
        # Output only has 1 or 0
        try:
            model_prediction = int(out.strip())
        except ValueError:
            print(f"Error: {out}")
            continue
        if model_prediction == label:
            correct_predictions += 1
            print("correct")
        else:
            print("wrong")

    accuracy = correct_predictions / total_predictions
    return accuracy

# set_seed(42)
model_path = "Qwen/Qwen2.5-0.5B-Instruct"
act_scales_path = "act_scales/Qwen2.5-0.5B.pt"
alpha=0.85
tokenizer = AutoTokenizer.from_pretrained(model_path)

model = AutoModelForCausalLM.from_pretrained(
    model_path, torch_dtype=torch.bfloat16, device_map="auto"
)

act_scales = torch.load(act_scales_path)
smooth_lm(model, act_scales, alpha)#smooth之后再量化
model = quantize_qwen2(
        model,
        weight_quant="per_channel",
        act_quant="per_token",
        quantize_bmm_input=True,
        mode="SparseW8A8"
    )
prompt = "introduce yourself"
messages = [
    {"role": "system", "content": "You are Qwen, created by Alibaba Cloud. You are a helpful assistant."},
    {"role": "user", "content": prompt}
]
text = tokenizer.apply_chat_template(
    messages,
    tokenize=False,
    add_generation_prompt=True
)
model_inputs = tokenizer([text], return_tensors="pt").to(model.device)

generated_ids = model.generate(
    **model_inputs,
    max_new_tokens=512
)
generated_ids = [
    output_ids[len(input_ids):] for input_ids, output_ids in zip(model_inputs.input_ids, generated_ids)
]

response = tokenizer.batch_decode(generated_ids, skip_special_tokens=True)[0]
print(response)
# wnli_data = load_data("dev.tsv")
# acc=evaluate_model(model,tokenizer,wnli_data)
# print(acc)