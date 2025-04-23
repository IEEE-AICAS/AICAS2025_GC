`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2025 04:14:19 PM
// Design Name: 
// Module Name: w4a8_gemm_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module w4a8_gemm_wrapper#(
  parameter integer C_M00_AXI_ADDR_WIDTH = 64  ,
  parameter integer C_M00_AXI_DATA_WIDTH = 512 ,
  parameter integer C_M01_AXI_ADDR_WIDTH = 64  ,
  parameter integer C_M01_AXI_DATA_WIDTH = 256 ,
  parameter integer C_M02_AXI_ADDR_WIDTH = 64  ,
  parameter integer C_M02_AXI_DATA_WIDTH = 1024
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
  input  wire [32-1:0]                     scalar01       ,
  input  wire [32-1:0]                     scalar02       ,
  input  wire [32-1:0]                     scalar03       ,
  input  wire [64-1:0]                     axi00_ptr0     ,
  input  wire [64-1:0]                     axi01_ptr0     ,
  input  wire [64-1:0]                     axi02_ptr0     
);

localparam integer  LP_NUM_EXAMPLES    = 1;

(* KEEP = "yes" *)
logic                                areset                         = 1'b0;
logic                                ap_start_r                     = 1'b0;
logic                                ap_idle_r                      = 1'b1;
logic                                ap_start_pulse                ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_i                     ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_r                      = {LP_NUM_EXAMPLES{1'b0}};
// logic [32-1:0]                       ctrl_xfer_size_in_bytes        = LP_DEFAULT_LENGTH_IN_BYTES;
// logic [32-1:0]                       ctrl_constant                  = 32'd1;

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

assign ap_start_pulse = ap_start & ~ap_start_r;

w4a8_gemm_example #(
  .C_M00_AXI_ADDR_WIDTH ( C_M00_AXI_ADDR_WIDTH ),
  .C_M00_AXI_DATA_WIDTH ( C_M00_AXI_DATA_WIDTH ),
  .C_M01_AXI_ADDR_WIDTH ( C_M01_AXI_ADDR_WIDTH ),
  .C_M01_AXI_DATA_WIDTH ( C_M01_AXI_DATA_WIDTH ),
  .C_M02_AXI_ADDR_WIDTH ( C_M02_AXI_ADDR_WIDTH ),
  .C_M02_AXI_DATA_WIDTH ( C_M02_AXI_DATA_WIDTH )
)
inst_example (
  .ap_clk          ( ap_clk          ),
  .ap_rst_n        ( ap_rst_n        ),
  .kernel_clk      ( kernel_clk      ),
  .kernel_rst_n    ( kernel_rst_n    ),
  .m00_axi_awvalid ( m00_axi_awvalid ),
  .m00_axi_awready ( m00_axi_awready ),
  .m00_axi_awaddr  ( m00_axi_awaddr  ),
  .m00_axi_awlen   ( m00_axi_awlen   ),
  .m00_axi_wvalid  ( m00_axi_wvalid  ),
  .m00_axi_wready  ( m00_axi_wready  ),
  .m00_axi_wdata   ( m00_axi_wdata   ),
  .m00_axi_wstrb   ( m00_axi_wstrb   ),
  .m00_axi_wlast   ( m00_axi_wlast   ),
  .m00_axi_bvalid  ( m00_axi_bvalid  ),
  .m00_axi_bready  ( m00_axi_bready  ),
  .m00_axi_arvalid ( m00_axi_arvalid ),
  .m00_axi_arready ( m00_axi_arready ),
  .m00_axi_araddr  ( m00_axi_araddr  ),
  .m00_axi_arlen   ( m00_axi_arlen   ),
  .m00_axi_rvalid  ( m00_axi_rvalid  ),
  .m00_axi_rready  ( m00_axi_rready  ),
  .m00_axi_rdata   ( m00_axi_rdata   ),
  .m00_axi_rlast   ( m00_axi_rlast   ),
  .m01_axi_awvalid ( m01_axi_awvalid ),
  .m01_axi_awready ( m01_axi_awready ),
  .m01_axi_awaddr  ( m01_axi_awaddr  ),
  .m01_axi_awlen   ( m01_axi_awlen   ),
  .m01_axi_wvalid  ( m01_axi_wvalid  ),
  .m01_axi_wready  ( m01_axi_wready  ),
  .m01_axi_wdata   ( m01_axi_wdata   ),
  .m01_axi_wstrb   ( m01_axi_wstrb   ),
  .m01_axi_wlast   ( m01_axi_wlast   ),
  .m01_axi_bvalid  ( m01_axi_bvalid  ),
  .m01_axi_bready  ( m01_axi_bready  ),
  .m01_axi_arvalid ( m01_axi_arvalid ),
  .m01_axi_arready ( m01_axi_arready ),
  .m01_axi_araddr  ( m01_axi_araddr  ),
  .m01_axi_arlen   ( m01_axi_arlen   ),
  .m01_axi_rvalid  ( m01_axi_rvalid  ),
  .m01_axi_rready  ( m01_axi_rready  ),
  .m01_axi_rdata   ( m01_axi_rdata   ),
  .m01_axi_rlast   ( m01_axi_rlast   ),
  .m02_axi_awvalid ( m02_axi_awvalid ),
  .m02_axi_awready ( m02_axi_awready ),
  .m02_axi_awaddr  ( m02_axi_awaddr  ),
  .m02_axi_awlen   ( m02_axi_awlen   ),
  .m02_axi_wvalid  ( m02_axi_wvalid  ),
  .m02_axi_wready  ( m02_axi_wready  ),
  .m02_axi_wdata   ( m02_axi_wdata   ),
  .m02_axi_wstrb   ( m02_axi_wstrb   ),
  .m02_axi_wlast   ( m02_axi_wlast   ),
  .m02_axi_bvalid  ( m02_axi_bvalid  ),
  .m02_axi_bready  ( m02_axi_bready  ),
  .m02_axi_arvalid ( m02_axi_arvalid ),
  .m02_axi_arready ( m02_axi_arready ),
  .m02_axi_araddr  ( m02_axi_araddr  ),
  .m02_axi_arlen   ( m02_axi_arlen   ),
  .m02_axi_rvalid  ( m02_axi_rvalid  ),
  .m02_axi_rready  ( m02_axi_rready  ),
  .m02_axi_rdata   ( m02_axi_rdata   ),
  .m02_axi_rlast   ( m02_axi_rlast   ),
  .ap_start        ( block_start        ),
  .ap_done         ( block_done        ),
  .ap_idle         (         ),
  .ap_ready        (         ),
  .scalar00        ( op_code        ),
  .axi00_ptr0      ( addr_activation      ),
  .axi01_ptr0      ( addr_weight      ),
  .axi02_ptr0      ( addr_result      )
);

logic [63:0] addr_weight;
logic [63:0] addr_activation;
logic [63:0] addr_result;
logic [31:0] op_code;

logic block_done;
logic block_start;

w4a8_controler # (
    .WEIGHT_BLOCK_SIZE    (4096),
    .ACTIVATION_BLOCK_SIZE(4096),
    .RESULT_BLOCK_SIZE    (32*1024),
    .GEMM                 (1)
) controler_inst (
    .ap_clk(ap_clk),
    .areset(areset),
    .M              (scalar01),
    .N              (scalar02),
    .K              (scalar03),
    .axi00_ptr0     (axi00_ptr0),
    .axi01_ptr0     (axi01_ptr0),
    .axi02_ptr0     (axi02_ptr0),
    .addr_weight    (addr_weight),
    .addr_activation(addr_activation),
    .addr_result    (addr_result),
    .op_code        (op_code),
    .ap_start       (ap_start_pulse),
    .ap_done        (ap_done_i),
    .block_done     (block_done),
    .block_start    (block_start)
);

endmodule
