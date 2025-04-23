//需要把send模块改造，每次输入到matmu模块的数据为16*GS大小的矩阵块
`timescale 1 ns / 1 ps
	module gemv_float_q8_v1_0_M00_AXIS_SEND #
	(
		// Users to add parameters here
		parameter GS = 64,
		parameter Q_WIDTH = 8,
		parameter S_WIDTH = 32,
		parameter I_DIM   = 896,
		parameter O_DIM	  = 16,
		// User parameters ends
		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 32
	)
	(
		// Users to add ports here
		input 	wire  					XDATA_VALID,
		input 	wire  					WDATA_VALID,
		input   wire  					START,
		input   wire [Q_WIDTH*GS-1:0] 	XQ_DATA_IN,
		input   wire [Q_WIDTH*GS-1:0]   WQ_DATA_IN,
		input	wire [S_WIDTH-1:0]  	XS_DATA_IN,
		input 	wire [S_WIDTH-1:0] 		WS_DATA_IN,
		output  wire  					RECEIVE_READY,
		output  wire  					SEND_DONE,
		output  wire  					RECEIVE_DATA_READY,		
		// User ports ends
		// Global ports
		input wire  M_AXIS_ACLK,
		input wire  M_AXIS_ARESETN,
		// Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		output wire  M_AXIS_TVALID,
		// TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
		// TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
		output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB,
		// TLAST indicates the boundary of a packet.
		output wire  M_AXIS_TLAST,
		// TREADY indicates that the slave can accept a transfer in the current cycle.
		input wire  M_AXIS_TREADY
	);                 
	// value of the ceiling of the log base 2.                                           
	function integer clogb2 (input integer bit_depth);                                   
	  begin                                                                              
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                                      
	      bit_depth = bit_depth >> 1;                                                    
	  end                                                                                
	endfunction                                                                          
	// Total number of output data                                                 
	localparam NUMBER_OF_OUTPUT_WORDS = O_DIM;                                               
	localparam RECEIVE_GROUP_NUM 	  = I_DIM/GS;//需要输入多少组 
	// function called clogb2 that returns an integer which has the                                                                                                                                                                                               
	// bit_num gives the minimum number of bits needed to address 'depth' size of FIFO.  
	localparam bit_num  = clogb2(NUMBER_OF_OUTPUT_WORDS);
	//readw输入计数位宽
	localparam RECEIVE_GROUP_WIDTH = clogb2(RECEIVE_GROUP_NUM);                                 	                                                                                     
	// Define the states of state machine                                                
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO                                      
	localparam  [1:0] IDLE = 2'b00,        // This is the initial/idle state                                                                                                    
	                SEND_STREAM   = 2'b01; 
					// In this state the stream data is output through M_AXIS_TDATA   
	//对于接收数据也有一个状态机，接收完转到另一个状态机
	localparam	[1:0] RECEIVE_IDLE = 2'b00,
					RECEIVE_DATA = 2'b01,
					RECEIVE_DONE = 2'b10;
	// State variable                                                                    
	reg [1:0] mst_exec_state;
	reg [1:0] receive_state;                                                            
	// Example design FIFO read pointer                                                  
	reg [bit_num-1:0] read_pointer;                                                      
	// AXI Stream internal signals
	//wait counter. The master waits for the user defined number of clock cycles before initiating a transfer.
	//streaming data valid
	wire  	axis_tvalid;
	//streaming data valid delayed by one clock cycle
	reg  	axis_tvalid_delay;
	//Last of the streaming data 
	wire  	axis_tlast;
	//Last of the streaming data delayed by one clock cycle
	reg  	axis_tlast_delay;
	//FIFO implementation signals
	reg [C_M_AXIS_TDATA_WIDTH-1 : 0] 	stream_data_out;
	wire  	tx_en;
	//输入给matmul模块的数据有效性
	wire   				MATMUL_READY;
	wire 				matmul_valid;
	wire [O_DIM-1:0]    matmul_ready;
	//matmul模块完成计算
	wire 	 			MATMUL_DONE;
	wire [O_DIM-1:0] 	matmul_done;
	//The master has issued all the streaming data stored in FIFO	
	reg  	tx_done;
	//允许写数据
	wire write_data_en;
	//输入缓存
	reg [Q_WIDTH*GS-1:0] 			xq_data_in;
	reg [S_WIDTH-1:0] 				xs_data_in;
	//bram存储
	reg [Q_WIDTH*GS-1:0] 			wq_data_in[0:O_DIM-1];
	reg [S_WIDTH-1:0] 				ws_data_in[0:O_DIM-1];
	wire[S_WIDTH-1:0] 				x_data_out[0:O_DIM-1];
	//接收状态
	reg  							receive_done;
	//计数器
	reg [bit_num-1:0]   			receive_data_counter;
	reg [RECEIVE_GROUP_WIDTH-1:0]	receive_group_counter;

	// I/O Connections assignments
	assign M_AXIS_TVALID	= axis_tvalid_delay;
	assign M_AXIS_TDATA	= stream_data_out;
	assign M_AXIS_TLAST	= axis_tlast_delay;
	assign M_AXIS_TSTRB	= {(C_M_AXIS_TDATA_WIDTH/8){1'b1}};
	//tvalid generation
	//axis_tvalid is asserted when the control state machine's state is SEND_STREAM and
	//number of output streaming data is less than the NUMBER_OF_OUTPUT_WORDS.
	assign axis_tvalid = ((mst_exec_state == SEND_STREAM) && (read_pointer < NUMBER_OF_OUTPUT_WORDS));	                                                                                               
	// AXI tlast generation                                                                        
	// axis_tlast is asserted number of output streaming data is NUMBER_OF_OUTPUT_WORDS-1          
	// (0 to NUMBER_OF_OUTPUT_WORDS-1)                                                             
	assign axis_tlast = (read_pointer == NUMBER_OF_OUTPUT_WORDS-1);                                
	//FIFO read enable generation 
	assign tx_en = M_AXIS_TREADY && axis_tvalid;  
	//准备接收下一个group
	assign RECEIVE_READY = receive_done & (!MATMUL_READY);
	//输入给计算模块的数据是否有效
	assign  matmul_valid = (receive_state == RECEIVE_DONE);
	//输出传输结束信号
	assign  SEND_DONE = tx_done;
	assign  RECEIVE_DATA_READY = (receive_state == RECEIVE_DATA)
							&WDATA_VALID&XDATA_VALID;
	//matmul模块状态判断
	assign MATMUL_DONE  = &matmul_done;
	assign MATMUL_READY = &matmul_ready;

	//receive状态机跳转
	always @(posedge M_AXIS_ACLK) begin
		if(!M_AXIS_ARESETN) begin
			receive_state <= RECEIVE_IDLE;
			receive_group_counter <= 'd0;
		end
		else begin
			case(receive_state)
				RECEIVE_IDLE: begin
					if(XDATA_VALID && WDATA_VALID) begin
						receive_state <= RECEIVE_DATA;
					end
					else begin
						receive_state <= RECEIVE_IDLE;
					end
				end

				RECEIVE_DATA: begin
					if(receive_done) begin
						receive_state <= RECEIVE_DONE;
					end
					else begin
						receive_state <= RECEIVE_DATA;
					end
				end

				RECEIVE_DONE: begin
					if(receive_group_counter == RECEIVE_GROUP_NUM-1) begin
						if(RECEIVE_READY) begin
							receive_state <= RECEIVE_IDLE;
							receive_group_counter <= 0;
						end
						else begin
							receive_state <= RECEIVE_DONE;
						end
					end
					else begin
						if(RECEIVE_READY) begin
							receive_group_counter <= receive_group_counter+1;
							receive_state <= RECEIVE_DATA;
						end
					end
				end
			endcase
		end
	end
	//receive 计数及接受数据
	always @(posedge M_AXIS_ACLK) begin
		if(!M_AXIS_ARESETN) begin
			receive_data_counter <= 'd0;
			receive_done <= 1'b0;
		end
		else if((receive_state == RECEIVE_DONE) && RECEIVE_READY) begin
			receive_data_counter <= 'd0;
			receive_done <= 1'b0;	
		end
		else begin
			if(receive_data_counter <= NUMBER_OF_OUTPUT_WORDS-1) begin
				if(RECEIVE_DATA_READY) begin
					receive_data_counter <= receive_data_counter + 1;	
					wq_data_in[receive_data_counter] <= WQ_DATA_IN;
					ws_data_in[receive_data_counter] <= WS_DATA_IN;
					if(receive_data_counter == 0) begin
						xq_data_in <= XQ_DATA_IN;
						xs_data_in <= XS_DATA_IN;
					end
					receive_done <= 1'b0;
				end
				else begin
					receive_done <= 1'b0;
				end
			end
			else begin
				receive_done <= 1'b1;
				if(RECEIVE_READY) begin
					receive_data_counter <= 0;
				end
			end
		end
	end
	//例化模块
	genvar matmul_index;
	generate
		for (matmul_index = 0; matmul_index < O_DIM; matmul_index=matmul_index+1) begin:matmul_gen
			matmul #(
				.GS(GS),
				.Q_WIDTH(Q_WIDTH),
				.S_WIDTH(S_WIDTH),
				.I_DIM(I_DIM)
			)u_matmul(
				.clk(M_AXIS_ACLK),
				.rst_n(M_AXIS_ARESETN),
				.matmul_valid(matmul_valid),
				.x_q_data(xq_data_in),
				.x_s_data(xs_data_in),
				.w_q_data(wq_data_in[matmul_index]),
				.w_s_data(ws_data_in[matmul_index]),
				.START(START),
				.DONE(matmul_done[matmul_index]),
				.x_out_data(x_data_out[matmul_index]),
				.matmul_ready(matmul_ready[matmul_index])
			);
		end
	endgenerate

	// Control state machine implementation                             
	always @(posedge M_AXIS_ACLK)                                             
	begin                                                                     
	  if (!M_AXIS_ARESETN) begin                                                   
	  // Synchronous reset (active low)                                                                                                       
	    mst_exec_state <= IDLE;                                             
	  end                                                                   
	  else                                                                    
	    case (mst_exec_state)                                                 
	      IDLE: begin   
			if(MATMUL_DONE) begin
	        	mst_exec_state  <= SEND_STREAM;                                                                                          
			end
			else begin
				mst_exec_state <= IDLE;
			end                                                                 
		  end                                                                                                              
	      SEND_STREAM: begin                                                        
	        // The example design streaming master functionality starts       
	        // when the master drives output tdata from the FIFO and the slave
	        // has finished storing the S_AXIS_TDATA                          
	        if (tx_done) begin                                                           
	            mst_exec_state <= IDLE;                                       
	        end                                                             
	        else begin                                                           
	            mst_exec_state <= SEND_STREAM;                                
	        end
		  end                                                             
	    endcase                                                               
	end                                                                       
	                                                                                                                                                                                              
	// Delay the axis_tvalid and axis_tlast signal by one clock cycle                              
	// to match the latency of M_AXIS_TDATA                                                        
	always @(posedge M_AXIS_ACLK) begin                                                                                          
	  if (!M_AXIS_ARESETN) begin                                                                                      
	      axis_tvalid_delay <= 1'b0;                                                               
	      axis_tlast_delay <= 1'b0;                                                                
	  end                                                                                        
	  else begin                                                                                      
	      axis_tvalid_delay <= axis_tvalid;                                                        
	      axis_tlast_delay <= axis_tlast;                                                          
	  end                                                                                        
	end                                                                                            

	//read_pointer pointer
	always@(posedge M_AXIS_ACLK) begin                                                                            
	  if(!M_AXIS_ARESETN) begin                                                                        
	      read_pointer <= 0;                                                         
	      tx_done <= 1'b0;                                                           
	  end                                                                          
	  else                                                                           
	    if (read_pointer <= NUMBER_OF_OUTPUT_WORDS-1) begin                                                                      
	        if (tx_en) begin                                                                  
	            read_pointer <= read_pointer + 1;                                    
	            tx_done <= 1'b0;                                                     
	        end                                                                    
	    end                                                                        
	    else if (read_pointer == NUMBER_OF_OUTPUT_WORDS) begin                                                                      
	        // tx_done is asserted when NUMBER_OF_OUTPUT_WORDS numbers of streaming data
	        // has been out.                                                         
	        tx_done <= 1'b1;                                                         
	    end                                                                        
	end                                                                               
	                                                     
	// Streaming output data is read from FIFO       
	always @( posedge M_AXIS_ACLK )                  
	begin                                            
	    if(!M_AXIS_ARESETN) begin                                        
	        stream_data_out <= 1;                      
	    end                                          
	    else if (tx_en) begin                                        
	        stream_data_out <= x_data_out[read_pointer];   
	    end                                          
	end                                              

	// Add user logic here

	// User logic ends

	endmodule