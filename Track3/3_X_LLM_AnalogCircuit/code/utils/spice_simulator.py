import subprocess
import re
from typing import Dict, Optional
from utils.logger_manager import LoggerManager


class SpiceSimulator:
    def __init__(self, test_dir: str = "test"):
        self.test_dir = test_dir
        self.logger = LoggerManager.get_logger("SpiceSimulator")
        self.user_prompt = """Based on the simulation results from the previous iteration and the target specifications for the operational amplifier, please analyze the current design and provide optimization suggestions. Do not provide a complete netlist.

Required Analysis:
1. Circuit Topology Analysis:
   - Analyze the function of each stage
   - Identify critical parameters affecting performance
   - Explain current limitations in the design

2. Parameter-Performance Relationship:
   - Gain: Which parameters most strongly influence Gain?
   - GBW: How to optimize bandwidth without compromising stability?
   - Phase Margin: What parameters affect stability?
   - Slew Rate: How to improve SR while maintaining power budget?
   - Power Consumption: How to optimize current distribution?

3. Optimization Suggestions:
   - Specific recommendations for parameter adjustments
   - Trade-offs between different specifications
   - Priority of modifications based on simulation results

Important Notes:
1. All L and W values must be > 0.5 (without units)
2. Consider:
   - Transistor operating regions
   - Matching requirements
   - Current distribution
   - Temperature and process variations
3. Focus on explaining the reasoning behind each suggestion
4. Address any specific issues from previous simulation results

Please provide detailed analysis and recommendations for improving the design."""


    def parse_simulation_error(self, error_msg: str) -> Dict[str, Optional[float]]:
        """
        处理仿真错误情况
        Args:
            error_msg: 错误信息
        Returns:
            Dict[str, Optional[float]]: 包含所有指标的空结果字典
        """
        self.logger.error(f"仿真发生错误: {error_msg}")
        return {
            "Gain": None,
            "GBW": None,
            "PM": None,
            "SR": None,
            "IDC": None,
            "error": error_msg
        }

    def parse_ac_results(self, output: str) -> Dict[str, Optional[float]]:
        """
        解析AC分析结果
        Returns:
            Dict[str, Optional[float]]: 包含增益、带宽和相位裕度的字典，如果数据不存在则对应值为None
        """
        # 检查是否存在错误信息
        if "error:" in output.lower() or "timeout" in output.lower():
            return self.parse_simulation_error(output)

        results = {
            "Gain": None,
            "GBW": None,
            "PM": None
        }

        try:
            with open("AC_results.txt", "r") as f:
                content = f.read().strip()
                if not content:
                    self.logger.warning("AC结果文件为空")
                    return results

                # 将文件内容按行拆分
                lines = content.splitlines()
                for line in lines:
                    try:
                        if "Gain:" in line:
                            value = line.split(":")[1].strip()
                            results["Gain"] = float(value)
                        elif "GBW:" in line:
                            value = line.split(":")[1].strip()
                            results["GBW"] = float(value)
                        elif "PM:" in line:
                            value = line.split(":")[1].strip()
                            results["PM"] = float(value)
                    except (ValueError, IndexError) as e:
                        self.logger.warning(f"解析AC结果行失败: {line.strip()}, 错误: {str(e)}")
                        continue

        except FileNotFoundError:
            self.logger.error("AC结果文件不存在")
        except Exception as e:
            self.logger.error(f"解析AC结果时发生错误: {str(e)}")

        return results
                        

    def parse_sr_results(self, output: str) -> Optional[float]:
        """
        解析压摆率结果
        Returns:
            Optional[float]: 压摆率值，如果数据不存在则返回None
        """
        # 检查是否存在错误信息
        if "error:" in output.lower() or "timeout" in output.lower():
            return None

        try:
            with open("SR.txt", "r") as f:
                content = f.read().strip()
                if not content:
                    self.logger.warning("SR结果文件为空")
                    return None
                
                # 提取sr = xxx格式的数据
                match = re.search(r'sr\s*=\s*([-+]?\d*\.?\d+(?:[eE][-+]?\d+)?)', content)
                if match:
                    sr_value = float(match.group(1))
                    return sr_value
                else:
                    self.logger.warning(f"SR结果格式不正确: {content}")
                    return None
                    
        except FileNotFoundError:
            self.logger.error("SR结果文件不存在")
        except Exception as e:
            self.logger.error(f"解析SR结果时发生错误: {str(e)}")
        
        return None

    def parse_idc_results(self, output: str) -> Optional[float]:
        """
        解析功耗结果
        Returns:
            Optional[float]: 功耗值(μA)，如果数据不存在则返回None
        """
        # 检查是否存在错误信息
        if "error:" in output.lower() or "timeout" in output.lower():
            return None

        try:
            with open("Idc.txt", "r") as f:
                content = f.read().strip()
                if not content:
                    self.logger.warning("Idc结果文件为空")
                    return None
                
                # 提取i(vmeas) = xxx格式的数据
                match = re.search(r'i\([^)]+\)\s*=\s*([-+]?\d*\.?\d+(?:[eE][-+]?\d+)?)', content)
                if match:
                    idc_value = float(match.group(1))
                    return idc_value * 1e6  # 转换为μA
                else:
                    self.logger.warning(f"Idc结果格式不正确: {content}")
                    return None
                    
        except FileNotFoundError:
            self.logger.error("Idc结果文件不存在")
        except Exception as e:
            self.logger.error(f"解析Idc结果时发生错误: {str(e)}")
        
        return None


    def run_simulation(self, netlist_path: str) -> str:
        """
        运行SPICE仿真
        Args:
            netlist_path: 网表文件路径
        Returns:
            str: 仿真输出或错误信息
        """
        try:
            # 设置超时时间为60秒
            result = subprocess.run(
                ["ngspice", "-b", netlist_path],
                capture_output=True,
                text=True,
                timeout=60
            )
            
            # 检查是否执行成功
            if result.returncode != 0:
                error_msg = f"error: 仿真失败，返回码 {result.returncode}\n{result.stderr}"
                self.logger.error(error_msg)
                return error_msg
                
            return result.stdout

        except subprocess.TimeoutExpired:
            error_msg = "timeout: 仿真执行超时"
            self.logger.error(error_msg)
            return error_msg
            
        except Exception as e:
            error_msg = f"error: 仿真执行异常: {str(e)}"
            self.logger.error(error_msg)
            return error_msg
