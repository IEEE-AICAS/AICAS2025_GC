transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+dsp_macro_bypass  -L xil_defaultlib -L xilinx_vip -L xpm -L xbip_dsp48_wrapper_v3_0_6 -L xbip_utils_v3_0_14 -L xbip_pipe_v3_0_10 -L dsp_macro_v1_0_7 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.dsp_macro_bypass xil_defaultlib.glbl

do {dsp_macro_bypass.udo}

run 1000ns

endsim

quit -force
