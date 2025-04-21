import ollama
import asyncio
import platform
import subprocess
import config
import random
import re

from http import HTTPStatus
import dashscope
from dashscope.api_entities.dashscope_response import Role
from dashscope import Generation
from dashscope.aigc.generation import AioGeneration


class Aligpt_ollama():
    def __init__(self, model, temperature):
        self.model = model
        self.temperature = temperature
        
    async def async_add_message(self, prompt, question):
        client= ollama.Client()
        prompt += "\n\n" + question
        print(prompt)
        """
        Call Ollama to generate a streaming response, print it in real time and return the full result

        Args:
        prompt (str): A prompt entered by the user
        model (str, optional): The name of the model used. Defaults to "llama2".

        Returns:
        str: Complete generated content (error message returned if failure)
        """
        full_response = ""
        try:
            # Create a stream generator
            stream = client.generate(
                model=self.model,
                prompt=prompt,
                options={"temperature":self.temperature},
                stream=True,
                keep_alive=-1
            )
            
            # Process the response block by block
            for chunk in stream:
                chunk_content = chunk.get("response", "")
                print(chunk_content, end="", flush=True)  # Print in real time without line feed
                full_response += chunk_content

            print()  # Last line wrap
            return full_response

        except Exception as e:
            error_msg = f"Build failure: {str(e)}"
            print(error_msg)
            return error_msg
        
class Aligpt():
    def __init__(self, model, temperature):
        dashscope.api_key = ""
        self.model = model
        self.temperature = temperature
    
    async def async_add_message(self, prompt, question, questionhistory=[], enable_search=False):
        if questionhistory:
            messages = [{'role': Role.SYSTEM, 'content': prompt}]
            for i in questionhistory:
                messages.append({'role': Role.USER, 'content': i.get("question")})
                messages.append({'role': Role.ASSISTANT, 'content': i.get("answer")})
            messages.append({'role': Role.USER, 'content': question})
            messages, full_content, input_tokens, output_tokens = await self.async_dashscope_stream(messages, enable_search)
            # print("response:", response)
            try:
                return full_content
            except Exception as e:
                return "err"
            
        else:
            messages = [{'role': Role.SYSTEM, 'content': prompt},
                        {'role': Role.USER, 'content': question}]
            messages, full_content, input_tokens, output_tokens = await self.async_dashscope_stream(messages, enable_search)
            # print("ai返回的response=", response)
            try:
                return full_content
            except Exception as e:
                return "err"
    
    async def async_dashscope_stream(self, messages, enable_search):
        seed = random.randint(1, 2**32 -1)
        responses = await AioGeneration.call(
            model=self.model,
            messages=messages,
            result_format='message',  # set the result to be "message" format.
            temperature=self.temperature,
            seed=4274740410,
            stream=True,
            incremental_output=True,
            enable_search=enable_search
        )
        full_content = ''
        input_tokens = 0
        output_tokens = 0
        print_request_id = True
        async for response in responses:
            if response.status_code == HTTPStatus.OK:
                if print_request_id:
                    print(f'Request id: {response.request_id}')
                    print_request_id = False
                # append result to messages.
                full_content += response.output.choices[0]['message']['content']
                role = response.output.choices[0]['message']['role']
                input_tokens = response.usage.input_tokens
                output_tokens = response.usage.output_tokens
                print(response.output.choices[0]['message']['content'], flush=True, end='')
            else:
                print('Request id: %s, Status code: %s, error code: %s, error message: %s, input messages: %s' % (
                    response.request_id, response.status_code,
                    response.code, response.message, messages
                ))
        messages.append({'role': role,
                        'content': full_content})
        
        return messages, full_content, input_tokens, output_tokens

async def callmodel_async(
    prompt: str, 
    question: str
):
    # check current os
    current_os = platform.system()
    if current_os == "Windows":
        print(f"prompt: {prompt}")
        print(f"question: {question}")
        ali = Aligpt(model='qwen2.5-7b-instruct', temperature=0)
    else:
        ali = Aligpt_ollama(model="qwen2.5:7b-instruct-fp16", temperature=0)
    return await ali.async_add_message(prompt, question)


