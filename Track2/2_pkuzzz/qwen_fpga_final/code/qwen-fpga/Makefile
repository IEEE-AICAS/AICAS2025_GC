# Makefile

QWEN_HF_PATH ?= qwen_model/
QWEN_BIN_MODEL_PATH ?= Qwen2.5-0.5B-Instruct.bin
QWEN_QUANT_W4A8_BIN_MODEL_PATH ?= Qwen2.5-0.5B-Instruct-Quant-w4a8.bin
QWEN_QUANT_W4A8_V4_BIN_MODEL_PATH ?= Qwen2.5-0.5B-Instruct-Quant-w4a8-v4.bin
QWEN_BIN_TOKEN_PATH ?= tokenizer.bin
XCLBIN_NAME ?= w4a8_infer_250M_v5
GEMM_KERNEL_NAME ?= w4a8_gemm
GEMV_KERNEL_NAME ?= w4a8_gemv
CC = /usr/bin/gcc
CXX = /usr/bin/g++

XCLBIN_PATH = ${XCLBIN_NAME}.xclbin
WI_GRID_PER_BUF ?= 2
WI_ELEM_PER_GRID ?= 32
MODEL_PATH = ${QWEN_QUANT_W4A8_V4_BIN_MODEL_PATH}

# blas
# TODO: Chenhao thinks we need to prepare the development env once and for all.
# 		Stop wasting time maintaining two versions that support both w/ blas and w/o blas
BLAS_CONDA_PREFIX ?= $(dir $(abspath $(lastword $(MAKEFILE_LIST)))).conda_blas

# xrt 
XRT_INCLUDE ?= /usr/include/xrt

PARAMS_FLAGS = -DXCLBIN_PATH='"${XCLBIN_PATH}"' -DGEMM_KERNEL_NAME='"${GEMM_KERNEL_NAME}"' -DGEMV_KERNEL_NAME='"${GEMV_KERNEL_NAME}"' -DQWEN_BIN_MODEL_PATH='"${MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' \
			   -DWI_GRID_PER_BUF=${WI_GRID_PER_BUF} -DWI_ELEM_PER_GRID=${WI_ELEM_PER_GRID}

CFLAGS = -Ofast -fopenmp -march=native -I./include -I${XRT_INCLUDE} ${PARAMS_FLAGS} -fPIC
LDFLAGS = -lm 

FPGA_FLAGS = -DFPGA
FPGA_LDFLAGS = -lxrt_coreutil -pthread 

## debug ##
ifdef DEBUG
  ifeq ($(DEBUG), 1)
	CFLAGS += -g
  endif
endif

## profile ##
ifdef PROFILE
  ifeq ($(PROFILE), 1)
	CFLAGS += -DPROFILE
  endif
endif

## blas ##
CFLAGS += -DBLAS -I${BLAS_CONDA_PREFIX}/include 
LDFLAGS += -L${BLAS_CONDA_PREFIX}/lib -Wl,-rpath,$(BLAS_CONDA_PREFIX)/lib -lopenblas

########## Shared lib ###########
USE_PYTHON_TOKEN_SO = run_with_python_tokenizer.so
USE_PYTHON_TOKEN_QUANT_W4A8_SO = run_with_python_tokenizer_quant_w4a8.so
USE_C_TOKEN_SO = run_with_c_tokenizer.so
USE_C_TOKEN_QUANT_W4A8_SO = run_with_c_tokenizer_quant_w4a8.so

${USE_PYTHON_TOKEN_SO}: run.c ${QWEN_BIN_MODEL_PATH} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITHOUT_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native run.c -lm  -o ${USE_PYTHON_TOKEN_SO}

${USE_PYTHON_TOKEN_QUANT_W4A8_SO}: runq4.c ${QWEN_QUANT_W4A8_BIN_MODEL_PATH} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITHOUT_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_QUANT_W4A8_BIN_MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native runq4.c -lm  -o ${USE_PYTHON_TOKEN_QUANT_W4A8_SO}

${USE_C_TOKEN_SO}: run.c ${QWEN_BIN_MODEL_PATH} ${QWEN_BIN_TOKEN_PATH} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITH_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native run.c -lm  -o ${USE_C_TOKEN_SO}

${USE_C_TOKEN_QUANT_SO}: runq.c ${QWEN_QUANT_BIN_MODEL_PATH} ${QWEN_BIN_TOKEN_PATH} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITH_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_QUANT_BIN_MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native runq.c -lm  -o ${USE_C_TOKEN_QUANT_SO}

