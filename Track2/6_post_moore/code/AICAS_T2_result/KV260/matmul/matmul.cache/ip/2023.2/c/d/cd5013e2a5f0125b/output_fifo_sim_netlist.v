// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue Mar  4 15:21:00 2025
// Host        : DESKTOP-66QCD9K running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ output_fifo_sim_netlist.v
// Design      : output_fifo
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xck26-sfvc784-2LV-c
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "output_fifo,fifo_generator_v13_2_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_9,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (rst,
    wr_clk,
    rd_clk,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    empty,
    valid,
    wr_rst_busy,
    rd_rst_busy);
  input rst;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 write_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME write_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input wr_clk;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 read_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME read_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input rd_clk;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) input [31:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [31:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  output valid;
  output wr_rst_busy;
  output rd_rst_busy;

  wire [31:0]din;
  wire [31:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire rd_rst_busy;
  wire rst;
  wire valid;
  wire wr_clk;
  wire wr_en;
  wire wr_rst_busy;
  wire NLW_U0_almost_empty_UNCONNECTED;
  wire NLW_U0_almost_full_UNCONNECTED;
  wire NLW_U0_axi_ar_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_overflow_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_full_UNCONNECTED;
  wire NLW_U0_axi_ar_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_underflow_UNCONNECTED;
  wire NLW_U0_axi_aw_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_overflow_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_full_UNCONNECTED;
  wire NLW_U0_axi_aw_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_underflow_UNCONNECTED;
  wire NLW_U0_axi_b_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_overflow_UNCONNECTED;
  wire NLW_U0_axi_b_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_b_prog_full_UNCONNECTED;
  wire NLW_U0_axi_b_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_underflow_UNCONNECTED;
  wire NLW_U0_axi_r_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_overflow_UNCONNECTED;
  wire NLW_U0_axi_r_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_r_prog_full_UNCONNECTED;
  wire NLW_U0_axi_r_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_underflow_UNCONNECTED;
  wire NLW_U0_axi_w_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_overflow_UNCONNECTED;
  wire NLW_U0_axi_w_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_w_prog_full_UNCONNECTED;
  wire NLW_U0_axi_w_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_underflow_UNCONNECTED;
  wire NLW_U0_axis_dbiterr_UNCONNECTED;
  wire NLW_U0_axis_overflow_UNCONNECTED;
  wire NLW_U0_axis_prog_empty_UNCONNECTED;
  wire NLW_U0_axis_prog_full_UNCONNECTED;
  wire NLW_U0_axis_sbiterr_UNCONNECTED;
  wire NLW_U0_axis_underflow_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_m_axi_arvalid_UNCONNECTED;
  wire NLW_U0_m_axi_awvalid_UNCONNECTED;
  wire NLW_U0_m_axi_bready_UNCONNECTED;
  wire NLW_U0_m_axi_rready_UNCONNECTED;
  wire NLW_U0_m_axi_wlast_UNCONNECTED;
  wire NLW_U0_m_axi_wvalid_UNCONNECTED;
  wire NLW_U0_m_axis_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_tvalid_UNCONNECTED;
  wire NLW_U0_overflow_UNCONNECTED;
  wire NLW_U0_prog_empty_UNCONNECTED;
  wire NLW_U0_prog_full_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axis_tready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_underflow_UNCONNECTED;
  wire NLW_U0_wr_ack_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_wr_data_count_UNCONNECTED;
  wire [6:0]NLW_U0_data_count_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_arlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_aruser_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_awlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awuser_UNCONNECTED;
  wire [63:0]NLW_U0_m_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wuser_UNCONNECTED;
  wire [7:0]NLW_U0_m_axis_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tstrb_UNCONNECTED;
  wire [3:0]NLW_U0_m_axis_tuser_UNCONNECTED;
  wire [6:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [6:0]NLW_U0_wr_data_count_UNCONNECTED;

  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "64" *) 
  (* C_AXI_ID_WIDTH = "1" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "0" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "7" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "32" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "32" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_EN_SAFETY_CKT = "1" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "zynquplus" *) 
  (* C_FULL_FLAGS_RST_VAL = "1" *) 
  (* C_HAS_ALMOST_EMPTY = "0" *) 
  (* C_HAS_ALMOST_FULL = "0" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "0" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "0" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "1" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "1" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "2" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "1" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "1" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "0" *) 
  (* C_PRELOAD_REGS = "1" *) 
  (* C_PRIM_FIFO_TYPE = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "4" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "5" *) 
  (* C_PROG_EMPTY_TYPE = "0" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "127" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "126" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "7" *) 
  (* C_RD_DEPTH = "128" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "7" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SELECT_XPM = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "2" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "1" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "7" *) 
  (* C_WR_DEPTH = "128" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "7" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_fifo_generator_v13_2_9 U0
       (.almost_empty(NLW_U0_almost_empty_UNCONNECTED),
        .almost_full(NLW_U0_almost_full_UNCONNECTED),
        .axi_ar_data_count(NLW_U0_axi_ar_data_count_UNCONNECTED[4:0]),
        .axi_ar_dbiterr(NLW_U0_axi_ar_dbiterr_UNCONNECTED),
        .axi_ar_injectdbiterr(1'b0),
        .axi_ar_injectsbiterr(1'b0),
        .axi_ar_overflow(NLW_U0_axi_ar_overflow_UNCONNECTED),
        .axi_ar_prog_empty(NLW_U0_axi_ar_prog_empty_UNCONNECTED),
        .axi_ar_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_prog_full(NLW_U0_axi_ar_prog_full_UNCONNECTED),
        .axi_ar_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_rd_data_count(NLW_U0_axi_ar_rd_data_count_UNCONNECTED[4:0]),
        .axi_ar_sbiterr(NLW_U0_axi_ar_sbiterr_UNCONNECTED),
        .axi_ar_underflow(NLW_U0_axi_ar_underflow_UNCONNECTED),
        .axi_ar_wr_data_count(NLW_U0_axi_ar_wr_data_count_UNCONNECTED[4:0]),
        .axi_aw_data_count(NLW_U0_axi_aw_data_count_UNCONNECTED[4:0]),
        .axi_aw_dbiterr(NLW_U0_axi_aw_dbiterr_UNCONNECTED),
        .axi_aw_injectdbiterr(1'b0),
        .axi_aw_injectsbiterr(1'b0),
        .axi_aw_overflow(NLW_U0_axi_aw_overflow_UNCONNECTED),
        .axi_aw_prog_empty(NLW_U0_axi_aw_prog_empty_UNCONNECTED),
        .axi_aw_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_prog_full(NLW_U0_axi_aw_prog_full_UNCONNECTED),
        .axi_aw_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_rd_data_count(NLW_U0_axi_aw_rd_data_count_UNCONNECTED[4:0]),
        .axi_aw_sbiterr(NLW_U0_axi_aw_sbiterr_UNCONNECTED),
        .axi_aw_underflow(NLW_U0_axi_aw_underflow_UNCONNECTED),
        .axi_aw_wr_data_count(NLW_U0_axi_aw_wr_data_count_UNCONNECTED[4:0]),
        .axi_b_data_count(NLW_U0_axi_b_data_count_UNCONNECTED[4:0]),
        .axi_b_dbiterr(NLW_U0_axi_b_dbiterr_UNCONNECTED),
        .axi_b_injectdbiterr(1'b0),
        .axi_b_injectsbiterr(1'b0),
        .axi_b_overflow(NLW_U0_axi_b_overflow_UNCONNECTED),
        .axi_b_prog_empty(NLW_U0_axi_b_prog_empty_UNCONNECTED),
        .axi_b_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_prog_full(NLW_U0_axi_b_prog_full_UNCONNECTED),
        .axi_b_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_rd_data_count(NLW_U0_axi_b_rd_data_count_UNCONNECTED[4:0]),
        .axi_b_sbiterr(NLW_U0_axi_b_sbiterr_UNCONNECTED),
        .axi_b_underflow(NLW_U0_axi_b_underflow_UNCONNECTED),
        .axi_b_wr_data_count(NLW_U0_axi_b_wr_data_count_UNCONNECTED[4:0]),
        .axi_r_data_count(NLW_U0_axi_r_data_count_UNCONNECTED[10:0]),
        .axi_r_dbiterr(NLW_U0_axi_r_dbiterr_UNCONNECTED),
        .axi_r_injectdbiterr(1'b0),
        .axi_r_injectsbiterr(1'b0),
        .axi_r_overflow(NLW_U0_axi_r_overflow_UNCONNECTED),
        .axi_r_prog_empty(NLW_U0_axi_r_prog_empty_UNCONNECTED),
        .axi_r_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_prog_full(NLW_U0_axi_r_prog_full_UNCONNECTED),
        .axi_r_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_rd_data_count(NLW_U0_axi_r_rd_data_count_UNCONNECTED[10:0]),
        .axi_r_sbiterr(NLW_U0_axi_r_sbiterr_UNCONNECTED),
        .axi_r_underflow(NLW_U0_axi_r_underflow_UNCONNECTED),
        .axi_r_wr_data_count(NLW_U0_axi_r_wr_data_count_UNCONNECTED[10:0]),
        .axi_w_data_count(NLW_U0_axi_w_data_count_UNCONNECTED[10:0]),
        .axi_w_dbiterr(NLW_U0_axi_w_dbiterr_UNCONNECTED),
        .axi_w_injectdbiterr(1'b0),
        .axi_w_injectsbiterr(1'b0),
        .axi_w_overflow(NLW_U0_axi_w_overflow_UNCONNECTED),
        .axi_w_prog_empty(NLW_U0_axi_w_prog_empty_UNCONNECTED),
        .axi_w_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_prog_full(NLW_U0_axi_w_prog_full_UNCONNECTED),
        .axi_w_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_rd_data_count(NLW_U0_axi_w_rd_data_count_UNCONNECTED[10:0]),
        .axi_w_sbiterr(NLW_U0_axi_w_sbiterr_UNCONNECTED),
        .axi_w_underflow(NLW_U0_axi_w_underflow_UNCONNECTED),
        .axi_w_wr_data_count(NLW_U0_axi_w_wr_data_count_UNCONNECTED[10:0]),
        .axis_data_count(NLW_U0_axis_data_count_UNCONNECTED[10:0]),
        .axis_dbiterr(NLW_U0_axis_dbiterr_UNCONNECTED),
        .axis_injectdbiterr(1'b0),
        .axis_injectsbiterr(1'b0),
        .axis_overflow(NLW_U0_axis_overflow_UNCONNECTED),
        .axis_prog_empty(NLW_U0_axis_prog_empty_UNCONNECTED),
        .axis_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_prog_full(NLW_U0_axis_prog_full_UNCONNECTED),
        .axis_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_rd_data_count(NLW_U0_axis_rd_data_count_UNCONNECTED[10:0]),
        .axis_sbiterr(NLW_U0_axis_sbiterr_UNCONNECTED),
        .axis_underflow(NLW_U0_axis_underflow_UNCONNECTED),
        .axis_wr_data_count(NLW_U0_axis_wr_data_count_UNCONNECTED[10:0]),
        .backup(1'b0),
        .backup_marker(1'b0),
        .clk(1'b0),
        .data_count(NLW_U0_data_count_UNCONNECTED[6:0]),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .int_clk(1'b0),
        .m_aclk(1'b0),
        .m_aclk_en(1'b0),
        .m_axi_araddr(NLW_U0_m_axi_araddr_UNCONNECTED[31:0]),
        .m_axi_arburst(NLW_U0_m_axi_arburst_UNCONNECTED[1:0]),
        .m_axi_arcache(NLW_U0_m_axi_arcache_UNCONNECTED[3:0]),
        .m_axi_arid(NLW_U0_m_axi_arid_UNCONNECTED[0]),
        .m_axi_arlen(NLW_U0_m_axi_arlen_UNCONNECTED[7:0]),
        .m_axi_arlock(NLW_U0_m_axi_arlock_UNCONNECTED[0]),
        .m_axi_arprot(NLW_U0_m_axi_arprot_UNCONNECTED[2:0]),
        .m_axi_arqos(NLW_U0_m_axi_arqos_UNCONNECTED[3:0]),
        .m_axi_arready(1'b0),
        .m_axi_arregion(NLW_U0_m_axi_arregion_UNCONNECTED[3:0]),
        .m_axi_arsize(NLW_U0_m_axi_arsize_UNCONNECTED[2:0]),
        .m_axi_aruser(NLW_U0_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(NLW_U0_m_axi_arvalid_UNCONNECTED),
        .m_axi_awaddr(NLW_U0_m_axi_awaddr_UNCONNECTED[31:0]),
        .m_axi_awburst(NLW_U0_m_axi_awburst_UNCONNECTED[1:0]),
        .m_axi_awcache(NLW_U0_m_axi_awcache_UNCONNECTED[3:0]),
        .m_axi_awid(NLW_U0_m_axi_awid_UNCONNECTED[0]),
        .m_axi_awlen(NLW_U0_m_axi_awlen_UNCONNECTED[7:0]),
        .m_axi_awlock(NLW_U0_m_axi_awlock_UNCONNECTED[0]),
        .m_axi_awprot(NLW_U0_m_axi_awprot_UNCONNECTED[2:0]),
        .m_axi_awqos(NLW_U0_m_axi_awqos_UNCONNECTED[3:0]),
        .m_axi_awready(1'b0),
        .m_axi_awregion(NLW_U0_m_axi_awregion_UNCONNECTED[3:0]),
        .m_axi_awsize(NLW_U0_m_axi_awsize_UNCONNECTED[2:0]),
        .m_axi_awuser(NLW_U0_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(NLW_U0_m_axi_awvalid_UNCONNECTED),
        .m_axi_bid(1'b0),
        .m_axi_bready(NLW_U0_m_axi_bready_UNCONNECTED),
        .m_axi_bresp({1'b0,1'b0}),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(1'b0),
        .m_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_rid(1'b0),
        .m_axi_rlast(1'b0),
        .m_axi_rready(NLW_U0_m_axi_rready_UNCONNECTED),
        .m_axi_rresp({1'b0,1'b0}),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(1'b0),
        .m_axi_wdata(NLW_U0_m_axi_wdata_UNCONNECTED[63:0]),
        .m_axi_wid(NLW_U0_m_axi_wid_UNCONNECTED[0]),
        .m_axi_wlast(NLW_U0_m_axi_wlast_UNCONNECTED),
        .m_axi_wready(1'b0),
        .m_axi_wstrb(NLW_U0_m_axi_wstrb_UNCONNECTED[7:0]),
        .m_axi_wuser(NLW_U0_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(NLW_U0_m_axi_wvalid_UNCONNECTED),
        .m_axis_tdata(NLW_U0_m_axis_tdata_UNCONNECTED[7:0]),
        .m_axis_tdest(NLW_U0_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_U0_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_U0_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(NLW_U0_m_axis_tlast_UNCONNECTED),
        .m_axis_tready(1'b0),
        .m_axis_tstrb(NLW_U0_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_U0_m_axis_tuser_UNCONNECTED[3:0]),
        .m_axis_tvalid(NLW_U0_m_axis_tvalid_UNCONNECTED),
        .overflow(NLW_U0_overflow_UNCONNECTED),
        .prog_empty(NLW_U0_prog_empty_UNCONNECTED),
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(rd_clk),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[6:0]),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(rd_rst_busy),
        .rst(rst),
        .s_aclk(1'b0),
        .s_aclk_en(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid(1'b0),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock(1'b0),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awid(1'b0),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlock(1'b0),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_buser(NLW_U0_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_ruser(NLW_U0_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wid(1'b0),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(1'b0),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b0),
        .s_axis_tlast(1'b0),
        .s_axis_tready(NLW_U0_s_axis_tready_UNCONNECTED),
        .s_axis_tstrb(1'b0),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .srst(1'b0),
        .underflow(NLW_U0_underflow_UNCONNECTED),
        .valid(valid),
        .wr_ack(NLW_U0_wr_ack_UNCONNECTED),
        .wr_clk(wr_clk),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[6:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(wr_rst_busy));
endmodule

(* DEST_SYNC_FF = "2" *) (* INIT_SYNC_FF = "0" *) (* REG_OUTPUT = "1" *) 
(* SIM_ASSERT_CHK = "0" *) (* SIM_LOSSLESS_GRAY_CHK = "0" *) (* VERSION = "0" *) 
(* WIDTH = "7" *) (* XPM_MODULE = "TRUE" *) (* is_du_within_envelope = "true" *) 
(* keep_hierarchy = "true" *) (* xpm_cdc = "GRAY" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_xpm_cdc_gray
   (src_clk,
    src_in_bin,
    dest_clk,
    dest_out_bin);
  input src_clk;
  input [6:0]src_in_bin;
  input dest_clk;
  output [6:0]dest_out_bin;

  wire [6:0]async_path;
  wire [5:0]binval;
  wire dest_clk;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [6:0]\dest_graysync_ff[0] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [6:0]\dest_graysync_ff[1] ;
  wire [6:0]dest_out_bin;
  wire [5:0]gray_enc;
  wire src_clk;
  wire [6:0]src_in_bin;

  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[0]),
        .Q(\dest_graysync_ff[0] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[1]),
        .Q(\dest_graysync_ff[0] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[2]),
        .Q(\dest_graysync_ff[0] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[3]),
        .Q(\dest_graysync_ff[0] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[4]),
        .Q(\dest_graysync_ff[0] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[5]),
        .Q(\dest_graysync_ff[0] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[6]),
        .Q(\dest_graysync_ff[0] [6]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [0]),
        .Q(\dest_graysync_ff[1] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [1]),
        .Q(\dest_graysync_ff[1] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [2]),
        .Q(\dest_graysync_ff[1] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [3]),
        .Q(\dest_graysync_ff[1] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [4]),
        .Q(\dest_graysync_ff[1] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [5]),
        .Q(\dest_graysync_ff[1] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [6]),
        .Q(\dest_graysync_ff[1] [6]),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[0]_i_1 
       (.I0(\dest_graysync_ff[1] [0]),
        .I1(binval[1]),
        .O(binval[0]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \dest_out_bin_ff[1]_i_1 
       (.I0(\dest_graysync_ff[1] [1]),
        .I1(\dest_graysync_ff[1] [3]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(\dest_graysync_ff[1] [6]),
        .I4(\dest_graysync_ff[1] [4]),
        .I5(\dest_graysync_ff[1] [2]),
        .O(binval[1]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \dest_out_bin_ff[2]_i_1 
       (.I0(\dest_graysync_ff[1] [2]),
        .I1(\dest_graysync_ff[1] [4]),
        .I2(\dest_graysync_ff[1] [6]),
        .I3(\dest_graysync_ff[1] [5]),
        .I4(\dest_graysync_ff[1] [3]),
        .O(binval[2]));
  LUT4 #(
    .INIT(16'h6996)) 
    \dest_out_bin_ff[3]_i_1 
       (.I0(\dest_graysync_ff[1] [3]),
        .I1(\dest_graysync_ff[1] [5]),
        .I2(\dest_graysync_ff[1] [6]),
        .I3(\dest_graysync_ff[1] [4]),
        .O(binval[3]));
  LUT3 #(
    .INIT(8'h96)) 
    \dest_out_bin_ff[4]_i_1 
       (.I0(\dest_graysync_ff[1] [4]),
        .I1(\dest_graysync_ff[1] [6]),
        .I2(\dest_graysync_ff[1] [5]),
        .O(binval[4]));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[5]_i_1 
       (.I0(\dest_graysync_ff[1] [5]),
        .I1(\dest_graysync_ff[1] [6]),
        .O(binval[5]));
  FDRE \dest_out_bin_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[0]),
        .Q(dest_out_bin[0]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[1]),
        .Q(dest_out_bin[1]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[2]),
        .Q(dest_out_bin[2]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[3]),
        .Q(dest_out_bin[3]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[4]),
        .Q(dest_out_bin[4]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[5]),
        .Q(dest_out_bin[5]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[1] [6]),
        .Q(dest_out_bin[6]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[0]_i_1 
       (.I0(src_in_bin[1]),
        .I1(src_in_bin[0]),
        .O(gray_enc[0]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[1]_i_1 
       (.I0(src_in_bin[2]),
        .I1(src_in_bin[1]),
        .O(gray_enc[1]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[2]_i_1 
       (.I0(src_in_bin[3]),
        .I1(src_in_bin[2]),
        .O(gray_enc[2]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[3]_i_1 
       (.I0(src_in_bin[4]),
        .I1(src_in_bin[3]),
        .O(gray_enc[3]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[4]_i_1 
       (.I0(src_in_bin[5]),
        .I1(src_in_bin[4]),
        .O(gray_enc[4]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[5]_i_1 
       (.I0(src_in_bin[6]),
        .I1(src_in_bin[5]),
        .O(gray_enc[5]));
  FDRE \src_gray_ff_reg[0] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[0]),
        .Q(async_path[0]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[1] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[1]),
        .Q(async_path[1]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[2] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[2]),
        .Q(async_path[2]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[3] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[3]),
        .Q(async_path[3]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[4] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[4]),
        .Q(async_path[4]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[5] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[5]),
        .Q(async_path[5]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[6] 
       (.C(src_clk),
        .CE(1'b1),
        .D(src_in_bin[6]),
        .Q(async_path[6]),
        .R(1'b0));
endmodule

(* DEST_SYNC_FF = "2" *) (* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_gray" *) 
(* REG_OUTPUT = "1" *) (* SIM_ASSERT_CHK = "0" *) (* SIM_LOSSLESS_GRAY_CHK = "0" *) 
(* VERSION = "0" *) (* WIDTH = "7" *) (* XPM_MODULE = "TRUE" *) 
(* is_du_within_envelope = "true" *) (* keep_hierarchy = "true" *) (* xpm_cdc = "GRAY" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_xpm_cdc_gray__2
   (src_clk,
    src_in_bin,
    dest_clk,
    dest_out_bin);
  input src_clk;
  input [6:0]src_in_bin;
  input dest_clk;
  output [6:0]dest_out_bin;

  wire [6:0]async_path;
  wire [5:0]binval;
  wire dest_clk;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [6:0]\dest_graysync_ff[0] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [6:0]\dest_graysync_ff[1] ;
  wire [6:0]dest_out_bin;
  wire [5:0]gray_enc;
  wire src_clk;
  wire [6:0]src_in_bin;

  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[0]),
        .Q(\dest_graysync_ff[0] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[1]),
        .Q(\dest_graysync_ff[0] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[2]),
        .Q(\dest_graysync_ff[0] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[3]),
        .Q(\dest_graysync_ff[0] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[4]),
        .Q(\dest_graysync_ff[0] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[5]),
        .Q(\dest_graysync_ff[0] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[6]),
        .Q(\dest_graysync_ff[0] [6]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [0]),
        .Q(\dest_graysync_ff[1] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [1]),
        .Q(\dest_graysync_ff[1] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [2]),
        .Q(\dest_graysync_ff[1] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [3]),
        .Q(\dest_graysync_ff[1] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [4]),
        .Q(\dest_graysync_ff[1] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [5]),
        .Q(\dest_graysync_ff[1] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [6]),
        .Q(\dest_graysync_ff[1] [6]),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[0]_i_1 
       (.I0(\dest_graysync_ff[1] [0]),
        .I1(binval[1]),
        .O(binval[0]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \dest_out_bin_ff[1]_i_1 
       (.I0(\dest_graysync_ff[1] [1]),
        .I1(\dest_graysync_ff[1] [3]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(\dest_graysync_ff[1] [6]),
        .I4(\dest_graysync_ff[1] [4]),
        .I5(\dest_graysync_ff[1] [2]),
        .O(binval[1]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \dest_out_bin_ff[2]_i_1 
       (.I0(\dest_graysync_ff[1] [2]),
        .I1(\dest_graysync_ff[1] [4]),
        .I2(\dest_graysync_ff[1] [6]),
        .I3(\dest_graysync_ff[1] [5]),
        .I4(\dest_graysync_ff[1] [3]),
        .O(binval[2]));
  LUT4 #(
    .INIT(16'h6996)) 
    \dest_out_bin_ff[3]_i_1 
       (.I0(\dest_graysync_ff[1] [3]),
        .I1(\dest_graysync_ff[1] [5]),
        .I2(\dest_graysync_ff[1] [6]),
        .I3(\dest_graysync_ff[1] [4]),
        .O(binval[3]));
  LUT3 #(
    .INIT(8'h96)) 
    \dest_out_bin_ff[4]_i_1 
       (.I0(\dest_graysync_ff[1] [4]),
        .I1(\dest_graysync_ff[1] [6]),
        .I2(\dest_graysync_ff[1] [5]),
        .O(binval[4]));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[5]_i_1 
       (.I0(\dest_graysync_ff[1] [5]),
        .I1(\dest_graysync_ff[1] [6]),
        .O(binval[5]));
  FDRE \dest_out_bin_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[0]),
        .Q(dest_out_bin[0]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[1]),
        .Q(dest_out_bin[1]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[2]),
        .Q(dest_out_bin[2]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[3]),
        .Q(dest_out_bin[3]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[4]),
        .Q(dest_out_bin[4]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[5]),
        .Q(dest_out_bin[5]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[1] [6]),
        .Q(dest_out_bin[6]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[0]_i_1 
       (.I0(src_in_bin[1]),
        .I1(src_in_bin[0]),
        .O(gray_enc[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[1]_i_1 
       (.I0(src_in_bin[2]),
        .I1(src_in_bin[1]),
        .O(gray_enc[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[2]_i_1 
       (.I0(src_in_bin[3]),
        .I1(src_in_bin[2]),
        .O(gray_enc[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[3]_i_1 
       (.I0(src_in_bin[4]),
        .I1(src_in_bin[3]),
        .O(gray_enc[3]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[4]_i_1 
       (.I0(src_in_bin[5]),
        .I1(src_in_bin[4]),
        .O(gray_enc[4]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[5]_i_1 
       (.I0(src_in_bin[6]),
        .I1(src_in_bin[5]),
        .O(gray_enc[5]));
  FDRE \src_gray_ff_reg[0] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[0]),
        .Q(async_path[0]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[1] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[1]),
        .Q(async_path[1]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[2] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[2]),
        .Q(async_path[2]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[3] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[3]),
        .Q(async_path[3]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[4] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[4]),
        .Q(async_path[4]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[5] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[5]),
        .Q(async_path[5]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[6] 
       (.C(src_clk),
        .CE(1'b1),
        .D(src_in_bin[6]),
        .Q(async_path[6]),
        .R(1'b0));
endmodule

(* DEST_SYNC_FF = "5" *) (* INIT_SYNC_FF = "0" *) (* SIM_ASSERT_CHK = "0" *) 
(* SRC_INPUT_REG = "0" *) (* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) 
(* is_du_within_envelope = "true" *) (* keep_hierarchy = "true" *) (* xpm_cdc = "SINGLE" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_xpm_cdc_single
   (src_clk,
    src_in,
    dest_clk,
    dest_out);
  input src_clk;
  input src_in;
  input dest_clk;
  output dest_out;

  wire dest_clk;
  wire src_in;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "SINGLE" *) wire [4:0]syncstages_ff;

  assign dest_out = syncstages_ff[4];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(src_in),
        .Q(syncstages_ff[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[0]),
        .Q(syncstages_ff[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[1]),
        .Q(syncstages_ff[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[2]),
        .Q(syncstages_ff[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[3]),
        .Q(syncstages_ff[4]),
        .R(1'b0));
endmodule

(* DEST_SYNC_FF = "5" *) (* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_single" *) 
(* SIM_ASSERT_CHK = "0" *) (* SRC_INPUT_REG = "0" *) (* VERSION = "0" *) 
(* XPM_MODULE = "TRUE" *) (* is_du_within_envelope = "true" *) (* keep_hierarchy = "true" *) 
(* xpm_cdc = "SINGLE" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_xpm_cdc_single__2
   (src_clk,
    src_in,
    dest_clk,
    dest_out);
  input src_clk;
  input src_in;
  input dest_clk;
  output dest_out;

  wire dest_clk;
  wire src_in;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "SINGLE" *) wire [4:0]syncstages_ff;

  assign dest_out = syncstages_ff[4];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(src_in),
        .Q(syncstages_ff[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[0]),
        .Q(syncstages_ff[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[1]),
        .Q(syncstages_ff[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[2]),
        .Q(syncstages_ff[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[3]),
        .Q(syncstages_ff[4]),
        .R(1'b0));
endmodule

(* DEF_VAL = "1'b1" *) (* DEST_SYNC_FF = "5" *) (* INIT = "1" *) 
(* INIT_SYNC_FF = "0" *) (* SIM_ASSERT_CHK = "0" *) (* VERSION = "0" *) 
(* XPM_MODULE = "TRUE" *) (* is_du_within_envelope = "true" *) (* keep_hierarchy = "true" *) 
(* xpm_cdc = "SYNC_RST" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_xpm_cdc_sync_rst
   (src_rst,
    dest_clk,
    dest_rst);
  input src_rst;
  input dest_clk;
  output dest_rst;

  wire dest_clk;
  wire src_rst;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "SYNC_RST" *) wire [4:0]syncstages_ff;

  assign dest_rst = syncstages_ff[4];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(src_rst),
        .Q(syncstages_ff[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[0]),
        .Q(syncstages_ff[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[1]),
        .Q(syncstages_ff[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[2]),
        .Q(syncstages_ff[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[3]),
        .Q(syncstages_ff[4]),
        .R(1'b0));
endmodule

(* DEF_VAL = "1'b1" *) (* DEST_SYNC_FF = "5" *) (* INIT = "1" *) 
(* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_sync_rst" *) (* SIM_ASSERT_CHK = "0" *) 
(* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) (* is_du_within_envelope = "true" *) 
(* keep_hierarchy = "true" *) (* xpm_cdc = "SYNC_RST" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_xpm_cdc_sync_rst__2
   (src_rst,
    dest_clk,
    dest_rst);
  input src_rst;
  input dest_clk;
  output dest_rst;

  wire dest_clk;
  wire src_rst;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "SYNC_RST" *) wire [4:0]syncstages_ff;

  assign dest_rst = syncstages_ff[4];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(src_rst),
        .Q(syncstages_ff[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[0]),
        .Q(syncstages_ff[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[1]),
        .Q(syncstages_ff[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[2]),
        .Q(syncstages_ff[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[3]),
        .Q(syncstages_ff[4]),
        .R(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2023.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jLV29U0rrfMIZhYJzdoUrPoqB9eHQ5NXmWyCdqnN3Wgm+GU4C3zthrN1m4QGiaj0thPCIynZbX+0
7yjtkv+T5ByJ6NhiofAwWseGLvPXlYu6ERAPvi4SAYpF2VUqQHtPAbPmnPubGdDRgIEpeobF7hsz
rEcpEru1pyiScUriyuo=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
vsoizVrOONWw/DhjRLEYrtRmtji+Ok63CbpSg/l9VnoKAi8tAzqRbQ57atGB2N6IGGbKHkbK2Uzh
EHgWvYZeyt4hE+bpQX91vc9PNxfjQMGzPoFD3jCWk30EmEk+AND39eWx+DhJ8xhFuucoOQ2GwyAk
B+Mjs15naPE7DvlHel8hnD4dfSdYhGKp96oozu8JeBto8aHG6poOuYkxSwaut7NCI+mabCkMxtMp
RrydgmRuTvhRTbJMyx5CxFSZTRDrS5aU1vaRlnMiqKCI7g2KY9pemYaJsFeVodBuo6IyKGynyEhs
wr+VtUhQDtaVhMkwB95WwmMoDk9F2L5Au1I+TQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
W081dPMCWhKs5YlQD7n3zvf7+PTcnb8eFWxoVs8+zHLkxDMA1klITbsfztGYvJFce8Yao5XQLLqZ
oUE5Pq2arq+zwICFUcLjdMsmP1WmL82znHOPHm83zNwrxWMloHkySAqzFbgJeHa973uZqj0M8ydc
sYmzCYVlGVjt0QX0xqA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Zpc3MmdLWaVOv+S4z2POuoyslYoAbWc+Npxq2UyQRtDwf566IId3uwAetolMAgfLo/G3ezuSOXMn
8NznS37h9XvmVrxA50SAux68P87WgkLtiUYqM3CMBKkxNlZ/TR8WzTuQyFdvzkOE9lp8HC7LXnk5
RDsnOM+su46FW7ysY01COslo9Xc7rhs6WFqx29+Xcqk8+ZMLSzaJfuwZdNmJFS3Q1vhlq3ZeYqMl
wMieB731KsPxjxp7VKNHpTbgFryC2isqc4ohBDOt52M/Bz4B/rIpFeHfZ7X3jWSiKtSuBsDN2NXf
EMjfAT248dlK7NxJ+NBNPhS5sLxTiGyQhta57A==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rPMYqnkKhJKV1wltOfDrKos9ZbucaoX3WGTuqsdLkGpcKObzslHBwlGrKtWV7bZYmS2SM+QuEMfa
CE+tCUdsSiprp+n5BuSQlJa6BJ8mlqccjoo/JLw2QEmUhyMXQ3TLGomGGoZdeTmMPXhUBAOyLPea
Ddc8mgtTN8Kpy117GOTXDKP+IKJqW01fLrPJpgEhFiJCbyElLgtCRWmI94gX+y4XNVS0Cd1YwNw6
4nHgnEdC7fXARDKcYO3VsWC/pdzPQgursXloNLrVYa6i2xr+8E1V0+nSWwNYQZP7XUIVqXKMU8Ea
bT4acXrRCF/5tJJ5B9JparYI0zxXSbaakn1dIw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2022_10", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mfroTgL8g2pyIXQ/mGO9YHm19cd5mOlJ++qpusOYeVxGmkIhvF4aKx+AyIUz2yGGAeCtOzIasHty
pyqKgZhibSqxcpHgR0m6GOxXXOXJiHaK8NzxUzXeRJovcBI/WjtDhXeb1LRMI1J97jVBtJPJQH0Y
fGOD7jWvkvQwxnrZdyLp6kPWgSIcavHHDbO7iJv4gnyGp6W3/FCDo2RKWNLoW+SNjSdLZ6YRP8a+
ldaGU8TYvJ03KWlmik7repuN6AwxCjg2KeQ+x1sBAEXzROXomuSbvX3ZAo8UiIKAQY1SJumHLG3L
QI/S4Wbl1Hz6LDTsttMwP480gq6+tb6s1E4oWw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QJIabgm8dx/gVHbOQFwt8maOKVHFgkpZTPR6dzD8fqoGo9M9oGPTqBqchtPZWgv2UYFF2KEUSlV4
L3SDXBKrLs+NsAVTcICaEMiEi6j82zj/C1LsPkQfS8RLrg0ab8lbDMb5YqJ7lkHs3iM65x2iN1Mf
66cTgCbkAdl3rDpab75btpTQt5ZKiq5CSY3RZfyIW0uWbTGTELm6liuRKM9+K8BQwTU7A+FFFQBA
/9eJwQYzNNA/iwoYJ2WTPd6pBlzXriNLu9M+/2bYicNBSuH1PBR9v2ESrTB6k7EiV1zvBXV9NuG/
sFt4MumWMuSNwP2W38bQATxxW/l0IrmaXGOC/w==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
lhKf/Vgj6pHpme1ji4HVe36BU8pMkam/2I9lFeyOiBnIbzgdEGfLJBcEvkL33A7s0hxa6LFbHnkT
upgMpPjmIghBz3xUQ13vpiY152thFec6qvlcdg1r+GTmnBOSFl6g/OfZ3eFUhfsve6ZjQHpXnKFo
a55hN2+eP1EG9+VxGeM7XkHaeFhEIry52qtnmg072KEFIwRiGs2d/TJ4AqupuIdIiP1kTN9k+oqa
2ta1vdtqPY0dDHqrf+5YSd0CejkhQeCqg/bauLP3755SwdOPRgooG5ANT8hUpTiFMFXtU+GC9NSp
evJtMHUy1NbgMmhFHO+w3URLEdjSaBxZPD7YLdWkF65jY526tJzoek+BzEKoBaGfCaY7O1nHKXm+
89k3rPUy0Xo4/0nHpno+N/Db09heJPbnGsCwN/l+KnR6Lz8kvWziBjZe0ijOkKI+T12y3T1VeOtY
H/aqtNlQt1mhFwrbw6ezaAiDPVbCQXnly6b4tbb8+nFsxWOGIGAfLozB

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PNsQ8uEcQYrl+GaDuBaq1tQ5br5aAdaqHnyrc0NVu/JnQUk53jaiLx8Oz5fNACvWelUUk2/C+P5I
b2rbU1bb/dC6TqC5J1N0yoMYRYw58u4Lrl8Kgqgt9Rlph5Qgzzfxp+oblXF/pO4mRyAXpZhpNkFT
0Ar9BUtPOTOtJ9/g53SRnZ6GjxzfeD+25J4fcXBNo2gCTgUkwiLSsJRwTB/cJmn+dZPwPdIOHEP9
TkfDK+OrbLYO3T+DFBTCMRNH2NB1J9sc5s+nPU8iYnjgPTo6HoGW+LIlCz6yNJMZzJzoeW708utc
0fJXkT7vLDVh7olvy3V9AAY8Do0YR1kiZlhVhQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zAz8RnGHFebkJFAS+gjC+mXHW7m7We+JgSmIz15mS01u/4+9Ng0sJfkeXOClmVPTQ2Mp2Yuv6/6f
ehzUTcANilWsqLM6Q1FToCPNX/NTqodlcHirGM7b5R9yevouNT/aqH12nmbunBQmBHmehNutdCjG
r6Z7kZgeZ2ZE7MMOF0rTy1XHEPkqgMNTRoS8R/pPWPTW4/j+bn3aJj0Q/fTz4Gi3mbSUKWs2fREQ
UKiuolNJkN6DiDvhlVYHUyytXNJG44ikmBXehoQQRLapkYaxnQmMRT1ok9uY6pKoy71CtvJ3Mt2x
EQv1GU2i4qQyAOwa0mkEohWXduicU6tDz3zQwQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TK3eE9V+v1z2P1KjG4GrjhA1n3qDOpNzLGXdtjnjhF0QBFPSuhC+nmNqTPOb3p2a9r5KD0miY3Cd
+KpjH6Ao09E2/LD2Go4aLQh6vP+9BldlSKEwCGfx2NjBQrXWVH21lQR7IRjOvyTOclpd7SgtUJLw
dvebETyLiKr9C6RfnIBeptuCA3iJlXfwkh6I0JfzD5WBizQkotioZmmrXv5105pCXQ4Ta1WThFsA
2ll9dZeSjEDHUxxhfyfjryv9m4VL89ZDU/rGITsdptwB1BC1jLqmPDymY05lyECnjA6NIR5GGfI4
K2y2f4GfikKoN5r9IOvFzw963Wm82ZZPtXOKGg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 107792)
`pragma protect data_block
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
KhRnxuY=
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
