import pandas as pd
import math
import os
from typing import Union, List, Tuple
import numpy as np
from copy import deepcopy
from transformers import AutoModelForCausalLM, AutoTokenizer, Qwen2ForCausalLM, Qwen2Tokenizer
import torch
import ctypes
import numpy as np
import json
import argparse
from rich.progress import Progress, TextColumn, BarColumn, TaskProgressColumn
from rich.columns import Columns
from rich.console import Console
import pdb
from model.int_qwen import replace_decoders, replace_norm, replace_lm_head
from transformers.models.llama.modeling_llama import LlamaConfig
from transformers import PretrainedConfig

from model.fake_quant import Quantizer

DEVICE = "cuda:6"

def infer(prompt, max_gen_step, model, tokenizer):
    assert max_gen_step>0

    messages = [
        {"role": "system", "content": "You are Qwen, created by Alibaba Cloud. You are a helpful assistant."},
        {"role": "user", "content": prompt}
    ]
    tokens = tokenizer.apply_chat_template(
        messages,
        tokenize=False,
        add_generation_prompt=True
    )
    model_inputs = tokenizer([tokens], return_tensors="pt",padding=False).to(DEVICE)

    max_steps=max_gen_step

    generated_ids = model.generate(
        **model_inputs,
        max_new_tokens=max_steps,
        # top_k=1,
        # top_p=0.0,
        # repetition_penalty=1,
        # past_key_values=None,
        do_sample=False,
    )

    generated_ids = [
        output_ids[len(input_ids):] for input_ids, output_ids in zip(model_inputs.input_ids, generated_ids)
    ]

    response = tokenizer.batch_decode(generated_ids, skip_special_tokens=True)[0]

    return response


def evaluate_model(dataset, model, tokenizer):
    correct_predictions = 0
    total_predictions = len(dataset)
    print(f"total_predictions={total_predictions}")
    

    finish_cnt=0
    with Progress(
        TextColumn("[bold green]{task.description}"),
        BarColumn(),
        TaskProgressColumn(),
        TextColumn("{task.completed}/{task.total} tasks completed"),
    ) as progress:
        
        task = progress.add_task("[bold green]Evaluation ", total=total_predictions)

        for _, data in dataset.iterrows():
            sentence1 = data['sentence1']
            sentence2 = data['sentence2']
            label = data['label']

            # prompt
            prompt = f"Sentence 1: {sentence1} Sentence 2: {sentence2} Is the second sentence entailed by the first? (1 for yes, 0 for no) you can only output 1 or 0"
            
            out = infer(prompt, 1000, model,tokenizer)

            # Output only has 1 or 0
            
            # have "NO" result instead
            model_prediction = out.strip()
            print(f"Sent1: {sentence1}, Sent2: {sentence2}, model_prediction={model_prediction}, label={label}")

            try:
                model_prediction = int(model_prediction)
            except:
                raise ValueError(f"Model output is not 1 or 0: {model_prediction}")

            if model_prediction == label:
                correct_predictions += 1

            finish_cnt+=1
            progress.update(task, completed=finish_cnt,description="Evaluation ")

    accuracy = correct_predictions / total_predictions
    return accuracy


def load_data(file_path):
    return pd.read_csv(file_path, sep='\t')



if __name__ == "__main__":
    # dev.tsv is benchmark
    file_path = "dev.tsv"
    wnli_data = load_data(file_path)

    QWEN_PATH = "/home/gqy/models/Qwen2.5-0.5B-Instruct"
    tokenizer = Qwen2Tokenizer.from_pretrained(QWEN_PATH)
    model_cpu = Qwen2ForCausalLM.from_pretrained(QWEN_PATH, torch_dtype=torch.float32)
    ref_model = deepcopy(model_cpu).to(DEVICE)
    int_model = deepcopy(model_cpu).to(DEVICE)
    
    replace_decoders(int_model, DEVICE)
    replace_norm    (int_model, DEVICE)
    replace_lm_head (int_model, DEVICE)

    # accuracy = evaluate_model(wnli_data, ref_model, tokenizer)
    accuracy = evaluate_model(wnli_data, int_model, tokenizer)

    data={
        "acc":accuracy,
    }

    print(f"Model Accuracy: {accuracy:.4f}")
