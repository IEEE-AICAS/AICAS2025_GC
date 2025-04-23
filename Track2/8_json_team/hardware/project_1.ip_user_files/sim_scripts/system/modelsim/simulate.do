onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc"  -L xil_defaultlib -L xilinx_vip -L xpm -L axi_infrastructure_v1_1_0 -L axi_vip_v1_1_19 -L zynq_ultra_ps_e_vip_v1_0_19 -L lib_pkg_v1_0_4 -L lib_srl_fifo_v1_0_4 -L fifo_generator_v13_2_11 -L lib_fifo_v1_0_20 -L lib_cdc_v1_0_3 -L axi_datamover_v5_1_35 -L axi_sg_v4_1_19 -L axi_cdma_v4_1_33 -L axi_bram_ctrl_v4_1_11 -L xlconstant_v1_1_9 -L proc_sys_reset_v5_0_16 -L smartconnect_v1_0 -L axi_register_slice_v2_1_33 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.system xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {system.udo}

run 1000ns

quit -force
