from transformers import AutoModelForCausalLM, AutoTokenizer
import torch
import ctypes
import numpy as np
import json
import argparse
from runFPGA import runThroughput

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="A description of your program")
    parser.add_argument('--hf_path', type=str, required=True, help="The path of model")
    parser.add_argument('--bench_path', type=str, required=True, help="The path of benchmark (prompt).")
    args = parser.parse_args()

    file_path = args.bench_path
    hf_path = args.hf_path
    
    model_name=hf_path
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # ########################################
    # ######## Gen tokens ########
    # ########################################
    prompt = content

    inputs = tokenizer(prompt, return_tensors="pt", padding="max_length", truncation=True, max_length=576)
    input_array = inputs["input_ids"] * inputs["attention_mask"]

    tokens_int32 = input_array.to(dtype=torch.int32)
    array = tokens_int32.view(-1).numpy()
    array_ptr = array.ctypes.data_as(ctypes.POINTER(ctypes.c_int))
    array_size = len(array)

    prompt_token_array = tokens_int32.view(-1).numpy()
    
    prefill_throughput, decode_throughput = runThroughput(prompt_token_array)
    
    # Write to json
    data={
        "prefill_toks_per_second":prefill_throughput,
        "decode_toks_per_second":decode_throughput,
    }
    print(f"prefill_toks_per_second:{prefill_throughput}\ndecode_toks_per_second:{decode_throughput}")
    with open("submit_json/throughput.json", "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
