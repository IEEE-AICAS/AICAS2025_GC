// This is a generated file. Use and modify at your own risk.
//////////////////////////////////////////////////////////////////////////////// 
// default_nettype of none prevents implicit wire declaration.
`default_nettype none
module w4a8_gemm_example #(
  parameter integer C_M00_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M00_AXI_DATA_WIDTH = 128,
  parameter integer C_M01_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M01_AXI_DATA_WIDTH = 128,
  parameter integer C_M02_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M02_AXI_DATA_WIDTH = 128,
  parameter M                  = 8,
  parameter N                  = 8,
  parameter K                  = 32,
  parameter B_M                = 8,
  parameter B_N                = 16,
  parameter B_K                = 2,
  parameter MATRIXA_DATA_WIDTH = 8 ,
  parameter MATRIXB_DATA_WIDTH = 4 ,
  parameter RESULT_WIDTH       = 32
)
(
  // System Signals
  input  wire                              ap_clk         ,
  input  wire                              ap_rst_n       ,
  input  wire                              kernel_clk     ,
  input  wire                              kernel_rst_n   ,
  // AXI4 master interface m00_axi
  output wire                              m00_axi_awvalid,
  input  wire                              m00_axi_awready,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]   m00_axi_awaddr ,
  output wire [8-1:0]                      m00_axi_awlen  ,
  output wire                              m00_axi_wvalid ,
  input  wire                              m00_axi_wready ,
  output wire [C_M00_AXI_DATA_WIDTH-1:0]   m00_axi_wdata  ,
  output wire [C_M00_AXI_DATA_WIDTH/8-1:0] m00_axi_wstrb  ,
  output wire                              m00_axi_wlast  ,
  input  wire                              m00_axi_bvalid ,
  output wire                              m00_axi_bready ,
  output wire                              m00_axi_arvalid,
  input  wire                              m00_axi_arready,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]   m00_axi_araddr ,
  output wire [8-1:0]                      m00_axi_arlen  ,
  input  wire                              m00_axi_rvalid ,
  output wire                              m00_axi_rready ,
  input  wire [C_M00_AXI_DATA_WIDTH-1:0]   m00_axi_rdata  ,
  input  wire                              m00_axi_rlast  ,
  // AXI4 master interface m01_axi
  output wire                              m01_axi_awvalid,
  input  wire                              m01_axi_awready,
  output wire [C_M01_AXI_ADDR_WIDTH-1:0]   m01_axi_awaddr ,
  output wire [8-1:0]                      m01_axi_awlen  ,
  output wire                              m01_axi_wvalid ,
  input  wire                              m01_axi_wready ,
  output wire [C_M01_AXI_DATA_WIDTH-1:0]   m01_axi_wdata  ,
  output wire [C_M01_AXI_DATA_WIDTH/8-1:0] m01_axi_wstrb  ,
  output wire                              m01_axi_wlast  ,
  input  wire                              m01_axi_bvalid ,
  output wire                              m01_axi_bready ,
  output wire                              m01_axi_arvalid,
  input  wire                              m01_axi_arready,
  output wire [C_M01_AXI_ADDR_WIDTH-1:0]   m01_axi_araddr ,
  output wire [8-1:0]                      m01_axi_arlen  ,
  input  wire                              m01_axi_rvalid ,
  output wire                              m01_axi_rready ,
  input  wire [C_M01_AXI_DATA_WIDTH-1:0]   m01_axi_rdata  ,
  input  wire                              m01_axi_rlast  ,
  // AXI4 master interface m02_axi
  output wire                              m02_axi_awvalid,
  input  wire                              m02_axi_awready,
  output wire [C_M02_AXI_ADDR_WIDTH-1:0]   m02_axi_awaddr ,
  output wire [8-1:0]                      m02_axi_awlen  ,
  output wire                              m02_axi_wvalid ,
  input  wire                              m02_axi_wready ,
  output wire [C_M02_AXI_DATA_WIDTH-1:0]   m02_axi_wdata  ,
  output wire [C_M02_AXI_DATA_WIDTH/8-1:0] m02_axi_wstrb  ,
  output wire                              m02_axi_wlast  ,
  input  wire                              m02_axi_bvalid ,
  output wire                              m02_axi_bready ,
  output wire                              m02_axi_arvalid,
  input  wire                              m02_axi_arready,
  output wire [C_M02_AXI_ADDR_WIDTH-1:0]   m02_axi_araddr ,
  output wire [8-1:0]                      m02_axi_arlen  ,
  input  wire                              m02_axi_rvalid ,
  output wire                              m02_axi_rready ,
  input  wire [C_M02_AXI_DATA_WIDTH-1:0]   m02_axi_rdata  ,
  input  wire                              m02_axi_rlast  ,
  // Control Signals
  input  wire                              ap_start       ,
  output wire                              ap_idle        ,
  output wire                              ap_done        ,
  output wire                              ap_ready       ,
  input  wire [32-1:0]                     scalar00       ,
  input  wire [64-1:0]                     axi00_ptr0     ,
  input  wire [64-1:0]                     axi01_ptr0     ,
  input  wire [64-1:0]                     axi02_ptr0     
);


timeunit 1ps;
timeprecision 1ps;

///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
// Large enough for interesting traffic.
localparam integer  LP_DEFAULT_LENGTH_IN_BYTES = 16384;
localparam integer  LP_NUM_EXAMPLES    = 3;
localparam C_XFER_SIZE_WIDTH =32;
localparam LP_RD_MAX_OUTSTANDING = 16;
localparam LP_WR_MAX_OUTSTANDING = 16;

///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////
(* KEEP = "yes" *)
logic                                areset                         = 1'b0;
logic                                ap_start_r                     = 1'b0;
logic                                ap_idle_r                      = 1'b1;
logic                                ap_start_pulse                ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_i                     ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_r                      = {LP_NUM_EXAMPLES{1'b0}};
logic [32-1:0]                       ctrl_xfer_size_in_bytes        = LP_DEFAULT_LENGTH_IN_BYTES;
logic [32-1:0]                       ctrl_constant                  = 32'd1;

///////////////////////////////////////////////////////////////////////////////
// Begin RTL
///////////////////////////////////////////////////////////////////////////////

// Register and invert reset signal.
always @(posedge ap_clk) begin
  areset <= ~ap_rst_n;
end

// create pulse when ap_start transitions to 1
always @(posedge ap_clk) begin
  begin
    ap_start_r <= ap_start;
  end
end

assign ap_start_pulse = ap_start & ~ap_start_r;

// ap_idle is asserted when done is asserted, it is de-asserted when ap_start_pulse
// is asserted
always @(posedge ap_clk) begin
  if (areset) begin
    ap_idle_r <= 1'b1;
  end
  else begin
    ap_idle_r <= ap_done ? 1'b1 :
      ap_start_pulse ? 1'b0 : ap_idle;
  end
end

assign ap_idle = ap_idle_r;

// Done logic
always @(posedge ap_clk) begin
  if (areset) begin
    ap_done_r <= '0;
  end
  else begin
    ap_done_r <= (ap_done) ? '0 : ap_done_r | ap_done_i;
  end
end

assign ap_done = &ap_done_r;

// Ready Logic (non-pipelined case)
assign ap_ready = ap_done;

// Vadd example

logic [31:0] instr        ;
logic [3:0]  op_code      ; //0 for gemm,1 for gemv
logic [3:0]  read_activation ;
logic [3:0]  read_result  ;
logic [3:0]  write_result ;

assign instr = scalar00   ;
assign op_code = instr[3:0];
assign read_activation = instr[7:4];
assign read_result     = instr[11:8];
assign write_result    = instr[15:12];


logic [2:0] read_done_reg ;
logic [2:0] read_done     ;

logic [2:0] ap_done_tmp;

//assign ap_done_i[0] = not_busy_pulse ;
//assign ap_done_i[1] = (not_busy_pulse);
assign ap_done_i[0] = next_block ;
assign ap_done_i[1] = next_block;
assign ap_done_i[2] = ap_done_tmp[2]||((write_result == 4'h0)&&(ap_start_pulse));

assign read_done[0] =  ((p_addr_wr == B_M*B_K)&&!ap_start_pulse)||((read_activation==4'h0)&&(ap_start_pulse));
assign read_done[1] = (q_addr_wr == B_N*B_K)&&!ap_start_pulse;
assign read_done[2] = ((r_addr_wr == B_M*B_N)&&!ap_start_pulse)||((read_result==4'h0)&&(ap_start_pulse));

always_ff @ (posedge ap_clk) begin
  if(areset) begin
    read_done_reg <= 0;
  end
  else begin
    if(ap_start_pulse) begin
      read_done_reg <= read_done;
    end
    else begin
      read_done_reg <= &read_done_reg?0:(read_done_reg|read_done);
    end
  end
end

logic matrix_a_valid;
logic matrix_b_valid;
logic [M*K*MATRIXA_DATA_WIDTH-1:0] matrix_a_concat_data;
logic [N*K*MATRIXB_DATA_WIDTH-1:0] matrix_b_concat_data;

w4a8_gemm_example_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( C_XFER_SIZE_WIDTH     ) ,
  .C_MAX_OUTSTANDING   ( LP_RD_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 0                     )
)
p_buffer_readmaster (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse && (read_activation==4'h1)  ) ,
  .ctrl_done               (                ) ,
  .ctrl_addr_offset        ( axi00_ptr0        ) ,
  .ctrl_xfer_size_in_bytes (MATRIXA_DATA_WIDTH*M*K*B_M*B_K/8  ) ,
  .m_axi_arvalid           ( m00_axi_arvalid           ) ,
  .m_axi_arready           ( m00_axi_arready           ) ,
  .m_axi_araddr            ( m00_axi_araddr            ) ,
  .m_axi_arlen             ( m00_axi_arlen             ) ,
  .m_axi_rvalid            ( m00_axi_rvalid            ) ,
  .m_axi_rready            ( m00_axi_rready            ) ,
  .m_axi_rdata             ( m00_axi_rdata             ) ,
  .m_axi_rlast             ( m00_axi_rlast             ) ,
  .m_axis_aclk             ( ap_clk              ) ,
  .m_axis_areset           ( areset              ) ,
  .m_axis_tvalid           ( matrix_a_valid               ) ,
  .m_axis_tready           ( 1'b1               ) ,
  .m_axis_tlast            (                ) ,
  .m_axis_tdata            ( matrix_a               )  
);

w4a8_gemm_example_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M01_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M01_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( C_XFER_SIZE_WIDTH     ) ,
  .C_MAX_OUTSTANDING   ( LP_RD_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 0                     )
)
q_buffer_readmaster (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse ) ,
  .ctrl_done               (      ) ,
  .ctrl_addr_offset        ( axi01_ptr0        ) ,
  .ctrl_xfer_size_in_bytes ( MATRIXB_DATA_WIDTH*K*N*B_K*B_N/8 ) ,
  .m_axi_arvalid           ( m01_axi_arvalid           ) ,
  .m_axi_arready           ( m01_axi_arready           ) ,
  .m_axi_araddr            ( m01_axi_araddr            ) ,
  .m_axi_arlen             ( m01_axi_arlen             ) ,
  .m_axi_rvalid            ( m01_axi_rvalid            ) ,
  .m_axi_rready            ( m01_axi_rready            ) ,
  .m_axi_rdata             ( m01_axi_rdata             ) ,
  .m_axi_rlast             ( m01_axi_rlast             ) ,
  .m_axis_aclk             ( ap_clk              ) ,
  .m_axis_areset           ( areset              ) ,
  .m_axis_tvalid           ( matrix_b_valid               ) ,
  .m_axis_tready           ( 1'b1               ) ,
  .m_axis_tlast            (                ) ,
  .m_axis_tdata            ( matrix_b               )  
);

logic martix_c_valid;

w4a8_gemm_example_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M02_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M02_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( C_XFER_SIZE_WIDTH     ) ,
  .C_MAX_OUTSTANDING   ( LP_RD_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 0                     )
)
r_buffer_readmaster (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse && (read_result==4'h1)               ) ,
  .ctrl_done               (             ) ,
  .ctrl_addr_offset        ( axi02_ptr0        ) ,
  .ctrl_xfer_size_in_bytes ( RESULT_WIDTH*M*N*B_M*B_N/8 ) ,
  .m_axi_arvalid           ( m02_axi_arvalid           ) ,
  .m_axi_arready           ( m02_axi_arready           ) ,
  .m_axi_araddr            ( m02_axi_araddr            ) ,
  .m_axi_arlen             ( m02_axi_arlen             ) ,
  .m_axi_rvalid            ( m02_axi_rvalid            ) ,
  .m_axi_rready            ( m02_axi_rready            ) ,
  .m_axi_rdata             ( m02_axi_rdata             ) ,
  .m_axi_rlast             ( m02_axi_rlast             ) ,
  .m_axis_aclk             ( ap_clk              ) ,
  .m_axis_areset           ( areset              ) ,
  .m_axis_tvalid           ( martix_c_valid               ) ,
  .m_axis_tready           ( matrix_c_concat_ready_out               ) ,
  .m_axis_tlast            (                ) ,
  .m_axis_tdata            ( matrix_c               )  
);

logic [M*N*RESULT_WIDTH-1:0] matrix_c_concat_data;
logic                        matrix_c_concat_ready_out;
logic                        matrix_c_concat_ready_in;

logic [M*N*RESULT_WIDTH-1:0] matrix_data_zero ;
logic                        write_matrix_c_zero_reg;

always_ff @ (posedge ap_clk) begin
  if(areset) begin
    write_matrix_c_zero_reg <= 0;
  end
  else begin
    if(ap_start_pulse) begin
      write_matrix_c_zero_reg <= read_result==4'h2;
    end
    else begin
      if(read_done[2]) begin
        write_matrix_c_zero_reg <= 0;
      end
    end
  end
end
assign matrix_data_zero = 0;

data_concat # (
  .INPUT_DATA_WIDTH(C_M00_AXI_DATA_WIDTH),
  .OUTPUT_DATA_WIDTH(M*K*MATRIXA_DATA_WIDTH)
)  matrix_a_concat (
  .clk(ap_clk),
  .areset(areset),
  .ap_start(ap_start_pulse),
  .data_in  (matrix_a),
//  .data_in  (128'h01010101010101010101010101010101),
  .valid_in (matrix_a_valid),
  .data_out (matrix_a_concat_data),
  .valid_out(p_wr_en_in),
  .ready_in (1'b1),
  .ready_out()
);

data_concat # (
  .INPUT_DATA_WIDTH(C_M01_AXI_DATA_WIDTH),
  .OUTPUT_DATA_WIDTH(N*K*MATRIXB_DATA_WIDTH)
)  matrix_b_concat (
  .clk(ap_clk),
  .areset(areset),
  .ap_start(ap_start_pulse),
  .data_in  (matrix_b),
//  .data_in  (128'h11111111111111111111111111111111),
  .valid_in (matrix_b_valid),
  .data_out (matrix_b_concat_data),
  .valid_out(q_wr_en_in),
  .ready_in (1'b1),
  .ready_out()
);

data_concat # (
  .INPUT_DATA_WIDTH(M*N*RESULT_WIDTH),
  .OUTPUT_DATA_WIDTH(M*N*RESULT_WIDTH)
)  matrix_c_concat (
  .clk(ap_clk),
  .areset(areset),
  .ap_start(ap_start_pulse),
  .data_in  (write_matrix_c_zero_reg ? matrix_data_zero : matrix_c),
  .valid_in (write_matrix_c_zero_reg ? !(read_done[2]||read_done_reg[2]) : martix_c_valid),
  .data_out (matrix_c_concat_data),
  .valid_out(r_wr_en_in),
  .ready_in (1'b1),
  .ready_out(matrix_c_concat_ready_out)
);


localparam OP                 = 0 ;
localparam P_ADDR_WIDTH = $clog2(B_M*B_K);
localparam Q_ADDR_WIDTH = $clog2(B_N*B_K);
localparam R_ADDR_WIDTH = $clog2(B_M*B_N);

logic [C_M00_AXI_DATA_WIDTH-1:0] matrix_a;
logic [C_M01_AXI_DATA_WIDTH-1:0] matrix_b;
logic [C_M02_AXI_DATA_WIDTH-1:0] matrix_c;
logic                            p_wr_en_in;
logic                            q_wr_en_in;
logic                            r_wr_en_in;
logic                            r_rd_en_in;


logic                            busy;
logic                            busy_reg;
logic                            not_busy_pulse;

always_ff @ (posedge ap_clk) begin
  if(areset) begin
    busy_reg <= 0;
  end
  else begin
    busy_reg <= busy;
  end
end

assign not_busy_pulse = busy_reg&&!busy;

logic [P_ADDR_WIDTH:0] p_addr_wr;
logic [Q_ADDR_WIDTH:0] q_addr_wr;
logic [R_ADDR_WIDTH:0] r_addr_wr;
logic [R_ADDR_WIDTH:0] r_addr_rd;

always_ff @ (posedge ap_clk) begin
  if(areset) begin
    p_addr_wr <= 0;
    q_addr_wr <= 0;
    r_addr_wr <= 0;
    r_addr_rd <= 0;
  end
  else begin
    if(ap_start_pulse||(&read_done_reg)) begin
      p_addr_wr <= 0;
      q_addr_wr <= 0;
      r_addr_wr <= 0;
      r_addr_rd <= 0;
    end
    else begin
      p_addr_wr <= p_addr_wr + p_wr_en_in;
      q_addr_wr <= q_addr_wr + q_wr_en_in;
      r_addr_wr <= r_addr_wr + r_wr_en_in;
      r_addr_rd <= r_addr_rd + (r_rd_en_in&&!fifo_full);
    end
  end
end

logic enable_r_addr_rd;
logic enable_r_addr_rd_twice;

always_ff @ (posedge ap_clk) begin
  if(areset) begin
    enable_r_addr_rd <= 0;
    enable_r_addr_rd_twice <= 0;
  end
  else begin
    if(ap_start_pulse) begin
      enable_r_addr_rd <= 0;
      enable_r_addr_rd_twice <= 0;
    end
    else begin
      if(not_busy_pulse&&(write_result == 4'h1)) begin
        enable_r_addr_rd <= 1;
      end
//      if(not_busy_pulse&&(write_result == 4'h1)&&enable_r_addr_rd) begin
//        enable_r_addr_rd_twice <= 1;
//      end
    end
  end
end

assign r_rd_en_in = (write_result == 4'h1)&&enable_r_addr_rd && (r_addr_rd != B_M*B_N) && (!fifo_full);

`define DP

