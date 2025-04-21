import subprocess
from pathlib import Path
import re
import json
from typing import Dict, Any
import os


class ResultExtractor:
    @staticmethod
    def parse_ac_results(file_path: Path) -> Dict[str, float]:
        """解析AC仿真结果文件"""
        results = {}
        try:
            with open(file_path, 'r') as f:
                content = f.read()
                results.update({
                    'LowFreqGain_dB': float(re.search(r"Gain:\s*([\d.E+-]+)", content).group(1)),
                    'GBW_Hz': float(re.search(r"GBW:\s*([\d.E+-]+)", content).group(1)),
                    'PhaseMargin_deg': float(re.search(r"PM:\s*([\d.E+-]+)", content).group(1))
                })
        except Exception as e:
            print(f"AC结果解析错误: {e}")
            # 标记所有关键参数为缺失
            results.update({
                'LowFreqGain_dB': None,
                'GBW_Hz': None,
                'PhaseMargin_deg': None
            })
        return results

    @staticmethod
    def parse_idc(file_path: Path) -> Dict[str, float]:
        """解析静态电流及晶体管参数"""
        results = {}
        try:
            with open(file_path, 'r') as f:
                content = f.read()

                # 解析静态电流
                if (m := re.search(r"i\(vmeas\)\s*=\s*([+-]?\d+\.?\d*([eE][+-]?\d+)?)", content)):
                    raw_value = float(m.group(1))
                    results['idc_uA'] = raw_value * 1e6  # A → μA
                else:
                    print(f"未匹配到电流值: {file_path}")

                # 解析输出电压
                if (m := re.search(r"v\(vout\)\s*=\s*([+-]?\d+\.?\d*([eE][+-]?\d+)?)", content)):
                    results['vout_v'] = float(m.group(1))

                # 新增NMOS gm解析 (xm1)
                if (m := re.search(
                        r"@m\.xi1\.xm1\.msky130_fd_pr__nfet_01v8\[gm\]\s*=\s*([+-]?\d+\.?\d*([eE][+-]?\d+)?)",
                        content
                )):
                    results['gm1_s'] = float(m.group(1))

                # 新增PMOS gm解析 (xm7)
                if (m := re.search(
                        r"@m\.xi1\.xm7\.msky130_fd_pr__pfet_01v8\[gm\]\s*=\s*([+-]?\d+\.?\d*([eE][+-]?\d+)?)",
                        content
                )):
                    results['gm7_s'] = float(m.group(1))

        except Exception as e:
            print(f"IDC解析错误: {e}")
            results.update({
                'idc_uA': None,
            })
        return results

    @staticmethod
    def parse_sr(file_path: Path) -> Dict[str, float]:
        """解析压摆率结果"""
        try:
            with open(file_path, 'r') as f:
                content = f.read()
                # return {'SlewRate_Vs': float(re.search(r"sr\s*=\s*([\d.E+-]+)", content))}
                try:
                    match = re.search(r"sr\s*=\s*([+-]?\d+\.?\d*([eE][+-]?\d+)?)", content)
                    if match:
                        return {'SlewRate_Vs': float(match.group(1))}
                    else:
                        raise ValueError("未找到 SlewRate 值")
                except Exception as e:
                    print(f"SR解析错误: {str(e)}")
                    return {'SlewRate_Vs': None}
        except Exception as e:
            print(f"SR解析错误: {e}")
            results.update({
                'SlewRate_Vs': None,
            })
            return {}

    @staticmethod
    def parse_cmrr(result_dir: Path) -> Dict[str, float]:
        """解析特殊仿真结果"""
        results = {}
        try:
            # 解析CMRR
            cmrr_path = "./CMRR_results.txt"
            with open(cmrr_path) as f:
                results['CMRR_dB'] = float(re.search(r"CMRR:\s*([\d.-]+)", f.read()).group(1))
        except Exception as e:
            print(f"特殊结果解析错误: {e}")
        return results

    def parse_noise(result_dir: Path) -> Dict[str, float]:
        results = {}
        try:
            # 解析Noise
            noise_path = "./noise_1KHZ.txt"
            with open(noise_path) as f:
                results['InputNoise_uVrms'] = float(
                    re.search(r"inputnoise:\s*([+-]?\d+\.?\d*([eE][+-]?\d+)?)\s*V?", f.read()).group(1)) * 1e6  # V -> μV
        except Exception as e:
            print(f"特殊结果解析错误: {e}")
        return results

    def parse_psrr(result_dir: Path) -> Dict[str, float]:
        results = {}
        try:
            # 解析PSRR
            psrr_path = "./PSRR_results.txt"
            with open(psrr_path) as f:
                results['PSRR_dB'] = float(re.search(r"PSRR:\s*([\d.-]+)", f.read()).group(1))
        except Exception as e:
            print(f"特殊结果解析错误: {e}")
        return results


