// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

(* BLOCK_STUB = "true" *)
module dsp_macro_exp_silu (
  A,
  B,
  C,
  P
);

  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 a_intf DATA" *)
  (* X_INTERFACE_MODE = "slave a_intf" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *)
  input [17:0]A;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 b_intf DATA" *)
  (* X_INTERFACE_MODE = "slave b_intf" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *)
  input [17:0]B;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 c_intf DATA" *)
  (* X_INTERFACE_MODE = "slave c_intf" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME c_intf, LAYERED_METADATA undef" *)
  input [35:0]C;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 p_intf DATA" *)
  (* X_INTERFACE_MODE = "master p_intf" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *)
  output [36:0]P;

  // stub module has no contents

endmodule
