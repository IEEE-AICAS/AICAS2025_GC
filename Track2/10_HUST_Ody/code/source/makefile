# Qwen model and tokenizer binary paths
QWEN_HF_PATH         ?= /home/ubuntu/workfile/AICAS/Qwen2.5-0.5B-INT8 #your path to Qwen model HF
QWEN_BIN_MODEL_PATH  ?= $(QWEN_HF_PATH)/Qwen2.5-0.5B-Instruct.bin
QWEN_BIN_TOKEN_PATH  ?= $(QWEN_HF_PATH)/tokenizer.bin
XCLBIN_PATH          ?= ./binary_container_1.bin

# Vitis XRT environment
CXX         := aarch64-linux-gnu-g++
SYSROOT     := /home/ht/workfile/vitis_workspace/zynqmp_common_image_sdk/sdk/sysroots/cortexa72-cortexa53-xilinx-linux
XRT_INCLUDE := $(SYSROOT)/usr/include/xrt
XRT_LIB     := $(SYSROOT)/usr/lib

# CXXFLAGS := -std=c++14 -Ofast -fPIC -shared -fopenmp -march=armv8.2-a+fp+simd+crypto -mtune=cortex-a72  \
# Compiler flags
CXXFLAGS := -std=c++1y -Ofast -Wall -fPIC -shared -fopenmp -march=armv8-a+fp+simd -mtune=cortex-a72 \
    -I$(XRT_INCLUDE) \
    -I/home/ht/Xilinx/Vitis_HLS/2022.2/include \
    -D__USE_XOPEN2K8 -DVITIS_PLATFORM=kv260_custom \
    -DQWEN_BIN_MODEL_PATH=\"$(QWEN_BIN_MODEL_PATH)\" \
    -DQWEN_BIN_TOKEN_PATH=\"$(QWEN_BIN_TOKEN_PATH)\" \
    -DXCLBIN_PATH=\"$(XCLBIN_PATH)\" \
    --sysroot=$(SYSROOT)

# Linker flags
LDFLAGS := -L$(XRT_LIB) \
    -luuid -lxrt_coreutil -lxilinxopencl \
    -lpthread -lrt -ldl -lcrypt -lstdc++

# Build shared library
libtest_fpga.so: runq_fpga.cpp
	$(CXX) $(CXXFLAGS) runq_fpga.cpp -o run_with_fpga.so $(LDFLAGS)

.PHONY: clean
clean:
	rm -f libtest_fpga.so *.o
