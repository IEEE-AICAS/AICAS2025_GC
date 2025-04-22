# 2025-03-24T17:36:40.070273500
import vitis

client = vitis.create_client()
client.set_workspace(path="E:/Desktop/LLM/competition/FPGA_GC/KV260/vitis_project")

comp = client.get_component(name="qwen_acc")
comp.build()

comp.build()

comp.build()

status = comp.clean()

comp.build()

comp.build()

vitis.dispose()

vitis.dispose()

