"""A TIR(tool-integrated reasoning) math agent
```bash
python tir_math.py
```
"""
import os
import ipdb
import re
from pprint import pprint
from ollama import create

from qwen_agent.agents import TIRMathAgent
from qwen_agent.gui import WebUI

ROOT_RESOURCE = os.path.join(os.path.dirname(__file__), 'resource')

# We use the following two systems to distinguish between COT mode and TIR mode
TIR_SYSTEM = """Please integrate natural language reasoning with programs to solve the problem above, and put all the values I ask you to calculate in the International System of Units (SI) and within [\\boxed{}], all values in one box (for example, if I ask you to calculate 4 different values, you should return 1 box containing 4 values, the values are separated by ",',like"[\\boxed{1 \\text{ F}, 2 \\text{ F}, 3 \\text{ F}, 4 \\times 10^{-5} \\text{ F}}]", no extra commas allowed), and only contains of numbers."""
COT_SYSTEM = """Please reason step by step, and put all the values I ask you to calculate within \\boxed{}, one value one box."""
GENERATE_SYSTEM = """ Please follow the instructions to replace required strings with their values and send back the whole netlist within "{}". Don't tell me about your thinking process."""


def extract_with_slicing(text, start_char, end_char):
    start_index = -1
    end_index = -1
    for i, char in enumerate(text):
        if start_char in text[i:]:
            start_index = text[i:].index(start_char) + i
        if start_index != -1 and end_char in text[i:]:
            end_index = text[i:].index(end_char) + i
            continue
    if start_index != -1 and end_index != -1:
        return text[start_index + len(start_char):end_index]
    else:
        return None

# def extract_with_slicing(text, start_char, end_char):
#     start_index = text.find(start_char)
#     if start_index == -1:
#         return None

#     end_index = text.find(end_char, start_index + len(start_char))
#     if end_index == -1:
#         return None

    return text[start_index + len(start_char):end_index].strip()
def init_agent_service():
    llm_cfg = {
        # Use a model service compatible with the OpenAI API, such as vLLM or Ollama:
        'model': 'qwenmath7b_modified',
        'model_server':'http://localhost:11434/v1/',  # base_url, also known as api_base
        'api_key': 'ollama',
    }
    # Use this to access the qwen2.5-math model deployed on dashscope
    #llm_cfg = {'model': 'qwen2.5-math-7b-instruct', 'model_type': 'qwen_dashscope', 'generate_cfg': {'top_k': 1}}
    bot = TIRMathAgent(llm=llm_cfg, name='Qwen2.5-Math', system_message=TIR_SYSTEM)
    return bot


def init_agent_service1():
    # Use this to access the qwen2.5-math model deployed on dashscope
    llm_cfg = {
        # Use a model service compatible with the OpenAI API, such as vLLM or Ollama:
        'model': 'qwen2.5normal7b_modified',
        'model_server':'http://localhost:11434/v1/',  # base_url, also known as api_base
        'api_key': 'ollama',
    }
    #llm_cfg = {'model': 'qwen2.5-7b-instruct', 'model_type': 'qwen_dashscope', 'generate_cfg': {'top_k': 1}}
    bot = TIRMathAgent(llm=llm_cfg, name='Qwen2.5-Math', system_message=GENERATE_SYSTEM)
    return bot

def concate_questions(prompt_num):
    send_prompt=[]
    with open(f'/root/submission/prompt/common_header.txt', 'r') as file:
        context=file.readlines()
        send_prompt=''.join(context)

    # with open('/root/submission/prompt/param_table.txt', 'r') as file:
    #     lines = file.readlines()
    #     for line in lines:
    #         if "To be calculated" not in line:
    #             send_prompt += line

    with open(f'/root/submission/prompt/step_{prompt_num}.txt', 'r') as file:
        context=file.readlines()
        send_prompt+=''.join(context)
        last_line=context[-1]
        variable_num=int(extract_with_slicing(last_line, 'calculate ', ' different'))
        variable_list=extract_with_slicing(last_line, 'values: ', '.').split(',')
        var_list=[]
        for vari in variable_list:
            if "and" in vari:
                vari = re.sub(r'\band\b', '', vari)
            vari=vari.replace(" ","")
            var_list.append(vari)

        print(variable_num,var_list)

    return send_prompt,var_list

