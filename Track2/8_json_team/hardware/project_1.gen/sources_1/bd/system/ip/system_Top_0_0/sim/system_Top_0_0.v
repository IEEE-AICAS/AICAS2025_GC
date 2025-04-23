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


// IP VLNV: xilinx.com:module_ref:Top:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_Top_0_0 (
  clock,
  reset,
  io_ddr_addr,
  io_ddr_dataWrite,
  io_ddr_dataRead,
  io_ddr_en,
  io_ddr_writeEn,
  io_fromCPU_ready,
  io_fromCPU_valid,
  io_fromCPU_bits,
  io_toCPU_ready,
  io_toCPU_valid,
  io_toCPU_bits,
  io_clk,
  io_rst
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clock CLK" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clock, ASSOCIATED_RESET reset, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *)
input wire clock;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset RST" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
input wire reset;
input wire [28 : 0] io_ddr_addr;
input wire [511 : 0] io_ddr_dataWrite;
output wire [511 : 0] io_ddr_dataRead;
input wire io_ddr_en;
input wire [63 : 0] io_ddr_writeEn;
output wire io_fromCPU_ready;
input wire io_fromCPU_valid;
input wire [319 : 0] io_fromCPU_bits;
input wire io_toCPU_ready;
output wire io_toCPU_valid;
output wire [191 : 0] io_toCPU_bits;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 io_clk CLK" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME io_clk, ASSOCIATED_RESET io_rst, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *)
input wire io_clk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 io_rst RST" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME io_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
input wire io_rst;

  Top inst (
    .clock(clock),
    .reset(reset),
    .io_ddr_addr(io_ddr_addr),
    .io_ddr_dataWrite(io_ddr_dataWrite),
    .io_ddr_dataRead(io_ddr_dataRead),
    .io_ddr_en(io_ddr_en),
    .io_ddr_writeEn(io_ddr_writeEn),
    .io_fromCPU_ready(io_fromCPU_ready),
    .io_fromCPU_valid(io_fromCPU_valid),
    .io_fromCPU_bits(io_fromCPU_bits),
    .io_toCPU_ready(io_toCPU_ready),
    .io_toCPU_valid(io_toCPU_valid),
    .io_toCPU_bits(io_toCPU_bits),
    .io_clk(io_clk),
    .io_rst(io_rst)
  );
endmodule