logic next_block;

//assign next_block = not_busy_pulse;

async_gemm # (
.M                 (M                 ),
.N                 (N                 ),
.K                 (K                 ),
.B_M               (B_M               ),
.B_N               (B_N               ),
.B_K               (B_K               ),
.A_DATA_WIDTH      (MATRIXA_DATA_WIDTH),
.B_DATA_WIDTH      (MATRIXB_DATA_WIDTH),
.RESULT_WIDTH      (RESULT_WIDTH      )
)  gemm_inst (
.clk         (ap_clk       ),                            
.kernel_clk  (kernel_clk   ),
.rst         (areset       ),         
.kernel_rst  (!kernel_rst_n),                   
.last_start  ((&read_done_reg)&&(op_code==4'h0)&&(write_result==4'h1)    ),                            
.p_wr_en_in  (p_wr_en_in),                            
.q_wr_en_in  (q_wr_en_in),                            
.r_wr_en_in  (r_wr_en_in),                            
.r_rd_en_in  (r_rd_en_in ),                            
.p_addr_in   (p_addr_wr ),         
.q_addr_in   (q_addr_wr ),         
.r_rd_addr_in(r_addr_rd ),         
.r_wr_addr_in(r_addr_wr  ),         
.matrix_a_in (matrix_a_concat_data ),
.matrix_b_in (matrix_b_concat_data ),
.matrix_c_in (matrix_c_concat_data ),     
.busy        (busy         ),              
.next_block  (next_block),            
.matrix_c_out(matrix_c_out          )     ,
.c_vaild_out (matrix_c_out_valid )
);



