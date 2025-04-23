# Makefile

# QWEN_HF_PATH ?= YOUR_Qwen2.5-0.5B-Instruct_PATH
# QWEN_HF_PATH ?= /home/wei/Desktop/git/AICAS/Qwen-0.5B-Instruct
QWEN_HF_PATH ?= /home/ubuntu/AICAS/AICAS/Qwen2.5-0.5B-Instruct/
#QWEN_HF_PATH ?= /root/sjtu-bin/Qwen2.5-0.5B-Instruct
# QWEN_HF_PATH ?= /home/wei/Desktop/git/AICAS/Qwen2.5-0.5B-Instruct-AWQ_dequantize
#QWEN_HF_PATH ?= /home/wei/Desktop/git/AICAS/Qwen2.5-0.5B-Instruct-AWQ
# QWEN_HF_PATH ?= /home/wei/Desktop/git/AICAS/gguf/qwen2.5-0.5b-instruct-q8_0.gguf
QWEN_BIN_MODEL_PATH ?= /home/ubuntu/AICAS/AICAS/Qwen2.5-0.5B-Instruct.bin
QWEN_BIN_MODEL_PATH_ORI ?= /home/ubuntu/AICAS/AICAS/Qwen2.5-0.5B-Instruct.bin
QWEN_BIN_MODEL_PATH_RUNQ ?= /home/ubuntu/AICAS/AICAS/Qwen2.5-0.5B-Instruct-runq.bin
QWEN_BIN_MODEL_PATH_RUNQ_1 ?= Qwen2.5-0.5B-Instruct-runq-without-bias.bin
#QWEN_BIN_MODEL_PATH ?= Qwen2.5-0.5B-Instruct-awq.bin
#QWEN_BIN_MODEL_PATH ?= Qwen2.5-0.5B-Instruct-awq-scale2.bin
#QWEN_BIN_MODEL_PATH ?= Qwen2.5-0.5B-Instruct-int8.bin
#QWEN_BIN_MODEL_PATH ?= Qwen2.5-0.5B-Instruct-int4-1.bin
#QWEN_BIN_MODEL_PATH ?= Qwen2.5-0.5B-Instruct-int4-scale2.bin
#QWEN_BIN_MODEL_PATH ?= Qwen2.5-0.5B-Instruct-int8-0114.bin
#QWEN_BIN_TOKEN_PATH ?= /root/sjtu-bin/tokenizer.bin
QWEN_BIN_TOKEN_PATH ?= /home/ubuntu/AICAS/AICAS/tokenizer.bin
CC ?= gcc # or clang

########## Shared lib ###########
USE_PYTHON_TOKEN_SO = run_with_python_tokenizer.so
USE_PYTHON_TOKEN_SO_STATISTIC = run_with_python_tokenizer_statistic.so
USE_PYTHON_TOKEN_SO_CC = run_with_python_tokenizer_cc.so
USE_PYTHON_TOKEN_SO_S_FLOAT = run_with_python_tokenizer_s_float.so
USE_PYTHON_TOKEN_SO_S_FLOAT_WITHOUT_BIAS = run_with_python_tokenizer_s_float_without_bias.so
USE_PYTHON_TOKEN_SO_S_FLOAT_DEBUG = run_with_python_tokenizer_s_float_debug
USE_PYTHON_TOKEN_SO_S_FLOAT_XW = run_with_python_tokenizer_s_float_xw.so
USE_PYTHON_TOKEN_SO_S_FLOAT_XW_TEST = run_with_python_tokenizer_s_float_xw_test.so
USE_PYTHON_TOKEN_SO_S_FLOAT_XW_P = run_with_python_tokenizer_s_float_xw_p.so
USE_C_TOKEN_SO = run_with_c_tokenizer.so
USE_C_TOKEN_SO_RUNQ = run_with_c_tokenizer_runq.so
USE_C_TOKEN_SO_RUNQ_XW = run_with_c_tokenizer_runq_xw.so
USE_C_TOKEN_SO_RUNQ_XW_TEST = run_with_c_tokenizer_runq_xw_test.so
USE_C_TOKEN_SO_RUNQ_XW_P = run_with_c_tokenizer_runq_xw_p.so

${USE_PYTHON_TOKEN_SO}: run.c ${QWEN_BIN_MODEL_PATH} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITHOUT_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native run.c -lm  -o ${USE_PYTHON_TOKEN_SO}

