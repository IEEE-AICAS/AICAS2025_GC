# ---------------------------
# RTL Co-Simulation Script
# ---------------------------

# Load global config
source ./script/config.tcl

# Open project
open_project $project_name
open_solution $solution_name

# Set device and clock
set_part $device
create_clock -period $clock_period -name default

# Add design files
foreach file $design_srcs {
    add_files $file -cflags "-I${design_dir}"
}

# Add testbench files
foreach file $tb_srcs {
    add_files -tb $file -cflags "-I${design_dir}"
}

# Set top function
set_top $top_function

# Run synthesis if not done
if { ![file exists "${project_name}/${solution_name}/syn/report/${top_function}_csynth.rpt"] } {
    csynth_design
}

# Run co-simulation
cosim_design -rtl verilog -tool xsim
# cosim_design -rtl verilog -tool xsim -wave_debug

# Close project
close_solution
close_project

exit