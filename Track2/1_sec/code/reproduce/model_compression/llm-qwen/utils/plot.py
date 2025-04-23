import os
import numpy as np
import json
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick


# set dpi
plt.rcParams['figure.dpi'] = 300
# set font
plt.rcParams['font.sans-serif'] = ['Arial']

case_names = os.listdir("logs")
print(case_names)

if not os.path.exists("figs"):
    os.mkdir("figs")

all_metrics = {}
for case_name in case_names:
    result_path = os.path.join("logs", case_name, "result.json")
    if not os.path.exists(result_path):
        print(f"result file not found: {result_path}")
        continue
    with open(result_path) as f:
        result = json.load(f)["results"]
    
    # the matrics that we care about
    metrics = {
        "arc_challenge": result["arc_challenge"]["acc_norm,none"],
        "arc_easy": result["arc_easy"]["acc_norm,none"],
        "gsm8k_5shot": result["gsm8k"]["exact_match,strict-match"],
        "hellaswag": result["hellaswag"]["acc_norm,none"],
        "lambada": result["lambada"]["acc,none"],
        "truthfulqa": result["truthfulqa"]["acc,none"],
        "wikitext": result["wikitext"]["word_perplexity,none"],
        "winogrande": result["winogrande"]["acc,none"]
    }
    
    all_metrics[case_name] = metrics


def plot(_selected_case_names, _selected_metric_keys, topic):
    # 开始绘图
    fig, ax = plt.subplots()

    # 设置每个 case_name 的柱状图颜色和偏移
    # colors = plt.cm.plasma(np.linspace(0, 0.7, len(_selected_case_names)))
    colors = plt.cm.viridis(np.linspace(0, 0.7, len(_selected_case_names)))
    offset = np.linspace(-0.2, 0.2, len(_selected_case_names))  # 根据 case_name 数量调整偏移量

    # 绘制每个指标对应的所有 case_name 的值
    for i, case_name in enumerate(_selected_case_names):
        metric_values = [all_metrics[case_name].get(metric, 0) / all_metrics["float"].get(metric, 1) for metric in _selected_metric_keys]
        ax.bar(np.arange(len(_selected_metric_keys)) + offset[i], metric_values, color=colors[i], width=0.1, label=case_name)
    
    # 将float的值放到对应的bar的上面
    metric_values = [all_metrics["float"].get(metric, 1) for metric in _selected_metric_keys]
    for j, metric_value in enumerate(metric_values):
        ax.text(j, 1.07, f"{metric_value:.2f}", ha='center', va='bottom')

    # 设置标题、标签和图例
    ax.set_title('Metric Comparison Across Different Cases')
    ax.set_xticks(np.arange(len(_selected_metric_keys)))
    ax.set_xticklabels(_selected_metric_keys, rotation=45)
    ax.set_xlabel('Metric')
    ax.set_ylabel('Ratio to "float16"')
    # set y range
    ax.set_ylim(0.75, 1.1)
    ax.yaxis.set_major_formatter(mtick.PercentFormatter(1.0))
    ax.legend(loc='upper left', bbox_to_anchor=(1, 1))

    # 调整布局并显示图表
    plt.title(topic)
    plt.tight_layout()
    # plt.show()
    plt.savefig("figs/" + topic + ".png")



if __name__ == "__main__":
    selected_metric_keys = {
        "arc_challenge",
        # "arc_easy",
        "gsm8k_5shot",
        "hellaswag",
        "lambada",
        # "truthfulqa",
        "wikitext",
        "winogrande",
    }

    # smoothing impact
    # smoothing_impact_names = [
    #     "float",
    #     "w8c_a8t",
    #     "w8c_a8t_sm",
    #     "w4g_a8g_g32",
    #     "w4g_a8g_g32_sm",
    # ]


    # # per-group size impact
    # group_impact_case_names = [
    #     "float",
    #     "w8c_a8t",
    #     # "w8g_a8g_g128",
    #     "w8g_a8g_g32",
    #     "w4c_a8t",
    #     "w4g_a8g_g128",
    #     "w4g_a8g_g32",
    # ]
    # plot(smoothing_impact_names, selected_metric_keys, "smoothing_impact")
    # plot(group_impact_case_names, selected_metric_keys, "group_impact")
    
    # quantize impact
    quantize_impact_case_names = [
        "float",
        "w4g_a6g_g32",
    ]
    plot(quantize_impact_case_names, selected_metric_keys, "quantize_impact")
    