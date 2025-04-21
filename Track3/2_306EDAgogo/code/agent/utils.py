from loguru import logger
from data import MOSFET,MOSFETNet,MOSFETParam,MOSFETCalc,CurrentNet,CurrentSource
from data import Idc_max,GBW_min,SR_min,PM_min,Gain_min
from data import Mode
import time

def read_sys_prompt(prompt_path):
    with open(prompt_path, "r") as file:
        return {"role":"system","content":file.read()}

def read_human_prompt(prompt_path,**kwargs):
    with open(prompt_path, "r") as file:
        prompt = file.read()
        if kwargs:
            prompt = prompt.format(**kwargs)
        return {"role":"user","content":prompt}
    
def update_design_result(mosfet_dict, design_result):
    # {"l_input":value,"l_other":value}
    for name, mosfet in mosfet_dict.items():
        if mosfet.name == "XM1" or mosfet.name == "XM2":
            mosfet.update_param("L",design_result["l_input"])
        else:
            mosfet.update_param("L",design_result["l_other"])

    # for name, attributes in design_result.items():  # 遍历最外层字典
    #     for attr_name, attr_value in attributes.items():  # 遍历每个 MOSFET 的属性
    #         mosfet_dict[name].update_param("L", attr_value)


def update_calculation_k_result(mosfet_dict,calculation_result):
    for name, mosfet in mosfet_dict.items():
        if len(mosfet.get_param("W_scale")) >= 1:
            mosfet.update_param("W_scale",calculation_result["k"],len(mosfet.get_param("W_scale"))-1)

def update_calculation_W_result(mosfet_dict,calculation_result):
    for name, mosfet in mosfet_dict.items():
        if mosfet.name == "XM1" or mosfet.name == "XM2":
            mosfet.update_param("W",calculation_result["W_input"])
        else:
            mosfet.update_param("W",calculation_result["W_other"])

def parse_netlist(mosfet_dict,current_source_dict,raw_netlist):
    lines = raw_netlist.strip().split('\n')
    for line in lines:
        parts = line.split()

        if len(parts) == 8:
            name = parts[0]
            type = parts[5]
            net = MOSFETNet(*parts[1:5])
            calc_param = MOSFETCalc()
            # 解析参数字符串
            param_dict = {}
            param_dict["L"] = parts[6].split('=')[1]
            W_split = parts[7].split('=')[1].split('/')
            param_dict["W"] = W_split[0]
            if len(W_split) > 1:
                param_dict["W_scale"] = [i for i in W_split[1:]]
            param = MOSFETParam(**param_dict)

            mosfet = MOSFET(name,type,net,param,calc_param)
            mosfet_dict[name] = mosfet
        elif len(parts) == 4:
            name = parts[0]
            net = CurrentNet(*parts[1:3])
            # 对 dc=vbp 解析得到 vbp
            dc = float(parts[3])
            current_source = CurrentSource(name,net,dc)
            current_source_dict[name] = current_source



def generate_netlist(mosfet_dict, current_source_dict, is_final=False,final_results=None):
    """
    生成电路网表
    Args:
        mosfet_dict: MOSFET器件字典
        current_source_dict: 电流源字典
    Returns:
        str: 生成的网表字符串
    """
    netlist = []
    netlist.append(".subckt AMP Vinp Vinn VDD VSS Vout\n")
    
    # 处理主MOSFET器件
    for name, mosfet in mosfet_dict.items():
        net = mosfet.net
        param = mosfet.param
        if mosfet.type == "pmos":
            type = "sky130_fd_pr__pfet_01v8_lvt"
        elif mosfet.type == "pmos_lvt":
            type = "sky130_fd_pr__pfet_01v8_lvt"
        else:
            type = "sky130_fd_pr__nfet_01v8"
        w = param.W
        for i in range(len(param.W_scale)):
            w /= float(param.W_scale[i])  
        if w > 1000:
            netlist.append(f"{name} {net.d} {net.g} {net.s} {net.b} {type} L={param.L} W={w/100} m=100\n")
        elif w > 100:
            netlist.append(f"{name} {net.d} {net.g} {net.s} {net.b} {type} L={param.L} W={w/10} m=10\n")
        else:
            netlist.append(f"{name} {net.d} {net.g} {net.s} {net.b} {type} L={param.L} W={w} m=1\n")
    
    if not is_final:
        for name, current_source in current_source_dict.items():
            net = current_source.net
            dc = current_source.dc
            netlist.append(f"{name} {net.pos} {net.neg} {dc}u\n")
    # 处理电流源,将电流源转换为电阻
    # TO DO
    else:
        for name, current_source in current_source_dict.items():
            resistor_name = name.replace("I","R")
            net = current_source.net
            resistor_value = final_results["v(xi1.1)"]/current_source.dc * 1000000
            netlist.append(f"{resistor_name} {net.pos} {net.neg} sky130_fd_pr__res_generic_nd {resistor_value}\n")


    netlist.append(".ends AMP\n")
    return ''.join(netlist)

def check_results(results):
    if not Mode.IS_SINGLE:
        if results["Gain"] > Gain_min and results["GBW"] > GBW_min and results["PM"] > PM_min and results["sr"] > SR_min and results["i(vmeas)"] < Idc_max:
            return True
        else:
            return False
    # 单个指标，更加严格防止工艺角影响
    elif Mode.IS_SINGLE and Mode.SINGLE == "Idc":
        if results["i(vmeas)"] < Idc_max*1.05 and results["i(vmeas)"] > Idc_max*0.95:
            return True
        else:
            return False
    elif Mode.IS_SINGLE and Mode.SINGLE == "PM":
        if results["PM"] < PM_min*1.05 and results["PM"] > PM_min*0.95:
            return True
        else:
            return False
    elif Mode.IS_SINGLE and Mode.SINGLE == "Gain":
        if results["Gain"] < Gain_min*1.05 and results["Gain"] > Gain_min*0.95:
            return True
        else:
            return False
    elif Mode.IS_SINGLE and Mode.SINGLE == "GBW":
        if results["GBW"] < GBW_min*1.05 and results["GBW"] > GBW_min*0.95:
            return True
        else:
            return False
    elif Mode.IS_SINGLE and Mode.SINGLE == "SR":
        if results["sr"] < SR_min*1.05 and results["sr"] > SR_min*0.95:
            return True
        else:
            return False
    else:
        return False

def time_decorator(func):
    def wrapper(*args, **kwargs):
        start_time = time.time()  # 记录开始时间
        result = func(*args, **kwargs)  # 调用被装饰的函数
        end_time = time.time()  # 记录结束时间
        logger.info(f"函数 '{func.__name__}' 的运行时间: {end_time - start_time:.4f} 秒")
        return result  # 返回函数的结果
    return wrapper 