import os
import re
import copy

'''
该智能体的主要功能是实现调用仿真工具对网表进行仿真，获得仿真结果
gene_netlist与generate_netlist_final负责各个阶段的网表参数写入到网表文件中。
update_scr负责更新仿真网表中的仿真corner与仿真网表路径。
gene_scr_result_path负责产生一次仿真中需要用到的脚本路径
get_simulation_result调用仿真工具，进行仿真，并读取仿真结果保存到数据结构中。
'''

def generate_netlist_final(netlist_dict, path):
    XM1_W = netlist_dict['XM1_W']
    XM1_L = netlist_dict['XM1_L']
    XM1_M = netlist_dict['XM1_M']
    XM2_W = netlist_dict['XM2_W']
    XM2_L = netlist_dict['XM2_L']
    XM2_M = netlist_dict['XM2_M']
    XM3_W = netlist_dict['XM3_W']
    XM3_L = netlist_dict['XM3_L']
    XM3_M = netlist_dict['XM3_M']
    XM4_W = netlist_dict['XM4_W']
    XM4_L = netlist_dict['XM4_L']
    XM4_M = netlist_dict['XM4_M']
    XM5_W = netlist_dict['XM5_W']
    XM5_L = netlist_dict['XM5_L']
    XM5_M = netlist_dict['XM5_M']
    XM6_W = netlist_dict['XM6_W']
    XM6_L = netlist_dict['XM6_L']
    XM6_M = netlist_dict['XM6_M']
    XM7_W = netlist_dict['XM7_W']
    XM7_L = netlist_dict['XM7_L']
    XM7_M = netlist_dict['XM7_M']
    XM8_W = netlist_dict['XM8_W']
    XM8_L = netlist_dict['XM8_L']
    XM8_M = netlist_dict['XM8_M']
    R1 = netlist_dict['R1']
    C1 = netlist_dict['C1']
    XM9_W = netlist_dict['XM9_W']
    XM9_L = netlist_dict['XM9_L']
    XM9_M = netlist_dict['XM9_M']
    XM10_W = netlist_dict['XM10_W']
    XM10_L = netlist_dict['XM10_L']
    XM10_M = netlist_dict['XM10_M']
    XM11_W = netlist_dict['XM11_W']
    XM11_L = netlist_dict['XM11_L']
    XM11_M = netlist_dict['XM11_M']
    XM12_W = netlist_dict['XM12_W']
    XM12_L = netlist_dict['XM12_L']
    XM12_M = netlist_dict['XM12_M']
    XM13_W = netlist_dict['XM13_W']
    XM13_L = netlist_dict['XM13_L']
    XM13_M = netlist_dict['XM13_M']
    R2 = netlist_dict['R2']
    net_list = f""".subckt AMP Vinp Vinn VDD VSS Vout

XM1 net1 Vinn net3 VSS sky130_fd_pr__nfet_01v8 L={XM1_L} W={XM1_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult={XM1_M} m={XM1_M}
XM2 net2 Vinp net3 VSS sky130_fd_pr__nfet_01v8 L={XM2_L} W={XM2_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult={XM2_M} m={XM2_M}
XM5 net3 Ibias VSS VSS sky130_fd_pr__nfet_01v8 L={XM5_L} W={XM5_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult={XM5_M} m={XM5_M}
XM8 Ibias Ibias VSS VSS sky130_fd_pr__nfet_01v8 L={XM8_L} W={XM8_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult={XM8_M} m={XM8_M}
XM7 Vout Ibias VSS VSS sky130_fd_pr__nfet_01v8 L={XM7_L} W={XM7_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult={XM7_M} m={XM7_M}
XM4 net2 net1 VDD VDD sky130_fd_pr__pfet_01v8 L={XM4_L} W={XM4_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult={XM4_M} m={XM4_M}
XM3 net1 net1 VDD VDD sky130_fd_pr__pfet_01v8 L={XM3_L} W={XM3_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult={XM3_M} m={XM3_M}
XM6 Vout net2 VDD VDD sky130_fd_pr__pfet_01v8 L={XM6_L} W={XM6_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult={XM6_M} m={XM6_M}

C1 net52 Vout {C1}p   m=1
R1 net52 net2 {R1} m=1

****IBIAS NETLIST****
XM9 Ibias VBP VDD VDD sky130_fd_pr__pfet_01v8 L={XM9_L} W={XM9_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult={XM9_M} m={XM9_M}
XM10 neta VBP VDD VDD sky130_fd_pr__pfet_01v8 L={XM10_L} W={XM10_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult={XM10_M} m={XM10_M}
XM11 VBP VBP VDD VDD sky130_fd_pr__pfet_01v8 L={XM11_L} W={XM11_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult={XM11_M} m={XM11_M} 

XM12 neta neta VSS VSS sky130_fd_pr__nfet_01v8 L={XM12_L} W={XM12_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult={XM12_M} m={XM12_M}
XM13 VBP neta netb VSS sky130_fd_pr__nfet_01v8 L={XM13_L} W={XM13_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult={XM13_M} m={XM13_M} 

R2 netb VSS {R2} m=1

.ends AMP"""
    with open(path, 'w') as f:
        f.write(net_list)

