transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+accelerate  -L xilinx_vip -L xpm -L xil_defaultlib -L axis_infrastructure_v1_1_1 -L axis_data_fifo_v2_0_11 -L xlconcat_v2_1_5 -L gigantic_mux -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.accelerate xil_defaultlib.glbl

do {accelerate.udo}

run 1000ns

endsim

quit -force
