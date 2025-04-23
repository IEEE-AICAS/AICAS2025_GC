# Makefile
QWEN_HF_PATH         ?= /home/ubuntu/workfile/AICAS/Qwen2.5-0.5B-INT8 # your HF model path
QWEN_BIN_MODEL_PATH  ?= $(QWEN_HF_PATH)/Qwen2.5-0.5B-Instruct.bin
QWEN_BIN_TOKEN_PATH  ?= $(QWEN_HF_PATH)/tokenizer.bin


CC ?= gcc # or clang


########## Shared lib ###########

USE_C_TOKEN_SO = ./run_with_fpga.so   #.so file path 
USE_PYTHON_TOKEN_SO =./run_with_fpga.so

########## Hf Model ###########
${QWEN_HF_PATH}:
	@if [ ! -f "${QWEN_HF_PATH}" ]; then \
		echo "Error: ${QWEN_HF_PATH} does not exist!"; \
		exit 1; \
	fi





########## Accuracy test ################
acc_eva: ${USE_PYTHON_TOKEN_SO}
	python3 eva/acc.py --hf_path ${QWEN_HF_PATH}  --so_path ${USE_PYTHON_TOKEN_SO} --bench_path eva/final.tsv


########## Throughput test ###########
thpt_eva: ${USE_C_TOKEN_SO}
	python3 eva/python_c_throughput.py --so_path  ${USE_C_TOKEN_SO} --bench_path eva/prompt.txt

########## Compress ratio test ###########
comp_eva:
	python eva/gen_comp_rate.py

clean:
	rm -f *.so
	rm runq