from cgi import print_form
import os
import time
import re
import json
from pathlib import Path
from typing import Optional, Dict
from llama_cpp import Llama

class QwenOptimizer:
    def __init__(self, debug=False):
        self.llm = Llama(
            model_path='/home/lisq/qwen_test/models/qwen2.5-14b-instruct-q5_k_m.gguf',
            n_ctx=4096,          # 上下文窗口大小
            n_threads=16,         # CPU线程数
            n_batch=512,         # 批处理大小
            offload_kqv=True,     # 显存优化
            verbose=False
        )
        self.max_retries = 5
        self.circuit_dir = "/home/lisq/final_contest/复赛/final_netlist2"
        self.debug_mode = debug
        self.metric_config = {
            'base_metrics': {
                'gain': ('LowFreqGain_dB', 'dB', '>', self._format_db),
                'gbw': ('GBW_Hz', 'MHz', '>', self._format_freq),
                'pm': ('PhaseMargin_deg', 'deg', '>', self._format_deg),
                'sr': ('SlewRate_Vs', 'V/μs', '>', self._format_voltage),
                'idc': ('idc_uA', 'μA', '<', self._format_current)
            },
            'special_metrics': {
                'cmrr': ('CMRR_dB', 'dB', '>', self._format_db),
                'psrr': ('PSRR_dB', 'dB', '>', self._format_db),
                'noise': ('InputNoise_uVrms', 'μV', '<', self._format_noise)
            }
        }

    def generate_netlist(self, current_netlist: str, spec: Dict, sim_results: Dict = None) -> Optional[str]:
        """生成考虑多corner的新网表"""
        prompt = self._build_prompt(current_netlist, spec, sim_results)
        return self._get_llm_response(prompt)

    def _build_prompt(self, netlist: str, spec: Dict, results: Dict) -> str:
        """构建完整提示词"""
        try:
            # 尝试多种可能的路径
            possible_paths = [
                '/home/lisq/final_contest/复赛/prompt/prompt_0.txt',
                os.path.join(os.path.dirname(__file__), '/home/lisq/final_contest/复赛/prompt/prompt_1.txt')
            ]
            
            for path in possible_paths:
                if os.path.exists(path):
                    with open(path, 'r', encoding='utf-8') as f:
                        prompt_template = f.read()
                    break
            else:
                print(f"❌ 无法找到模板文件 prompt_template.txt")
                print(f"尝试过的路径: {possible_paths}")
                return None
        except Exception as e:
            print(f"❌ 读取模板文件失败: {str(e)}")
            return None

        return f"""
        [当前电路网表]
        {netlist}

        [设计要求]
        {self._format_spec(spec)}

        [仿真结果分析]
        {self._format_results(spec, results)}

        [优化约束]
        {prompt_template}
        """

    def _format_spec(self, spec: Dict) -> str:
        """格式化设计指标"""
        spec_desc = {
            'gain': ('开环增益', 'dB'),
            'gbw': ('增益带宽积', 'MHz'),
            'pm': ('相位裕度', '°'),
            'sr': ('压摆率', 'V/μs'),
            'idc': ('静态电流', 'μA'),
            'cmrr': ('共模抑制比', 'dB'),
            'psrr': ('电源抑制比', 'dB'),
            'noise': ('输入噪声', 'μV')
        }
        return "\n".join([
            f"- {spec_desc[key][0]}: {config['operator']} {config['value']}{spec_desc[key][1]}"
            for key, config in spec.items() if key in spec_desc
        ])

    def _format_results(self, spec: Dict, results: Dict) -> str:
        """多corner结果可视化"""
        report = []
        for corner, data in results.items():
            report.append(f"\n=== {corner} Corner ===")
            report += self._format_corner_data(spec, data, is_tt=(corner == 'TT'))
        return "\n".join(report)

    def _format_corner_data(self, spec: Dict, data: Dict, is_tt: bool) -> list:
        """单个corner数据格式化"""
        lines = []
        # 基础指标
        for metric, (key, unit, op, formatter) in self.metric_config['base_metrics'].items():
            raw_value = data.get(key, None)
            target = spec.get(metric, {}).get('value', 0)
            lines.append(self._format_metric(
                metric, raw_value, target, unit, op, formatter
            ))

        # TT Corner特殊指标
        if is_tt:
            for metric, (key, unit, op, formatter) in self.metric_config['special_metrics'].items():
                raw_value = data.get(key, None)
                target = spec.get(metric, {}).get('value', 0)
                lines.append(self._format_metric(
                    metric, raw_value, target, unit, op, formatter
                ))
        return lines

    def _format_metric(self, name: str, value: float, target: float,
                       unit: str, operator: str, formatter: callable) -> str:
        """单个指标格式化"""
        if value is None:
            return f"  {name.upper():<8} | 数据缺失"

        status_icon = "✅" if self._check_metric(value, target, operator) else "❌"
        delta = abs(value - target) / target * 100 if target != 0 else 0
        return (
            f"  {status_icon} {name.upper():<8} | "
            f"当前值: {formatter(value):<8} {unit} | "
            f"目标: {operator} {formatter(target):<6} | "
            f"偏差: {delta:.1f}%"
        )

    def _check_metric(self, value: float, target: float, operator: str) -> bool:
        """检查指标是否达标"""
        if operator == '>':
            return value >= target
        elif operator == '<':
            return value <= target
        return False

    # 指标格式化工具函数
    def _format_db(self, value: float) -> str:
        return f"{value:.1f}"

    def _format_freq(self, value: float) -> str:
        return f"{value / 1e6:.2f}"  # Hz转MHz

    def _format_voltage(self, value: float) -> str:
        return f"{value / 1e6:.2f}"  # V/s转V/μs

    def _format_current(self, value: float) -> str:
        return f"{value:.1f}"

    def _format_deg(self, value: float) -> str:
        return f"{value:.1f}"

    def _format_noise(self, value: float) -> str:
        return f"{value:.2f}"

    def _get_llm_response(self, prompt: str) -> Optional[str]:
        """与LLM交互的核心逻辑"""
        for attempt in range(1, self.max_retries + 1):
            try:
                response = self.llm.create_chat_completion(                                                                                              messages=[{"role": "user", "content": prompt}],                                                                                      temperature=0.2,                                                                                                                     max_tokens=2048,                                                                                                                     stop=["</end>"]                                                                                                                  )
                #print(response)
                #print(type(response))
                #print(response.keys())
                return self._process_response(response)
            except Exception as e:
                self._handle_retry(attempt, e)
        return None

    def _process_response(self, response) -> str:
        """处理API响应"""
        if not response['choices']:
            raise ValueError("空响应内容")

        content = response['choices'][0]['message']['content']
        clean_netlist = self._clean_netlist(content)
        print(clean_netlist)
        return clean_netlist

    def _clean_netlist(self, raw: str) -> str:
        """清理生成的网表"""
        filtered_lines = []
        for line in raw.split('\n'):
            line = line.strip()
            line=line.replace('um ',' ').replace('u ', ' ')
            if any(keyword in line.lower() for keyword in ['###','of','is','here','the','to','-','```','plaintext','analysis', 'model', 'lib', '*']):
                continue
            filtered_lines.append(line)
        
        return '\n'.join(filtered_lines)


    def _handle_retry(self, attempt: int, error: Exception):
        """重试处理"""
        print(f"尝试 {attempt} 失败: {str(error)}")
        if attempt < self.max_retries:
            backoff = min(2 ** attempt, 30)
            print(f"等待 {backoff}秒后重试...")
            time.sleep(backoff)


if __name__ == "__main__":
    # 测试用例
    optimizer = QwenOptimizer(debug=True)

    test_netlist = """.subckt AMP Vinp Vinn VDD VSS Vout
    M1 Vinp Vbias VSS VSS sky130_fd_pr__nfet_01v8 W=1u L=0.15u
    .ends AMP"""

    test_spec = {
        "gain": {"operator": ">", "value": 60, "unit": "dB"},
        "gbw": {"operator": ">", "value": 20, "unit": "MHz"},
        "cmrr": {"operator": ">", "value": 80, "unit": "dB"}
    }

    sim_results = {
        "TT": {
            "LowFreqGain_dB": 58.2,
            "GBW_Hz": 18.5e6,
            "CMRR_dB": 85.3,
            "idc_uA": 350.1
        },
        "FF": {
            "LowFreqGain_dB": 62.1,
            "GBW_Hz": 22.3e6,
            "idc_uA": 420.5
        }
    }

    result = optimizer.generate_netlist(test_netlist, test_spec, sim_results)
    print("生成的网表：" + ("有效" if result else "无效"))
    if result:
        print(result)

