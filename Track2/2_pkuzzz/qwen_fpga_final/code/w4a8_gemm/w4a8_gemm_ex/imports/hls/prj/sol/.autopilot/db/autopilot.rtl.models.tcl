set SynModuleInfo {
  {SRCNAME w4a8_gemm_Pipeline_1 MODELNAME w4a8_gemm_Pipeline_1 RTLNAME w4a8_gemm_w4a8_gemm_Pipeline_1
    SUBMODULES {
      {MODELNAME w4a8_gemm_flow_control_loop_pipe_sequential_init RTLNAME w4a8_gemm_flow_control_loop_pipe_sequential_init BINDTYPE interface TYPE internal_upc_flow_control INSTNAME w4a8_gemm_flow_control_loop_pipe_sequential_init_U}
    }
  }
  {SRCNAME w4a8_gemm_Pipeline_VITIS_LOOP_64_1 MODELNAME w4a8_gemm_Pipeline_VITIS_LOOP_64_1 RTLNAME w4a8_gemm_w4a8_gemm_Pipeline_VITIS_LOOP_64_1}
  {SRCNAME w4a8_gemm_Pipeline_3 MODELNAME w4a8_gemm_Pipeline_3 RTLNAME w4a8_gemm_w4a8_gemm_Pipeline_3}
  {SRCNAME w4a8_gemm_Pipeline_4 MODELNAME w4a8_gemm_Pipeline_4 RTLNAME w4a8_gemm_w4a8_gemm_Pipeline_4}
  {SRCNAME w4a8_gemm_Pipeline_VITIS_LOOP_85_2 MODELNAME w4a8_gemm_Pipeline_VITIS_LOOP_85_2 RTLNAME w4a8_gemm_w4a8_gemm_Pipeline_VITIS_LOOP_85_2}
  {SRCNAME w4a8_gemm_Pipeline_6 MODELNAME w4a8_gemm_Pipeline_6 RTLNAME w4a8_gemm_w4a8_gemm_Pipeline_6}
  {SRCNAME w4a8_gemm_Pipeline_7 MODELNAME w4a8_gemm_Pipeline_7 RTLNAME w4a8_gemm_w4a8_gemm_Pipeline_7}
  {SRCNAME w4a8_gemm_Pipeline_VITIS_LOOP_106_3 MODELNAME w4a8_gemm_Pipeline_VITIS_LOOP_106_3 RTLNAME w4a8_gemm_w4a8_gemm_Pipeline_VITIS_LOOP_106_3}
  {SRCNAME w4a8_gemm_Pipeline_9 MODELNAME w4a8_gemm_Pipeline_9 RTLNAME w4a8_gemm_w4a8_gemm_Pipeline_9}
  {SRCNAME w4a8_gemm MODELNAME w4a8_gemm RTLNAME w4a8_gemm IS_TOP 1
    SUBMODULES {
      {MODELNAME w4a8_gemm_m00_axi_input_buffer_RAM_AUTO_1R1W RTLNAME w4a8_gemm_m00_axi_input_buffer_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME w4a8_gemm_m00_axi_m_axi RTLNAME w4a8_gemm_m00_axi_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME w4a8_gemm_m01_axi_m_axi RTLNAME w4a8_gemm_m01_axi_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME w4a8_gemm_m02_axi_m_axi RTLNAME w4a8_gemm_m02_axi_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME w4a8_gemm_control_s_axi RTLNAME w4a8_gemm_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
    }
  }
}
