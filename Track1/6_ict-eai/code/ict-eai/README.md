测评步骤
1. 到 build 目录编译
   cmake ..  && LLAMA_FAST=1 make -j8
   
2. 起服务

 ./root/lqc/aicas/llama/llama.cpp/build/bin/aicas -m /root/lqc/models/qwen2.5-0.5b-q8_0.gguf -t 8 -b 569 -c 600 -ctk q8_0 -ub 64

3. 切换conda环境
  conda activate qwen_memory

3. 监听进程内存状态

  python /root/lqc/aicas/llama/monitor.py aicas

4. 测试

  python /root/lqc/aicas/llama/benchmark.py
