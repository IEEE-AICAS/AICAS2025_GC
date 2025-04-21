import os, json
import asyncio

import config
from common_method import callmodel_async
from common_method import read_prompt_file
from common_method import read_result_file
from common_method import read_netlist_file
from common_method import write_string_to_file
from common_method import str2json
from common_method import simulation
from common_method import backup_file
from common_method import result2num

# Asynchronous function for index judgment
async def index_judgment():
    # Read the prompt content for index judgment from file
    prompt_index_judgment = await read_prompt_file("prompt_index_judgment.txt")
    # Convert the performance index in the configuration to JSON format with indentation
    performance_index = json.dumps(config.PFINDEX, indent=4)
    # Get the netlist and simulation results
    netlist, sim_result = await get_netlist_simresult()
    # Print the simulation results for debugging
    print(f"sim_result: {sim_result}")
    # Replace placeholders in the prompt content with actual values
    prompt_index_judgment = prompt_index_judgment.replace(r'${performance_index}', performance_index).replace(r'${sim_result}', json.dumps(sim_result, indent=4))
    # Call the model for asynchronous processing and get AI results
    ai_result = await callmodel_async(prompt_index_judgment, "Please output JSON")
    # Convert the AI result string to JSON format
    json_str = await str2json(ai_result)
    # Load the JSON string into a JSON object
    result_json = json.loads(json_str)
    # Update the configuration dictionary with the component index and index value from the JSON object
    config.COMPONENTINDEX['Component'] = result_json.get('Component')
    config.COMPONENTINDEX['Index'] = result_json.get('Index')
    # Print the updated configuration dictionary for debugging
    print(config.COMPONENTINDEX)

