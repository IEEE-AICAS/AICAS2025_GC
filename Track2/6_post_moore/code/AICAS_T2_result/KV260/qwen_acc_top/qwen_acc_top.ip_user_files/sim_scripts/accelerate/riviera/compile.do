transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xilinx_vip
vlib riviera/xpm
vlib riviera/xil_defaultlib
vlib riviera/axis_infrastructure_v1_1_1
vlib riviera/axis_data_fifo_v2_0_11
vlib riviera/xlconcat_v2_1_5
vlib riviera/gigantic_mux

vmap xilinx_vip riviera/xilinx_vip
vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib
vmap axis_infrastructure_v1_1_1 riviera/axis_infrastructure_v1_1_1
vmap axis_data_fifo_v2_0_11 riviera/axis_data_fifo_v2_0_11
vmap xlconcat_v2_1_5 riviera/xlconcat_v2_1_5
vmap gigantic_mux riviera/gigantic_mux

vlog -work xilinx_vip  -l axi_vip_v1_1_15 -l smartconnect_v1_0 -l zynq_ultra_ps_e_vip_v1_0_15 "+incdir+E:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axis_infrastructure_v1_1_1 -l axis_data_fifo_v2_0_11 -l xlconcat_v2_1_5 -l gigantic_mux \
"E:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"E:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"E:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"E:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"E:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"E:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"E:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"E:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"E:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -l axi_vip_v1_1_15 -l smartconnect_v1_0 -l zynq_ultra_ps_e_vip_v1_0_15 "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/434f/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ec67/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/2fcd/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/f0b6/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/35de/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/e2ba/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/a29c/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ae90/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/0e59/hdl/verilog" "+incdir+E:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axis_infrastructure_v1_1_1 -l axis_data_fifo_v2_0_11 -l xlconcat_v2_1_5 -l gigantic_mux \
"E:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"E:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  \
"E:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/434f/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ec67/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/2fcd/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/f0b6/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/35de/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/e2ba/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/a29c/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ae90/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/0e59/hdl/verilog" "+incdir+E:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axis_infrastructure_v1_1_1 -l axis_data_fifo_v2_0_11 -l xlconcat_v2_1_5 -l gigantic_mux \
"../../../bd/accelerate/ip/accelerate_zynq_ultra_ps_e_0_0/accelerate_zynq_ultra_ps_e_0_0_sim_netlist.v" \
"e:/Desktop/LLM/competition/FPGA_GC/KV260/qwen_acc_top/qwen_acc_top.gen/sources_1/bd/accelerate/ip/accelerate_gemv_float_q8_0_0/accelerate_gemv_float_q8_0_0_sim_netlist.v" \
"../../../bd/accelerate/ip/accelerate_axi_dma_0_0/accelerate_axi_dma_0_0_sim_netlist.v" \

vlog -work axis_infrastructure_v1_1_1  -v2k5 "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/434f/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ec67/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/2fcd/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/f0b6/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/35de/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/e2ba/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/a29c/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ae90/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/0e59/hdl/verilog" "+incdir+E:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axis_infrastructure_v1_1_1 -l axis_data_fifo_v2_0_11 -l xlconcat_v2_1_5 -l gigantic_mux \
"../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/434f/hdl/axis_infrastructure_v1_1_vl_rfs.v" \

vlog -work axis_data_fifo_v2_0_11  -v2k5 "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/434f/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ec67/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/2fcd/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/f0b6/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/35de/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/e2ba/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/a29c/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ae90/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/0e59/hdl/verilog" "+incdir+E:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axis_infrastructure_v1_1_1 -l axis_data_fifo_v2_0_11 -l xlconcat_v2_1_5 -l gigantic_mux \
"../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/68dc/hdl/axis_data_fifo_v2_0_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/434f/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ec67/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/2fcd/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/f0b6/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/35de/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/e2ba/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/a29c/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ae90/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/0e59/hdl/verilog" "+incdir+E:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axis_infrastructure_v1_1_1 -l axis_data_fifo_v2_0_11 -l xlconcat_v2_1_5 -l gigantic_mux \
"../../../bd/accelerate/ip/accelerate_axis_data_fifo_0_0/sim/accelerate_axis_data_fifo_0_0.v" \
"../../../bd/accelerate/ip/accelerate_xbar_0/accelerate_xbar_0_sim_netlist.v" \
"../../../bd/accelerate/ip/accelerate_rst_ps8_0_99M_0/accelerate_rst_ps8_0_99M_0_sim_netlist.v" \
"../../../bd/accelerate/ip/accelerate_axi_smc_0/accelerate_axi_smc_0_sim_netlist.v" \
"../../../bd/accelerate/ip/accelerate_axi_dma_0_1/accelerate_axi_dma_0_1_sim_netlist.v" \
"../../../bd/accelerate/ip/accelerate_axis_data_fifo_1_0/sim/accelerate_axis_data_fifo_1_0.v" \
"../../../bd/accelerate/ip/accelerate_axis_data_fifo_0_1/sim/accelerate_axis_data_fifo_0_1.v" \

