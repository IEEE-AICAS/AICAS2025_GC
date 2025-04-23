# This script segment is generated automatically by AutoPilot

# clear list
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_begin
    cg_default_interface_gen_bundle_begin
    AESL_LIB_XILADAPTER::native_axis_begin
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 1 \
    name xi \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_xi \
    op interface \
    ports { xi { I 128 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 2 \
    name xi_c \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi_c \
    op interface \
    ports { xi_c_din { O 128 vector } xi_c_full_n { I 1 bit } xi_c_write { O 1 bit } xi_c_num_data_valid { I 3 vector } xi_c_fifo_cap { I 3 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 3 \
    name mro0 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_mro0 \
    op interface \
    ports { mro0 { I 128 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 4 \
    name mro0_c \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_mro0_c \
    op interface \
    ports { mro0_c_din { O 128 vector } mro0_c_full_n { I 1 bit } mro0_c_write { O 1 bit } mro0_c_num_data_valid { I 3 vector } mro0_c_fifo_cap { I 3 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 5 \
    name mro1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_mro1 \
    op interface \
    ports { mro1 { I 128 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 6 \
    name mro1_c \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_mro1_c \
    op interface \
    ports { mro1_c_din { O 128 vector } mro1_c_full_n { I 1 bit } mro1_c_write { O 1 bit } mro1_c_num_data_valid { I 3 vector } mro1_c_fifo_cap { I 3 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 7 \
    name mro2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_mro2 \
    op interface \
    ports { mro2 { I 128 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 8 \
    name mro2_c \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_mro2_c \
    op interface \
    ports { mro2_c_din { O 128 vector } mro2_c_full_n { I 1 bit } mro2_c_write { O 1 bit } mro2_c_num_data_valid { I 3 vector } mro2_c_fifo_cap { I 3 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 9 \
    name mro3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_mro3 \
    op interface \
    ports { mro3 { I 128 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 10 \
    name mro3_c \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_mro3_c \
    op interface \
    ports { mro3_c_din { O 128 vector } mro3_c_full_n { I 1 bit } mro3_c_write { O 1 bit } mro3_c_num_data_valid { I 3 vector } mro3_c_fifo_cap { I 3 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 11 \
    name row \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_row \
    op interface \
    ports { row { I 16 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 12 \
    name row_c \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_row_c \
    op interface \
    ports { row_c_din { O 16 vector } row_c_full_n { I 1 bit } row_c_write { O 1 bit } row_c_num_data_valid { I 3 vector } row_c_fifo_cap { I 3 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id -1 \
    name ap_ctrl \
    type ap_ctrl \
    reset_level 1 \
    sync_rst true \
    corename ap_ctrl \
    op interface \
    ports { ap_start { I 1 bit } ap_ready { O 1 bit } ap_done { O 1 bit } ap_idle { O 1 bit } ap_continue { I 1 bit } } \
} "
}


# Adapter definition:
set PortName ap_clk
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_clock] == "cg_default_interface_gen_clock"} {
eval "cg_default_interface_gen_clock { \
    id -2 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_clk \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-113\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}


# Adapter definition:
set PortName ap_rst
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_reset] == "cg_default_interface_gen_reset"} {
eval "cg_default_interface_gen_reset { \
    id -3 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_rst \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-114\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}



# merge
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_end
    cg_default_interface_gen_bundle_end
    AESL_LIB_XILADAPTER::native_axis_end
}


