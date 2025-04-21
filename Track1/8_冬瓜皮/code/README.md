# 1. 环境搭建

安装 autoround：

```bash
cd auto-round
pip install .[cpu]
```

**注意：**请勿使用 github 官方源代码构建，代码经过修改，请使用本地代码构建。

安装 embedding OMSE 量化库：

```bash
cd embedding_quant_cuda


# 修改编译参数
vim setup.py

include_dirs=['/home/gaoithe/.conda/envs/llm/lib/python3.9/site-packages/torch/include'],  # 指定 PyTorch >头文件路径

library_dirs=['/home/gaoithe/.conda/envs/llm/lib/python3.9/site-packages/torch/lib'],  # 指定 PyTorch 库路>径

extra_compile_args={'nvcc': ['-arch=sm_86']}


# 进行编译安装
python setup.py install
```



# 2. 量化

```
python autoRound_quant.py
```



# 3. 评估

```
# transformers 模型速度评估
benchmark.py    
# gguf 模型速度评估
llama_cpp_python.py
# 内存使用量监测
monitor.py

# gguf 模型精度评估
precision_gguf.py

# transformers 模型精度评估
precision.py
```


