# this ACC is modified by Chinese DALISHI Group for our FPGA

import pandas as pd
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch
import ctypes
import numpy as np
import json
import argparse
from rich.progress import Progress, TextColumn, BarColumn, TaskProgressColumn
from rich.columns import Columns
from rich.console import Console
from runFPGA import runInfer

def infer(prompt,hf_path):
    model_name=hf_path
    tokenizer = AutoTokenizer.from_pretrained(model_name)

# #     messages = [
#         {"role": "system", "content": "You are Qwen, created by Alibaba Cloud. You are a helpful assistant."},
#         {"role": "user", "content": prompt}
#     ]
#     tokens = tokenizer.apply_chat_template(
#         messages,
#         tokenize=False,
#         add_generation_prompt=True
#     )
    inputs = tokenizer(prompt, return_tensors="pt", padding="max_length", truncation=True, max_length=192)
    
    input_array = inputs["input_ids"] * inputs["attention_mask"]

    tokens_int32 = input_array.to(dtype=torch.int32)
    array = tokens_int32.view(-1).numpy()
    array_ptr = array.ctypes.data_as(ctypes.POINTER(ctypes.c_int))
    array_size = len(array)

    prompt_token_array = tokens_int32.view(-1).numpy()

    
    output = runInfer(prompt_token_array)

    return output


def evaluate_model(dataset,hf_path):
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
            
            # Output only has 1 or 0
            print(f"Golden label = {data['label']}")
            out = infer(prompt,hf_path)
            model_prediction = int(out)

            if model_prediction == label:
                correct_predictions += 1
                print("correct +1")
            else:
                print("incorrect +1")
            finish_cnt+=1
            print(f"rate = {correct_predictions} / {finish_cnt} = {correct_predictions/finish_cnt}")
            progress.update(task, completed=finish_cnt,description="Evaluation ")

    accuracy = correct_predictions / total_predictions
    return accuracy


def load_data(file_path):
    return pd.read_csv(file_path, sep='\t')

if __name__ == "__main__":
    
    np.seterr(over='ignore')
    
    parser = argparse.ArgumentParser(description="A description of your program")
    parser.add_argument('--hf_path', type=str, required=True, help="The path of Qwen hf model path.")
    parser.add_argument('--bench_path', type=str, required=True, help="The path of benchmark (dev.tsv).")
    args = parser.parse_args()
    
    hf_path = args.hf_path
    
    # dev.tsv is benchmark
    file_path = args.bench_path
    wnli_data = load_data(file_path)

    # eva
    accuracy = evaluate_model(wnli_data,hf_path)

    # Write to json
    data={
    "acc":accuracy,
    }

    with open("submit_json/acc.json", "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

    print(f"Model Accuracy: {accuracy:.2f}")
