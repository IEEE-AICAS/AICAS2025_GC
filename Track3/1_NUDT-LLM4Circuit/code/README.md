# LLM_for_circuit_design
## 项目代码
- 赛道3_NUDT-LLM4Circuit_复赛/
  - agent/
    - sim_result/                    #保存仿真产生的结果的文件
        - tt_AC_results.txt
        - tt_IDC_results.txt
        - tt_SR_results.txt
        - ...
    - sim_src/                       #仿真脚本
        - AMP_AC.cir
        - AMP_CMRR.cir
        - AMP_I0.cir                 #仿真电流的脚本
        - AMP_IDC.cir
        - AMP_noise.cir
        - AMP_PSRR.cir
        - AMP_SR.cir
        - AMP.cir                    #仿真的网表，优化完成后的最优网表。
    - main.py  #主函数
    - Agent_global_collaboration.py  #全局协同智能体
    - Agent_initial.py               #初始化智能体
    - Agent_optimization.py          #优化智能体
    - Agent_resizing.py              #尺寸参数调整智能体
    - Agent_simulation.py            #仿真智能体
    - config.py                      #全局参数配置文件
    - process_record.txt             #保存运行过程结果的文件
    - extracted_code1.py             #初始化第一阶段用大模型生成的计算初始化参数值的代码
    - extracted_code2.py             #初始化第二阶段用大模型生成的计算初始化参数值的代码
    - output1.md                     #初始化第一阶段用大模型生成的原始输出
    - output2.md                     #初始化第一阶段用大模型生成的原始输出
    - netlist_para.txt               #用于保存并读取初始化的参数的文件
  - data/
    - train_data.json
  - prompt/
    - initial_prompt1.txt
    - initial_prompt2.txt
    - opt_prompt.txt
  - README.md
  - monitor.py 
  ─ monitor_results.json                     

## Attention
opt_prompt.txt是在运行中生成的，每一次运行需要清空opt_prompt.txt，因为monitor.py在网表优化前进行了token计算，所以为了保证token计算正确需要在网表生成后再进行token计算。
文件extracted_code1.py，extracted_code2.py，output1.md，output2.md是在运行的过程中生成的。
第一阶段初始化时，initial_prompt1.txt的内容输入给大模型，产生的输出保存在output1.md，处理后生成extracted_code1.py，然后调用extracted_code1.py，生成第一阶段初始化的参数。
第二阶段初始化时，initial_prompt2.txt的内容输入给大模型，产生的输出保存在output2.md，处理后生成extracted_code2.py，然后调用extracted_code2.py，生成第二阶段初始化的参数。

## 验证说明
在验证环节，只需要在mian.py中修改verify_metric为需要验证的指标名，verify_value为需要验证的指标值。
其中verify_metric：输入'Gain', 'GBW', 'PM', 'SR', 'idc'其中的字符串即可，分别对应增益，增益带宽积，相位裕度，转换速率，功耗。
其中verify_value：
增益的单位为dB（例如初赛的60）
增益带宽积的单位为Hz（例如初赛的20）
相位裕度的单位为°（例如初赛的60）
转换速率单位V/μS（例如初赛的20）
功耗的单位为μA （例如初赛的500）

## 验证示例
修改main.py文件中的
verify_metric = 'GBW'
verify_value = 30
然后运行main.p即可，最终的网表保存在./sim_src/AMP.cir中。

