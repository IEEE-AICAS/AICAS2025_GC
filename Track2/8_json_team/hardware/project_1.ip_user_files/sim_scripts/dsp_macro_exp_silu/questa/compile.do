vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/xpm
vlib questa_lib/msim/xbip_dsp48_wrapper_v3_0_6
vlib questa_lib/msim/xbip_utils_v3_0_14
vlib questa_lib/msim/xbip_pipe_v3_0_10
vlib questa_lib/msim/dsp_macro_v1_0_7
vlib questa_lib/msim/xil_defaultlib

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap xpm questa_lib/msim/xpm
vmap xbip_dsp48_wrapper_v3_0_6 questa_lib/msim/xbip_dsp48_wrapper_v3_0_6
vmap xbip_utils_v3_0_14 questa_lib/msim/xbip_utils_v3_0_14
vmap xbip_pipe_v3_0_10 questa_lib/msim/xbip_pipe_v3_0_10
vmap dsp_macro_v1_0_7 questa_lib/msim/dsp_macro_v1_0_7
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xilinx_vip -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"/home/adnepukan/vitis/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93  \
"/home/adnepukan/vitis/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xbip_dsp48_wrapper_v3_0_6 -64 -93  \
"../../../ipstatic/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work xbip_utils_v3_0_14 -64 -93  \
"../../../ipstatic/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_10 -64 -93  \
"../../../ipstatic/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work dsp_macro_v1_0_7 -64 -93  \
"../../../ipstatic/hdl/dsp_macro_v1_0_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../../project_1.gen/sources_1/ip/dsp_macro_exp_silu/sim/dsp_macro_exp_silu.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

