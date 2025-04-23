set SynModuleInfo {
  {SRCNAME entry_proc MODELNAME entry_proc RTLNAME Macro_MAC_Acc4_top_entry_proc}
  {SRCNAME read_xi_to_stream MODELNAME read_xi_to_stream RTLNAME Macro_MAC_Acc4_top_read_xi_to_stream
    SUBMODULES {
      {MODELNAME Macro_MAC_Acc4_top_flow_control_loop_pipe_sequential_init RTLNAME Macro_MAC_Acc4_top_flow_control_loop_pipe_sequential_init BINDTYPE interface TYPE internal_upc_flow_control INSTNAME Macro_MAC_Acc4_top_flow_control_loop_pipe_sequential_init_U}
    }
  }
  {SRCNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_1 MODELNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_1 RTLNAME Macro_MAC_Acc4_top_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_1}
  {SRCNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2 MODELNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2 RTLNAME Macro_MAC_Acc4_top_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2}
  {SRCNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_11 MODELNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_11 RTLNAME Macro_MAC_Acc4_top_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_11}
  {SRCNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22 MODELNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22 RTLNAME Macro_MAC_Acc4_top_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22}
  {SRCNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_13 MODELNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_13 RTLNAME Macro_MAC_Acc4_top_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_13}
  {SRCNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24 MODELNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24 RTLNAME Macro_MAC_Acc4_top_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24}
  {SRCNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_15 MODELNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_15 RTLNAME Macro_MAC_Acc4_top_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_15}
  {SRCNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26 MODELNAME Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26 RTLNAME Macro_MAC_Acc4_top_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26}
  {SRCNAME compute_mac_sub MODELNAME compute_mac_sub RTLNAME Macro_MAC_Acc4_top_compute_mac_sub
    SUBMODULES {
      {MODELNAME Macro_MAC_Acc4_top_fadd_32ns_32ns_32_6_no_dsp_1 RTLNAME Macro_MAC_Acc4_top_fadd_32ns_32ns_32_6_no_dsp_1 BINDTYPE op TYPE fadd IMPL fabric LATENCY 5 ALLOW_PRAGMA 1}
      {MODELNAME Macro_MAC_Acc4_top_fmul_32ns_32ns_32_5_max_dsp_1 RTLNAME Macro_MAC_Acc4_top_fmul_32ns_32ns_32_5_max_dsp_1 BINDTYPE op TYPE fmul IMPL maxdsp LATENCY 4 ALLOW_PRAGMA 1}
      {MODELNAME Macro_MAC_Acc4_top_sitofp_32s_32_6_no_dsp_1 RTLNAME Macro_MAC_Acc4_top_sitofp_32s_32_6_no_dsp_1 BINDTYPE op TYPE sitofp IMPL auto LATENCY 5 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME compute_mac MODELNAME compute_mac RTLNAME Macro_MAC_Acc4_top_compute_mac
    SUBMODULES {
      {MODELNAME Macro_MAC_Acc4_top_sparsemux_17_3_32_1_1 RTLNAME Macro_MAC_Acc4_top_sparsemux_17_3_32_1_1 BINDTYPE op TYPE sparsemux IMPL compactencoding_dontcare}
    }
  }
  {SRCNAME Loop_VITIS_LOOP_324_2_proc MODELNAME Loop_VITIS_LOOP_324_2_proc RTLNAME Macro_MAC_Acc4_top_Loop_VITIS_LOOP_324_2_proc
    SUBMODULES {
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi3_s_M_elems_V_2_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi3_s_M_elems_V_6_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi3_s_M_elems_V_1_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi3_s_M_elems_V_5_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi3_s_M_elems_V_0_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi3_s_M_elems_V_4_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi2_s_M_elems_V_2_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi2_s_M_elems_V_6_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi2_s_M_elems_V_1_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi2_s_M_elems_V_5_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi2_s_M_elems_V_0_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi2_s_M_elems_V_4_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi1_s_M_elems_V_2_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi1_s_M_elems_V_6_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi1_s_M_elems_V_1_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi1_s_M_elems_V_5_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi1_s_M_elems_V_0_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi1_s_M_elems_V_4_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi0_s_M_elems_V_3_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi1_s_M_elems_V_3_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi2_s_M_elems_V_3_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi3_s_M_elems_V_3_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi0_s_M_elems_V_7_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi1_s_M_elems_V_7_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi2_s_M_elems_V_7_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi3_s_M_elems_V_7_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi0_s_M_elems_V_2_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi0_s_M_elems_V_6_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi0_s_M_elems_V_1_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi0_s_M_elems_V_5_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi0_s_M_elems_V_0_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi0_s_M_elems_V_4_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro0_s_M_elems_V_3_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro0_s_M_elems_V_2_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro0_s_M_elems_V_1_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro0_s_M_elems_V_0_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro0_s_M_elems_V_4_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro0_s_M_elems_V_5_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro0_s_M_elems_V_6_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro0_s_M_elems_V_7_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro1_s_M_elems_V_3_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro1_s_M_elems_V_2_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro1_s_M_elems_V_1_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro1_s_M_elems_V_0_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro1_s_M_elems_V_4_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro1_s_M_elems_V_5_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro1_s_M_elems_V_6_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro1_s_M_elems_V_7_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro2_s_M_elems_V_3_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro2_s_M_elems_V_2_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro2_s_M_elems_V_1_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro2_s_M_elems_V_0_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro2_s_M_elems_V_4_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro2_s_M_elems_V_5_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro2_s_M_elems_V_6_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro2_s_M_elems_V_7_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro3_s_M_elems_V_3_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro3_s_M_elems_V_2_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro3_s_M_elems_V_1_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro3_s_M_elems_V_0_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro3_s_M_elems_V_4_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro3_s_M_elems_V_5_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro3_s_M_elems_V_6_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro3_s_M_elems_V_7_U}
    }
  }
  {SRCNAME Loop_VITIS_LOOP_337_3_proc MODELNAME Loop_VITIS_LOOP_337_3_proc RTLNAME Macro_MAC_Acc4_top_Loop_VITIS_LOOP_337_3_proc
    SUBMODULES {
      {MODELNAME Macro_MAC_Acc4_top_flow_control_loop_pipe RTLNAME Macro_MAC_Acc4_top_flow_control_loop_pipe BINDTYPE interface TYPE internal_upc_flow_control INSTNAME Macro_MAC_Acc4_top_flow_control_loop_pipe_U}
    }
  }
  {SRCNAME Macro_MAC_Acc4_top MODELNAME Macro_MAC_Acc4_top RTLNAME Macro_MAC_Acc4_top IS_TOP 1
    SUBMODULES {
      {MODELNAME Macro_MAC_Acc4_top_fifo_w128_d3_S RTLNAME Macro_MAC_Acc4_top_fifo_w128_d3_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME xi_c_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w128_d3_S RTLNAME Macro_MAC_Acc4_top_fifo_w128_d3_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro0_c_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w128_d3_S RTLNAME Macro_MAC_Acc4_top_fifo_w128_d3_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro1_c_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w128_d3_S RTLNAME Macro_MAC_Acc4_top_fifo_w128_d3_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro2_c_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w128_d3_S RTLNAME Macro_MAC_Acc4_top_fifo_w128_d3_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME mro3_c_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w16_d3_S RTLNAME Macro_MAC_Acc4_top_fifo_w16_d3_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME row_c_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local0_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local0_1_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local0_2_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local0_3_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local0_4_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local0_5_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local0_6_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local0_7_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local1_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local1_1_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local1_2_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local1_3_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local1_4_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local1_5_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local1_6_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local1_7_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local2_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local2_1_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local2_2_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local2_3_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local2_4_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local2_5_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local2_6_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local2_7_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local3_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local3_1_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local3_2_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local3_3_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local3_4_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local3_5_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local3_6_U}
      {MODELNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x RTLNAME Macro_MAC_Acc4_top_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pout_local3_7_U}
      {MODELNAME Macro_MAC_Acc4_top_start_for_Loop_VITIS_LOOP_324_2_proc_U0 RTLNAME Macro_MAC_Acc4_top_start_for_Loop_VITIS_LOOP_324_2_proc_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_Loop_VITIS_LOOP_324_2_proc_U0_U}
    }
  }
}