def concate_iter_questions(iter_prompt_num):
    send_prompt=[]
    with open(f'/root/submission/prompt/common_header_iter.txt', 'r') as file:
        context=file.readlines()
        send_prompt=''.join(context)

    with open('/root/submission/prompt/param_table_new.txt', 'r') as file:
        lines = file.readlines()
        for line in lines:
            if "To be calculated" not in line:
                send_prompt += line
    # i = 0
    var_list=[]
    # while i < iter_prompt_num:
    with open(f'/root/submission/prompt/iter_step_{iter_prompt_num}.txt', 'r') as file:
        context=file.readlines()
        send_prompt+=''.join(context)
        last_line=context[-1]
        variable_num=int(extract_with_slicing(last_line, 'calculate ', ' different'))
        variable_list=extract_with_slicing(last_line, 'values: ', '.').split(',')
        for vari in variable_list:
            if "and" in vari:
                vari = re.sub(r'\band\b', '', vari)
            vari=vari.replace(" ","")
            var_list.append(vari)
        # i+=1
        print(variable_num,var_list)

    return send_prompt,var_list

def concate_generation():
    send_prompt=''

    with open('/root/submission/prompt/param_table_new.txt', 'r') as file:
        lines = file.readlines()
        for line in lines:
            if "To be calculated" not in line:
                send_prompt += line

    with open(f'/root/submission/prompt/generate_netlist.txt', 'r') as file:
        context=file.readlines()
        send_prompt+=''.join(context)

    return send_prompt

def separate_values(strcontent):
    value_list=strcontent.split(',')
    val_list=[]
    for val in value_list:
        if 'times' in val:
            print(val)
            # ipdb.set_trace()
            ten_num=int(extract_with_slicing(val, '\\times 10^{', '}').split(' ')[0].replace('}',''))
            pattern = r'\b' + re.escape('times 10^{') + r'.*?\b' + re.escape('} \\text') + r'\b'
            val = re.sub(pattern, '', val)
        else:
            ten_num=0
        val = val.replace(" ", "")
        pattern = r'[-+]?\d*\.?\d+(?:e[-+]?\d+)?'

        # 使用 re.findall() 提取所有匹配的数字
        numbers = re.findall(pattern, val)
        numbers=float(numbers[0])*(10**ten_num)
        val_list.append(numbers)

    return val_list

def find_lines_starting_with(file_path, start_char,expected_val):
    with open(file_path, 'r') as file:
        lines = file.readlines()
        modified_char = start_char.replace('_new','')
    with open(file_path, 'w') as file:
        for line in lines:
            if line.startswith(start_char) or line.startswith(modified_char):
                if '[To be calculated]' in line:
                    line = line.replace('[To be calculated]', str(expected_val))
                else:
                    # ipdb.set_trace()
                    if line.startswith(start_char):
                        line = f'{start_char} = {expected_val}\n'
                    else:
                        line = f'{modified_char} = {expected_val}\n'

            file.write(line)

# def modify_lines_iter(file_path, start_char,expected_val):
#     with open(file_path, 'r') as file:
#         lines = file.readlines()

#     with open(file_path, 'w') as file:
#         for line in lines:
#             if line.startswith(start_char):
#                 # Replace the multi value
#                 line = re.sub(rf'start_char = \d+', rf'start_char = {expected_val}', line)
#             file.write(line)
def read_deepseek_prompt(num):
    with open(f'/root/submission/prompt/step_{num}.txt', 'r', encoding='utf-8') as file:
        query = file.read()
    return query

def read_deepseek_instruction_prompt(filepath):
    with open(filepath, 'r', encoding='utf-8') as file:
        query = file.read()
    return query

