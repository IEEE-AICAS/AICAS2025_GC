import re
import os

binaries_path = "C:/projects/AAAProjects/PROJ17_LLM_QWEN/LLM_CPP/cmake-build-debug/binaries/"
condense_path = "C:/projects/AAAProjects/PROJ17_LLM_QWEN/LLM_CPP/cmake-build-debug/condense/"

for decoder_id in range(24):
    X_src_file = f"decoder_{decoder_id}/MHA_X.bin"
    X_tgt_file = f"X_{decoder_id}.bin"
    Y_src_file = f"decoder_{decoder_id}/MLP_XD_RES.bin"
    Y_tgt_file = f"Y_{decoder_id}.bin"
    W_src_file = f"decoder_{decoder_id}/CONDENSED_WEIGHT.bin"
    W_tgt_file = f"CONDENSED_WEIGHT_{decoder_id}.bin"
    # use scp to copy
    target_ip = "162.105.183.165"
    target_path = f"/home/xilinx/jupyter_notebooks/projects/PROJ03_QWEN/bin"
    os.system(f"scp {binaries_path}{X_src_file} xilinx@{target_ip}:{target_path}/{X_tgt_file}")
    os.system(f"scp {binaries_path}{Y_src_file} xilinx@{target_ip}:{target_path}/{Y_tgt_file}")
    os.system(f"scp {condense_path}{W_src_file} xilinx@{target_ip}:{target_path}/{W_tgt_file}")

# special handle CLS
for decoder_id in [24]:
    X_src_file = f"decoder_{decoder_id}/CLS_X.bin"
    X_tgt_file = f"CLS_X.bin"
    Y_src_file = f"decoder_{decoder_id}/CLS.bin"
    Y_tgt_file = f"CLS.bin"
    W_src_file = f"decoder_{decoder_id}/CONDENSED_WEIGHT.bin"
    W_tgt_file = f"CONDENSED_WEIGHT_{decoder_id}.bin"
    # use scp to copy
    target_ip = "162.105.183.165"
    target_path = f"/home/xilinx/jupyter_notebooks/projects/PROJ03_QWEN/bin"
    os.system(f"scp {binaries_path}{X_src_file} xilinx@{target_ip}:{target_path}/{X_tgt_file}")
    os.system(f"scp {binaries_path}{Y_src_file} xilinx@{target_ip}:{target_path}/{Y_tgt_file}")
    os.system(f"scp {condense_path}{W_src_file} xilinx@{target_ip}:{target_path}/{W_tgt_file}")

# upload embedding
for decoder_id in [0]:
    X_src_file = f"EMBEDDING.bin"
    X_tgt_file = f"EMBEDDING.bin"
    # use scp to copy
    target_ip = "162.105.183.165"
    target_path = f"/home/xilinx/jupyter_notebooks/projects/PROJ03_QWEN/bin"
    os.system(f"scp {condense_path}{X_src_file} xilinx@{target_ip}:{target_path}/{X_tgt_file}")

