import copy
from Agent_simulation import Agent_simulation, gene_netlist


'''
这个Agent负责处理大模型的调整回答，然后根据回答修改网表，并更新状态字典。
gene_adj_trend，gene_adj_trend_extra根据大模型回答产生记录调整策略的字典。
gene_new_value根据策略产生新的网表参数值。
gene_new_net_list，gene_new_net_list_extra根据新的网表参数值更新网表数据。
update_flag_dict更新状态字典。
'''

def gene_adj_trend(response, state):
    if state == "stage1":
        trend_dict = {'XM6_L': None, 'XM6_W': None, 'XM1_W': None, 'XM1_L': None, 'I0': None, 'R1': None, 'XM7_W': None}
    else:
        trend_dict = {'XM6_L': None, 'XM6_W': None, 'XM1_W': None, 'XM1_L': None, 'I0': None, 'R1': None, 'XM7_W': None,
                      'R2': None}
    response = response.split('.')
    response = response[1].split(": ")
    for key, value in trend_dict.items():
        if key == response[0]:
            trend_dict[key] = response[1]
    if response[0] == "XM6_L":
        trend_dict["XM6_W"] = response[1]
    if response[0] == "XM1_L":
        if state != 'over':
            trend_dict["XM1_W"] = response[1]
    # print(trend_dict)
    return trend_dict

def gene_adj_trend_extra(response):
    trend_dict = {'XM6_W': None, 'C1': None,'R2': None}
    if response[0] == 'XM6':
        trend_dict['XM6_W'] = response[1]
    elif response[0] == 'C1' or response[0] == 'c1':
        trend_dict['C1'] = response[1]
    elif response[0] == 'R2' or response[0] == 'r2':
        trend_dict['R2'] = response[1]
    return trend_dict

def gene_new_value(tend, old):
    if tend == None:
        new = old
    if tend == 'reduce by half':  
        new = round(old / 2, 2)
    if tend == 'double':  
        new = round(old * 2, 2)
    if tend == 'triple':  
        new = old + 1
    if tend == "up":  
        new = old + 1.5
    if tend == "up little":  
        new = round(old * (1 + 0.05), 2)
    if tend == "up much": 
        new = old + 2300
    if tend == "up very much":  
        new = old + 5000
    if tend == 'up little little':  
        new = old + 0.5
    if tend == "down little": 
        new = round(old * (1 - 0.035), 2)
    if tend == "up very little":
        new = old + 0.2
    if tend == "down very little":
        new = old - 0.1
    return new

def gene_new_net_list(trend_dict, old_netlist_dict):
    new_netlist_dict = copy.deepcopy(old_netlist_dict)
    for key, value in trend_dict.items():
        new = gene_new_value(value, old_netlist_dict[key])
        if key == 'XM1_W':
            new_netlist_dict['XM1_W'] = new
            new_netlist_dict['XM2_W'] = new
        if key == 'XM1_L':
            new_netlist_dict['XM1_L'] = new
            new_netlist_dict['XM2_L'] = new
        else:
            new_netlist_dict[key] = new
    # print(new_netlist_dict)
    return new_netlist_dict

def gene_new_net_list_extra(trend_dict, old_netlist_dict):
    new_netlist_dict = copy.deepcopy(old_netlist_dict)
    for key, value in trend_dict.items():
        if value != None:
            if key == 'XM6_W':
                new = old_netlist_dict['XM6_W'] - 1
                new_netlist_dict['XM6_W'] = new
            if key == 'C1':
                if value == 'up':
                    new = old_netlist_dict['C1'] + 0.05
                if value == 'down':
                    new = old_netlist_dict['C1'] - 0.05
                new_netlist_dict['C1'] = new
            if key == 'R2':
                if value == 'up':
                    new = old_netlist_dict['R2'] + 10000
                if value == 'down':
                    new = old_netlist_dict['R2'] - 2000
                new_netlist_dict['R2'] = new
    return new_netlist_dict

def update_flag_dict(act_list, flag_dict):
    flag_act_list = act_list[1:]
    for i in flag_act_list:
        i = i.split('.')
        act = i[1].split(':')
        if act[0] == 'state':
            flag_dict["state"] = act[1]
        elif act[0]=='optimize_metric':
            flag_dict['optimize_metric']=act[1]
    return flag_dict

def Agent_resizing(args, response, netlists_list, sim_results_list, flag_dict, corner, result_tamplate):
    if flag_dict['state'] == 'extra':
        act_list = response.split(' ')
        trend_dict = gene_adj_trend_extra(act_list)
        new_netlist_dict = gene_new_net_list_extra(trend_dict, netlists_list[-1])
        netlists_list.append(new_netlist_dict)
        result =  Agent_simulation(args, new_netlist_dict, flag_dict['state'], corner, flag_dict, result_tamplate)
        sim_results_list.append(result)
    elif flag_dict['state'] == 'over':
        act_list = "1.XM1_L: triple"
        trend_dict = gene_adj_trend(act_list, flag_dict['state'])
        new_netlist_dict = gene_new_net_list(trend_dict, netlists_list[-1])
        netlists_list.append(new_netlist_dict)
        gene_netlist(new_netlist_dict, args.net_list_path, flag_dict['state'])
    else:
        act_list = response.split('\n')
        if "rollback" in act_list[0]:
            netlists_list.pop()
            sim_results_list.pop()
            flag_dict = update_flag_dict(act_list, flag_dict)
        else:
            if len(act_list) > 1:
                flag_dict = update_flag_dict(act_list, flag_dict)
            trend_dict = gene_adj_trend(act_list[0], flag_dict['state'])
            new_netlist_dict = gene_new_net_list(trend_dict, netlists_list[-1])
            # print(new_netlist_dict)
            netlists_list.append(new_netlist_dict)
            result =  Agent_simulation(args, new_netlist_dict, flag_dict['state'], corner, flag_dict, result_tamplate)
            sim_results_list.append(result)
    return netlists_list, sim_results_list, flag_dict


