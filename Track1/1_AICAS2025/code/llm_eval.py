from transformers import AutoTokenizer, AutoConfig
from lm_eval.models.huggingface import HFLM
from lm_eval import simple_evaluate, evaluate
from lm_eval import tasks

import MNN.llm as mnnllm
import torch
import json
import os
import glob
import copy
import argparse

class Result:
    def __init__(self, lm_logits):
        self.logits = lm_logits

class Qwen:
    def __init__(self, model_path):
        self.config = None
        self.device = 'cpu'
        qwen = mnnllm.create(model_path)
        qwen.load()
        qwen.set_config({'all_logits': True, 'use_template': False})
        self.model = qwen
        self.tokenizer = AutoTokenizer.from_pretrained('/root/model/Qwen2.5-0.5B-Instruct/models--Qwen--Qwen2.5-0.5B-Instruct/snapshots/7ae557604adf67be50417f59c2c2f167def9a775', trust_remote_code=True)

    def tie_weights(self):
        pass

    def eval(self):
        pass

    def __call__(self, inp: torch.Tensor):
        lm_logits_list = []
        for ids in inp:
            ids_list = ids.tolist()
            logits = self.model.forward(ids_list)
            npy_logits = copy.deepcopy(logits.read())
            torch_logits = torch.from_numpy(npy_logits)
            lm_logits_list.append(torch_logits)
        lm_logits = torch.concat(lm_logits_list, axis=0)
        return Result(lm_logits)

def llm_eval(model, tokenizer, folder_name):
    print('### start eval ... ', folder_name)
    lm = HFLM(pretrained=model, tokenizer=tokenizer, batch_size=1, device="cpu", trust_remote_code=True)
    results = simple_evaluate(model=lm, tasks=["arc_challenge","hellaswag","ceval-valid"], batch_size=1)
    # results = simple_evaluate(model=lm, tasks=["arc_challenge"], batch_size=1)
    # 将results中的数据导出到json文件中
    filtered_results = results.copy()
    filtered_results = {key: value for key, value in results.items() if key == "results"}
    json_filtered_results = json.dumps(filtered_results, indent=4)
    result_filename = f"results_{folder_name}.json"
    print(result_filename)
    with open(result_filename, "w") as json_file:
        json_file.write(json_filtered_results)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='mnn-llm', formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('--model_path', type=str, default='/root/MNN/transformers/llm/export/4bit_channel/config.json', required=False, help='path(`str` or `os.PathLike`)')
    parser.add_argument('--token_path', type=str, default='/root/Qwen2.5-0.5B-Instruct', required=False, help='path(`str` or `os.PathLike`)')
    args = parser.parse_args()
    tokenizer = AutoTokenizer.from_pretrained(args.token_path, trust_remote_code=True)
    config = AutoConfig.from_pretrained(args.token_path, trust_remote_code=True)
    model = Qwen(args.model_path)
    model.config = config
    folder_name = os.path.basename(os.path.dirname(args.model_path))
    llm_eval(model, tokenizer, folder_name)
