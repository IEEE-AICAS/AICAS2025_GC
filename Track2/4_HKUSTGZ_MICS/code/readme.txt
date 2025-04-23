This is the readme to evaluate the result of AICAS 2025 for raceway 2 in first round. Our team is HKUSTGZ_MICS.

The pynq_api is in 
"PYNQ/pynq_api.zip"
We should run these to install it:
cd /PYNQ/
unzip ./pynq_api.zip
cd ./pynq_api
sudo make all
sudo make install

And the quantization file is in this path.
"Qwen2.5-0.5B-Instruct-runq.bin"

To evaluate the accuracy, we can run
make acc_eva_s_float_xw_prefill

To evaluate the throughput, we can run
make thpt_eva_runq_xw_prefill

To evaluate the compression rate, we can run 
make comp_eva
"/root/jupyter_notebooks/AICAS/Qwen2.5-0.5B-Instruct-runq.bin"