async def str2spice(str_data: str):
    import re
    try:
        matches = re.findall(r'```spice_final\n(.*?)\n```', str_data, re.DOTALL)
        # get the last match
        if matches:
            answer = matches[-1]
        else:
            matches = re.findall(r'```spice\n(.*?)\n```', str_data, re.DOTALL)
            if matches:
                answer = matches[-1]
            else:
                matches = re.findall(r'```spice_process\n(.*?)\n```', str_data, re.DOTALL)
                if matches:
                    answer = matches[-1]
                else:
                    answer = None
        return answer
    except Exception as e:
        # if the output is not in JSON format, return it directly and record the log
        answer = None
        return answer
    
import json
async def str2json(str_data: str):
    import re
    try:
        matches = re.findall(r'```json\n(.*?)\n```', str_data, re.DOTALL)
        # get the last match
        if matches:
            answer = matches[-1]
        else:
            matches = re.findall(r'```json\n(.*?)\n```', str_data, re.DOTALL)
            if matches:
                answer = matches[-1]
            else:
                matches = re.findall(r'```json\n(.*?)\n```', str_data, re.DOTALL)
                if matches:
                    answer = matches[-1]
                else:
                    try:
                        answer = json.loads(str_data)
                        return str_data
                    except Exception as e:
                        answer = None
                        return answer
                    
        return answer
    except Exception as e:
        # if the output is not in JSON format, return it directly and record the log
        answer = None
        return answer
        
import os
prompt_dir = os.path.join(os.path.dirname(__file__), '..', 'prompt')
        
async def read_prompt_file(filename):
    file_path = os.path.join(prompt_dir, filename)
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
        return content
    except FileNotFoundError:
        print(f"cannot find file {filename} .")
        return None
    except Exception as e:
        print(f"error return when read file {filename}: {e}")
        return None
    
result_dir = os.path.join(os.path.dirname(__file__), '..', 'result')
async def read_result_file(filename):
    file_path = os.path.join(result_dir, filename)
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
        return content
    except FileNotFoundError:
        print(f"cannot find file {filename} .")
        return None
    except Exception as e:
        print(f"error return when read file {filename}: {e}")
        return None
    
netlist_dir = os.path.join(os.path.dirname(__file__), '..', 'netlist')
async def read_netlist_file(filename):
    file_path = os.path.join(netlist_dir, filename)
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
        return content
    except FileNotFoundError:
        print(f"cannot find file {filename} .")
        return None
    except Exception as e:
        print(f"error return when read file {filename}: {e}")
        return None
    
async def write_string_to_file(filename, content):
    # open the file in write mode, if the file does not exist, create the file
    try:
        with open(filename, 'w', encoding='utf-8') as file:
            file.write(content)
        return True
    except Exception as e:
        print(f"error return when writing file {filename} : {e}")
        return False
    
import shutil
    
async def backup_file(original_file_path, num):
    # Check if the original file exists
    if not os.path.isfile(original_file_path):
        print(f"file '{original_file_path}' is not exist.")
        return False

    # split file name and extension
    file_name, file_extension = os.path.splitext(original_file_path)

    # add '_last' before the extension
    backup_file_name = f"{file_name}_{num}{file_extension}"

    # copy file to new path
    try:
        shutil.copy2(original_file_path, backup_file_name)
        return True
    except Exception as e:
        print(f"error return when backup file: {e}")
        return False

import datetime
import zipfile
    
def backup_directories():
    # backup file path
    files_to_backup = []
    
    # add files to backup list if they meet the criteria
    # backup files in netlist directory whose name starts with AMP
    netlist_path = '../netlist'
    for file in os.listdir(netlist_path):
        if file.startswith('AMP') and os.path.isfile(os.path.join(netlist_path, file)):
            files_to_backup.append(os.path.join(netlist_path, file))
    
    # backup files in result directory
    result_path = '../result'
    for file in os.listdir(result_path):
        if os.path.isfile(os.path.join(result_path, file)):
            files_to_backup.append(os.path.join(result_path, file))
    
    # backup files in prompt directory
    prompt_path = '../prompt'
    for file in os.listdir(prompt_path):
        if os.path.isfile(os.path.join(prompt_path, file)):
            files_to_backup.append(os.path.join(prompt_path, file))

    # backup file's name and path
    timestamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    backup_filename = f"../backup/{timestamp}.zip"

    # if the backup directory does not exist, create it
    os.makedirs('../backup', exist_ok=True)

    # create a zip file
    with zipfile.ZipFile(backup_filename, 'w', zipfile.ZIP_DEFLATED) as backup_zip:
        for file_path in files_to_backup:
            # add file to zip file
            backup_zip.write(file_path, os.path.basename(file_path))

    # print(f"backup finish, save as: {backup_filename}")
    


