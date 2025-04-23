
`timescale 1 ns / 1 ps

	module axi_bram_v2_0 #
	(
		// Users to add parameters here
		parameter integer NUMBER_OF_INPUT_WORDS  = 896*897/16,
		parameter integer NUMBER_OF_OUTPUT_WORDS  = 896*14/4,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S_AXIS
		parameter integer C_S_AXIS_TDATA_WIDTH	= 128,

		// Parameters of Axi Master Bus Interface M_AXIS
		parameter integer C_M_AXIS_TDATA_WIDTH	= 128,
		parameter integer C_M_AXIS_START_COUNT	= 32
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S_AXIS
		input wire  s_axis_aclk,
		input wire  s_axis_aresetn,
		output wire  s_axis_tready,
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] s_axis_tdata,
		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] s_axis_tstrb,
		input wire  s_axis_tlast,
		input wire  s_axis_tvalid,

		// Ports of Axi Master Bus Interface M_AXIS
		input wire  m_axis_aclk,
		input wire  m_axis_aresetn,
		output wire  m_axis_tvalid,
		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] m_axis_tdata,
		output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] m_axis_tstrb,
		output wire  m_axis_tlast,
		input wire  m_axis_tready
	);

	wire fifo_wren;
	wire tx_en;
	wire [15:0] write_pointer_w;
	wire [11:0] read_pointer_w;


	wire [11:0] data_count;

// Instantiation of Axi Bus Interface S_AXIS
	axi_bram_v2_0_S_AXIS # ( 
		.NUMBER_OF_INPUT_WORDS(NUMBER_OF_INPUT_WORDS),
		.C_S_AXIS_TDATA_WIDTH(C_S_AXIS_TDATA_WIDTH)
	) axi_bram_v2_0_S_AXIS_inst (
		.fifo_wren(fifo_wren),
		.write_pointer_o(write_pointer_w),
		.S_AXIS_ACLK(s_axis_aclk),
		.S_AXIS_ARESETN(s_axis_aresetn),
		.S_AXIS_TREADY(s_axis_tready),
		.S_AXIS_TDATA(s_axis_tdata),
		.S_AXIS_TSTRB(s_axis_tstrb),
		.S_AXIS_TLAST(s_axis_tlast),
		.S_AXIS_TVALID(s_axis_tvalid)
	);


	reg send_start_r1;
	reg send_start_r2;
	wire send_start;
	always @(posedge s_axis_aclk or negedge s_axis_aresetn) begin
		if(!s_axis_aresetn)begin
			send_start_r1 <= 0;
			send_start_r2 <= 0;
		end else if (data_count == NUMBER_OF_OUTPUT_WORDS) begin
			send_start_r1 <= 1;
			send_start_r2 <= send_start_r1;
		end else begin
			send_start_r1 <= 0;
			send_start_r2 <= send_start_r1;
		end
	
	end
	assign send_start = send_start_r1 & (~send_start_r2);
// Instantiation of Axi Bus Interface M_AXIS
	axi_bram_v2_0_M_AXIS # ( 
		.NUMBER_OF_OUTPUT_WORDS(NUMBER_OF_OUTPUT_WORDS),
		.C_M_AXIS_TDATA_WIDTH(C_M_AXIS_TDATA_WIDTH),
		.C_M_START_COUNT(C_M_AXIS_START_COUNT)
	) axi_bram_v2_0_M_AXIS_inst (
		.tx_en(tx_en),
		.send_start(send_start),//896*14
		.read_pointer_o(read_pointer_w),
		.M_AXIS_ACLK(m_axis_aclk),
		.M_AXIS_ARESETN(m_axis_aresetn),
		.M_AXIS_TVALID(m_axis_tvalid),
		.M_AXIS_TDATA(),
		.M_AXIS_TSTRB(m_axis_tstrb),
		.M_AXIS_TLAST(m_axis_tlast),
		.M_AXIS_TREADY(m_axis_tready)
	);

	// Add user logic here
	// input_buffer u_input_buffer(
	// 	.clka 			(s_axis_aclk),
	// 	.wea 			(fifo_wren),
	// 	.addra			(write_pointer_w),
	// 	.dina			(s_axis_tdata), 
	// 	.clkb			(s_axis_aclk),  
	// 	.addrb			(read_pointer_w),
	// 	.doutb			(m_axis_tdata)
	// );

	reg [127:0] stream_data_fifo[55:0];
	always @( posedge s_axis_aclk ) begin
	    if (fifo_wren && write_pointer_w <= 55 ) begin
	        stream_data_fifo[write_pointer_w] <= s_axis_tdata;
	    end  
	end  

	reg [5:0] stream_data_addr;
	always @(posedge s_axis_aclk or negedge s_axis_aresetn) begin
		if(!s_axis_aresetn || write_pointer_w <= 55) begin 
			stream_data_addr <= 6'd0;
	    end else if (fifo_wren && write_pointer_w > 55)begin
			if (stream_data_addr == 6'd55) begin
				stream_data_addr <= 6'd0;
			end else begin
				stream_data_addr <= stream_data_addr + 6'd1;
			end
	    end    
	end

	wire matmul_enable;
	assign matmul_enable = (write_pointer_w <= 55) ? 0 : 1;
	wire dout_valid;
	wire signed [31:0] dout;

	conv_unit #(
		.MAX_KERNEL_NUMBER(16),
		.WEIGHT_PRECISION (8),
		.FEATURE_MAP_PRECISION(8),
		.BIAS_PRECISION(32),
		.PRECISION_ADDER(16)
	) u_conv_unit(
		.clk                 (s_axis_aclk         ),
		.rst_n               (s_axis_aresetn      ),
		.enable              (matmul_enable       ),
		.din_weight          (s_axis_tdata        ),
		.din_fm              (stream_data_fifo[stream_data_addr]),
		.din_bias            (0                   ),
		.fm_updata_valid     (fifo_wren && write_pointer_w > 55),
		.weight_updata_valid (fifo_wren && write_pointer_w > 55),
		.bias_or_not         (0			          ),
		.dout                (dout                ),
		.dout_valid          (dout_valid          )
	);

	reg signed [31:0] dout_acc;
	reg [1:0] cnt_1;
	reg  vaild_acc;
	always @(posedge s_axis_aclk or negedge s_axis_aresetn) begin
		if (!s_axis_aresetn) begin
			cnt_1 <= 0;
		end else if (dout_valid) begin
			cnt_1 <= cnt_1 + 1;
			vaild_acc <= (cnt_1 == 3) ? 1 : 0;
			dout_acc <= (cnt_1 == 0) ?  dout : (dout_acc + dout);
		end else begin
			vaild_acc <= 0;
		end
	end


	reg [127:0]fifo_din; 
	reg buffer_wren;
	reg [1:0] fifo_in_cnt;
	always @(posedge s_axis_aclk or negedge s_axis_aresetn) begin
		if (!s_axis_aresetn) begin
			fifo_in_cnt <= 0;
			buffer_wren <= 0;
			fifo_din <= 0;
		end else if (vaild_acc) begin
			fifo_in_cnt <= fifo_in_cnt + 1;
			case (fifo_in_cnt)
				2'd0: begin fifo_din[31:0] <= dout_acc;buffer_wren <= 0;end
				2'd1: begin fifo_din[63:32] <= dout_acc;buffer_wren <= 0;end
				2'd2: begin fifo_din[95:64] <= dout_acc;buffer_wren <= 0;end
				2'd3: begin fifo_din[127:96] <= dout_acc; buffer_wren <= 1;end
				default: begin fifo_din <= 0;buffer_wren <= 0;end
			endcase
		end else begin
			buffer_wren <= 0;
		end
	end

	fifo_generator_0 u_buffer_fifo (
		.clk(s_axis_aclk),
		.srst(!s_axis_aresetn), 
		.din(fifo_din),
		.wr_en(buffer_wren),//write_pointer1_r > COL_MAX - 2表示前面多一个空
		.rd_en(tx_en),
		.dout(m_axis_tdata), 
		.empty(),
		.data_count(data_count)
	);
	// User logic ends

	endmodule
