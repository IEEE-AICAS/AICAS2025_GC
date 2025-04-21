from Agent_resizing import Agent_resizing
import ollama
from config import config_arg
import re

'''
这个Agent负责进行每阶段的网表化工作
通过generate_writer_prompt函数产生并保存优化过程中的prompt到opt_prompt.txt文件中
通过writer_record函数把优化记录保存到process_record.txt文件中
'''

def generate_writer_prompt(args, target_result, result, last_result, flag_dict, corner):
    opt = flag_dict['optimize_metric']
    state = flag_dict["state"]
    simulation_results = "current_simulation_result:{"
    last_simulayion_results = "last_simulation_result:{"
    if state == 'extra':
        t_opt = target_result[opt]
        c_opt = result['tt_'+opt]
        target_results = f"target_result:{opt}:"  + "{" + f"'{opt}': {t_opt}" + "},"
        simulation_results = f"current_simulation_result:{opt}:" + "{" + f"'{opt}': {c_opt},"
    elif state == "stage3":
        if opt == "Gain":
            t_gain = target_result["Gain"]
            t_pm = target_result["PM"]
            target_results = "target_result:{" + f"Gain:{t_gain},PM:{t_pm}" + "},"
            for c in corner:
                key_1 = c + "_Gain"
                key_2 = c + "_PM"
                c_opt_1 = result[key_1]
                c_opt_2 = result[key_2]
                l_opt_1 = last_result[key_1]
                l_opt_2 = last_result[key_2]
                simulation_results = simulation_results + f"{c}_Gain:{c_opt_1},{c}_PM:{c_opt_2},"
                last_simulayion_results = last_simulayion_results + f"{c}_Gain:{l_opt_1},{c}_PM:{l_opt_2},"
        else:
            t_opt = target_result[opt]
            target_results = "target_result:{" + f"{opt}:{t_opt}" + "},"
            for c in corner:
                key = c + "_" + opt
                c_opt = result[key]
                if last_result == None:
                    l_opt = None
                else:
                    l_opt = last_result[key]
                simulation_results = simulation_results + f"{c}_{opt}:{c_opt},"
                last_simulayion_results = last_simulayion_results + f"{c}_{opt}:{l_opt},"
    else:
        if opt == "noise":
            t_opt = None
        else:
            t_opt = target_result[opt]
        target_results = "target_result:{" + f"{opt}:{t_opt}" + "},"
        for c in corner:
            key = c + "_" + opt
            c_opt = result[key]
            if last_result == None:
                l_opt = None
            else:
                l_opt = last_result[key]
            simulation_results = simulation_results + f"{c}_{opt}:{c_opt},"
            last_simulayion_results = last_simulayion_results + f"{c}_{opt}:{l_opt},"
    simulation_results = simulation_results[:-1] + "},"
    last_simulayion_results = last_simulayion_results[:-1] + "},"
    if state == 'extra':
        conditions = "condition:" + f"optimize_metric:{opt},state:extra."
    else:
        conditions = "condition:{" + f"optimize_metric:{opt}" + f",state:{state}" "}."
    if state == 'stage1':
        prompt = target_results + simulation_results + last_simulayion_results + conditions
    else:
        prompt = target_results + simulation_results + conditions
    with open(args.opt_prompt, 'a') as f:
        f.write(prompt + '\n')
    return prompt

def writer_record(args, counter, netlist, results, adjustment, state, flag_dict, result_tamplate, corner):
    if state == "net":
        with open(args.process_path, "a") as f2:
            f2.write(
                f"第{counter}次优化后，网表的参数-------------------------------------------------------------------------------\n")
            f2.write(str(netlist[-1]))
            f2.write("\n")
    if state == 'res':
        with open(args.process_path, 'a') as f1:
            f1.write(
                f"第{counter}次优化后，网表仿真各项指标-------------------------------------------------------------------------------\n")
            f1.write(str(results[-1]))
            f1.write("\n")
    if state == "adj":
        with open(args.process_path, 'a') as f:
            f.write(
                f"第{counter}次优化的调整策略-------------------------------------------------------------------------------\n")
            f.write(adjustment + "\n")
    # if state == "over":
    #     with open(args.process_path, "a") as f2:
    #         f2.write(
    #             f"最优网表的参数-------------------------------------------------------------------------------\n")
    #         f2.write(str(netlist[-1]))
    #         f2.write("\n")
    #     result = copy.deepcopy(result_tamplate)
    #     corner = ['tt', 'ss', 'ff', 'sf', 'fs']
    #     for c in corner:
    #         paths = gene_scr_result_path(args, c, flag_dict['state'], flag_dict['optimize_metric'])
    #         adapt_scr(paths, args, c)
    #         result = get_simulation_result(args, paths, flag_dict['state'], flag_dict['optimize_metric'], result,
    #                                        c)
    #     with open(args.process_path, 'a') as f1:
    #         f1.write(
    #             f"最优网表仿真各项指标-------------------------------------------------------------------------------\n")
    #         f1.write(str(result))
    #         f1.write("\n")