//async_gemm # (
//.M                 (M                 ),
//.N                 (N                 ),
//.K                 (K                 ),
//.B_M               (B_M               ),
//.B_N               (B_N               ),
//.B_K               (B_K               ),
//.A_DATA_WIDTH      (MATRIXA_DATA_WIDTH),
//.B_DATA_WIDTH      (MATRIXB_DATA_WIDTH),
//.RESULT_WIDTH      (RESULT_WIDTH      )
//)  gemm_inst (
//.clk         (ap_clk       ),                            
//.kernel_clk  (kernel_clk   ),
//.rst         (areset       ),         
//.kernel_rst  (!kernel_rst_n),                                
//.start       ((&read_done_reg)&&(op_code==4'h0)    ),                            
//.p_wr_en_in  (p_wr_en_in),                            
//.q_wr_en_in  (q_wr_en_in),                            
//.r_wr_en_in  (r_wr_en_in),                            
//.r_rd_en_in  (r_rd_en_in ),                            
//.p_addr_in   (p_addr_wr ),         
//.q_addr_in   (q_addr_wr ),         
//.r_rd_addr_in(r_addr_rd ),         
//.r_wr_addr_in(r_addr_wr  ),         
////.matrix_a_in (512'h01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101 ),
////.matrix_b_in (256'h1111111111111111111111111111111111111111111111111111111111111111 ),
////.matrix_a_in (512'h00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001 ),
////.matrix_b_in (256'h0000000100000001000000010000000100000001000000010000000100000001 ),
//.matrix_a_in (1024'h0000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001 ),
//.matrix_b_in ( 512'h00000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001 ),
//.matrix_c_in (2048'h0 ),     
//.busy        (busy         ),      
//.next_block  (next_block),                        
//.matrix_c_out(matrix_c_out          )     ,
//.c_vaild_out (matrix_c_out_valid )
//);