# simulation fuction
async def run_ngspice(cir_file, b=True):
    try:
        # use subprocess.Popen run cmd
        cir_file_path = os.path.join(os.getcwd(), '../netlist', cir_file)
        # check current os
        current_os = platform.system()
        # set ngspice path
        ngspice_path_windows = "../other/NGSpice64/bin/ngspice.exe"
        ngspice_path_linux = "../other/ngspice-43/debug/src/ngspice"
        
        # Windows command
        if current_os == "Windows":
            if b:
                command = [ngspice_path_windows, "-b", cir_file_path]
            else:
                command = [ngspice_path_windows, cir_file_path]
        # linux command
        elif current_os == "Linux" or current_os == "Darwin":
            if b:
                command = [ngspice_path_linux, "-b", cir_file_path]
            else:
                command = [ngspice_path_linux, cir_file_path]
        else:
            print(f"Unsupported operating system: {current_os}")
            return False
        
        # set run path
        result_path = os.path.abspath('../result')
        
        # process = subprocess.Popen(command, cwd=result_path, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        process = await asyncio.create_subprocess_exec(
            *command,
            cwd=result_path,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        # 异步等待进程完成
        await process.wait()
        
        
        # get output and error information
        # stdout, stderr = process.communicate()
        
        return process.returncode == 0
        # return True
        
    except Exception as e:
        print(f"error return when run cmd: {e}")
        return False
    
async def simulation(selection, corner='', b=True):
    if b:
        if corner:
            run_ngspice_result = await run_ngspice(f"{corner}/AMP_{selection}.cir")
        else:
            run_ngspice_result = await run_ngspice(f"AMP_{selection}.cir")
    else:
        if corner:
            run_ngspice_result = await run_ngspice(f"{corner}/AMP_{selection}.cir", b=False)
        else:
            run_ngspice_result = await run_ngspice(f"AMP_{selection}.cir", b=False)
    if run_ngspice_result:
        if corner:
            AMP_result = await read_result_file(f"{corner}_{selection}.txt")
            print(f"corner: {corner}")
            print(f"selection: {selection}")
        else:
            AMP_result = await read_result_file(f"{selection}.txt")
            print(f"selection: {selection}")
        print(AMP_result)
    else:
        print("Simulation failed.")
            
def result2num(sim_result):
    import re
    # match float or int by regex
    pattern = r"[-+]?\d*\.\d+|[-+]?\d+"

    # create a dictionary to store the results
    result = {}

    # for each line in the text
    for line in sim_result.splitlines():
        try:
            key, value = line.split(':', 1)
        except Exception as sp:
            key = line.split(':', 1)[0]
            value = "0"
        key = key.strip()  # remove spaces
        match = re.search(pattern, value)  # find number
        
        if match:
            result[key] = match.group()  # get and add number to dictionary
        else:
            if key.startswith("XM"):  # if the key starts with "XM", store the value in the dictionary
                result[key] = value.lstrip()
            else:
                result[key] = 0  # if there is no number, use an empty string

    # return result
    return result
            
from operator import gt, lt, ge, le, eq
            
