import os
import sys
import threading
if "analog" not in os.getcwd():
    os.chdir(os.getcwd()+"/analog")
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../')))

from agent.agent0 import DesignAgent
from agent.agent1 import CalculationAgent
from agent.agent2 import RevisionAgent

from data import mosfet_dict,current_source_dict
import data
from agent.utils import *
from config import *


iter_count = 0
iter_max = 5
is_satisfied = False
current_netlist = ""
current_results = {}
final_netlist = ""
final_results = {}


@time_decorator
def design_agent_process():
    # 读取多个prompt
    human0_prompts = read_human_prompt(f"prompt/human0_0_prompt.txt")
    sys0_prompts = read_sys_prompt(f"prompt/sys0_0_prompt.txt")

    # 解析prompt中的电路拓扑
    parse_netlist(mosfet_dict,current_source_dict,sys0_prompts["content"])

    # 电路关键参数设计
    agent0 = DesignAgent(prompt=sys0_prompts)
    design_result = agent0.invoke(human0_prompts)
    update_design_result(mosfet_dict,design_result)

    logger.info("所有电路关键参数初始化设计完成!")

@time_decorator
def calculation_agent_process():
    # 读取prompt
    global iter_count,current_results
    L_input,L_other = mosfet_dict["XM1"].get_param("L"),mosfet_dict["XB1"].get_param("L")
    human1_0_prompt = read_human_prompt("prompt/human1_0_prompt.txt",WL_max=data.WL_max,l_input=L_input,l_other=L_other)
    human1_1_prompt = read_human_prompt("prompt/human1_1_prompt.txt",l=L_other,WL_max=data.WL_max)

    agent1 = CalculationAgent()
    def invoke_W(prompt):
        calculation_W_result = agent1.invoke(prompt=prompt)
        update_calculation_W_result(mosfet_dict,calculation_W_result)
    def invoke_k(prompt):
        if data.Mode.IS_SINGLE and data.Mode.SINGLE == "Idc" and iter_count > 0:
            Idc0 = current_results["i(vmeas)"]
            calculation_k_result = {"k":((2*data.mosfet_dict["XB3"].get_param("W_scale")[1]+4)*data.Idc_max/Idc0 - 4)/2}
            update_calculation_k_result(mosfet_dict,calculation_k_result)
        else:
            calculation_k_result = agent1.invoke(prompt=prompt)
            update_calculation_k_result(mosfet_dict,calculation_k_result)
    threads = []
    for prompt in [human1_0_prompt,human1_1_prompt]:
        if prompt == human1_0_prompt:
            thread = threading.Thread(target=invoke_W, args=(prompt,))
        elif prompt == human1_1_prompt:
            thread = threading.Thread(target=invoke_k, args=(prompt,))
        threads.append(thread)
        thread.start()
    for thread in threads:
        thread.join()

    print("查找表所需参数计算完成!")


@time_decorator
def simulation_agent_process():
    global iter_count,current_netlist,current_results,is_satisfied,final_netlist,final_results
    current_netlist = generate_netlist(mosfet_dict,current_source_dict)
    logger.trace(f"当前电路网表: {current_netlist}")

    with open("sim/AMP.cir","w") as file:
        file.write(current_netlist)
    # 仿真
    sim_files = ['AMP_AC.cir', 'AMP_IDC.cir', 'AMP_SR.cir']
    def run_simulation(file):
        os.system("cd sim/TT && ngspice -b {}".format(file))

    threads = []
    for f in sim_files:
        thread = threading.Thread(target=run_simulation, args=(f,))
        threads.append(thread)
        thread.start()
    
    for thread in threads:
        thread.join()

    # 读取仿真结果
    for filename in ["TT_AC_results.txt", "TT_Idc.txt", "TT_SR.txt"]:
        with open("sim/TT/{}".format(filename),"r") as file:
            for line in file:
                key,value = line.split("=")
                if key.strip() == "GBW":
                    #仿真结果GBW要/10^6 i(vmeas)要*10^6 sr要/10^6对吧
                    current_results[key.strip()] = float(value.strip())/10**6
                elif key.strip() == "i(vmeas)":
                    current_results[key.strip()] = float(value.strip())*10**6
                elif key.strip() == "sr":
                    current_results[key.strip()] = float(value.strip())/10**6
                else:
                    current_results[key.strip()] = float(value.strip())
    logger.info(f"当前仿真结果: {current_results}")

    # 如果current_results满足结果，则将current_netlist更新到final_netlist
    if check_results(current_results):
        final_netlist = current_netlist
        final_results = current_results
        with open("sim/TT/TT_v.txt") as file:
            for line in file:
                key,value = line.split("=")
                final_results[key.strip()] = float(value.strip())

        is_satisfied = True
        logger.info("仿真结果满足要求，结束迭代")
    else:
        is_satisfied = False
        logger.info("仿真结果不满足要求，继续迭代")
    
    iter_count += 1

@time_decorator
def revision_agent_process():
    global current_results
    human2_prompt = read_human_prompt(f"prompt/human2_prompt.txt",current_results=current_results)
    agent2 = RevisionAgent()
    agent2.invoke(human2_prompt)
    logger.info("电路参数修正完成!")

@time_decorator
def main():
    global iter_count,is_satisfied,final_netlist,final_results
    while iter_count < iter_max and not is_satisfied:
        if iter_count == 0:
            design_agent_process()
        calculation_agent_process()
        simulation_agent_process()
        revision_agent_process()
    # 满足要求后，增大50%输入对管宽度，牺牲PM换取GBW，再次仿真看结果是否满足要求
    # 满足要求会自动保存到final_netlist和final_results
    if is_satisfied:
        simulation_agent_process()
    else:
        # 不满足要求，取最后一次结果
        final_netlist = current_netlist
        final_results = current_results
        with open("sim/TT/TT_v.txt") as file:
            for line in file:
                key,value = line.split("=")
                final_results[key.strip()] = float(value.strip())
    
    #将理想电流源替换为电阻，生成最终网表
    final = generate_netlist(mosfet_dict,current_source_dict,is_final=True,final_results=final_results)
    with open("sim/AMP.cir","w") as file:
        file.write(final)





    

if __name__ == "__main__":
    main()


    