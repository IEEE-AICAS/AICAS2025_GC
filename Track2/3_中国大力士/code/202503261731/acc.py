# this ACC is modified by Chinese DALISHI Group for our FPGA
from pynq import Overlay
from pynq import allocate
from pynq.lib.dma import DMA
import pynq
import os
import mmap
import time

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

# def infer(prompt,hf_path):
#     model_name=hf_path
#     tokenizer = AutoTokenizer.from_pretrained(model_name)
    
#     # tokens = 192 is just for acc.py, in throughput-test cases we use 576
#     inputs = tokenizer(prompt, return_tensors="pt", padding="max_length", truncation=True, max_length=192)
    
#     # now we handle the input array
#     input_array = inputs["input_ids"] * inputs["attention_mask"]
#     tokens_int32 = input_array.to(dtype=torch.int32)
#     array = tokens_int32.view(-1).numpy()
#     array_ptr = array.ctypes.data_as(ctypes.POINTER(ctypes.c_int))
#     array_size = len(array)
#     prompt_token_array = tokens_int32.view(-1).numpy()

#     # find the last token index
#     for i in range(len(prompt_token_array)):
#         if prompt_token_array[i] == 0:
#             last_index = i + 1
#             break
    
#     # get the output
#     output = runAcc(prompt_token_array, last_index)

#     return output


