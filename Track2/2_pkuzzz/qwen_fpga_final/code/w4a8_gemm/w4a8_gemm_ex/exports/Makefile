KERNEL_NAME:=w4a8_gemm
TARGET ?= $(KERNEL_NAME)_host_example.exe

SRC_DIRS ?= src

ifndef XILINX_XRT
$(error environment variable XILINX_XRT is not set. Please ensure the Xilinx runtime is installed and properly sourced)
endif

DEVICE ?= xilinx:kv260_som:prj:0.0
VITIS_PLATFORM_VLNV := $(DEVICE)

VITIS_PLATFORM := $(subst :,_,$(VITIS_PLATFORM_VLNV))
VITIS_PLATFORM := $(subst .,_,$(VITIS_PLATFORM))
SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.s)
OBJS := $(addsuffix .o,$(basename $(SRCS)))
DEPS := $(OBJS:.o=.d)
LDLIBS := -lxilinxopencl -lpthread -lrt -lstdc++
LOADLIBES := -L$(XILINX_XRT)/lib

INC_DIRS := $(shell find $(SRC_DIRS) -type d) $(XILINX_XRT)/include
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CPPFLAGS ?= $(INC_FLAGS) -MMD -MP -std=gnu++11 -g -Wall -DVITIS_PLATFORM=$(VITIS_PLATFORM)

$(TARGET): $(OBJS)
	$(CXX) $(LDFLAGS) $(OBJS) -o $@ $(LOADLIBES) $(LDLIBS)

.PHONY: clean
clean:
	$(RM) $(TARGET) $(OBJS) $(DEPS)

-include $(DEPS)