logic [M*N*RESULT_WIDTH-1:0] matrix_c_out;
logic matrix_c_out_valid;

logic                        s_axis_tvalid ;
logic                        s_axis_tready ;
logic [M*N*RESULT_WIDTH-1:0] s_axis_tdata  ;
logic                        fifo_full     ;

// always_ff @ (posedge ap_clk) begin
//   matrix_c_out_valid <= r_rd_en_in;
// end

logic [M*N*RESULT_WIDTH-1:0] matrix_c_devide_data;
logic                        matrix_c_devide_valid;
logic                        matrix_c_devide_ready;

fifo # (
  .DATA_WIDTH(M*N*RESULT_WIDTH),
  .DEPTH(4)
) r_fifo (
  .clock        (ap_clk),
  .reset      (areset),
  .write_enable    (matrix_c_out_valid),     
  .data_in     (matrix_c_out),
  .full      (fifo_full),
  .read_enable    (matrix_c_devide_ready),              
  .data_out       (matrix_c_devide_data),
  .data_out_valid (matrix_c_devide_valid),
  .empty           ()                
);

data_devide # (
  .INPUT_DATA_WIDTH(M*N*RESULT_WIDTH),
  .OUTPUT_DATA_WIDTH(C_M02_AXI_DATA_WIDTH)
)  matrix_c_devide (
  .clk(ap_clk),
  .areset(areset),
  .ap_start(ap_start_pulse),
  .data_in  (matrix_c_devide_data),
  .valid_in (matrix_c_devide_valid),
  .data_out (s_axis_tdata),
  .valid_out(s_axis_tvalid),
  .ready_in (s_axis_tready),
  .ready_out(matrix_c_devide_ready)
);