def test(num):
    # Define the agent
    #query,varlist=concate_questions(num)
    #bot = init_agent_service()
    query = read_deepseek_prompt(num)
    print(query)
    #os.system(f"ollama run tripplyons/r1-distill-qwen-7b '{query}' | tee question_{num}.txt")
    os.system(f"ollama run qwen2.5-coder:7b '{query}' | tee question_{num}.txt")
    # Chat
    #messages = [{'role': 'user', 'content': query}]
    #response_all=[]
    #for response in bot.run(messages):
        #response_all.append(response)
        #pprint(response, indent=2)

    #response_str=response_all[-1][0]['content']
    with open(f'question_2.txt', 'r', encoding='utf-8') as file:
        response_str = file.read()
    #print(response_str)
    code=extract_python_code(response_str)
    with open("/root/submission/agent/output.py", "w", encoding="utf-8") as file:
        file.write(code)
    from output import calculate_ratio
    result_list=calculate_ratio(50,0.5,50,38,28,0.22,20)
    print('Calculation complete',result_list)

    result_list=list(result_list)

    result_list[0]=round(result_list[0],2)
    result_list[1]=round(result_list[1],2)
    result_list[2]=round(result_list[2]*0.5,2)
    result_list[3]=round(result_list[3]*0.5/2,2)
    result_list[4]=round(result_list[4]*0.8,2)
    result_list[5]=round(result_list[5]*0.5,2)

    var_list=['W_12','W_34','W_5','W_6','W_7','W_8',]
    for i in range (0,len(result_list)):
            find_lines_starting_with('/root/submission/prompt/param_table_new.txt', var_list[i],result_list[i])
    


    #print(response_str)
    '''
    result = extract_with_slicing(response_str, '\\boxed{', '}')
    print(result)
    if not result:
        result = extract_with_slicing(response_str, '\\boxed{', ']')
    if not result:
        result = extract_with_slicing(response_str, '\\boxed{', '}')
    print(response_all[-1][0])
    var_vals=separate_values(result)
    print(result)
    print(var_vals)
    if len(varlist)==len(var_vals):
        for i in range (0,len(varlist)):
            find_lines_starting_with('../prompt/param_table.txt', varlist[i],var_vals[i])
            find_lines_starting_with('../prompt/param_table_new.txt', varlist[i],var_vals[i])
    '''

def iteration(num):
    # Define the agent
    query,varlist=concate_iter_questions(num)
    # ipdb.set_trace()
    print(query)
    with open("/root/submission/agent/query.txt", "w", encoding="utf-8") as file:
        file.write(query)
    os.system(f'ollama run qwen2.5:7b < /root/submission/agent/query.txt | tee iteration.txt')
    
    with open(f'iteration.txt', 'r', encoding='utf-8') as file:
        response_str = file.read()
    
    response_str = extract_parameter_code(response_str)
    return response_str
    '''
    if response_str == None:
    response_str = '```parameter_table\n'+response_str+"\n"+"```"
    with open('../prompt/param_table_new.txt', 'w') as f:
        f.write(response_str)
    '''

def execute_iteration_until_not_none(func):
    response_str = func(1)
    if response_str is None:
        print("Result is None, retrying...")
        response_str = func(1)
    else:
        response_str = '```parameter_table\n'+response_str+"\n"+"```"
        with open('/root/submission/prompt/param_table_new.txt', 'w') as f:
            f.write(response_str)
    


def replace_values():
    
    variables = {}
    with open("/root/submission/prompt/param_table_new.txt", 'r') as f:
        for line in f:
            line = line.strip()
            if '=' in line and '[To be calculated]' not in line and '```' not in line:
                key, value = line.split('=', 1)
                variables[key.strip()] = value.strip()

    os.system('rm -f /root/submission/final_netlist2/AMP.cir')
    os.system('touch /root/submission/final_netlist2/AMP.cir')
    os.system('cp /root/submission/prompt_previous/AMP_clean.cir /root/submission/final_netlist2/AMP.cir')
    target_file = '/root/submission/final_netlist2/AMP.cir'
    # 读取 target_file，替换变量为对应的值
    with open(target_file, 'r') as f:
        target_lines = f.readlines()

    with open(target_file, 'w') as f:
        for line in target_lines:
            for key, value in variables.items():
                # 替换变量为对应的值
                line = line.replace(key, value)
            print(line)
            f.write(line)



