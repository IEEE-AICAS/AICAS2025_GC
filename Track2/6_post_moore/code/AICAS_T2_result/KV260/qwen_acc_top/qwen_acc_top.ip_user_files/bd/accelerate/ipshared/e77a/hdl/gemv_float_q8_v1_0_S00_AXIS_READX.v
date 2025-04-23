
`timescale 1 ns / 1 ps

	module gemv_float_q8_v1_0_S00_AXIS_READX #
	(
		// Users to add parameters here
		parameter Q_WIDTH 	= 8,
		parameter S_WIDTH 	= 32,
		parameter GS 		= 64,
		// User parameters ends
		// Do not modify the parameters beyond this line

		// AXI4Stream sink: Data Width
		parameter integer C_S_AXIS_TDATA_WIDTH	= 32
	)
	(
		// Users to add ports here
		input   wire  					RECEIVE_READY,
		output  wire  					SEND_VALID,
		output 	wire [Q_WIDTH*GS-1:0]	q_data_out,
		output  wire [S_WIDTH-1:0]		s_data_out,
		// User ports ends
		// Do not modify the ports beyond this line

		// AXI4Stream sink: Clock
		input wire  S_AXIS_ACLK,
		// AXI4Stream sink: Reset
		input wire  S_AXIS_ARESETN,
		// Ready to accept data in
		output wire  S_AXIS_TREADY,
		// Data in
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
		// Indicates boundary of last packet
		input wire  S_AXIS_TLAST,
		// Data is in valid
		input wire  S_AXIS_TVALID
	);

	//分配寄存器空间
	reg [Q_WIDTH*GS-1:0] 	q_data_buf;
	reg [S_WIDTH-1:0] 		s_data_buf;

	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction

	// Total number of input data.
	localparam NUMBER_OF_INPUT_WORDS  = 17;
	// bit_num gives the minimum number of bits needed to address 'NUMBER_OF_INPUT_WORDS' size of FIFO.
	localparam bit_num  = clogb2(NUMBER_OF_INPUT_WORDS-1);
	// Define the states of state machine
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO
	localparam [1:0] IDLE = 2'b00,        // This is the initial/idle state 

	                WRITE_FIFO  = 2'b01, // In this state FIFO is written with the
	                                    // input stream data S_AXIS_TDATA
					WAIT_HANDSHAKE = 2'b10;

	wire  	axis_tready;
	// State variable
	reg [1:0] mst_exec_state;     
	// FIFO write enable
	wire fifo_wren;
	// FIFO write pointer
	reg [bit_num-1:0] write_pointer;
	// sink has accepted all the streaming data and stored in FIFO
	reg writes_done;
	// I/O Connections assignments

	assign S_AXIS_TREADY	= axis_tready;

	// Control state machine implementation
	always @(posedge S_AXIS_ACLK) 
	begin  
	  if (!S_AXIS_ARESETN) begin
	  // Synchronous reset (active low)
	    mst_exec_state <= IDLE;
	  end  
	  else begin
	    case (mst_exec_state)
	      IDLE: begin
	        // The sink starts accepting tdata when 
	        // there tvalid is asserted to mark the
	        // presence of valid streaming data 
	        if (S_AXIS_TVALID) begin
	        	mst_exec_state <= WRITE_FIFO;
	        end
	        else begin
	            mst_exec_state <= IDLE;
	        end
		  end
	      WRITE_FIFO: begin
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
	        if (writes_done) begin
	            mst_exec_state <= WAIT_HANDSHAKE;
	        end
	        else begin
	        // The sink accepts and stores tdata 
	        // into FIFO
	    		mst_exec_state <= WRITE_FIFO;
	        end
		  end
		  WAIT_HANDSHAKE: begin
		  //raedw读完之后再进行赋值和新一轮write fifo
		  	if (RECEIVE_READY) begin
				mst_exec_state <= IDLE;
			end
			else begin
				mst_exec_state <= WAIT_HANDSHAKE;
			end
		  end
		  default: begin
			mst_exec_state <= IDLE;
		  end
	    endcase
	  end
	end
	// AXI Streaming Sink 
	// 
	// The example design sink is always ready to accept the S_AXIS_TDATA  until
	// the FIFO is not filled with NUMBER_OF_INPUT_WORDS number of input words.
	assign axis_tready = ((mst_exec_state == WRITE_FIFO) && (write_pointer <= NUMBER_OF_INPUT_WORDS-1));

	always@(posedge S_AXIS_ACLK)
	begin
	  if(!S_AXIS_ARESETN)
	    begin
	      write_pointer <= 0;
	      writes_done <= 1'b0;
	    end
	  else if (mst_exec_state == WAIT_HANDSHAKE && RECEIVE_READY) begin
    	write_pointer <= 0;  // 在握手完成后复位指针
    	writes_done <= 1'b0;
	  end  
	  else
	    if (write_pointer <= NUMBER_OF_INPUT_WORDS-1)
	      begin
	        if (fifo_wren)
	          begin
	            // write pointer is incremented after every write to the FIFO
	            // when FIFO write signal is enabled.
	            write_pointer <= write_pointer + 1;
	            writes_done <= 1'b0;
	          end
	        if ((write_pointer == NUMBER_OF_INPUT_WORDS-1) && S_AXIS_TLAST)
	        begin
	            // reads_done is asserted when NUMBER_OF_INPUT_WORDS numbers of streaming data 
	            // has been written to the FIFO which is also marked by S_AXIS_TLAST(kept for optional usage).
	            writes_done <= 1'b1;
	        end
	      end  
	end

	// FIFO write enable generation
	assign fifo_wren = S_AXIS_TVALID && axis_tready;

	// FIFO Implementation
	// Streaming input data is stored in FIFO
	always @( posedge S_AXIS_ACLK ) begin
		if((!S_AXIS_ARESETN)||(mst_exec_state == IDLE)) begin
			q_data_buf <= 'd0;
			s_data_buf <= 'd0;
		end
		else begin
			if (fifo_wren) begin
				if(write_pointer < NUMBER_OF_INPUT_WORDS - 1) begin
					q_data_buf[(write_pointer*C_S_AXIS_TDATA_WIDTH) +: C_S_AXIS_TDATA_WIDTH] 
						<= S_AXIS_TDATA[C_S_AXIS_TDATA_WIDTH-1 : 0];
				end
				else begin
						s_data_buf[S_WIDTH-1 : 0] <= S_AXIS_TDATA[C_S_AXIS_TDATA_WIDTH-1 : 0];
				end
			end  
		end
	end  

	// Add user logic here
	//这批数据已经写好
	assign SEND_VALID = (mst_exec_state == WAIT_HANDSHAKE);
	assign q_data_out = q_data_buf;
	assign s_data_out = s_data_buf;
	// User logic ends

	endmodule
