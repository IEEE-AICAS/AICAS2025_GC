# Makefile
QWEN_HF_PATH = model/
QWEN_BIN_MODEL_PATH ?= 
CC = CC # or clang

########## Hf Model ###########
${QWEN_HF_PATH}:
	@if [ ! -f "${QWEN_HF_PATH}" ]; then \
		echo "Error: ${QWEN_HF_PATH} does not exist!"; \
		exit 1; \
	fi

########## Accuracy test ################
acc_eva: ${USE_PYTHON_TOKEN_SO}
	python acc.py --hf_path ${QWEN_HF_PATH} --bench_path eva/dev.tsv

########## Throughput test ###########
thpt_eva: ${USE_C_TOKEN_SO}
	python python_c_throughput.py --hf_path ${QWEN_HF_PATH} --bench_path eva/prompt.txt

########## Compress ratio test ###########
comp_eva:
	python gen_comp_rate.py
