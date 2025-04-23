

import torch
import torch.nn as nn
from transformers import AutoTokenizer, AutoModelForCausalLM
from smoothquant.smooth import smooth_lm
from smoothquant.fake_quant import quantize_qwen2
import tqdm
from datasets import load_dataset
import random


class Evaluator:
    def __init__(self, dataset, tokenizer, device, n_samples=40):
        self.dataset = dataset
        self.tokenizer = tokenizer
        self.device = device
        # random.shuffle(self.dataset["text"])
        self.dataset = tokenizer(
            "\n\n".join(dataset["text"]), return_tensors="pt",max_length=130000,truncation=True#模型最大长度，这里截断一下
        ).input_ids.to(device)

        self.n_samples = n_samples

    @torch.no_grad()
    def evaluate(self, model):
        model.eval()
        nlls = []
        n_samples = self.n_samples if self.n_samples else self.dataset.size(1) // 2048
        # print(n_samples)
        for i in tqdm.tqdm(range(n_samples), desc="Evaluating..."):
            batch = self.dataset[:, (i * 2048) : ((i + 1) * 2048)].to(model.device)
            with torch.no_grad():
                lm_logits = model(batch).logits
            shift_logits = lm_logits[:, :-1, :].contiguous().float()
            shift_labels = self.dataset[:, (i * 2048) : ((i + 1) * 2048)][:, 1:]
            loss_fct = nn.CrossEntropyLoss()
            loss = loss_fct(
                shift_logits.view(-1, shift_logits.size(-1)), shift_labels.view(-1)
            )
            neg_log_likelihood = loss.float() * 2048
            nlls.append(neg_log_likelihood)

        return torch.exp(torch.stack(nlls).sum() / (n_samples * 2048))


model_path = "Qwen/Qwen2.5-0.5B-Instruct"
act_scales_path = "act_scales/Qwen2.5-0.5B.pt"
alpha=0.85
tokenizer = AutoTokenizer.from_pretrained(model_path)
dataset = load_dataset("Salesforce/wikitext", "wikitext-2-raw-v1",split="test")
evaluator = Evaluator(dataset, tokenizer, "cuda",n_samples=None)

model = AutoModelForCausalLM.from_pretrained(
    model_path, torch_dtype=torch.bfloat16, device_map="auto"
)

act_scales = torch.load(act_scales_path)
smooth_lm(model, act_scales, alpha)#smooth之后再量化
model = quantize_qwen2(
        model,
        weight_quant="per_channel",
        act_quant="per_token",
        quantize_bmm_input=True,
        mode="W8A8"
    )
# ppl = evaluator.evaluate(model)
model.save_pretrained("Qwen/Qwen2.5-0.5B-Instruct-quant")
# print(f"Perplexity: {ppl}")