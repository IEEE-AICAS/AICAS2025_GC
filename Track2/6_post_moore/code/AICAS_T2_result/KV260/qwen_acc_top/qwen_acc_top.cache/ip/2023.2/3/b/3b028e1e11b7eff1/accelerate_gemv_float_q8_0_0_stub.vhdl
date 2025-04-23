-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
-- Date        : Mon Mar 24 15:43:18 2025
-- Host        : DESKTOP-66QCD9K running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ accelerate_gemv_float_q8_0_0_stub.vhdl
-- Design      : accelerate_gemv_float_q8_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xck26-sfvc784-2LV-c
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    ip_aclk : in STD_LOGIC;
    ip_aresetn : in STD_LOGIC;
    s00_axi_ctrl_awaddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_ctrl_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_ctrl_awvalid : in STD_LOGIC;
    s00_axi_ctrl_awready : out STD_LOGIC;
    s00_axi_ctrl_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_ctrl_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_ctrl_wvalid : in STD_LOGIC;
    s00_axi_ctrl_wready : out STD_LOGIC;
    s00_axi_ctrl_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_ctrl_bvalid : out STD_LOGIC;
    s00_axi_ctrl_bready : in STD_LOGIC;
    s00_axi_ctrl_araddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_ctrl_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_ctrl_arvalid : in STD_LOGIC;
    s00_axi_ctrl_arready : out STD_LOGIC;
    s00_axi_ctrl_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_ctrl_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_ctrl_rvalid : out STD_LOGIC;
    s00_axi_ctrl_rready : in STD_LOGIC;
    s00_axis_readx_tready : out STD_LOGIC;
    s00_axis_readx_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axis_readx_tstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axis_readx_tlast : in STD_LOGIC;
    s00_axis_readx_tvalid : in STD_LOGIC;
    s01_axis_readw_tready : out STD_LOGIC;
    s01_axis_readw_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s01_axis_readw_tstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s01_axis_readw_tlast : in STD_LOGIC;
    s01_axis_readw_tvalid : in STD_LOGIC;
    m00_axis_send_tvalid : out STD_LOGIC;
    m00_axis_send_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m00_axis_send_tstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m00_axis_send_tlast : out STD_LOGIC;
    m00_axis_send_tready : in STD_LOGIC
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "ip_aclk,ip_aresetn,s00_axi_ctrl_awaddr[3:0],s00_axi_ctrl_awprot[2:0],s00_axi_ctrl_awvalid,s00_axi_ctrl_awready,s00_axi_ctrl_wdata[31:0],s00_axi_ctrl_wstrb[3:0],s00_axi_ctrl_wvalid,s00_axi_ctrl_wready,s00_axi_ctrl_bresp[1:0],s00_axi_ctrl_bvalid,s00_axi_ctrl_bready,s00_axi_ctrl_araddr[3:0],s00_axi_ctrl_arprot[2:0],s00_axi_ctrl_arvalid,s00_axi_ctrl_arready,s00_axi_ctrl_rdata[31:0],s00_axi_ctrl_rresp[1:0],s00_axi_ctrl_rvalid,s00_axi_ctrl_rready,s00_axis_readx_tready,s00_axis_readx_tdata[31:0],s00_axis_readx_tstrb[3:0],s00_axis_readx_tlast,s00_axis_readx_tvalid,s01_axis_readw_tready,s01_axis_readw_tdata[31:0],s01_axis_readw_tstrb[3:0],s01_axis_readw_tlast,s01_axis_readw_tvalid,m00_axis_send_tvalid,m00_axis_send_tdata[31:0],m00_axis_send_tstrb[3:0],m00_axis_send_tlast,m00_axis_send_tready";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "gemv_float_q8_v1_0,Vivado 2023.2";
begin
end;