async def comparison_sim_result_info():
    if config.ISCUSTOM:
        if config.CUSTOMINDEX == 'Gain':
            sim_result_AC = await read_result_file(f"TT_AC.txt")
            result_AC = result2num(sim_result_AC)
            if float(config.PFINDEX['Gain']['value']) * 0.9 <= float(result_AC['Gain']) <= float(config.PFINDEX['Gain']['value']) * 1.1:
                return True
            else:
                return False
        elif config.CUSTOMINDEX == 'GBW':
            sim_result_AC = await read_result_file(f"TT_AC.txt")
            result_AC = result2num(sim_result_AC)
            if float(config.PFINDEX['GBW']['value']) * 0.9 <= float(result_AC['GBW']) <= float(config.PFINDEX['GBW']['value']) * 1.1:
                return True
            else:
                return False
        elif config.CUSTOMINDEX == 'PM':
            sim_result_AC = await read_result_file(f"TT_AC.txt")
            result_AC = result2num(sim_result_AC)
            if float(config.PFINDEX['PM']['value']) * 0.9 <= float(result_AC['PM']) <= float(config.PFINDEX['PM']['value']) * 1.1:
                return True
            else:
                return False
        elif config.CUSTOMINDEX == 'SR':
            sim_result_SR = await read_result_file(f"TT_SR.txt")
            result_SR = result2num(sim_result_SR)
            if float(config.PFINDEX['SR']['value']) * 0.9 <= float(result_SR['SR']) <= float(config.PFINDEX['SR']['value']) * 1.1:
                return True
            else:
                return False
        elif config.CUSTOMINDEX == 'IDC':
            sim_result_IDC = await read_result_file(f"TT_IDC.txt")
            result_IDC = result2num(sim_result_IDC)
            if float(config.PFINDEX['IDC']['value']) * 0.9 <= float(result_IDC['IDC']) <= float(config.PFINDEX['IDC']['value']) * 1.1:
                return True
            else:
                return False
    
    corners = ['FF', 'FS', 'SF', 'SS', 'TT']
    
    sim_result_tmp = {
        "Gain": 0,
        "GBW": 0,
        "PM": 0,
        "SR": 0,
        "IDC": 0
    }
    
    for corner in corners:
        sim_result_AC = await read_result_file(f"{corner}_AC.txt")
        result_AC = result2num(sim_result_AC)
        sim_result_SR = await read_result_file(f"{corner}_SR.txt")
        result_SR = result2num(sim_result_SR)
        sim_result_IDC = await read_result_file(f"{corner}_IDC.txt")
        result_IDC = result2num(sim_result_IDC)
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
            if sim_result_tmp['IDC'] > result_IDC['IDC']:
                sim_result_tmp['IDC'] = result_IDC['IDC']
        else:
            sim_result_tmp['IDC'] = result_IDC['IDC']

    sim_result = sim_result_tmp
    
    COMPARE_OPS = {
        "greater_than": gt,
        "less_than": lt,
        "greater_equal": ge,
        "less_equal": le,
        "equal": eq
    }
    
    if (
            sim_result['Gain'] 
            and sim_result['GBW']
            and sim_result['PM']
            and sim_result['SR']
            and sim_result['IDC'] 
        ):
        for param, configs in config.PFINDEX.items():
            
            current_val = sim_result.get(param)
            if current_val is None:
                raise ValueError(f"no param {param} ")
            
            try:
                target_val = float(configs["value"])  
                current_val = float(current_val)
            except ValueError:
                raise TypeError(f"param {param} can not convert to float")
            
            op_name = configs["requirement"]
            compare_op = COMPARE_OPS.get(op_name)
            if not compare_op:
                raise ValueError(f"err: {op_name} (param {param})")
            
            if not compare_op(current_val, target_val):
                return False
        return True
    else:
        return False
    
def delete_history_files():
    import re
    # defind the directory to delete the files
    netlist_path = '../netlist'
    result_path = '../result'

    # delete all files in the netlist directory whose name starts with AMP_ and ends with .cir
    for file in os.listdir(netlist_path):
        if re.match(r'^AMP_\d+\.cir$', file):  # match the file name by regular expression
            file_path = os.path.join(netlist_path, file)
            if os.path.isfile(file_path):
                os.remove(file_path)

    # delete all files in result directory
    for file in os.listdir(result_path):
        file_path = os.path.join(result_path, file)
        if os.path.isfile(file_path):
            os.remove(file_path)
            
            
def ext_pipe(component_name):
    """
    extract component lines from netlist file
    :param component_names: list of component names(for example ["XM1", "C1"])
    :return: all component lines
    """
    filename = "../netlist/AMP.cir"
    patterns = [re.compile(rf'^\s*{component_name}\b', re.IGNORECASE)]
    matched_lines = []

    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()  # remove spaces
            if not line or line.startswith('*') or line.startswith('.'):
                continue  # skip comments and empty lines
            for pattern in patterns:
                if pattern.search(line):
                    matched_lines.append({component_name: line})
                    break
    return matched_lines

def replace_netlist_lines(
    component_name: str, 
    new_content: str,
) -> None:
    """
    replace netlist lines in netlist file
    :param component_names: component name wait for replacement
    :param new_content: new line
    """
    filename = '../netlist/AMP.cir'
    # read netlist file
    with open(filename, 'r+') as f:
        lines = f.readlines()
        f.seek(0)  # reset file pointer to the beginning
        f.truncate()  # clear the file

        # ergodic netlist file and replace
        for line in lines:
            matched = False
            # use re to match component name
            if re.match(rf"^\s*{component_name}\b", line, re.IGNORECASE):
                f.write(new_content + '\n')
                matched = True
            if not matched:
                f.write(line)  # hold the original line which is not matched