vlog -work xlconcat_v2_1_5  -v2k5 "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/434f/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ec67/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/2fcd/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/f0b6/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/35de/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/e2ba/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/a29c/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ae90/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/0e59/hdl/verilog" "+incdir+E:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axis_infrastructure_v1_1_1 -l axis_data_fifo_v2_0_11 -l xlconcat_v2_1_5 -l gigantic_mux \
"../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/147b/hdl/xlconcat_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/434f/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ec67/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/2fcd/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/f0b6/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/35de/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/e2ba/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/a29c/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ae90/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/0e59/hdl/verilog" "+incdir+E:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axis_infrastructure_v1_1_1 -l axis_data_fifo_v2_0_11 -l xlconcat_v2_1_5 -l gigantic_mux \
"../../../bd/accelerate/ip/accelerate_xlconcat_0_0/sim/accelerate_xlconcat_0_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/sim/bd_591a.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_0/sim/bd_591a_ila_lib_0.v" \

vlog -work gigantic_mux  -v2k5 "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/434f/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ec67/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/2fcd/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/f0b6/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/35de/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/e2ba/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/a29c/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ae90/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/0e59/hdl/verilog" "+incdir+E:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axis_infrastructure_v1_1_1 -l axis_data_fifo_v2_0_11 -l xlconcat_v2_1_5 -l gigantic_mux \
"../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/e87a/hdl/gigantic_mux_v1_0_cntr.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/434f/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ec67/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/2fcd/hdl" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/f0b6/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/35de/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/e2ba/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/a29c/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/ae90/hdl/verilog" "+incdir+../../../../qwen_acc_top.gen/sources_1/bd/accelerate/ipshared/0e59/hdl/verilog" "+incdir+E:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axis_infrastructure_v1_1_1 -l axis_data_fifo_v2_0_11 -l xlconcat_v2_1_5 -l gigantic_mux \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_1/bd_591a_g_inst_0_gigantic_mux.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_1/sim/bd_591a_g_inst_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_2/sim/bd_591a_slot_0_aw_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_3/sim/bd_591a_slot_0_w_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_4/sim/bd_591a_slot_0_b_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_5/sim/bd_591a_slot_0_ar_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_6/sim/bd_591a_slot_0_r_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_7/sim/bd_591a_slot_1_aw_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_8/sim/bd_591a_slot_1_w_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_9/sim/bd_591a_slot_1_b_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_10/sim/bd_591a_slot_1_ar_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_11/sim/bd_591a_slot_1_r_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_12/sim/bd_591a_slot_2_aw_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_13/sim/bd_591a_slot_2_w_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_14/sim/bd_591a_slot_2_b_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_15/sim/bd_591a_slot_2_ar_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_16/sim/bd_591a_slot_2_r_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_17/sim/bd_591a_slot_3_aw_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_18/sim/bd_591a_slot_3_w_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_19/sim/bd_591a_slot_3_b_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_20/sim/bd_591a_slot_3_ar_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/bd_0/ip/ip_21/sim/bd_591a_slot_3_r_0.v" \
"../../../bd/accelerate/ip/accelerate_system_ila_0_0/sim/accelerate_system_ila_0_0.v" \
"../../../bd/accelerate/ip/accelerate_auto_ds_0/accelerate_auto_ds_0_sim_netlist.v" \
"../../../bd/accelerate/ip/accelerate_auto_pc_0/accelerate_auto_pc_0_sim_netlist.v" \
"../../../bd/accelerate/ip/accelerate_auto_ds_1/accelerate_auto_ds_1_sim_netlist.v" \
"../../../bd/accelerate/ip/accelerate_auto_pc_1/accelerate_auto_pc_1_sim_netlist.v" \
"../../../bd/accelerate/sim/accelerate.v" \

vlog -work xil_defaultlib \
"glbl.v"