def gene_netlist(netlist_dict, path, state):
    if state == 'stage1':
        XM1_W = netlist_dict['XM1_W']
        XM1_L = netlist_dict['XM1_L']
        XM1_M = netlist_dict['XM1_M']
        XM2_W = netlist_dict['XM2_W']
        XM2_L = netlist_dict['XM2_L']
        XM2_M = netlist_dict['XM2_M']
        XM3_W = netlist_dict['XM3_W']
        XM3_L = netlist_dict['XM3_L']
        XM3_M = netlist_dict['XM3_M']
        XM4_W = netlist_dict['XM4_W']
        XM4_L = netlist_dict['XM4_L']
        XM4_M = netlist_dict['XM4_M']
        XM5_W = netlist_dict['XM5_W']
        XM5_L = netlist_dict['XM5_L']
        XM5_M = netlist_dict['XM5_M']
        XM6_W = netlist_dict['XM6_W']
        XM6_L = netlist_dict['XM6_L']
        XM6_M = netlist_dict['XM6_M']
        XM7_W = netlist_dict['XM7_W']
        XM7_L = netlist_dict['XM7_L']
        XM7_M = netlist_dict['XM7_M']
        XM8_W = netlist_dict['XM8_W']
        XM8_L = netlist_dict['XM8_L']
        XM8_M = netlist_dict['XM8_M']
        I0 = netlist_dict['I0']
        R1 = netlist_dict['R1']
        C1 = netlist_dict['C1']
        net_list = f""".subckt AMP Vinp Vinn VDD VSS Vout

XM1 net1 Vinn net3 VSS sky130_fd_pr__nfet_01v8 L={XM1_L} W={XM1_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m={XM1_M}
XM2 net2 Vinp net3 VSS sky130_fd_pr__nfet_01v8 L={XM2_L} W={XM2_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m={XM2_M}
XM5 net3 Ibias VSS VSS sky130_fd_pr__nfet_01v8 L={XM5_L} W={XM5_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m={XM5_M}
XM8 Ibias Ibias VSS VSS sky130_fd_pr__nfet_01v8 L={XM8_L} W={XM8_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m={XM8_M}
XM7 Vout Ibias VSS VSS sky130_fd_pr__nfet_01v8 L={XM7_L} W={XM7_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m={XM7_M}
XM4 net2 net1 VDD VDD sky130_fd_pr__pfet_01v8 L={XM4_L} W={XM4_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m={XM4_M}
XM3 net1 net1 VDD VDD sky130_fd_pr__pfet_01v8 L={XM3_L} W={XM3_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m={XM3_M}
XM6 Vout net2 VDD VDD sky130_fd_pr__pfet_01v8 L={XM6_L} W={XM6_W} nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m={XM6_M}

I0 VDD Ibias {I0}u
C1 net52 Vout {C1}p   m=1
R1 net52 net2 {R1} m=1

.ends AMP"""
        with open(path, 'w') as f:
            f.write(net_list)
    else:
        generate_netlist_final(netlist_dict,  path)

