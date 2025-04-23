from pynq import Overlay
from pynq import allocate
from pynq.lib.dma import DMA
#from pynq_cdma import CDMA
import pynq
import os
import mmap
import time
import numpy as np
import torch
import json
import pandas as pd
from transformers import AutoModelForCausalLM, AutoTokenizer
import ctypes
import argparse
from rich.progress import Progress, TextColumn, BarColumn, TaskProgressColumn
from rich.columns import Columns
from rich.console import Console
import time

def runInfer(input_token, model_bin_path="model/model.bin", overlay_path="overlay/system.bit"):
    
    overlay=Overlay(overlay_path)
    overlay.ip_dict
    
    SEQUENCE_LEN = 192
    HIDDEN_DIM = 896
    
    # We have 4GB ddr(2^^30)
    allocated_size = 512 * 1024 * 1024 # 512MB
    ddr_array = allocate(allocated_size, dtype=np.uint8,cacheable=1) #512MB
    
    buffer0=allocate(shape=(SEQUENCE_LEN*HIDDEN_DIM*2),dtype='uint8',cacheable=1) # for input
    with open("./workspace/embedding_address.txt", "w") as f:
        f.write(str(buffer0.device_address))
    buffer1=allocate(shape=(SEQUENCE_LEN*HIDDEN_DIM*2),dtype='uint8',cacheable=1) # for output
    with open("./workspace/result_address.txt", "w") as f:
        f.write(str(buffer1.device_address))
    
    with open("./workspace/pynq_alloc_phys_addr.txt", "w") as f:
        f.write(str(ddr_array.device_address))
    
    # load model into ddr_array
    # load model.bin into DDR ddr_array
    metadata = {}
    current_index = 0
    allocated_size = 512 * 1024 * 1024 # 512MB

    data = torch.load(model_bin_path, map_location=torch.device("cpu"))

    # recorder
    metadata = {}
    current_index = 0

    for key, tensor in data.items():
        arr = tensor.cpu().numpy().flatten()
        if arr.dtype == np.float16:
            data_bytes = arr.tobytes()
            num_bytes = len(data_bytes)  
            data_uint8 = np.frombuffer(data_bytes, dtype=np.uint8)
            # here the float16 will be seperate into HIGH8bit and LOW8bit, in the ddr array, it will be ddr[0]= LOW8bit, ddr[1]= HIGH8bit
        
        elif arr.dtype == np.int8:
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
    
    SEQUENCE_LEN=192
    HIDDEN_DIM=896
    sequence_valid_len=0

    for i in range(SEQUENCE_LEN):
        if input_token[i]==0:
            buffer0[i*(2*HIDDEN_DIM):(i+1)*(2*HIDDEN_DIM)]=[0]*(2*HIDDEN_DIM)
        else:
            buffer0[i*(2*HIDDEN_DIM):(i+1)*(2*HIDDEN_DIM)]=ddr_array[input_token[i]*(2*HIDDEN_DIM):(input_token[i]+1)*(2*HIDDEN_DIM)]
            sequence_valid_len=i+1
    np.copyto(buffer0, np.array(torch.Tensor(buffer0).reshape(SEQUENCE_LEN, HIDDEN_DIM, 2).reshape(SEQUENCE_LEN//32, 32, HIDDEN_DIM, 2).permute(0, 2, 1, 3).flatten(), dtype=np.uint8))
    torch.set_printoptions(profile="full")
    # print(list(buffer0))
    #print(torch.tensor(buffer0))
    for i in range(SEQUENCE_LEN*HIDDEN_DIM*2):
        buffer1[i]=0
    ############################################################
    # 
    # Following is the long long long QWEN computing codes
    #
    ############################################################

    # Define address
    DDR_BASE = ddr_array.device_address
    PARAM_BASE = 0x500000
    PARAM_SIZE = 0x200000 # we just use 2MB for safety, actually we have total 2.25MB, after 2MB is ROPE_BASE
    ROPE_BASE = 0x420000
    ROPE_SIZE = 0x6000
    PARAM_SCALE_BASE = 0x426000
    PARAM_SCALE_SIZE = 0xa000
    ACT_SCALE_BASE = 0x460000
    ACT_SCALE_SIZE = 0x8000

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

    # we have several functions: dma, LayerNorm, Kproj, Vproj, Qproj, Attention, Oproj, FFN1_5, FFN6
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
    
    for i in range(24):
        layer = f"model.layers.{i}" 
        if i == 0:
            # for layer 0, there is an extra layerNorm
            q_a_scale_recip = layer + q_act_scale_recip
            dma_src_address, dma_size = return_meta(q_a_scale_recip)
            q_a_recip_address = ACT_SCALE_BASE + act_scale_address
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, q_a_recip_address, dma_size]))
            act_scale_address += dma_size
            
            input_n_weight = layer + input_norm_weight
            dma_src_address, dma_size = return_meta(input_n_weight)
            input_n_weight = PARAM_SCALE_BASE + param_scale_address
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, input_n_weight, dma_size]))
            param_scale_address += dma_size
            
            instrcution_list.append(("LayerNorm",[q_a_recip_address,input_n_weight]))
            param_address = 0
            param_scale_address = ROPE_SIZE
            act_scale_address = 0
        
        # for all layers, first compute QKV
        # K compute
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
        
        instrcution_list.append(("Kproj",  [k_w_address, k_a_s_address, k_w_s_address, bm1_k_s_recip_address, ROPE_BASE]))
        param_address = 0
        param_scale_address = ROPE_SIZE
        act_scale_address = 0
        
        # V compute
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
        bm2_v_s_recip_address = PARAM_SCALE_BASE + param_scale_address # 只有bm2_v_s_recip是在PARAM_SCALE_BASE
        param_scale_address += dma_size
        instrcution_list.append(("dma", [DDR_BASE+dma_src_address, bm2_v_s_recip_address, dma_size]))
        
        instrcution_list.append(("Vproj", [v_w_address, v_a_s_address, v_w_s_address, bm2_v_s_recip_address]))
        param_address = 0
        param_scale_address = ROPE_SIZE
        act_scale_address = 0
        
        # Q compute
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
        
        instrcution_list.append(("Qproj", [q_w_address, q_a_s_address, q_w_s_address, bm1_q_s_recip_address, ROPE_BASE]))
        param_address = 0
        param_scale_address = ROPE_SIZE
        act_scale_address = 0
        
        # Attention
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
        
        instrcution_list.append(("Attention",[bm1_q_s_address, bm1_k_s_address, bm2_s_s_recip_address, bm2_s_s_address, bm2_v_s_address, o_a_s_recip_address]))
        param_address = 0
        param_scale_address = ROPE_SIZE
        act_scale_address = 0
        
        # Attention out proj
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
        
        instrcution_list.append(("Oproj",[o_w_address,o_a_s_address,o_w_s_address,g_a_s_recip_address,p_ln_w_address]))
        param_address = 0
        param_scale_address = ROPE_SIZE
        act_scale_address = 0
        
        # FFN compute (we have FFN1_5 and FFN6, and we need to tiling the weight into 6 pieces(896-896-896-896-896-384, sum is 4864))
        for _ffn in range(6):
            if _ffn < 5:
                g_w = layer + gate_weight
                dma_src_address, dma_size = return_meta(g_w)
                real_dma_size = int(dma_size * 896 / 4864)
                real_src_address = dma_src_address + _ffn * real_dma_size
                g_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, g_w_address, real_dma_size]))
                
                u_w = layer + up_weight
                dma_src_address, dma_size = return_meta(u_w)
                real_dma_size = int(dma_size * 896 / 4864)
                real_src_address = dma_src_address + _ffn * real_dma_size
                u_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, u_w_address, real_dma_size]))
                
                d_w = layer + down_weight
                dma_src_address, dma_size = return_meta(d_w)
                real_dma_size = int(dma_size * 896 / 4864)
                real_src_address = dma_src_address + _ffn * real_dma_size
                d_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, d_w_address, real_dma_size]))
                    
            elif _ffn == 5:
                g_w = layer + gate_weight
                dma_src_address, dma_size = return_meta(g_w)
                real_dma_size = int(dma_size * 384 / 4864)
                real_src_address = dma_src_address + _ffn * int(dma_size * 896 / 4864)
                g_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, g_w_address, real_dma_size]))
                
                u_w = layer + up_weight
                dma_src_address, dma_size = return_meta(u_w)
                real_dma_size = int(dma_size * 384 / 4864)
                real_src_address = dma_src_address + _ffn * int(dma_size * 896 / 4864)
                u_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, u_w_address, real_dma_size]))
                
                d_w = layer + down_weight
                dma_src_address, dma_size = return_meta(d_w)
                real_dma_size = int(dma_size * 384 / 4864)
                real_src_address = dma_src_address + _ffn * int(dma_size * 896 / 4864)
                d_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, d_w_address, real_dma_size]))
                
            if _ffn == 0:
                # we just need to update other params when _ffn == 0
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
                
                # upload next layer's input-scale-recip and input-layerNorm-weight
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
            if _ffn<5:
                instrcution_list.append(("FFN1_5",[g_w_address,g_a_s_address,g_w_s_address,d_a_s_recip_address,u_w_address,u_w_s_address,d_w_address,d_a_s_address,d_w_s_address]))
            else:
                instrcution_list.append(("FFN6",[g_w_address,g_a_s_address,g_w_s_address,d_a_s_recip_address,u_w_address,u_w_s_address,d_w_address,d_a_s_address,d_w_s_address,next_q_a_s_recip_address,next_i_ln_w_address]))
            param_address = 0
            param_scale_address = ROPE_SIZE
            act_scale_address = 0

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
        ffn_index=0
        for i in range(len(instrcution_list)):
            if instrcution_list[i][0] == "dma":
                f.write(f"\tif(cdmaSimpleTransfer(&cdma, {instrcution_list[i][1][0]}, IP_BASEADDR+{instrcution_list[i][1][1]}, {instrcution_list[i][1][2]}, NULL, NULL)!=XST_SUCCESS)\n")
                f.write("\t\tprintf('Error: CDMA transfer failed!');\n")
                f.write("\twhile(cdmaCfgIsBusy());\n")
            elif instrcution_list[i][0] == "LayerNorm":
                f.write(f"\tLayerNorm({instrcution_list[i][1][0]},{instrcution_list[i][1][1]});\n")
                id += 1
            elif instrcution_list[i][0] == "Kproj":
                f.write(f"\tKproj({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]});\n")
                id += 1
            elif instrcution_list[i][0] == "Qproj":
                f.write(f"\tQproj({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]});\n")
                id += 1
            elif instrcution_list[i][0] == "Vproj":
                f.write(f"\tVproj({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]});\n")
                id += 1
            elif instrcution_list[i][0] == "Attention":
                f.write(f"\tAttention({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]},{instrcution_list[i][1][5]});\n")
                id += 1 
            elif instrcution_list[i][0] == "Oproj":
                f.write(f"\tOproj({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]});\n")
                id += 1 
            elif instrcution_list[i][0] == "FFN1_5":
                f.write(f"\tFFN1_5({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]},{instrcution_list[i][1][5]},{instrcution_list[i][1][6]},{instrcution_list[i][1][7]},{instrcution_list[i][1][8]},{ffn_index});\n")
                ffn_index=(ffn_index+1)%5
                id += 1 
            elif instrcution_list[i][0] == "FFN6":
                f.write(f"\tFFN6({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]},{instrcution_list[i][1][5]},{instrcution_list[i][1][6]},{instrcution_list[i][1][7]},{instrcution_list[i][1][8]},{instrcution_list[i][1][9]},{instrcution_list[i][1][10]});\n")
                id += 1 
                
        # last we take the logits from 0x200000(BYPASS_BASE) to bypass_ddr_address, then caculate it from python
        f.write(f"\tif(cdmaSimpleTransfer(&cdma, IP_BASEADDR+BYPASS_BASE, result_PHY_address, 2* SEQUENCE_LEN * HIDDEN_DIM, NULL, NULL)!=XST_SUCCESS)\n")
        f.write("\t\tprintf('Error: CDMA transfer failed!');\n")
        f.write("\twhile(cdmaCfgIsBusy());\n")
                
        f.write("\treturn 0;\n}")
        
    print("[Generate main.c file]")
    
    ## then run main.c
    os.system("rm main.out ; gcc -w main.c include/xil_printf.c -Linclude -lxil -o main.out") 
    os.system("./main.out")
    
    print("[Compile and run main.c file]")
    
    ################
    
    np.copyto(buffer1, np.array(torch.tensor(buffer1).reshape(SEQUENCE_LEN//32, HIDDEN_DIM, 32, 2).permute(0, 2, 1, 3).reshape(SEQUENCE_LEN, HIDDEN_DIM, 2).flatten(), dtype=np.uint8))
    
    ## then caculate the last op(logits)
    ## logits_src from bypass(SEQUENCE_LEN, HIDDEN_DIM) * weight(HIDDEN_DIM,2) -> logits(SEQUENCE_LEN,2) ->just got the last 2 result
    weight_index, _ = return_meta("score.weight")
    
    # we just need the last row for computation
    result_src_index = (sequence_valid_len-1)*HIDDEN_DIM * 2
    
    output_0 = 0
    output_1 = 0
    
    for m in range(HIDDEN_DIM):    
        result_src=np.frombuffer((np.int16(buffer1[result_src_index+1+m*2])<<8)|np.int16(buffer1[result_src_index+m*2]), dtype=np.float16)[0]
        
        weight0 = np.frombuffer((np.int16(ddr_array[weight_index+3+m*4])<<8)|np.int16(ddr_array[weight_index+2+m*4]), dtype=np.float16)[0]
        output_0 += weight0 * result_src
        
        weight1 = np.frombuffer((np.int16(ddr_array[weight_index+1+m*4])<<8)|np.int16(ddr_array[weight_index+0+m*4]), dtype=np.float16)[0]
        output_1 += weight1 * result_src
    
    output=0 if output_0>output_1 else 1
    
    del buffer0
    del buffer1
    del ddr_array
    overlay.free()
    
    print("Finish once")
    
    return output


def runThroughput(input_token, model_bin_path="model/model.bin", overlay_path="overlay/system.bit"):
    
    overlay=Overlay(overlay_path)
    overlay.ip_dict
    
    SEQUENCE_LEN = 192
    HIDDEN_DIM = 896
    
    # We have 4GB ddr(2^^30)
    allocated_size = 512 * 1024 * 1024 # 512MB
    ddr_array = allocate(allocated_size, dtype=np.uint8,cacheable=1) #512MB
    
    buffer0=allocate(shape=(SEQUENCE_LEN*HIDDEN_DIM*2),dtype='uint8',cacheable=1) # for input
    with open("./workspace/embedding_address.txt", "w") as f:
        f.write(str(buffer0.device_address))
    buffer1=allocate(shape=(SEQUENCE_LEN*HIDDEN_DIM*2),dtype='uint8',cacheable=1) # for output
    with open("./workspace/result_address.txt", "w") as f:
        f.write(str(buffer1.device_address))
    
    with open("./workspace/pynq_alloc_phys_addr.txt", "w") as f:
        f.write(str(ddr_array.device_address))
    
    # load model into ddr_array
    # load model.bin into DDR ddr_array
    metadata = {}
    current_index = 0
    allocated_size = 512 * 1024 * 1024 # 512MB

    data = torch.load(model_bin_path, map_location=torch.device("cpu"))

    # recorder
    metadata = {}
    current_index = 0

    for key, tensor in data.items():
        arr = tensor.cpu().numpy().flatten()
        if arr.dtype == np.float16:
            data_bytes = arr.tobytes()
            num_bytes = len(data_bytes)  
            data_uint8 = np.frombuffer(data_bytes, dtype=np.uint8)
            # here the float16 will be seperate into HIGH8bit and LOW8bit, in the ddr array, it will be ddr[0]= LOW8bit, ddr[1]= HIGH8bit
        
        elif arr.dtype == np.int8:
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
    
    SEQUENCE_LEN=192
    HIDDEN_DIM=896

    for i in range(SEQUENCE_LEN*HIDDEN_DIM*2):
        buffer1[i]=0
    
    ############################################################
    # 
    # Following is the long long long QWEN computing codes
    #
    ############################################################

    # Define address
    DDR_BASE = ddr_array.device_address
    PARAM_BASE = 0x500000
    PARAM_SIZE = 0x200000 # we just use 2MB for safety, actually we have total 2.25MB, after 2MB is ROPE_BASE
    ROPE_BASE = 0x420000
    ROPE_SIZE = 0x6000
    PARAM_SCALE_BASE = 0x426000
    PARAM_SCALE_SIZE = 0xa000
    ACT_SCALE_BASE = 0x460000
    ACT_SCALE_SIZE = 0x8000

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

    # we have several functions: dma, LayerNorm, Kproj, Vproj, Qproj, Attention, Oproj, FFN1_5, FFN6
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
    
    for i in range(24):
        layer = f"model.layers.{i}" 
        if i == 0:
            # for layer 0, there is an extra layerNorm
            q_a_scale_recip = layer + q_act_scale_recip
            dma_src_address, dma_size = return_meta(q_a_scale_recip)
            q_a_recip_address = ACT_SCALE_BASE + act_scale_address
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, q_a_recip_address, dma_size]))
            act_scale_address += dma_size
            
            input_n_weight = layer + input_norm_weight
            dma_src_address, dma_size = return_meta(input_n_weight)
            input_n_weight = PARAM_SCALE_BASE + param_scale_address
            instrcution_list.append(("dma",[DDR_BASE+dma_src_address, input_n_weight, dma_size]))
            param_scale_address += dma_size
            
            instrcution_list.append(("LayerNorm",[q_a_recip_address,input_n_weight]))
            param_address = 0
            param_scale_address = ROPE_SIZE
            act_scale_address = 0
        
        # for all layers, first compute QKV
        # K compute
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
        
        instrcution_list.append(("Kproj",  [k_w_address, k_a_s_address, k_w_s_address, bm1_k_s_recip_address, ROPE_BASE]))
        param_address = 0
        param_scale_address = ROPE_SIZE
        act_scale_address = 0
        
        # V compute
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
        bm2_v_s_recip_address = PARAM_SCALE_BASE + param_scale_address # 只有bm2_v_s_recip是在PARAM_SCALE_BASE
        param_scale_address += dma_size
        instrcution_list.append(("dma", [DDR_BASE+dma_src_address, bm2_v_s_recip_address, dma_size]))
        
        instrcution_list.append(("Vproj", [v_w_address, v_a_s_address, v_w_s_address, bm2_v_s_recip_address]))
        param_address = 0
        param_scale_address = ROPE_SIZE
        act_scale_address = 0
        
        # Q compute
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
        
        instrcution_list.append(("Qproj", [q_w_address, q_a_s_address, q_w_s_address, bm1_q_s_recip_address, ROPE_BASE]))
        param_address = 0
        param_scale_address = ROPE_SIZE
        act_scale_address = 0
        
        # Attention
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
        
        instrcution_list.append(("Attention",[bm1_q_s_address, bm1_k_s_address, bm2_s_s_recip_address, bm2_s_s_address, bm2_v_s_address, o_a_s_recip_address]))
        param_address = 0
        param_scale_address = ROPE_SIZE
        act_scale_address = 0
        
        # Attention out proj
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
        
        instrcution_list.append(("Oproj",[o_w_address,o_a_s_address,o_w_s_address,g_a_s_recip_address,p_ln_w_address]))
        param_address = 0
        param_scale_address = ROPE_SIZE
        act_scale_address = 0
        
        # FFN compute (we have FFN1_5 and FFN6, and we need to tiling the weight into 6 pieces(896-896-896-896-896-384, sum is 4864))
        for _ffn in range(6):
            if _ffn < 5:
                g_w = layer + gate_weight
                dma_src_address, dma_size = return_meta(g_w)
                real_dma_size = int(dma_size * 896 / 4864)
                real_src_address = dma_src_address + _ffn * real_dma_size
                g_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, g_w_address, real_dma_size]))
                
                u_w = layer + up_weight
                dma_src_address, dma_size = return_meta(u_w)
                real_dma_size = int(dma_size * 896 / 4864)
                real_src_address = dma_src_address + _ffn * real_dma_size
                u_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, u_w_address, real_dma_size]))
                
                d_w = layer + down_weight
                dma_src_address, dma_size = return_meta(d_w)
                real_dma_size = int(dma_size * 896 / 4864)
                real_src_address = dma_src_address + _ffn * real_dma_size
                d_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, d_w_address, real_dma_size]))
                    
            elif _ffn == 5:
                g_w = layer + gate_weight
                dma_src_address, dma_size = return_meta(g_w)
                real_dma_size = int(dma_size * 384 / 4864)
                real_src_address = dma_src_address + _ffn * int(dma_size * 896 / 4864)
                g_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, g_w_address, real_dma_size]))
                
                u_w = layer + up_weight
                dma_src_address, dma_size = return_meta(u_w)
                real_dma_size = int(dma_size * 384 / 4864)
                real_src_address = dma_src_address + _ffn * int(dma_size * 896 / 4864)
                u_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, u_w_address, real_dma_size]))
                
                d_w = layer + down_weight
                dma_src_address, dma_size = return_meta(d_w)
                real_dma_size = int(dma_size * 384 / 4864)
                real_src_address = dma_src_address + _ffn * int(dma_size * 896 / 4864)
                d_w_address = PARAM_BASE + param_address
                param_address += real_dma_size
                instrcution_list.append(("dma",[DDR_BASE+real_src_address, d_w_address, real_dma_size]))
                
            if _ffn == 0:
                # we just need to update other params when _ffn == 0
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
                
                # upload next layer's input-scale-recip and input-layerNorm-weight
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
            if _ffn<5:
                instrcution_list.append(("FFN1_5",[g_w_address,g_a_s_address,g_w_s_address,d_a_s_recip_address,u_w_address,u_w_s_address,d_w_address,d_a_s_address,d_w_s_address]))
            else:
                instrcution_list.append(("FFN6",[g_w_address,g_a_s_address,g_w_s_address,d_a_s_recip_address,u_w_address,u_w_s_address,d_w_address,d_a_s_address,d_w_s_address,next_q_a_s_recip_address,next_i_ln_w_address]))
            param_address = 0
            param_scale_address = ROPE_SIZE
            act_scale_address = 0

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
        ffn_index=0
        for i in range(len(instrcution_list)):
            if instrcution_list[i][0] == "dma":
                f.write(f"\tif(cdmaSimpleTransfer(&cdma, {instrcution_list[i][1][0]}, IP_BASEADDR+{instrcution_list[i][1][1]}, {instrcution_list[i][1][2]}, NULL, NULL)!=XST_SUCCESS)\n")
                f.write("\t\tprintf('Error: CDMA transfer failed!');\n")
                f.write("\twhile(cdmaCfgIsBusy());\n")
            elif instrcution_list[i][0] == "LayerNorm":
                f.write(f"\tLayerNorm({instrcution_list[i][1][0]},{instrcution_list[i][1][1]});\n")
                id += 1
            elif instrcution_list[i][0] == "Kproj":
                f.write(f"\tKproj({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]});\n")
                id += 1
            elif instrcution_list[i][0] == "Qproj":
                f.write(f"\tQproj({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]});\n")
                id += 1
            elif instrcution_list[i][0] == "Vproj":
                f.write(f"\tVproj({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]});\n")
                id += 1
            elif instrcution_list[i][0] == "Attention":
                f.write(f"\tAttention({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]},{instrcution_list[i][1][5]});\n")
                id += 1 
            elif instrcution_list[i][0] == "Oproj":
                f.write(f"\tOproj({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]});\n")
                id += 1 
            elif instrcution_list[i][0] == "FFN1_5":
                f.write(f"\tFFN1_5({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]},{instrcution_list[i][1][5]},{instrcution_list[i][1][6]},{instrcution_list[i][1][7]},{instrcution_list[i][1][8]},{ffn_index});\n")
                ffn_index=(ffn_index+1)%5
                id += 1 
            elif instrcution_list[i][0] == "FFN6":
                f.write(f"\tFFN6({instrcution_list[i][1][0]},{instrcution_list[i][1][1]},{instrcution_list[i][1][2]},{instrcution_list[i][1][3]},{instrcution_list[i][1][4]},{instrcution_list[i][1][5]},{instrcution_list[i][1][6]},{instrcution_list[i][1][7]},{instrcution_list[i][1][8]},{instrcution_list[i][1][9]},{instrcution_list[i][1][10]});\n")
                id += 1 
                
        # last we take the logits from 0x200000(BYPASS_BASE) to bypass_ddr_address, then caculate it from python
        f.write(f"\tif(cdmaSimpleTransfer(&cdma, IP_BASEADDR+BYPASS_BASE, result_PHY_address, 2* SEQUENCE_LEN * HIDDEN_DIM, NULL, NULL)!=XST_SUCCESS)\n")
        f.write("\t\tprintf('Error: CDMA transfer failed!');\n")
        f.write("\twhile(cdmaCfgIsBusy());\n")
                
        f.write("\treturn 0;\n}")
        
    print("[Generate main.c file]")
    
    ## then run main.c
    os.system("rm main.out ; gcc -w main.c include/xil_printf.c -Linclude -lxil -o main.out") 
    
    weight_index, _ = return_meta("score.weight")
    output_0 = 0
    output_1 = 0
    
    
    prefill_start_time = time.time()
    
    sequence_valid_len=0
    for i in range(SEQUENCE_LEN):
        if input_token[i]==0:
            buffer0[i*(2*HIDDEN_DIM):(i+1)*(2*HIDDEN_DIM)]=[0]*(2*HIDDEN_DIM)
        else:
            buffer0[i*(2*HIDDEN_DIM):(i+1)*(2*HIDDEN_DIM)]=ddr_array[input_token[i]*(2*HIDDEN_DIM):(input_token[i]+1)*(2*HIDDEN_DIM)]
            sequence_valid_len=i+1
    np.copyto(buffer0, np.array(torch.Tensor(buffer0).reshape(SEQUENCE_LEN, HIDDEN_DIM, 2).reshape(SEQUENCE_LEN//32, 32, HIDDEN_DIM, 2).permute(0, 2, 1, 3).flatten(), dtype=np.uint8))
    result_src_index = (sequence_valid_len-1)*HIDDEN_DIM * 2
    torch.set_printoptions(profile="full")
    
    os.system("./main.out")
    
    print("[Compile and run main.c file]")
    
    ################
    
    np.copyto(buffer1, np.array(torch.tensor(buffer1).reshape(SEQUENCE_LEN//32, HIDDEN_DIM, 32, 2).permute(0, 2, 1, 3).reshape(SEQUENCE_LEN, HIDDEN_DIM, 2).flatten(), dtype=np.uint8))
    
    ## then caculate the last op(logits)
    ## logits_src from bypass(SEQUENCE_LEN, HIDDEN_DIM) * weight(HIDDEN_DIM,2) -> logits(SEQUENCE_LEN,2) ->just got the last 2 result
    #weight_index, _ = return_meta("score.weight")
    
    # we just need the last row for computation
    #result_src_index = (SEQUENCE_LEN-1)*HIDDEN_DIM * 2
    
    for m in range(HIDDEN_DIM):    
        result_src=np.frombuffer((np.int16(buffer1[result_src_index+1+m*2])<<8)|np.int16(buffer1[result_src_index+m*2]), dtype=np.float16)[0]
        
        weight0 = np.frombuffer((np.int16(ddr_array[weight_index+3+m*4])<<8)|np.int16(ddr_array[weight_index+2+m*4]), dtype=np.float16)[0]
        output_0 += weight0 * result_src
        
        weight1 = np.frombuffer((np.int16(ddr_array[weight_index+1+m*4])<<8)|np.int16(ddr_array[weight_index+0+m*4]), dtype=np.float16)[0]
        output_1 += weight1 * result_src
        
    output=0 if output_0>output_1 else 1
  
    
    prefill_end_time = time.time()
    
    prefill_time = prefill_end_time - prefill_start_time
    
    output_0 = 0
    output_1 = 0
    
    print("Finish prefill.")
    
    sequence_valid_len=0
    for i in range(SEQUENCE_LEN):
        if input_token[i]==0:
            buffer0[i*(2*HIDDEN_DIM):(i+1)*(2*HIDDEN_DIM)]=[0]*(2*HIDDEN_DIM)
        else:
            buffer0[i*(2*HIDDEN_DIM):(i+1)*(2*HIDDEN_DIM)]=ddr_array[input_token[i]*(2*HIDDEN_DIM):(input_token[i]+1)*(2*HIDDEN_DIM)]
            sequence_valid_len=i+1
    np.copyto(buffer0, np.array(torch.Tensor(buffer0).reshape(SEQUENCE_LEN, HIDDEN_DIM, 2).reshape(SEQUENCE_LEN//32, 32, HIDDEN_DIM, 2).permute(0, 2, 1, 3).flatten(), dtype=np.uint8))
    torch.set_printoptions(profile="full")
    result_src_index = (sequence_valid_len-1)*HIDDEN_DIM * 2

    
    decode_start_time = time.time()
    
    os.system("./main.out")
    
    
    np.copyto(buffer1, np.array(torch.tensor(buffer1).reshape(SEQUENCE_LEN//32, HIDDEN_DIM, 32, 2).permute(0, 2, 1, 3).reshape(SEQUENCE_LEN, HIDDEN_DIM, 2).flatten(), dtype=np.uint8))
    for m in range(HIDDEN_DIM):    
        result_src=np.frombuffer((np.int16(buffer1[result_src_index+1+m*2])<<8)|np.int16(buffer1[result_src_index+m*2]), dtype=np.float16)[0]
        
        weight0 = np.frombuffer((np.int16(ddr_array[weight_index+3+m*4])<<8)|np.int16(ddr_array[weight_index+2+m*4]), dtype=np.float16)[0]
        output_0 += weight0 * result_src
        
        weight1 = np.frombuffer((np.int16(ddr_array[weight_index+1+m*4])<<8)|np.int16(ddr_array[weight_index+0+m*4]), dtype=np.float16)[0]
        output_1 += weight1 * result_src
    
       
    output=0 if output_0>output_1 else 1
  
    
    decode_end_time = time.time()
    
    
    decode_time = decode_end_time - decode_start_time
    print("Finish decode.")
    
    del buffer0
    del buffer1
    del ddr_array
    overlay.free()
    
    prefill_throughput = 1 / prefill_time
    decode_throughput = 1 / decode_time
    
    return prefill_throughput, decode_throughput