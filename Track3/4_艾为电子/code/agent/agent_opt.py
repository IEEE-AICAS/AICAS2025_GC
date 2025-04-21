import os, json
import asyncio

import config
from common_method import callmodel_async
from common_method import read_prompt_file
from common_method import read_result_file
from common_method import read_netlist_file
from common_method import write_string_to_file
from common_method import str2spice
from common_method import simulation
from common_method import backup_file
from common_method import result2num
from common_method import ext_pipe
from common_method import replace_netlist_lines

async def generatingNL_optimize(count_num, b=True):
    """
    Asynchronously generates and optimizes a netlist based on various conditions and simulation results.
    
    Parameters:
    - count_num: An integer representing the count number for backup files.
    - b: A boolean indicating whether the simulation should run with a specific condition.
    
    Returns:
    None
    """
    
    # Determine the type of optimization based on the configuration index
    if config.COMPONENTINDEX['Index'] == 'Iref':
        # Read the prompt file for Iref optimization
        prompt_opt = await read_prompt_file("prompt_opt_iref.txt")
        corners = ['FF', 'FS', 'SF', 'SS', 'TT']
        sim_result_tmp = {"Iref": 0}
        for corner in corners:
            sim_result_IDC = await read_result_file(f"{corner}_IDC.txt")
            result_IDC = result2num(sim_result_IDC)
            if sim_result_tmp['Iref']:
                if sim_result_tmp['Iref'] > result_IDC['Iref']:
                    sim_result_tmp['Iref'] = result_IDC['Iref']
            else:
                sim_result_tmp['Iref'] = result_IDC['Iref']
        # Replace the placeholder in the prompt with the Iref result
        iref_result = f"Iref: {sim_result_tmp['Iref']}"
        prompt_opt = prompt_opt.replace(r'${sim_result}', iref_result)
    
    if config.COMPONENTINDEX['Index'] == 'XM7':
        # Read the prompt file for XM7 optimization
        prompt_opt = await read_prompt_file("prompt_opt_xm7.txt")
    
    if config.COMPONENTINDEX['Index'] == 'XM1XM2':
        # Read the prompt file for XM1XM2 optimization
        prompt_opt = await read_prompt_file("prompt_opt_xm1xm2.txt")
    
    if config.COMPONENTINDEX['Index'] == 'Gain':
        # Read the prompt file for Gain optimization
        prompt_opt = await read_prompt_file("prompt_opt_gain.txt")
        if config.ISCUSTOM:
            if config.CUSTOMINDEX == 'Gain':
                sim_result_AC = await read_result_file(f"TT_AC.txt")
                result_AC = result2num(sim_result_AC)
                if float(result_AC['Gain']) > float(config.PFINDEX['Gain']['value']) * 1.1:
                    Gain_result = "The Gain is too large"
                elif float(result_AC['Gain']) < float(config.PFINDEX['Gain']['value']) * 0.9:
                    Gain_result = "The Gain is too small"
                else:
                    Gain_result = "The Gain is meet the requirement"
                prompt_opt = prompt_opt.replace(r'${gain}', Gain_result)
        
    if config.COMPONENTINDEX['Index'] == 'SR':
        # Determine the optimization for SR based on custom configuration
        if config.ISCUSTOM:
            if config.CUSTOMINDEX == 'SR':
                config.COMPONENTINDEX['Component'] = ["C1"]
                prompt_opt = await read_prompt_file("prompt_opt_sr_single.txt")
                sim_result_SR = await read_result_file(f"TT_SR.txt")
                result_SR = result2num(sim_result_SR)
                if float(result_SR['SR']) > float(config.PFINDEX['SR']['value']) * 1.1:
                    SR_result = "The SR is too large"
                elif float(result_SR['SR']) < float(config.PFINDEX['SR']['value']) * 0.9:
                    SR_result = "The SR is too small"
                else:
                    SR_result = "The SR is meet the requirement"
                prompt_opt = prompt_opt.replace(r'${sr}', SR_result)
        else:
            prompt_opt = await read_prompt_file("prompt_opt_sr.txt")
        
    if config.COMPONENTINDEX['Index'] == 'PM':
        # Read the prompt file for PM optimization
        prompt_opt = await read_prompt_file("prompt_opt_pm.txt")
        corners = ['FF', 'FS', 'SF', 'SS', 'TT']
        sim_result_tmp = {"PM": 0}
        for corner in corners:
            sim_result_AC = await read_result_file(f"{corner}_AC.txt")
            result_AC = result2num(sim_result_AC)
            if sim_result_tmp['PM']:
                if sim_result_tmp['PM'] > result_AC['PM']:
                    sim_result_tmp['PM'] = result_AC['PM']
            else:
                sim_result_tmp['PM'] = result_AC['PM']
        prompt_opt = prompt_opt.replace(r'${PM}', sim_result_tmp['PM'])
        
    if config.COMPONENTINDEX['Index'] == 'GBW':
        # Read the prompt file for GBW optimization
        prompt_opt = await read_prompt_file("prompt_opt_gbw.txt")
        if config.ISCUSTOM:
            if config.CUSTOMINDEX == 'GBW':
                sim_result_AC = await read_result_file(f"TT_AC.txt")
                result_AC = result2num(sim_result_AC)
                if float(result_AC['GBW']) > float(config.PFINDEX['GBW']['value']) * 1.1:
                    GBW_result = "The GBW is too large"
                elif float(result_AC['GBW']) < float(config.PFINDEX['GBW']['value']) * 0.9:
                    GBW_result = "The GBW is too small"
                else:
                    GBW_result = "The GBW is meet the requirement"
                prompt_opt = prompt_opt.replace(r'${gbw}', GBW_result)
        
    context_list = []
    for component in config.COMPONENTINDEX['Component']:
        context_list.append(ext_pipe(component)[0])
    prompt_opt = prompt_opt.replace(r'${component}', json.dumps(context_list))
    
    ai_result = await callmodel_async(prompt_opt, "Please output spice_final")
    
    netlist_str = await str2spice(ai_result)
    for line in json.loads(netlist_str):
        for key, value in line.items():
            replace_netlist_lines(key, value)
    
    selections = ['CMRR', 'PSRR', 'noise']
    await asyncio.gather(*(simulation(selection, b=b) for selection in selections))
    corners = ['FF', 'FS', 'SF', 'SS', 'TT']
    selections = ['AC', 'SR', 'IDC']
    await asyncio.gather(*(simulation(selection, corner=corner, b=b) for selection in selections for corner in corners))
        
    last_netlist = os.path.join(os.path.dirname(__file__), '..', 'netlist', 'AMP.cir')
    await backup_file(last_netlist, count_num + 1)
    corners = ['FF', 'FS', 'SF', 'SS', 'TT']
    selections = ['AC', 'SR', 'IDC']
    for corner in corners:
        for selection in selections:
            last_sim_result = os.path.join(os.path.dirname(__file__), '..', 'result', f'{corner}_{selection}.txt')
            await backup_file(last_sim_result, count_num + 1)
    selections = ['CMRR', 'PSRR', 'noise']
    for selection in selections:
        last_sim_result = os.path.join(os.path.dirname(__file__), '..', 'result', f'{selection}.txt')
        await backup_file(last_sim_result, count_num + 1)
    