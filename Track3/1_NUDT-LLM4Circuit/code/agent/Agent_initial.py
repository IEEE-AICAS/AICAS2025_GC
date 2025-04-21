from Agent_simulation import Agent_simulation
import os
import re
import sys
import ollama
import subprocess
from pathlib import Path
import copy
from config import config_arg

'''
这个Agent负责进行每阶段的初始化工作
第一、二阶段初始化通过initial_prompt1，initial_prompt2给到大模型，生成python代码extracted_code1，extracted_code2，运行代码得到初始化网表
第三阶段初始化不需要调用大模型
'''

def convert_netlist(input_dict, state):
    """
    转换一下字典
    """
    output = {}

    # 处理S系列参数
    s_mapping = {
        "S1": "XM1",
        "S2": "XM2",
        "S3": "XM3",
        "S4": "XM4",
        "S5": "XM5",
        "S6": "XM6",
        "S7": "XM7",
        "S8": "XM8",
        "S9": "XM9",
        "S10": "XM10",
        "S11": "XM11",
        "S12": "XM12",
        "S13": "XM13",
    }

    for s_key, xm_prefix in s_mapping.items():
        if s_key in input_dict:
            value_part, fixed_value = input_dict[s_key].split("/")
            if xm_prefix == 'XM9':
                output[f"{xm_prefix}_W"] = float(value_part)
                output[f"{xm_prefix}_L"] = float(fixed_value)
                output[f"{xm_prefix}_M"] = 6
            elif  xm_prefix == 'XM13':
                output[f"{xm_prefix}_W"] = float(value_part)
                output[f"{xm_prefix}_L"] = float(fixed_value)
                output[f"{xm_prefix}_M"] = 4
            else:
                output[f"{xm_prefix}_W"] = float(value_part)
                output[f"{xm_prefix}_L"] = float(fixed_value)
                output[f"{xm_prefix}_M"] = 1

    if state == "stage1":
        direct_mapping = {
            "C1": ("C1", float),
            "R1": ("R1", float),
            "I0_uA": ("I0", lambda x: float(x)),
        }
    if state == "stage2":
        direct_mapping = {
            "R2": ("R2", float),
        }

    for src_key, (dst_key, converter) in direct_mapping.items():
        if src_key in input_dict:
            output[dst_key] = converter(input_dict[src_key])

    return output


def LLM_gene_initial_netlist(state, netlist):
    netlist_dict = {}
    with open("/mnt/c/llm/LLM4AMP/agent/netlist_para.txt", "r") as file:
            for line in file:
                line = line.strip()
                if line:
                    key, value = line.split(": ")
                    netlist_dict[key] = value
    return netlist_dict


def generate_initial_netlist(state, netlist):
    """
    这个函数的netlist需要第一阶段仿真完成后传入(字典形式)
    """
    if state == "stage1":
        init_stage1()  # 生成第一阶段网表字典，把它写入到netlist_para.txt中
        # initial_netlist = LLM_gene_initial_netlist(
        #     state, netlist=None
        # )  # 从netlist_para.txt中读取出来这个网表
        netlist_dict = {}
        try:
            with open("/mnt/c/llm/LLM4AMP/agent/netlist_para.txt", "r") as file:
                for line in file:
                    line = line.strip()
                    if line:
                        key, value = line.split(": ")
                        netlist_dict[key] = value
            initial_net_list = convert_netlist(netlist_dict, "stage1")  # 转换为目标规范格式
        except FileNotFoundError:
            initial_net_list = generate_initial_netlist(state, netlist)
        

    if state == "stage2":
        netlist2 = copy.deepcopy(netlist)  # 这里的netlist是上一阶段模拟的结果，需要传入
        with open("/mnt/c/llm/LLM4AMP/agent/netlist_para.txt", "w") as file:
            for key, value in netlist2.items():
                file.write(f"{key}: {value}\n")
        # 把第一阶段仿真优化后的规范网表字典写入到netlist_para.txt中
        insert_parameters()  # 插入参数到第二阶段的提示词中
        init_stage2()  # 生成第二阶段网表字典，把它写入到netlist_para.txt中
        delete_parameters()
        initial_netlist_stage2 = LLM_gene_initial_netlist(
            state, netlist=netlist
        )  # 从netlist_para.txt中读取出来这个网表
        initial_net_list = convert_netlist(
            initial_netlist_stage2, "stage2"
        )  # 转换为目标规范格式
        netlist2.update(initial_net_list)
        initial_net_list = netlist2
        print(initial_net_list)  # 打印一下第二阶段的初始化字典,下面有输出示例

    return initial_net_list


