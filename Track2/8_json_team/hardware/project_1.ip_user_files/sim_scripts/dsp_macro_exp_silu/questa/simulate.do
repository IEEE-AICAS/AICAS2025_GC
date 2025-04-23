onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib dsp_macro_exp_silu_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {dsp_macro_exp_silu.udo}

run 1000ns

quit -force
