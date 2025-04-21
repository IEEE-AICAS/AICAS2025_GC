from abc import ABC, abstractmethod
from typing import Dict, List, Optional
from utils.logger_manager import LoggerManager
from utils.llm_generator import LLMGenerator

class BaseAgent(ABC):
    """所有Agent的基类"""
    
    def __init__(self, llm: LLMGenerator, agent_name: str):
        """
        初始化Agent
        Args:
            llm: 共享的LLM生成器实例
            agent_name: agent的名称，用于对话历史
        """
        self.logger = LoggerManager.get_logger(self.__class__.__name__)
        self.llm = llm
        self.agent_name = agent_name
