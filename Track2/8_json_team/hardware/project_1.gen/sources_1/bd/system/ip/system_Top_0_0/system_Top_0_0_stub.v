// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
// Date        : Mon Feb 17 14:00:22 2025
// Host        : adnepukan-deepin running 64-bit Deepin 20.9
// Command     : write_verilog -force -mode synth_stub
//               /home/adnepukan/aicas4qwen/hardware/project_1/project_1.gen/sources_1/bd/system/ip/system_Top_0_0/system_Top_0_0_stub.v
// Design      : system_Top_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xck26-sfvc784-2LV-c
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "system_Top_0_0,Top,{}" *) (* CORE_GENERATION_INFO = "system_Top_0_0,Top,{x_ipProduct=Vivado 2024.2,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=Top,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* IP_DEFINITION_SOURCE = "module_ref" *) (* X_CORE_INFO = "Top,Vivado 2024.2" *) 
module system_Top_0_0(clock, reset, io_ddr_addr, io_ddr_dataWrite, 
  io_ddr_dataRead, io_ddr_en, io_ddr_writeEn, io_fromCPU_ready, io_fromCPU_valid, 
  io_fromCPU_bits, io_toCPU_ready, io_toCPU_valid, io_toCPU_bits, io_clk, io_rst)
/* synthesis syn_black_box black_box_pad_pin="reset,io_ddr_addr[28:0],io_ddr_dataWrite[511:0],io_ddr_dataRead[511:0],io_ddr_en,io_ddr_writeEn[63:0],io_fromCPU_ready,io_fromCPU_valid,io_fromCPU_bits[319:0],io_toCPU_ready,io_toCPU_valid,io_toCPU_bits[191:0],io_rst" */
/* synthesis syn_force_seq_prim="clock" */
/* synthesis syn_force_seq_prim="io_clk" */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clock CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clock, ASSOCIATED_RESET reset, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *) input clock /* synthesis syn_isclock = 1 */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input reset;
  input [28:0]io_ddr_addr;
  input [511:0]io_ddr_dataWrite;
  output [511:0]io_ddr_dataRead;
  input io_ddr_en;
  input [63:0]io_ddr_writeEn;
  output io_fromCPU_ready;
  input io_fromCPU_valid;
  input [319:0]io_fromCPU_bits;
  input io_toCPU_ready;
  output io_toCPU_valid;
  output [191:0]io_toCPU_bits;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 io_clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME io_clk, ASSOCIATED_RESET io_rst, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *) input io_clk /* synthesis syn_isclock = 1 */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 io_rst RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME io_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input io_rst;
endmodule
