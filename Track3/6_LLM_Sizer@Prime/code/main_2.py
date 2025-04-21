import os
import subprocess
import re
import ollama
def run_simulation(file_path,index):
    """
    Call ngspice and save the results
    """
    simulation_cases = [
        "AMP_AC.cir",
        "AMP_IDC.cir",
        "AMP_SR.cir"
    ]
    
    results = {}  
    circuit_file = simulation_cases[index]
    circuit_path = os.path.join(file_path, circuit_file)

    try:
        subprocess.run(["./ngspice-43/src/ngspice", "-b", circuit_path], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Running {circuit_file} failed: {e}")
        results[circuit_file] = None  

    return results

def call_model(model_name, message,file_path):
    response = ollama.chat(
        model=model_name,
        options = {"temperature" : 0,"num_predict" : 50,"top_p":0.95 },
        messages=message,
        stream=False
        )
    print(f"{response["message"]["content"]}\n")
    with open(file_path, "w") as f:
        f.write(response["message"]["content"])


def extract_size(text):
    pattern = r"([\w_]+)\s*=\s*([\d.]+)"
    matches = re.findall(pattern, text)
    results = {name: float(value) if '.' in value else int(value) for name, value in matches}
    return results

def add_params_to_amp_cir(params, ini_file_path ,file_path="./AMP.cir"):

    param_lines = [f".param {key}={value}" for key, value in params.items()]
    param_block = "\n".join(param_lines) + "\n\n"
    subckt_line = ".subckt AMP Vinn Vinp VDD VSS Vout\n"

    with open(ini_file_path, "r") as file:
        original_content = file.read()

    with open(file_path, "w") as file:
        file.write(subckt_line + param_block + original_content)

models = ["qwen2.5:0.5b", "qwen2.5:1.5b"]

def generate_netlist(ini_file_path):
    
    with open("./prompt/generate_size.txt", "r") as f:
        prompt1 = f.read()
    with open("./prompt/get_mults.txt", "r") as f:
        prompt2 = f.read()

    message1=[
            {'role': 'system', 'content': 'You are an expert in circuit design.'},
            {'role': 'user', 'content': prompt1}
        ]
    message2=[
            {'role': 'system', 'content': 'You are an expert in circuit design.'},
            {'role': 'user', 'content': prompt2}
        ]

    call_model(models[0],message1,'./size1.txt')
    call_model(models[1],message2,'./size2.txt')
    call_model(models[0],message1,'./size1.txt')
    call_model(models[1],message2,'./size2.txt')
    print("Initial sizes generated successfully.")
    with open('size1.txt', 'r') as f:
        size1 = f.read()
    with open('size2.txt', 'r') as f:
        size2 = f.read()
    size1 = extract_size(size1)
    size2 = extract_size(size2)
    size = {**size1, **size2}
    print(size)
    add_params_to_amp_cir(size,ini_file_path)

def extract_values_from_file(file_path):
    """
    Extract values from results file
    """
    extracted_data = {}

    f_path = os.path.join(file_path, "AC_results.txt")
    try:
        with open(f_path, 'r') as file:
            pattern = r'(\w+)\s*:\s*([-+]?\d*\.\d+([eE][-+]?\d+)?|\d+([eE][-+]?\d+)?)'
            file_content = file.read()
            matches = re.findall(pattern, file_content)
            for match in matches:
                extracted_data[match[0]] = float(match[1])
    except FileNotFoundError:
        print(f"File AC_results.txt not found")

    f_path = os.path.join(file_path, "SR.txt")
    try:
        with open(f_path, 'r') as file:
            pattern = r'(\w+)\s*=\s*([-+]?\d*\.\d+([eE][-+]?\d+)?|\d+([eE][-+]?\d+)?)'
            file_content = file.read()
            matches = re.findall(pattern, file_content)
            for match in matches:
                extracted_data[match[0]] = float(match[1])
    except FileNotFoundError:
        print(f"File SR.txt not found")

    f_path = os.path.join(file_path, "Idc.txt")
    try:
        with open(f_path, 'r') as file:
            pattern = r'i\(vmeas\)\s*=\s*([-+]?\d*\.\d+([e][-+]?\d+)?|\d+([e][-+]?\d+)?)'
            file_content = file.read()
            matches = re.findall(pattern, file_content)
            for match in matches:
                extracted_data['idc'] = float(match[0])
    except FileNotFoundError:
        print(f"File Idc.txt not found")
    
    return extracted_data

def get_goal():
    """
    Get the goal from the file
    """
    f_path = "goal.txt"
    label = "none"
    value = 0.0
    try:
        with open(f_path, 'r') as file:
            for line in file:
                if line.startswith('#'):
                    continue
                goal_line = line.strip()
                label, value = goal_line.split(':')
                print(label, value)
                value = float(value)
                return label, value

    except FileNotFoundError:
        print(f"File goal.txt not found")
    
    return label, value

def call_model_2(model_name, message):
    response = ollama.chat(
        model=model_name,
        options = {"temperature" : 0,"num_predict" : 50,"top_p":0.95 },
        messages=message,
        stream=False
    )
    print(f"{response["message"]["content"]}\n")
    return response["message"]["content"]

def modify_line_in_file(file_path, line_start, new_content):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    for i, line in enumerate(lines):
        if line.startswith(line_start):
            lines[i] = f"{line_start} {new_content}\n"
            break

    with open(file_path, 'w') as file:
        file.writelines(lines)

run_simulation("./",0)
run_simulation("./",1)
run_simulation("./",2)
extracted_data = extract_values_from_file("./")
label = "none"
value = 0.0
label, value = get_goal()
print(label, value)


if label == "Gain":
    if value <= 64:
        print("Gain already satisfied, yet a redesign will be given")
        generate_netlist("./amp_ini/AMP_gain0.txt")
    elif 64 <= value <= 70:
        print("Gain already satisfied, yet a redesign will be given")
        generate_netlist("./amp_ini/AMP_gain1.txt")
    elif 70 <= value <= 78:
        generate_netlist("./amp_ini/AMP_gain2.txt")
    elif 78 < value <= 92:
        generate_netlist("./amp_ini/AMP_gain3.txt")
    elif value > 92:
        print("Gain might be too high for this topology, yet a redesign will be given")
        generate_netlist("./amp_ini/AMP_gain3.txt")
if label == 'GBW':
    if value <= 20e6:
        print("GBW already satisfied, yet a redesign will be given")
        generate_netlist("./amp_ini/AMP_GBW.txt")
    elif 20e6 < value <= 89e6:
        #generate initial netlist
        generate_netlist("./amp_ini/AMP_GBW.txt")
        #get adjustment according to the goal
        #set design space of multipliers
        m_min = 1
        m_max = 100 #upper limit of mult, the value is calculated before in the AMP, so it is known and directly used here
        m_current = 0
        lower_bound = value*0.9
        upper_bound = value*1.1
        for i in range(100):
            run_simulation("./",0)
            current_values = extract_values_from_file("./")
            if(current_values['GBW'] > lower_bound and current_values['GBW'] < upper_bound):
                break
            if current_values['GBW'] < lower_bound:
                m_max = m_current
            if current_values['GBW'] > upper_bound:
                m_min = m_current
            message=[
                {'role': 'system', 'content': 'You are an expert in circuit design.'},
                {'role': 'user', 'content': f"Please return a integer value between {m_min} and {m_max}, please only return the integer and do not include any other text"} 
            ]
            response = ollama.chat(
                model=models[1],
                options = {"temperature" : 0,"num_predict" : 50,"top_p":0.95 },
                messages=message,
                stream=False
            )
            str_response = response["message"]["content"]
            m_current = int(str_response)

            ##check if the value is within the bounds
            if m_current < m_min or m_current > m_max:
                m_current = m_min+(m_max-m_min)//2
            with open('AMP.cir', 'r') as f:
                lines = f.readlines()
            for i,line in enumerate(lines):
                if line.startswith('.param c_mult='):
                    lines[i] = f".param c_mult={m_current}\n"
                    break
            with open('AMP.cir', 'w') as f:
                f.writelines(lines)

    #the following cases are the maximum GBW that can be achieved with the current topology
    elif 89e6 < value <= 108e6:
        generate_netlist("./amp_ini/AMP_GBW_max.cir")
    elif value > 108e6:
        print("GBW might be too high for this topology, yet a design will be given")
        generate_netlist("./amp_ini/AMP_GBW_max.cir")
if label == 'IDC':
    #generate initial netlist
    generate_netlist("./amp_ini/AMP_IDC.txt")
    #get adjustment according to the goal
    prompt = f"We need the second stage to have a current of {value-10}uA. Please return the information in the format below: I_stage2 = ? u"
    message=[
            {'role': 'system', 'content': 'You are an expert in circuit design.'},
            {'role': 'user', 'content': prompt}
        ]
    response = ollama.chat(
        model=models[1],
        options = {"temperature" : 0,"num_predict" : 50,"top_p":0.95 },
        messages=message,
        stream=False
    )
    str_response = response["message"]["content"]
    response_no_spaces = str_response.replace(" ", "")
    with open('AMP.cir', 'r') as f:
        lines = f.readlines()
    for i,line in enumerate(lines):
        if line.startswith('*insert change here'):
            lines[i] = f".param {response_no_spaces}\n"
            break
    with open('AMP.cir', 'w') as f:
        f.writelines(lines)
if label == 'SR':
    if value <= 20e6:
        print("SR already satisfied, yet a redesign will be given")
        generate_netlist("./amp_ini/AMP_SR.txt")
    elif value > 408e6:
        print("SR might be too high for this topology, yet a redesign will be given")
        generate_netlist("./amp_ini/AMP_GBW_max.txt")
    else:
        generate_netlist("./amp_ini/AMP_SR.txt")
        run_simulation("./",2)
        current_values = extract_values_from_file("./")
        m_min = 1
        m_max = 130
        m_current = 0
        lower_bound = value*0.9
        upper_bound = value*1.1
        for i in range(100):
            run_simulation("./",2)
            current_values = extract_values_from_file("./")
            if(current_values['sr'] > lower_bound and current_values['sr'] < upper_bound):
                break
            if current_values['sr'] < lower_bound:
                m_max = m_current
            if current_values['sr'] > upper_bound:
                m_min = m_current
            message=[
                {'role': 'system', 'content': 'You are an expert in circuit design.'},
                {'role': 'user', 'content': f"Please return a integer value between {m_min} and {m_max}, please only return the integer and do not include any other text"} 
            ]
            response = ollama.chat(
                model=models[1],
                options = {"temperature" : 0,"num_predict" : 50,"top_p":0.95 },
                messages=message,
                stream=False
            )
            str_response = response["message"]["content"]
            m_current = int(str_response)

            ##check if the value is within the bounds
            if m_current < m_min or m_current > m_max:
                m_current = m_min+(m_max-m_min)//2
            with open('AMP.cir', 'r') as f:
                lines = f.readlines()
            for i,line in enumerate(lines):
                if line.startswith('.param c_mult='):
                    lines[i] = f".param c_mult={m_current}\n"
                    break
            with open('AMP.cir', 'w') as f:
                f.writelines(lines)

print("Design complete")