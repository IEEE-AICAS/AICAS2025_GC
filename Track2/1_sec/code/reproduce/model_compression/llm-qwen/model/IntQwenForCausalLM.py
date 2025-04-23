from typing import Optional, Union
import os
from transformers.models.llama.modeling_llama import LlamaConfig, PreTrainedModel, LlamaForCausalLM
from transformers import AutoConfig, AutoModel, AutoModelForCausalLM
from transformers import PretrainedConfig
from model.int_qwen import replace_decoders, replace_norm, replace_lm_head
import torch

class IntQwenConfig(LlamaConfig):

    model_type = "int_qwen"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.quantize              = kwargs.get("quantize",     True            )
        self.model_name            = kwargs.get("model_name",   "Qwen/Qwen2.5-0.5B-Instruct" )
        

class IntQwenForCausalLM(PreTrainedModel):

    config_class = IntQwenConfig

    def __init__(self, config):
        super().__init__(config)
        # get current rank
        rank = torch.distributed.get_rank() if torch.distributed.is_initialized() else 0
        device = f"cuda:{rank}"
        
        self.model = AutoModelForCausalLM.from_pretrained(
            config.model_name,
            torch_dtype="auto",
            device_map="auto"
        )
        if config.quantize:
            print("Replacing with integer-only decoders")
            replace_decoders (self.model, device)
            replace_norm     (self.model, device)
            replace_lm_head  (self.model, device)
        else:
            print("Use float decoders")
        
    def forward(self, *args, **kwargs):
        with torch.no_grad():
            return self.model(*args, **kwargs)
    
    @classmethod
    def from_pretrained(
        cls,
        pretrained_model_name_or_path: Optional[Union[str, os.PathLike]],
        *model_args,
        config: Optional[Union[PretrainedConfig, str, os.PathLike]] = None,
        cache_dir: Optional[Union[str, os.PathLike]] = None,
        ignore_mismatched_sizes: bool = False,
        force_download: bool = False,
        local_files_only: bool = False,
        token: Optional[Union[str, bool]] = None,
        revision: str = "main",
        use_safetensors: bool = None,
        **kwargs,
    ):
        return IntQwenForCausalLM(config)
    
    def generate(self, *args, **kwargs):
        return self.model.generate(*args, **kwargs)
    
        
# crucial for AutoModel!
AutoConfig.register("int_qwen", IntQwenConfig)
AutoModelForCausalLM.register(IntQwenConfig, IntQwenForCausalLM)

# also crucial!
IntQwenConfig.register_for_auto_class()
IntQwenForCausalLM.register_for_auto_class()
