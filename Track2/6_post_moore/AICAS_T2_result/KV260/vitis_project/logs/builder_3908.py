# 2025-03-24T17:28:02.460350500
import vitis

client = vitis.create_client()
client.set_workspace(path="E:/Desktop/LLM/competition/FPGA_GC/KV260/vitis_project")

comp = client.get_component(name="qwen_acc")
comp.build()

platform = client.get_platform_component(name="accelerate_wrapper")
status = platform.build()

comp.build()

vitis.dispose()

