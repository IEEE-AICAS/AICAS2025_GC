import torch

def generate_rope_suparam(theta: float, seq_len: int, head_dim: int=64):
    seq_len_tensor=torch.arange(seq_len)    # [seq_len]
    theta_tensor=theta**(-torch.arange(0, head_dim, 2)/head_dim)    # [head_dim/2]
    seq_theta_tensor=seq_len_tensor.reshape((-1, 1))*theta_tensor.reshape((1, -1))  # [seq_len, head_dim/2]
    cos_tensor=torch.cos(seq_theta_tensor).t()  # [head_dim/2, seq_len]
    sin_tensor=torch.sin(seq_theta_tensor).t()  # [head_dim/2, seq_len]
    return torch.concat((cos_tensor.unsqueeze(dim=1), sin_tensor.unsqueeze(dim=1)), dim=1).flatten(0, 1)   # [head_dim, seq_len]

def reshape_rope_suparam(rope: torch.Tensor, align_size: int=32, param=1):
    # input: [head_dim, seq_len]
    # output: [(seq_len//32)*head_dim, seq_len]
    head_dim=rope.shape[0]
    seq_len=rope.shape[1]
    assert seq_len%32==0, "Sequence length must be a multiple of 32."
    return rope.reshape(head_dim, seq_len//32, 32).permute(1, 0, 2).flatten(0, 1).to(torch.float16)*param

def main():
    result=reshape_rope_suparam(generate_rope_suparam(1000000.0, 192, 64), 32, 896**(-0.25))
    print(result.shape)
    print(result)

if __name__ == '__main__':
    main()