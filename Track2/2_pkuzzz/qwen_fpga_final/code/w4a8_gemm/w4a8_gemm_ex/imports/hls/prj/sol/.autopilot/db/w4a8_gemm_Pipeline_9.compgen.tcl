# This script segment is generated automatically by AutoPilot

# clear list
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_begin
    cg_default_interface_gen_bundle_begin
    AESL_LIB_XILADAPTER::native_axis_begin
}

# XIL_BRAM:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::xil_bram_gen] == "::AESL_LIB_XILADAPTER::xil_bram_gen"} {
eval "::AESL_LIB_XILADAPTER::xil_bram_gen { \
    id 24 \
    name m02_axi_output_buffer \
    reset_level 1 \
    sync_rst true \
    dir I \
    corename m02_axi_output_buffer \
    op interface \
    ports { m02_axi_output_buffer_address0 { O 13 vector } m02_axi_output_buffer_ce0 { O 1 bit } m02_axi_output_buffer_q0 { I 32 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'm02_axi_output_buffer'"
}
}


# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 22 \
    name m02_axi \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_m02_axi \
    op interface \
    ports { m_axi_m02_axi_AWVALID { O 1 bit } m_axi_m02_axi_AWREADY { I 1 bit } m_axi_m02_axi_AWADDR { O 64 vector } m_axi_m02_axi_AWID { O 1 vector } m_axi_m02_axi_AWLEN { O 32 vector } m_axi_m02_axi_AWSIZE { O 3 vector } m_axi_m02_axi_AWBURST { O 2 vector } m_axi_m02_axi_AWLOCK { O 2 vector } m_axi_m02_axi_AWCACHE { O 4 vector } m_axi_m02_axi_AWPROT { O 3 vector } m_axi_m02_axi_AWQOS { O 4 vector } m_axi_m02_axi_AWREGION { O 4 vector } m_axi_m02_axi_AWUSER { O 1 vector } m_axi_m02_axi_WVALID { O 1 bit } m_axi_m02_axi_WREADY { I 1 bit } m_axi_m02_axi_WDATA { O 512 vector } m_axi_m02_axi_WSTRB { O 64 vector } m_axi_m02_axi_WLAST { O 1 bit } m_axi_m02_axi_WID { O 1 vector } m_axi_m02_axi_WUSER { O 1 vector } m_axi_m02_axi_ARVALID { O 1 bit } m_axi_m02_axi_ARREADY { I 1 bit } m_axi_m02_axi_ARADDR { O 64 vector } m_axi_m02_axi_ARID { O 1 vector } m_axi_m02_axi_ARLEN { O 32 vector } m_axi_m02_axi_ARSIZE { O 3 vector } m_axi_m02_axi_ARBURST { O 2 vector } m_axi_m02_axi_ARLOCK { O 2 vector } m_axi_m02_axi_ARCACHE { O 4 vector } m_axi_m02_axi_ARPROT { O 3 vector } m_axi_m02_axi_ARQOS { O 4 vector } m_axi_m02_axi_ARREGION { O 4 vector } m_axi_m02_axi_ARUSER { O 1 vector } m_axi_m02_axi_RVALID { I 1 bit } m_axi_m02_axi_RREADY { O 1 bit } m_axi_m02_axi_RDATA { I 512 vector } m_axi_m02_axi_RLAST { I 1 bit } m_axi_m02_axi_RID { I 1 vector } m_axi_m02_axi_RFIFONUM { I 9 vector } m_axi_m02_axi_RUSER { I 1 vector } m_axi_m02_axi_RRESP { I 2 vector } m_axi_m02_axi_BVALID { I 1 bit } m_axi_m02_axi_BREADY { O 1 bit } m_axi_m02_axi_BRESP { I 2 vector } m_axi_m02_axi_BID { I 1 vector } m_axi_m02_axi_BUSER { I 1 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 23 \
    name sext_ln103 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln103 \
    op interface \
    ports { sext_ln103 { I 58 vector } } \
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
set InstName w4a8_gemm_flow_control_loop_pipe_sequential_init_U
set CompName w4a8_gemm_flow_control_loop_pipe_sequential_init
set name flow_control_loop_pipe_sequential_init
if {${::AESL::PGuard_autocg_gen} && ${::AESL::PGuard_autocg_ipmgen}} {
if {[info proc ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control] == "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control"} {
eval "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control { \
    name ${name} \
    prefix w4a8_gemm_ \
}"
} else {
puts "@W \[IMPL-107\] Cannot find ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control, check your platform lib"
}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $CompName BINDTYPE interface TYPE internal_upc_flow_control INSTNAME $InstName
}


