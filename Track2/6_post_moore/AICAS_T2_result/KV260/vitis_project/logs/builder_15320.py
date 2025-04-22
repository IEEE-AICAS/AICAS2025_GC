# 2025-03-24T17:09:05.310642500
import vitis

client = vitis.create_client()
client.set_workspace(path="E:/Desktop/LLM/competition/FPGA_GC/KV260/vitis_project")

platform = client.create_platform_component(name = "accelerate_wrapper",hw = "E:/Desktop/LLM/competition/FPGA_GC/KV260/qwen_acc_top/accelerate_wrapper.xsa",os = "standalone",cpu = "psu_cortexa53_0")

platform = client.get_platform_component(name="accelerate_wrapper")
status = platform.build()

comp = client.create_app_component(name="qwen_acc",platform = "E:/Desktop/LLM/competition/FPGA_GC/KV260/vitis_project/accelerate_wrapper/export/accelerate_wrapper/accelerate_wrapper.xpfm",domain = "standalone_psu_cortexa53_0")

vitis.dispose()