def gene_scr_result_path(args, corner, state, metric):
    if state == 'stage1':
        if metric == 'GBW' or metric == "Gain" or metric == "PM":
            AC_path = [args.AMP_AC_path, args.sim_result_path + corner + "_AC_results.txt"]
            paths = [AC_path]
            return paths
        if metric == 'SR':
            SR_path = [args.AMP_SR_path, args.sim_result_path + corner + "_SR_results.txt"]
            paths = [SR_path]
            return paths
        if metric == "noise":
            noise_path = [args.AMP_noise_path, args.sim_result_path + corner + "_NOISE_results.txt"]
            paths = [noise_path]
            return paths
    if state == 'stage2':
        if metric == "I0":
            I0_path = [args.AMP_I0_path, args.sim_result_path + corner + "_I0_results.txt"]
            paths = [I0_path]
            return paths
    if state == 'stage3':
        # if metric == "PM":
            AC_path = [args.AMP_AC_path, args.sim_result_path + corner + "_AC_results.txt"]
            paths = [AC_path]
            return paths
        # if metric == "Gain":
        #     AC_path = [args.AMP_AC_path, args.sim_result_path + corner + "_AC_results.txt"]
        #     paths = [AC_path]
        #     return paths
    if state == 'over':
        AC_path = [args.AMP_AC_path, args.sim_result_path + corner + "_AC_results.txt"]
        paths = [AC_path]
        return paths
    if state == "over_test":
        AC_path = [args.AMP_AC_path, args.sim_result_path + corner + "_AC_results.txt"]
        SR_path = [args.AMP_SR_path, args.sim_result_path + corner + "_SR_results.txt"]
        IDC_path = [args.AMP_IDC_path, args.sim_result_path + corner + "_IDC_results.txt"]
        CMRR_path = [args.AMP_CMRR_path, args.sim_result_path + corner + "CMRR_results.txt"]
        PSRR_path = [args.AMP_PSRR_path, args.sim_result_path + corner + "PSRR_results.txt"]
        noise_path = [args.AMP_noise_path, args.sim_result_path + corner + "_NOISE_results.txt"]
        paths = [AC_path, SR_path, IDC_path, CMRR_path, PSRR_path, noise_path]
        return paths
    if state == 'extra':
        if metric == 'GBW' or metric == "Gain" or metric == "PM":
            AC_path = [args.AMP_AC_path, args.sim_result_path + corner + "_AC_results.txt"]
            paths = [AC_path]
            return paths
        if metric == 'SR':
            SR_path = [args.AMP_SR_path, args.sim_result_path + corner + "_SR_results.txt"]
            paths = [SR_path]
            return paths
        if metric == "idc":
            idc_path = [args.AMP_IDC_path, args.sim_result_path + corner + "_IDC_results.txt"]
            paths = [idc_path]
            return paths

def update_scr(paths, args, corner):
    for path in paths:
        with open(path[0], 'r') as f:
            all_line = []
            for line in f.readlines():
                if re.search(r".LIB", line):
                    new_line = f".LIB '" + args.lib_path + "'" + corner + "\n"
                    all_line.append(new_line)
                elif re.search(r".INCLUDE", line):
                    new_line = f".INCLUDE " + args.net_list_path + "\n"
                    all_line.append(new_line)
                elif re.search(r"echo", line):
                    greater_than_index = line.find("> ")
                    new_line = line[:greater_than_index + 1] + " " + path[1] + '\n'
                    all_line.append(new_line)
                else:
                    all_line.append(line)
        with open(path[0], 'w') as f:
            f.writelines(all_line)

