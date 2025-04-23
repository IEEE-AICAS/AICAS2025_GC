
`timescale 1 ns / 1 ps

	module gemv_float_q8_v1_0 #
	(
		// Users to add parameters here
		parameter Q_WIDTH 	= 8,
		parameter S_WIDTH 	= 32,
		parameter GS 		= 64,
		parameter I_DIM		= 896,
		parameter O_DIM 	= 16,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI_CTRL
		parameter integer C_S00_AXI_CTRL_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_CTRL_ADDR_WIDTH	= 4,

		// Parameters of Axi Slave Bus Interface S00_AXIS_READX
		parameter integer C_S00_AXIS_READX_TDATA_WIDTH	= 32,
		parameter integer C_M00_AXIS_SEND_START_COUNT = 32,
		// Parameters of Axi Slave Bus Interface S01_AXIS_READW
		parameter integer C_S01_AXIS_READW_TDATA_WIDTH	= 32,

		// Parameters of Axi Master Bus Interface M00_AXIS_SEND
		parameter integer C_M00_AXIS_SEND_TDATA_WIDTH	= 32
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI_CTRL
		input wire  ip_aclk,
		input wire  ip_aresetn,
		input wire [C_S00_AXI_CTRL_ADDR_WIDTH-1 : 0] s00_axi_ctrl_awaddr,
		input wire [2 : 0] s00_axi_ctrl_awprot,
		input wire  s00_axi_ctrl_awvalid,
		output wire  s00_axi_ctrl_awready,
		input wire [C_S00_AXI_CTRL_DATA_WIDTH-1 : 0] s00_axi_ctrl_wdata,
		input wire [(C_S00_AXI_CTRL_DATA_WIDTH/8)-1 : 0] s00_axi_ctrl_wstrb,
		input wire  s00_axi_ctrl_wvalid,
		output wire  s00_axi_ctrl_wready,
		output wire [1 : 0] s00_axi_ctrl_bresp,
		output wire  s00_axi_ctrl_bvalid,
		input wire  s00_axi_ctrl_bready,
		input wire [C_S00_AXI_CTRL_ADDR_WIDTH-1 : 0] s00_axi_ctrl_araddr,
		input wire [2 : 0] s00_axi_ctrl_arprot,
		input wire  s00_axi_ctrl_arvalid,
		output wire  s00_axi_ctrl_arready,
		output wire [C_S00_AXI_CTRL_DATA_WIDTH-1 : 0] s00_axi_ctrl_rdata,
		output wire [1 : 0] s00_axi_ctrl_rresp,
		output wire  s00_axi_ctrl_rvalid,
		input wire  s00_axi_ctrl_rready,

		// Ports of Axi Slave Bus Interface S00_AXIS_READX
		output wire  s00_axis_readx_tready,
		input wire [C_S00_AXIS_READX_TDATA_WIDTH-1 : 0] s00_axis_readx_tdata,
		input wire [3 : 0] s00_axis_readx_tstrb,
		input wire  s00_axis_readx_tlast,
		input wire  s00_axis_readx_tvalid,

		// Ports of Axi Slave Bus Interface S01_AXIS_READW
		output wire  s01_axis_readw_tready,
		input wire [C_S01_AXIS_READW_TDATA_WIDTH-1 : 0] s01_axis_readw_tdata,
		input wire [3 : 0] s01_axis_readw_tstrb,
		input wire  s01_axis_readw_tlast,
		input wire  s01_axis_readw_tvalid,

		// Ports of Axi Master Bus Interface M00_AXIS_SEND
		output wire  m00_axis_send_tvalid,
		output wire [C_M00_AXIS_SEND_TDATA_WIDTH-1 : 0] m00_axis_send_tdata,
		output wire [(C_M00_AXIS_SEND_TDATA_WIDTH/8)-1 : 0] m00_axis_send_tstrb,
		output wire  m00_axis_send_tlast,
		input wire  m00_axis_send_tready
	);

	wire 					ip_start;
	wire  					ip_done;
	wire  					sendx_receive_ready;//SEND stream准备接收x
	wire  					readx_send_valid;//readx 发送有效
	wire  					sendw_receive_ready;//SEND stream准备接受w
	wire   					readw_send_valid;//readw 发送有效
	wire [31:0] 			data_size;
	//缓存完AXI上再发给send模块的数据
	wire [Q_WIDTH*GS-1:0]   xq_data_out;
	wire [S_WIDTH-1:0] 		xs_data_out;
	wire [Q_WIDTH*GS-1:0]   wq_data_out;
	wire [S_WIDTH-1:0] 		ws_data_out;
	//send模块的ready信号
	wire  					receive_ready;
	wire  					receive_data_ready;
	assign sendx_receive_ready = receive_ready;
	assign sendw_receive_ready = receive_ready;

// Instantiation of Axi Bus Interface S00_AXI_CTRL
	gemv_float_q8_v1_0_S00_AXI_CTRL # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_CTRL_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_CTRL_ADDR_WIDTH)
	) gemv_float_q8_v1_0_S00_AXI_CTRL_inst (
		.S_AXI_ACLK(ip_aclk),
		.S_AXI_ARESETN(ip_aresetn),
		.S_AXI_AWADDR(s00_axi_ctrl_awaddr),
		.S_AXI_AWVALID(s00_axi_ctrl_awvalid),
		.S_AXI_AWREADY(s00_axi_ctrl_awready),
		.S_AXI_WDATA(s00_axi_ctrl_wdata),
		.S_AXI_WSTRB(s00_axi_ctrl_wstrb),
		.S_AXI_WVALID(s00_axi_ctrl_wvalid),
		.S_AXI_WREADY(s00_axi_ctrl_wready),
		.S_AXI_BRESP(s00_axi_ctrl_bresp),
		.S_AXI_BVALID(s00_axi_ctrl_bvalid),
		.S_AXI_BREADY(s00_axi_ctrl_bready),
		.S_AXI_ARADDR(s00_axi_ctrl_araddr),
		.S_AXI_ARVALID(s00_axi_ctrl_arvalid),
		.S_AXI_ARREADY(s00_axi_ctrl_arready),
		.S_AXI_RDATA(s00_axi_ctrl_rdata),
		.S_AXI_RRESP(s00_axi_ctrl_rresp),
		.S_AXI_RVALID(s00_axi_ctrl_rvalid),
		.S_AXI_RREADY(s00_axi_ctrl_rready),
		.IP_START(ip_start),
		.IP_DONE(ip_done),
		.DATA_SIZE(data_size)
	);

// Instantiation of Axi Bus Interface S00_AXIS_READX
	gemv_float_q8_v1_0_S00_AXIS_READX # ( 
		.C_S_AXIS_TDATA_WIDTH(C_S00_AXIS_READX_TDATA_WIDTH),
		.Q_WIDTH(Q_WIDTH),
		.S_WIDTH(S_WIDTH),
		.GS(GS)
	) gemv_float_q8_v1_0_S00_AXIS_READX_inst (
		.S_AXIS_ACLK(ip_aclk),
		.S_AXIS_ARESETN(ip_aresetn),
		.S_AXIS_TREADY(s00_axis_readx_tready),
		.S_AXIS_TDATA(s00_axis_readx_tdata),
		.S_AXIS_TLAST(s00_axis_readx_tlast),
		.S_AXIS_TVALID(s00_axis_readx_tvalid),
		.RECEIVE_READY(sendx_receive_ready),
		.SEND_VALID(readx_send_valid),
		.q_data_out(xq_data_out),
		.s_data_out(xs_data_out)
	);

// Instantiation of Axi Bus Interface S01_AXIS_READW
	gemv_float_q8_v1_0_S01_AXIS_READW # ( 
		.C_S_AXIS_TDATA_WIDTH(C_S01_AXIS_READW_TDATA_WIDTH),
		.GS(GS),
		.Q_WIDTH(Q_WIDTH),
		.S_WIDTH(S_WIDTH),
		.O_DIM(O_DIM)
	) gemv_float_q8_v1_0_S01_AXIS_READW_inst (
		.S_AXIS_ACLK(ip_aclk),
		.S_AXIS_ARESETN(ip_aresetn),
		.S_AXIS_TREADY(s01_axis_readw_tready),
		.S_AXIS_TDATA(s01_axis_readw_tdata),
		.S_AXIS_TLAST(s01_axis_readw_tlast),
		.S_AXIS_TVALID(s01_axis_readw_tvalid),
		.RECEIVE_READY(sendw_receive_ready),
		.RECEIVE_DATA_READY(receive_data_ready),
		.SEND_VALID(readw_send_valid),
		.q_data_out(wq_data_out),
		.s_data_out(ws_data_out)
	);

// Instantiation of Axi Bus Interface M00_AXIS_SEND
	gemv_float_q8_v1_0_M00_AXIS_SEND # ( 
		.C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_SEND_TDATA_WIDTH),
		.GS(GS),
		.Q_WIDTH(Q_WIDTH),
		.S_WIDTH(S_WIDTH),
		.O_DIM(O_DIM),
		.I_DIM(I_DIM)
	) gemv_float_q8_v1_0_M00_AXIS_SEND_inst (
		.M_AXIS_ACLK(ip_aclk),
		.M_AXIS_ARESETN(ip_aresetn),
		.M_AXIS_TVALID(m00_axis_send_tvalid),
		.M_AXIS_TDATA(m00_axis_send_tdata),
		.M_AXIS_TSTRB(m00_axis_send_tstrb),
		.M_AXIS_TLAST(m00_axis_send_tlast),
		.M_AXIS_TREADY(m00_axis_send_tready),
		.XDATA_VALID(readx_send_valid),
		.WDATA_VALID(readw_send_valid),
		.START(ip_start),
		.XQ_DATA_IN(xq_data_out),
		.WQ_DATA_IN(wq_data_out),
		.XS_DATA_IN(xs_data_out),
		.WS_DATA_IN(ws_data_out),
		.RECEIVE_READY(receive_ready),
		.RECEIVE_DATA_READY(receive_data_ready),
		.SEND_DONE(ip_done)
	);

	// Add user logic here

	// User logic ends

	endmodule
