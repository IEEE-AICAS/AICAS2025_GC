# AICAS 测试指南

## 目录结构
```text
.
├── bin/ # 由model导出的.bin文件
├── driver/ # dma-proxy驱动
├── eva/ # 测试脚本
├── model/ # 千问模型文件
├── model_quantized/ # 量化后的千问模型文件
├── qwen_accel/ # 硬件加速器 bit 流文件
├── rtl/ # 硬件代码目录
└── submit_json/ # 测试结果目录
```
## 测试流程

### 1. 进入工作目录
```bash
cd /path/to/AICAS  # 替换为实际路径
```
### 2. 执行脚本加载硬件
```bash
bash ./load_hardware.sh  # 加载加速器固件并编译安装dma-proxy驱动
```
### 3. 测试吞吐量
```bash
make thpt_eva  
```
### 4. 测试准确率
```bash
make acc_eva
```
### 5. 测试模型压缩量
```bash
make comp_eva # 压缩后的模型路径在./model_quantized/model.safetensors
```
## 说明
本实验的硬件仅实现了一个简单的矩阵乘法加速，同时由于软硬件交互的设计存在问题，实际上的计算速度有所减少，为了减少测试时间，仅prefill的前几个token进入了硬件中进行加速；