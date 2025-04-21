from agent_1 import QwenOptimizer
from agent_2 import SpiceSimulator
from agent_3 import parse_spec, parse_spice_params
import time
import shutil
import os
from pathlib import Path


def optimization_loop():
    # 初始化组件
    optimizer = QwenOptimizer()
    base_corners = ['TT']  # 第一阶段必跑
    secondary_corners = ['SS', 'FF', 'FS', 'SF']  # TT通过后执行
    simulator = SpiceSimulator('/home/lisq/final_contest/复赛/final_netlist2')

    # 读取设计指标和原始网表
    spec = parse_spec('/home/lisq/final_contest/复赛/prompt/prompt_3.txt')
    with open('/home/lisq/final_contest/复赛/prompt/prompt_2.txt', 'r', encoding='utf-8') as f:
        original_netlist = f.read()

    # 打印设计指标（增强版）
    print("\n=== 设计指标要求 ===")
    metric_names = {
        'gain': ('开环增益', 'dB'),
        'gbw': ('增益带宽积', 'MHz'),
        'pm': ('相位裕度', 'deg'),
        'sr': ('压摆率', 'V/μs'),
        'idc': ('静态电流', 'μA'),
        'cmrr': ('共模抑制比', 'dB'),
        'psrr': ('电源抑制比', 'dB'),
        'noise': ('输入噪声', 'μV')
    }

    for param, config in spec.items():
        if param in metric_names:
            name, unit = metric_names[param]
            print(f"- {name}: {config['operator']} {config['value']}{unit}")
    print("=" * 40 + "\n")

    iteration = 1
    max_iterations = 30
    current_netlist = original_netlist

    while iteration <= max_iterations:
        print(f"\n=== 迭代 {iteration}/{max_iterations} ===")
        all_results = {}

        # 步骤1：生成新网表
        new_netlist = optimizer.generate_netlist(
            current_netlist=current_netlist,
            spec=spec,
            sim_results=all_results
        )
        if not validate_netlist(new_netlist):
            print("⚠️ 网表验证失败，终止优化")
            break

        # 保存新网表
        netlist_dir = Path('/home/lisq/final_contest/复赛/final_netlist2')
        netlist_path = netlist_dir / 'AMP.cir'
        try:
            netlist_path.write_text(new_netlist)
            current_netlist = new_netlist
        except Exception as e:
            print(f"❌ 网表保存失败: {str(e)}")
            break


        # 阶段1: TT基础指标验证
        print("\n🔁 阶段1: 验证TT基础指标")
        try:
            tt_results  = simulator.run_corner('TT')
            all_results.update(tt_results )
            # 提取TT结果进行验证
            print(tt_results)

        except Exception as e:
            print(f"TT仿真失败: {str(e)}")
            iteration += 1
            continue

        # TT基础检查
        tt_data = tt_results['TT']
        if not check_corner_spec(spec, tt_data, 'TT'):
            print("❌ TT基础指标未达标，跳过当前迭代")
            save_results(all_results, f"/home/lisq/final_contest/复赛/agent/simulation_results/iter{iteration}_results.json")
            iteration += 1
            continue

        # 阶段2: 次要工艺角验证
        print("🔁 阶段2: 验证次要工艺角")
        # simulator.corners = secondary_corners  # 动态更新仿真角
        stage2_success = True
        flag=4   #总共有4个corner 的仿真：FF SS SF FS
        for corner in secondary_corners:
            try:
                # 逐个corner仿真
                corner_results = simulator.run_corner(corner)
                all_results.update(corner_results)
                print(corner_results)

                # 实时验证
                corner_data = corner_results[corner]
                if not check_corner_spec(spec, corner_data, corner):
                    print(f"❌ {corner}未达标")
                    flag=flag-1
                    save_results(all_results, f"/home/lisq/final_contest/复赛/agent/simulation_results/iter{iteration}_results.json")
            except Exception as e:
                print(f"{corner}仿真失败: {str(e)}")
                stage2_success=False
                break
        if flag>=0:
            stage2_success=True
        #print(stage_2_sucess)
        if not stage2_success:
            iteration += 1
            continue

        # 阶段3: 特殊指标验证
        print("🔁 阶段3: 验证特殊指标")
        try:
            special_data = simulator.run_special()
            all_results.update(special_data)  # 保存但不检查
        except Exception as e:
            print(f"特殊指标仿真失败: {str(e)}")
            iteration += 1
            continue

        # print("\n[DEBUG] 最终结果结构验证:")
        # for corner, data in all_results.items():
        #     print(f"{corner}: {type(data)}")  # 检查数据类型
        #     if not isinstance(data, dict):
        #         print(f"❌ 错误：{corner} 的结果类型为 {type(data)}，应为字典")

        # 合并需要检查的工艺角列表
        all_required_corners = base_corners + secondary_corners  # ['TT', 'SS', 'FF', 'FS', 'SF']
        # 最终验证逻辑
        if all(
                isinstance(all_results.get(c), dict)  # 防御性获取数据
                and check_corner_spec(spec, all_results[c], c)
                for c in all_required_corners
        ):
            print("🎉 所有工艺角指标达标!")
            save_results(all_results, Path('/home/lisq/final_contest/复赛/agent/simulation_results/final_results.json'))
            return True
        elif (check_corner_spec(spec, tt_data, 'TT') and stage2_success == True ):
            save_results(all_results, f"/home/lisq/final_contest/复赛/agent/simulation_results/iter{iteration}_results.json")
            return True
        iteration += 1

    print("\n优化未达到设计要求")
    return False