# ${USE_PYTHON_TOKEN_SO_STATISTIC}: run_statistic.c ${QWEN_BIN_MODEL_PATH_ORI} Makefile
# 	g++ -fpermissive -I /home/wei/Desktop/git/AICAS/eigen -std=c++17 -shared -fPIC -Ofast -fopenmp -DWITHOUT_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_ORI}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native run_statistic.c -lm  -o ${USE_PYTHON_TOKEN_SO_STATISTIC}

${USE_PYTHON_TOKEN_SO_STATISTIC}: run_statistic.c ${QWEN_BIN_MODEL_PATH_ORI} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITHOUT_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_ORI}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native run_statistic.c -lm  -o ${USE_PYTHON_TOKEN_SO_STATISTIC}

${USE_PYTHON_TOKEN_SO_S_FLOAT}: runq_s_float.c ${QWEN_BIN_MODEL_PATH_RUNQ} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITHOUT_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_RUNQ}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native runq_s_float.c -lm  -o ${USE_PYTHON_TOKEN_SO_S_FLOAT}

${USE_PYTHON_TOKEN_SO_S_FLOAT_DEBUG}: runq_s_float.c ${QWEN_BIN_MODEL_PATH_ORI} Makefile
	$(CC) -ggdb -fPIC -Ofast -fopenmp -DNORMAL -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_ORI}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native runq_s_float.c -lm  -o ${USE_PYTHON_TOKEN_SO_S_FLOAT_DEBUG}

${USE_PYTHON_TOKEN_SO_S_FLOAT_WITHOUT_BIAS}: runq_without_bias.c ${QWEN_BIN_MODEL_PATH_RUNQ_1} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITHOUT_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_RUNQ_1}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native runq_without_bias.c -lm  -o ${USE_PYTHON_TOKEN_SO_S_FLOAT_WITHOUT_BIAS}

${USE_PYTHON_TOKEN_SO_S_FLOAT_XW}: runq_s_float_xw.c ${QWEN_BIN_MODEL_PATH_RUNQ} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITHOUT_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_RUNQ}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native runq_s_float_xw.c -lm  -o ${USE_PYTHON_TOKEN_SO_S_FLOAT_XW} -lpynq -lcma -lpthread

${USE_PYTHON_TOKEN_SO_S_FLOAT_XW_TEST}: runq_s_float_xw_test.c ${QWEN_BIN_MODEL_PATH_RUNQ} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITHOUT_C_EN_DECODE -DNDEBUG -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_RUNQ}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native runq_s_float_xw_test.c -lm  -o ${USE_PYTHON_TOKEN_SO_S_FLOAT_XW_TEST}

${USE_PYTHON_TOKEN_SO_S_FLOAT_XW_P}: runq_s_float_xw_prefill.c ${QWEN_BIN_MODEL_PATH_RUNQ} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITHOUT_C_EN_DECODE -DNDEBUG -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_RUNQ}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native runq_s_float_xw_prefill.c -lm  -o ${USE_PYTHON_TOKEN_SO_S_FLOAT_XW_P} -lpynq -lcma -lpthread

${USE_C_TOKEN_SO}: run.c ${QWEN_BIN_MODEL_PATH} ${QWEN_BIN_TOKEN_PATH} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITH_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native run.c -lm  -o ${USE_C_TOKEN_SO}

${USE_C_TOKEN_SO_RUNQ}: runq_s_float.c ${QWEN_BIN_MODEL_PATH_RUNQ} ${QWEN_BIN_TOKEN_PATH} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITH_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_RUNQ}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native runq_s_float.c -lm  -o ${USE_C_TOKEN_SO_RUNQ}

${USE_C_TOKEN_SO_RUNQ_XW}: runq_s_float_xw.c ${QWEN_BIN_MODEL_PATH_RUNQ} ${QWEN_BIN_TOKEN_PATH} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITH_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_RUNQ}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native runq_s_float_xw.c -lm  -o ${USE_C_TOKEN_SO_RUNQ_XW} -lpynq -lcma -lpthread

${USE_C_TOKEN_SO_RUNQ_XW_TEST}: runq_s_float_xw_test.c ${QWEN_BIN_MODEL_PATH_RUNQ} ${QWEN_BIN_TOKEN_PATH} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITH_C_EN_DECODE -DNDEBUG -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_RUNQ}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native runq_s_float_xw_test.c -lm  -o ${USE_C_TOKEN_SO_RUNQ_XW_TEST}