def generate():
    os.system('rm -f /root/submission/final_netlist2/AMP.cir')
    os.system('touch /root/submission/final_netlist2/AMP.cir')
    os.system('cp /root/submission/prompt_previous/AMP_clean.cir /root/submission/final_netlist2/AMP.cir')
    # Define the agent
    query=concate_generation()
    print(query)
    # Chat

    with open("query.txt", "w", encoding="utf-8") as file:
        file.write(query)
    os.system(f'ollama run qwen2.5normal7b_modified:latest < query.txt | tee generation.txt')
    with open(f'generation.txt', 'r', encoding='utf-8') as file:
        response_str = file.read()
    #print(response_str)
    code=extract_ngspice_code(response_str)
    with open("/root/submission/final_netlist2/AMP.cir", "w", encoding="utf-8") as file:
        file.write(code)


def evaluate_metrics(sim_results, expected_results):
    evaluation_matrix = [False]*len(sim_results)
    print(sim_results, expected_results)
    for idx in range(len(sim_results)):
        if idx != 7 and idx != 4:
            if float(sim_results[idx]) > expected_results[idx]:
                evaluation_matrix[idx] = True
        else:
            if float(sim_results[idx]) < expected_results[idx]:
                evaluation_matrix[idx] = True
    print("Evaluation Matrix:", evaluation_matrix)
    return evaluation_matrix

def ResultsExtraction(AC_results_dir, SR_results_dir, idc_results_dir, CMRR_results_dir, noise_results_dir, PSRR_results_dir):
    all_results = []
    with open(AC_results_dir,'r') as file:
        for line in file:
            if line != '\n':
                line.replace("\n","")
                if 'GBW' in line:
                    print(line)
                    all_results.append(float(line.split(' ')[-1])/1E6)
                else:
                    all_results.append(float(line.split(' ')[-1]))
    with open(CMRR_results_dir, 'r') as file:
        for line in file:
            if line != '\n':
                line.replace("\n","")
                if 'CMRR' in line:
                    # ipdb.set_trace()
                    all_results.append(float(line.split(' ')[-1]))
    with open(noise_results_dir, 'r') as file:
        for line in file:
            if line != '\n':
                line.replace("\n","")
                if 'inputnoise' in line:
                    # ipdb.set_trace()
                    all_results.append(float(line.split(' ')[-1])*1000000)
    with open(PSRR_results_dir, 'r') as file:
        for line in file:
            if line != '\n':
                line.replace("\n","")
                if 'PSRR' in line:
                    all_results.append(float(line.split(' ')[-1]))
    # AC_results = [Gain, GBW, PM]
    with open(SR_results_dir,'r') as file:
        for line in file:
            if line != '\n':
                line.replace("\n","")
                value = (float(line.split(' ')[-1]))/10**6
                SR_result = "{:.3f}".format(value)
    with open(idc_results_dir,'r') as file:
        for line in file:
            if line != '\n':
                line.replace("\n","")
                value = (float(line.split(' ')[-1]))*10**6
                IDC_result = "{:.3f}".format(value)
    all_results.extend([float(SR_result), float(IDC_result)])
    return all_results
