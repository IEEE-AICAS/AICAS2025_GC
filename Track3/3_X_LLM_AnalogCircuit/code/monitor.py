import psutil  
import time  
import os  
import signal  
import sys  
import atexit  
import json 
import subprocess
import argparse


#说明:初赛的propmpt统计、复赛的propmpt统计、运行时长与内存占用均使用本脚本
#初赛请运行"python monitor.py --mode preliminary"
#复赛请运行"python monitor.py --mode final"
#本脚本将直接运行agent目录下main.py统计运行时长和内存占用，并统计prompt目录下的token总数
#复赛如遇到因推理方式导致无法正常监测内存占用的情况，请将监测进程指向推理进程并告知组委会
#文件树结构如下:
#.
#├── agent
#│   ├── agent_1.py
#│   ├── agent_2.py
#│   ├── agent_3.py
#│   └── main.py
#├── monitor.py
#├── monitor_results.json
#└── prompt
#    ├── prompt1.txt
#    ├── prompt2.txt
#    ├── prompt3.txt
#    └── prompt4.txt

# Description: This script is used for prompt statistics in the preliminary and final rounds, as well as for measuring runtime duration and memory usage.
# For the preliminary round, please run "python monitor.py --mode preliminary"
# For the final round, please run "python monitor.py --mode final"
# This script will directly execute main.py under the agent directory to measure runtime duration and memory usage, and it will also count the total number of tokens in the prompt directory.
# In case of inability to properly monitor memory usage during the final round due to inference methods, please direct the monitoring process to the inference process and inform the organizing committee.
# File tree structure as follows:
#.
#├── agent
#│   ├── agent_1.py
#│   ├── agent_2.py
#│   ├── agent_3.py
#│   └── main.py
#├── monitor.py
#├── monitor_results.json
#└── prompt
#    ├── prompt1.txt
#    ├── prompt2.txt
#    ├── prompt3.txt
#    └── prompt4.txt


def count_words_in_file(file_path):
    """
    统计指定文本文件中的单词数
    Counts the number of words in a given text file
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            text = file.read()
            words = text.split()  # 使用空白字符分割单词
            return len(words)  # 返回单词数
    except Exception as e:
        print(f"Unable to read file {file_path}: {e}")
        return 0

def count_words_in_folder(folder_path):
    """
    统计指定文件夹下所有 txt 文件的单词总数
    Counts the total number of words in all txt files in the specified folder.
    """
    total_word_count = 0
    for root, dirs, files in os.walk(folder_path):  # 遍历文件夹及子文件夹
        for file in files:
            if file.endswith('.txt'):  # 只处理 txt 文件
                file_path = os.path.join(root, file)
                word_count = count_words_in_file(file_path)
                total_word_count += word_count
                print(f"Number of tokens in file {file_path}: {word_count}")

    print(f"\ntotal tokens: {total_word_count}")
    return total_word_count

#初赛监测
# Preliminary round monitoring
def preliminary():
    prompt_dir = os.path.join(os.getcwd(), 'prompt')  # 当前工作目录下的prompt 文件夹
    if os.path.isdir(prompt_dir):
        print(f"No {prompt_dir}")
    else:
        raise ValueError("Prompt folder not found")
    total_word_count = count_words_in_folder(prompt_dir)
    token_stats = {
        "token": total_word_count
    }
    write_results__to_json(token_stats, 'w')

    

# 保存结果到JSON文件
# Save results to JSON file
def write_results__to_json(stats, mode):
    file_path = 'monitor_results.json'
    if mode == 'a':
        with open(file_path, 'r', encoding='utf-8') as report_file:
            existing_data = json.load(report_file)
        if not isinstance(existing_data, list):
            existing_data = [existing_data]
        existing_data.append(stats)
        with open(file_path, 'w', encoding='utf-8') as report_file:
            json.dump(existing_data, report_file, indent=2)
    else:
        with open(file_path, 'w') as report_file:
            json.dump(stats, report_file, indent=2)
    print(f"""\nThe result has been successfully saved to the {file_path} file.""")

# 监控进程并更新结果
# Monitor the process and update the results
def monitor_process(process, stats, start_time):
    ps_process = psutil.Process(process.pid)  # 使用 psutil.Process 获取进程对象
    print(f"Monitoring process with PID: {process.pid}...")

    while True:
        status = process.poll()
        if status is None:
            time.sleep(0.1)
            mem_info = ps_process.memory_info()
            rss = mem_info.rss / 1024**2  # MB
            stats["max_rss"] = max(stats["max_rss"], rss)

            elapsed_time = time.time() - start_time
            stats["total_time"] = elapsed_time

            #print(f"Current Time: {elapsed_time} s")
            #print(f"Current RSS Memory: {rss:.2f} MB | Max RSS Memory: {stats['max_rss']:.2f} MB\n")
        else:
            print(f"Subprocess stopped, exit status code: {status}")
            print(f"Final Time: {elapsed_time} s")
            print(f"Final Max RSS Memory: {stats['max_rss']:.2f} MB\n")
            break

# 检查当前目录下 agent 目录中的 main.py 是否存在
# Check if main.py exists in the agent directory in the current directory.
def check_main_py():
    agent_dir = os.path.join(os.getcwd(), 'agent')  # 当前工作目录下的 agent 文件夹
    main_py_path = os.path.join(agent_dir, 'main.py')

    if os.path.isfile(main_py_path):
        print(f"Find {main_py_path}")
        return main_py_path
    else:
        raise ValueError("No main.py")

# 启动 main.py 并获取进程名称
# Start main.py and get the process name
def get_process_name_from_pid(pid):
    try:
        process = psutil.Process(pid)
        return process.name()  # 获取进程名称
    except psutil.NoSuchProcess:
        return None

# 启动 main.py 脚本, 获取pid和运行时间
# Start main.py script, get pid and runtime
def start_main_py_and_getPID(main_py_path):
    if main_py_path:
        # 启动 main.py 脚本
        process = subprocess.Popen(['python', main_py_path])  # 运行 main.py 脚本
        start_time = time.time()
        pid = process.pid  # 获取启动的进程 PID
        
        # 获取进程名称
        process_name = get_process_name_from_pid(pid)
        print(f"Started process: {process_name}")
    return process, start_time

#复赛监测
#Rematch monitoring
def final():
    preliminary()
    main_py_path = check_main_py()
    process, start_time = start_main_py_and_getPID(main_py_path)

    stats = {
        "max_rss": 0,
        "total_time": 0
    }
    
    monitor_process(process, stats, start_time)
    write_results__to_json(stats, 'a')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run the script in different modes.")
    parser.add_argument("--mode", default="final", choices=["preliminary", "final"], help="Specify the mode to run: 'preliminary' or 'final'")
    args = parser.parse_args()
    
    if args.mode == "preliminary":
        preliminary()
    elif args.mode == "final":
        final()
    else:
        parser.error("Invalid mode. Please choose either 'preliminary' or 'final'.")
