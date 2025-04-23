# Qwen2.5-0.5B-Instruct-AWQ Project

This repository contains the implementation and evaluation tools for ​**Qwen2.5-0.5B-Instruct-AWQ** across multiple platforms (CPU and FPGA), a language model optimized with Activation-aware Weight Quantization (AWQ) for efficient inference. This project is developed for the AICAS 2025 Grand Challenge, featuring C/C++ acceleration, FPGA deployment utilities, and evaluation scripts for accuracy, compression rate, and throughput.

## Repository Structure

### Core Directories
- ​**`Qwen2.5-0.5B-Instruct-AWQ/`**: 
  Contains the model configuration, tokenizer files (`tokenizer.json`, `vocab.json`), and license. This folder is required for test accuarcy for the python token;
  - `config.json`: Model architecture configuration.
  - `generation_config.json`: Text generation settings.
  - `tokenizer_config.json`: Tokenizer parameters.

- ​**`params/`**:  
  Stores the base model weights and tokenizer binary.
  - `tokenizer.bin`: Tokenizer binary file.

- ​**`params_awq64/`**:  
  Quantized AWQ model parameters. 
  - `fullmodel_combined.bin`: Combined AWQ weights.(473689856);
  - `fullmodel_metadata.json`: Metadata for quantized model.
  - ​**Note**: The `.bin` file contains zero-padding for AXI bus optimization. Actual model size is smaller due to excluded padding data (288-byte blocks contain 12-byte padding).

### Source Code
- ​**`src_hls/`**:  
  High-Level Synthesis (HLS) project for FPGA deployment (**Vivado HLS 2024.2 required**).
  - Contains AWQ acceleration core design, simulation, and synthesis results.

- ​**`src_py/`**:  
  Python utilities for model extraction, quantization, and demos.
  - `BF16toAWQ.py` : Quantizes Hugging Face BF16 models to AWQ format;
  - `AWQ_Export_Final.ipynb`:Converts AWQ models to binary+JSON format (weights + structure)；
  
### Evaluation & Results
- ​**`eva/`**:  
  Evaluation scripts and datasets from AICAS committee.
  - `acc.py`: Accuracy evaluation.
  - `gen_comp_rate.py`: Compression rate calculation.
  - `python_c_throughput.py`: Throughput benchmarking.
  - `dev.tsv`/`final.tsv`: Test datasets/results.

- ​**`submit_json/`**:  
  Precomputed metrics in JSON format.
  - `acc.json`, `comp_rate.json`, `throughput.json`.

## Dependencies
- ​**Build Tools**: CMake ≥3.10, Make, GCC/C++ compiler.
- ​**Python**: Python 3.x with PyTorch, NumPy, Jupyter.
- ​**FPGA Tools**: Vivado HLS/Vitis (for HLS deployment).
- ​**Model Weights**: Ensure `params/` and `params_awq64/` are present.

## Build Instructions
  1. Under Root Path of the project (local host compile and running);
    * init        - Initial the xclbin, and copy it into firmare folder;
    * clean       - Remove all build artifacts
    * help        - Show this help message
    * acc_eva     - Acc evaluation AICAS (Please do not remove so_py, if do not have cross-compile environment)
    * thpt_eva    - Thoughtput evaluation AICAS (Please do not remove so_c, if do not have cross-compile environment)
    * comp_eva    - Compress Ratio Eva AICAS
    * cmake       - Generate "AWQ_Attention" which can run model infer;


## Reference:
  This project also include or learn from other open source project. We would like to thanks to :
  1. nlohmann/json ([JSON File read support](https://github.com/nlohmann/json));
  2. llama2c [Infer function](https://github.com/karpathy/llama2.c) 
  
## Message to committe:
We extend our sincere gratitude to the AICAS 2025 organizers for their guidance and support throughout this competition. Our implementation encountered toolchain compatibility challenges that merit special clarification: While the submitted JSON results (acc.json, throughput.json, comp_rate.json) reflect ​actual measurements using the Vitis 2023.1 toolchain (deployed on KV260 hardware), the theoretical throughput values cited in our paper derive from ​Vivado HLS 2024.2 synthesis optimizations (csynth_2024.rpt). We have attaced the our HLS design (src_hls) for the committe review. This distinction stems from two factors:

1. The stable Vitis 2023.1 environment (applied for competition submissions) exhibited a stream channel reduction bug (4 designed AXI-Streams → 3 implemented, per csynth_2023.rpt).
2. Though Vitis 2024.2 resolved this issue and achieved 2.2× faster cycle-accurate simulations, but it cannnot support the whole flow development becasue Vitis Embedding Development Bugs.
