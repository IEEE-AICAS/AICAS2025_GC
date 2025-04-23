# ---------------------------
# C Simulation Script
# ---------------------------

# Load global config
source ./script/config.tcl

# Open project
open_project $project_name
open_solution $solution_name

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

# Run C simulation
csim_design -clean

# Close project
close_solution
close_project

exit