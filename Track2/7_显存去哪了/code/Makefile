# Makefile

QWEN_HF_PATH ?= ./model
QWEN_BIN_MODEL_PATH ?= ./bin/Qwen2.5-0.5B-Instruct_q80.bin
QWEN_BIN_TOKEN_PATH ?= ./bin/tokenizer.bin
CC ?= gcc # or clang

########## Shared lib ###########
USE_PYTHON_TOKEN_SO = run_with_python_tokenizer.so
USE_C_TOKEN_SO = run_with_c_tokenizer.so

${USE_PYTHON_TOKEN_SO}: run.c ${QWEN_BIN_MODEL_PATH} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITHOUT_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native run.c dma_app.c -lm  -o ${USE_PYTHON_TOKEN_SO}

${USE_C_TOKEN_SO}: run.c ${QWEN_BIN_MODEL_PATH} ${QWEN_BIN_TOKEN_PATH} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITH_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native run.c dma_app.c -lm  -o ${USE_C_TOKEN_SO}

########## Hf Model ###########
${QWEN_HF_PATH}:
	@if [ ! -f "${QWEN_HF_PATH}" ]; then \
		echo "Error: ${QWEN_HF_PATH} does not exist!"; \
		exit 1; \
	fi

########## Export bin Model ###########
${QWEN_BIN_MODEL_PATH}: ${QWEN_HF_PATH}
	@if [ ! -f "${QWEN_BIN_MODEL_PATH}" ]; then \
		echo "Generating ${QWEN_BIN_MODEL_PATH}..."; \
		python export/export_qwen2_bin.py ${QWEN_BIN_MODEL_PATH} --hf=${QWEN_HF_PATH}; \
	else \
		echo "${QWEN_BIN_MODEL_PATH} already exists, skipping."; \
	fi

${QWEN_BIN_TOKEN_PATH}: ${QWEN_HF_PATH}
	@if [ ! -f "${QWEN_BIN_TOKEN_PATH}" ]; then \
		echo "Generating ${QWEN_BIN_TOKEN_PATH}..."; \
		python export/export_token_bin.py ${QWEN_HF_PATH} ${QWEN_BIN_TOKEN_PATH}; \
	else \
		echo "${QWEN_BIN_TOKEN_PATH} already exists, skipping."; \
	fi

######### Define some names for so #######

########## Plain C run ###########
# all_c_infer: run.c ${QWEN_BIN_MODEL_PATH} ${QWEN_BIN_TOKEN_PATH}
# 	$(CC) -Ofast -fopenmp -march=native -DNORMAL -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' run.c  -lm  -o run 
all_c_infer: run.c ${QWEN_BIN_MODEL_PATH} ${QWEN_BIN_TOKEN_PATH}
	$(CC) -Ofast -fopenmp -march=native -DNORMAL -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' run.c dma_app.c -lm  -o run

########## Accuracy test ################
acc_eva: ${USE_PYTHON_TOKEN_SO}
	python eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath ${USE_PYTHON_TOKEN_SO}) --bench_path eva/final.tsv

########## Throughput test ###########
thpt_eva: ${USE_C_TOKEN_SO}
	python eva/python_c_throughput.py --so_path $(shell realpath ${USE_C_TOKEN_SO}) --bench_path eva/prompt.txt

########## Compress ratio test ###########
comp_eva:
	python eva/gen_comp_rate.py

clean:
	rm -f *.so
	rm run