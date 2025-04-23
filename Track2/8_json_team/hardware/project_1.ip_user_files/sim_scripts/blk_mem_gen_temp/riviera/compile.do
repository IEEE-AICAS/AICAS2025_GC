transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xilinx_vip
vlib riviera/xpm
vlib riviera/blk_mem_gen_v8_4_9
vlib riviera/xil_defaultlib

vmap xilinx_vip riviera/xilinx_vip
vmap xpm riviera/xpm
vmap blk_mem_gen_v8_4_9 riviera/blk_mem_gen_v8_4_9
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xilinx_vip  -incr -l axi_vip_v1_1_19 -l smartconnect_v1_0 -l zynq_ultra_ps_e_vip_v1_0_19 "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l blk_mem_gen_v8_4_9 -l xil_defaultlib \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -l axi_vip_v1_1_19 -l smartconnect_v1_0 -l zynq_ultra_ps_e_vip_v1_0_19 "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l blk_mem_gen_v8_4_9 -l xil_defaultlib \
"/home/adnepukan/vitis/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"/home/adnepukan/vitis/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_4_9  -incr -v2k5 "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l blk_mem_gen_v8_4_9 -l xil_defaultlib \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l blk_mem_gen_v8_4_9 -l xil_defaultlib \
"../../../../project_1.gen/sources_1/ip/blk_mem_gen_temp/sim/blk_mem_gen_temp.v" \

vlog -work xil_defaultlib \
"glbl.v"

