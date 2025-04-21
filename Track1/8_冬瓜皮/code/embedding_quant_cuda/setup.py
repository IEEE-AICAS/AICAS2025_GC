from setuptools import setup
from torch.utils.cpp_extension import BuildExtension, CUDAExtension

setup(
    name='embedding_quant_cuda',
    ext_modules=[
        CUDAExtension(
            name='embedding_quant_cuda',
            sources=['omse.cu', 'binding.cpp'],
            include_dirs=['/home/gaoithe/.conda/envs/llm/lib/python3.9/site-packages/torch/include'],  # 指定 PyTorch 头文件路径
            library_dirs=['/home/gaoithe/.conda/envs/llm/lib/python3.9/site-packages/torch/lib'],  # 指定 PyTorch 库路径
            extra_compile_args={'nvcc': ['-arch=sm_86']}
        ),
    ],
    cmdclass={
        'build_ext': BuildExtension
    }
)