# Import comparison operators for later use in comparisons
from operator import gt, lt, ge, le, eq
# Function to get netlist and simulation results
async def get_netlist_simresult():
    # Read the netlist file
    netlist = await read_netlist_file(f"AMP.cir")
    # Define the corners for simulation
    corners = ['FF', 'FS', 'SF', 'SS', 'TT']
    # Initialize the simulation result dictionary
    sim_result_tmp = {
        "Gain": 0,
        "GBW": 0,
        "SR": 0,
        "PM": 0,
        "IDC": 0,
        "XM1": None,
        "XM2": None,
        "XM3": None,
        "XM4": None,
        "XM5": None,
        "XM6": None,
        "XM7": None,
        "XM8": None,
        "Iref": 0,
        "Vth8": 0,
    }
    # Read and process simulation results depending on the situation
    if config.ISCUSTOM:
        # If it is a custom design, read the corresponding simulation results and convert them to numbers
        sim_result_AC = await read_result_file(f"TT_AC.txt")
        result_AC = result2num(sim_result_AC)
        sim_result_SR = await read_result_file(f"TT_SR.txt")
        result_SR = result2num(sim_result_SR)
        sim_result_IDC = await read_result_file(f"TT_IDC.txt")
        result_IDC = result2num(sim_result_IDC)
        # Update the temporary simulation result dictionary with the processed results
        sim_result_tmp['Gain'] = result_AC['Gain']
        sim_result_tmp['GBW'] = result_AC['GBW']
        sim_result_tmp['PM'] = result_AC['PM']
        sim_result_tmp['SR'] = result_SR['SR']
        sim_result_tmp['IDC'] = result_IDC['IDC']
    else:
        # If it is not a custom design, iterate through each corner to read the simulation results and convert them to numbers
        for corner in corners:
            sim_result_AC = await read_result_file(f"{corner}_AC.txt")
            result_AC = result2num(sim_result_AC)
            sim_result_SR = await read_result_file(f"{corner}_SR.txt")
            result_SR = result2num(sim_result_SR)
            sim_result_IDC = await read_result_file(f"{corner}_IDC.txt")
            result_IDC = result2num(sim_result_IDC)
            # Update the temporary simulation result dictionary with the processed results, keeping track of the minimum values
            if sim_result_tmp['Gain']:
                if sim_result_tmp['Gain'] > result_AC['Gain']:
                    sim_result_tmp['Gain'] = result_AC['Gain']
            else:
                sim_result_tmp['Gain'] = result_AC['Gain']
            if sim_result_tmp['GBW']:
                if sim_result_tmp['GBW'] > result_AC['GBW']:
                    sim_result_tmp['GBW'] = result_AC['GBW']
            else:
                sim_result_tmp['GBW'] = result_AC['GBW']
            if sim_result_tmp['PM']:
                if sim_result_tmp['PM'] > result_AC['PM']:
                    sim_result_tmp['PM'] = result_AC['PM']
            else:
                sim_result_tmp['PM'] = result_AC['PM']
            if sim_result_tmp['SR']:
                if sim_result_tmp['SR'] > result_SR['SR']:
                    sim_result_tmp['SR'] = result_SR['SR']
            else:
                sim_result_tmp['SR'] = result_SR['SR']
            if sim_result_tmp['IDC']:
                if sim_result_tmp['IDC'] < result_IDC['IDC']:
                    sim_result_tmp['IDC'] = result_IDC['IDC']
            else:
                sim_result_tmp['IDC'] = result_IDC['IDC']
            # Update the operating state of each transistor, choosing the less stringent state
            if sim_result_tmp['XM1']:
                if sim_result_tmp['XM1'] in ['Satuation', 'Subthreshold'] and result_IDC['XM1'] not in ['Satuation', 'Subthreshold']:
                    sim_result_tmp['XM1'] = result_IDC['XM1']
            else:
                sim_result_tmp['XM1'] = result_IDC['XM1']
            if sim_result_tmp['XM2']:
                if sim_result_tmp['XM2'] in ['Satuation', 'Subthreshold'] and result_IDC['XM2'] not in ['Satuation', 'Subthreshold']:
                    sim_result_tmp['XM2'] = result_IDC['XM2']
            else:
                sim_result_tmp['XM2'] = result_IDC['XM2']
            if sim_result_tmp['XM3']:
                if sim_result_tmp['XM3'] in ['Satuation', 'Subthreshold'] and result_IDC['XM3'] not in ['Satuation', 'Subthreshold']:
                    sim_result_tmp['XM3'] = result_IDC['XM3']
            else:
                sim_result_tmp['XM3'] = result_IDC['XM3']
            if sim_result_tmp['XM4']:
                if sim_result_tmp['XM4'] in ['Satuation', 'Subthreshold'] and result_IDC['XM4'] not in ['Satuation', 'Subthreshold']:
                    sim_result_tmp['XM4'] = result_IDC['XM4']
            else:
                sim_result_tmp['XM4'] = result_IDC['XM4']
            if sim_result_tmp['XM5']:
                if sim_result_tmp['XM5'] in ['Satuation', 'Subthreshold'] and result_IDC['XM5'] not in ['Satuation', 'Subthreshold']:
                    sim_result_tmp['XM5'] = result_IDC['XM5']
            else:
                sim_result_tmp['XM5'] = result_IDC['XM5']
            if sim_result_tmp['XM6']:
                if sim_result_tmp['XM6'] in ['Satuation', 'Subthreshold'] and result_IDC['XM6'] not in ['Satuation', 'Subthreshold']:
                    sim_result_tmp['XM6'] = result_IDC['XM6']
            else:
                sim_result_tmp['XM6'] = result_IDC['XM6']
            if sim_result_tmp['XM7']:
                if sim_result_tmp['XM7'] in ['Satuation', 'Subthreshold'] and result_IDC['XM7'] not in ['Satuation', 'Subthreshold']:
                    sim_result_tmp['XM7'] = result_IDC['XM7']
            else:
                sim_result_tmp['XM7'] = result_IDC['XM7']
            if sim_result_tmp['XM8']:
                if sim_result_tmp['XM8'] in ['Satuation', 'Subthreshold'] and result_IDC['XM8'] not in ['Satuation', 'Subthreshold']:
                    sim_result_tmp['XM8'] = result_IDC['XM8']
            else:
                sim_result_tmp['XM8'] = result_IDC['XM8']
            # Update the minimum bias current
            if sim_result_tmp['Iref']:
                if sim_result_tmp['Iref'] > result_IDC['Iref']:
                    sim_result_tmp['Iref'] = result_IDC['Iref']
            else:
                sim_result_tmp['Iref'] = result_IDC['Iref']
        # Evaluate the bias current against specified thresholds
        if float(sim_result_tmp['Iref']) > 19:
            sim_result_tmp['Iref'] = f"{sim_result_tmp['Iref']}. Greater_than 19"
        elif float(sim_result_tmp['Iref']) < 14:
            sim_result_tmp['Iref'] = f"{sim_result_tmp['Iref']}. Less_than 14"
        else:
            sim_result_tmp['Iref'] = f"OK."
    # Assign the temporary simulation result dictionary to the return value
    sim_result = sim_result_tmp
    # Define a dictionary mapping strings to comparison operators
    COMPARE_OPS = {
        "greater_than": gt,
        "less_than": lt,
        "greater_equal": ge,
        "less_equal": le,
        "equal": eq
    }
    # Compare the simulation results with the performance index based on whether it is a custom design
    if config.ISCUSTOM:
        # For custom designs, check if each performance index meets the requirements within a certain range
        if config.CUSTOMINDEX == 'Gain':
            if float(config.PFINDEX['Gain']['value']) * 0.9 <= float(sim_result['Gain']) <= float(config.PFINDEX['Gain']['value']) * 1.1:
                sim_result['Gain'] = str(sim_result['Gain']) + ". Meets the requirements."
            else:
                sim_result['Gain'] = str(sim_result['Gain']) + ". Does not meet the requirements."
        else:
            sim_result['Gain'] = str(sim_result['Gain']) + ". Meets the requirements."
        if config.CUSTOMINDEX == 'GBW':
            if float(config.PFINDEX['GBW']['value']) * 0.9 <= float(sim_result['GBW']) <= float(config.PFINDEX['GBW']['value']) * 1.1:
                sim_result['GBW'] = str(sim_result['GBW']) + ". Meets the requirements."
            else:
                sim_result['GBW'] = str(sim_result['GBW']) + ". Does not meet the requirements."
        else:
            sim_result['GBW'] = str(sim_result['GBW']) + ". Meets the requirements."
        if config.CUSTOMINDEX == 'PM':
            if float(config.PFINDEX['PM']['value']) * 0.9 <= float(sim_result['PM']) <= float(config.PFINDEX['PM']['value']) * 1.1:
                sim_result['PM'] = str(sim_result['PM']) + ". Meets the requirements."
            else:
                sim_result['PM'] = str(sim_result['PM']) + ". Does not meet the requirements."
        else:
            sim_result['PM'] = str(sim_result['PM']) + ". Meets the requirements."
        if config.CUSTOMINDEX == 'SR':
            if float(config.PFINDEX['SR']['value']) * 0.9 <= float(sim_result['SR']) <= float(config.PFINDEX['SR']['value']) * 1.1:
                sim_result['SR'] = str(sim_result['SR']) + ". Meets the requirements."
            else:
                sim_result['SR'] = str(sim_result['SR']) + ". Does not meet the requirements."
        else:
            sim_result['SR'] = str(sim_result['SR']) + ". Meets the requirements."
        if config.CUSTOMINDEX == 'IDC':
            if float(config.PFINDEX['IDC']['value']) * 0.9 <= float(sim_result['IDC']) <= float(config.PFINDEX['IDC']['value']) * 1.1:
                sim_result['IDC'] = str(sim_result['IDC']) + ". Meets the requirements."
            else:
                sim_result['IDC'] = str(sim_result['IDC']) + ". Does not meet the requirements."
        else:
            sim_result['IDC'] = str(sim_result['IDC']) + ". Meets the requirements."
    
    else:
        # For default designs, check if each performance index meets the requirements within a certain range
        if COMPARE_OPS[config.PFINDEX['Gain']['requirement']](float(sim_result['Gain']), float(config.PFINDEX['Gain']['value'])):
            sim_result['Gain'] = str(sim_result['Gain']) + ". Meets the requirements."
        else:
            sim_result['Gain'] = str(sim_result['Gain']) + ". Does not meet the requirements."
        if COMPARE_OPS[config.PFINDEX['GBW']['requirement']](float(sim_result['GBW']), float(config.PFINDEX['GBW']['value'])):
            sim_result['GBW'] = str(sim_result['GBW']) + ". Meets the requirements."
        else:
            sim_result['GBW'] = str(sim_result['GBW']) + ". Does not meet the requirements."
        if COMPARE_OPS[config.PFINDEX['PM']['requirement']](float(sim_result['PM']), float(config.PFINDEX['PM']['value'])):
            sim_result['PM'] = str(sim_result['PM']) + ". Meets the requirements."
        else:
            sim_result['PM'] = str(sim_result['PM']) + ". Does not meet the requirements."
        if COMPARE_OPS[config.PFINDEX['SR']['requirement']](float(sim_result['SR']), float(config.PFINDEX['SR']['value'])):
            sim_result['SR'] = str(sim_result['SR']) + ". Meets the requirements."
        else:
            sim_result['SR'] = str(sim_result['SR']) + ". Does not meet the requirements."
        if COMPARE_OPS[config.PFINDEX['IDC']['requirement']](float(sim_result['IDC']), float(config.PFINDEX['IDC']['value'])):
            sim_result['IDC'] = str(sim_result['IDC']) + ". Meets the requirements."
        else:
            sim_result['IDC'] += str(sim_result['IDC']) + ". Does not meet the requirements."
    
    return netlist, sim_result