// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2025 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:user:gemv_float_q8:1.0
// IP Revision: 12

(* X_CORE_INFO = "gemv_float_q8_v1_0,Vivado 2023.2" *)
(* CHECK_LICENSE_TYPE = "accelerate_gemv_float_q8_0_0,gemv_float_q8_v1_0,{}" *)
(* CORE_GENERATION_INFO = "accelerate_gemv_float_q8_0_0,gemv_float_q8_v1_0,{x_ipProduct=Vivado 2023.2,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=gemv_float_q8,x_ipVersion=1.0,x_ipCoreRevision=12,x_ipLanguage=VERILOG,x_ipSimLanguage=VERILOG,C_S00_AXI_CTRL_DATA_WIDTH=32,C_S00_AXI_CTRL_ADDR_WIDTH=4,C_S00_AXIS_READX_TDATA_WIDTH=32,C_M00_AXIS_SEND_TDATA_WIDTH=32,C_M00_AXIS_SEND_START_COUNT=32,C_S01_AXIS_READW_TDATA_WIDTH=32,Q_WIDTH=8,S_WIDTH=32,GS=64,I_DIM=896,O_DIM=16}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module accelerate_gemv_float_q8_0_0 (
  ip_aclk,
  ip_aresetn,
  s00_axi_ctrl_awaddr,
  s00_axi_ctrl_awprot,
  s00_axi_ctrl_awvalid,
  s00_axi_ctrl_awready,
  s00_axi_ctrl_wdata,
  s00_axi_ctrl_wstrb,
  s00_axi_ctrl_wvalid,
  s00_axi_ctrl_wready,
  s00_axi_ctrl_bresp,
  s00_axi_ctrl_bvalid,
  s00_axi_ctrl_bready,
  s00_axi_ctrl_araddr,
  s00_axi_ctrl_arprot,
  s00_axi_ctrl_arvalid,
  s00_axi_ctrl_arready,
  s00_axi_ctrl_rdata,
  s00_axi_ctrl_rresp,
  s00_axi_ctrl_rvalid,
  s00_axi_ctrl_rready,
  s00_axis_readx_tready,
  s00_axis_readx_tdata,
  s00_axis_readx_tstrb,
  s00_axis_readx_tlast,
  s00_axis_readx_tvalid,
  s01_axis_readw_tready,
  s01_axis_readw_tdata,
  s01_axis_readw_tstrb,
  s01_axis_readw_tlast,
  s01_axis_readw_tvalid,
  m00_axis_send_tvalid,
  m00_axis_send_tdata,
  m00_axis_send_tstrb,
  m00_axis_send_tlast,
  m00_axis_send_tready
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ip_aclk, ASSOCIATED_RESET ip_aresetn, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN accelerate_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ip_aclk CLK" *)
input wire ip_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ip_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ip_aresetn RST" *)
input wire ip_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL AWADDR" *)
input wire [3 : 0] s00_axi_ctrl_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL AWPROT" *)
input wire [2 : 0] s00_axi_ctrl_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL AWVALID" *)
input wire s00_axi_ctrl_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL AWREADY" *)
output wire s00_axi_ctrl_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL WDATA" *)
input wire [31 : 0] s00_axi_ctrl_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL WSTRB" *)
input wire [3 : 0] s00_axi_ctrl_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL WVALID" *)
input wire s00_axi_ctrl_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL WREADY" *)
output wire s00_axi_ctrl_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL BRESP" *)
output wire [1 : 0] s00_axi_ctrl_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL BVALID" *)
output wire s00_axi_ctrl_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL BREADY" *)
input wire s00_axi_ctrl_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL ARADDR" *)
input wire [3 : 0] s00_axi_ctrl_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL ARPROT" *)
input wire [2 : 0] s00_axi_ctrl_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL ARVALID" *)
input wire s00_axi_ctrl_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL ARREADY" *)
output wire s00_axi_ctrl_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL RDATA" *)
output wire [31 : 0] s00_axi_ctrl_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL RRESP" *)
output wire [1 : 0] s00_axi_ctrl_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL RVALID" *)
output wire s00_axi_ctrl_rvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_CTRL, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 4, SUPPORTS_NARROW_BURST 0, FREQ_HZ 99999001, DATA_WIDTH 32, PROTOCOL AXI4LITE, ID_WIDTH 0, ADDR_WIDTH 4, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 1, PHASE 0.0, NUM_READ_THREADS 1, NUM_WRITE_TH\
READS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_CTRL RREADY" *)
input wire s00_axi_ctrl_rready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS_READX TREADY" *)
output wire s00_axis_readx_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS_READX TDATA" *)
input wire [31 : 0] s00_axis_readx_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS_READX TSTRB" *)
input wire [3 : 0] s00_axis_readx_tstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS_READX TLAST" *)
input wire s00_axis_readx_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXIS_READX, WIZ_DATA_WIDTH 32, FREQ_HZ 99999001, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 0, HAS_TLAST 1, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS_READX TVALID" *)
input wire s00_axis_readx_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S01_AXIS_READW TREADY" *)
output wire s01_axis_readw_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S01_AXIS_READW TDATA" *)
input wire [31 : 0] s01_axis_readw_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S01_AXIS_READW TSTRB" *)
input wire [3 : 0] s01_axis_readw_tstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S01_AXIS_READW TLAST" *)
input wire s01_axis_readw_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S01_AXIS_READW, WIZ_DATA_WIDTH 32, FREQ_HZ 99999001, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 0, HAS_TLAST 1, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S01_AXIS_READW TVALID" *)
input wire s01_axis_readw_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS_SEND TVALID" *)
output wire m00_axis_send_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS_SEND TDATA" *)
output wire [31 : 0] m00_axis_send_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS_SEND TSTRB" *)
output wire [3 : 0] m00_axis_send_tstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS_SEND TLAST" *)
output wire m00_axis_send_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M00_AXIS_SEND, WIZ_DATA_WIDTH 32, FREQ_HZ 99999001, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 0, HAS_TLAST 1, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS_SEND TREADY" *)
input wire m00_axis_send_tready;

  gemv_float_q8_v1_0 #(
    .C_S00_AXI_CTRL_DATA_WIDTH(32),  // Width of S_AXI data bus
    .C_S00_AXI_CTRL_ADDR_WIDTH(4),  // Width of S_AXI address bus
    .C_S00_AXIS_READX_TDATA_WIDTH(32),  // AXI4Stream sink: Data Width
    .C_M00_AXIS_SEND_TDATA_WIDTH(32),  // Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
    .C_M00_AXIS_SEND_START_COUNT(32),  // Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
    .C_S01_AXIS_READW_TDATA_WIDTH(32),  // AXI4Stream sink: Data Width
    .Q_WIDTH(8),
    .S_WIDTH(32),
    .GS(64),
    .I_DIM(896),
    .O_DIM(16)
  ) inst (
    .ip_aclk(ip_aclk),
    .ip_aresetn(ip_aresetn),
    .s00_axi_ctrl_awaddr(s00_axi_ctrl_awaddr),
    .s00_axi_ctrl_awprot(s00_axi_ctrl_awprot),
    .s00_axi_ctrl_awvalid(s00_axi_ctrl_awvalid),
    .s00_axi_ctrl_awready(s00_axi_ctrl_awready),
    .s00_axi_ctrl_wdata(s00_axi_ctrl_wdata),
    .s00_axi_ctrl_wstrb(s00_axi_ctrl_wstrb),
    .s00_axi_ctrl_wvalid(s00_axi_ctrl_wvalid),
    .s00_axi_ctrl_wready(s00_axi_ctrl_wready),
    .s00_axi_ctrl_bresp(s00_axi_ctrl_bresp),
    .s00_axi_ctrl_bvalid(s00_axi_ctrl_bvalid),
    .s00_axi_ctrl_bready(s00_axi_ctrl_bready),
    .s00_axi_ctrl_araddr(s00_axi_ctrl_araddr),
    .s00_axi_ctrl_arprot(s00_axi_ctrl_arprot),
    .s00_axi_ctrl_arvalid(s00_axi_ctrl_arvalid),
    .s00_axi_ctrl_arready(s00_axi_ctrl_arready),
    .s00_axi_ctrl_rdata(s00_axi_ctrl_rdata),
    .s00_axi_ctrl_rresp(s00_axi_ctrl_rresp),
    .s00_axi_ctrl_rvalid(s00_axi_ctrl_rvalid),
    .s00_axi_ctrl_rready(s00_axi_ctrl_rready),
    .s00_axis_readx_tready(s00_axis_readx_tready),
    .s00_axis_readx_tdata(s00_axis_readx_tdata),
    .s00_axis_readx_tstrb(s00_axis_readx_tstrb),
    .s00_axis_readx_tlast(s00_axis_readx_tlast),
    .s00_axis_readx_tvalid(s00_axis_readx_tvalid),
    .s01_axis_readw_tready(s01_axis_readw_tready),
    .s01_axis_readw_tdata(s01_axis_readw_tdata),
    .s01_axis_readw_tstrb(s01_axis_readw_tstrb),
    .s01_axis_readw_tlast(s01_axis_readw_tlast),
    .s01_axis_readw_tvalid(s01_axis_readw_tvalid),
    .m00_axis_send_tvalid(m00_axis_send_tvalid),
    .m00_axis_send_tdata(m00_axis_send_tdata),
    .m00_axis_send_tstrb(m00_axis_send_tstrb),
    .m00_axis_send_tlast(m00_axis_send_tlast),
    .m00_axis_send_tready(m00_axis_send_tready)
  );
endmodule
