
For COMPLETE VERSION PLEASE VIEW THE CODE ON THE SERVER

README file final edition 20250324
### the folder is located at /home/fusai
### the file "main.py" is located at /home/fusai/agent 
### before you run main.py, please activate ollama first 
    to activate ollama
    -enter /home/bin by "cd /home/bin"
    -run "./ollama serve"
    -then open a new session and keep the ollama page activate

*** Test 1.8.1
    with ollama activated
    run "monitor.py --mode final" at location /home/fusai
    before you do the verification, you can clear the text in AMP.cir
    the text in amp_ini.cir is the format to which LLM will add parameters, it will not be used in the prompts so it's not located there
    you can check amp_ini.cir,files in ./prompt and files in ./amp_ini to ensure no violation exists with illegal data

*** Test 1.8.1
    with ollama activated
    edit the file goal.txt in /home/fusai, the format is given, please do follow the format and only enter one restrction each time
    PLEASE notice the upper and lower marks
    PLEASE split label and value with ":" and no additional spaces is permitted
    i.e. "Gain:60"  
    i.e. "idc:100" will raise an error, please use "IDC:100"
    i.e. "GBW :100e6" will raise an error, please use "GBW:100e6"
    then you can run main_2.py under /home/fusai
    you can get the netlist in /home/fusai/AMP.cir
*** However the main_2.py has its limits, the metrics cannot be improved without limits
    the approximate bounds are as follow:
    Gain: 60-~90
    GBW: 20-~100
    IDC: 20-?
    SR: 20-~400

I've noticed that there has been some fluctuation in the outputs of ollama due to unknwon reasons, thus I've prepared a back up file
If there is any problem, feel free to contact me!

