// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
// Date        : Sat Feb  8 13:03:49 2025
// Host        : adnepukan-deepin running 64-bit Deepin 20.9
// Command     : write_verilog -force -mode synth_stub -rename_top system_zynq_ultra_ps_e_0_0 -prefix
//               system_zynq_ultra_ps_e_0_0_ system_zynq_ultra_ps_e_0_0_stub.v
// Design      : system_zynq_ultra_ps_e_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xck26-sfvc784-2LV-c
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "system_zynq_ultra_ps_e_0_0,zynq_ultra_ps_e_v3_5_5_zynq_ultra_ps_e,{}" *) (* CORE_GENERATION_INFO = "system_zynq_ultra_ps_e_0_0,zynq_ultra_ps_e_v3_5_5_zynq_ultra_ps_e,{x_ipProduct=Vivado 2024.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=zynq_ultra_ps_e,x_ipVersion=3.5,x_ipCoreRevision=5,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_DP_USE_AUDIO=0,C_DP_USE_VIDEO=0,C_MAXIGP0_DATA_WIDTH=128,C_MAXIGP1_DATA_WIDTH=128,C_MAXIGP2_DATA_WIDTH=32,C_SAXIGP0_DATA_WIDTH=128,C_SAXIGP1_DATA_WIDTH=128,C_SAXIGP2_DATA_WIDTH=128,C_SAXIGP3_DATA_WIDTH=128,C_SAXIGP4_DATA_WIDTH=128,C_SAXIGP5_DATA_WIDTH=128,C_SAXIGP6_DATA_WIDTH=128,C_USE_DIFF_RW_CLK_GP0=0,C_USE_DIFF_RW_CLK_GP1=0,C_USE_DIFF_RW_CLK_GP2=0,C_USE_DIFF_RW_CLK_GP3=0,C_USE_DIFF_RW_CLK_GP4=0,C_USE_DIFF_RW_CLK_GP5=0,C_USE_DIFF_RW_CLK_GP6=0,C_EN_FIFO_ENET0=0,C_EN_FIFO_ENET1=0,C_EN_FIFO_ENET2=0,C_EN_FIFO_ENET3=0,C_PL_CLK0_BUF=TRUE,C_PL_CLK1_BUF=FALSE,C_PL_CLK2_BUF=FALSE,C_PL_CLK3_BUF=FALSE,C_TRACE_PIPELINE_WIDTH=8,C_EN_EMIO_TRACE=0,C_TRACE_DATA_WIDTH=32,C_USE_DEBUG_TEST=0,C_SD0_INTERNAL_BUS_WIDTH=8,C_SD1_INTERNAL_BUS_WIDTH=8,C_NUM_F2P_0_INTR_INPUTS=1,C_NUM_F2P_1_INTR_INPUTS=1,C_EMIO_GPIO_WIDTH=1,C_NUM_FABRIC_RESETS=1}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* X_CORE_INFO = "zynq_ultra_ps_e_v3_5_5_zynq_ultra_ps_e,Vivado 2024.2" *) 
module system_zynq_ultra_ps_e_0_0(maxihpm0_fpd_aclk, maxigp0_awid, 
  maxigp0_awaddr, maxigp0_awlen, maxigp0_awsize, maxigp0_awburst, maxigp0_awlock, 
  maxigp0_awcache, maxigp0_awprot, maxigp0_awvalid, maxigp0_awuser, maxigp0_awready, 
  maxigp0_wdata, maxigp0_wstrb, maxigp0_wlast, maxigp0_wvalid, maxigp0_wready, maxigp0_bid, 
  maxigp0_bresp, maxigp0_bvalid, maxigp0_bready, maxigp0_arid, maxigp0_araddr, maxigp0_arlen, 
  maxigp0_arsize, maxigp0_arburst, maxigp0_arlock, maxigp0_arcache, maxigp0_arprot, 
  maxigp0_arvalid, maxigp0_aruser, maxigp0_arready, maxigp0_rid, maxigp0_rdata, 
  maxigp0_rresp, maxigp0_rlast, maxigp0_rvalid, maxigp0_rready, maxigp0_awqos, maxigp0_arqos, 
  saxihpc0_fpd_aclk, saxigp0_aruser, saxigp0_awuser, saxigp0_awid, saxigp0_awaddr, 
  saxigp0_awlen, saxigp0_awsize, saxigp0_awburst, saxigp0_awlock, saxigp0_awcache, 
  saxigp0_awprot, saxigp0_awvalid, saxigp0_awready, saxigp0_wdata, saxigp0_wstrb, 
  saxigp0_wlast, saxigp0_wvalid, saxigp0_wready, saxigp0_bid, saxigp0_bresp, saxigp0_bvalid, 
  saxigp0_bready, saxigp0_arid, saxigp0_araddr, saxigp0_arlen, saxigp0_arsize, 
  saxigp0_arburst, saxigp0_arlock, saxigp0_arcache, saxigp0_arprot, saxigp0_arvalid, 
  saxigp0_arready, saxigp0_rid, saxigp0_rdata, saxigp0_rresp, saxigp0_rlast, saxigp0_rvalid, 
  saxigp0_rready, saxigp0_awqos, saxigp0_arqos, saxihpc1_fpd_aclk, saxigp1_aruser, 
  saxigp1_awuser, saxigp1_awid, saxigp1_awaddr, saxigp1_awlen, saxigp1_awsize, 
  saxigp1_awburst, saxigp1_awlock, saxigp1_awcache, saxigp1_awprot, saxigp1_awvalid, 
  saxigp1_awready, saxigp1_wdata, saxigp1_wstrb, saxigp1_wlast, saxigp1_wvalid, 
  saxigp1_wready, saxigp1_bid, saxigp1_bresp, saxigp1_bvalid, saxigp1_bready, saxigp1_arid, 
  saxigp1_araddr, saxigp1_arlen, saxigp1_arsize, saxigp1_arburst, saxigp1_arlock, 
  saxigp1_arcache, saxigp1_arprot, saxigp1_arvalid, saxigp1_arready, saxigp1_rid, 
  saxigp1_rdata, saxigp1_rresp, saxigp1_rlast, saxigp1_rvalid, saxigp1_rready, saxigp1_awqos, 
  saxigp1_arqos, pl_ps_irq0, pl_resetn0, pl_clk0, pl_clk1)
/* synthesis syn_black_box black_box_pad_pin="maxigp0_awid[15:0],maxigp0_awaddr[39:0],maxigp0_awlen[7:0],maxigp0_awsize[2:0],maxigp0_awburst[1:0],maxigp0_awlock,maxigp0_awcache[3:0],maxigp0_awprot[2:0],maxigp0_awvalid,maxigp0_awuser[15:0],maxigp0_awready,maxigp0_wdata[127:0],maxigp0_wstrb[15:0],maxigp0_wlast,maxigp0_wvalid,maxigp0_wready,maxigp0_bid[15:0],maxigp0_bresp[1:0],maxigp0_bvalid,maxigp0_bready,maxigp0_arid[15:0],maxigp0_araddr[39:0],maxigp0_arlen[7:0],maxigp0_arsize[2:0],maxigp0_arburst[1:0],maxigp0_arlock,maxigp0_arcache[3:0],maxigp0_arprot[2:0],maxigp0_arvalid,maxigp0_aruser[15:0],maxigp0_arready,maxigp0_rid[15:0],maxigp0_rdata[127:0],maxigp0_rresp[1:0],maxigp0_rlast,maxigp0_rvalid,maxigp0_rready,maxigp0_awqos[3:0],maxigp0_arqos[3:0],saxigp0_aruser,saxigp0_awuser,saxigp0_awid[5:0],saxigp0_awaddr[48:0],saxigp0_awlen[7:0],saxigp0_awsize[2:0],saxigp0_awburst[1:0],saxigp0_awlock,saxigp0_awcache[3:0],saxigp0_awprot[2:0],saxigp0_awvalid,saxigp0_awready,saxigp0_wdata[127:0],saxigp0_wstrb[15:0],saxigp0_wlast,saxigp0_wvalid,saxigp0_wready,saxigp0_bid[5:0],saxigp0_bresp[1:0],saxigp0_bvalid,saxigp0_bready,saxigp0_arid[5:0],saxigp0_araddr[48:0],saxigp0_arlen[7:0],saxigp0_arsize[2:0],saxigp0_arburst[1:0],saxigp0_arlock,saxigp0_arcache[3:0],saxigp0_arprot[2:0],saxigp0_arvalid,saxigp0_arready,saxigp0_rid[5:0],saxigp0_rdata[127:0],saxigp0_rresp[1:0],saxigp0_rlast,saxigp0_rvalid,saxigp0_rready,saxigp0_awqos[3:0],saxigp0_arqos[3:0],saxigp1_aruser,saxigp1_awuser,saxigp1_awid[5:0],saxigp1_awaddr[48:0],saxigp1_awlen[7:0],saxigp1_awsize[2:0],saxigp1_awburst[1:0],saxigp1_awlock,saxigp1_awcache[3:0],saxigp1_awprot[2:0],saxigp1_awvalid,saxigp1_awready,saxigp1_wdata[127:0],saxigp1_wstrb[15:0],saxigp1_wlast,saxigp1_wvalid,saxigp1_wready,saxigp1_bid[5:0],saxigp1_bresp[1:0],saxigp1_bvalid,saxigp1_bready,saxigp1_arid[5:0],saxigp1_araddr[48:0],saxigp1_arlen[7:0],saxigp1_arsize[2:0],saxigp1_arburst[1:0],saxigp1_arlock,saxigp1_arcache[3:0],saxigp1_arprot[2:0],saxigp1_arvalid,saxigp1_arready,saxigp1_rid[5:0],saxigp1_rdata[127:0],saxigp1_rresp[1:0],saxigp1_rlast,saxigp1_rvalid,saxigp1_rready,saxigp1_awqos[3:0],saxigp1_arqos[3:0],pl_ps_irq0[0:0],pl_resetn0,pl_clk1" */
/* synthesis syn_force_seq_prim="maxihpm0_fpd_aclk" */
/* synthesis syn_force_seq_prim="saxihpc0_fpd_aclk" */
/* synthesis syn_force_seq_prim="saxihpc1_fpd_aclk" */
/* synthesis syn_force_seq_prim="pl_clk0" */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 M_AXI_HPM0_FPD_ACLK CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_HPM0_FPD_ACLK, ASSOCIATED_BUSIF M_AXI_HPM0_FPD, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *) input maxihpm0_fpd_aclk /* synthesis syn_isclock = 1 */;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD AWID" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_HPM0_FPD, NUM_WRITE_OUTSTANDING 8, NUM_READ_OUTSTANDING 8, DATA_WIDTH 128, PROTOCOL AXI4, FREQ_HZ 99999001, ID_WIDTH 16, ADDR_WIDTH 40, AWUSER_WIDTH 16, ARUSER_WIDTH 16, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk0, NUM_READ_THREADS 4, NUM_WRITE_THREADS 4, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) output [15:0]maxigp0_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD AWADDR" *) output [39:0]maxigp0_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD AWLEN" *) output [7:0]maxigp0_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD AWSIZE" *) output [2:0]maxigp0_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD AWBURST" *) output [1:0]maxigp0_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD AWLOCK" *) output maxigp0_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD AWCACHE" *) output [3:0]maxigp0_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD AWPROT" *) output [2:0]maxigp0_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD AWVALID" *) output maxigp0_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD AWUSER" *) output [15:0]maxigp0_awuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD AWREADY" *) input maxigp0_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD WDATA" *) output [127:0]maxigp0_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD WSTRB" *) output [15:0]maxigp0_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD WLAST" *) output maxigp0_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD WVALID" *) output maxigp0_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD WREADY" *) input maxigp0_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD BID" *) input [15:0]maxigp0_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD BRESP" *) input [1:0]maxigp0_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD BVALID" *) input maxigp0_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD BREADY" *) output maxigp0_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD ARID" *) output [15:0]maxigp0_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD ARADDR" *) output [39:0]maxigp0_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD ARLEN" *) output [7:0]maxigp0_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD ARSIZE" *) output [2:0]maxigp0_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD ARBURST" *) output [1:0]maxigp0_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD ARLOCK" *) output maxigp0_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD ARCACHE" *) output [3:0]maxigp0_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD ARPROT" *) output [2:0]maxigp0_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD ARVALID" *) output maxigp0_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD ARUSER" *) output [15:0]maxigp0_aruser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD ARREADY" *) input maxigp0_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD RID" *) input [15:0]maxigp0_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD RDATA" *) input [127:0]maxigp0_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD RRESP" *) input [1:0]maxigp0_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD RLAST" *) input maxigp0_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD RVALID" *) input maxigp0_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD RREADY" *) output maxigp0_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD AWQOS" *) output [3:0]maxigp0_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HPM0_FPD ARQOS" *) output [3:0]maxigp0_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S_AXI_HPC0_FPD_ACLK CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_HPC0_FPD_ACLK, ASSOCIATED_BUSIF S_AXI_HPC0_FPD, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *) input saxihpc0_fpd_aclk /* synthesis syn_isclock = 1 */;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD ARUSER" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_HPC0_FPD, NUM_WRITE_OUTSTANDING 16, NUM_READ_OUTSTANDING 16, DATA_WIDTH 128, PROTOCOL AXI4, FREQ_HZ 99999001, ID_WIDTH 6, ADDR_WIDTH 49, AWUSER_WIDTH 1, ARUSER_WIDTH 1, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, MAX_BURST_LENGTH 4, PHASE 0.0, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input saxigp0_aruser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD AWUSER" *) input saxigp0_awuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD AWID" *) input [5:0]saxigp0_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD AWADDR" *) input [48:0]saxigp0_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD AWLEN" *) input [7:0]saxigp0_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD AWSIZE" *) input [2:0]saxigp0_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD AWBURST" *) input [1:0]saxigp0_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD AWLOCK" *) input saxigp0_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD AWCACHE" *) input [3:0]saxigp0_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD AWPROT" *) input [2:0]saxigp0_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD AWVALID" *) input saxigp0_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD AWREADY" *) output saxigp0_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD WDATA" *) input [127:0]saxigp0_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD WSTRB" *) input [15:0]saxigp0_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD WLAST" *) input saxigp0_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD WVALID" *) input saxigp0_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD WREADY" *) output saxigp0_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD BID" *) output [5:0]saxigp0_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD BRESP" *) output [1:0]saxigp0_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD BVALID" *) output saxigp0_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD BREADY" *) input saxigp0_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD ARID" *) input [5:0]saxigp0_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD ARADDR" *) input [48:0]saxigp0_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD ARLEN" *) input [7:0]saxigp0_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD ARSIZE" *) input [2:0]saxigp0_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD ARBURST" *) input [1:0]saxigp0_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD ARLOCK" *) input saxigp0_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD ARCACHE" *) input [3:0]saxigp0_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD ARPROT" *) input [2:0]saxigp0_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD ARVALID" *) input saxigp0_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD ARREADY" *) output saxigp0_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD RID" *) output [5:0]saxigp0_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD RDATA" *) output [127:0]saxigp0_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD RRESP" *) output [1:0]saxigp0_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD RLAST" *) output saxigp0_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD RVALID" *) output saxigp0_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD RREADY" *) input saxigp0_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD AWQOS" *) input [3:0]saxigp0_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC0_FPD ARQOS" *) input [3:0]saxigp0_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S_AXI_HPC1_FPD_ACLK CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_HPC1_FPD_ACLK, ASSOCIATED_BUSIF S_AXI_HPC1_FPD, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *) input saxihpc1_fpd_aclk /* synthesis syn_isclock = 1 */;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD ARUSER" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_HPC1_FPD, NUM_WRITE_OUTSTANDING 16, NUM_READ_OUTSTANDING 16, DATA_WIDTH 128, PROTOCOL AXI4, FREQ_HZ 99999001, ID_WIDTH 6, ADDR_WIDTH 49, AWUSER_WIDTH 1, ARUSER_WIDTH 1, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, MAX_BURST_LENGTH 4, PHASE 0.0, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input saxigp1_aruser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD AWUSER" *) input saxigp1_awuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD AWID" *) input [5:0]saxigp1_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD AWADDR" *) input [48:0]saxigp1_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD AWLEN" *) input [7:0]saxigp1_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD AWSIZE" *) input [2:0]saxigp1_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD AWBURST" *) input [1:0]saxigp1_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD AWLOCK" *) input saxigp1_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD AWCACHE" *) input [3:0]saxigp1_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD AWPROT" *) input [2:0]saxigp1_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD AWVALID" *) input saxigp1_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD AWREADY" *) output saxigp1_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD WDATA" *) input [127:0]saxigp1_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD WSTRB" *) input [15:0]saxigp1_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD WLAST" *) input saxigp1_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD WVALID" *) input saxigp1_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD WREADY" *) output saxigp1_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD BID" *) output [5:0]saxigp1_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD BRESP" *) output [1:0]saxigp1_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD BVALID" *) output saxigp1_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD BREADY" *) input saxigp1_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD ARID" *) input [5:0]saxigp1_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD ARADDR" *) input [48:0]saxigp1_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD ARLEN" *) input [7:0]saxigp1_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD ARSIZE" *) input [2:0]saxigp1_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD ARBURST" *) input [1:0]saxigp1_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD ARLOCK" *) input saxigp1_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD ARCACHE" *) input [3:0]saxigp1_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD ARPROT" *) input [2:0]saxigp1_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD ARVALID" *) input saxigp1_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD ARREADY" *) output saxigp1_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD RID" *) output [5:0]saxigp1_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD RDATA" *) output [127:0]saxigp1_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD RRESP" *) output [1:0]saxigp1_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD RLAST" *) output saxigp1_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD RVALID" *) output saxigp1_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD RREADY" *) input saxigp1_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD AWQOS" *) input [3:0]saxigp1_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_HPC1_FPD ARQOS" *) input [3:0]saxigp1_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 PL_PS_IRQ0 INTERRUPT" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME PL_PS_IRQ0, SENSITIVITY LEVEL_HIGH, PortWidth 1" *) input [0:0]pl_ps_irq0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 PL_RESETN0 RST" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME PL_RESETN0, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) output pl_resetn0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 PL_CLK0 CLK" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME PL_CLK0, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *) output pl_clk0 /* synthesis syn_isclock = 1 */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 PL_CLK1 CLK" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME PL_CLK1, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk1, INSERT_VIP 0" *) output pl_clk1;
endmodule