def test_flow():
    #bot = init_agent_service()
    # os.system('rm -f /root/submission/prompt/param_table.txt')
    # os.system('touch /root/submission/prompt/param_table.txt')
    # os.system('cp /root/submission/prompt_previous/param_table_clean.txt /root/submission/prompt/param_table.txt')
    os.system('rm -f /root/submission/prompt/param_table_new.txt')
    os.system('touch /root/submission/prompt/param_table_new.txt')
    os.system('cp /root/submission/prompt_previous/param_table_new_clean.txt /root/submission/prompt/param_table_new.txt')
    # ipdb.set_trace()
    # for i in range (2,10):
    #     test(i)
    test(2)

    #generate()
    replace_values()
    # Corner iteration generation of the sim results, and selected the worst solution
    corners = ['FF','FS','SF','SS','TT']
    # copy the initial parameters, to ensure same intialization of each corner
    # os.system('cp ../prompt/param_table_new.txt ../prompt/initial_parameter_table_new.txt')
    # os.system('cp ../prompt/param_table.txt ../prompt/initial_param_table.txt')
    sim_results_all_corners = {}
   
        # os.system(f'touch {corner}_iteration_records.txt')
        # os.system('cp ../prompt/initial_parameter_table_new.txt ../prompt/param_table_new.txt')
        # os.system('cp ../prompt/initial_param_table.txt ../prompt/param_table.txt')
    corner = 'TT'
    Satisfied = False
    iteration_time = 0
    # expected_results = [75, 20, 60, 20, 500] # For testing several iterations
    expected_results = [70, 20, 60, 70, 20, 75, 20, 500]
    metrix = ['gain_value', 'gbw_value', 'pm_value', 'CMRR_value', 'noise_value', 'PSRR_value', 'sr_value', 'idc_value']
    while (not Satisfied) and (iteration_time < 10):
        # ngspice simulation
        # ipdb.set_trace()
        os.system(f'ngspice -b /root/submission/final_netlist2/{corner}/AMP_AC_CurrentBias.cir')
        os.system(f'ngspice -b /root/submission/final_netlist2/{corner}/AMP_SR_CurrentBias.cir')
        os.system(f'ngspice -b /root/submission/final_netlist2/{corner}/AMP_IDC_CurrentBias.cir')
        ############### TODO ###############s
        ## Should add CMRR, noise & PSRR simulation & Extraction 
        # Evaluation Results Extraction
        os.system(f'ngspice -b /root/submission/final_netlist2/{corner}/AMP_CMRR.cir')
        os.system(f'ngspice -b /root/submission/final_netlist2/{corner}/AMP_noise.cir')
        os.system(f'ngspice -b /root/submission/final_netlist2/{corner}/AMP_PSRR.cir')
        AC_results_dir = f'/root/submission/{corner}_AC_results.txt'
        SR_results_dir = f'/root/submission/{corner}_SR.txt'
        idc_results_dir = f'/root/submission/{corner}_Idc.txt'
        CMRR_results_dir = '/root/submission/CMRR_results.txt'
        noise_results_dir = '/root/submission/noise_1KHZ.txt'
        PSRR_results_dir = '/root/submission/PSRR_results.txt'

        sim_results = ResultsExtraction(AC_results_dir, SR_results_dir, idc_results_dir, CMRR_results_dir, noise_results_dir, PSRR_results_dir)

        with open(f'{corner}_iteration_records.txt', 'a') as file:
            def print_to_file(*args, **kwargs):
                print(*args, **kwargs)
                print(*args, file=file, **kwargs)

            print_to_file("------------------------")
            print_to_file("Simulation Result Metrix:")
            print_to_file('Gain:', sim_results[0], 'GBW:', sim_results[1], 'PM:', sim_results[2], 'CMRR:', sim_results[3], 'noise:', sim_results[4], 'PSRR:', sim_results[5], 'SR:', sim_results[6], 'IDC:', sim_results[7])
            print_to_file("------------------------")
            # Finetune Logic
            evaluation_result_metrix = evaluate_metrics(sim_results, expected_results)
            print_to_file("------------------------")
            print_to_file("Evaluation Result Metrix:")
            print_to_file('Gain:', evaluation_result_metrix[0], 'GBW:', evaluation_result_metrix[1], 'PM:', evaluation_result_metrix[2], 'CMRR:', evaluation_result_metrix[3], 'noise:', evaluation_result_metrix[4], 'PSRR:', evaluation_result_metrix[5], 'SR:', evaluation_result_metrix[6], 'IDC:', evaluation_result_metrix[7])
            print_to_file("------------------------")
            # for i in range(len(evaluation_result_metrix)):
            #     # modify the values in param_table
            #     find_lines_starting_with('/root/submission/prompt/param_table.txt', metrix[i], evaluation_result_metrix[i])
            # ipdb.set_trace()
            if all(item for item in evaluation_result_metrix):
                Satisfied = True
            else:
                unsatisfied = []
                print_to_file('iteration_number', iteration_time)
                for idx, item in enumerate(evaluation_result_metrix):
                    if item == False:
                        # print_to_file(f"Metrix {metrix[idx]} is unsatisfied")
                        unsatisfied.append(metrix[idx])
                if 'gain_value' in unsatisfied or 'pm_value' in unsatisfied:
                    print_to_file("------------------------------------------------")
                    print_to_file("Iteration Starts for fine-tuning gain and PM...")
                    print_to_file("Increase the width of the transistor M6 and M7 by epsilon")
                    print_to_file("------------------------------------------------")
                    #iteration(1) # Execute the first iteration prompt
                    execute_iteration_until_not_none(iteration)
                    replace_values()
                # else:
                #     Satisfied = True
        iteration_time += 1
    # Finish Fine-tuning with TT corner

    # Potential Problem here, the worst value might not satisfy the expected_results, but not too away from if TT corner is near the expectation.
    for corner in corners:
        os.system(f'ngspice -b /root/submission/final_netlist2/{corner}/AMP_AC_CurrentBias.cir')
        os.system(f'ngspice -b /root/submission/final_netlist2/{corner}/AMP_SR_CurrentBias.cir')
        os.system(f'ngspice -b /root/submission/final_netlist2/{corner}/AMP_IDC_CurrentBias.cir')
        ############### TODO ###############s
        ## Should add CMRR, noise & PSRR simulation & Extraction 
        # Evaluation Results Extraction
        os.system(f'ngspice -b /root/submission/final_netlist2/{corner}/AMP_CMRR.cir')
        os.system(f'ngspice -b /root/submission/final_netlist2/{corner}/AMP_noise.cir')
        os.system(f'ngspice -b /root/submission/final_netlist2/{corner}/AMP_PSRR.cir')
        AC_results_dir = f'/root/submission/{corner}_AC_results.txt'
        SR_results_dir = f'/root/submission/{corner}_SR.txt'
        idc_results_dir = f'/root/submission/{corner}_Idc.txt'
        CMRR_results_dir = '/root/submission/CMRR_results.txt'
        noise_results_dir = '/root/submission/noise_1KHZ.txt'
        PSRR_results_dir = '/root/submission/PSRR_results.txt'

        sim_results = ResultsExtraction(AC_results_dir, SR_results_dir, idc_results_dir, CMRR_results_dir, noise_results_dir, PSRR_results_dir)
        with open(f'{corner}_evaluation_records.txt', 'a') as file:
            def print_to_file(*args, **kwargs):
                print(*args, **kwargs)
                print(*args, file=file, **kwargs)

            print_to_file("------------------------")
            print_to_file("Simulation Result Metrix:")
            print_to_file('Gain:', sim_results[0], 'GBW:', sim_results[1], 'PM:', sim_results[2], 'CMRR:', sim_results[3], 'noise:', sim_results[4], 'PSRR:', sim_results[5], 'SR:', sim_results[6], 'IDC:', sim_results[7])
            print_to_file("------------------------")
            # Finetune Logic
            evaluation_result_metrix = evaluate_metrics(sim_results, expected_results)
            print_to_file("------------------------")
            print_to_file("Evaluation Result Metrix:")
            print_to_file('Gain:', evaluation_result_metrix[0], 'GBW:', evaluation_result_metrix[1], 'PM:', evaluation_result_metrix[2], 'CMRR:', evaluation_result_metrix[3], 'noise:', evaluation_result_metrix[4], 'PSRR:', evaluation_result_metrix[5], 'SR:', evaluation_result_metrix[6], 'IDC:', evaluation_result_metrix[7])
            print_to_file("------------------------")
    # All simulated results stored in f'{corner}_iteration_records.txt'
        sim_results_all_corners[corner] = sim_results
        # metrix = ['gain_value', 'gbw_value', 'pm_value', 'CMRR_value', 'noise_value', 'PSRR_value', 'sr_value', 'idc_value']
        # ipdb.set_trace()
    results_dict = {}
    worst_list = []
    for metric in metrix:
        results_dict[metric] = []
    for key in sim_results_all_corners.keys():
        print("------------------------")
        print(f'Simulation Results of {key}: ')
        sim_results = sim_results_all_corners[key]
        print('Gain:', sim_results[0], 'GBW:', sim_results[1], 'PM:', sim_results[2], 'CMRR:', sim_results[3], 'noise:', sim_results[4], 'PSRR:', sim_results[5], 'SR:', sim_results[6], 'IDC:', sim_results[7])
        for idx, metric in enumerate(metrix):
            results_dict[metric].append(sim_results[idx])
    for metric in results_dict.keys():
        if key not in ['noise_value', 'idc_value']:
            worst_value = min(results_dict[metric])
            worst_list.append(worst_value)
        else:
            worst_value = max(results_dict[metric])
            worst_list.append(worst_value)
    # print out the worst evaluation results
    print('The Worst Evaluation Results are:')
    for idx, metric in enumerate(results_dict.keys()):
        worst_value = worst_list[idx]
        print(f'{metric} worst value: {worst_value}')
    print('Finish Evaluation!!')



