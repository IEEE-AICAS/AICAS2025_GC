from typing import Dict, Optional, List
import os
from .base_agent import BaseAgent
from utils.spice_simulator import SpiceSimulator
from utils.llm_generator import LLMGenerator

class SimulationAgent(BaseAgent):
    """负责仿真电路的Agent"""
    
    def __init__(self, llm: LLMGenerator):
        super().__init__(llm=llm, agent_name="simulator")
        self.simulator = SpiceSimulator()
        self.last_error = None
        self.last_results = None
        self.test_dir = "test"  # 仿真文件目录
        
        # 确保测试目录存在
        os.makedirs(self.test_dir, exist_ok=True)
    
    def process(self) -> Dict[str, Optional[str]]:
        """
        仿真电路并收集结果
        Returns:
            Dict[str, Optional[str]]: 仿真结果（带单位）
        """
        # 初始化结果字典
        results = {
            "Gain": None,
            "GBW": None,
            "PM": None,
            "SR": None,
            "IDC": None
        }
        
        try:
            # AC分析
            ac_output = self.simulator.run_simulation(os.path.join(self.test_dir, "AMP_AC.cir"))
            if "error:" in ac_output.lower() or "timeout" in ac_output.lower():
                error_msg = ac_output
                results.update({
                    "Gain": error_msg,
                    "GBW": error_msg,
                    "PM": error_msg
                })
            else:
                ac_results = self.simulator.parse_ac_results(ac_output)
                results.update({
                    "Gain": f"{ac_results['Gain']} dB",  # Gain单位为dB
                    "GBW": f"{ac_results['GBW'] / 1e6:.2f} MHz",  # GBW单位为MHz
                    "PM": f"{ac_results['PM']:.2f}°"  # PM单位为°
                })
            
            # SR分析
            sr_output = self.simulator.run_simulation(os.path.join(self.test_dir, "AMP_SR.cir"))
            if "error:" in sr_output.lower() or "timeout" in sr_output.lower():
                results["SR"] = sr_output
            else:
                sr_value = self.simulator.parse_sr_results(sr_output)
                results["SR"] = f"{sr_value / 1e6:.2f} V/μS"  # SR单位为V/μS
            
            # 功耗分析
            idc_output = self.simulator.run_simulation(os.path.join(self.test_dir, "AMP_IDC.cir"))
            if "error:" in idc_output.lower() or "timeout" in idc_output.lower():
                results["IDC"] = idc_output
            else:
                idc_value = self.simulator.parse_idc_results(idc_output)
                results["IDC"] = f"{idc_value:.2f} μA"  # IDC单位为μA
            
            # 构建结果消息
            results_str = "Simulation Results:\n"
            for param, value in results.items():
                results_str += f"{param}: {value}\n"
            
            self.last_results = results
            self.last_error = None
            
            # 创建用户请求和助手响应消息
            user_message = {"role": "user", "content": "Run simulation and analyze results"}
            assistant_message = {"role": self.agent_name, "content": results_str}
            
            return results, [user_message, assistant_message]
            
        except Exception as e:
            self.last_error = str(e)
            error_msg = f"Simulation Failed: {self.last_error}"
            self.logger.error(error_msg)
            
            # 将所有结果设置为错误信息
            for key in results:
                results[key] = error_msg
            
            return results, [{"role": self.agent_name, "content": error_msg}]