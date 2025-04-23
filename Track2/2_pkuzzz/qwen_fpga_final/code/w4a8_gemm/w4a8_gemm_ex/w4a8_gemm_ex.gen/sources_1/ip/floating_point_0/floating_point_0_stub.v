// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1.2 (lin64) Build 3605665 Fri Aug  5 22:52:02 MDT 2022
// Date        : Mon Mar  3 17:27:34 2025
// Host        : admin2024-MS73-HB1-000 running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/xiping/workspace/kv260_rtl_kernel_test_vitis/rtl_kernel_test_100M_kernels/vivado_rtl_kernel/w4a8_gemm_ex/w4a8_gemm_ex.gen/sources_1/ip/floating_point_0/floating_point_0_stub.v
// Design      : floating_point_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xck26-sfvc784-2LV-c
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "floating_point_v7_1_14,Vivado 2022.1.2" *)
module floating_point_0(aclk, s_axis_a_tvalid, s_axis_a_tdata, 
  s_axis_a_tlast, s_axis_b_tvalid, s_axis_b_tdata, m_axis_result_tvalid, 
  m_axis_result_tdata, m_axis_result_tlast)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_a_tvalid,s_axis_a_tdata[15:0],s_axis_a_tlast,s_axis_b_tvalid,s_axis_b_tdata[15:0],m_axis_result_tvalid,m_axis_result_tdata[15:0],m_axis_result_tlast" */;
  input aclk;
  input s_axis_a_tvalid;
  input [15:0]s_axis_a_tdata;
  input s_axis_a_tlast;
  input s_axis_b_tvalid;
  input [15:0]s_axis_b_tdata;
  output m_axis_result_tvalid;
  output [15:0]m_axis_result_tdata;
  output m_axis_result_tlast;
endmodule
