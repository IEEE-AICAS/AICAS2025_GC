transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+blk_mem_gen_bypass  -L xil_defaultlib -L xilinx_vip -L xpm -L blk_mem_gen_v8_4_9 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.blk_mem_gen_bypass xil_defaultlib.glbl

do {blk_mem_gen_bypass.udo}

run 1000ns

endsim

quit -force
