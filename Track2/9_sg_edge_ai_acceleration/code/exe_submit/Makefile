# Configuration Section
PATH_SRC      	?= src_c
BUILD_DIR     	:= build
SO_PY_DIR     	:= so_py
SO_C_DIR      	:= so_c
SO_C_NAME		:=librun_with_c_tokenizer.so
SO_PY_NAME		:=librun_with_python_tokenizer.so
EXEC_NAME     	:= run
CMAKE_FLAGS   	:= -DCOMPILE_MODE
QWEN_HF_PATH	:= ./Qwen2.5-0.5B-Instruct-AWQ

# Help Information
.PHONY: help
help:
	@echo "Available targets:"
	@echo "	 init	     - Initialize environment"
	@echo "  cmake       - Build normal executable with CMake"
	@echo "  clean       - Remove all build artifacts"
	@echo "  help        - Show this help message"
	@echo "	 acc_eva	 - Acc evaluation AICAS"
	@echo "	 thpt_eva	 - Thoughtput evaluation AICAS"
	@echo "	 comp_eva	 - Compress Ratio Eva AICAS"


# Build Targets
.PHONY: init
init:
	sudo cp -r vadd /lib/firmware/xilinx
	sudo xmutil unloadapp
	sudo xmutil loadapp vadd

# CMake Build Abstraction
define build_cmake_target
	@echo "Building in $(1)..."; \
	rm -rf $(1) && mkdir -p $(1) && \
	(cd $(1) && cmake $(CMAKE_FLAGS)=$(2) .. && make) || \
	(echo "CMake build failed"; exit 1)
endef

.PHONY: cmake
cmake:
	$(call build_cmake_target,$(BUILD_DIR),normal)
	@echo "Running executable..."; ./$(BUILD_DIR)/AWQ_Attention

${SO_PY_DIR}/${SO_PY_NAME}:
	$(call build_cmake_target,$(SO_PY_DIR),py_token)
	@echo "Python tokenizer library built in $(SO_PY_DIR)"

${SO_C_DIR}/${SO_C_NAME}:
	$(call build_cmake_target,$(SO_C_DIR),c_token)
	@echo "C tokenizer library built in $(SO_C_DIR)"

# Cleanup
.PHONY: clean
clean:
	@rm -rf $(BUILD_DIR) $(SO_PY_DIR) $(SO_C_DIR) $(EXEC_NAME)
	@echo "All build artifacts removed"

# Use for AICAS 2025 Evaluation
acc_eva: ${SO_PY_DIR}/${SO_PY_NAME}
	@echo "[INFO]: Accuarcy Eva"
	python3 eva/acc.py --hf_path ${QWEN_HF_PATH} --so_path $(shell realpath ${SO_PY_DIR}/${SO_PY_NAME}) --bench_path eva/final.tsv

thpt_eva: ${SO_C_DIR}/${SO_C_NAME}
	@echo "[INFO]: Thoughtput Eva"
	python3 eva/python_c_throughput.py --so_path $(shell realpath ${SO_C_DIR}/${SO_C_NAME}) --bench_path eva/prompt.txt
	
comp_eva:
	python3 eva/gen_comp_rate.py
