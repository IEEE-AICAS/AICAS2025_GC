import argparse

'''
全局参数
'''

def config_arg():
    parser = argparse.ArgumentParser(description="llm_4_ic_design")
    parser.add_argument("--opt_model_name", default="model_v1_5_0.5b_8bit", help='the name of optimize QWen model')
    parser.add_argument("--init_model_name", default="3b_coder", help='the name of initial QWen model')
    parser.add_argument("--extra_model_name", default="test_0.5b_8bit", help='the name of optimize QWen model')
    parser.add_argument("--lib_path", default="/mnt/c/llm/package/models/sky130.lib.spice", help='仿真lib库调用路径')
    parser.add_argument("--simulation_path", default="/mnt/c/llm/package/ngspice-43/release/src", help='仿真工具调用路径')
    parser.add_argument("--opt_prompt", default="/mnt/c/llm/LLM4AMP/prompt/opt_prompt.txt", help='优化过程使用的prompt保存路径')

    parser.add_argument("--net_list_path", default='/mnt/c/llm/LLM4AMP/agent/sim_src/AMP.cir',
                         help="进行仿真的网表路径")
    parser.add_argument("--AMP_CMRR_path", default='/mnt/c/llm/LLM4AMP/agent/sim_src/AMP_CMRR.cir',
                        help='仿真CMPR文件路径')
    parser.add_argument("--AMP_PSRR_path", default='/mnt/c/llm/LLM4AMP/agent/sim_src/AMP_PSRR.cir',
                        help='仿真CMPR文件路径')
    parser.add_argument("--AMP_noise_path", default='/mnt/c/llm/LLM4AMP/agent/sim_src/AMP_noise.cir',
                        help='仿真noise文件路径')
    parser.add_argument("--AMP_AC_path", default="/mnt/c/llm/LLM4AMP/agent/sim_src/AMP_AC.cir",
                        help='仿真AC文件路径')
    parser.add_argument("--AMP_SR_path", default="/mnt/c/llm/LLM4AMP/agent/sim_src/AMP_SR.cir",
                        help='仿真SR文件路径')
    parser.add_argument("--AMP_IDC_path", default="/mnt/c/llm/LLM4AMP/agent/sim_src/AMP_IDC.cir",
                        help='仿真IDC文件路径')
    parser.add_argument("--AMP_I0_path", default="/mnt/c/llm/LLM4AMP/agent/sim_src/AMP_I0.cir",
                        help='仿真IDC文件路径')

    parser.add_argument("--sim_result_path", default="/mnt/c/llm/LLM4AMP/agent/sim_result/",
                        help='仿真结果保存路径')
    parser.add_argument("--process_path", default="/mnt/c/llm/LLM4AMP/agent/process_record.txt")

    arg = parser.parse_args()

    return arg