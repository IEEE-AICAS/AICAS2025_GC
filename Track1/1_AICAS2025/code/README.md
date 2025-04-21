
# 使用方法

1. 代码下载与编译
```
# 下载代码
# commit id: 04c13fb62136a33460278a50a8592f4047e8aa0f
git clone https://github.com/alibaba/MNN.git

# 打patch
cd MNN
cp /path/to/code/aicas2025.patch .
git apply aicas2025.patch

# 编译 llm_demo
mkdir build && cd build
cmake .. -DMNN_LOW_MEMORY=true -DMNN_CPU_WEIGHT_DEQUANT_GEMM=true -DMNN_BUILD_LLM=true -DMNN_SUPPORT_TRANSFORMER_FUSE=true -DMNN_AVX512=true -DMNN_ARM82=true
make -j32
cd ..

# 编译Python包
cd pymnn/pip_package
python build_deps.py llm
python setup.py install
```

2. 模型导出
```
cd MNN/transformers/llm/export
export HF_ENDPOINT=https://hf-mirror.com    # AWQ数据集下载使用
python llmexport.py --path /path/to/Qwen2.5-0.5B-Instruct --export mnn --awq --quant_bit 8 --ppl
python llmexport.py --path /path/to/Qwen2.5-0.5B-Instruct --export mnn --awq --quant_bit 8
```

3. 测试精度
```
cd /path/to/code/
python llm_eval.py --model_path /path/to/mnn_model/config.json --token_path /path/to/Qwen2.5-0.5B
```

4. 测试性能
```
cd MNN/build
./llm_demo /path/to/mnn_model/config.json prompt.txt
```
