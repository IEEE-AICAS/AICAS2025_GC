# This script segment is generated automatically by AutoPilot

if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler Macro_MAC_Acc4_top_sparsemux_17_3_32_1_1 BINDTYPE {op} TYPE {sparsemux} IMPL {compactencoding_dontcare}
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
    id 205 \
    name xi_s_0_0 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_xi_s_0_0 \
    op interface \
    ports { xi_s_0_0_dout { I 32 vector } xi_s_0_0_empty_n { I 1 bit } xi_s_0_0_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 206 \
    name xi_s_0_01 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_xi_s_0_01 \
    op interface \
    ports { xi_s_0_01_dout { I 32 vector } xi_s_0_01_empty_n { I 1 bit } xi_s_0_01_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 207 \
    name xi_s_0_02 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_xi_s_0_02 \
    op interface \
    ports { xi_s_0_02_dout { I 32 vector } xi_s_0_02_empty_n { I 1 bit } xi_s_0_02_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 208 \
    name xi_s_0_03 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_xi_s_0_03 \
    op interface \
    ports { xi_s_0_03_dout { I 32 vector } xi_s_0_03_empty_n { I 1 bit } xi_s_0_03_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 209 \
    name xi_s_0_04 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_xi_s_0_04 \
    op interface \
    ports { xi_s_0_04_dout { I 32 vector } xi_s_0_04_empty_n { I 1 bit } xi_s_0_04_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 210 \
    name xi_s_0_05 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_xi_s_0_05 \
    op interface \
    ports { xi_s_0_05_dout { I 32 vector } xi_s_0_05_empty_n { I 1 bit } xi_s_0_05_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 211 \
    name xi_s_0_06 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_xi_s_0_06 \
    op interface \
    ports { xi_s_0_06_dout { I 32 vector } xi_s_0_06_empty_n { I 1 bit } xi_s_0_06_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 212 \
    name xi_s_0_07 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_xi_s_0_07 \
    op interface \
    ports { xi_s_0_07_dout { I 32 vector } xi_s_0_07_empty_n { I 1 bit } xi_s_0_07_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 213 \
    name mro_s_0_0 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_mro_s_0_0 \
    op interface \
    ports { mro_s_0_0_dout { I 32 vector } mro_s_0_0_empty_n { I 1 bit } mro_s_0_0_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 214 \
    name mro_s_0_08 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_mro_s_0_08 \
    op interface \
    ports { mro_s_0_08_dout { I 32 vector } mro_s_0_08_empty_n { I 1 bit } mro_s_0_08_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 215 \
    name mro_s_0_09 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_mro_s_0_09 \
    op interface \
    ports { mro_s_0_09_dout { I 32 vector } mro_s_0_09_empty_n { I 1 bit } mro_s_0_09_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 216 \
    name mro_s_0_010 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_mro_s_0_010 \
    op interface \
    ports { mro_s_0_010_dout { I 32 vector } mro_s_0_010_empty_n { I 1 bit } mro_s_0_010_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 217 \
    name mro_s_0_011 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_mro_s_0_011 \
    op interface \
    ports { mro_s_0_011_dout { I 32 vector } mro_s_0_011_empty_n { I 1 bit } mro_s_0_011_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 218 \
    name mro_s_0_012 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_mro_s_0_012 \
    op interface \
    ports { mro_s_0_012_dout { I 32 vector } mro_s_0_012_empty_n { I 1 bit } mro_s_0_012_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 219 \
    name mro_s_0_013 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_mro_s_0_013 \
    op interface \
    ports { mro_s_0_013_dout { I 32 vector } mro_s_0_013_empty_n { I 1 bit } mro_s_0_013_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 220 \
    name mro_s_0_014 \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_mro_s_0_014 \
    op interface \
    ports { mro_s_0_014_dout { I 32 vector } mro_s_0_014_empty_n { I 1 bit } mro_s_0_014_read { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 221 \
    name qzeros_0_val8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_0_val8 \
    op interface \
    ports { qzeros_0_val8 { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 222 \
    name qzeros_1_val16 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_1_val16 \
    op interface \
    ports { qzeros_1_val16 { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 223 \
    name qzeros_2_val24 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_2_val24 \
    op interface \
    ports { qzeros_2_val24 { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 224 \
    name qzeros_3_val32 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_3_val32 \
    op interface \
    ports { qzeros_3_val32 { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 225 \
    name qzeros_4_val40 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_4_val40 \
    op interface \
    ports { qzeros_4_val40 { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 226 \
    name qzeros_5_val48 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_5_val48 \
    op interface \
    ports { qzeros_5_val48 { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 227 \
    name qzeros_6_val56 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_6_val56 \
    op interface \
    ports { qzeros_6_val56 { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 228 \
    name qzeros_7_val64 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qzeros_7_val64 \
    op interface \
    ports { qzeros_7_val64 { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 229 \
    name qscale_0_val72 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_0_val72 \
    op interface \
    ports { qscale_0_val72 { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 230 \
    name qscale_1_val81 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_1_val81 \
    op interface \
    ports { qscale_1_val81 { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 231 \
    name qscale_2_val89 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_2_val89 \
    op interface \
    ports { qscale_2_val89 { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 232 \
    name qscale_3_val98 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_3_val98 \
    op interface \
    ports { qscale_3_val98 { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 233 \
    name qscale_4_val106 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_4_val106 \
    op interface \
    ports { qscale_4_val106 { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 234 \
    name qscale_5_val115 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_5_val115 \
    op interface \
    ports { qscale_5_val115 { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 235 \
    name qscale_6_val123 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_6_val123 \
    op interface \
    ports { qscale_6_val123 { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 236 \
    name qscale_7_val132 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_qscale_7_val132 \
    op interface \
    ports { qscale_7_val132 { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 237 \
    name pout_local_0 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_pout_local_0 \
    op interface \
    ports { pout_local_0_i { I 32 vector } pout_local_0_o { O 32 vector } pout_local_0_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 238 \
    name pout_local_1 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_pout_local_1 \
    op interface \
    ports { pout_local_1_i { I 32 vector } pout_local_1_o { O 32 vector } pout_local_1_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 239 \
    name pout_local_2 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_pout_local_2 \
    op interface \
    ports { pout_local_2_i { I 32 vector } pout_local_2_o { O 32 vector } pout_local_2_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 240 \
    name pout_local_3 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_pout_local_3 \
    op interface \
    ports { pout_local_3_i { I 32 vector } pout_local_3_o { O 32 vector } pout_local_3_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 241 \
    name pout_local_4 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_pout_local_4 \
    op interface \
    ports { pout_local_4_i { I 32 vector } pout_local_4_o { O 32 vector } pout_local_4_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 242 \
    name pout_local_5 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_pout_local_5 \
    op interface \
    ports { pout_local_5_i { I 32 vector } pout_local_5_o { O 32 vector } pout_local_5_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 243 \
    name pout_local_6 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_pout_local_6 \
    op interface \
    ports { pout_local_6_i { I 32 vector } pout_local_6_o { O 32 vector } pout_local_6_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 244 \
    name pout_local_7 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_pout_local_7 \
    op interface \
    ports { pout_local_7_i { I 32 vector } pout_local_7_o { O 32 vector } pout_local_7_o_ap_vld { O 1 bit } } \
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


