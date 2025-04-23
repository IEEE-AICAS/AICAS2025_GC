# %% [markdown]
# # SmoothQuant on Llama 2 7B
# 
# In this notebook, we use Llama-2-7B model to demonstrate SmoothQuant can use 8-bit for both weights and activations to achieve the similar perplexity as FP16 models.

# %% [markdown]
# In order to run this notebook, you need to install the following packages:
# 
# - smoothquant
# - PyTorch
# - Transformers
# - Accelerate

# %%
import os

os.environ["CUDA_DEVICE_ORDER"] = "PCI_BUS_ID"
os.environ["CUDA_VISIBLE_DEVICES"] = "0"

import torch
import torch.nn as nn
from transformers.models.qwen2.modeling_qwen2 import (
    Qwen2Attention,
    Qwen2DecoderLayer,
    Qwen2ForCausalLM,
    Qwen2MLP
)
from transformers import LlamaTokenizer
from transformers import Qwen2Tokenizer
from smoothquant.smooth import smooth_lm
from smoothquant.fake_quant import quantize_llama_like
import tqdm

# %% [markdown]
# The following is an evaluator to see the performance of the model. We use a toy dataset (the first 40 examples in the test set of the Wikitext-2 dataset) to evaluate the model. You can replace it with your own dataset. The conclusion should be the same.

# %%
class Evaluator:
    def __init__(self, dataset, tokenizer, device, n_samples=40):
        self.dataset = dataset
        self.tokenizer = tokenizer
        self.device = device

        self.dataset = tokenizer(
            "\n\n".join(dataset["text"]), return_tensors="pt"
        ).input_ids.to(device)

        self.n_samples = n_samples

    @torch.no_grad()
    def evaluate(self, model):
        model.eval()
        nlls = []
        for i in tqdm.tqdm(range(self.n_samples), desc="Evaluating..."):
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

        return torch.exp(torch.stack(nlls).sum() / (self.n_samples * 2048))

# %%
from datasets import load_dataset

tokenizer = LlamaTokenizer.from_pretrained("meta-llama/Llama-2-7b-hf")
dataset = load_dataset('wikitext', 'wikitext-2-raw-v1', split='test')
evaluator = Evaluator(dataset, tokenizer, "cuda")

# %% [markdown]
# ## FP16 Model Perplexity

# %% [markdown]
# Let's first check the performance of the original FP16 model.

# %%
model_fp16 = LlamaForCausalLM.from_pretrained(
    "meta-llama/Llama-2-7b-hf", torch_dtype=torch.float16, device_map="auto"
)

# %%
ppl_fp16 = evaluator.evaluate(model_fp16)
print(f"Original model (fp16) perplexity: {ppl_fp16}")

# %% [markdown]
# We then quantize the model to W8A8 and check the performance.

# %% [markdown]
# ## Naive W8A8 Quantized Model Perplexity

# %%
model_w8a8 = quantize_llama_like(model_fp16)
print(model_w8a8)

# %%
ppl_w8a8 = evaluator.evaluate(model_w8a8)
print(f"Naive W8A8 quantized model perplexity: {ppl_w8a8}")

# %% [markdown]
# We can see there is a perplexity increase. We then use SmoothQuant to quantize the model and check the performance.

# %% [markdown]
# ## SmoothQuant W8A8 Quantized Model Perplexity

# %%
model = LlamaForCausalLM.from_pretrained(
    "meta-llama/Llama-2-7b-hf", torch_dtype=torch.float16, device_map="auto"
)
act_scales = torch.load("../act_scales/llama-2-7b.pt")
smooth_lm(model, act_scales, 0.85)
model_smoothquant_w8a8 = quantize_llama_like(model)
print(model_smoothquant_w8a8)

# %% [markdown]
# We can see the smoothed model has a lower perplexity which is close to the FP16 model's. This is because SmoothQuant smooths the outliers in activations and balances the quantization difficulty of activations and weights.

# %%
ppl_smoothquant_w8a8 = evaluator.evaluate(model_smoothquant_w8a8)
print(f"SmoothQuant W8A8 quantized model perplexity: {ppl_smoothquant_w8a8}")


