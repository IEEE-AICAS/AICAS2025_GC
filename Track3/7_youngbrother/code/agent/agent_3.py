import re
from pathlib import Path
from typing import Dict, Union, List
import json


class ParamParser:
    """增强型参数解析器，支持多工艺角数据"""

    @staticmethod
    def parse_value(value_str: str) -> float:
        """智能单位转换解析"""
        unit_map = {
            'T': 1e12, 'G': 1e9, 'MEG': 1e6, 'K': 1e3,
            'M': 1e-3, 'U': 1e-6, 'N': 1e-9, 'P': 1e-12,
            'F': 1e-15, 'DB': 1, 'UV': 1e-6
        }

        # 处理科学计数法
        if 'e' in value_str.lower():
            return float(value_str)

        # 分离数值和单位
        match = re.match(r"([\d.]+)([A-Za-z]*)", value_str.strip())
        if match:
            num, unit = match.groups()
            multiplier = unit_map.get(unit.upper(), 1)
            return float(num) * multiplier
        return float(value_str)

    @staticmethod
    def parse_spice_params(netlist_path: str) -> Dict[str, Dict]:
        """解析多工艺角网表参数"""
        corner_params = {}
        current_corner = 'TT'  # 默认corner

        with open(netlist_path, 'r') as f:
            for line in f:
                line = line.strip()

                # 检测工艺角切换
                if line.startswith('.LIB'):
                    corner_match = re.search(r"\.LIB\s+'.*/models/sky130\.lib\.spice'(\w+)", line)
                    if corner_match:
                        current_corner = corner_match.group(1)
                        corner_params[current_corner] = {}

                # MOS参数解析
                if line.startswith(('M', 'X')) and 'sky130' in line:
                    device_params = {}
                    parts = re.split(r'\s+', line)

                    # 提取器件类型
                    model = parts[-2]
                    device_type = 'nmos' if 'nfet' in model else 'pmos'

                    # 解析参数对
                    param_str = parts[-1]
                    for param in re.findall(r"(\w+)=([\w.]+)", param_str):
                        key, val = param
                        device_params[key.lower()] = ParamParser.parse_value(val)

                    # 存储参数
                    device_id = parts[0].lstrip('X')
                    corner_params[current_corner][device_id] = {
                        'type': device_type,
                        'model': model,
                        'params': device_params
                    }

        return corner_params


class SpecParser:
    """统一规格解析器，不分工艺角"""

    @staticmethod
    def parse_spec(spec_path: str) -> Dict[str, Dict]:
        """解析统一设计指标"""
        spec = {}

        with open(spec_path) as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue

                # 指标解析
                match = re.match(
                    r"(\w+)\s*(>=|<=|>|<)\s*([\d.]+)([a-zA-Z/]*)",
                    line
                )
                if match:
                    param, op, val, unit = match.groups()
                    key = param.lower()
                    spec[key] = {
                        'value': SpecParser._convert_unit(float(val), unit),
                        'operator': op,
                        'unit': unit
                    }
        return spec

    @staticmethod
    def _convert_unit(value: float, unit: str) -> float:
        """单位转换逻辑（保持不变）"""
        conversions = {
            'dB': lambda x: x,
            'MHz': lambda x: x * 1e6,
            'uA': lambda x: x * 1e-6,
            'V/us': lambda x: x * 1e6,
            'uV': lambda x: x * 1e-6
        }
        return conversions.get(unit.lower(), lambda x: x)(value)


class ResultAnalyzer:
    """多工艺仿真结果分析器"""

    @staticmethod
    def analyze_results(results: Dict, spec: Dict) -> Dict[str, List]:
        """执行多维度结果分析"""
        analysis = {
            'violations': [],
            'worst_corners': {},
            'margins': {}
        }

        # 遍历所有指标
        for metric in ['gain', 'gbw', 'pm', 'sr', 'idc', 'cmrr', 'psrr', 'noise']:
            metric_results = []

            # 收集各corner数据
            for corner, data in results.items():
                value = data.get(metric, None)
                if value is not None:
                    metric_results.append((corner, value))

            if not metric_results:
                continue

            # 确定最差情况
            if metric in ['gain', 'gbw', 'pm', 'sr', 'cmrr', 'psrr']:
                worst_value = min(v for _, v in metric_results)
            else:
                worst_value = max(v for _, v in metric_results)

            worst_corners = [c for c, v in metric_results if v == worst_value]
            analysis['worst_corners'][metric] = worst_corners

            # 计算安全裕度
            if 'common' in spec:
                target = spec['common'].get(metric, {}).get('value', 0)
                if target != 0:
                    margin = (worst_value - target) / abs(target) * 100
                    analysis['margins'][metric] = f"{margin:.1f}%"

            # 检查违规
            for corner, value in metric_results:
                spec_config = spec.get(corner, spec.get('common', {}))
                if not ResultAnalyzer._check_metric(value, spec_config.get(metric, {})):
                    analysis['violations'].append({
                        'corner': corner,
                        'metric': metric,
                        'value': value,
                        'spec': spec_config.get(metric, {})
                    })

        return analysis

    @staticmethod
    def _check_metric(value: float, spec: Dict) -> bool:
        """检查单个指标是否达标"""
        if not spec:
            return True

        op = spec.get('operator', '>')
        target = spec.get('value', 0)

        if op == '>':
            return value >= target
        elif op == '<':
            return value <= target
        elif op == '>=':
            return value >= target
        elif op == '<=':
            return value <= target
        return True

# 显式导出接口函数
parse_spec = SpecParser.parse_spec
parse_spice_params = ParamParser.parse_spice_params
read_current_params = ParamParser.parse_spice_params  # 保持旧版兼容

# 测试用例
if __name__ == "__main__":
    # 示例网表解析
    net_params = ParamParser.parse_spice_params("AMP.cir")
    print("网表参数:", json.dumps(net_params, indent=2))

    # 示例指标解析
    spec = SpecParser.parse_spec("spec.txt")
    print("\n设计指标:", json.dumps(spec, indent=2))

    # 示例结果分析
    sample_results = {
        'TT': {'gain': 75, 'cmrr': 80},
        'FF': {'gain': 82, 'cmrr': 78}
    }
    analysis = ResultAnalyzer.analyze_results(sample_results, spec)
    print("\n结果分析:", json.dumps(analysis, indent=2))

