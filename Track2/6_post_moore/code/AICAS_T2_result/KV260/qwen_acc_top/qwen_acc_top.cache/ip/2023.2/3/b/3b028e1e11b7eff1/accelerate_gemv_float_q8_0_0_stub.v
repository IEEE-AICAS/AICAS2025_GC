// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Mon Mar 24 15:43:18 2025
// Host        : DESKTOP-66QCD9K running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ accelerate_gemv_float_q8_0_0_stub.v
// Design      : accelerate_gemv_float_q8_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xck26-sfvc784-2LV-c
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "gemv_float_q8_v1_0,Vivado 2023.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(ip_aclk, ip_aresetn, s00_axi_ctrl_awaddr, 
  s00_axi_ctrl_awprot, s00_axi_ctrl_awvalid, s00_axi_ctrl_awready, s00_axi_ctrl_wdata, 
  s00_axi_ctrl_wstrb, s00_axi_ctrl_wvalid, s00_axi_ctrl_wready, s00_axi_ctrl_bresp, 
  s00_axi_ctrl_bvalid, s00_axi_ctrl_bready, s00_axi_ctrl_araddr, s00_axi_ctrl_arprot, 
  s00_axi_ctrl_arvalid, s00_axi_ctrl_arready, s00_axi_ctrl_rdata, s00_axi_ctrl_rresp, 
  s00_axi_ctrl_rvalid, s00_axi_ctrl_rready, s00_axis_readx_tready, s00_axis_readx_tdata, 
  s00_axis_readx_tstrb, s00_axis_readx_tlast, s00_axis_readx_tvalid, 
  s01_axis_readw_tready, s01_axis_readw_tdata, s01_axis_readw_tstrb, 
  s01_axis_readw_tlast, s01_axis_readw_tvalid, m00_axis_send_tvalid, m00_axis_send_tdata, 
  m00_axis_send_tstrb, m00_axis_send_tlast, m00_axis_send_tready)
/* synthesis syn_black_box black_box_pad_pin="ip_aresetn,s00_axi_ctrl_awaddr[3:0],s00_axi_ctrl_awprot[2:0],s00_axi_ctrl_awvalid,s00_axi_ctrl_awready,s00_axi_ctrl_wdata[31:0],s00_axi_ctrl_wstrb[3:0],s00_axi_ctrl_wvalid,s00_axi_ctrl_wready,s00_axi_ctrl_bresp[1:0],s00_axi_ctrl_bvalid,s00_axi_ctrl_bready,s00_axi_ctrl_araddr[3:0],s00_axi_ctrl_arprot[2:0],s00_axi_ctrl_arvalid,s00_axi_ctrl_arready,s00_axi_ctrl_rdata[31:0],s00_axi_ctrl_rresp[1:0],s00_axi_ctrl_rvalid,s00_axi_ctrl_rready,s00_axis_readx_tready,s00_axis_readx_tdata[31:0],s00_axis_readx_tstrb[3:0],s00_axis_readx_tlast,s00_axis_readx_tvalid,s01_axis_readw_tready,s01_axis_readw_tdata[31:0],s01_axis_readw_tstrb[3:0],s01_axis_readw_tlast,s01_axis_readw_tvalid,m00_axis_send_tvalid,m00_axis_send_tdata[31:0],m00_axis_send_tstrb[3:0],m00_axis_send_tlast,m00_axis_send_tready" */
/* synthesis syn_force_seq_prim="ip_aclk" */;
  input ip_aclk /* synthesis syn_isclock = 1 */;
  input ip_aresetn;
  input [3:0]s00_axi_ctrl_awaddr;
  input [2:0]s00_axi_ctrl_awprot;
  input s00_axi_ctrl_awvalid;
  output s00_axi_ctrl_awready;
  input [31:0]s00_axi_ctrl_wdata;
  input [3:0]s00_axi_ctrl_wstrb;
  input s00_axi_ctrl_wvalid;
  output s00_axi_ctrl_wready;
  output [1:0]s00_axi_ctrl_bresp;
  output s00_axi_ctrl_bvalid;
  input s00_axi_ctrl_bready;
  input [3:0]s00_axi_ctrl_araddr;
  input [2:0]s00_axi_ctrl_arprot;
  input s00_axi_ctrl_arvalid;
  output s00_axi_ctrl_arready;
  output [31:0]s00_axi_ctrl_rdata;
  output [1:0]s00_axi_ctrl_rresp;
  output s00_axi_ctrl_rvalid;
  input s00_axi_ctrl_rready;
  output s00_axis_readx_tready;
  input [31:0]s00_axis_readx_tdata;
  input [3:0]s00_axis_readx_tstrb;
  input s00_axis_readx_tlast;
  input s00_axis_readx_tvalid;
  output s01_axis_readw_tready;
  input [31:0]s01_axis_readw_tdata;
  input [3:0]s01_axis_readw_tstrb;
  input s01_axis_readw_tlast;
  input s01_axis_readw_tvalid;
  output m00_axis_send_tvalid;
  output [31:0]m00_axis_send_tdata;
  output [3:0]m00_axis_send_tstrb;
  output m00_axis_send_tlast;
  input m00_axis_send_tready;
endmodule
