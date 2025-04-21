import os
import sys
import csv
import argparse
from datetime import datetime
from typing import Dict, List, Optional

def setup_environment():
    """设置环境变量和工作目录"""
    root_dir = os.path.dirname(os.path.abspath(__file__))  # 获取当前脚本的目录
    parent_dir = os.path.dirname(root_dir)  # 获取上一级目录
    if parent_dir not in sys.path:
        sys.path.insert(0, parent_dir)  # 将上一级目录添加到 sys.path
    os.chdir(parent_dir)  # 将工作目录切换到上一级目录
    os.makedirs("batch_results", exist_ok=True)  # 在上一级目录中创建 batch_results 文件夹

# 首先设置环境
setup_environment()

from utils.logger_manager import LoggerManager
from agent.amp_design_controller import AmpDesignController

# 获取logger
logger = LoggerManager.get_logger("batch_design")

def update_designer_prompt(gain: Optional[float] = None, 
                            gbw: Optional[float] = None, 
                            pm: Optional[float] = None, 
                            sr: Optional[float] = None):
    """更新designer_initial.txt中的性能要求"""
    try:
        prompt_path = os.path.join("prompt", "designer_initial.txt")
        if not os.path.exists(prompt_path):
            logger.error(f"找不到prompt文件: {prompt_path}")
            return False
            
        # 读取原始文件内容
        with open(prompt_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            
        # 找到Performance requirements部分
        performance_start = -1
        for i, line in enumerate(lines):
            if "Performance requirements:" in line:
                performance_start = i
                break
                
        if performance_start == -1:
            logger.error("找不到Performance requirements部分")
            return False
            
        # 构建新的性能要求
        new_requirements = []
        if gain is not None:
            new_requirements.append(f"Gain > {gain}dB")
        if gbw is not None:
            new_requirements.append(f"GBW > {gbw}MHz")
        if pm is not None:
            new_requirements.append(f"PM > {pm}°")
        if sr is not None:
            new_requirements.append(f"SR > {sr}V/μs")
            
        # 替换原有内容
        new_lines = lines[:performance_start + 1]
        new_lines.extend([req + "\n" for req in new_requirements])
        
        # 找到下一个主要部分
        next_section = -1
        for i, line in enumerate(lines[performance_start + 1:], performance_start + 1):
            if line.strip() and not line.startswith(" "):
                next_section = i
                break
                
        if next_section != -1:
            new_lines.extend(lines[next_section:])
            
        # 写入新内容
        with open(prompt_path, 'w', encoding='utf-8') as f:
            f.writelines(new_lines)
            
        logger.info("成功更新designer_initial.txt文件")
        return True
        
    except Exception as e:
        logger.error(f"更新prompt文件时发生错误: {str(e)}")
        return False

def parse_arguments():
    """解析命令行参数"""
    parser = argparse.ArgumentParser(description="批量运行运放电路设计")
    parser.add_argument("--num_runs", type=int, default=20, help="运行次数")
    parser.add_argument("--model_name", default="qwen2.5_7b", help="模型名称")
    parser.add_argument("--api_key", default="brttrg", help="API密钥")
    parser.add_argument("--base_url", default="http://localhost:11434/v1", help="API基础URL")
    parser.add_argument("--max_iterations", type=int, default=1, help="每次运行的最大迭代次数")
    parser.add_argument("--temperature", type=float, default=0.2, help="生成温度")
    parser.add_argument("--gain", type=float, default=60, help="增益要求(dB)")
    parser.add_argument("--gbw", type=float, default=20, help="增益带宽积要求(MHz)")
    parser.add_argument("--pm", type=float, default=60, help="相位裕度要求(度)")
    parser.add_argument("--sr", type=float, default=20, help="压摆率要求(V/μs)")
    parser.add_argument("--idc", type=float, default=500, help="电流要求")
    return parser.parse_args()

def extract_numeric_value(value):
    """从带单位或错误信息的字符串中提取数值"""
    if value is None:
        return None
    
    if isinstance(value, (int, float)):
        return float(value)
    
    try:
        # 如果是报错信息就直接返回none不要提取数字
        if "仿真失败" in value or "Simulation Failed" in value:
            return None
        
        # 如果是字符串，尝试提取数字部分
        import re
        # 匹配科学计数法和普通数字
        matches = re.findall(r'[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?', str(value))
        if matches:
            return float(matches[0])
        return None
    except:
        return None

def calculate_netlist_score(netlist_metrics: Dict[str, float], all_metrics: List[Dict[str, float]]) -> float:
    """计算单个网表的得分"""
    try:
        # 提取所有有效的指标值
        valid_metrics = []
        for metrics in all_metrics:
            valid_metric = {}
            for key in ['Gain', 'GBW', 'PM', 'SR', 'IDC']:
                value = extract_numeric_value(metrics.get(key))
                if value is not None:
                    valid_metric[key] = value
            if len(valid_metric) == 5:  # 只有当所有指标都有效时才包含
                valid_metrics.append(valid_metric)
        
        if not valid_metrics:
            return 0.0
        
        # 计算最大值和最小值
        max_values = {
            key: max(m[key] for m in valid_metrics)
            for key in ['Gain', 'GBW', 'PM', 'SR', 'IDC']
        }
        min_values = {
            key: min(m[key] for m in valid_metrics)
            for key in ['Gain', 'GBW', 'PM', 'SR', 'IDC']
        }
        
        # 提取当前网表的有效值
        current_values = {}
        for key in ['Gain', 'GBW', 'PM', 'SR', 'IDC']:
            value = extract_numeric_value(netlist_metrics.get(key))
            if value is None:
                return 0.0  # 如果缺少任何指标，得分为0
            current_values[key] = value
        
        # 基础分计算
        Gain_base = 12 if current_values['Gain'] >= 60 else (current_values['Gain'] / max_values['Gain']) * 12
        GBW_base = 12 if current_values['GBW'] >= 20 else (current_values['GBW'] / max_values['GBW']) * 12
        SR_base = 12 if current_values['SR'] >= 20 else (current_values['SR'] / max_values['SR']) * 12
        PM_base = 12 if current_values['PM'] >= 60 else (current_values['PM'] / max_values['PM']) * 12
        Idc_base = 12 if current_values['IDC'] <= 500 else (max_values['IDC'] / current_values['IDC']) * 12
        
        # 额外分计算
        P_Idc = (1 - (current_values['IDC'] - min_values['IDC']) / (max_values['IDC'] - min_values['IDC'])) * 6
        P_Gain = ((current_values['Gain'] - min_values['Gain']) / (max_values['Gain'] - min_values['Gain'])) * 4.5
        P_GBW = ((current_values['GBW'] - min_values['GBW']) / (max_values['GBW'] - min_values['GBW'])) * 4.5
        P_SR = ((current_values['SR'] - min_values['SR']) / (max_values['SR'] - min_values['SR'])) * 4.5
        P_PM = ((current_values['PM'] - min_values['PM']) / (max_values['PM'] - min_values['PM'])) * 3
        
        # 总得分
        total_score = (
            Gain_base + GBW_base + SR_base + PM_base + Idc_base +
            P_Idc + P_Gain + P_GBW + P_SR + P_PM
        )
        
        return total_score
    except Exception as e:
        logger.error(f"计算网表得分时发生错误: {str(e)}")
        return 0.0

def save_best_netlist(results_dir: str, netlists: List[Dict], metrics_list: List[Dict], conversations: List[List[Dict]]):
    """保存最佳网表及其信息"""
    try:
        # 计算每个网表的得分
        scores = []
        for i, metrics in enumerate(metrics_list):
            score = calculate_netlist_score(metrics, metrics_list)
            scores.append((i, score))
        
        # 找出得分最高的网表
        if not scores:
            logger.warning("没有有效的网表可供选择")
            return
        
        best_idx, best_score = max(scores, key=lambda x: x[1])
        
        # 保存最佳网表信息
        best_netlist_path = os.path.join(results_dir, "best_netlist.txt")
        with open(best_netlist_path, 'w', encoding='utf-8') as f:
            f.write(f"Best Netlist (Score: {best_score:.2f})\n")
            f.write("-" * 80 + "\n")
            f.write(f"Netlist Content:\n{netlists[best_idx]}\n\n")
            f.write("Metrics:\n")
            for key, value in metrics_list[best_idx].items():
                f.write(f"{key}: {value}\n")
            
            f.write("\nConversation History:\n")
            f.write("-" * 80 + "\n")
            for msg in conversations[best_idx]:
                f.write(f"Role: {msg['role']}\n")
                f.write(f"Content: {msg['content']}\n")
                f.write("-" * 80 + "\n")
        
        logger.info(f"已保存最佳网表信息到: {best_netlist_path}")
        
    except Exception as e:
        logger.error(f"保存最佳网表时发生错误: {str(e)}")

def save_results(run_id: int, netlist: str, metrics: Dict[str, Optional[float]], 
                conversation: List[Dict[str, str]], results_dir: str, csv_writer,
                all_metrics: List[Dict[str, Optional[float]]] = None):
    """保存一次运行的结果"""
    # 计算得分
    score = 0.0
    if all_metrics is not None:
        score = calculate_netlist_score(metrics, all_metrics)
    
    # 将对话历史转换为字符串
    conversation_str = ""
    for msg in conversation:
        conversation_str += f"Role: {msg['role']}\n"
        conversation_str += f"Content: {msg['content']}\n"
        conversation_str += "-" * 80 + "\n"
    
    # 写入CSV文件
    csv_writer.writerow({
        'Run': run_id,
        'Netlist': netlist,
        'Conversation': conversation_str,
        'Gain': metrics.get('Gain'),
        'GBW': metrics.get('GBW'),
        'PM': metrics.get('PM'),
        'SR': metrics.get('SR'),
        'IDC': metrics.get('IDC'),
        'Score': f"{score:.2f}"
    })

def main():
    """主函数"""
    args = parse_arguments()
    
    # 更新designer_initial.txt中的性能要求
    # if not update_designer_prompt(args.gain, args.gbw, args.pm, args.sr):
    #     logger.error("更新性能要求失败，程序退出")
    #     return
        
    # 创建结果目录
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    results_dir = os.path.join("batch_results", f"run_{timestamp}")
    os.makedirs(results_dir, exist_ok=True)
    
    # 创建CSV文件
    csv_path = os.path.join(results_dir, "results.csv")
    fieldnames = ['Run', 'Netlist', 'Conversation',
                 'Gain', 'GBW', 'PM', 'SR', 'IDC', 'Score']
    
    # 存储所有运行的结果
    all_netlists = []
    all_metrics = []
    all_conversations = []

    
    with open(csv_path, 'w', newline='', encoding='utf-8-sig') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()

        # 构建参数
        agent_kwargs = {
            "api_key": args.api_key,
            "base_url": args.base_url,
            "temperature": args.temperature
        }
        
        # 创建控制器实例
        controller = AmpDesignController(
            model_name=args.model_name,
            **agent_kwargs
        )
        
        # 运行指定次数的设计
        for run_id in range(args.num_runs):
            logger.info(f"开始第 {run_id + 1}/{args.num_runs} 次运行")
            controller.conversation_history = []
            try:
                # 运行优化设计并获取结果
                netlist, results, conversation = controller.optimize_design(
                    max_iterations=args.max_iterations
                )
                
                                
                # 存储结果
                all_netlists.append(netlist)
                all_metrics.append(results)
                all_conversations.append(conversation)

                # 保存这次运行的结果
                save_results(run_id + 1, netlist, results, conversation, 
                            results_dir, writer, all_metrics)
                
                logger.info(f"第 {run_id + 1} 次运行完成")
                
            except Exception as e:
                logger.error(f"第 {run_id + 1} 次运行发生错误: {str(e)}", exc_info=True)
                continue
        
        # 保存最佳网表
        save_best_netlist(results_dir, all_netlists, all_metrics, all_conversations)

if __name__ == "__main__":
    main()
