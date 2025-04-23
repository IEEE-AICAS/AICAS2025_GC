onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+ip_scaler_dsp_v -L xilinx_vip -L xpm -L xbip_dsp48_wrapper_v3_0_4 -L xbip_utils_v3_0_10 -L xbip_pipe_v3_0_6 -L dsp_macro_v1_0_2 -L xil_defaultlib -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.ip_scaler_dsp_v xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure

do {ip_scaler_dsp_v.udo}

run -all

endsim

quit -force
