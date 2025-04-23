import torch
import torch.nn as nn
import tqdm
import matplotlib.pyplot as plt
import os
import torch
import torch.nn as nn
import tqdm

class Evaluator:
    def __init__(self, dataset, tokenizer, n_samples=160):
        self.dataset = dataset
        self.tokenizer = tokenizer

        self.dataset = tokenizer("\n\n".join(dataset["text"]), return_tensors="pt").input_ids
        self.n_samples = n_samples

    @torch.no_grad()
    def evaluate(self, model, device):
        model.eval()
        total_neg_log_likelihood = 0.0
        total_tokens = 0
        # move dataset to the same device as the model
        self.dataset = self.dataset.to(device)
        
        progress_bar = tqdm.tqdm(range(self.n_samples), desc="Evaluating...")
        for i in progress_bar:
            batch = self.dataset[:, (i * 2048) : ((i + 1) * 2048)].to(device)
            with torch.no_grad():
                lm_logits = model(batch).logits
            shift_logits = lm_logits[:, :-1, :].contiguous().float()
            shift_labels = self.dataset[:, (i * 2048) : ((i + 1) * 2048)][:, 1:]
            loss_fct = nn.CrossEntropyLoss(reduction='sum')
            loss = loss_fct(shift_logits.view(-1, shift_logits.size(-1)), shift_labels.view(-1))
            
            total_neg_log_likelihood += loss.item()
            total_tokens += shift_labels.numel()

            current_ppl = torch.exp(torch.tensor(total_neg_log_likelihood / total_tokens))
            progress_bar.set_description(f"Evaluating... (Current PPL: {current_ppl.item():.4f})")

        final_ppl = torch.exp(torch.tensor(total_neg_log_likelihood / total_tokens))
        return final_ppl

def minmax(tensor):
    min_val = tensor.min().item()  # 获取最小值并转换为 Python 标量
    max_val = tensor.max().item()  # 获取最大值并转换为 Python 标量
    return (min_val, max_val)

def bits(_t):
    bits = 1
    _t_min = _t.min()
    _t_max = _t.max()
    while True:
        q_min = -2**(bits-1)
        q_max = +2**(bits-1) - 1
        if _t_min < q_min or _t_max > q_max:
            bits += 1
        else:
            break
    return bits

def print_tensor(x, num=10, info=""):
    print("**************************************print tensor**************************************")
    print(f"{info:30s} shape: {x.shape}, dtype: {x.dtype}, min: {x.min().item()}, max: {x.max().item()}, {x.flatten()[:num].tolist()}")
    print("****************************************************************************************")


def compare_tensor(_x, _y, info=""):
    # apply data type promotion
    _x = _x.squeeze()
    _y = _y.squeeze()
    print("--------------------------------------compare tensor--------------------------------------")
    num = 10

    formatted_x = [f"{__x:8d}" for __x in _x.flatten()[:num]]
    formatted_y = [f"{__y:8d}" for __y in _y.flatten()[:num]]
    print(f"{info:30s} shape: {_x.shape}, min_x: {_x.min().item():.5e}, max_x: {_x.max().item():.5e}, elems: {formatted_x}")
    print(f"{info:30s} shape: {_y.shape}, min_y: {_y.min().item():.5e}, max_y: {_y.max().item():.5e}, elems: {formatted_y}")
    # compute average abs diff ratio
    diff = torch.abs(_x - _y)
    avg_diff = diff.double().mean().item()
    avg_x = torch.abs(_x).double().mean().item()
    avg_y = torch.abs(_y).double().mean().item()
    allclose = torch.allclose(_x, _y, rtol=1e-3)
    print(f"{info:30s}      Average diff: {avg_diff:.4f},           Average x: {avg_x:.4f},             Average y:{avg_y:.4f},            allclose: {allclose}")
    assert allclose
    print("------------------------------------------------------------------------------------------")
    

    
