from typing import Dict, Optional, List
from .base_agent import BaseAgent
from utils.llm_generator import LLMGenerator
import os

class AnalysisAgent(BaseAgent):
    """负责分析仿真结果并提供改进建议的Agent"""
    
    def __init__(self, llm: LLMGenerator):
        super().__init__(llm=llm, agent_name="analyzer")
        
        prompt_dir = os.path.join(os.path.dirname(__file__), "..", "prompt")
        
        # 读取system prompt
        with open(os.path.join(prompt_dir, "analysis_system.txt"), "r", encoding="utf-8") as f:
            self.system_prompt = f.read().strip()
            
        # 读取错误分析提示词
        with open(os.path.join(prompt_dir, "analysis_error.txt"), "r", encoding="utf-8") as f:
            self.error_prompt = f.read().strip()
        
        # 读取性能优化提示词
        with open(os.path.join(prompt_dir, "analysis_optimization.txt"), "r", encoding="utf-8") as f:
            self.optimization_prompt = f.read().strip()

    def _get_latest_simulation_result(self, conversation_history: List[Dict[str, str]]) -> Optional[Dict]:
        """
        获取最近一次的仿真结果
        Args:
            conversation_history: 对话历史
        Returns:
            Optional[Dict]: 最近的仿真结果消息，如果没有则返回None
        """
        if not conversation_history:
            return None
            
        # 从后向前查找simulator的消息
        for msg in reversed(conversation_history):
            if msg["role"] == "simulator":
                return msg
        return None

    def _has_simulation_error(self, results: str) -> bool:
        """
        检查仿真消息是否包含错误
        Args:
            results: 仿真结果消息
        Returns:
            bool: 是否包含错误
        """
        if not results:
            return False
            
        content = results.lower()
        # 检查是否包含错误关键词
        error_keywords = ["error", "failed", "timeout", "fatal", "invalid"]
        return any(keyword in content for keyword in error_keywords)

    def _filter_recent_messages(self, conversation_history: List[Dict[str, str]]) -> List[Dict[str, str]]:
        """
        筛选最近一次的设计和仿真对话
        Args:
            conversation_history: 完整的对话历史
        Returns:
            List[Dict[str, str]]: 筛选后的对话列表，保持原始顺序
        """
        if not conversation_history:
            return []
        
        # 从后向前查找最近的消息对
        message_pairs = []
        found_simulator = False
        found_designer = False
        
        # 从后向前遍历
        for i in range(len(conversation_history) - 1, -1, -1):
            msg = conversation_history[i]
            role = msg["role"]
            
            # 找到simulator消息
            if not found_simulator and role == "simulator":
                # 向前查找对应的user消息
                for j in range(i - 1, -1, -1):
                    if conversation_history[j]["role"] == "user":
                        # 保存user和simulator的消息对及其索引
                        message_pairs.append((j, conversation_history[j]))  # user消息
                        message_pairs.append((i, msg))  # simulator消息
                        found_simulator = True
                        break
            
            # 找到designer消息
            elif not found_designer and role == "designer":
                # 向前查找对应的user消息
                for j in range(i - 1, -1, -1):
                    if conversation_history[j]["role"] == "user":
                        # 保存user和designer的消息对及其索引
                        message_pairs.append((j, conversation_history[j]))  # user消息
                        message_pairs.append((i, msg))  # designer消息
                        found_designer = True
                        break
            
            # 如果都找到了就停止搜索
            if found_simulator and found_designer:
                break
        
        # 按原始索引排序
        message_pairs.sort(key=lambda x: x[0])
        
        # 只返回消息内容，去掉索引
        return [pair[1] for pair in message_pairs]

    def process(self, conversation_history: List[Dict[str, str]] = None, netlist: str = None, results: Dict[str, str] = None) -> List[Dict[str, str]]:
        """
        分析仿真结果并提供建议
        Args:
            conversation_history: 对话历史
            netlist: 电路网表字符串
            results: 仿真结果字典
        Returns:
            List[Dict[str, str]]: 新的消息列表
        """
        # 构建基础消息列表
        messages = [{"role": "system", "content": self.system_prompt}]
        
        # 判断是否有错误
        has_error = self._has_simulation_error(str(results))
        
        # 根据仿真状态选择合适的提示词
        if has_error:
            prompt = self.error_prompt.replace("<<netlist>>", netlist).replace("<<error_messages>>", str(results))
        else:
            # 使用函数入参中的netlist和results
            prompt = self.optimization_prompt.replace("<<netlist>>", netlist).replace("<<Gain>>", results["Gain"]).replace("<<GBW>>", results["GBW"]).replace("<<PM>>", results["PM"]).replace("<<SR>>", results["SR"]).replace("<<IDC>>", results["IDC"])
        
        # 创建用户请求消息
        user_message = {"role": "user", "content": prompt}
        messages.append(user_message)
        
        # 生成分析报告
        response = self.llm.generate(messages)
        
        # 创建助手响应消息
        assistant_message = {"role": self.agent_name, "content": response}
        
        return [user_message, assistant_message]