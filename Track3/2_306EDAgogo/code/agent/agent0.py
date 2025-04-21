# 导入必要的模块
import os
import json
from loguru import logger
from ollama import chat
from utils import read_human_prompt,read_sys_prompt
from config import *
if "analog" not in os.getcwd():
    os.chdir(os.getcwd()+"/analog")

class DesignAgent:
    def __init__(self,prompt:dict=None):
        self.messages = []
        if prompt is not None:
            self.messages.append(prompt)
    
    def get_response(self,messages):
        response = chat(
            model = "qwen2.5:7b",
            messages = messages,
            format = "json",
        )
        if response.message.content is None:
            response.message.content = ""
        return response.message

    def invoke(self,prompt:dict):
        current_messages = self.messages.copy()
        current_messages.append(prompt)

        assistant_message = self.get_response(current_messages)

        logger.trace(assistant_message.content)

        return json.loads(assistant_message.content)

        

if __name__ == "__main__":
    sys_prompt = read_sys_prompt("prompt/sys0_0_prompt.txt")
    human_prompt = read_human_prompt("prompt/human0_0_prompt.txt")
    agent = DesignAgent(sys_prompt)
    agent.invoke(human_prompt)


