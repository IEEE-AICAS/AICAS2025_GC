transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xilinx_vip
vlib riviera/xpm
vlib riviera/xbip_dsp48_wrapper_v3_0_6
vlib riviera/xbip_utils_v3_0_14
vlib riviera/xbip_pipe_v3_0_10
vlib riviera/dsp_macro_v1_0_7
vlib riviera/xil_defaultlib

vmap xilinx_vip riviera/xilinx_vip
vmap xpm riviera/xpm
vmap xbip_dsp48_wrapper_v3_0_6 riviera/xbip_dsp48_wrapper_v3_0_6
vmap xbip_utils_v3_0_14 riviera/xbip_utils_v3_0_14
vmap xbip_pipe_v3_0_10 riviera/xbip_pipe_v3_0_10
vmap dsp_macro_v1_0_7 riviera/dsp_macro_v1_0_7
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xilinx_vip  -incr -l axi_vip_v1_1_19 -l smartconnect_v1_0 -l zynq_ultra_ps_e_vip_v1_0_19 "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xbip_dsp48_wrapper_v3_0_6 -l xbip_utils_v3_0_14 -l xbip_pipe_v3_0_10 -l dsp_macro_v1_0_7 -l xil_defaultlib \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -l axi_vip_v1_1_19 -l smartconnect_v1_0 -l zynq_ultra_ps_e_vip_v1_0_19 "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xbip_dsp48_wrapper_v3_0_6 -l xbip_utils_v3_0_14 -l xbip_pipe_v3_0_10 -l dsp_macro_v1_0_7 -l xil_defaultlib \
"/home/adnepukan/vitis/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"/home/adnepukan/vitis/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xbip_dsp48_wrapper_v3_0_6 -93  -incr \
"../../../ipstatic/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work xbip_utils_v3_0_14 -93  -incr \
"../../../ipstatic/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_10 -93  -incr \
"../../../ipstatic/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work dsp_macro_v1_0_7 -93  -incr \
"../../../ipstatic/hdl/dsp_macro_v1_0_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../../project_1.gen/sources_1/ip/dsp_macro_exp_silu/sim/dsp_macro_exp_silu.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

