# This script segment is generated automatically by AutoPilot

set name Macro_MAC_Acc4_top_fadd_32ns_32ns_32_6_no_dsp_1
if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $name BINDTYPE {op} TYPE {fadd} IMPL {fabric} LATENCY 5 ALLOW_PRAGMA 1
}


set name Macro_MAC_Acc4_top_fmul_32ns_32ns_32_5_max_dsp_1
if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $name BINDTYPE {op} TYPE {fmul} IMPL {maxdsp} LATENCY 4 ALLOW_PRAGMA 1
}


set name Macro_MAC_Acc4_top_sitofp_32s_32_6_no_dsp_1
if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $name BINDTYPE {op} TYPE {sitofp} IMPL {auto} LATENCY 5 ALLOW_PRAGMA 1
}


# clear list
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_begin
    cg_default_interface_gen_bundle_begin
    AESL_LIB_XILADAPTER::native_axis_begin
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 169 \
    name xi_s_0 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_xi_s_0 \
    op interface \
    ports { xi_s_0_dout { I 32 vector } xi_s_0_empty_n { I 1 bit } xi_s_0_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 170 \
    name mro_s_0 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_mro_s_0 \
    op interface \
    ports { mro_s_0_dout { I 32 vector } mro_s_0_empty_n { I 1 bit } mro_s_0_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 171 \
    name qzeros_0_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_0_val \
    op interface \
    ports { qzeros_0_val { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 172 \
    name qzeros_1_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_1_val \
    op interface \
    ports { qzeros_1_val { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 173 \
    name qzeros_2_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_2_val \
    op interface \
    ports { qzeros_2_val { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 174 \
    name qzeros_3_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_3_val \
    op interface \
    ports { qzeros_3_val { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 175 \
    name qzeros_4_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_4_val \
    op interface \
    ports { qzeros_4_val { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 176 \
    name qzeros_5_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_5_val \
    op interface \
    ports { qzeros_5_val { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 177 \
    name qzeros_6_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_6_val \
    op interface \
    ports { qzeros_6_val { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 178 \
    name qzeros_7_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_7_val \
    op interface \
    ports { qzeros_7_val { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 179 \
    name qscale_0_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_0_val \
    op interface \
    ports { qscale_0_val { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 180 \
    name qscale_1_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_1_val \
    op interface \
    ports { qscale_1_val { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 181 \
    name qscale_2_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_2_val \
    op interface \
    ports { qscale_2_val { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 182 \
    name qscale_3_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_3_val \
    op interface \
    ports { qscale_3_val { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 183 \
    name qscale_4_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_4_val \
    op interface \
    ports { qscale_4_val { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 184 \
    name qscale_5_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_5_val \
    op interface \
    ports { qscale_5_val { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 185 \
    name qscale_6_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_6_val \
    op interface \
    ports { qscale_6_val { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 186 \
    name qscale_7_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_7_val \
    op interface \
    ports { qscale_7_val { I 32 vector } } \
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

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id -2 \
    name ap_return \
    type ap_return \
    reset_level 1 \
    sync_rst true \
    corename ap_return \
    op interface \
    ports { ap_return { O 1 vector } } \
} "
}


# Adapter definition:
set PortName ap_clk
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_clock] == "cg_default_interface_gen_clock"} {
eval "cg_default_interface_gen_clock { \
    id -3 \
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
    id -4 \
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


