# Qwen FPGA

## Install

Install miniconda and create python virtual env
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh
conda create -n kv260 python==3.12
conda activate kv260
pip install -r requirements.txt
```

Install dependency for openblas
```bash
conda create -c conda-forge openblas libopenblas=*=*openmp* -p .conda_blas -y
```

## Setup

```bash
# Install bitstream (need `sudo`)
bash setup.sh
# activate conda env
# use the given conda env
```

## Test c infer
```bash
# compilation
make build/test_runq_fpga
# run
./test_runq_fpga
```

## Accuracy
```bash
# preliminary round benchmark
make acc_fpga
# final round benchmark
make acc_fpga_final
```

## Throughput
```bash
make thpt_fpga
```

## Compression Rate
```bash
make comp_fpga
```
