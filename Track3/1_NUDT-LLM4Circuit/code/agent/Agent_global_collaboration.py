from Agent_initial import Agent_initial
from Agent_optimization import Agent_optimization
from config import config_arg
from Agent_simulation import Agent_simulation, gene_netlist, gene_scr_result_path, update_scr, get_simulation_result
import time
import copy




def Agent_global_collaboration(args, valid_metric, valid_value):
    '''
    分阶段调用初始化智能体与优化智能体进行优化，最终产生最优网表保存在./sim_src/AMP.cir
    '''
    # start_time = time.time()
    standard_Gain = 60
    standard_GBW = 20000000
    standard_PM = 60
    standard_SR = 20000000
    standard_idc = 0.0005
    standard_result = {"Gain": standard_Gain, "GBW": standard_GBW, "PM": standard_PM, "idc": standard_idc,
                          'SR': standard_SR}
    '''
    调用初始化智能体，完成第一阶段的初始化
    '''
    netlists_list, sim_results_list, corner, result_tamplate, flag_dict = Agent_initial(args, standard_result, state='stage1', netlists_list=None, sim_results_list=None, flag_dict=None, result_tamplate=None)
    '''
    调用优化智能体，完成第一阶段的优化
    '''
    counter = 0
    netlists_list, sim_results_list, flag_dict = Agent_optimization(args, standard_result, netlists_list, sim_results_list, corner, result_tamplate, flag_dict, counter)
    if flag_dict["state"] == 'stage2':
        '''
        调用初始化智能体，完成第二阶段的初始化
        '''
        netlists_list, sim_results_list, standard_result = Agent_initial(args, standard_result, flag_dict["state"], netlists_list=netlists_list, sim_results_list=sim_results_list, flag_dict=flag_dict, result_tamplate=result_tamplate)
        '''
        调用优化智能体，完成第二阶段的优化
        '''
        netlists_list, sim_results_list, flag_dict = Agent_optimization(args, standard_result, netlists_list, sim_results_list, corner, result_tamplate, flag_dict, counter)
    if flag_dict["state"] == 'stage3':
        '''
        调用初始化智能体，完成第三阶段的初始化
        '''
        netlists_list, sim_results_list, corner = Agent_initial(args, standard_result, flag_dict["state"], netlists_list=netlists_list, sim_results_list=sim_results_list, flag_dict=flag_dict, result_tamplate=result_tamplate)
        '''
        调用优化智能体，完成第三阶段的优化
        '''
        netlists_list, sim_results_list, flag_dict = Agent_optimization(args, standard_result, netlists_list, sim_results_list, corner, result_tamplate, flag_dict, counter)
    '''
    如果不需要验证，则此时优化完成，最终产生最优网表保存在./sim_src/AMP.cir
    如果需要验证，则执行验证优化优化的额外阶段。
    '''
    if valid_metric:
        if valid_metric == "GBW" or valid_metric == "SR":
            valid_metric = valid_metric * 1e6
        if valid_metric == "idc":
            valid_metric = valid_metric / 1e6
        corner = ['tt']
        flag_dict = {'state':None, "optimize_metric":None}
        flag_dict['state'] = 'extra'
        flag_dict['optimize_metric'] = valid_metric
        target_restult = {"Gain": None, "GBW": None, "PM": None, "idc": None,'SR': None} 
        target_restult[valid_metric] = valid_value
        extra_first_result= Agent_simulation(args, netlists_list[-1], 'extra', corner, flag_dict, result_tamplate)
        sim_results_list.append(extra_first_result)
        netlists_list, sim_results_list, flag_dict = Agent_optimization(args, target_restult, netlists_list, sim_results_list, corner, result_tamplate, flag_dict, counter)
    
    # end_time = time.time()
    # with open(args.process_path, "a") as f2:
    #     f2.write(
    #         f"运行时间-------------------------------------------------------------------------------\n")
    #     f2.write(str(end_time-start_time))
    #     f2.write("\n")
    # gene_netlist(netlists_list[-1], args.net_list_path, 'over_test')
    # result = copy.deepcopy(result_tamplate)
    # corner = ['tt', 'ss', 'ff', 'sf', 'fs']
    # for c in corner:
    #     paths = gene_scr_result_path(args, c, 'over_test', flag_dict['optimize_metric'])
    #     update_scr(paths, args, c)
    #     result = get_simulation_result(args, paths, 'over_test', flag_dict['optimize_metric'],
    #                                            result, c)
    
    # with open(args.process_path, "a") as f2:
    #     f2.write(
    #         f"最优的网表-------------------------------------------------------------------------------\n")
    #     f2.write(str(netlists_list[-1]))
    #     f2.write("\n")
    #     f2.write(
    #         f"最优的网表仿真结果-------------------------------------------------------------------------------\n")
    #     f2.write(str(result))
    # print('optimize over, the best netlist is:')
    # print(str(netlists_list[-1]))
    # print('The simulation result is:')
    # print(str(sim_results_list[-1]))
    # print(end_time-start_time)



    