onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib control_w4a8_gemm_vip_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {control_w4a8_gemm_vip.udo}

run -all

quit -force
