import pandas as pd
import os
import sys
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch
import ctypes
import numpy as np
import json
import argparse
from rich.progress import Progress, TextColumn, BarColumn, TaskProgressColumn
from rich.columns import Columns
from rich.console import Console

def infer(prompt,max_gen_step,hf_path,so_path):
    assert max_gen_step>0
    # ########################################
    # ######## Gen tokens ########
    # ########################################
    model_name=hf_path
    tokenizer = AutoTokenizer.from_pretrained(model_name)

    messages = [
        {"role": "system", "content": "You are Qwen, created by Alibaba Cloud. You are a helpful assistant."},
        {"role": "user", "content": prompt}
    ]
    tokens = tokenizer.apply_chat_template(
        messages,
        tokenize=False,
        add_generation_prompt=True
    )
    model_inputs = tokenizer([tokens], return_tensors="pt",padding=False)

    tokens_int32 = model_inputs["input_ids"].to(dtype=torch.int32)
    array = tokens_int32.view(-1).numpy()
    array_ptr = array.ctypes.data_as(ctypes.POINTER(ctypes.c_int))
    array_size = len(array)

    ########################################
    ######## Inference With C ##############
    ########################################
    # Load shared library


    #so_to_invoke = ctypes.CDLL(so_path,winmode=0)
    so_to_invoke = ctypes.CDLL(so_path)
    invoked_c_func=so_to_invoke.run_without_encode_decode

    #### Define Variables in Python ###
    # prompt tokens
    prompt_token_array = tokens_int32.view(-1).numpy()
    prompt_token_array_len = len(prompt_token_array)
    prompt_token_array = prompt_token_array.ctypes.data_as(ctypes.POINTER(ctypes.c_int))
    # output token
    response_token_array = (ctypes.c_int * max_gen_step)()
    response_token_array_len=ctypes.c_int(10)
    # max_steps
    max_steps=max_gen_step
    # C can not print
    c_print = ctypes.c_bool(False)

    #### Define Variables in C ###
    invoked_c_func.argtypes  =  [ctypes.POINTER(ctypes.c_int),ctypes.c_int,
                                 ctypes.POINTER(ctypes.c_int),ctypes.POINTER(ctypes.c_int),
                                 ctypes.c_bool,ctypes.c_int]

    invoked_c_func.restype = None

    #### Invoke C ###
    # print("Begin invoke.")
    invoked_c_func(prompt_token_array,prompt_token_array_len,
                   response_token_array,response_token_array_len,
                   c_print,max_steps)


    #######################################
    ####### Deal with Returned Array ######
    #######################################
    response_token_len=response_token_array_len.value
    response_token_list = [response_token_array[i] for i in range(response_token_len)]
    response_token_tensor = torch.tensor(response_token_list, dtype=torch.int32)

    response = tokenizer.decode(response_token_tensor, skip_special_tokens=True)

    return response


def evaluate_model(dataset,hf_path,so_path):
    correct_predictions = 0

    #The program may run into crash at iterations >70, so we can divide total 635 testing task into sperate subsets, and calculate accuracy afterwards. it would not affect final accuracy.
    subset = dataset.iloc[:635]  
    total_predictions = len(subset)
    print(f"total_predictions={total_predictions}")
    

    finish_cnt=0
    with Progress(
        TextColumn("[bold green]{task.description}"),
        BarColumn(),
        TaskProgressColumn(),
        TextColumn("{task.completed}/{task.total} tasks completed"),
    ) as progress:
        
        task = progress.add_task("[bold green]Evaluation ", total=total_predictions)

        

        for _, data in subset.iterrows():
            
            sentence1 = data['sentence1']
            sentence2 = data['sentence2']
            label = data['label']

            # prompt
            prompt = f"Sentence 1: {sentence1} Sentence 2: {sentence2} Is the second sentence entailed by the first? (1 for yes, 0 for no) you can only output 1 or 0"
            
            out = infer(prompt, 1000,hf_path,so_path)

            # Output only has 1 or 0
            model_prediction = int(out.strip())

            if model_prediction == label:
                correct_predictions += 1

            finish_cnt+=1
            progress.update(task, completed=finish_cnt,description="Evaluation ")

    accuracy = correct_predictions / total_predictions
    return accuracy,correct_predictions,total_predictions


def load_data(file_path):
    return pd.read_csv(file_path, sep='\t')

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="A description of your program")
    parser.add_argument('--hf_path', type=str, required=False, help="The path of Qwen hf model path.", default='/home/ubuntu/workfile/AICAS/Qwen-2.5B-INT8')
    parser.add_argument('--so_path', type=str, required=False, help="The path of.so",default='./libtest_fpga.so') 
    parser.add_argument('--bench_path', type=str, required=False, help="The path of tsv",default='eva/final.tsv')
    args = parser.parse_args()


    # .tsv is benchmark
    file_path = args.bench_path
    wnli_data = load_data(file_path)

    # eva
    accuracy,correct_predictions,total_predictions = evaluate_model(wnli_data,args.hf_path,args.so_path)

    # Write to json
    data={
    "acc":accuracy,
    }

    with open("submit_json/acc.json", "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

    print(f"Model Accuracy: {accuracy:.2f}, correct_predictions:{correct_predictions},total_predictions:{total_predictions}")