w4a8_gemm_example_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( C_XFER_SIZE_WIDTH     ) ,
  .C_MAX_OUTSTANDING   ( 2 ) ,
  .C_INCLUDE_DATA_FIFO ( 0                     )
)
p_buffer_write_master (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( 1'b0                ) ,
  .ctrl_done               (               ) ,
  .ctrl_addr_offset        ( axi00_ptr0        ) ,
  .ctrl_xfer_size_in_bytes ( 0 ) ,
  .m_axi_awvalid           ( m00_axi_awvalid           ) ,
  .m_axi_awready           ( m00_axi_awready           ) ,
  .m_axi_awaddr            ( m00_axi_awaddr            ) ,
  .m_axi_awlen             ( m00_axi_awlen             ) ,
  .m_axi_wvalid            ( m00_axi_wvalid            ) ,
  .m_axi_wready            ( m00_axi_wready            ) ,
  .m_axi_wdata             ( m00_axi_wdata             ) ,
  .m_axi_wstrb             ( m00_axi_wstrb             ) ,
  .m_axi_wlast             ( m00_axi_wlast             ) ,
  .m_axi_bvalid            ( m00_axi_bvalid            ) ,
  .m_axi_bready            ( m00_axi_bready            ) ,
  .s_axis_aclk             ( ap_clk              ) ,
  .s_axis_areset           ( areset              ) ,
  .s_axis_tvalid           (             ) ,
  .s_axis_tready           (             ) ,
  .s_axis_tdata            (             )
);

w4a8_gemm_example_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M01_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M01_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( C_XFER_SIZE_WIDTH     ) ,
  .C_MAX_OUTSTANDING   ( 2 ) ,
  .C_INCLUDE_DATA_FIFO ( 0                     )
)
q_buffer_write_master (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( 0                ) ,
  .ctrl_done               (               ) ,
  .ctrl_addr_offset        ( axi01_ptr0        ) ,
  .ctrl_xfer_size_in_bytes ( 0 ) ,
  .m_axi_awvalid           ( m01_axi_awvalid           ) ,
  .m_axi_awready           ( m01_axi_awready           ) ,
  .m_axi_awaddr            ( m01_axi_awaddr            ) ,
  .m_axi_awlen             ( m01_axi_awlen             ) ,
  .m_axi_wvalid            ( m01_axi_wvalid            ) ,
  .m_axi_wready            ( m01_axi_wready            ) ,
  .m_axi_wdata             ( m01_axi_wdata             ) ,
  .m_axi_wstrb             ( m01_axi_wstrb             ) ,
  .m_axi_wlast             ( m01_axi_wlast             ) ,
  .m_axi_bvalid            ( m01_axi_bvalid            ) ,
  .m_axi_bready            ( m01_axi_bready            ) ,
  .s_axis_aclk             ( ap_clk              ) ,
  .s_axis_areset           ( areset              ) ,
  .s_axis_tvalid           (             ) ,
  .s_axis_tready           (             ) ,
  .s_axis_tdata            (             )
);

