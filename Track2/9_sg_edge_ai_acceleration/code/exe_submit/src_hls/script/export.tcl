# ---------------------------
# IP Export Script
# ---------------------------

# Load global config
source ./script/config.tcl

# Open project
open_project $project_name
open_solution $solution_name

# Ensure synthesis is complete
if { ![file exists "${project_name}/${solution_name}/syn/report/${top_function}_csynth.rpt"] } {
    csynth_design
}

# Export IP
export_design -format ip_catalog -output $ip_output_dir

# Close project
close_solution
close_project

exit