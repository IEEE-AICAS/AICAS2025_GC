import os, json
import asyncio

import config
from common_method import callmodel_async
from common_method import read_prompt_file
from common_method import write_string_to_file
from common_method import str2json
from common_method import simulation
from common_method import backup_file

# Extract necessary information from the indicator requirements described in the judges' natural language.
async def get_requirement(custom: bool):
    # This method is only used to improve the experience of judges adjusting indicators and does not affect the generation process. Therefore, the prompt is placed here.
    prompt_get_req = """- Role: Expert in Analysis of Electronic Circuit Design Performance Metrics.
- Background: When s design operational amplifier (op-amp) circuit netlists, they need to clarify performance metric requirements to facilitate subsequent design and optimization. User inputs contain key metrics including open-loop gain (Gain), gain bandwidth product (GBW), phase margin (PM), slew rate (SR), and power consumption (IDC), which must be organized into clear JSON format for automated processing and analysis.
- Profile: You are an expert with profound knowledge and extensive practical experience in electronic circuit design. You possess precise understanding and analytical capabilities for op-amp performance metrics, enabling rapid and accurate extraction of critical information from complex design requirements and structured presentation.
- Skills: Electronic circuit theory, performance metric analysis, data extraction/organization techniques, and proficient JSON formatting capabilities.
- Goals: Extract key information from -input performance metric requirements for op-amp circuit netlist designs, and organize it into compliant JSON format output that accurately reflects target values and inequality directions (> or <) for each metric.
- Constrains: Extracted information must be completely accurate, JSON format must meet standards, target values and inequality directions for each metric must be explicitly specified without omissions or errors.
- OutputFormat: JSON format
- Workflow: 
    1. Carefully read -input performance metric requirements for op-amp circuit netlist designs, identify and extract key metrics (Gain, GBW, PM, SR, IDC) with their target values.
    2. Determine the inequality direction for each metric (whether the target value requires greater than or less than).
    3. Organize extracted information into specified JSON structure and format, ensuring correct and complete JSON output.
- Examples:
  - Example1：
    input：Open-loop gain (Gain) should be greater than 100dB, gain bandwidth product (GBW) >1MHz, phase margin (PM) >60 degrees, slew rate (SR) >1V/μs, power consumption (IDC) <100μA.
    output：```json
    {
      "Gain": {
        "value": "100",
        "unit": "dB",
        "requirement": "greater_than"
      },
      "GBW": {
        "value": "1",
        "unit": "MHz",
        "requirement": "greater_than"
      },
      "PM": {
        "value": "60",
        "unit": "degree",
        "requirement": "greater_than"
      },
      "SR": {
        "value": "1",
        "unit": "V/μs",
        "requirement": "greater_than"
      },
      "IDC": {
        "value": "100",
        "unit": "μA",
        "requirement": "less_than"
      }
    }
    ```
  - Example2：
    input：Open-loop gain (Gain) <80dB, gain bandwidth product (GBW) <0.5MHz, phase margin (PM) <45 degrees, slew rate (SR) <0.5V/μs, power consumption (IDC) >5μA.
    output：```json
    {
      "Gain": {
        "value": "80",
        "unit": "dB",
        "requirement": "less_than"
      },
      "GBW": {
        "value": "0.5",
        "unit": "MHz",
        "requirement": "less_than"
      },
      "PM": {
        "value": "45",
        "unit": "degree",
        "requirement": "less_than"
      },
      "SR": {
        "value": "0.5",
        "unit": "V/μs",
        "requirement": "less_than"
      },
      "IDC": {
        "value": "5",
        "unit": "μA",
        "requirement": "greater_than"
      }
    }
    ```"""
    prompt_userInput = ""
    if custom:
        # request user input
        prompt_userInput = input("Please enter your operational amplifier circuit performance specifications (e.g., Open-loop gain (Gain) should be greater than 60dB, Gain Bandwidth Product (GBW) >20MHz, Phase Margin (PM) >60 degrees, Slew Rate (SR) >20V/μs, Power Consumption (IDC) <500μA), press enter to use default info:")
    
    # call model to get the requirement if the user input is not empty
    if prompt_userInput:
        ai_result = await callmodel_async(prompt_get_req, prompt_userInput)
    # if the user input is empty, use the default info
    else:
        ai_result = """```json
{
  "Gain": {
    "value": "60",
    "unit": "dB",
    "requirement": "greater_than"
  },
  "GBW": {
    "value": "20",
    "unit": "MHz",
    "requirement": "greater_than"
  },
  "PM": {
    "value": "60",
    "unit": "degree",
    "requirement": "greater_than"
  },
  "SR": {
    "value": "20",
    "unit": "V/μs",
    "requirement": "greater_than"
  },
  "IDC": {
    "value": "500",
    "unit": "μA",
    "requirement": "less_than"
  }
}
```"""
        
    json_str = await str2json(ai_result)
    
    # Write indicator requirements to environment variables and prompt word files
    try:
        json_str = json.loads(json_str)
        
        if not json_str.get('Gain'):
            json_str['Gain'] = {
                'value': 10,
                'unit': 'dB',
                'requirement': 'greater_than'
            }
            config.ISCUSTOM = True
        else:
            config.CUSTOMINDEX = 'Gain'
        if not json_str.get('GBW'):
            json_str['GBW'] = {
                'value': 1,
                'unit': 'MHz',
                'requirement': 'greater_than'
            }
            config.ISCUSTOM = True
        else:
            config.CUSTOMINDEX = 'GBW'
        if not json_str.get('PM'):
            json_str['PM'] = {
                'value': 10,
                'unit': 'degree',
                'requirement': 'greater_than'
            }
            config.ISCUSTOM = True
        else:
            config.CUSTOMINDEX = 'PM'
        if not json_str.get('SR'):
            json_str['SR'] = {
                "value": "5",
                "unit": "V/μs",
                "requirement": "greater_than"
            }
            config.ISCUSTOM = True
        else:
            config.CUSTOMINDEX = 'SR'
        if not json_str.get('IDC'):
            json_str['IDC'] = {
                "value": "1000",
                "unit": "μA",
                "requirement": "less_than"
            }
            config.ISCUSTOM = True
        else:
            config.CUSTOMINDEX = 'IDC'
        
        config.PFINDEX["Gain"] = {
            'value': float(json_str['Gain']['value']),
            'requirement': json_str['Gain']['requirement'],
            'unit': json_str['Gain']['unit']
        }
        config.PFINDEX['GBW'] = {
            'value': float(json_str['GBW']['value']),
            'requirement': json_str['GBW']['requirement'],
            'unit': json_str['GBW']['unit']
        }
        config.PFINDEX['PM'] = {
            'value': float(json_str['PM']['value']),
            'requirement': json_str['PM']['requirement'],
            'unit': json_str['PM']['unit']
        }
        config.PFINDEX['SR'] = {
            'value': float(json_str['SR']['value']),
            'requirement': json_str['SR']['requirement'],
            'unit': json_str['SR']['unit']
        }
        config.PFINDEX['IDC'] = {
            'value': float(json_str['IDC']['value']),
            'requirement': json_str['IDC']['requirement'],
            'unit': json_str['IDC']['unit']
        }
        json_str = f"""Open-loop Gain (Gain): {json_str['Gain']['requirement']} {json_str['Gain']['value']}{json_str['Gain']['unit']};
Gain-Bandwidth Product (GBW): {json_str['GBW']['requirement']} {json_str['GBW']['value']}{json_str['GBW']['unit']};
Phase Margin (PM): {json_str['PM']['requirement']} {json_str['PM']['value']}{json_str['PM']['unit']};
Slew Rate (SR): {json_str['SR']['requirement']} {json_str['SR']['value']}{json_str['SR']['unit']};
Static Power Consumption (IDC): {json_str['IDC']['requirement']} {json_str['IDC']['value']}{json_str['IDC']['unit']}"""
    except json.JSONDecodeError:
        print("json decode error")