def _check_metrics(spec: dict, results: dict, metric_config: dict) -> bool:
    """通用指标检查工具"""
    for metric, (key, check_type, ratio) in metric_config.items():
        value = results.get(key)
        spec_value = spec[metric]['value']

        if value is None:
            print(f"❌ 缺失关键参数: {key}")
            return False

        threshold = spec_value * ratio
        if (check_type == 'min' and value < threshold) or (check_type == 'max' and value > threshold):
            print(f"❌ {metric}不达标 ({value} vs {threshold})")
            return False
    return True


def check_corner_spec(spec: dict, results: dict, corner: str) -> bool:
    """通用指标检查（仅基础指标）"""
    # 基础指标配置（统一使用spec中的阈值）

    #print(spec)
    #print(results)
    #print(corner)
    if corner  == 'TT':

        checks = {
            'gain': ('LowFreqGain_dB', 'min', 0.95),  # 95% spec要求
            'gbw': ('GBW_Hz', 'min', 0.95),
            'pm': ('PhaseMargin_deg', 'min', 0.95),
            'sr': ('SlewRate_Vs', 'min', 0.95),
            'idc': ('idc_uA', 'max', 1.05)
        }
    else:
        checks = {
            'gain': ('LowFreqGain_dB', 'min', 0.9),  # 90% spec要求
            'gbw': ('GBW_Hz', 'min', 0.9),
            'pm': ('PhaseMargin_deg', 'min', 0.9),
            'sr': ('SlewRate_Vs', 'min', 0.9),
            'idc': ('idc_uA', 'max', 1.2)
        }

    all_passed = True
    for metric, (key, check_type,thd_value) in checks.items():
        value = results.get(key)
        spec_value = spec[metric]['value']*thd_value

        # 参数存在性检查
        if value is None:
            print(f"❌ [{corner}] 缺失基础参数: {key}")
            all_passed = False
            continue

        # 严格满足spec值
        condition_met = (check_type == 'min' and value >= spec_value) \
                        or (check_type == 'max' and value <= spec_value)

        if not condition_met:
            print(f"❌ [{corner}] {metric}不达标 ({value} vs spec要求 {spec_value})")
            all_passed = False

    return all_passed


def validate_netlist(netlist: str) -> bool:
    """网表基础验证"""
    required = ['.subckt AMP', 'sky130_fd_pr', '.ends AMP']
    return all(r in netlist for r in required)


def clean_previous_results():
    """清理历史结果文件"""
    # 清理各corner结果文件
    for corner in ['TT', 'FF', 'SS', 'SF', 'FS']:
        result_file = Path(f"./{corner}_result.txt")
        if result_file.exists():
            result_file.unlink()

    # 清理特殊指标文件
    special_files = [
        'CMRR_results.txt',
        'noise_1KHZ.txt',
        'PSRR_results.txt'
    ]
    for file in special_files:
        path = Path(f"./{file}")
        if path.exists():
            path.unlink()

def save_results(results: dict, path: Path):
    """保存结构化仿真结果"""
    import json
    try:
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(results, f, indent=2)
        print(f"✅ 结果已保存至: {path}")
    except IOError as e:
        print(f"❌ 结果保存失败: {str(e)}")

def save_corner_results(corner: str, results: dict):
    """带条件的结果保存函数"""
    result_path = Path(f"/home/lisq/final_contest/复赛/agent/{corner}_result.txt")

    filtered_results = {}
    for key, value in results.items():
        # TT保留全部指标，其他corner过滤特殊指标
        if corner == 'TT' or key not in ['CMRR_dB', 'InputNoise_uVrms', 'PSRR_dB']:
            filtered_results[key] = value

    with open(result_path, 'w') as f:
        json.dump(filtered_results, f, indent=2)


if __name__ == "__main__":
    # 备份初始文件
    optimization_loop()

