vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/xpm
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_vip_v1_1_19
vlib questa_lib/msim/zynq_ultra_ps_e_vip_v1_0_19
vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/lib_pkg_v1_0_4
vlib questa_lib/msim/lib_srl_fifo_v1_0_4
vlib questa_lib/msim/fifo_generator_v13_2_11
vlib questa_lib/msim/lib_fifo_v1_0_20
vlib questa_lib/msim/lib_cdc_v1_0_3
vlib questa_lib/msim/axi_datamover_v5_1_35
vlib questa_lib/msim/axi_sg_v4_1_19
vlib questa_lib/msim/axi_cdma_v4_1_33
vlib questa_lib/msim/axi_bram_ctrl_v4_1_11
vlib questa_lib/msim/xlconstant_v1_1_9
vlib questa_lib/msim/proc_sys_reset_v5_0_16
vlib questa_lib/msim/smartconnect_v1_0
vlib questa_lib/msim/axi_register_slice_v2_1_33

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap xpm questa_lib/msim/xpm
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_19 questa_lib/msim/axi_vip_v1_1_19
vmap zynq_ultra_ps_e_vip_v1_0_19 questa_lib/msim/zynq_ultra_ps_e_vip_v1_0_19
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap lib_pkg_v1_0_4 questa_lib/msim/lib_pkg_v1_0_4
vmap lib_srl_fifo_v1_0_4 questa_lib/msim/lib_srl_fifo_v1_0_4
vmap fifo_generator_v13_2_11 questa_lib/msim/fifo_generator_v13_2_11
vmap lib_fifo_v1_0_20 questa_lib/msim/lib_fifo_v1_0_20
vmap lib_cdc_v1_0_3 questa_lib/msim/lib_cdc_v1_0_3
vmap axi_datamover_v5_1_35 questa_lib/msim/axi_datamover_v5_1_35
vmap axi_sg_v4_1_19 questa_lib/msim/axi_sg_v4_1_19
vmap axi_cdma_v4_1_33 questa_lib/msim/axi_cdma_v4_1_33
vmap axi_bram_ctrl_v4_1_11 questa_lib/msim/axi_bram_ctrl_v4_1_11
vmap xlconstant_v1_1_9 questa_lib/msim/xlconstant_v1_1_9
vmap proc_sys_reset_v5_0_16 questa_lib/msim/proc_sys_reset_v5_0_16
vmap smartconnect_v1_0 questa_lib/msim/smartconnect_v1_0
vmap axi_register_slice_v2_1_33 questa_lib/msim/axi_register_slice_v2_1_33

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

vlog -work xpm -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"/home/adnepukan/vitis/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"/home/adnepukan/vitis/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93  \
"/home/adnepukan/vitis/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0 -64 -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_19 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/8c45/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work zynq_ultra_ps_e_vip_v1_0_19 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl/zynq_ultra_ps_e_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_zynq_ultra_ps_e_0_0/sim/system_zynq_ultra_ps_e_0_0_vip_wrapper.v" \

vcom -work lib_pkg_v1_0_4 -64 -93  \
"../../../../project_1.gen/sources_1/bd/system/ipshared/8c68/hdl/lib_pkg_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_4 -64 -93  \
"../../../../project_1.gen/sources_1/bd/system/ipshared/1e5a/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vlog -work fifo_generator_v13_2_11 -64 -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/6080/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_11 -64 -93  \
"../../../../project_1.gen/sources_1/bd/system/ipshared/6080/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_11 -64 -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/6080/hdl/fifo_generator_v13_2_rfs.v" \

vcom -work lib_fifo_v1_0_20 -64 -93  \
"../../../../project_1.gen/sources_1/bd/system/ipshared/e160/hdl/lib_fifo_v1_0_rfs.vhd" \

vcom -work lib_cdc_v1_0_3 -64 -93  \
"../../../../project_1.gen/sources_1/bd/system/ipshared/2a4f/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work axi_datamover_v5_1_35 -64 -93  \
"../../../../project_1.gen/sources_1/bd/system/ipshared/4277/hdl/axi_datamover_v5_1_vh_rfs.vhd" \

vcom -work axi_sg_v4_1_19 -64 -93  \
"../../../../project_1.gen/sources_1/bd/system/ipshared/fc5d/hdl/axi_sg_v4_1_rfs.vhd" \

vcom -work axi_cdma_v4_1_33 -64 -93  \
"../../../../project_1.gen/sources_1/bd/system/ipshared/9d4d/hdl/axi_cdma_v4_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/system/ip/system_axi_cdma_0_0/sim/system_axi_cdma_0_0.vhd" \

vcom -work axi_bram_ctrl_v4_1_11 -64 -93  \
"../../../../project_1.gen/sources_1/bd/system/ipshared/df79/hdl/axi_bram_ctrl_v4_1_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/system/ip/system_axi_bram_ctrl_0_0/sim/system_axi_bram_ctrl_0_0.vhd" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ipshared/cdac/src/config_register_slave_lite_v1_0_S00_AXI.v" \
"../../../bd/system/ipshared/cdac/src/config_register.v" \
"../../../bd/system/ip/system_config_register_0_0/sim/system_config_register_0_0.v" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/sim/bd_44e3.v" \

