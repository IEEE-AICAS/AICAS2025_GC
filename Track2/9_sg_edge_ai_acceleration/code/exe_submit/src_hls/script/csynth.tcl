# ---------------------------
# Synthesis Script
# ---------------------------

# Load global config
source ./script/config.tcl

# Create/reset project
open_project -reset $project_name
open_solution -reset $solution_name
set_part $device

# Add design files
foreach file $design_srcs {
    add_files $file -cflags "-I${design_dir}"
    puts "\[INFO\]: Find $file"
}

# Set top function
set_top $top_function

# Create clock constraint
create_clock -period $clock_period -name default

# Run synthesis
csynth_design

# Close project
close_solution
close_project

exit