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
    id 13 \
    name p_read \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_p_read \
    op interface \
    ports { p_read { I 128 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 14 \
    name xi3_s_M_elems_V_2 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi3_s_M_elems_V_2 \
    op interface \
    ports { xi3_s_M_elems_V_2_din { O 32 vector } xi3_s_M_elems_V_2_full_n { I 1 bit } xi3_s_M_elems_V_2_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 15 \
    name xi3_s_M_elems_V_6 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi3_s_M_elems_V_6 \
    op interface \
    ports { xi3_s_M_elems_V_6_din { O 32 vector } xi3_s_M_elems_V_6_full_n { I 1 bit } xi3_s_M_elems_V_6_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 16 \
    name xi3_s_M_elems_V_1 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi3_s_M_elems_V_1 \
    op interface \
    ports { xi3_s_M_elems_V_1_din { O 32 vector } xi3_s_M_elems_V_1_full_n { I 1 bit } xi3_s_M_elems_V_1_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 17 \
    name xi3_s_M_elems_V_5 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi3_s_M_elems_V_5 \
    op interface \
    ports { xi3_s_M_elems_V_5_din { O 32 vector } xi3_s_M_elems_V_5_full_n { I 1 bit } xi3_s_M_elems_V_5_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 18 \
    name xi3_s_M_elems_V_0 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi3_s_M_elems_V_0 \
    op interface \
    ports { xi3_s_M_elems_V_0_din { O 32 vector } xi3_s_M_elems_V_0_full_n { I 1 bit } xi3_s_M_elems_V_0_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 19 \
    name xi3_s_M_elems_V_4 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi3_s_M_elems_V_4 \
    op interface \
    ports { xi3_s_M_elems_V_4_din { O 32 vector } xi3_s_M_elems_V_4_full_n { I 1 bit } xi3_s_M_elems_V_4_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 20 \
    name xi2_s_M_elems_V_2 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi2_s_M_elems_V_2 \
    op interface \
    ports { xi2_s_M_elems_V_2_din { O 32 vector } xi2_s_M_elems_V_2_full_n { I 1 bit } xi2_s_M_elems_V_2_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 21 \
    name xi2_s_M_elems_V_6 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi2_s_M_elems_V_6 \
    op interface \
    ports { xi2_s_M_elems_V_6_din { O 32 vector } xi2_s_M_elems_V_6_full_n { I 1 bit } xi2_s_M_elems_V_6_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 22 \
    name xi2_s_M_elems_V_1 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi2_s_M_elems_V_1 \
    op interface \
    ports { xi2_s_M_elems_V_1_din { O 32 vector } xi2_s_M_elems_V_1_full_n { I 1 bit } xi2_s_M_elems_V_1_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 23 \
    name xi2_s_M_elems_V_5 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi2_s_M_elems_V_5 \
    op interface \
    ports { xi2_s_M_elems_V_5_din { O 32 vector } xi2_s_M_elems_V_5_full_n { I 1 bit } xi2_s_M_elems_V_5_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 24 \
    name xi2_s_M_elems_V_0 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi2_s_M_elems_V_0 \
    op interface \
    ports { xi2_s_M_elems_V_0_din { O 32 vector } xi2_s_M_elems_V_0_full_n { I 1 bit } xi2_s_M_elems_V_0_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 25 \
    name xi2_s_M_elems_V_4 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi2_s_M_elems_V_4 \
    op interface \
    ports { xi2_s_M_elems_V_4_din { O 32 vector } xi2_s_M_elems_V_4_full_n { I 1 bit } xi2_s_M_elems_V_4_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 26 \
    name xi1_s_M_elems_V_2 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi1_s_M_elems_V_2 \
    op interface \
    ports { xi1_s_M_elems_V_2_din { O 32 vector } xi1_s_M_elems_V_2_full_n { I 1 bit } xi1_s_M_elems_V_2_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 27 \
    name xi1_s_M_elems_V_6 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi1_s_M_elems_V_6 \
    op interface \
    ports { xi1_s_M_elems_V_6_din { O 32 vector } xi1_s_M_elems_V_6_full_n { I 1 bit } xi1_s_M_elems_V_6_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 28 \
    name xi1_s_M_elems_V_1 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi1_s_M_elems_V_1 \
    op interface \
    ports { xi1_s_M_elems_V_1_din { O 32 vector } xi1_s_M_elems_V_1_full_n { I 1 bit } xi1_s_M_elems_V_1_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 29 \
    name xi1_s_M_elems_V_5 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi1_s_M_elems_V_5 \
    op interface \
    ports { xi1_s_M_elems_V_5_din { O 32 vector } xi1_s_M_elems_V_5_full_n { I 1 bit } xi1_s_M_elems_V_5_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 30 \
    name xi1_s_M_elems_V_0 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi1_s_M_elems_V_0 \
    op interface \
    ports { xi1_s_M_elems_V_0_din { O 32 vector } xi1_s_M_elems_V_0_full_n { I 1 bit } xi1_s_M_elems_V_0_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 31 \
    name xi1_s_M_elems_V_4 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi1_s_M_elems_V_4 \
    op interface \
    ports { xi1_s_M_elems_V_4_din { O 32 vector } xi1_s_M_elems_V_4_full_n { I 1 bit } xi1_s_M_elems_V_4_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 32 \
    name xi0_s_M_elems_V_3 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi0_s_M_elems_V_3 \
    op interface \
    ports { xi0_s_M_elems_V_3_din { O 32 vector } xi0_s_M_elems_V_3_full_n { I 1 bit } xi0_s_M_elems_V_3_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 33 \
    name xi1_s_M_elems_V_3 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi1_s_M_elems_V_3 \
    op interface \
    ports { xi1_s_M_elems_V_3_din { O 32 vector } xi1_s_M_elems_V_3_full_n { I 1 bit } xi1_s_M_elems_V_3_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 34 \
    name xi2_s_M_elems_V_3 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi2_s_M_elems_V_3 \
    op interface \
    ports { xi2_s_M_elems_V_3_din { O 32 vector } xi2_s_M_elems_V_3_full_n { I 1 bit } xi2_s_M_elems_V_3_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 35 \
    name xi3_s_M_elems_V_3 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi3_s_M_elems_V_3 \
    op interface \
    ports { xi3_s_M_elems_V_3_din { O 32 vector } xi3_s_M_elems_V_3_full_n { I 1 bit } xi3_s_M_elems_V_3_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 36 \
    name xi0_s_M_elems_V_7 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi0_s_M_elems_V_7 \
    op interface \
    ports { xi0_s_M_elems_V_7_din { O 32 vector } xi0_s_M_elems_V_7_full_n { I 1 bit } xi0_s_M_elems_V_7_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 37 \
    name xi1_s_M_elems_V_7 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi1_s_M_elems_V_7 \
    op interface \
    ports { xi1_s_M_elems_V_7_din { O 32 vector } xi1_s_M_elems_V_7_full_n { I 1 bit } xi1_s_M_elems_V_7_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 38 \
    name xi2_s_M_elems_V_7 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi2_s_M_elems_V_7 \
    op interface \
    ports { xi2_s_M_elems_V_7_din { O 32 vector } xi2_s_M_elems_V_7_full_n { I 1 bit } xi2_s_M_elems_V_7_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 39 \
    name xi3_s_M_elems_V_7 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi3_s_M_elems_V_7 \
    op interface \
    ports { xi3_s_M_elems_V_7_din { O 32 vector } xi3_s_M_elems_V_7_full_n { I 1 bit } xi3_s_M_elems_V_7_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 40 \
    name xi0_s_M_elems_V_2 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi0_s_M_elems_V_2 \
    op interface \
    ports { xi0_s_M_elems_V_2_din { O 32 vector } xi0_s_M_elems_V_2_full_n { I 1 bit } xi0_s_M_elems_V_2_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 41 \
    name xi0_s_M_elems_V_6 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi0_s_M_elems_V_6 \
    op interface \
    ports { xi0_s_M_elems_V_6_din { O 32 vector } xi0_s_M_elems_V_6_full_n { I 1 bit } xi0_s_M_elems_V_6_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 42 \
    name xi0_s_M_elems_V_1 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi0_s_M_elems_V_1 \
    op interface \
    ports { xi0_s_M_elems_V_1_din { O 32 vector } xi0_s_M_elems_V_1_full_n { I 1 bit } xi0_s_M_elems_V_1_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 43 \
    name xi0_s_M_elems_V_5 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi0_s_M_elems_V_5 \
    op interface \
    ports { xi0_s_M_elems_V_5_din { O 32 vector } xi0_s_M_elems_V_5_full_n { I 1 bit } xi0_s_M_elems_V_5_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 44 \
    name xi0_s_M_elems_V_0 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi0_s_M_elems_V_0 \
    op interface \
    ports { xi0_s_M_elems_V_0_din { O 32 vector } xi0_s_M_elems_V_0_full_n { I 1 bit } xi0_s_M_elems_V_0_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 45 \
    name xi0_s_M_elems_V_4 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_xi0_s_M_elems_V_4 \
    op interface \
    ports { xi0_s_M_elems_V_4_din { O 32 vector } xi0_s_M_elems_V_4_full_n { I 1 bit } xi0_s_M_elems_V_4_write { O 1 bit } } \
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
    ports { ap_start { I 1 bit } ap_ready { O 1 bit } ap_done { O 1 bit } ap_idle { O 1 bit } } \
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


# flow_control definition:
set InstName Macro_MAC_Acc4_top_flow_control_loop_pipe_sequential_init_U
set CompName Macro_MAC_Acc4_top_flow_control_loop_pipe_sequential_init
set name flow_control_loop_pipe_sequential_init
if {${::AESL::PGuard_autocg_gen} && ${::AESL::PGuard_autocg_ipmgen}} {
if {[info proc ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control] == "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control"} {
eval "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control { \
    name ${name} \
    prefix Macro_MAC_Acc4_top_ \
}"
} else {
puts "@W \[IMPL-107\] Cannot find ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control, check your platform lib"
}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $CompName BINDTYPE interface TYPE internal_upc_flow_control INSTNAME $InstName
}