class SpiceSimulator:
    def __init__(self, base_dir: str):
        self.base_dir = Path(base_dir)
        self.sim_timeout = 120

    # def batch_simulate(self) -> Dict[str, Dict[str, Any]]:
    #     """执行批量仿真并返回结构化结果"""
    #     all_results = {}
    #
    #     # 执行多corner基础仿真
    #     for corner in self.corners:
    #         corner_dir = self.base_dir / corner
    #         all_results[corner] = self._run_corner_simulations(corner_dir,corner)
    #
    #     # 执行特殊仿真(TT only)
    #     tt_dir = self.base_dir
    #     all_results['TT'].update(self._run_special_simulations(tt_dir))
    #
    #     return all_results

    def run_corner(self, corner: str) -> dict:
        """运行单个工艺角的基础仿真"""
        try:
            results = self._run_corner_simulations(
            corner_dir=self.base_dir / corner,
            corner=corner
            )
            return {corner: results}
        except Exception as e:
            print(f"工艺角 {corner} 仿真失败，返回空字典")
            return {corner: {}}  # 确保返回字典而非其他类型

    def run_special(self) -> dict:
        """运行特殊指标仿真（TT only）"""
        try:
            results=self._run_special_simulations(self.base_dir)
            return {'special': results}
        except Exception as e:
            print(f"工艺角 {corner} 仿真失败，返回空字典")
            return {corner: {}}  # 确保返回字典而非其他类型

    def _run_corner_simulations(self, corner_dir: Path, corner: str) -> Dict[str, Any]:
        """运行单个corner的所有基础仿真"""
        print(f"\n=== 正在处理 {corner_dir.name} Corner ===")
        results = {}

        # AC仿真
        ac_path = corner_dir / "AMP_AC.cir"
        ac_result_path = Path(f"./{corner}_AC_results.txt")
        if ac_path.exists():
            self._run_simulation(ac_path)
            results.update(ResultExtractor.parse_ac_results(ac_result_path))

        # IDC仿真
        idc_path = corner_dir / "AMP_IDC.cir"
        idc_result_path = Path(f"./{corner}_Idc.txt")
        if idc_path.exists():
            self._run_simulation(idc_path)
            results.update(ResultExtractor.parse_idc(idc_result_path))

        # SR仿真
        sr_path = corner_dir / "AMP_SR.cir"
        sr_result_path = Path(f"./{corner}_SR.txt")
        if sr_path.exists():
            self._run_simulation(sr_path)
            results.update(ResultExtractor.parse_sr(sr_result_path))

        return results

    def _run_special_simulations(self, tt_dir: Path) -> Dict[str, Any]:
        """运行TT corner的特殊仿真"""
        print("\n=== 正在处理特殊仿真 ===")
        results = {}

        # CMRR仿真
        cmrr_path = self.base_dir / "AMP_CMRR.cir"
        cmrr_result_path = Path(f"./CMRR_results.txt")
        if cmrr_path.exists():
            self._run_simulation(cmrr_path)
            results.update(ResultExtractor.parse_cmrr(cmrr_result_path))

        # Noise仿真
        noise_path = self.base_dir / "AMP_noise.cir"
        noise_result_path = Path(f"./noise_1KHZ.txt")
        if noise_path.exists():
            self._run_simulation(noise_path)
            results.update(ResultExtractor.parse_noise(noise_result_path))

        # PSRR仿真
        psrr_path = self.base_dir / "AMP_PSRR.cir"
        psrr_result_path = Path(f"./PSRR_results.txt")
        if psrr_path.exists():
            self._run_simulation(psrr_path)
            results.update(ResultExtractor.parse_psrr(psrr_result_path))

        return results

    def _run_simulation(self, cir_file: Path):
        """执行单个仿真"""
        try:
            print(f"运行仿真: {cir_file.name}")
            subprocess.run(
                ['ngspice', '-b', str(cir_file)],
                check=True,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                timeout=self.sim_timeout
            )
        except subprocess.CalledProcessError as e:
            print(f"仿真失败: {cir_file.name} - 错误码 {e.returncode}")
        except subprocess.TimeoutExpired:
            print(f"仿真超时: {cir_file.name}")
        except Exception as e:
            print(f"未知错误: {str(e)}")

    def get_results_structure(self) -> Dict[str, Any]:
        """获取空结果结构用于测试"""
        return {
            corner: {
                'LowFreqGain_dB': 0.0,
                'GBW_Hz': 0.0,
                'PhaseMargin_deg': 0.0,
                'idc_uA': 0.0,
                'SlewRate_Vs': 0.0,
                **({'CMRR_dB': 0.0, 'PSRR_dB': 0.0, 'InputNoise_uVrms': 0.0} if corner == 'TT' else {})
            } for corner in self.corners
        }


if __name__ == "__main__":
    # 测试用例
    corners = ['TT', 'SS', 'FF', 'FS', 'SF']
    simulator = SpiceSimulator(
        base_dir='../final_netlist2',
        corners=corners  # 新增参数
    )

    # 运行所有仿真
    results = simulator.batch_simulate()

    # 打印结果
    print("\n仿真结果汇总:")
    for corner, data in results.items():
        print(f"\n{corner} Corner:")
        for k, v in data.items():
            print(f"  {k}: {v}")