def get_simulation_result(args, paths, state, metric, results, corner):  # 单个的corner
    command0 = 'cd ' + args.simulation_path
    if state == 'stage1':
        if metric == 'GBW' or metric == "Gain" or metric == "PM":
            command1 = './ngspice ' + args.AMP_AC_path
            command = [command0, command1]
            command_string = "; ".join(command)
            os.system(command_string)
            for path in paths:
                with open(path[1], 'r') as f:
                    data = f.readlines()
                    results["tt_Gain"] = float(data[0].strip("\n"))
                    results["tt_GBW"] = float(data[1].strip("\n"))
                    results["tt_PM"] = float(data[2].strip("\n"))
            return results
        if metric == 'SR':
            command1 = './ngspice ' + args.AMP_SR_path
            command = [command0, command1]
            command_string = "; ".join(command)
            os.system(command_string)
            for path in paths:
                with open(path[1], 'r') as f:
                    data = f.readlines()
                    results["tt_SR"] = float(data[0].strip("\n"))
            return results
        if metric == "noise":
            command1 = './ngspice ' + args.AMP_noise_path
            command = [command0, command1]
            command_string = "; ".join(command)
            os.system(command_string)
            for path in paths:
                with open(path[1], 'r') as f:
                    data = f.readlines()
                    results["tt_noise"] = float(data[0].strip("\n"))
            return results
    if state == 'stage2':
        if metric == "I0":
            command1 = './ngspice ' + args.AMP_I0_path
            command = [command0, command1]
            command_string = "; ".join(command)
            os.system(command_string)
            for path in paths:
                with open(path[1], 'r') as f:
                    data = f.readlines()
                    results["tt_I0"] = float(data[0].strip("\n"))
            return results
    if state == 'stage3':
        # if metric == "PM":
            command1 = './ngspice ' + args.AMP_AC_path
            command = [command0, command1]
            command_string = "; ".join(command)
            os.system(command_string)
            for path in paths:
                with open(path[1], 'r') as f:
                    data = f.readlines()
                    key_1 = corner + "_Gain"
                    key_2 = corner + "_GBW"
                    key_3 = corner + "_PM"
                    results[key_1] = float(data[0].strip("\n"))
                    results[key_2] = float(data[1].strip("\n"))
                    results[key_3] = float(data[2].strip("\n"))
            return results
    if state == "over_test":
        command1 = './ngspice ' + args.AMP_AC_path
        command2 = './ngspice ' + args.AMP_SR_path
        command3 = './ngspice ' + args.AMP_IDC_path
        command4 = './ngspice ' + args.AMP_CMRR_path
        command5 = './ngspice ' + args.AMP_noise_path
        command6 = './ngspice ' + args.AMP_PSRR_path
        command = [command0, command1, command2, command3, command4, command5, command6]
        command_string = "; ".join(command)
        os.system(command_string)
        with open(paths[0][1], 'r') as f:
            data = f.readlines()
            key_1 = corner + "_Gain"
            key_2 = corner + "_GBW"
            key_3 = corner + "_PM"
            results[key_1] = float(data[0].strip("\n"))
            results[key_2] = float(data[1].strip("\n"))
            results[key_3] = float(data[2].strip("\n"))
        with open(paths[1][1], 'r') as f:
            data = f.readlines()
            key = corner + "_SR"
            results[key] = float(data[0].strip("\n"))
        with open(paths[2][1], 'r') as f:
            data = f.readlines()
            key = corner + "_idc"
            results[key] = float(data[0].strip("\n"))
        with open(paths[3][1], 'r') as f:
            data = f.readlines()
            key = corner + "_CMRR"
            results[key] = float(data[0].strip("\n"))
        with open(paths[4][1], 'r') as f:
            data = f.readlines()
            key = corner + "_PSRR"
            results[key] = float(data[0].strip("\n"))
        with open(paths[5][1], 'r') as f:
            data = f.readlines()
            key = corner + "_noise"
            results[key] = float(data[0].strip("\n"))
        return results
    elif state == 'extra':
        if metric == 'GBW' or metric == "Gain" or metric == "PM":
            command1 = './ngspice ' + args.AMP_AC_path
            command = [command0, command1]
            command_string = "; ".join(command)
            os.system(command_string)
            for path in paths:
                with open(path[1], 'r') as f:
                    data = f.readlines()
                    results["tt_Gain"] = float(data[0].strip("\n"))
                    results["tt_GBW"] = float(data[1].strip("\n"))
                    results["tt_PM"] = float(data[2].strip("\n"))
            return results
        if metric == 'SR':
            command1 = './ngspice ' + args.AMP_SR_path
            command = [command0, command1]
            command_string = "; ".join(command)
            os.system(command_string)
            for path in paths:
                with open(path[1], 'r') as f:
                    data = f.readlines()
                    results["tt_SR"] = float(data[0].strip("\n"))
            return results
        if metric == "idc":
            command1 = './ngspice ' + args.AMP_IDC_path
            command = [command0, command1]
            command_string = "; ".join(command)
            os.system(command_string)
            for path in paths:
                with open(path[1], 'r') as f:
                    data = f.readlines()
                    results["tt_idc"] = float(data[0].strip("\n"))
            return results
    else:
        return results

def Agent_simulation(args, netlist_dict, state, corner, flag_dict, result_tamplate):
    result = copy.deepcopy(result_tamplate)
    gene_netlist(netlist_dict, args.net_list_path, state) #将网表字典里的参数写入到网表文件
    if flag_dict["state"] == "stage1" or flag_dict["state"] == "stage2":
        paths = gene_scr_result_path(args, corner[-1], flag_dict['state'], flag_dict['optimize_metric']) #生成仿真文件和保存仿真结果的地址
        update_scr(paths, args, corner[-1])  #更新仿真脚本
        result = get_simulation_result(args, paths, flag_dict['state'], flag_dict['optimize_metric'], result,
                                           corner[-1]) #运行脚本得到仿真结果
    elif flag_dict["state"] == "stage3":
        for c in corner:
            paths = gene_scr_result_path(args, c, flag_dict['state'], flag_dict['optimize_metric'])
            update_scr(paths, args, c)
            result = get_simulation_result(args, paths, flag_dict['state'], flag_dict['optimize_metric'],
                                               result, c)
    else:
        paths = gene_scr_result_path(args, corner[-1], flag_dict['state'], flag_dict['optimize_metric']) #生成仿真文件和保存仿真结果的地址
        update_scr(paths, args, corner[-1])  #更新仿真脚本
        result = get_simulation_result(args, paths, flag_dict['state'], flag_dict['optimize_metric'], result,
                                           corner[-1]) #运行脚本得到仿真结果

    return result