def app_tui():
    # Define the agent
    bot = init_agent_service()

    # Chat
    messages = []
    while True:
        # Query example: 斐波那契数列前10个数字
        query = input('user question: ')
        messages.append({'role': 'user', 'content': query})
        response = []
        for response in bot.run(messages):
            print('bot response:', response)
        messages.extend(response)


def app_gui():
    bot = init_agent_service()
    chatbot_config = {
        'prompt.suggestions': [
            r'曲线 $y=2 \\ln (x+1)$ 在点 $(0,0)$ 处的切线方程为 $( )$.',
            'A digital display shows the current date as an $8$-digit integer consisting of a $4$-digit year, '
            'followed by a $2$-digit month, followed by a $2$-digit date within the month. '
            'For example, Arbor Day this year is displayed as 20230428. '
            'For how many dates in $2023$ will each digit appear an even number of times '
            'in the 8-digital display for that date?'
        ]
    }
    WebUI(bot, chatbot_config=chatbot_config).run()

def extract_python_code(text):
    pattern = r'```python\s*(.*?)\s*```'  # 匹配 ```python 开头和 ``` 结尾的内容
    matches = re.findall(pattern, text, re.DOTALL)  # 使用 DOTALL 模式匹配换行符
    return matches[0] if matches else None  # 返回第一个匹配结果