${USE_C_TOKEN_QUANT_W4A8_SO}: runq4.c ${QWEN_QUANT_W4A8_BIN_MODEL_PATH} ${QWEN_BIN_TOKEN_PATH} Makefile
	$(CC) -shared -fPIC -Ofast -fopenmp -DWITH_C_EN_DECODE -DQWEN_BIN_MODEL_PATH='"${QWEN_QUANT_W4A8_BIN_MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' -march=native runq4.c -lm  -o ${USE_C_TOKEN_QUANT_W4A8_SO}

########## Hf Model ###########
${QWEN_HF_PATH}:
	@if [ ! -f "${QWEN_HF_PATH}" ]; then \
		echo "Error: ${QWEN_HF_PATH} does not exist!"; \
		exit 1; \
	fi

########## Export bin Model ###########
${QWEN_BIN_MODEL_PATH}: ${QWEN_HF_PATH}
	python export/export_qwen2_bin.py ${QWEN_BIN_MODEL_PATH} --hf=${QWEN_HF_PATH} --version=0;
	
${QWEN_QUANT_W4A8_BIN_MODEL_PATH}: ${QWEN_HF_PATH}
	python export/export_qwen2_bin.py ${QWEN_QUANT_W4A8_BIN_MODEL_PATH} --hf=${QWEN_HF_PATH} --version=5;

${QWEN_QUANT_W4A8_V4_BIN_MODEL_PATH}: ${QWEN_HF_PATH}
	python export/export_qwen2_bin.py ${QWEN_QUANT_W4A8_V4_BIN_MODEL_PATH} --hf=${QWEN_HF_PATH} --version=7 --wi_grid_per_buf=${WI_GRID_PER_BUF} --wi_elem_per_grid=${WI_ELEM_PER_GRID};

${QWEN_BIN_TOKEN_PATH}: ${QWEN_HF_PATH} 
	python export/export_token_bin.py ${QWEN_HF_PATH} ${QWEN_BIN_TOKEN_PATH}

######### Define some names for so #######

########## Plain C run ###########
all_c_infer: run.c ${QWEN_BIN_MODEL_PATH} ${QWEN_BIN_TOKEN_PATH}
	$(CC) -Ofast -fopenmp -march=native -DNORMAL -DQWEN_BIN_MODEL_PATH='"${QWEN_BIN_MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' run.c  -lm  -o run

all_c_infer_quant_w4a8: runq4.c ${QWEN_QUANT_W4A8_BIN_MODEL_PATH} ${QWEN_BIN_TOKEN_PATH}
	$(CC) -Ofast -fopenmp -march=native -DNORMAL -DQWEN_BIN_MODEL_PATH='"${QWEN_QUANT_W4A8_BIN_MODEL_PATH}"' -DQWEN_BIN_TOKEN_PATH='"${QWEN_BIN_TOKEN_PATH}"' runq4.c  -lm  -o runq4

########## Accuracy test ################
acc_eva: ${USE_PYTHON_TOKEN_SO}
	python eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath ${USE_PYTHON_TOKEN_SO}) --bench_path eva/dev.tsv

acc_eva_final: ${USE_PYTHON_TOKEN_SO}
	python eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath ${USE_PYTHON_TOKEN_SO}) --bench_path eva/final.tsv

acc_eva_quant_w4a8: ${USE_PYTHON_TOKEN_QUANT_W4A8_SO}
	python eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath ${USE_PYTHON_TOKEN_QUANT_W4A8_SO}) --bench_path eva/dev.tsv

########## Throughput test ###########
thpt_eva: ${USE_C_TOKEN_SO}
	python eva/python_c_throughput.py --so_path $(shell realpath ${USE_C_TOKEN_SO}) --bench_path eva/prompt.txt

thpt_eva_quant_w4a8: ${USE_C_TOKEN_QUANT_W4A8_SO}
	python eva/python_c_throughput.py --so_path $(shell realpath ${USE_C_TOKEN_QUANT_W4A8_SO}) --bench_path eva/prompt.txt

########## Compress ratio test ###########
comp_eva: ${QWEN_BIN_MODEL_PATH}
	python eva/gen_comp_rate.py --file_path ${QWEN_BIN_MODEL_PATH}

