// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

(* BLOCK_STUB = "true" *)
module dsp_macro_0 (
  CLK,
  CE,
  SCLR,
  SEL,
  A,
  B,
  C,
  D,
  P
);

  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk_intf CLK" *)
  (* X_INTERFACE_MODE = "slave clk_intf" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:pcout_intf:carrycascout_intf:carryout_intf:bcout_intf:acout_intf:concat_intf:d_intf:c_intf:b_intf:a_intf:bcin_intf:acin_intf:pcin_intf:carryin_intf:carrycascin_intf:sel_intf, ASSOCIATED_RESET SCLR:SCLRD:SCLRA:SCLRB:SCLRCONCAT:SCLRC:SCLRM:SCLRP:SCLRSEL, ASSOCIATED_CLKEN CE:CED:CED1:CED2:CED3:CEA:CEA1:CEA2:CEA3:CEA4:CEB:CEB1:CEB2:CEB3:CEB4:CECONCAT:CECONCAT3:CECONCAT4:CECONCAT5:CEC:CEC1:CEC2:CEC3:CEC4:CEC5:CEM:CEP:CESEL:CESEL1:CESEL2:CESEL3:CESEL4:CESEL5, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN , ASSOCIATED_PORT , INSERT_VIP 0" *)
  input CLK;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *)
  (* X_INTERFACE_MODE = "slave ce_intf" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_HIGH" *)
  input CE;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 sclr_intf RST" *)
  (* X_INTERFACE_MODE = "slave sclr_intf" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME sclr_intf, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *)
  input SCLR;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 sel_intf DATA" *)
  (* X_INTERFACE_MODE = "slave sel_intf" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME sel_intf, LAYERED_METADATA undef" *)
  input [1:0]SEL;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 a_intf DATA" *)
  (* X_INTERFACE_MODE = "slave a_intf" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *)
  input [26:0]A;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 b_intf DATA" *)
  (* X_INTERFACE_MODE = "slave b_intf" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *)
  input [17:0]B;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 c_intf DATA" *)
  (* X_INTERFACE_MODE = "slave c_intf" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME c_intf, LAYERED_METADATA undef" *)
  input [47:0]C;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 d_intf DATA" *)
  (* X_INTERFACE_MODE = "slave d_intf" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME d_intf, LAYERED_METADATA undef" *)
  input [26:0]D;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 p_intf DATA" *)
  (* X_INTERFACE_MODE = "master p_intf" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *)
  output [47:0]P;

  // stub module has no contents

endmodule
