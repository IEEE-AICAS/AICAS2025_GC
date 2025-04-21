import os
import json
import sys
from data import mosfet_dict
import data
from utils import read_human_prompt,update_calculation_k_result
from ollama import ChatResponse, chat
from config import *

class RevisionAgent:
    def __init__(self,prompt:dict=None):
        self.messages = []
        if prompt is not None:
            self.messages.append(prompt)
    
    def get_response(self,messages):
        response: ChatResponse = chat(
            model = "qwen2.5:7b",
            messages = messages,
        )
        return response.message
    
    def get_response_with_tool(self,messages):
        response: ChatResponse = chat(
            model="qwen2.5:7b",
            messages=messages,
            tools=self._tool,
        )
        if response.message.content is None:
            response.message.content = ""
        return response.message

    def invoke(self,prompt:dict):
        current_messages = self.messages.copy()
        current_messages.append(prompt)
        assistant_message = self.get_response_with_tool(current_messages)

        if assistant_message.tool_calls:
            for tool_call in assistant_message.tool_calls:
                if tool_call.function.name == "revise_param":
                    self.revise_param(**tool_call.function.arguments)

    def revise_param(self,current_results:dict):
        if data.Mode.IS_SINGLE and data.Mode.SINGLE == "Idc":
            return
        if current_results["Gain"] < data.Gain_min:
            for mosfet in mosfet_dict.values():
                if mosfet.name == "XM1" or mosfet.name == "XM2":
                    mosfet.update_param("L", round(mosfet.get_param("L") + 0.1, 2))
                # else:
                #     mosfet.update_param("L", round(mosfet.get_param("L") + 0.1, 2))
            logger.trace("增益过小,增大L")
        if current_results["PM"] < data.PM_min - 5:
            data.WL_max *= 0.5
            logger.trace("PM过小,减小WL_max")
        elif current_results["PM"] < data.PM_min:
            data.WL_max -= 5
            logger.trace("PM过小,减小WL_max")
        else:
            for mosfet in mosfet_dict.values():
                if mosfet.name == "XM1" or mosfet.name == "XM2":
                    mosfet.update_param("W", round(mosfet.get_param("W") * 1.5, 2))
            logger.trace("满足要求,增大输入对管宽度")
        
    _tool = [
        {
            "type": "function",
            "function": {
                "name": "revise_param",
                "description": "Revise the parameters of the MOSFETs based on the current results",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "current_results": 
                        {
                            "type": "dict",
                            "description" : "The current results of the circuit"
                        }
                    }
                },
                "required": ["current_results"]
            }
        }
    ]
    
if __name__ == "__main__":
    pass


            