def copy_tensor(t):
    if isinstance(t, torch.Tensor):
        return t.clone().detach()
    elif isinstance(t, (list, tuple)):
        return [copy_tensor(x) for x in t]
    




def capture_dut(_model, _tokenizer, _device):
    # check output decoder by decoder
    # use register_forward_hook to get the tensor value
    layers = _model.model.layers

    # remove all hooks
    for m in _model.modules():
        m._forward_hooks.clear()
        
    # reference modules with names
    name2m = {l: dict() for l in range(len(layers))} 
    for l, layer in enumerate(layers):
        name2m[l][f"MHA"]           = layer.MHA
        name2m[l][f"MLP"]           = layer.MLP
        name2m[l][f"MHA.rmsnorm"]   = layer.MHA.rmsnorm
        name2m[l][f"MHA.rope"]      = layer.MHA.rotary_emb
        name2m[l][f"MHA.softmax"]   = layer.MHA.softmax
        name2m[l][f"MLP.rmsnorm"]   = layer.MLP.rmsnorm
        name2m[l][f"MLP.silu"]      = layer.MLP.silu

    # reference head
    cls_decoder_id = len(layers)
    print(f"cls_decoder_id: {cls_decoder_id}")
    name2m[cls_decoder_id] = dict()
    name2m[cls_decoder_id][f"CLS.rmsnorm"] = _model.model.norm
    name2m[cls_decoder_id][f"CLS.lm_head"] = _model.lm_head

    # global variable for capturing all tensor values with hooks
    tensor_values = {l: dict() for l in range(len(_model.model.layers)+1)}
    def hook_fn(_l, _name):
        def _hook_fn(m, args, kwargs, output):
            tensor_values[_l][_name] = {
                "args":     copy_tensor(args),
                "kwargs":   copy_tensor(kwargs),
                "output":   copy_tensor(output)
            }
        
        return _hook_fn

    # register hooks
    for l in range(len(layers)+1):
        for hookname, m in name2m[l].items():
            m.register_forward_hook(hook_fn(l, hookname), with_kwargs=True)
        
    # prepare input and do inference
    input_text = open("/usr/include/stdio.h").read()
    input_ids = _tokenizer.encode(input_text, return_tensors="pt").to(_device)
    input_ids = input_ids[:, :128]
    _model(input_ids)

    # after calling, clear all hooks
    for l in range(len(layers)):
        for hookname, m in name2m[l].items():
            m._forward_hooks.clear()
            
    return tensor_values




def capture_ref(_model, _tokenizer, _device):
    # check output decoder by decoder
    # use register_forward_hook to get the tensor value
    layers = _model.model.layers

    # remove all hooks
    for m in _model.modules():
        m._forward_hooks.clear()
        
    # reference modules with names
    name2m = {l: dict() for l in range(len(layers))} 
    for l, layer in enumerate(layers):
        name2m[l][f"MHA"]           = layer.self_attn
        name2m[l][f"MLP"]           = layer.mlp

    # reference head
    cls_decoder_id = len(layers)
    print(f"cls_decoder_id: {cls_decoder_id}")
    name2m[cls_decoder_id] = dict()
    name2m[cls_decoder_id][f"CLS.rmsnorm"] = _model.model.norm
    name2m[cls_decoder_id][f"CLS.lm_head"] = _model.lm_head

    # global variable for capturing all tensor values with hooks
    tensor_values = {l: dict() for l in range(len(_model.model.layers)+1)}
    def hook_fn(_l, _name):
        def _hook_fn(m, args, kwargs, output):
            tensor_values[_l][_name] = {
                "args":     copy_tensor(args),
                "kwargs":   copy_tensor(kwargs),
                "output":   copy_tensor(output)
            }
        
        return _hook_fn

    # register hooks
    for l in range(len(layers)+1):
        for hookname, m in name2m[l].items():
            m.register_forward_hook(hook_fn(l, hookname), with_kwargs=True)
        
    # prepare input and do inference
    input_text = open("/usr/include/stdio.h").read()
    input_ids = _tokenizer.encode(input_text, return_tensors="pt").to(_device)
    input_ids = input_ids[:, :128]
    _model(input_ids)

    # after calling, clear all hooks
    for l in range(len(layers)):
        for hookname, m in name2m[l].items():
            m._forward_hooks.clear()
            
    return tensor_values



