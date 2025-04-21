# 导入必要的模块
import json
import os
from ollama import ChatResponse, chat
from utils import read_sys_prompt,read_human_prompt
from config import *
import data
if "analog" not in os.getcwd():
    os.chdir(os.getcwd()+"/analog")

class CalculationAgent:
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
    
    def get_response_with_tool(self,messages):
        response: ChatResponse = chat(
            model = "qwen2.5:7b",
            messages = messages,
            tools = self._tool,
        )
        if response.message.content is None:
            response.message.content = ""
        return response.message


    def invoke(self,prompt):
        current_messages = self.messages.copy()
        current_messages.append(prompt)

        assistant_message = self.get_response_with_tool(current_messages)
        current_messages.append(assistant_message)
        for tool_call in assistant_message.tool_calls:
            if tool_call.function.name == "calculate_k":
                tool_info = {"role":"tool","name":tool_call.function.name}
                tool_info["content"] = self.calculate_k(**tool_call.function.arguments)
                current_messages.append(tool_info)
            elif tool_call.function.name == "calculate_W":
                tool_info = {"role":"tool","name":tool_call.function.name}
                tool_info["content"] = self.calculate_W(**tool_call.function.arguments)
                current_messages.append(tool_info)
            
            # assistant_message = self.get_response(self.messages)
            # self.messages.append(assistant_message)

        # print(self.messages)
        return current_messages[-1]["content"]
        # return self.messages[-1]["content"]
        # print(self.messages[-1].model_dump_json())
        # print(self.messages[-1].content)
    
    def calculate_k(self, l:float,WL_max:float):
        W = WL_max/l
        k = W/data.L_LVT_min/10
        logger.trace(f"计算k: {W}/{data.L_LVT_min}/10 = {k}")
        return {"k":round(k,2)}  # 保留两位有效数字
    
    def calculate_W(self, l_input: float, l_other: float,WL_max:float):
        W_input = WL_max / l_input
        W_other = WL_max / l_other
        logger.trace(f"计算W: {WL_max}/{l_input} = {W_input}, {WL_max}/{l_other} = {W_other}")
        return {"W_input":W_input,"W_other":W_other}
    
    
    _tool = [
        {
            "type": "function",
            "function": {
                "name": "calculate_k",
                "description": "calculate k",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "l": {"type": "number","description": "the length of MOSFET, unit um"},
                        "WL_max": {"type": "number","description": "the maximum width*length of MOSFET, unit um^2"}
                    },
                    "required": ["l","WL_max"]
                }
            }
        },
        {
            "type": "function",
            "function": {
                "name": "calculate_W",
                "description": "calculate the width of MOSFET",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "l_input": {"type": "number","description": "the input MOSFET length, unit um"},
                        "l_other": {"type": "number","description": "the other MOSFET length, unit um"},
                        "WL_max": {"type": "number","description": "the maximum width*length of MOSFET, unit um^2"}
                    },
                    "required": ["l_input","l_other","WL_max"]
                }
            }
        }
    ]

if __name__ == "__main__":
    agent = CalculationAgent()
    human_prompt = read_human_prompt("prompt/human1_1_prompt.txt",l=1.0,WL_max=data.WL_max)
    print(agent.invoke(human_prompt))

