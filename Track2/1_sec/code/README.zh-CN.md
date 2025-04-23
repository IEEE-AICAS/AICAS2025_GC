# EdgeDecoding

<!-- ![Build Status](https://img.shields.io/badge/build-passing-brightgreen) -->
[English](README.md) | [中文](README.zh-CN.md)

![Platform](https://img.shields.io/badge/platform-FPGA-orange)

该项目是我们面向大模型端侧部署的模型-硬件协同设计加速器，目标是为端侧FPGA提供令人满意的解码吞吐率，项目命名暂定为“EdgeDecoding”。按照比赛提交要求，我们提供了用于复现的代码。由于代码量较大且跨多个项目，如对复现或者加速器性能有疑问，请联系我们。该版本为复赛改进版本，加速器访问权重的专用AXI接口数量从一个提升至两个，带宽接近翻倍，因此prefill速率接近翻倍，同时由于实现片上argmax避免分类结果写回，decode速度提升至原来的4倍。

---
## 加速器指标
| LUTs  | DSPs | BRAMs  | URAMs     | Frequency | decode      | prefill    | Accuracy on WNLI | Compression Rate |
|:-----:|:----:|:------:|:---------:|:---------:|:-----------:|:----------:|:----------------:|:----------------:|
| 85.6k | 602  | 123.5  |  11       | 375MHz    |  35.2 tok/s |288.5 tok/s | 51.97%           |    6726          |

---

## Requirements
- Vivado HLS 2023.2 或更高
- Python 3
- IDEA + Scala (2.11.12) + Spinal (1.7.1) + Verilator (4.228)

## 提交文件结构
提交由多个部分组成：（1）reproduce：原始设计文件，用于复现。（2）scripts：生成竞赛要求提交结果的脚本。（3）根目录下的.json文件：竞赛要求的提交结果。

```text
EdgeDecoding
├── reproduce/                  # 用于复现的工程文件
│   ├── model_compression       # 用于压缩的pytorch工程文件，使用仅整数量化算法对Qwen模型进行量化
│   ├── hls_design              # 包含对Qwen模型各个组件的算子设计，基于HLS实现
│   ├── simulation              # 基于SpinalHDL搭建的仿真工程，用于算子组件的连接与集成仿真
│   └── vivado_design           # 包含生成的加速器IP（Qwen.zip）和Vivado Block Design (design_1.tcl)
|
├── scripts/                    # 用于生成竞赛要求提交结果的脚本
|   ├── bin                     # 压缩后的权重，包含24层decoder、一层lm_head和一个embedding table
│   ├── Qwen2.5-0.5B-Instruct   # tokenizer
│   ├── demo.ipynb              # 用于展示实时大模型生成效果的Jupyter Notebook
│   ├── Makefile                # 用于生成提交结果的Makefile，与原模板工程使用方式一致
│   ├── design_1_pruned.bit     # FPGA的PL侧比特流文件，词表修剪版本
│   ├── fpga_qwen.py            # 加速器驱动代码
│   └── ...
|
├── acc.json                    # 准确率结果
├── comp_rate.json              # 压缩率结果
└── throughput.json             # 吞吐率结果
```

## FAQ

### Q: 为什么prefill速度远快于decode速度？
- A: 因为PL侧加速器有token并行度，每次加载完整的权重可同时计算8个token的prefill，此外prefill无需计算lm_head。综合来说，prefill速度高于decode速度的8倍。

### Q: 为什么提供了两个bit流文件？
- A: 这两个版本分别可以达到最高的吞吐率和更长的上下文。带_long_context后缀的bit流文件通过使用更多URAM进行片上KV Cache的缓存，可以达到1024上下文长度，更加适合demo；而不带后缀的bit流文件仅提供192上下文长度，但是由于读写KV Cache量更少从而达到更高吞吐率。使用这两个bit流文件中的哪一个可以通过修改constants.py中的IS_LONG_CONTEXT变量进行切换。

### Q: 为什么unpack文件夹中的权重文件不参与compression rate的计算？
- A: 这是因为unpack文件夹中的权重是通过算法从致密权重中解压出来的。为尽可能提升压缩率，本项目利用了Qwen2.5-0.5B模型的tie embedding特性（即Embedding与分类头权重为同一矩阵），仅保存致密的单个Embedding矩阵，使用其解压出原始Embedding矩阵并且在线量化和排布分类头权重。可通过删除unpack中的权重并重新运行准确率和吞吐率测试以保证公平性，若unpack文件夹下没有对应权重文件程序会自动重新解压。
