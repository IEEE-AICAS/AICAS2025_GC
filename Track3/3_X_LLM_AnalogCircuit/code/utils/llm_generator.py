from typing import Dict, List
import openai
from utils.logger_manager import LoggerManager

class LLMGenerator:
    """大语言模型生成器，仅支持API调用"""
    
    def __init__(self, model_name: str = "deepseek-coder", **kwargs):
        """
        初始化模型生成器
        Args:
            model_name: 模型名称
            **kwargs: 其他参数，如api_key、base_url、temperature等
        """
        self.logger = LoggerManager.get_logger("LLMGenerator")
        self.model_name = model_name
        self.temperature = kwargs.get("temperature", 0.7)
        
        # 初始化OpenAI客户端
        self.client = openai.OpenAI(
            api_key=kwargs.get("api_key"),
            base_url=kwargs.get("base_url", "https://api.deepseek.com")
        )

    def generate(self, messages: List[Dict[str, str]]) -> str:
        """
        使用API生成响应
        Args:
            messages: 消息列表
            temperature: 温度参数，控制生成的随机性
        Returns:
            str: 生成的响应文本
        """
        self.logger.info("开始生成响应...")
        self.logger.debug(f"输入消息: {messages}")
        
        try:
            response = self.client.chat.completions.create(
                model=self.model_name,
                messages=messages
            )
            
            result = response.choices[0].message.content
            self.logger.info("成功生成响应")
            self.logger.info(f"生成的响应: {result}")
            return result
            
        except Exception as e:
            self.logger.error(f"API调用失败: {str(e)}")
            raise 