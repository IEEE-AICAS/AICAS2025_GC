import os
import asyncio

from common_method import callmodel_async
from common_method import read_prompt_file
from common_method import write_string_to_file
from common_method import str2spice
from common_method import simulation
from common_method import backup_file


async def generatingNL_init(b=True):

    # load init prompt
    prompt_init = await read_prompt_file("prompt_init.txt")
    # load outputExample
    prompt_outputExample = await read_prompt_file("prompt_outputExample.txt")
    # merge prompt
    prompt_init = prompt_init.replace(r'${outputExample}', prompt_outputExample)
    # load init user input
    prompt_generatingNL = await read_prompt_file("prompt_init_input.txt")
    # load topology
    prompt_topology = await read_prompt_file("prompt_topology.txt")
    # merge prompt
    prompt_init = prompt_init.replace(r'${topology}', prompt_topology)
    
    temperature = 0
    ai_result = await callmodel_async(prompt_init, prompt_generatingNL)
    
    netlist_str = await str2spice(ai_result)
    write_result = await write_string_to_file("../netlist/AMP.cir", netlist_str)
    if write_result:
        print("write file success!")
        selections = ['CMRR', 'PSRR', 'noise']
        await asyncio.gather(*(simulation(selection, b=b) for selection in selections))
        corners = ['FF', 'FS', 'SF', 'SS', 'TT']
        selections = ['AC', 'SR', 'IDC']
        await asyncio.gather(*(simulation(selection, corner=corner, b=b) for selection in selections for corner in corners))
        
    last_netlist = os.path.join(os.path.dirname(__file__), '..', 'netlist', 'AMP.cir')
    await backup_file(last_netlist, 0)
    corners = ['FF', 'FS', 'SF', 'SS', 'TT']
    selections = ['AC', 'SR', 'IDC']
    for corner in corners:
        for selection in selections:
            last_sim_result = os.path.join(os.path.dirname(__file__), '..', 'result', f'{corner}_{selection}.txt')
            await backup_file(last_sim_result, 0)
    selections = ['CMRR', 'PSRR', 'noise']
    for selection in selections:
        last_sim_result = os.path.join(os.path.dirname(__file__), '..', 'result', f'{selection}.txt')
        await backup_file(last_sim_result, 0)
    