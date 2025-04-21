import sys
from loguru import logger

class LogConfig:
    def __init__(self,level=None,rotation=None) -> None:
        self.level = level if level else "INFO"
        self.rotation = rotation if rotation else '5 MB'
        self.file_handler_id = logger.add('logs/file_{time}.log', 
                                         format="{time:YYYY-MM-DD HH:mm:ss.SSS} | {level:<8} | {name}:{function}:{line} - {message}", 
                                         level=self.level,
                                         rotation=self.rotation,
                                         encoding='utf-8')
    def remove_logger(self):
        logger.remove(self.file_handler_id)


log_config = LogConfig("TRACE")

if __name__ == "__main__":
    logger.info("test")