import psutil
import time
import os
import signal
import sys
import atexit
import json

current_pid=os.getpid()
print(f"当前进程pid号为:{current_pid}")

monitored = sys.argv[1]
print(f"需要监测的进程为:{monitored}")
target_pid = None

for proc in psutil.process_iter(['pid', 'name', 'cmdline']):
    if proc.info['cmdline'] is not None and monitored in proc.info['cmdline'] and proc.pid!=current_pid:
        print(f"残留进程为:{proc.pid}")
        proc.kill()
        print("残留进程清除完成")

print("\r\n")
print("寻找指定进程，请打开吞吐量测试脚本,并在吞吐量测试完毕后关闭此脚本：")
while not target_pid:
    for proc in psutil.process_iter(['pid', 'name', 'cmdline']):
        if proc.info['cmdline'] is not None and monitored in proc.info['cmdline'] and proc.pid!=current_pid:
            target_pid = proc.pid
            break

    if not target_pid:
        print("未找到指定进程")
        time.sleep(1)

print("\r\n")
print(f"已找到指定进程pid号为: {target_pid}")
process = psutil.Process(target_pid)
process_cmdline = process.cmdline()
print(f"pid对应名称为{process_cmdline}")

max_memory_stats = {
    "max_rss": 0,
    "max_vms": 0
}

def write_memory_max_to_json():   #导出json
    with open('memory_results.json', 'w') as report_file:
        json.dump(max_memory_stats, report_file, indent=2)
    print("\n已成功将吞吐量结果保存至 'memory_results.json' 文件中.")

atexit.register(write_memory_max_to_json) #在进程结束时保存结果

while 1:
    time.sleep(0.1)
    mem_info = process.memory_info()
    rss=mem_info.rss/1024**2
    vms=mem_info.vms/1024**2

    max_memory_stats["max_rss"] = max(max_memory_stats["max_rss"], rss)
    max_memory_stats["max_vms"] = max(max_memory_stats["max_vms"], vms)

    print(f"Current RSS Memory: {rss:.2f} MB | Current VMS Memory: {vms:.2f} MB")
    print(f"Max RSS Memory: {max_memory_stats['max_rss']:.2f} MB | Max VMS Memory: {max_memory_stats['max_vms']:.2f} MB\n")