def extract_ngspice_code(text):
    pattern = r'```ngspice\s*(.*?)\s*```'  # 匹配 ```python 开头和 ``` 结尾的内容
    matches = re.findall(pattern, text, re.DOTALL)  # 使用 DOTALL 模式匹配换行符
    return matches[0] if matches else None  # 返回第一个匹配结果

def extract_parameter_code(text):
    pattern = r'```parameter_table\s*(.*?)\s*```'  # 匹配 ```python 开头和 ``` 结尾的内容
    matches = re.findall(pattern, text, re.DOTALL)  # 使用 DOTALL 模式匹配换行符
    return matches[0] if matches else None  # 返回第一个匹配结果

if __name__ == '__main__':
    
    os.system('rm -f /root/submission/agent/output.py')
    # os.system('rm -f /root/submission/prompt/param_table.txt')
    # os.system('touch /root/submission/prompt/param_table.txt')
    # os.system('cp /root/submission/prompt_previous/param_table_clean.txt /root/submission/prompt/param_table.txt')
    os.system('rm -f /root/submission/prompt/param_table_new.txt')
    os.system('touch /root/submission/prompt/param_table_new.txt')
    os.system('cp /root/submission/prompt_previous/param_table_new_clean.txt /root/submission/prompt/param_table_new.txt')
    os.system('rm -f /root/submission/final_netlist2/AMP.cir')
    os.system('touch /root/submission/final_netlist2/AMP.cir')
    os.system('cp /root/submission/prompt_previous/AMP_clean.cir /root/submission/final_netlist2/AMP.cir')
    

    test_flow()
    
    
    with open('/root/submission/final_netlist2/CurrentBias.cir', 'r', encoding='utf-8') as source_file:
        content = source_file.read()
        content += '\n\n'

    with open('/root/submission/final_netlist2/AMP.cir', 'r+', encoding='utf-8') as target_file:
        original_content = target_file.read()
        target_file.seek(0)
        target_file.write(content)
        target_file.write(original_content)

    os.system('cp /root/submission/final_netlist2/AMP.cir /root/submission/AMP.cir')
    
    #for i in range (0,3):
        #execute_iteration_until_not_none(iteration)