class plot_tensor_cls:
    def __init__(self):
        self.fig_number = 0
        self.path_prefix = "figs/plot_tensors/"
        os.makedirs(self.path_prefix, exist_ok=True)
        self.status = True
    
    def visualize_outlier(self, _x):
        # use 3 subplots
        _x = _x[:, :].float()
        threshold = 3 * torch.std(_x)
        _x_abs = torch.abs(_x)
        _x_abs[_x_abs < threshold] = 0
        # set fig
        fig = plt.figure(dpi=200, figsize=(24, 4))
        ax1 = fig.add_subplot(131, projection='3d')
        ax2 = fig.add_subplot(132)
        ax3 = fig.add_subplot(133)
        # set data
        x = torch.arange(_x.shape[0])
        y = torch.arange(_x.shape[1])
        X, Y = torch.meshgrid(x, y)
        Z = _x_abs
        # plot
        surf = ax1.plot_surface(X, Y, Z, cmap='coolwarm')
        ax1.set_zlabel('Value')
        ax1.set_xlabel('Token')
        ax1.set_ylabel('Channel')
        ax1.view_init(30, 5)
        fig.colorbar(surf, ax=ax1)
        # plot std
        std = torch.std(_x_abs, dim=-1)
        ax2.plot(std)
        ax2.set_title("Std of each token")
        ax2.set_xlabel("Token")
        ax2.set_ylabel("Std")
        # plot std
        std = torch.std(_x_abs, dim=0)
        ax3.plot(std)
        ax3.set_title("Std of each channel")
        ax3.set_xlabel("Channel")
        ax3.set_ylabel("Std")

    def __call__(self, x, decoder_id, tensor_name, mode=None):
        if not self.status:
            return
        
        fig_number = self.fig_number
        # make dir
        path_prefix = f"figs/plot_tensors/decoder_{decoder_id}/"
        os.makedirs(path_prefix, exist_ok=True)

        # different modes
        if mode is None:
            # single tensor
            assert isinstance(x, torch.Tensor)
            plt.hist(x.cpu().flatten().numpy(), bins=100)
            plt.title(f"Decoder {decoder_id} {tensor_name} histogram")
            file_name = f"Fig_{fig_number:02d}_{tensor_name}.png"
        elif mode == "multi":
            #  a list of tensors
            assert isinstance(x, list)
            ncols = len(x)
            fig, axs = plt.subplots(1, ncols)
            for i in range(ncols):
                axs[i].hist(x[i].cpu().flatten().numpy(), bins=100)
                axs[i].set_title(f"{tensor_name[i]}")
            file_name = f"Fig_{fig_number:02d}_{'_'.join(tensor_name)}.png"
        elif mode == "stacked":
            # should be a list of tensors
            assert isinstance(x, list)
            fig, ax = plt.subplots()
            for i in range(len(x)):
                ax.hist(x[i].cpu().flatten().numpy(), bins=100, alpha=0.5, label=tensor_name[i])
            ax.legend()
            file_name = f"Fig_{fig_number:02d}_{'_'.join(tensor_name)}.png"
        elif mode == "outlier":
            x = x.cpu()
            self.visualize_outlier(x)
            file_name = f"Fig_{fig_number:02d}_{tensor_name}.png"
        else:
            raise ValueError("Invalid mode")
        
        plt.savefig(os.path.join(path_prefix, file_name))
        plt.close()
        
        self.fig_number += 1