def evaluate_model(dataset,hf_path, model_bin_path="model/model.bin", overlay_path="overlay/system.bit"):
    correct_predictions = 0
    total_predictions = len(dataset)
    print(f"total_predictions={total_predictions}")
    

    # for high-speed, we directly infer the model here instead of using any other function
    model_name=hf_path
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    
    
    # get the FPGA system files
    overlay=Overlay(overlay_path)
    overlay.ip_dict
    
    # parameters of model
    SEQUENCE_LEN = 192
    HIDDEN_DIM = 896
    
    ###########################
    # now we need to allocate the buffers for everything
    # We have 4GB ddr totally(2^^30)
    
    # for ddr_array
    allocated_size = 512 * 1024 * 1024 # 512MB for params(actually we just need 431MB, other MB for reserved)
    ddr_array = allocate(allocated_size, dtype=np.uint8,cacheable=1) #512MB
    with open("./workspace/pynq_alloc_phys_addr.txt", "w") as f:
        f.write(str(ddr_array.device_address))
    
    # for acc input
    input_buffer=allocate(shape=(SEQUENCE_LEN*HIDDEN_DIM*2),dtype='uint8',cacheable=1)
    with open("./workspace/embedding_address.txt", "w") as f:
        f.write(str(input_buffer.device_address))

    # for acc output
    output_buffer=allocate(shape=(SEQUENCE_LEN*HIDDEN_DIM*2),dtype='uint8',cacheable=1) # for output
    with open("./workspace/result_address.txt", "w") as f:
        f.write(str(output_buffer.device_address))
    
    for i in range(SEQUENCE_LEN*HIDDEN_DIM*2):
        output_buffer[i]=0
        
    ###########################
    # load model.bin into DDR(ddr_array)
    
    # for record
    metadata = {}
    current_index = 0

    # loading...
    data = torch.load(model_bin_path, map_location=torch.device("cpu"))

    for key, tensor in data.items():
        arr = tensor.cpu().numpy().flatten()
        if arr.dtype == np.float16:
            data_bytes = arr.tobytes()
            num_bytes = len(data_bytes)  
            data_uint8 = np.frombuffer(data_bytes, dtype=np.uint8)
            # here the float16 will be seperate into HIGH8bit and LOW8bit, in the ddr array, it will be ddr[0]= LOW8bit, ddr[1]= HIGH8bit
        elif arr.dtype == np.int8 or arr.dtype == np.uint8:
            num_bytes = arr.size
            data_uint8 = arr.astype(np.uint8)
        else:
            raise ValueError(f"unsupport dtype: {arr.dtype} (key: {key})")
        
        if current_index + num_bytes > allocated_size:
            raise MemoryError("ddr area full")

        ddr_array[current_index: current_index + num_bytes] = data_uint8
        
        metadata[key] = {
            "index": current_index,
            "num": num_bytes
        }
        
        current_index += num_bytes

    print("[DONE: locate to ddr ddr_array]")
    
    with open("workspace/metadata.txt", "w") as f:
        for key, value in metadata.items():
            line = f"{key}:{value['index']},{value['num']}\n"
            f.write(line)

    print("[Generate metadata.txt]")

    ############################################################
    # 
    # Following is the QWEN computing codes after compilation
    #
    ############################################################

    # Define address
    IP_BASEADDR = 0xa1000000
    DDR_BASE = ddr_array.device_address
    PARAM_BASE = 0x500000
    PARAM_SIZE = 0x200000 # we just use 2MB for safety, actually we have total 2.25MB, after 2MB is ROPE_BASE
    ROPE_BASE = 0x420000
    ROPE_SIZE = 0x6000 # from metadata.txt, 24576 B
    PARAM_SCALE_BASE = 0x426000
    PARAM_SCALE_SIZE = 0xa000
    ACT_SCALE_BASE = 0x460000
    ACT_SCALE_SIZE = 0x8000
    k_cache_address = 0xa0800000
    v_cache_address = 0xa0812000
    
    MLP_w_address0 = 0x0
    MLP_w_address1 = 0x65000
    # Define metadata searching function
    def return_meta(key):
        return metadata[key]["index"], metadata[key]["num"]

    # define the instrcution list
    instrcution_list = []
    
    # define the params' name for searching the metadata dict
    q_weight = ".self_attn.q_proj.weight"
    q_weight_scale = ".self_attn.q_proj.weight_scale"
    q_act_scale = ".self_attn.q_proj.act_scale"
    q_act_scale_recip = ".self_attn.q_proj.act_scale_reciprocal"
    k_weight = ".self_attn.k_proj.weight"
    k_weight_scale = ".self_attn.k_proj.weight_scale"
    k_act_scale = ".self_attn.k_proj.act_scale"
    k_act_scale_recip = ".self_attn.k_proj.act_scale_reciprocal"
    v_weight = ".self_attn.v_proj.weight"
    v_weight_scale = ".self_attn.v_proj.weight_scale"
    v_act_scale = ".self_attn.v_proj.act_scale"
    v_act_scale_recip = ".self_attn.v_proj.act_scale_reciprocal"
    o_weight = ".self_attn.o_proj.weight"
    o_weight_scale = ".self_attn.o_proj.weight_scale"
    o_act_scale = ".self_attn.o_proj.act_scale"
    o_act_scale_recip = ".self_attn.o_proj.act_scale_reciprocal"
    bmm1_query_scale = ".self_attn.bmm1.query_scale"
    bmm1_query_scale_recip = ".self_attn.bmm1.query_scale_reciprocal"
    bmm1_key_scale = ".self_attn.bmm1.key_scale"
    bmm1_key_scale_recip = ".self_attn.bmm1.key_scale_reciprocal"
    bmm2_score_scale = ".self_attn.bmm2.score_scale"
    bmm2_score_scale_recip = ".self_attn.bmm2.score_scale_reciprocal"
    bmm2_value_scale = ".self_attn.bmm2.value_scale"
    bmm2_value_scale_recip = ".self_attn.bmm2.value_scale_reciprocal"
    gate_weight = ".mlp.gate_proj.weight"
    gate_weight_scale = ".mlp.gate_proj.weight_scale"
    gate_act_scale = ".mlp.gate_proj.act_scale"
    gate_act_scale_recip = ".mlp.gate_proj.act_scale_reciprocal"
    up_weight = ".mlp.up_proj.weight"
    up_weight_scale = ".mlp.up_proj.weight_scale"
    up_act_scale = ".mlp.up_proj.act_scale"
    up_act_scale_recip = ".mlp.up_proj.act_scale_reciprocal"
    down_weight = ".mlp.down_proj.weight"
    down_weight_scale = ".mlp.down_proj.weight_scale"
    down_act_scale = ".mlp.down_proj.act_scale"
    down_act_scale_recip = ".mlp.down_proj.act_scale_reciprocal"
    input_norm_weight = ".input_layernorm.weight"
    post_norm_weight = ".post_attention_layernorm.weight"

    rope = "rope_suparam"
    score_weight = "score.weight"
    last_norm = "model.norm.weight"


    # we have several functions: dma, norm, k_proj, v_proj, q_proj, attention, o_proj, mlp0_17, mlp18, check_task
    # and we will use string to act as the functions in the following format " Function_name:param0,param1,param2...."
    # and then we will print it into a file in /workspace

    # First use DMA to transfter rope weight
    rope_address, rope_size = return_meta(key)
    instrcution_list.append(("dma",[DDR_BASE+rope_address,ROPE_BASE,rope_size]))

    dma_src_address = 0
    dma_size = 0
    param_address = 0
    param_scale_address = ROPE_SIZE
    act_scale_address = 0
    
    id = 0 # just for compute OPs, not for DMA.
    
    seq_len = 192
    seq_len_tot = 192
    
    for i in range(24):
        layer = f"model.layers.{i}" 
        if i == 0:
            
            # for layer 0, there is an extra norm and extra transformation for VKQ params and attention's scale params
            q_a_scale_recip = layer + q_act_scale_recip
            dma_src_address, dma_size = return_meta(q_a_scale_recip)
            q_a_recip_address = ACT_SCALE_BASE + act_scale_address
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, q_a_recip_address, dma_size]))
            act_scale_address += dma_size
            
            input_n_weight = layer + input_norm_weight
            dma_src_address, dma_size = return_meta(input_n_weight)
            input_n_weight_address = PARAM_SCALE_BASE + param_scale_address
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, input_n_weight_address, dma_size]))
            param_scale_address += dma_size
            
            instrcution_list.append(("norm",[id, seq_len, q_a_recip_address,input_n_weight_address]))
            instrcution_list.append(("check",[id]))
            
            id += 1
            if id > 65486:
                id = 0
                
            param_address = 0
            param_scale_address = ROPE_SIZE
            act_scale_address = 0
        
        
            # then we need to transfer all the params for VKQ first for layer 0.
            # after that, we will start to compute VK in the pipeline pattern.
            
            # transfer V in layer0
            v_w = layer + v_weight
            dma_src_address, dma_size = return_meta(v_w)
            v_w_address = PARAM_BASE + param_address
            param_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, v_w_address, dma_size]))
            
            v_a_s = layer + v_act_scale
            dma_src_address, dma_size = return_meta(v_a_s)
            v_a_s_address = ACT_SCALE_BASE + act_scale_address
            act_scale_address += dma_size
            instrcution_list.append(("dma", [DDR_BASE+dma_src_address, v_a_s_address, dma_size]))
            
            v_w_s = layer + v_weight_scale
            dma_src_address, dma_size = return_meta(v_w_s)
            v_w_s_address = PARAM_SCALE_BASE + param_scale_address
            param_scale_address += dma_size
            instrcution_list.append(("dma", [DDR_BASE+dma_src_address, v_w_s_address, dma_size]))
            
            bm2_v_s_recip = layer + bmm2_value_scale_recip
            dma_src_address, dma_size = return_meta(bm2_v_s_recip)
            bm2_v_s_recip_address = PARAM_SCALE_BASE + param_scale_address
            param_scale_address += dma_size
            instrcution_list.append(("dma", [DDR_BASE+dma_src_address, bm2_v_s_recip_address, dma_size]))
            
            # transfer K in layer0
            k_w = layer + k_weight
            dma_src_address, dma_size = return_meta(k_w)
            k_w_address = PARAM_BASE + param_address
            param_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, k_w_address, dma_size]))
            
            k_a_s = layer + k_act_scale
            dma_src_address, dma_size = return_meta(k_a_s)
            k_a_s_address = ACT_SCALE_BASE + act_scale_address
            act_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, k_a_s_address, dma_size]))
            
            k_w_s = layer + k_weight_scale
            dma_src_address, dma_size = return_meta(k_w_s)
            k_w_s_address = PARAM_SCALE_BASE + param_scale_address
            param_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, k_w_s_address, dma_size]))
            
            bm1_k_s_recip = layer + bmm1_key_scale_recip
            dma_src_address, dma_size = return_meta(bm1_k_s_recip)
            bm1_k_s_recip_address = ACT_SCALE_BASE + act_scale_address
            act_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, bm1_k_s_recip_address, dma_size]))
            
            # transfer Q in layer0
            q_w = layer + q_weight
            dma_src_address, dma_size = return_meta(q_w)
            q_w_address = PARAM_BASE + param_address
            param_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, q_w_address, dma_size]))
            
            q_a_s = layer + q_act_scale
            dma_src_address, dma_size = return_meta(q_a_s)
            q_a_s_address = ACT_SCALE_BASE + act_scale_address
            act_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, q_a_s_address, dma_size]))
            
            q_w_s = layer + q_weight_scale
            dma_src_address, dma_size = return_meta(q_w_s)
            q_w_s_address = PARAM_SCALE_BASE + param_scale_address
            param_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, q_w_s_address, dma_size]))
            
            bm1_q_s_recip = layer + bmm1_query_scale_recip
            dma_src_address, dma_size = return_meta(bm1_q_s_recip)
            bm1_q_s_recip_address = ACT_SCALE_BASE + act_scale_address
            act_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, bm1_q_s_recip_address, dma_size]))

            # transfer attention in layer0
            bm1_q_s = layer + bmm1_query_scale
            dma_src_address, dma_size = return_meta(bm1_q_s)
            bm1_q_s_address = ACT_SCALE_BASE + act_scale_address
            act_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, bm1_q_s_address, dma_size]))
            
            bm1_k_s = layer + bmm1_key_scale
            dma_src_address, dma_size = return_meta(bm1_k_s)
            bm1_k_s_address = PARAM_SCALE_BASE + param_scale_address
            param_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, bm1_k_s_address, dma_size]))
            
            bm2_s_s_recip = layer + bmm2_score_scale_recip
            dma_src_address, dma_size = return_meta(bm2_s_s_recip)
            bm2_s_s_recip_address = ACT_SCALE_BASE + act_scale_address
            act_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, bm2_s_s_recip_address, dma_size]))
            
            bm2_s_s = layer + bmm2_score_scale
            dma_src_address, dma_size = return_meta(bm2_s_s)
            bm2_s_s_address = ACT_SCALE_BASE + act_scale_address
            act_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, bm2_s_s_address, dma_size]))
            
            bm2_v_s = layer + bmm2_value_scale
            dma_src_address, dma_size = return_meta(bm2_v_s)
            bm2_v_s_address = PARAM_SCALE_BASE + param_scale_address
            param_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, bm2_v_s_address, dma_size]))
            
            o_a_s_recip = layer + o_act_scale_recip
            dma_src_address, dma_size = return_meta(o_a_s_recip)
            o_a_s_recip_address = ACT_SCALE_BASE + act_scale_address
            act_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, o_a_s_recip_address, dma_size]))
            
        # for all layers, first compute QKV
        # compute V
        instrcution_list.append(("v_proj",[id, seq_len, seq_len_tot, v_w_address, v_cache_address, v_a_s_address, v_w_s_address, bm2_v_s_recip_address]))
        instrcution_list.append(("check",[id]))
        id += 1
        if id > 65486:
            id = 0
        # compute K
        instrcution_list.append(("k_proj",[id, seq_len, seq_len_tot, k_w_address, k_cache_address, k_a_s_address, k_w_s_address, bm1_k_s_recip_address, ROPE_BASE]))
        instrcution_list.append(("check",[id]))
        id += 1
        if id > 65486:
            id = 0
        # compute Q
        instrcution_list.append(("q_proj",[id, seq_len, seq_len_tot, q_w_address, q_a_s_address, q_w_s_address, bm1_q_s_recip_address, ROPE_BASE]))
        instrcution_list.append(("check",[id]))   
        id += 1
        if id > 65486:
            id = 0
        # compute Attention(and transfer O_proj params)
        instrcution_list.append(("attention",[id, seq_len, seq_len_tot, k_cache_address, bm1_q_s_address, bm1_k_s_address, bm2_s_s_recip_address, v_cache_address, bm2_s_s_address, bm2_v_s_address, o_a_s_recip_address]))
        
        param_address = 0
        param_scale_address = ROPE_SIZE
        act_scale_address = 0
        
        o_w = layer + o_weight
        dma_src_address, dma_size = return_meta(o_w)
        o_w_address = PARAM_BASE + param_address
        param_address += dma_size
        instrcution_list.append(("dma",[DDR_BASE+dma_src_address, o_w_address, dma_size]))
        
        o_a_s = layer + o_act_scale
        dma_src_address, dma_size = return_meta(o_a_s)
        o_a_s_address = ACT_SCALE_BASE + act_scale_address
        act_scale_address += dma_size
        instrcution_list.append(("dma",[DDR_BASE+dma_src_address, o_a_s_address, dma_size]))
        
        o_w_s = layer + o_weight_scale
        dma_src_address, dma_size = return_meta(o_w_s)
        o_w_s_address = PARAM_SCALE_BASE + param_scale_address
        param_scale_address += dma_size
        instrcution_list.append(("dma",[DDR_BASE+dma_src_address, o_w_s_address, dma_size]))
        
        g_a_s_recip = layer + gate_act_scale_recip
        dma_src_address, dma_size = return_meta(g_a_s_recip)
        g_a_s_recip_address = ACT_SCALE_BASE + act_scale_address
        act_scale_address += dma_size
        instrcution_list.append(("dma",[DDR_BASE+dma_src_address, g_a_s_recip_address, dma_size]))
        
        p_ln_w = layer + post_norm_weight
        dma_src_address, dma_size = return_meta(p_ln_w)
        p_ln_w_address = PARAM_SCALE_BASE + param_scale_address
        param_scale_address += dma_size
        instrcution_list.append(("dma",[DDR_BASE+dma_src_address, p_ln_w_address, dma_size]))
        
        instrcution_list.append(("check",[id+27]))   
        id += 28
        if id > 65486:
            id = 0
        
        ####### 
        # compute attention out proj and transfer MLP0
        instrcution_list.append(("o_proj",[id, seq_len, o_w_address,o_a_s_address,o_w_s_address,g_a_s_recip_address,p_ln_w_address]))
        
        # update other params for all MLPs
        g_a_s = layer + gate_act_scale
        dma_src_address, dma_size = return_meta(g_a_s)
        g_a_s_address = ACT_SCALE_BASE + act_scale_address
        act_scale_address += dma_size
        instrcution_list.append(("dma",[DDR_BASE+dma_src_address, g_a_s_address, dma_size]))
        
        g_w_s = layer + gate_weight_scale
        dma_src_address, dma_size = return_meta(g_w_s)
        g_w_s_address = PARAM_SCALE_BASE + param_scale_address
        param_scale_address += dma_size
        instrcution_list.append(("dma",[DDR_BASE+dma_src_address, g_w_s_address, dma_size]))
        
        d_a_s_recip = layer + down_act_scale_recip
        dma_src_address, dma_size = return_meta(d_a_s_recip)
        d_a_s_recip_address = ACT_SCALE_BASE + act_scale_address
        act_scale_address += dma_size
        instrcution_list.append(("dma",[DDR_BASE+dma_src_address, d_a_s_recip_address, dma_size]))
        
        u_w_s = layer + up_weight_scale
        dma_src_address, dma_size = return_meta(u_w_s)
        u_w_s_address = PARAM_SCALE_BASE + param_scale_address
        param_scale_address += dma_size
        instrcution_list.append(("dma",[DDR_BASE+dma_src_address, u_w_s_address, dma_size]))
        
        u_a_s = layer + up_act_scale
        dma_src_address, dma_size = return_meta(u_a_s)
        u_a_s_address = PARAM_SCALE_BASE + param_scale_address
        param_scale_address += dma_size
        instrcution_list.append(("dma",[DDR_BASE+dma_src_address, u_a_s_address, dma_size]))
        
        d_w_s = layer + down_weight_scale
        dma_src_address, dma_size = return_meta(d_w_s)
        d_w_s_address = PARAM_SCALE_BASE + param_scale_address
        param_scale_address += dma_size
        instrcution_list.append(("dma",[DDR_BASE+dma_src_address, d_w_s_address, dma_size]))
        
        d_a_s = layer + down_act_scale
        dma_src_address, dma_size = return_meta(d_a_s)
        d_a_s_address = ACT_SCALE_BASE + act_scale_address
        act_scale_address += dma_size
        instrcution_list.append(("dma",[DDR_BASE+dma_src_address, d_a_s_address, dma_size]))
        
        # upload next layer's input-scale-recip and input-norm-weight
        if i < 23:
            layer_next = f"model.layers.{i+1}" 
            next_q_a_s_recip = layer_next + q_act_scale_recip
            dma_src_address, dma_size = return_meta(next_q_a_s_recip)
            next_q_a_s_recip_address = ACT_SCALE_BASE + act_scale_address
            act_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, next_q_a_s_recip_address,dma_size]))
            
            next_i_ln_w = layer_next + input_norm_weight
            dma_src_address, dma_size = return_meta(next_i_ln_w)
            next_i_ln_w_address = PARAM_SCALE_BASE + param_scale_address
            param_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, next_i_ln_w_address, dma_size]))
            
        else:
            next_q_a_s_recip = layer + q_act_scale_recip # according to myj, we just need to use any other scale_recip 
            dma_src_address, dma_size = return_meta(next_q_a_s_recip)
            next_q_a_s_recip_address = ACT_SCALE_BASE + act_scale_address
            act_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, next_q_a_s_recip_address, dma_size]))
            
            next_i_ln_w = last_norm
            dma_src_address, dma_size = return_meta(next_i_ln_w)
            next_i_ln_w_address = PARAM_SCALE_BASE + param_scale_address
            param_scale_address += dma_size
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, next_i_ln_w_address, dma_size]))
        
        # upload MLP0's params into MLP_address(not 0 or 1, because O_proj has already taken the first place[size = 401408])
        g_w = layer + gate_weight
        dma_src_address, dma_size = return_meta(g_w)
        real_dma_size = int(dma_size / 19)
        real_src_address = dma_src_address + real_dma_size
        g_w_address = PARAM_BASE + param_address
        param_address += real_dma_size
        instrcution_list.append(("dma",[DDR_BASE+real_src_address, g_w_address, real_dma_size]))
        
        u_w = layer + up_weight
        dma_src_address, dma_size = return_meta(u_w)
        real_dma_size = int(dma_size / 19)
        real_src_address = dma_src_address + real_dma_size
        u_w_address = PARAM_BASE + param_address
        param_address += real_dma_size
        instrcution_list.append(("dma",[DDR_BASE+real_src_address, u_w_address, real_dma_size]))
        
        d_w = layer + down_weight
        dma_src_address, dma_size = return_meta(d_w)
        real_dma_size = int(dma_size / 19)
        real_src_address = dma_src_address + real_dma_size
        d_w_address = PARAM_BASE + param_address
        param_address += real_dma_size
        instrcution_list.append(("dma",[DDR_BASE+real_src_address, d_w_address, real_dma_size]))
        
        instrcution_list.append(("check",[id]))   
        id += 1
        if id > 65486:
            id = 0
            
        # FFN compute (we have mlp0_17 and mlp18, and we need to tiling the weight into 19 pieces)
        for _ffn in range(19):
            if _ffn<18:
                instrcution_list.append(("mlp0_17",[id, seq_len, g_w_address,g_a_s_address,g_w_s_address+_ffn*512,u_w_address,u_a_s_address, u_w_s_address+_ffn*512,d_a_s_recip_address, d_w_address,d_a_s_address,d_w_s_address]))
                
                if _ffn % 2 == 0:
                    param_address = MLP_w_address0
                else:
                    param_address = MLP_w_address1
                
                # upload MLP_ffn(+1)'s weight
                g_w = layer + gate_weight
                dma_src_address, dma_size = return_meta(g_w)
                real_dma_size = int(dma_size / 19)
                real_src_address = dma_src_address + real_dma_size * (_ffn + 1)
                g_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, g_w_address, real_dma_size]))
                
                u_w = layer + up_weight
                dma_src_address, dma_size = return_meta(u_w)
                real_dma_size = int(dma_size / 19)
                real_src_address = dma_src_address + real_dma_size * (_ffn + 1)
                u_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, u_w_address, real_dma_size]))
                
                d_w = layer + down_weight
                dma_src_address, dma_size = return_meta(d_w)
                real_dma_size = int(dma_size / 19)
                real_src_address = dma_src_address + real_dma_size * (_ffn + 1)
                d_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, d_w_address, real_dma_size]))
                
                instrcution_list.append(("check",[id+50]))   
                id += 51
                if id > 65486:
                    id = 0
            else:
                instrcution_list.append(("mlp18",[id, seq_len, g_w_address,g_a_s_address,g_w_s_address+_ffn*512,u_w_address,u_a_s_address, u_w_s_address+_ffn*512,d_a_s_recip_address, d_w_address,d_a_s_address,d_w_s_address,next_q_a_s_recip_address,next_i_ln_w_address]))
                
                if i < 23: # not the last mlp, so we need to upload the next QKV params
                    
                    param_address = 0
                    
                    # transfer V
                    v_w = layer + v_weight
                    dma_src_address, dma_size = return_meta(v_w)
                    v_w_address = PARAM_BASE + param_address
                    param_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, v_w_address, dma_size]))
                    
                    v_a_s = layer + v_act_scale
                    dma_src_address, dma_size = return_meta(v_a_s)
                    v_a_s_address = ACT_SCALE_BASE + act_scale_address
                    act_scale_address += dma_size
                    instrcution_list.append(("dma", [DDR_BASE+dma_src_address, v_a_s_address, dma_size]))
                    
                    v_w_s = layer + v_weight_scale
                    dma_src_address, dma_size = return_meta(v_w_s)
                    v_w_s_address = PARAM_SCALE_BASE + param_scale_address
                    param_scale_address += dma_size
                    instrcution_list.append(("dma", [DDR_BASE+dma_src_address, v_w_s_address, dma_size]))
                    
                    bm2_v_s_recip = layer + bmm2_value_scale_recip
                    dma_src_address, dma_size = return_meta(bm2_v_s_recip)
                    bm2_v_s_recip_address = PARAM_SCALE_BASE + param_scale_address
                    param_scale_address += dma_size
                    instrcution_list.append(("dma", [DDR_BASE+dma_src_address, bm2_v_s_recip_address, dma_size]))
                    
                    # transfer K
                    k_w = layer + k_weight
                    dma_src_address, dma_size = return_meta(k_w)
                    k_w_address = PARAM_BASE + param_address
                    param_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, k_w_address, dma_size]))
                    
                    k_a_s = layer + k_act_scale
                    dma_src_address, dma_size = return_meta(k_a_s)
                    k_a_s_address = ACT_SCALE_BASE + act_scale_address
                    act_scale_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, k_a_s_address, dma_size]))
                    
                    k_w_s = layer + k_weight_scale
                    dma_src_address, dma_size = return_meta(k_w_s)
                    k_w_s_address = PARAM_SCALE_BASE + param_scale_address
                    param_scale_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, k_w_s_address, dma_size]))
                    
                    bm1_k_s_recip = layer + bmm1_key_scale_recip
                    dma_src_address, dma_size = return_meta(bm1_k_s_recip)
                    bm1_k_s_recip_address = ACT_SCALE_BASE + act_scale_address
                    act_scale_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, bm1_k_s_recip_address, dma_size]))
                    
                    # transfer Q
                    q_w = layer + q_weight
                    dma_src_address, dma_size = return_meta(q_w)
                    q_w_address = PARAM_BASE + param_address
                    param_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, q_w_address, dma_size]))
                    
                    q_a_s = layer + q_act_scale
                    dma_src_address, dma_size = return_meta(q_a_s)
                    q_a_s_address = ACT_SCALE_BASE + act_scale_address
                    act_scale_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, q_a_s_address, dma_size]))
                    
                    q_w_s = layer + q_weight_scale
                    dma_src_address, dma_size = return_meta(q_w_s)
                    q_w_s_address = PARAM_SCALE_BASE + param_scale_address
                    param_scale_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, q_w_s_address, dma_size]))
                    
                    bm1_q_s_recip = layer + bmm1_query_scale_recip
                    dma_src_address, dma_size = return_meta(bm1_q_s_recip)
                    bm1_q_s_recip_address = ACT_SCALE_BASE + act_scale_address
                    act_scale_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, bm1_q_s_recip_address, dma_size]))

                    # transfer attention
                    bm1_q_s = layer + bmm1_query_scale
                    dma_src_address, dma_size = return_meta(bm1_q_s)
                    bm1_q_s_address = ACT_SCALE_BASE + act_scale_address
                    act_scale_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, bm1_q_s_address, dma_size]))
                    
                    bm1_k_s = layer + bmm1_key_scale
                    dma_src_address, dma_size = return_meta(bm1_k_s)
                    bm1_k_s_address = PARAM_SCALE_BASE + param_scale_address
                    param_scale_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, bm1_k_s_address, dma_size]))
                    
                    bm2_s_s_recip = layer + bmm2_score_scale_recip
                    dma_src_address, dma_size = return_meta(bm2_s_s_recip)
                    bm2_s_s_recip_address = ACT_SCALE_BASE + act_scale_address
                    act_scale_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, bm2_s_s_recip_address, dma_size]))
                    
                    bm2_s_s = layer + bmm2_score_scale
                    dma_src_address, dma_size = return_meta(bm2_s_s)
                    bm2_s_s_address = ACT_SCALE_BASE + act_scale_address
                    act_scale_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, bm2_s_s_address, dma_size]))
                    
                    bm2_v_s = layer + bmm2_value_scale
                    dma_src_address, dma_size = return_meta(bm2_v_s)
                    bm2_v_s_address = PARAM_SCALE_BASE + param_scale_address
                    param_scale_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, bm2_v_s_address, dma_size]))
                    
                    o_a_s_recip = layer + o_act_scale_recip
                    dma_src_address, dma_size = return_meta(o_a_s_recip)
                    o_a_s_recip_address = ACT_SCALE_BASE + act_scale_address
                    act_scale_address += dma_size
                    instrcution_list.append(("dma",[DDR_BASE+dma_src_address, o_a_s_recip_address, dma_size]))
                
                    instrcution_list.append(("check",[id+50]))   
                    id += 51
                    if id > 65486:
                        id = 0
                else:
                    instrcution_list.append(("check",[id+50]))   
                    id += 51
                    if id > 65486:
                        id = 0
    print("[Compilation Done]")


    # write instruction_list into a file(./workspace/instructions.txt)
    with open("workspace/instructions.txt", "w") as f:
        for i in range(len(instrcution_list)):
            f.write(instrcution_list[i][0]+":")
            for param in range(len(instrcution_list[i][1])):
                f.write(f"{instrcution_list[i][1][param]},")
            f.write("\n")

    print("[Generate instructions.txt]")


    # write to a new main.c
    os.system("rm main.c")
    os.system("cp base.c main.c")

    id = 0
    with open("main.c", "a") as f:
        
        # we need to caculate the embedding address for token([1,sequence_len]), we will have ([sequence_len, hidden_dim]) embedding tokens(after embedding) to be tranfered into FPGA
        # f.write(f"\tint token_address_offset;\n")
        # f.write(f"\tint token_address_offset_bypass;\n")
        # f.write(f"\tint token_len = HIDDEN_DIM * 2;\n")
        # for m in range(SEQUENCE_LEN):
        #     token_offset = input_token[m]
        #     f.write(f"\ttoken_address_offset = 2 * ({token_offset} * HIDDEN_DIM) + ddr_PHY_src; // for there is float16 but saved in uint8 format\n")
        #     f.write(f"\tif(cdmaSimpleTransfer(&cdma, token_address_offset, IP_BASEADDR + BYPASS_BASE + token_len * {m}, token_len, NULL, NULL)!=XST_SUCCESS)\n")
        #     f.write("\t\tprintf('Error: CDMA transfer failed!');\n")
        #     f.write("\twhile(cdmaCfgIsBusy());\n")
        
        # then is the transformer part
        for i in range(len(instrcution_list)):
            if instrcution_list[i][0] == "dma":
                f.write(f"\tif(cdmaSimpleTransfer(&cdma, {instrcution_list[i][1][0]}, IP_BASEADDR+{instrcution_list[i][1][1]}, {instrcution_list[i][1][2]}, NULL, NULL)!=XST_SUCCESS)\n")
                f.write("\t\tprintf('Error: CDMA transfer failed!');\n")
                f.write("\twhile(cdmaCfgIsBusy());\n")
            elif instrcution_list[i][0] == "norm":
                f.write(f"\tnorm({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},IP_BASEADDR+{instrcution_list[i][1][2]},IP_BASEADDR+{instrcution_list[i][1][3]});\n")
            elif instrcution_list[i][0] == "k_proj":
                f.write(f"\tk_proj({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]},{instrcution_list[i][1][5]},{instrcution_list[i][1][6]},{instrcution_list[i][1][7]},{instrcution_list[i][1][8]});\n")
            elif instrcution_list[i][0] == "q_proj":
                f.write(f"\tq_proj({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]},{instrcution_list[i][1][5]},{instrcution_list[i][1][6]});\n")
            elif instrcution_list[i][0] == "v_proj":
                f.write(f"\tv_proj({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]},{instrcution_list[i][1][5]},{instrcution_list[i][1][6]},{instrcution_list[i][1][7]});\n")
            elif instrcution_list[i][0] == "attention":
                f.write(f"\tattention({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},getSeqValidLen(),{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]},{instrcution_list[i][1][5]},{instrcution_list[i][1][6]},{instrcution_list[i][1][7]},{instrcution_list[i][1][8]},{instrcution_list[i][1][9]},{instrcution_list[i][1][10]});\n")
            elif instrcution_list[i][0] == "o_proj":
                f.write(f"\to_proj({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]},{instrcution_list[i][1][5]},{instrcution_list[i][1][6]});\n")
            elif instrcution_list[i][0] == "mlp0_17":
                f.write(f"\tmlp0_17({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]},{instrcution_list[i][1][5]},{instrcution_list[i][1][6]},{instrcution_list[i][1][7]},{instrcution_list[i][1][8]},{instrcution_list[i][1][9]},{instrcution_list[i][1][10]},{instrcution_list[i][1][11]});\n")
            elif instrcution_list[i][0] == "mlp18":
                f.write(f"\tmlp18({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]},{instrcution_list[i][1][5]},{instrcution_list[i][1][6]},{instrcution_list[i][1][7]},{instrcution_list[i][1][8]},{instrcution_list[i][1][9]},{instrcution_list[i][1][10]},{instrcution_list[i][1][11]},{instrcution_list[i][1][12]},{instrcution_list[i][1][13]});\n")
            elif instrcution_list[i][0] == "check":
                f.write(f"\ttask = taskRetired();\n")
                f.write(f"\twhile(task != {instrcution_list[i][1][0]})"+"{\n")
                f.write("\t\ttask = taskRetired();"+"}\n")

        # last we take the logits from 0x200000(BYPASS_BASE) to bypass_ddr_address, then caculate it from python
        f.write(f"\tif(cdmaSimpleTransfer(&cdma, IP_BASEADDR+BYPASS_BASE, result_PHY_address, 2* SEQUENCE_LEN * HIDDEN_DIM, NULL, NULL)!=XST_SUCCESS)\n")
        f.write("\t\tprintf('Error: CDMA transfer failed!');\n")
        f.write("\twhile(cdmaCfgIsBusy());\n")
                
        f.write("\treturn 0;\n}")
        
    print("[Generate main.c file]")
    
    ## then run main.c
    os.system("rm main.out ; gcc -w main.c include/xil_printf.c -Linclude -lxil -o main.out") 
    
    print("[Generate main.out file]")
    
    print("\n**********[Start ACC test]**********\n")
    finish_cnt=0
    with Progress(
        TextColumn("[bold green]{task.description}"),
        BarColumn(),
        TaskProgressColumn(),
        TextColumn("{task.completed}/{task.total} tasks completed"),
    ) as progress:
        
        task = progress.add_task("[bold green]Evaluation ", total=total_predictions)

        # counter=-1
        for _, data in dataset.iterrows():
            # counter+=1
            # if counter<1:
                # continue
            # if counter==2:
                # break
            sentence1 = data['sentence1']
            sentence2 = data['sentence2']
            label = data['label']

            # prompt
            # prompt = f"Sentence 1: {sentence1} Sentence 2: {sentence2} Is the second sentence entailed by the first? (1 for yes, 0 for no) you can only output 1 or 0"
            prompt = f"{sentence1},{sentence2}"
            # Output only has 1 or 0
            print(f"Golden label = {data['label']}")
            
            
            # tokens = 192 is just for acc.py, in throughput-test cases we use 576
            inputs = tokenizer(prompt, return_tensors="pt", padding="max_length", truncation=True, max_length=192)
            
            # now we handle the input array
            input_array = inputs["input_ids"] * inputs["attention_mask"]
            tokens_int32 = input_array.to(dtype=torch.int32)
            array = tokens_int32.view(-1).numpy()
            array_ptr = array.ctypes.data_as(ctypes.POINTER(ctypes.c_int))
            array_size = len(array)
            prompt_token_array = tokens_int32.view(-1).numpy()

            # find the last token index
            for i in range(len(prompt_token_array)):
                if prompt_token_array[i]==0:
                    last_index=i-1
                    break

            # for sequence valid length
            with open("./workspace/seq_valid_len.txt", "w") as f:
                f.write(str(last_index+1))
            print("sequence valid length=", last_index+1)
            
            input_token = prompt_token_array
            
            ###########################
            # get the ouput
            # (written by myj) Here is the embedding ops. We copy the embedding result into the input_buffer for DMA later.
            torch.set_printoptions(profile="full")
            for i in range(SEQUENCE_LEN):
                input_buffer[i*(2*HIDDEN_DIM):(i+1)*(2*HIDDEN_DIM)]=ddr_array[input_token[i]*(2*HIDDEN_DIM):(input_token[i]+1)*(2*HIDDEN_DIM)]
            np.copyto(input_buffer, np.array(torch.Tensor(input_buffer).reshape(SEQUENCE_LEN, HIDDEN_DIM, 2).reshape(SEQUENCE_LEN//8, 8, HIDDEN_DIM, 2).permute(0, 2, 1, 3).flatten(), dtype=np.uint8))
            # print(torch.tensor(input_buffer).reshape(SEQUENCE_LEN//8, HIDDEN_DIM, 16).view(torch.uint8)[0, 0:128])
            for i in range(SEQUENCE_LEN*HIDDEN_DIM*2):
                output_buffer[i]=0

            os.system("./main.out")

            time.sleep(0.1)
            
            ################
            
            # print(torch.tensor(output_buffer).reshape(SEQUENCE_LEN//8, HIDDEN_DIM, 16).view(torch.uint8)[0, 0:128])
            np.copyto(output_buffer, np.array(torch.tensor(output_buffer).reshape(SEQUENCE_LEN//8, HIDDEN_DIM, 8, 2).permute(0, 2, 1, 3).reshape(SEQUENCE_LEN, HIDDEN_DIM, 2).flatten(), dtype=np.uint8))
            # print(torch.tensor(output_buffer).reshape(SEQUENCE_LEN, HIDDEN_DIM*2).view(torch.uint8))

            # then caculate the last op(logits)
            # logits_src from bypass(SEQUENCE_LEN, HIDDEN_DIM) * weight(HIDDEN_DIM,2) -> logits(SEQUENCE_LEN,2) ->just got the last 2 result
            weight_index, _ = return_meta("score.weight")
            
            # we just need the last row for computation
            #result_src_index = (SEQUENCE_LEN-1)*HIDDEN_DIM * 2
            result_src_index = last_index * HIDDEN_DIM * 2
            
            output_0 = 0
            output_1 = 0
            
            result_src=torch.tensor(output_buffer[result_src_index:result_src_index+HIDDEN_DIM*2]).reshape(-1, 2).contiguous().view(torch.float16)
            weight=torch.tensor(ddr_array[weight_index:weight_index+HIDDEN_DIM*4]).reshape(2, -1).contiguous().view(torch.float16)
            output=torch.argmax(weight@result_src, dim=0)
            
            # for m in range(HIDDEN_DIM):    
            #     result_src=torch.tensor() np.float16(int(f'{ddr_array[result_src_index+1+m*2]:08b}{ddr_array[result_src_index+m*2]:08b}',2))
                
            #     weight0 = np.float16(int(f'{ddr_array[weight_index+1+m*2*2]:08b}{ddr_array[weight_index+m*2*2]:08b}',2))
            #     output_0 += weight0 * result_src
                
            #     weight1 = np.float16(int(f'{ddr_array[weight_index+3+m*2*2]:08b}{ddr_array[weight_index+2+m*2*2]:08b}',2))
            #     output_1 += weight1*result_src
            
            # output = torch.argmax(torch.tensor([[output_0, output_1]]), dim=1)
            
            model_prediction = int(output)

            if model_prediction == label:
                correct_predictions += 1
                print("correct +1")
            else:
                print("incorrect +1")

            finish_cnt+=1
            print(f"rate = {correct_predictions} / {finish_cnt} = {correct_predictions/finish_cnt}")
            progress.update(task, completed=finish_cnt,description="Evaluation ")

    accuracy = correct_predictions / total_predictions
    
    del input_buffer
    del output_buffer
    del ddr_array
    overlay.free()
    
    return accuracy


def load_data(file_path):
    return pd.read_csv(file_path, sep='\t')

if __name__ == "__main__":
    
    np.seterr(over='ignore')
    
    parser = argparse.ArgumentParser(description="A description of your program")
    parser.add_argument('--hf_path', type=str, required=True, help="The path of Qwen hf model path. We just need it for the tokenizer.")
    parser.add_argument('--bench_path', type=str, required=True, help="The path of benchmark (final.tsv).")
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
