from typing import Optional, List, Dict
import re
import os
import math
from .base_agent import BaseAgent
from utils.llm_generator import LLMGenerator
from datetime import datetime

class DesignAgent(BaseAgent):
    """负责设计电路网表的Agent"""
    
    def __init__(self, llm: LLMGenerator, run_id: str = None):
        """
        初始化设计Agent
        Args:
            llm: LLM生成器实例
            run_id: 运行ID，用于保存历史文件
        """
        super().__init__(llm=llm, agent_name="designer")
        
        # 保存运行ID
        self.run_id = run_id
        
        # 添加仿真文件目录
        self.test_dir = "test"  # 仿真文件目录
        os.makedirs(self.test_dir, exist_ok=True)
        
        # 读取各种prompt模板
        prompt_dir = os.path.join(os.path.dirname(__file__), "..", "prompt")
        
        with open(os.path.join(prompt_dir, "designer_system.txt"), "r", encoding="utf-8") as f:
            self.system_prompt = f.read().strip()
        
        with open(os.path.join(prompt_dir, "designer_initial.txt"), "r", encoding="utf-8") as f:
            self.design_template = f.read().strip()
        
        with open(os.path.join(prompt_dir, "designer_iteration.txt"), "r", encoding="utf-8") as f:
            self.iteration_prompt = f.read().strip()
    
    def _save_netlist(self, netlist: str, output_path: str = None, iteration: int = None):
        """
        保存网表到文件
        Args:
            netlist: 网表内容
            output_path: 可选的输出路径，默认为test/AMP.cir
            iteration: 迭代次数，用于保存历史版本
        """
        # 保存当前使用的网表
        if output_path is None:
            output_path = os.path.join(self.test_dir, "AMP.cir")
            
        # 确保输出目录存在
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        
        # 写入当前网表文件
        with open(output_path, "w") as f:
            f.write(netlist)
        
        # 如果指定了迭代次数和运行ID，保存到对应的历史目录
        if iteration is not None and self.run_id is not None:
            # 构建本次运行的历史目录路径
            run_history_dir = os.path.join("history", f"run_{self.run_id}")
            os.makedirs(run_history_dir, exist_ok=True)
            
            # 保存到运行历史目录
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            history_path = os.path.join(run_history_dir, f"AMP_iteration_{iteration}_{timestamp}.cir")
            with open(history_path, "w") as f:
                f.write(netlist)

    def _validate_mosfet_parameters(self, netlist: str) -> bool:
        """
        验证网表中MOSFET的L和W参数是否在有效范围内
        Args:
            netlist: 网表内容
        Returns:
            bool: 所有参数都在有效范围内返回True，否则返回False
        """
        # 正则表达式匹配MOSFET的L和W参数
        pattern = r"XM\d+\s+\S+\s+\S+\s+\S+\s+\S+\s+sky130_fd_pr__\w+\s+L=([\d.]+)\s+W=([\d.]+)"
        
        # 查找所有匹配的L和W值
        matches = re.findall(pattern, netlist)
        
        # 定义参数范围
        min_value = 0.2
        max_value = 100
        
        # 检查每个L和W是否在范围内
        for idx, (L, W) in enumerate(matches, start=1):
            L = float(L)
            W = float(W)
            self.logger.info(f"Transistor XM{idx}: L={L}, W={W}")
            
            if min_value <= L <= max_value and min_value <= W <= max_value:
                self.logger.info(f"  L and W are within the valid range [{min_value}, {max_value}].")
            else:
                self.logger.error(f"  ERROR: L or W is out of the valid range [{min_value}, {max_value}]!")
                return False
        
        return True

    def fix_units_and_w(self, netlist: str) -> str:
        """
        自动填补网表中缺失的单位（电流和电容），并调整 W 参数的范围。
        - 电流单位：uA（微安）
        - 电容单位：pF（皮法）
        - W 范围：0.2 到 100，如果 W 超过 100，则 W = W / 10，m = m * 10
        """
        # 正则表达式匹配电流和电容的值（可能缺少单位）
        current_pattern = r"(I\d+\s+\S+\s+\S+\s+)(\d+(?:\.\d+)?)(u?A?)"
        capacitor_pattern = r"(Cc\s+\S+\s+\S+\s+)(\d+(?:\.\d+)?)(p?F?)"

        # 正则表达式匹配 MOSFET 的 W 和 m 参数
        mosfet_pattern = r"(XM\d+\s+\S+\s+\S+\s+\S+\s+\S+\s+sky130_fd_pr__\w+\s+L=[\d.]+\s+W=)([\d.]+)(\s+m=)([\d.]+)"

        # 填补电流单位
        def fix_current(match):
            prefix = match.group(1)  # 匹配 I0 net3 VSS
            value = match.group(2)   # 匹配电流值（如 25）
            unit = match.group(3)    # 匹配单位（如 uA、u、A）
            if not unit:
                return f"{prefix}{value}uA"  # 如果单位缺失，补充 uA
            elif unit == "u":
                return f"{prefix}{value}uA"  # 如果单位是 u，补充 uA
            elif unit == "A":
                return f"{prefix}{value}uA"  # 如果单位是 A，补充 uA
            else:
                return match.group(0)  # 如果单位完整，保持不变

        # 填补电容单位
        def fix_capacitor(match):
            prefix = match.group(1)  # 匹配 Cc net2 Vout
            value = match.group(2)   # 匹配电容值（如 1）
            unit = match.group(3)    # 匹配单位（如 pF、p、F）
            if not unit:
                return f"{prefix}{value}pF"  # 如果单位缺失，补充 pF
            elif unit == "p":
                return f"{prefix}{value}pF"  # 如果单位是 p，补充 pF
            elif unit == "F":
                return f"{prefix}{value}pF"  # 如果单位是 F，补充 pF
            else:
                return match.group(0)  # 如果单位完整，保持不变

        # 调整 W 参数的范围
        def fix_w(match):
            prefix = match.group(1)  # 匹配 XM1 net1 Vinn net3 VSS sky130_fd_pr__nfet_01v8 L=
            l_value = float(match.group(2))  # 匹配 L 的值
            w_value = float(match.group(3))  # 匹配 W 的值
            m_prefix = match.group(4)  # 匹配 m=
            m_value = float(match.group(5))  # 匹配 m 的值

            # 计算新的 W 值：W = L * W
            new_w_value = l_value * w_value

            # 如果 W > 5 且 W ≠ 10，将 W 缩放到 5，并调整 m
            if new_w_value > 5 and new_w_value != 10:
                scale_factor = new_w_value / 5
                scale_factor = math.ceil(scale_factor)  # 将 scale_factor 向上取整
                new_w_value /= scale_factor
                new_w_value = round(new_w_value, 1)  # 将 new_w_value 四舍五入到一位小数
                m_value *= scale_factor
                m_value = math.ceil(m_value)  # 将 m 近似取整

            return f"{prefix}{l_value} W={new_w_value}{m_prefix}{int(m_value)}"

        # 使用正则表达式替换网表中的电流和电容值
        netlist = re.sub(current_pattern, fix_current, netlist)
        netlist = re.sub(capacitor_pattern, fix_capacitor, netlist)

        # 使用正则表达式替换网表中的 W 和 m 值
        netlist = re.sub(mosfet_pattern, fix_w, netlist)

        return netlist

    def process(self, conversation_history: List[Dict[str, str]] = None, iteration: int = None) -> list:
        """
        生成或优化网表
        Args:
            conversation_history: 完整的对话历史
            iteration: 当前迭代次数
        Returns:
            Tuple[str, List[Dict]]: (生成的网表, 对话消息)
        """
        max_attempts = 3  # 最大尝试次数
        
        for attempt in range(max_attempts):
            self.logger.info(f"正在进行第{attempt + 1}次网表生成尝试...")
            
            # 构建基础消息列表
            # messages = [{"role": "system", "content": self.system_prompt}]
            messages = []
            
            user_prompt = self.design_template
            
            # 创建用户请求消息
            user_message = {"role": "user", "content": user_prompt}
            messages.append(user_message)
            
            # 生成网表
            response = self.llm.generate(messages)
            
            # 创建助手响应消息
            assistant_message = {"role": self.agent_name, "content": response}
            
            # 提取网表
            netlist = self.extract_netlist(response)
            if netlist is None:
                self.logger.error("生成的响应中未找到有效的网表")
                if attempt == max_attempts - 1:
                    raise ValueError("Failed to extract netlist from response")
                continue
            
            # 修复网表中的单位和W参数
            self.logger.info("正在修复网表中的单位和W参数...")
            netlist = self.fix_units_and_w(netlist)
            self.logger.info(f"修复后的网表为:{netlist}")
            
            # 验证MOSFET参数
            self.logger.info("正在验证MOSFET参数...")
            if self._validate_mosfet_parameters(netlist):
                self.logger.info("MOSFET参数验证通过")
                # 参数验证通过，保存网表并返回结果
                self._save_netlist(netlist=netlist, output_path=None, iteration=iteration)
                return netlist, [user_message, assistant_message]
            
            if attempt == max_attempts - 1:
                self.logger.error("达到最大尝试次数，MOSFET参数仍然无效")
                return netlist, [user_message, assistant_message]
            
            # 如果参数验证失败且还有尝试机会，继续下一次尝试
            self.logger.warning(f"MOSFET参数验证失败，将进行第{attempt + 2}次尝试")
    
    def extract_netlist(self, content: str) -> Optional[str]:
        """
        从大语言模型生成的内容中提取出网表代码。
        支持多种格式：
        1. <netlist>...</netlist>标签中的内容
        2. ```spice...```代码块中的内容
        3. 以*或.开头的连续SPICE代码行
        
        Args:
            content: LLM生成的完整响应内容
        Returns:
            str: 提取的网表代码，如果未找到则返回None
        """
        # 1. 首先尝试提取<netlist>标签中的内容
        netlist_pattern = re.compile(r"<netlist>\s*(.*?)\s*</netlist>", re.DOTALL)
        match = netlist_pattern.search(content)
        if match:
            return match.group(1).strip()
        
        # 2. 尝试提取```spice...```代码块
        spice_block_pattern = re.compile(r"```(?:[a-zA-Z]+)?\s*([\s\S]*?)\s*```")
        match = spice_block_pattern.search(content)
        if match:
            return match.group(1).strip()
        
        # 3. 尝试提取以*或.开头的连续SPICE代码行
        lines = content.split('\n')
        netlist_lines = []
        in_netlist = False
        
        for line in lines:
            line = line.strip()
            # 跳过空行
            if not line:
                continue
            
            # 检测网表开始（以*或.开头的行）
            if line.startswith(('*', '.')) or line.startswith('X') or 'sky130' in line:
                # 如果是新的网表开始，清除之前收集的内容
                if line.startswith('*') and 'Two-stage' in line and netlist_lines:
                    netlist_lines = []
                in_netlist = True
                netlist_lines.append(line)
            # 如果已经在网表中，继续收集后续行
            elif in_netlist and (line.startswith('+') or line.startswith('I') or line.startswith('C')):
                netlist_lines.append(line)
            # 如果遇到非网表行且已经收集了一些网表行，则结束收集
            elif in_netlist and netlist_lines and not any(line.lower().startswith(x) for x in ('netlist', 'spice', 'circuit')):
                break
        
        # 如果找到了网表行，返回它们
        if netlist_lines:
            return '\n'.join(netlist_lines)
        
        # 如果都没找到，返回None
        self.logger.warning("未能从内容中提取到网表代码")
        return None 