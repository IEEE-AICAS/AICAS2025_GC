import torch
import torch.nn as nn
import torch.nn.functional as F
from transformers import set_seed,Qwen2ForCausalLM,Qwen2Tokenizer,Qwen2ForSequenceClassification
from transformers.models.qwen2.modeling_qwen2 import Qwen2Attention
from transformers.utils import logging
import datasets
from smoothquant.bmm import quantized_matmul

# set_seed(42)
model_path='/lamport/makkapakka/lilinqi/Qwen2-Instruct'
model=Qwen2ForCausalLM.from_pretrained(model_path,torch_dtype="auto",device_map="auto")
tokenizer=Qwen2Tokenizer.from_pretrained(model_path)

# for name, m in model.named_modules():
#     if(isinstance(m,Qwen2Attention)):
#         m.bmm=quantized_matmul

prompt = "Give me a short introduction to large language model."
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