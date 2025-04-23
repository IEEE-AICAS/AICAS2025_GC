onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc"  -L xilinx_vip -L xpm -L xil_defaultlib -L axis_infrastructure_v1_1_1 -L axis_data_fifo_v2_0_11 -L xlconcat_v2_1_5 -L gigantic_mux -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.accelerate xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {accelerate.udo}

run 1000ns

quit -force
