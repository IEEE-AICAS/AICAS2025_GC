# This is a generated file. Use and modify at your own risk.
################################################################################

open_project prj
open_solution sol -flow_target vitis
set_part xck26-sfvc784-2LV-c
add_files ../w4a8_gemm_cmodel.cpp
set_top w4a8_gemm
csynth_design
exit

