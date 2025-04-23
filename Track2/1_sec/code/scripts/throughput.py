import torch
import ctypes
import numpy as np
import json
import argparse
from time import time

from fpga_qwen import *
from constants import IS_LONG_CONTEXT

accelerator = QWEN_ACCELERATOR(qwen, tokenizer, S)

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="A description of your program")
    parser.add_argument('--bench_path', type=str, required=True, help="The path of benchmark (prompt).")
    args = parser.parse_args()
    ########################################
    ######## Load Prompt ###################
    ########################################

    file_path = args.bench_path

    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # ########################################
    # ######## Gen tokens ########
    # ########################################
    input_ids = tokenizer.encode(content, add_special_tokens=True)
    
    if not IS_LONG_CONTEXT:
        input_ids = input_ids[:100]
    
    pre_tok_per_sec = []
    gen_tok_per_sec = []

    cur_time = time.time()
    
    for output_ids in accelerator.generate_iter(input_ids, include_prefill=True):

        new_time = time.time()
        elapsed = new_time - cur_time
        cur_time = new_time

        if len(output_ids) > 1: 
            # this is a prefill chunk
            pre_tok_per_sec.append(len(output_ids) / elapsed)
        else:
            # this is a generation token
            assert len(output_ids) == 1
            gen_tok_per_sec.append(len(output_ids) / elapsed)
            
        output_seq = tokenizer.decode(output_ids, skip_special_tokens=False)
        print(output_seq, end="", flush=True)
        
    # calculate average speed
    avg_pre_tok_per_sec = sum(pre_tok_per_sec) / len(pre_tok_per_sec)
    avg_gen_tok_per_sec = sum(gen_tok_per_sec) / len(gen_tok_per_sec)

    ########################################
    ######## Inference With FPGA ########
    ########################################

    # Write to json
    data={
        "prefill_toks_per_second": avg_pre_tok_per_sec,
        "decode_toks_per_second" : avg_gen_tok_per_sec
    }

    with open("submit_json/throughput.json", "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
