vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/blk_mem_gen_v8_4_9
vlib modelsim_lib/msim/xil_defaultlib

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xpm modelsim_lib/msim/xpm
vmap blk_mem_gen_v8_4_9 modelsim_lib/msim/blk_mem_gen_v8_4_9
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

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
"/home/adnepukan/vitis/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93  \
"/home/adnepukan/vitis/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_4_9 -64 -incr -mfcu  "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/ip/blk_mem_gen_asup/sim/blk_mem_gen_asup.v" \

vlog -work xil_defaultlib \
"glbl.v"

