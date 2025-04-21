from Agent_global_collaboration import Agent_global_collaboration
from config import config_arg
import time

if __name__ == '__main__':
    '''
    调用全局智能体，生成网表，如果是进行验证，则修改verify_metric为需要验证的指标名，verify_value为需要验证的指标值。
    '''
    args = config_arg()  # 全局参数
    verify_metric = None   #  Gain, GBW, PM, SR, idc
    verify_value =  None
    Agent_global_collaboration(args, verify_metric, verify_value)