w4a8_gemm_example_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M02_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M02_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( C_XFER_SIZE_WIDTH     ) ,
  .C_MAX_OUTSTANDING   ( LP_WR_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
r_buffer_write_master (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse && (write_result == 4'h1)      ) ,
  .ctrl_done               ( ap_done_tmp[2]              ) ,
  .ctrl_addr_offset        ( axi02_ptr0        ) ,
  .ctrl_xfer_size_in_bytes ( RESULT_WIDTH*M*N*B_M*B_N/8 ) ,
  .m_axi_awvalid           ( m02_axi_awvalid           ) ,
  .m_axi_awready           ( m02_axi_awready           ) ,
  .m_axi_awaddr            ( m02_axi_awaddr            ) ,
  .m_axi_awlen             ( m02_axi_awlen             ) ,
  .m_axi_wvalid            ( m02_axi_wvalid            ) ,
  .m_axi_wready            ( m02_axi_wready            ) ,
  .m_axi_wdata             ( m02_axi_wdata             ) ,
  .m_axi_wstrb             ( m02_axi_wstrb             ) ,
  .m_axi_wlast             ( m02_axi_wlast             ) ,
  .m_axi_bvalid            ( m02_axi_bvalid            ) ,
  .m_axi_bready            ( m02_axi_bready            ) ,
  .s_axis_aclk             ( ap_clk              ) ,
  .s_axis_areset           ( areset              ) ,
  .s_axis_tvalid           (  s_axis_tvalid           ) ,
  .s_axis_tready           (  s_axis_tready           ) ,
  .s_axis_tdata            (  s_axis_tdata            )
);



endmodule : w4a8_gemm_example
`default_nettype wire

