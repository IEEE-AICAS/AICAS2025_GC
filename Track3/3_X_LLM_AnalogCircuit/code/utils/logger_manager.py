import logging
import os
from datetime import datetime
from typing import Optional

class LoggerManager:
    _instance: Optional['LoggerManager'] = None
    _logger: Optional[logging.Logger] = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(LoggerManager, cls).__new__(cls)
        return cls._instance
    
    def __init__(self):
        if LoggerManager._logger is None:
            self._setup_logger()
    
    def _setup_logger(self):
        """初始化全局logger配置"""
        # 创建logs目录
        log_dir = "logs"
        os.makedirs(log_dir, exist_ok=True)
        
        # 获取根logger
        root_logger = logging.getLogger()
        root_logger.setLevel(logging.INFO)
        
        # 清除所有已存在的handlers
        root_logger.handlers.clear()
        
        # 创建控制台handler
        console_handler = logging.StreamHandler()
        console_handler.setLevel(logging.INFO)
        console_formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )
        console_handler.setFormatter(console_formatter)
        
        # 创建文件handler
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        log_file = os.path.join(log_dir, f"amp_design_{timestamp}.log")
        file_handler = logging.FileHandler(log_file, encoding='utf-8')
        file_handler.setLevel(logging.INFO)
        file_formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )
        file_handler.setFormatter(file_formatter)
        
        # 添加handlers到根logger
        root_logger.addHandler(console_handler)
        root_logger.addHandler(file_handler)
        
        # 保存logger实例
        LoggerManager._logger = root_logger
        
        # 记录启动信息
        root_logger.info("=== Amplifier Design System Started ===")
        root_logger.info(f"Log file created at: {log_file}")
    
    @classmethod
    def get_logger(cls, name: str = None) -> logging.Logger:
        """
        获取logger实例
        Args:
            name: 模块名称，如果不指定则返回根logger
        Returns:
            logging.Logger: logger实例
        """
        if cls._instance is None:
            cls._instance = cls()
        
        if name:
            # 返回带有模块名的logger
            return logging.getLogger(name)
        return cls._logger 