def extract_and_execute_code(code_str: str, output_file: str = "extracted_code.py"):
    """
    从字符串中提取Python代码块并执行

    参数:
        code_str (str): 包含代码块的原始字符串
        output_file (str): 生成的Python文件名
    """
    try:
        # 使用正则表达式匹配Python代码块
        code_pattern = re.compile(r"```python(.*?)```", re.DOTALL)
        match = code_pattern.search(code_str)

        if not match:
            raise ValueError("未找到有效的Python代码块")

        # 提取并清理代码
        extracted_code = match.group(1).strip()

        # 写入文件
        code_path = Path(output_file)
        code_path.write_text(extracted_code, encoding="utf-8")
        print(f"代码已保存到 {code_path.resolve()}")

        # 执行代码
        print("\n执行结果:")
        result = subprocess.run(
            [sys.executable, str(code_path)], check=True, text=True, capture_output=True
        )
        # print(result.stdout)

    except Exception as e:
        print(f"错误发生: {str(e)}")
        if "result" in locals() and result.stderr:
            print("错误输出：")
            print(result.stderr)


def init_stage1():
    # 初始化二级运算放大器网表
    with open("/mnt/c/llm/LLM4AMP/prompt/initial_prompt1.txt", "r", encoding="utf-8") as prompt_file:
        prompt_content = prompt_file.read().strip()

    # 打开文件准备写入
    with open("/mnt/c/llm/LLM4AMP/agent/output1.md", "w", encoding="utf-8") as file:
        stream = ollama.chat(
            model="qwen2.5-coder:3b",
            stream=True,
            messages=[{"role": "user", "content": prompt_content}],
            options={"temperature": 0.3, "max_tokens": 200},
        )

        full_response = ""
        for chunk in stream:
            content = chunk.get("message", {}).get("content", "")
            print(content, end="", flush=True)
            file.write(content)
            full_response += content

    print("\n完整响应已保存到 output1.md 文件中。")

    with open("/mnt/c/llm/LLM4AMP/agent/output1.md", "r", encoding="utf-8") as prompt_file:
        pycode1 = prompt_file.read().strip()

    extract_and_execute_code(pycode1, "/mnt/c/llm/LLM4AMP/agent/extracted_code1.py")


def insert_parameters():
    para_dict = {}
    with open("/mnt/c/llm/LLM4AMP/agent/netlist_para.txt", "r") as f:
        for line in f:
            key, value = line.strip().split(": ")
            para_dict[key] = value

    # i0_ua = para_dict["I0"].split("/")[0]
    # s5_value = para_dict["XM5_W"].split("/")[0]
    i0_ua = para_dict["I0"]
    s5_value = para_dict["XM5_W"]

    with open("/mnt/c/llm/LLM4AMP/prompt/initial_prompt2.txt", "r") as f:
        lines = f.readlines()

    insert_index = None
    for idx, line in enumerate(lines):
        if "[Process Parameters]" in line:
            insert_index = idx + 1
            break

    if insert_index is not None:
        lines.insert(insert_index, f"I0_uA = {i0_ua}\n")
        lines.insert(insert_index + 1, f"S5 = {s5_value}\n")

    with open("/mnt/c/llm/LLM4AMP/prompt/initial_prompt2.txt", "w") as f:
        f.writelines(lines)

    print("参数插入成功！")


def delete_parameters():
    """删除通过insert_parameters()插入的参数"""
    try:
        with open("/mnt/c/llm/LLM4AMP/prompt/initial_prompt2.txt", "r", encoding="utf-8") as f:
            lines = f.readlines()

        # 定位要删除的行（反向遍历避免索引错位）
        delete_indices = []
        for idx, line in enumerate(lines):
            if line.strip().startswith(("I0_uA = ", "S5 = ")):
                delete_indices.append(idx)

        # 删除找到的行
        for idx in reversed(sorted(delete_indices)):
            del lines[idx]

        # 写回文件
        with open("/mnt/c/llm/LLM4AMP/prompt/initial_prompt2.txt", "w", encoding="utf-8") as f:
            f.writelines(lines)

        print("参数删除成功！")
        return True
    except Exception as e:
        print(f"删除失败: {str(e)}")
        return False


