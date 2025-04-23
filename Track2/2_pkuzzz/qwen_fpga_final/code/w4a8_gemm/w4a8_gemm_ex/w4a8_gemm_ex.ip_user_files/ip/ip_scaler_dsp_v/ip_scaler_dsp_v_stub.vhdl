-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1.2 (lin64) Build 3605665 Fri Aug  5 22:52:02 MDT 2022
-- Date        : Mon Feb 24 00:51:35 2025
-- Host        : admin2024-MS73-HB1-000 running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub
--               /home/xiping/workspace/kv260_rtl_kernel_test_vitis/rtl_kernel_test_100M_kernels/vivado_rtl_kernel/w4a8_gemm_ex/w4a8_gemm_ex.gen/sources_1/ip/ip_scaler_dsp_v/ip_scaler_dsp_v_stub.vhdl
-- Design      : ip_scaler_dsp_v
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xck26-sfvc784-2LV-c
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ip_scaler_dsp_v is
  Port ( 
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 16 downto 0 );
    B : in STD_LOGIC_VECTOR ( 7 downto 0 );
    D : in STD_LOGIC_VECTOR ( 16 downto 0 );
    P : out STD_LOGIC_VECTOR ( 25 downto 0 )
  );

end ip_scaler_dsp_v;

architecture stub of ip_scaler_dsp_v is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "CLK,A[16:0],B[7:0],D[16:0],P[25:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "dsp_macro_v1_0_2,Vivado 2022.1.2";
begin
end;
