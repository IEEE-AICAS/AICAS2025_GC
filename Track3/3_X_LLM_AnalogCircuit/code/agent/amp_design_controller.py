from typing import Optional, Dict, Union
import os
import json
from datetime import datetime
from .design_agent import DesignAgent
from .simulation_agent import SimulationAgent
from .analysis_agent import AnalysisAgent
from utils.logger_manager import LoggerManager
from utils.llm_generator import LLMGenerator

class AmpDesignController:
    """运放设计流程的主控制器"""
    
    def __init__(self, model_name: str = "deepseek-coder", **kwargs):
        self.logger = LoggerManager.get_logger("AmpDesignController")
        
        # 创建本次运行的唯一标识，格式：年月日_时分秒
        current_time = datetime.now()
        self.run_id = current_time.strftime('%Y-%m-%d_%H-%M-%S')  # 使用连字符分隔，更易读
        
        # 创建本次运行的历史记录目录
        self.history_dir = os.path.join("history", f"run_{self.run_id}")
        os.makedirs(self.history_dir, exist_ok=True)
        
        # 记录运行开始时间
        self.logger.info(f"=== 开始新的运行 {self.run_id} ===")
        
        # 创建共享的LLM实例
        self.llm = LLMGenerator(model_name=model_name, **kwargs)
        
        # 创建各个Agent，共享LLM实例和run_id
        self.designer = DesignAgent(llm=self.llm, run_id=self.run_id)
        self.simulator = SimulationAgent(llm=self.llm)
        self.analyzer = AnalysisAgent(llm=self.llm)
        
        # 存储完整的对话历史
        self.conversation_history = []
    
    def optimize_design(self, max_iterations: int = 5) -> str:
        """优化运放设计的主循环"""
        self.logger.info(f"开始电路优化设计，最大迭代次数: {max_iterations}")
        
        for i in range(max_iterations):
            self.logger.info(f"\n{'='*20} 第{i+1}次设计迭代 {'='*20}")
            
            # 1. 生成网表
            netlist, messages = self.designer.process(
                conversation_history=self.conversation_history,
                iteration=i+1
            )
            self.conversation_history.extend(messages)
            
            # 2. 仿真验证
            results, sim_message = self.simulator.process()
            self.logger.info(f"Simulator仿真结果:\n{results}")
            self.conversation_history.extend(sim_message)
            
            # 3. 分析结果
            # analysis_message = self.analyzer.process(conversation_history=self.conversation_history, netlist=netlist, results=results)
            # self.conversation_history.extend(analysis_message)
            
            # 保存当前迭代的历史记录
            self._save_conversation_history(i + 1)
        
        # 保存最终的历史记录
        self._save_conversation_history("final")

        return netlist, results, self.conversation_history
        
    def _save_conversation_history(self, iteration: Union[int, str]):
        """
        保存对话历史到文件
        Args:
            iteration: 迭代次数或特殊标记（如'final'）
        """
        # 构建文件名
        filename = f"conversation_history_iteration_{iteration}.json"
        filepath = os.path.join(self.history_dir, filename)
        
        # 准备历史数据
        history_data = {
            "run_id": self.run_id,
            "timestamp": datetime.now().strftime('%Y%m%d_%H%M%S'),
            "iteration": iteration,
            "history": self.conversation_history
        }
        
        # 保存到文件
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(history_data, f, ensure_ascii=False, indent=2)
        
        self.logger.info(f"对话历史已保存到: {filepath}")
