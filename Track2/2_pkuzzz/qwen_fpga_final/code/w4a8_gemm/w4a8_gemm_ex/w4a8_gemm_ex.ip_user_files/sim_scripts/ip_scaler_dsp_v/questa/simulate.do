onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib ip_scaler_dsp_v_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {ip_scaler_dsp_v.udo}

run -all

quit -force
