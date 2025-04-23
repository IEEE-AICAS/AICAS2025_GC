-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
-- Date        : Mon Feb 17 14:00:22 2025
-- Host        : adnepukan-deepin running 64-bit Deepin 20.9
-- Command     : write_vhdl -force -mode synth_stub
--               /home/adnepukan/aicas4qwen/hardware/project_1/project_1.gen/sources_1/bd/system/ip/system_Top_0_0/system_Top_0_0_stub.vhdl
-- Design      : system_Top_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xck26-sfvc784-2LV-c
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity system_Top_0_0 is
  Port ( 
    clock : in STD_LOGIC;
    reset : in STD_LOGIC;
    io_ddr_addr : in STD_LOGIC_VECTOR ( 28 downto 0 );
    io_ddr_dataWrite : in STD_LOGIC_VECTOR ( 511 downto 0 );
    io_ddr_dataRead : out STD_LOGIC_VECTOR ( 511 downto 0 );
    io_ddr_en : in STD_LOGIC;
    io_ddr_writeEn : in STD_LOGIC_VECTOR ( 63 downto 0 );
    io_fromCPU_ready : out STD_LOGIC;
    io_fromCPU_valid : in STD_LOGIC;
    io_fromCPU_bits : in STD_LOGIC_VECTOR ( 319 downto 0 );
    io_toCPU_ready : in STD_LOGIC;
    io_toCPU_valid : out STD_LOGIC;
    io_toCPU_bits : out STD_LOGIC_VECTOR ( 191 downto 0 );
    io_clk : in STD_LOGIC;
    io_rst : in STD_LOGIC
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of system_Top_0_0 : entity is "system_Top_0_0,Top,{}";
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of system_Top_0_0 : entity is "system_Top_0_0,Top,{x_ipProduct=Vivado 2024.2,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=Top,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of system_Top_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of system_Top_0_0 : entity is "module_ref";
end system_Top_0_0;

architecture stub of system_Top_0_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "clock,reset,io_ddr_addr[28:0],io_ddr_dataWrite[511:0],io_ddr_dataRead[511:0],io_ddr_en,io_ddr_writeEn[63:0],io_fromCPU_ready,io_fromCPU_valid,io_fromCPU_bits[319:0],io_toCPU_ready,io_toCPU_valid,io_toCPU_bits[191:0],io_clk,io_rst";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clock : signal is "xilinx.com:signal:clock:1.0 clock CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of clock : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clock : signal is "XIL_INTERFACENAME clock, ASSOCIATED_RESET reset, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of reset : signal is "xilinx.com:signal:reset:1.0 reset RST";
  attribute X_INTERFACE_MODE of reset : signal is "slave";
  attribute X_INTERFACE_PARAMETER of reset : signal is "XIL_INTERFACENAME reset, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of io_clk : signal is "xilinx.com:signal:clock:1.0 io_clk CLK";
  attribute X_INTERFACE_MODE of io_clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER of io_clk : signal is "XIL_INTERFACENAME io_clk, ASSOCIATED_RESET io_rst, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of io_rst : signal is "xilinx.com:signal:reset:1.0 io_rst RST";
  attribute X_INTERFACE_MODE of io_rst : signal is "slave";
  attribute X_INTERFACE_PARAMETER of io_rst : signal is "XIL_INTERFACENAME io_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of stub : architecture is "Top,Vivado 2024.2";
begin
end;