def Agent_optimization(args, target_result, netlists_list, sim_results_list, corner, result_tamplate, flag_dict, counter):
    if flag_dict["state"] == 'stage1':
        while flag_dict["state"] == 'stage1': #第一阶段优化
            if len(sim_results_list) == 1:
                prompt = generate_writer_prompt(args, target_result, sim_results_list[-1], None, flag_dict, corner)
            else:
                prompt = generate_writer_prompt(args, target_result, sim_results_list[-1], sim_results_list[-2], flag_dict, corner)
            response=ollama.chat(model=args.opt_model_name,stream=False,messages=[{"role": "user","content": prompt}],options={"temperature":0.2})
            content = response.message.content
            match = re.search(r'action:\s*\{(.*?)\}', content, re.DOTALL)
            action_content = match.group(1).strip()
            writer_record(args, counter, None, None, action_content, 'adj', flag_dict, result_tamplate, corner)
            counter += 1
            netlists_list, sim_results_list, flag_dict = Agent_resizing(args, action_content, netlists_list, sim_results_list, flag_dict, corner, result_tamplate)
            writer_record(args, counter, netlists_list, None, None, 'net', flag_dict, result_tamplate, corner)
            writer_record(args, counter, None, sim_results_list, None, 'res', flag_dict, result_tamplate, corner)
        return netlists_list, sim_results_list, flag_dict
    if flag_dict["state"] == 'stage2':
        while flag_dict["state"] == 'stage2': #第二阶段优化
            prompt = generate_writer_prompt(args, target_result, sim_results_list[-1], sim_results_list[-2], flag_dict, corner)
            response=ollama.chat(model=args.opt_model_name,stream=False,messages=[{"role": "user","content": prompt}],options={"temperature":0.2})
            content = response.message.content
            match = re.search(r'action:\s*\{(.*?)\}', content, re.DOTALL)
            action_content = match.group(1).strip()
            writer_record(args, counter, None, None, action_content, 'adj', flag_dict, result_tamplate, corner)
            counter += 1
            netlists_list, sim_results_list, flag_dict = Agent_resizing(args, action_content, netlists_list, sim_results_list, flag_dict, corner, result_tamplate)
            writer_record(args, counter, netlists_list, None, None, 'net', flag_dict, result_tamplate, corner)
            writer_record(args, counter, None, sim_results_list, None, 'res', flag_dict, result_tamplate, corner)
        return netlists_list, sim_results_list, flag_dict
    if flag_dict["state"] == 'stage3':
        while flag_dict["state"] == 'stage3': #第三阶段优化
            prompt = generate_writer_prompt(args, target_result, sim_results_list[-1], sim_results_list[-2], flag_dict, corner)
            response=ollama.chat(model=args.opt_model_name,stream=False,messages=[{"role": "user","content": prompt}],options={"temperature":0.2})
            content = response.message.content
            match = re.search(r'action:\s*\{(.*?)\}', content, re.DOTALL)
            action_content = match.group(1).strip()
            writer_record(args, counter, None, None, action_content, 'adj', flag_dict, result_tamplate, corner)
            counter += 1
            netlists_list, sim_results_list, flag_dict = Agent_resizing(args, action_content, netlists_list, sim_results_list, flag_dict, corner, result_tamplate)
            writer_record(args, counter, netlists_list, None, None, 'net', flag_dict, result_tamplate, corner)
            writer_record(args, counter, None, sim_results_list, None, 'res', flag_dict, result_tamplate, corner)
        netlists_list, sim_results_list, flag_dict = Agent_resizing(args, action_content, netlists_list, sim_results_list, flag_dict, corner, result_tamplate)
        return netlists_list, sim_results_list, flag_dict
    if flag_dict["state"] == 'extra':
        sim_result = sim_results_list[-1]
        opt_metric = flag_dict['optimize_metric']
        c_result = float(sim_result['tt_'+opt_metric])
        target = float(target_result[opt_metric])
        start_dirc = target - c_result
        while flag_dict["state"] == 'extra':
            prompt = generate_writer_prompt(args, target_result, sim_results_list[-1], sim_results_list[-2], flag_dict, corner)
            response=ollama.chat(model=args.extra_model_name,stream=False,messages=[{"role": "user","content": prompt}],options={"temperature":0.2})
            text = response.message.content
            start_index = text.find("action: extra")
            # 如果找到了 "action: extra"
            if start_index != -1:
            # 提取 "action: extra" 后面的字符串
                action_content = text[start_index + len("action: extra"):].strip()
            else:
                print("未找到 'action: extra'")
            writer_record(args, counter, None, None, action_content, 'adj', flag_dict, result_tamplate, corner)
            counter += 1
            netlists_list, sim_results_list, flag_dict = Agent_resizing(args, action_content, netlists_list, sim_results_list, flag_dict, corner, result_tamplate)
            sim_result = sim_results_list[-1]
            opt_metric = flag_dict['optimize_metric']
            c_result = float(sim_result['tt_'+opt_metric])
            c_dirc = target - c_result
            if (start_dirc > 0 and c_dirc < 0) or (start_dirc < 0 and c_dirc > 0):
                flag_dict['state'] = 'end'
            writer_record(args, counter, netlists_list, None, None, 'net', flag_dict, result_tamplate, corner)
            writer_record(args, counter, None, sim_results_list, None, 'res', flag_dict, result_tamplate, corner)
        return netlists_list, sim_results_list, flag_dict