def init_stage2():
    # 初始化偏置电流电路
    with open("/mnt/c/llm/LLM4AMP/prompt/initial_prompt2.txt", "r", encoding="utf-8") as prompt_file:
        prompt_content = prompt_file.read().strip()

    with open("/mnt/c/llm/LLM4AMP/agent/output2.md", "w", encoding="utf-8") as file:
        stream = ollama.chat(
            model="qwen2.5-coder:3b",
            stream=True,
            messages=[{"role": "user", "content": prompt_content}],
            options={"temperature": 0.3},
        )

        full_response = ""
        for chunk in stream:
            content = chunk.get("message", {}).get("content", "")
            print(content, end="", flush=True)
            file.write(content)
            full_response += content

    print("\n完整响应已保存到 output2.md 文件中。")

    with open("/mnt/c/llm/LLM4AMP/agent/output2.md", "r", encoding="utf-8") as prompt_file:
        pycode2 = prompt_file.read().strip()

    extract_and_execute_code(pycode2, "/mnt/c/llm/LLM4AMP/agent/extracted_code2.py")


def check_netlistfile():
    '''
    3.19改
    '''
    with open('/mnt/c/llm/LLM4AMP/agent/netlist_para.txt','r') as f:
        content = f.read()
        if 'R2' not in content:
            return False
        return True


def Agent_initial(args, target, state, netlists_list, sim_results_list, flag_dict, result_tamplate):

    # processed_final = {'C1': 0.44, 'I0': 8.8, 'XM3_W': 7.992, 'XM4_W': 7.992, 'XM3_L': 1.0, 'XM4_L': 1.0, 'XM3_M': 1.0, 'XM4_M': 1.0, 'XM1_W': 2.397, 'XM2_W': 2.397, 'XM1_L': 1.0, 'XM2_L': 1.0, 'XM1_M': 1.0, 'XM2_M': 1.0, 'XM5_W': 6.812, 'XM8_W': 6.812, 'XM5_L': 1.0, 'XM8_L': 1.0, 'XM5_M': 1.0, 'XM8_M': 1.0, 'R1': 10000.0, 'XM6_W': 62.553, 'XM6_L': 1.0, 'XM6_M': 1.0, 'XM7_W': 24.74, 'XM7_L': 1.0, 'XM7_M': 1.0}
    '''
       初始化保存产生的所有网表参数字典的列表、保存产生的所有网表仿真结果的列表、保存产生的所有网表的分数的列表、状态标记字典
    '''
    if os.path.exists('/mnt/c/llm/LLM4AMP/agent/netlist_para.txt'):
        os.remove('/mnt/c/llm/LLM4AMP/agent/netlist_para.txt')

    if state == "stage1":   #第一阶段的初始化
        corner = ['tt'] #初始化第一阶段调整的corner为tt
        netlists_list = [] #保存调整过程中产生网表的list
        result_tamplate = {"tt_Gain": None, "tt_GBW": None, "tt_PM": None, "tt_SR": None, "tt_idc": None, "tt_CMRR": None,
                        "tt_PSRR": None, "tt_noise": None, "tt_I0": None,
                        "ff_Gain": None, "ff_GBW": None, "ff_PM": None, "ff_SR": None, "ff_idc": None, "ff_CMRR": None,
                        "ff_PSRR": None, "ff_noise": None, "ff_I0": None,
                        "ss_Gain": None, "ss_GBW": None, "ss_PM": None, "ss_SR": None, "ss_idc": None, "ss_CMRR": None,
                        "ss_PSRR": None, "ss_noise": None, "ss_I0": None,
                        "fs_Gain": None, "fs_GBW": None, "fs_PM": None, "fs_SR": None, "fs_idc": None, "fs__CMRR": None,
                        "fs_PSRR": None, "fs_noise": None, "fs_I0": None,
                        "sf_Gain": None, "sf_GBW": None, "sf_PM": None, "sf_SR": None, "sf_idc": None, "sf_CMRR": None,
                        "sf_PSRR": None, "sf_noise": None, "sf_I0": None
                        }  #调整过程中的结果保存模板字典
        sim_results_list = [] #保存调整过程中的结果的list
        flag_dict = {'state': state, "optimize_metric": "GBW"}  #初始化状态字典
        initial_netlist = generate_initial_netlist(state, netlist=None) #生成第一阶段初始化网表
        # initial_net_list = {'C1': 0.44, 'I0': 8.8, 'XM3_W': 7.89881, 'XM3_L': 1, 'XM3_M': 1, 'XM4_W': 7.89881, 'XM4_L': 1,
        #                     'XM4_M': 1, 'XM1_W': 1.22329, 'XM1_L': 1, 'XM1_M': 1, 'XM2_W': 1.22329, 'XM2_L': 1, 'XM2_M': 1,
        #                     'XM5_W': 4.45181, 'XM5_L': 1, 'XM5_M': 1, 'XM8_W': 4.45181, 'XM8_L': 1, 'XM8_M': 1,
        #                     'R1': 9725.18722, 'XM6_W': 61.44247, 'XM6_L': 1, 'XM6_M': 1, 'XM7_W': 15.72386, 'XM7_L': 1,
        #                     'XM7_M': 1}
        
        netlists_list.append(initial_netlist)
        sim_result = Agent_simulation(args, netlists_list[-1], state, corner, flag_dict, result_tamplate)
        sim_results_list.append(sim_result)

        return  netlists_list, sim_results_list, corner, result_tamplate, flag_dict
    
    if state == 'stage2':
        corner = ['tt']
        initial_netlist_stage2 = generate_initial_netlist(state, netlists_list[-1])
        while check_netlistfile()==False:
            initial_netlist_stage2 = generate_initial_netlist(state, netlists_list[-1])    #3.19改
        netlists_list.append(initial_netlist_stage2)
        sim_result = Agent_simulation(args, netlists_list[-1], state, corner, flag_dict, result_tamplate)
        sim_results_list.append(sim_result)
        current_netlist = netlists_list[-1]
        target['I0'] = (float(current_netlist['I0'])*1e-6)/6
        return netlists_list, sim_results_list, target
    
    if state == 'stage3':
        corner = ['tt', 'ss', 'ff', 'sf', 'fs']
        initial_netlist_stage3 = copy.deepcopy(netlists_list[-1])
        netlists_list.append(initial_netlist_stage3)
        sim_result = Agent_simulation(args, netlists_list[-1], state, corner, flag_dict, result_tamplate)
        sim_results_list.append(sim_result)
        return netlists_list, sim_results_list, corner
    
    # if state == 'extra':
    #     corner = ['tt']
    #     initial_netlist_stage_extra = copy.deepcopy(netlists_list[-1])
    #     netlists_list.append(initial_netlist_stage_extra)
    #     sim_result = Agent_simulation(args, netlists_list[-1], state, corner, flag_dict, result_tamplate)
    #     sim_results_list.append(sim_result)
    #     return netlists_list, sim_results_list, corner


