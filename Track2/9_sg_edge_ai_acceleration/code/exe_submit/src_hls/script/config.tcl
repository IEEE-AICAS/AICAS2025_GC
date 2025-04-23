# ---------------------------
# Global Configuration
# ---------------------------

# Project settings
set project_name      "prjhls_awqmul"       ;# Project name
set solution_name     "solution1"           ;# Solution name
set device            "xck26-sfvc784-2lv-c" ;# FPGA device for KV260
set clock_period      5                   ;# Clock period (ns)

# File paths
set design_dir        "./src"              ;# Design source directory
set tb_dir            "./tb"               ;# Testbench directory
set ip_output_dir     "./ip_repo"          ;# Output directory for IP

# Design files
set design_srcs [list \
    "${design_dir}/awq_macro.cpp" \
    "${design_dir}/awq_macro.h" \
]

# Testbench files
set tb_srcs [list \
    "${tb_dir}/tb_awq_macro.cpp" \
]

# Top function name
set top_function      "Macro_MAC_Acc4_top"           ;# Top-level function