${USE_C_TOKEN_SO_RUNQ_XW_P}: runq_s_float_xw_prefill.c ${QWEN_BIN_MODEL_PATH_RUNQ} ${QWEN_BIN_TOKEN_PATH} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITH_C_EN_DECODE -DNDEBUG -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_RUNQ}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native runq_s_float_xw_prefill.c -lm  -o ${USE_C_TOKEN_SO_RUNQ_XW_P} -lpynq -lcma -lpthread

########## Hf Model ###########
${QWEN_HF_PATH}:
	@if [ ! -f "${QWEN_HF_PATH}" ]; then \
		echo "Error: ${QWEN_HF_PATH} does not exist!"; \
		exit 1; \
	fi

########## Export bin Model ###########
#${QWEN_BIN_MODEL_PATH}: ${QWEN_HF_PATH}
#	python export/export_qwen2_bin.py ${QWEN_BIN_MODEL_PATH} --hf=${QWEN_HF_PATH}
#	
#${QWEN_BIN_MODEL_PATH_RUNQ}: ${QWEN_HF_PATH}
#	python export/export_qwen2_bin.py ${QWEN_BIN_MODEL_PATH_RUNQ} --hf=${QWEN_HF_PATH} --version=6

#${QWEN_BIN_MODEL_PATH_RUNQ_1}: ${QWEN_HF_PATH}
#	python export/export_qwen2_bin.py ${QWEN_BIN_MODEL_PATH_RUNQ_1} --hf=${QWEN_HF_PATH} --version=7

#${QWEN_BIN_TOKEN_PATH}: ${QWEN_HF_PATH} 
#	python export/export_token_bin.py ${QWEN_HF_PATH} ${QWEN_BIN_TOKEN_PATH}

######### Define some names for so #######

########## Plain C run ###########
all_c_infer: run.c ${QWEN_BIN_MODEL_PATH} ${QWEN_BIN_TOKEN_PATH}
	$(CC) -Ofast -fopenmp -march=native -DNORMAL -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' run.c  -lm  -o run
    
all_c_infer_runq_xw: runq_s_float_xw.c ${QWEN_BIN_MODEL_PATH_RUNQ} ${QWEN_BIN_TOKEN_PATH}
	$(CC) -Ofast -fopenmp -march=native -DNORMAL -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_RUNQ}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' runq_s_float_xw.c  -lm  -o runq_xw -lpynq -lcma -lpthread

########## Accuracy test ################
acc_eva: ${USE_PYTHON_TOKEN_SO}
	python eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath ${USE_PYTHON_TOKEN_SO}) --bench_path eva/dev.tsv

acc_eva_statistic: ${USE_PYTHON_TOKEN_SO_STATISTIC}
	python eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath ${USE_PYTHON_TOKEN_SO_STATISTIC}) --bench_path eva/dev.tsv
acc_eva_s_float: ${USE_PYTHON_TOKEN_SO_S_FLOAT}
	python eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath ${USE_PYTHON_TOKEN_SO_S_FLOAT}) --bench_path eva/dev.tsv

acc_eva_s_float_without_bias: ${USE_PYTHON_TOKEN_SO_S_FLOAT_WITHOUT_BIAS}
	python eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath ${USE_PYTHON_TOKEN_SO_S_FLOAT_WITHOUT_BIAS}) --bench_path eva/dev.tsv

acc_eva_s_float_xw: ${USE_PYTHON_TOKEN_SO_S_FLOAT_XW}
	python eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath ${USE_PYTHON_TOKEN_SO_S_FLOAT_XW}) --bench_path eva/dev.tsv

acc_eva_s_float_xw_test: ${USE_PYTHON_TOKEN_SO_S_FLOAT_XW_TEST}
	python eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath ${USE_PYTHON_TOKEN_SO_S_FLOAT_XW_TEST}) --bench_path eva/dev.tsv

acc_eva_s_float_xw_prefill: ${USE_PYTHON_TOKEN_SO_S_FLOAT_XW_P}
	/home/ubuntu/anaconda3/envs/aicas/bin/python eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath ${USE_PYTHON_TOKEN_SO_S_FLOAT_XW_P}) --bench_path eva/dev.tsv

########## Throughput test ###########
thpt_eva: ${USE_C_TOKEN_SO}
	python eva/python_c_throughput.py --so_path $(shell realpath ${USE_C_TOKEN_SO}) --bench_path eva/prompt.txt

thpt_eva_runq: ${USE_C_TOKEN_SO_RUNQ}
	python eva/python_c_throughput.py --so_path $(shell realpath ${USE_C_TOKEN_SO_RUNQ}) --bench_path eva/prompt.txt

