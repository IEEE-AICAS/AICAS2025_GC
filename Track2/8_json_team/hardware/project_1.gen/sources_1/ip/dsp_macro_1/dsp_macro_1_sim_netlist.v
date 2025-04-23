// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
// Date        : Wed Feb 12 00:49:26 2025
// Host        : adnepukan-deepin running 64-bit Deepin 20.9
// Command     : write_verilog -force -mode funcsim
//               /home/adnepukan/aicas4qwen/hardware/project_1/project_1.gen/sources_1/ip/dsp_macro_1/dsp_macro_1_sim_netlist.v
// Design      : dsp_macro_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xck26-sfvc784-2LV-c
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dsp_macro_1,dsp_macro_v1_0_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dsp_macro_v1_0_7,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module dsp_macro_1
   (CLK,
    CE,
    SCLR,
    A,
    B,
    C,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_mode = "slave clk_intf" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:pcout_intf:carrycascout_intf:carryout_intf:bcout_intf:acout_intf:concat_intf:d_intf:c_intf:b_intf:a_intf:bcin_intf:acin_intf:pcin_intf:carryin_intf:carrycascin_intf:sel_intf, ASSOCIATED_RESET SCLR:SCLRD:SCLRA:SCLRB:SCLRCONCAT:SCLRC:SCLRM:SCLRP:SCLRSEL, ASSOCIATED_CLKEN CE:CED:CED1:CED2:CED3:CEA:CEA1:CEA2:CEA3:CEA4:CEB:CEB1:CEB2:CEB3:CEB4:CECONCAT:CECONCAT3:CECONCAT4:CECONCAT5:CEC:CEC1:CEC2:CEC3:CEC4:CEC5:CEM:CEP:CESEL:CESEL1:CESEL2:CESEL3:CESEL4:CESEL5, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_mode = "slave ce_intf" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_HIGH" *) input CE;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 sclr_intf RST" *) (* x_interface_mode = "slave sclr_intf" *) (* x_interface_parameter = "XIL_INTERFACENAME sclr_intf, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *) input SCLR;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_mode = "slave a_intf" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [11:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_mode = "slave b_intf" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [17:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 c_intf DATA" *) (* x_interface_mode = "slave c_intf" *) (* x_interface_parameter = "XIL_INTERFACENAME c_intf, LAYERED_METADATA undef" *) input [27:0]C;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_mode = "master p_intf" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [30:0]P;

  wire [11:0]A;
  wire [17:0]B;
  wire [27:0]C;
  wire CE;
  wire CLK;
  wire [30:0]P;
  wire SCLR;
  wire NLW_U0_CARRYCASCOUT_UNCONNECTED;
  wire NLW_U0_CARRYOUT_UNCONNECTED;
  wire [29:0]NLW_U0_ACOUT_UNCONNECTED;
  wire [17:0]NLW_U0_BCOUT_UNCONNECTED;
  wire [47:0]NLW_U0_PCOUT_UNCONNECTED;

  (* C_A_WIDTH = "12" *) 
  (* C_B_WIDTH = "18" *) 
  (* C_CONCAT_WIDTH = "48" *) 
  (* C_CONSTANT_1 = "1" *) 
  (* C_C_WIDTH = "28" *) 
  (* C_D_WIDTH = "18" *) 
  (* C_HAS_A = "1" *) 
  (* C_HAS_ACIN = "0" *) 
  (* C_HAS_ACOUT = "0" *) 
  (* C_HAS_B = "1" *) 
  (* C_HAS_BCIN = "0" *) 
  (* C_HAS_BCOUT = "0" *) 
  (* C_HAS_C = "1" *) 
  (* C_HAS_CARRYCASCIN = "0" *) 
  (* C_HAS_CARRYCASCOUT = "0" *) 
  (* C_HAS_CARRYIN = "0" *) 
  (* C_HAS_CARRYOUT = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_CEA = "0" *) 
  (* C_HAS_CEB = "0" *) 
  (* C_HAS_CEC = "0" *) 
  (* C_HAS_CECONCAT = "0" *) 
  (* C_HAS_CED = "0" *) 
  (* C_HAS_CEM = "0" *) 
  (* C_HAS_CEP = "0" *) 
  (* C_HAS_CESEL = "0" *) 
  (* C_HAS_CONCAT = "0" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_INDEP_CE = "0" *) 
  (* C_HAS_INDEP_SCLR = "0" *) 
  (* C_HAS_PCIN = "0" *) 
  (* C_HAS_PCOUT = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SCLRA = "0" *) 
  (* C_HAS_SCLRB = "0" *) 
  (* C_HAS_SCLRC = "0" *) 
  (* C_HAS_SCLRCONCAT = "0" *) 
  (* C_HAS_SCLRD = "0" *) 
  (* C_HAS_SCLRM = "0" *) 
  (* C_HAS_SCLRP = "0" *) 
  (* C_HAS_SCLRSEL = "0" *) 
  (* C_LATENCY = "128" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_OPMODES = "000100111000010100000000" *) 
  (* C_P_LSB = "0" *) 
  (* C_P_MSB = "30" *) 
  (* C_REG_CONFIG = "00000000000000000000000001000100" *) 
  (* C_SEL_WIDTH = "0" *) 
  (* C_SQUARE_FCN = "0" *) 
  (* C_TEST_CORE = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  dsp_macro_1_dsp_macro_v1_0_7 U0
       (.A(A),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_U0_ACOUT_UNCONNECTED[29:0]),
        .B(B),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_U0_BCOUT_UNCONNECTED[17:0]),
        .C(C),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_U0_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYOUT(NLW_U0_CARRYOUT_UNCONNECTED),
        .CE(CE),
        .CEA(1'b1),
        .CEA1(1'b1),
        .CEA2(1'b1),
        .CEA3(1'b1),
        .CEA4(1'b1),
        .CEB(1'b1),
        .CEB1(1'b1),
        .CEB2(1'b1),
        .CEB3(1'b1),
        .CEB4(1'b1),
        .CEC(1'b1),
        .CEC1(1'b1),
        .CEC2(1'b1),
        .CEC3(1'b1),
        .CEC4(1'b1),
        .CEC5(1'b1),
        .CECONCAT(1'b1),
        .CECONCAT3(1'b1),
        .CECONCAT4(1'b1),
        .CECONCAT5(1'b1),
        .CED(1'b1),
        .CED1(1'b1),
        .CED2(1'b1),
        .CED3(1'b1),
        .CEM(1'b1),
        .CEP(1'b1),
        .CESEL(1'b1),
        .CESEL1(1'b1),
        .CESEL2(1'b1),
        .CESEL3(1'b1),
        .CESEL4(1'b1),
        .CESEL5(1'b1),
        .CLK(CLK),
        .CONCAT({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .P(P),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_U0_PCOUT_UNCONNECTED[47:0]),
        .SCLR(SCLR),
        .SCLRA(1'b0),
        .SCLRB(1'b0),
        .SCLRC(1'b0),
        .SCLRCONCAT(1'b0),
        .SCLRD(1'b0),
        .SCLRM(1'b0),
        .SCLRP(1'b0),
        .SCLRSEL(1'b0),
        .SEL(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2024.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
CuSIDRPSCLqvfieIk2rFSAJ1BHmtwRFyKrWRWtCYcA3H7dxnVaqhefwLH/fKtBh5mXZuNabpVD9/
ZdJEt4XGGUsM2Cnnnq3mVYfkCXx5yV68DULqpBO8BZjT7U2oFyPV8+oRfOBPiFGXBprW5HwqiZhG
SHnBsyJZk8VKxgIjzHE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
MF1qtyHCwR6riXabh/dGj/uojZQb7LWMCiDwb8vI+96M2HxX0eTs2LM9Sdzb6gtQmpxMH/LR/Pf/
BO5pe+Uz/u8fn81B3D0FG32P2rXTvGtQ2vMf+PFo0Y8YnhY3mOuvoDZqI4QOv8xSJkH4OlDNGg0r
4QrkqtwiJ4FhA4Ll1xXkcVZd7lghoQ71wt5S7Z8SiwgDSndp1nAKU/hUj8DvGvy/jplkD/DUARFw
CRjGHKLV2yfGGdE0D/MZ5G38dmJdn3Cfh39jH9FeYPWyhuhO5NW2zVzYywhCr6Ls3R8rbhwbmKCo
pCRIXOHQ7ugEVwxUC8pk/jQp8WL1/8bWwy54Bg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
luQHy1m8ciBq15jA72Cpt7V9YeqPs2eCtaMzp3h0umQDPOuH/IODV6pgmcxYZydO6b4rkFq++fZq
8z2f92D/lhHI7ez6n9XnFT/X+COsTFSOdPM8mrCvH+tEDMQAVOtknWoywaj6UAv52wNB3xda1037
DGPkO3aKM53MPDKlM00=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LMKIM07GdsHUJtwzFFfSj3Gyyd3SORspHtZqkX9p4VfnJTDyqmjulckguKAJSSW4RkEyhvXniVsz
qbjiEifjwPY0tvB3qKiMdM/Ay4UbJGUgjOFR52LZySLLodNHWGI8mB8JC/AtBiJxzbVNCfcOMl4v
LaxFKOy1RRxnhn3OIRV6vC4SjuC94StpI9SFlrbIkfh34d6dDitK5XHiAfG60Tuz66kf5WcwNdOo
D+QK0bpThVs3Gm7JZnIFqPeM03hrPTbeLgoRowGmwo4iMqN7+dpV3e+O5wYPMEbhrBIuvzi7875J
jPXWXyawnJCHh1qfFVthW8ilyqN5oSmnbF7gsQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
C5/YhNxNT8PRB8AYWtb7fRmu9FNKuVWgwIvmD0qqRXDdu9eTyMzeA3fJhVAea+XLnjukEcvdArTK
rG+7m0QKz+rBn2DBzj27SGjExdUm0w48syyUomlsyM6Haza2VHn9aiek3KQkNqTTJuJ7g5nBQ/yk
Esujl+JqAMBSgqsogJH/VZ0qHCC27SBFioXSduaGcggcz9bdtQT13SaTMvTmRaYisAvh6PiRrwj6
rVyJ918O6LlsxEMNfhvHogd/2mPVRUCsPWNTwzCPLVytO7YkyWm63dgPzXxSgoL/ozTPG0Zsv2tI
LmnKHqxBKOs1lho6lrEApXjqbLZyw1Gp/ZL5IQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2023_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
gjkCd4dNreUOkeJ8xazCCUl6+FBKbdbfO6kvIp4gAOFITLSfFUuw6mrl0+4mBA7XtgzfdX2NO0KZ
VgYIZ5v374csj0RX80vn87p1gW+FFIPwZhL4+6DphCn19qN0VfCZx03pkOhz5aSXskVrDeeZMZkA
8wuBDuaRyTN6Vw1RiRwAZb2zkerYrayjxW8eqtLa50GMjz2cJH+8VZRE1SnfS401eaGV8/03Vd2C
J2ahXDMgpipjPdFt5rvdqAaQ3GzpF0JHXBTvFCQ1Vg3qZL0CBLzIhvqYq7+pgNA/6qxvUYTytFi0
CXsCXJ20FEt0QufDHpCmiig5DZQy/ucQa0xB7g==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
hsMMPB9Ip0RNBx4zb6W38Nid8NmF6g03U/f7DMyWoSL/XSL2pcTVkDDaUBqNhmr4I32WpKsA4uDt
LwxcKdefZQ3C8C+kNQeEgmj611Ry1zzGs2urQFqD10UK6C5YGujmeGiAz78vsbGxF3YU1ezUZv+A
UWBM2RRnsFbLTWbUeZotWpIM5torDypIGchCvJkLIsKInNfwG8oZEQO8ibd/ZgIuuDVfCBR7sybW
Md7XW16BkgEGF2LgcvgVH4YI/LJNpZj+4wIGXb2zX36lMMrVw4A8LDwvj65vyyL4SDxtXWHOdLjg
Eqyya82/2KAHogtvgjKvmJykbFtTHV/SeSXiGA==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
xzYvjiRvkurUKUFHyIlWum67Zv6EgY+IjYjMLickNV6P3Cbhp8A+a8TllbFMUC3XKmw2vDcIz7Px
ygTWbUWb3lH8Y45PETv46E1v3Dq5eCQsKMUcbYAtcwDu0AuyjHt1zsDLGXy4rCKTZXNoTTNSA7q6
AjUbUUiCbzFk5rH1nYLUuGVYaz5wRgv1fzkqjw6vG8Uu9gV8KsplIa7itkkUeWf8eQ/4q2c7Kdpr
C029jt0DcJMKBpb2iw8eNh5BsxDqa+qp40oLkZjRhwaX7Iaf7FPpOGnZUCF2Zj7Wz0Dz/6AhQR1n
/yzfG8ihn4h6jra1vajQzA2jXO4wsh+TG5q/b6B9BujXh0+PEcgdKEAF9ufKtBNdysyOFh+FSEqY
VvNoxu0/V2i/J3JDcWa/a5ovjlomn2cqNwFdByYCKlAST2jrogNY7kxXDD5H5AODG07lidT6JS1M
PSc3SnQrr/LlfpdM676vcYGeBFGbyB91hDgMqRSnAOhaTPz06dYOSTqB

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
H7d1BVeC13rLw/CSEnbaPIjA7qfZyFPjAqif/3O3hIWeIgCSVX/nKTMPhIP1oOvFwgqze5jjU29L
thPx/Upl+Aa2HshO1v4MWP99OOgz1mBwUxzMncjEv0axfnaKXojUohk5y/dvA1Y1c7KN8+ZgftRf
7lEBHSCSTblYmH6OcCuuCI+guU1O9hu5TAcuXi2cRqAuDHWr0mejniM4qmO+jzDq2WhpIF+F3H0N
+JqxFfG2Odq6cbByB+uGyUnbpVV26DZdq5aOH+51GTVG58C8WVRTbcgiFWZguJ/gW4ge3Wd90q9e
wg7knRThOjywIPIdyGM6L6KktmZ/cS9tcSEbFA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
FTJsMMZzgmF2aPDoZmMqMX/RZWz+GFa5W34/fCnqmEiq8P1YvtpbThViH+Q+OVoN4QJtLPb6DzeD
+MqWvuCBDGsNCz3wGBOisMPwZK2MLJKMj25eu2aJL3bYy1c+F0wBkbLcZHEmxvpbD7mXV+55uL3Z
DF0/xdxrnE+4lFTMcnUhlv3/Se1WOA2bavo6Sx2tUvTDY80sgW6eFVUG+ngZjFtFfE2tDTzObqX0
ONp+WU6nqSTQXEmkX6Sg/XDGR/vhyOv5jLk7GV3qDiwhDH8keeQVQMJXVJl6e5iVhlGbrIm+vFoZ
ZGr3c72zasz4qRfRmRE29O/TWV+R7zyuYq/hXg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
R2P4WRjoL058k3jsZl1El3msGeWoxWkAQKZH30FnOTjO9gQrVnyBsRswmHoDk1st31qOZNgTq0SF
045vOcrZmJjhCN07ntO0XV/l1erwr3E9fpoTSPlQcqZMK/rVGBlzLsboKu8O38eZM+ehXkhFIZvB
fpsfXJioXRVyq1jVi51hYs3ncnWsQAr03xfSB8pEOY4TehKt/Iw3S1Aj3w1rq04/3dMS7il3+Vbo
vfWy5LceCzJAWQEqg8cdLVsg+pV4pHVLOrgElg3kmtGTi+jxPXUxHiX6ViWqTR05Y5PNihi2ZcE7
sODAwhM5627hQt4DO1o3Fb0vXntWkGVOVH6p+Q==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 10688)
`pragma protect data_block
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
HcA1Sdl0X8C8kRUwdc7h9OhhUH+DbQZBq3899NA=
`pragma protect end_protected
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2024.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
CuSIDRPSCLqvfieIk2rFSAJ1BHmtwRFyKrWRWtCYcA3H7dxnVaqhefwLH/fKtBh5mXZuNabpVD9/
ZdJEt4XGGUsM2Cnnnq3mVYfkCXx5yV68DULqpBO8BZjT7U2oFyPV8+oRfOBPiFGXBprW5HwqiZhG
SHnBsyJZk8VKxgIjzHE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
MF1qtyHCwR6riXabh/dGj/uojZQb7LWMCiDwb8vI+96M2HxX0eTs2LM9Sdzb6gtQmpxMH/LR/Pf/
BO5pe+Uz/u8fn81B3D0FG32P2rXTvGtQ2vMf+PFo0Y8YnhY3mOuvoDZqI4QOv8xSJkH4OlDNGg0r
4QrkqtwiJ4FhA4Ll1xXkcVZd7lghoQ71wt5S7Z8SiwgDSndp1nAKU/hUj8DvGvy/jplkD/DUARFw
CRjGHKLV2yfGGdE0D/MZ5G38dmJdn3Cfh39jH9FeYPWyhuhO5NW2zVzYywhCr6Ls3R8rbhwbmKCo
pCRIXOHQ7ugEVwxUC8pk/jQp8WL1/8bWwy54Bg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
luQHy1m8ciBq15jA72Cpt7V9YeqPs2eCtaMzp3h0umQDPOuH/IODV6pgmcxYZydO6b4rkFq++fZq
8z2f92D/lhHI7ez6n9XnFT/X+COsTFSOdPM8mrCvH+tEDMQAVOtknWoywaj6UAv52wNB3xda1037
DGPkO3aKM53MPDKlM00=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LMKIM07GdsHUJtwzFFfSj3Gyyd3SORspHtZqkX9p4VfnJTDyqmjulckguKAJSSW4RkEyhvXniVsz
qbjiEifjwPY0tvB3qKiMdM/Ay4UbJGUgjOFR52LZySLLodNHWGI8mB8JC/AtBiJxzbVNCfcOMl4v
LaxFKOy1RRxnhn3OIRV6vC4SjuC94StpI9SFlrbIkfh34d6dDitK5XHiAfG60Tuz66kf5WcwNdOo
D+QK0bpThVs3Gm7JZnIFqPeM03hrPTbeLgoRowGmwo4iMqN7+dpV3e+O5wYPMEbhrBIuvzi7875J
jPXWXyawnJCHh1qfFVthW8ilyqN5oSmnbF7gsQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
C5/YhNxNT8PRB8AYWtb7fRmu9FNKuVWgwIvmD0qqRXDdu9eTyMzeA3fJhVAea+XLnjukEcvdArTK
rG+7m0QKz+rBn2DBzj27SGjExdUm0w48syyUomlsyM6Haza2VHn9aiek3KQkNqTTJuJ7g5nBQ/yk
Esujl+JqAMBSgqsogJH/VZ0qHCC27SBFioXSduaGcggcz9bdtQT13SaTMvTmRaYisAvh6PiRrwj6
rVyJ918O6LlsxEMNfhvHogd/2mPVRUCsPWNTwzCPLVytO7YkyWm63dgPzXxSgoL/ozTPG0Zsv2tI
LmnKHqxBKOs1lho6lrEApXjqbLZyw1Gp/ZL5IQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2023_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
gjkCd4dNreUOkeJ8xazCCUl6+FBKbdbfO6kvIp4gAOFITLSfFUuw6mrl0+4mBA7XtgzfdX2NO0KZ
VgYIZ5v374csj0RX80vn87p1gW+FFIPwZhL4+6DphCn19qN0VfCZx03pkOhz5aSXskVrDeeZMZkA
8wuBDuaRyTN6Vw1RiRwAZb2zkerYrayjxW8eqtLa50GMjz2cJH+8VZRE1SnfS401eaGV8/03Vd2C
J2ahXDMgpipjPdFt5rvdqAaQ3GzpF0JHXBTvFCQ1Vg3qZL0CBLzIhvqYq7+pgNA/6qxvUYTytFi0
CXsCXJ20FEt0QufDHpCmiig5DZQy/ucQa0xB7g==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
hsMMPB9Ip0RNBx4zb6W38Nid8NmF6g03U/f7DMyWoSL/XSL2pcTVkDDaUBqNhmr4I32WpKsA4uDt
LwxcKdefZQ3C8C+kNQeEgmj611Ry1zzGs2urQFqD10UK6C5YGujmeGiAz78vsbGxF3YU1ezUZv+A
UWBM2RRnsFbLTWbUeZotWpIM5torDypIGchCvJkLIsKInNfwG8oZEQO8ibd/ZgIuuDVfCBR7sybW
Md7XW16BkgEGF2LgcvgVH4YI/LJNpZj+4wIGXb2zX36lMMrVw4A8LDwvj65vyyL4SDxtXWHOdLjg
Eqyya82/2KAHogtvgjKvmJykbFtTHV/SeSXiGA==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
xzYvjiRvkurUKUFHyIlWum67Zv6EgY+IjYjMLickNV6P3Cbhp8A+a8TllbFMUC3XKmw2vDcIz7Px
ygTWbUWb3lH8Y45PETv46E1v3Dq5eCQsKMUcbYAtcwDu0AuyjHt1zsDLGXy4rCKTZXNoTTNSA7q6
AjUbUUiCbzFk5rH1nYLUuGVYaz5wRgv1fzkqjw6vG8Uu9gV8KsplIa7itkkUeWf8eQ/4q2c7Kdpr
C029jt0DcJMKBpb2iw8eNh5BsxDqa+qp40oLkZjRhwaX7Iaf7FPpOGnZUCF2Zj7Wz0Dz/6AhQR1n
/yzfG8ihn4h6jra1vajQzA2jXO4wsh+TG5q/b6B9BujXh0+PEcgdKEAF9ufKtBNdysyOFh+FSEqY
VvNoxu0/V2i/J3JDcWa/a5ovjlomn2cqNwFdByYCKlAST2jrogNY7kxXDD5H5AODG07lidT6JS1M
PSc3SnQrr/LlfpdM676vcYGeBFGbyB91hDgMqRSnAOhaTPz06dYOSTqB

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
H7d1BVeC13rLw/CSEnbaPIjA7qfZyFPjAqif/3O3hIWeIgCSVX/nKTMPhIP1oOvFwgqze5jjU29L
thPx/Upl+Aa2HshO1v4MWP99OOgz1mBwUxzMncjEv0axfnaKXojUohk5y/dvA1Y1c7KN8+ZgftRf
7lEBHSCSTblYmH6OcCuuCI+guU1O9hu5TAcuXi2cRqAuDHWr0mejniM4qmO+jzDq2WhpIF+F3H0N
+JqxFfG2Odq6cbByB+uGyUnbpVV26DZdq5aOH+51GTVG58C8WVRTbcgiFWZguJ/gW4ge3Wd90q9e
wg7knRThOjywIPIdyGM6L6KktmZ/cS9tcSEbFA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
FTJsMMZzgmF2aPDoZmMqMX/RZWz+GFa5W34/fCnqmEiq8P1YvtpbThViH+Q+OVoN4QJtLPb6DzeD
+MqWvuCBDGsNCz3wGBOisMPwZK2MLJKMj25eu2aJL3bYy1c+F0wBkbLcZHEmxvpbD7mXV+55uL3Z
DF0/xdxrnE+4lFTMcnUhlv3/Se1WOA2bavo6Sx2tUvTDY80sgW6eFVUG+ngZjFtFfE2tDTzObqX0
ONp+WU6nqSTQXEmkX6Sg/XDGR/vhyOv5jLk7GV3qDiwhDH8keeQVQMJXVJl6e5iVhlGbrIm+vFoZ
ZGr3c72zasz4qRfRmRE29O/TWV+R7zyuYq/hXg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
R2P4WRjoL058k3jsZl1El3msGeWoxWkAQKZH30FnOTjO9gQrVnyBsRswmHoDk1st31qOZNgTq0SF
045vOcrZmJjhCN07ntO0XV/l1erwr3E9fpoTSPlQcqZMK/rVGBlzLsboKu8O38eZM+ehXkhFIZvB
fpsfXJioXRVyq1jVi51hYs3ncnWsQAr03xfSB8pEOY4TehKt/Iw3S1Aj3w1rq04/3dMS7il3+Vbo
vfWy5LceCzJAWQEqg8cdLVsg+pV4pHVLOrgElg3kmtGTi+jxPXUxHiX6ViWqTR05Y5PNihi2ZcE7
sODAwhM5627hQt4DO1o3Fb0vXntWkGVOVH6p+Q==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 16880)
`pragma protect data_block
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
MrFxmPr05wM=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