# if __name__ == '__main__':
#     args = config_arg()  # 全局参数
#     target_result = [60, 20000000, 60, 20000000, 0.0005]
#     netlists_list = [{'C1': 0.44, 'I0': 9.24, 'XM3_W': 8.041, 'XM3_L': 1, 'XM3_M': 1, 'XM4_W': 8.041, 'XM4_L': 1, 'XM4_M': 1, 'XM1_W': 12.49, 'XM1_L': 2, 'XM1_M': 1, 'XM2_W': 12.49, 'XM2_L': 2, 'XM2_M': 1, 'XM5_W': 4.443, 'XM5_L': 1, 'XM5_M': 1, 'XM8_W': 4.443, 'XM8_L': 1, 'XM8_M': 1, 'R1': 19229.392, 'XM6_W': 30.3135, 'XM6_L': 0.5, 'XM6_M': 1, 'XM7_W': 17.75, 'XM7_L': 1, 'XM7_M': 1}
# ]
#     sim_results_list = [{"tt_Gain": None, "tt_GBW": None, "tt_PM": None, "tt_SR": None, "tt_idc": None, "tt_CMRR": None,
#                         "tt_PSRR": None, "tt_noise": None, "tt_I0": None,
#                         "ff_Gain": None, "ff_GBW": None, "ff_PM": None, "ff_SR": None, "ff_idc": None, "ff_CMRR": None,
#                         "ff_PSRR": None, "ff_noise": None, "ff_I0": None,
#                         "ss_Gain": None, "ss_GBW": None, "ss_PM": None, "ss_SR": None, "ss_idc": None, "ss_CMRR": None,
#                         "ss_PSRR": None, "ss_noise": None, "ss_I0": None,
#                         "fs_Gain": None, "fs_GBW": None, "fs_PM": None, "fs_SR": None, "fs_idc": None, "fs__CMRR": None,
#                         "fs_PSRR": None, "fs_noise": None, "fs_I0": None,
#                         "sf_Gain": None, "sf_GBW": None, "sf_PM": None, "sf_SR": None, "sf_idc": None, "sf_CMRR": None,
#                         "sf_PSRR": None, "sf_noise": None, "sf_I0": None
#                         }]  #调整过程中的结果保存模板字典
#     corner = ['tt']
#     netlists_list, sim_results_list, corner, result_tamplate, flag_dict = Agent_initial(args, target_result, state='stage2', netlists_list=netlists_list, sim_results_list=sim_results_list, corner=corner)
#     print(netlists_list)
#     print(sim_results_list)

    
