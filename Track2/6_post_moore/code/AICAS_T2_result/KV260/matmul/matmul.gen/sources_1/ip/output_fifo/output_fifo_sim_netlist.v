// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue Mar  4 15:21:01 2025
// Host        : DESKTOP-66QCD9K running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/Desktop/LLM/competition/FPGA_GC/KV260/matmul/matmul.gen/sources_1/ip/output_fifo/output_fifo_sim_netlist.v
// Design      : output_fifo
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xck26-sfvc784-2LV-c
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "output_fifo,fifo_generator_v13_2_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_9,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module output_fifo
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
  output_fifo_fifo_generator_v13_2_9 U0
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

(* DEST_SYNC_FF = "2" *) (* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_gray" *) 
(* REG_OUTPUT = "1" *) (* SIM_ASSERT_CHK = "0" *) (* SIM_LOSSLESS_GRAY_CHK = "0" *) 
(* VERSION = "0" *) (* WIDTH = "7" *) (* XPM_MODULE = "TRUE" *) 
(* is_du_within_envelope = "true" *) (* keep_hierarchy = "true" *) (* xpm_cdc = "GRAY" *) 
module output_fifo_xpm_cdc_gray
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
module output_fifo_xpm_cdc_gray__2
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

(* DEST_SYNC_FF = "5" *) (* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_single" *) 
(* SIM_ASSERT_CHK = "0" *) (* SRC_INPUT_REG = "0" *) (* VERSION = "0" *) 
(* XPM_MODULE = "TRUE" *) (* is_du_within_envelope = "true" *) (* keep_hierarchy = "true" *) 
(* xpm_cdc = "SINGLE" *) 
module output_fifo_xpm_cdc_single
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
module output_fifo_xpm_cdc_single__2
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
(* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_sync_rst" *) (* SIM_ASSERT_CHK = "0" *) 
(* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) (* is_du_within_envelope = "true" *) 
(* keep_hierarchy = "true" *) (* xpm_cdc = "SYNC_RST" *) 
module output_fifo_xpm_cdc_sync_rst
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
module output_fifo_xpm_cdc_sync_rst__2
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 107280)
`pragma protect data_block
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
kcAh5YRS
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