# if __name__ == '__main__':
#     #  prompt = generate_writer_prompt(args, target_result, sim_results_list[-1], None, flag_dict, corner)
#     args = config_arg()  # 全局参数
#     standard_Gains = 60
#     standard_GBWs = 20000000
#     standard_PMs = 60
#     standard_SRs = 20000000
#     standard_idcs = 0.0005
#     target_restult = {"Gain": standard_Gains, "GBW": standard_GBWs, "PM": standard_PMs, "idc": standard_idcs,
#                           'SR': standard_SRs} # 赛方的指标要求
#     netlists_list = [{'XM1_W': 1.2452, 'XM1_L': 1.0, 'XM1_M': 1, 'XM2_W': 1.2452, 'XM2_L': 1.0, 'XM2_M': 1, 'XM3_W': 8.04094, 'XM3_L': 1.0, 'XM3_M': 1, 'XM4_W': 8.04094, 'XM4_L': 1.0, 'XM4_M': 1, 'XM5_W': 4.44308, 'XM5_L': 1.0, 'XM5_M': 1, 'XM6_W': 60.62723, 'XM6_L': 1.0, 'XM6_M': 1, 'XM7_W': 16.75002, 'XM7_L': 1.0, 'XM7_M': 1, 'XM8_W': 4.44308, 'XM8_L': 1.0, 'XM8_M': 1, 'C1': 0.44, 'R1': 10029.39208, 'I0': 8.8}]
#     sim_results_list = [{'tt_Gain': 40.0811, 'tt_GBW': 6846130.0, 'tt_PM': 81.646, 'tt_SR': None, 'tt_idc': None, 'tt_CMRR': None, 'tt_PSRR': None, 'tt_noise': None, 'tt_I0': None, 'ff_Gain': None, 'ff_GBW': None, 'ff_PM': None, 'ff_SR': None, 'ff_idc': None, 'ff_CMRR': None, 'ff_PSRR': None, 'ff_noise': None, 'ff_I0': None, 'ss_Gain': None, 'ss_GBW': None, 'ss_PM': None, 'ss_SR': None, 'ss_idc': None, 'ss_CMRR': None, 'ss_PSRR': None, 'ss_noise': None, 'ss_I0': None, 'fs_Gain': None, 'fs_GBW': None, 'fs_PM': None, 'fs_SR': None, 'fs_idc': None, 'fs__CMRR': None, 'fs_PSRR': None, 'fs_noise': None, 'fs_I0': None, 'sf_Gain': None, 'sf_GBW': None, 'sf_PM': None, 'sf_SR': None, 'sf_idc': None, 'sf_CMRR': None, 'sf_PSRR': None, 'sf_noise': None, 'sf_I0': None}]
#     corner = ['tt']
#     result_tamplate = {"tt_Gain": None, "tt_GBW": None, "tt_PM": None, "tt_SR": None, "tt_idc": None, "tt_CMRR": None,
#                         "tt_PSRR": None, "tt_noise": None, "tt_I0": None,
#                         "ff_Gain": None, "ff_GBW": None, "ff_PM": None, "ff_SR": None, "ff_idc": None, "ff_CMRR": None,
#                         "ff_PSRR": None, "ff_noise": None, "ff_I0": None,
#                         "ss_Gain": None, "ss_GBW": None, "ss_PM": None, "ss_SR": None, "ss_idc": None, "ss_CMRR": None,
#                         "ss_PSRR": None, "ss_noise": None, "ss_I0": None,
#                         "fs_Gain": None, "fs_GBW": None, "fs_PM": None, "fs_SR": None, "fs_idc": None, "fs__CMRR": None,
#                         "fs_PSRR": None, "fs_noise": None, "fs_I0": None,
#                         "sf_Gain": None, "sf_GBW": None, "sf_PM": None, "sf_SR": None, "sf_idc": None, "sf_CMRR": None,
#                         "sf_PSRR": None, "sf_noise": None, "sf_I0": None
#                         }  #调整过程中的结果保存模板字典
#     flag_dict = {'state': 'stage1', "optimize_metric": "GBW"}  #初始化状态字典
#     netlists_list, sim_results_list, flag_dict = Agent_optimization(args, target_restult, netlists_list, sim_results_list, corner, result_tamplate, flag_dict)
    