comp_eva_quant_w4a8: ${QWEN_QUANT_W4A8_BIN_MODEL_PATH}
	python eva/gen_comp_rate.py --file_path ${QWEN_QUANT_W4A8_BIN_MODEL_PATH}

## flags ##
build/.flags: FORCE
	@mkdir -p build/
	@echo "$(DEBUG) $(PROFILE) $(BLAS)" | cmp -s $@ - || echo "$(DEBUG) $(PROFILE) $(BLAS)" > $@

INCLUDE_FILES := $(wildcard include/*.h)

## src ###
build/%.c.o: src/%.c ${INCLUDE_FILES} Makefile build/.flags ${BLAS_CONDA_PREFIX}
	$(CC) -c $< -o $@ ${CFLAGS}

build/%_fpga.c.o: src/%.c ${INCLUDE_FILES} Makefile build/.flags ${BLAS_CONDA_PREFIX}
	$(CC) -c $< -o $@ ${CFLAGS} ${FPGA_FLAGS}
	
SRC_FILES := $(wildcard src/*.c)

CPU_OBJ_FILES := $(patsubst src/%.c, build/%.c.o, $(SRC_FILES))

FPGA_OBJ_FILES := $(patsubst src/%.c, build/%_fpga.c.o, $(SRC_FILES))

## test ##
build/test_xrt_utils: test/test_xrt_utils.c build/xrt_utils.c.o
	$(CC) $^ -o $@ ${CFLAGS} ${LDFLAGS} ${FPGA_LDFLAGS}

build/test_cpu.so: test/test_cpu.c build/cpu.c.o
	$(CC) -shared -fPIC $^ -o $@ ${CFLAGS} 

build/test_cpu: build/test_cpu.so
	python test/test_cpu.py --so_path $<

build/test_fpga: test/test_fpga.c $(FPGA_OBJ_FILES)
	$(CC) $^ -o $@ ${CFLAGS} ${LDFLAGS} ${FPGA_LDFLAGS}

build/test_runq: runq.c $(CPU_OBJ_FILES)
	$(CC) -DNORMAL $^ -o $@ ${CFLAGS} ${LDFLAGS}

build/test_runq_fpga: runq.c $(FPGA_OBJ_FILES)
	$(CC) -DNORMAL $^ -o $@ ${CFLAGS} ${LDFLAGS} ${FPGA_FLAGS} ${FPGA_LDFLAGS}

build/runq.so: runq.c $(CPU_OBJ_FILES)
	$(CC) -shared -DWITH_C_EN_DECODE $^ -o $@ ${CFLAGS} ${LDFLAGS}

build/runq_fpga_w_c.so: runq.c $(FPGA_OBJ_FILES)
	$(CC) -shared -DWITH_C_EN_DECODE $^ -o $@ ${CFLAGS} ${LDFLAGS} ${FPGA_FLAGS} ${FPGA_LDFLAGS}

build/runq_fpga_wo_c.so: runq.c $(FPGA_OBJ_FILES)
	$(CC) -shared -DWITHOUT_C_EN_DECODE $^ -o $@ ${CFLAGS} ${LDFLAGS} ${FPGA_FLAGS} ${FPGA_LDFLAGS}

thpt: build/runq.so
	python eva/python_c_throughput.py --so_path $(shell realpath $<) --bench_path eva/prompt.txt

thpt_fpga: build/runq_fpga_w_c.so
	python eva/python_c_throughput.py --so_path $(shell realpath $<) --bench_path eva/prompt.txt

acc_fpga: build/runq_fpga_wo_c.so
	python eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath $<) --bench_path eva/dev.tsv

acc_fpga_final: build/runq_fpga_wo_c.so
	python eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath $<) --bench_path eva/final.tsv

comp_fpga: ${MODEL_PATH}
	python eva/gen_comp_rate.py --file_path ${MODEL_PATH}

build/test_prefill_attn: test/test_prefill_attn.c build/cpu.c.o build/frontend.c.o build/ir.c.o build/profile.c.o
	$(CC) $^ -o $@ ${CFLAGS} ${LDFLAGS}

setup: setup.sh Makefile
	bash $< ${XCLBIN_NAME}

clean:
	rm -f build/* *.so run run_* runq runq_* runq4 runq4_* runbf runbf_*

clean_all:
	rm -rf *.bin ${BLAS_CONDA_PREFIX}

.PHONY: FORCE clean