thpt_eva_runq_xw: ${USE_C_TOKEN_SO_RUNQ_XW}
	/home/ubuntu/anaconda3/envs/aicas/bin/python eva/python_c_throughput.py --so_path $(shell realpath ${USE_C_TOKEN_SO_RUNQ_XW}) --bench_path eva/prompt.txt

thpt_eva_runq_xw_test: ${USE_C_TOKEN_SO_RUNQ_XW_TEST}
	/home/ubuntu/anaconda3/envs/aicas/bin/python eva/python_c_throughput.py --so_path $(shell realpath ${USE_C_TOKEN_SO_RUNQ_XW_TEST}) --bench_path eva/prompt.txt

thpt_eva_runq_xw_prefill: ${USE_C_TOKEN_SO_RUNQ_XW_P}
	/home/ubuntu/anaconda3/envs/aicas/bin/python eva/python_c_throughput.py --so_path $(shell realpath ${USE_C_TOKEN_SO_RUNQ_XW_P}) --bench_path eva/prompt.txt

########## Compress ratio test ###########
comp_eva:
	python eva/gen_comp_rate.py

clean:
	rm -f *.so
	rm run

EIGEN_PATH ?= eigen
USE_EIGEN_ACC ?= g++ -I  $(EIGEN_PATH) -std=c++17 -DCOPY_WEIGHTS -Ofast -DNDEBUG
#-DSHOW_FINISHED -DSHOW_TIME#-Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize
USE_EIGEN_THPT ?= g++ -I $(EIGEN_PATH) -std=c++17 -DCOPY_WEIGHTS -Ofast -DNDEBUG #-DUSE_MATMUL_EIGEN#-DUSE_FPGA
#-DSHOW_FINISHED -DSHOW_TIME
#-Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize
# -DTRANSPOSE_WEIGHTS# -O3 #-DSHOW_FINISHED -DSHOW_TIME # -ggdb -Rpass=loop-vectorize -ffast-math 

USE_PYTHON_TOKEN_SO_CC = run_with_python_tokenizer_cc.so
USE_PYTHON_TOKEN_SO_S_FLOAT_CC = run_with_python_tokenizer_s_float_cc.so
USE_C_TOKEN_SO_RUNQ_CC = run_with_c_tokenizer_runq_cc.so

${USE_PYTHON_TOKEN_SO_CC}: run.cc ${QWEN_BIN_MODEL_PATH_RUNQ} Makefile
	${USE_EIGEN} -fPIC -fopenmp -DWITHOUT_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_RUNQ}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native run.cc -lm  -o ${USE_PYTHON_TOKEN_SO_CC}

${USE_PYTHON_TOKEN_SO_S_FLOAT_CC}: run.cc ${QWEN_BIN_MODEL_PATH_RUNQ} Makefile
	${USE_EIGEN_ACC} -shared -fPIC -fopenmp -DWITHOUT_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_RUNQ}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native run.cc -lm  -o ${USE_PYTHON_TOKEN_SO_S_FLOAT_CC}

${USE_C_TOKEN_SO_RUNQ_CC}: run.cc ${QWEN_BIN_MODEL_PATH_RUNQ} ${QWEN_BIN_TOKEN_PATH} Makefile
	${USE_EIGEN_THPT} -shared -fPIC -fopenmp -DWITH_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_RUNQ}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native run.cc -lm  -o ${USE_C_TOKEN_SO_RUNQ_CC} #-lpynq -lcma -lpthread

all_cc_infer: run.cc ${QWEN_BIN_MODEL_PATH_RUNQ} ${QWEN_BIN_TOKEN_PATH}
	${USE_EIGEN} -fopenmp -march=native -DNORMAL_CC -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH_RUNQ}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' run.cc  -lm  -o run_cc

acc_eva_s_float_cc: ${USE_PYTHON_TOKEN_SO_S_FLOAT_CC}
	python eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath ${USE_PYTHON_TOKEN_SO_S_FLOAT_CC}) --bench_path eva/final.tsv

thpt_eva_runq_cc: ${USE_C_TOKEN_SO_RUNQ_CC}
	python eva/python_c_throughput.py --so_path $(shell realpath ${USE_C_TOKEN_SO_RUNQ_CC}) --bench_path eva/prompt.txt

draft: draft.cc
	${USE_EIGEN} -fopenmp -march=native draft.cc -o draft
