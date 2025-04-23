#!/bin/bash

DEFAULT_NAME=w4a8_infer_v2
NAME=${1:-$DEFAULT_NAME}

TAR=${NAME}.tar

if [ ! -d "qwen_model" ]; then
    mkdir qwen_model
    touch -r Qwen2.5-0.5B-Instruct-Quant-w4a8.bin qwen_model
fi
sudo rm -rf /lib/firmware/xilinx/${NAME}
sudo tar -xvf ${TAR} -C /
sudo xmutil unloadapp
sudo xmutil loadapp ${NAME}
