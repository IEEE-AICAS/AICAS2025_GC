from transformers import AutoModelForCausalLM, AutoTokenizer
import torch
import ctypes
import numpy as np
import json
import argparse

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="A description of your program")
    parser.add_argument('--so_path', type=str, required=True, help="The path of C shared library.")
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
    prompt = content

    ########################################
    ######## Inference With C ########
    ########################################
    so_to_invoke = ctypes.CDLL(args.so_path)
    invoked_c_func=so_to_invoke.run_with_encode_decode
    
    #### Define Variables in Python ###
    prefill_throughput = ctypes.c_float(0)
    decode_throughput = ctypes.c_float(0)
    # max_steps
    max_steps=10000

    invoked_c_func.argtypes  =  [ctypes.c_char_p,
                                 ctypes.POINTER(ctypes.c_float),ctypes.POINTER(ctypes.c_float),
                                 ctypes.c_int]
    invoked_c_func.restype = None

    #### Invoke C ###
    invoked_c_func(prompt.encode('utf-8'),
                   prefill_throughput,decode_throughput,
                   max_steps)

    # Write to json
    data={
        "prefill_toks_per_second":prefill_throughput.value,
        "decode_toks_per_second":decode_throughput.value,
    }
    with open("submit_json/throughput.json", "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