vlog -work xlconstant_v1_1_9 -64 -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/e2d2/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_0/sim/bd_44e3_one_0.v" \

vcom -work proc_sys_reset_v5_0_16 -64 -93  \
"../../../../project_1.gen/sources_1/bd/system/ipshared/0831/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_1/sim/bd_44e3_psr_aclk_0.vhd" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/sc_util_v1_0_vl_rfs.sv" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/3718/hdl/sc_switchboard_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_2/sim/bd_44e3_arsw_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_3/sim/bd_44e3_rsw_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_4/sim/bd_44e3_awsw_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_5/sim/bd_44e3_wsw_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_6/sim/bd_44e3_bsw_0.sv" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/f49a/hdl/sc_mmu_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_7/sim/bd_44e3_s00mmu_0.sv" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/2da8/hdl/sc_transaction_regulator_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_8/sim/bd_44e3_s00tr_0.sv" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/63ed/hdl/sc_si_converter_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_9/sim/bd_44e3_s00sic_0.sv" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/cef3/hdl/sc_axi2sc_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_10/sim/bd_44e3_s00a2s_0.sv" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/sc_node_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_11/sim/bd_44e3_sarn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_12/sim/bd_44e3_srn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_13/sim/bd_44e3_sawn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_14/sim/bd_44e3_swn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_15/sim/bd_44e3_sbn_0.sv" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/7f4f/hdl/sc_sc2axi_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_16/sim/bd_44e3_m00s2a_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_17/sim/bd_44e3_m00arn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_18/sim/bd_44e3_m00rn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_19/sim/bd_44e3_m00awn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_20/sim/bd_44e3_m00wn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_21/sim/bd_44e3_m00bn_0.sv" \

vlog -work smartconnect_v1_0 -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/37bc/hdl/sc_exit_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_22/sim/bd_44e3_m00e_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_23/sim/bd_44e3_m01s2a_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_24/sim/bd_44e3_m01arn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_25/sim/bd_44e3_m01rn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_26/sim/bd_44e3_m01awn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_27/sim/bd_44e3_m01wn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_28/sim/bd_44e3_m01bn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_29/sim/bd_44e3_m01e_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_30/sim/bd_44e3_m02s2a_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_31/sim/bd_44e3_m02arn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_32/sim/bd_44e3_m02rn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_33/sim/bd_44e3_m02awn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_34/sim/bd_44e3_m02wn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_35/sim/bd_44e3_m02bn_0.sv" \
"../../../bd/system/ip/system_axi_smc_0/bd_0/ip/ip_36/sim/bd_44e3_m02e_0.sv" \

vlog -work axi_register_slice_v2_1_33 -64 -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/system/ipshared/3ee4/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_axi_smc_0/sim/system_axi_smc_0.v" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/system/ip/system_rst_ps8_0_99M_0/sim/system_rst_ps8_0_99M_0.vhd" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/sim/bd_2721.v" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_0/sim/bd_2721_one_0.v" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_1/sim/bd_2721_psr_aclk_0.vhd" \

vlog -work xil_defaultlib -64 -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_19 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_2/sim/bd_2721_arinsw_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_3/sim/bd_2721_rinsw_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_4/sim/bd_2721_awinsw_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_5/sim/bd_2721_winsw_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_6/sim/bd_2721_binsw_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_7/sim/bd_2721_aroutsw_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_8/sim/bd_2721_routsw_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_9/sim/bd_2721_awoutsw_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_10/sim/bd_2721_woutsw_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_11/sim/bd_2721_boutsw_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_12/sim/bd_2721_arni_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_13/sim/bd_2721_rni_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_14/sim/bd_2721_awni_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_15/sim/bd_2721_wni_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_16/sim/bd_2721_bni_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_17/sim/bd_2721_s00mmu_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_18/sim/bd_2721_s00tr_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_19/sim/bd_2721_s00sic_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_20/sim/bd_2721_s00a2s_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_21/sim/bd_2721_sarn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_22/sim/bd_2721_srn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_23/sim/bd_2721_sawn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_24/sim/bd_2721_swn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_25/sim/bd_2721_sbn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_26/sim/bd_2721_m00s2a_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_27/sim/bd_2721_m00arn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_28/sim/bd_2721_m00rn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_29/sim/bd_2721_m00awn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_30/sim/bd_2721_m00wn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_31/sim/bd_2721_m00bn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_32/sim/bd_2721_m00e_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_33/sim/bd_2721_m01s2a_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_34/sim/bd_2721_m01arn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_35/sim/bd_2721_m01rn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_36/sim/bd_2721_m01awn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_37/sim/bd_2721_m01wn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_38/sim/bd_2721_m01bn_0.sv" \
"../../../bd/system/ip/system_axi_smc_1_0/bd_0/ip/ip_39/sim/bd_2721_m01e_0.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/6f8f/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_1.gen/sources_1/bd/system/ipshared/0127/hdl/verilog" "+incdir+/home/adnepukan/vitis/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_axi_smc_1_0/sim/system_axi_smc_1_0.v" \
"../../../bd/system/ip/system_Top_0_0/sim/system_Top_0_0.v" \
"../../../bd/system/sim/system.v" \

vlog -work xil_defaultlib \
"glbl.v"

