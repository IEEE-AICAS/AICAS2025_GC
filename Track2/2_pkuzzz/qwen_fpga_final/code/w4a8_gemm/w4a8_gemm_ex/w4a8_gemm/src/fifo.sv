`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/19 14:04:34
// Design Name: 
// Module Name: fifo2
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


module fifo #(
    parameter max_packagelength = 16,
    parameter DATA_WIDTH = 8, // ????¦Ë??
    parameter DEPTH = 4  // ???¦Ë??
) (
    input   logic clock,   // ??????
    input   logic reset, // ??¦Ë????????§¹??
    input   logic write_enable, // §Õ??????
    input   logic [DATA_WIDTH-1:0] data_in, // §Õ????
    output  logic full, // ???????
    input   logic read_enable, // ????????
    output  logic [DATA_WIDTH-1:0] data_out, // ??????
    output  logic                               data_out_valid,
    output  logic  empty // ???????
    
);
logic clock_free;
localparam FIFO_DEPTH = 1 << DEPTH;
// FIFO?¥???????RAM??
reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];
// §Õ???
reg [DEPTH:0] wr_ptr;
reg [DEPTH:0] count;
// ?????
(*mark_debug = "TRUE"*) reg [DEPTH:0] rd_ptr;


always_ff @(posedge clock) begin
    if (reset) begin // ??¦Ë?????§Õ???
        wr_ptr <= 0;
    end else if (write_enable) begin // §Õ???????????§Õ???????????§Õ???
        fifo_mem[wr_ptr[DEPTH-1:0]] <= data_in;
        wr_ptr <= wr_ptr+1;
    end
end


// ?????????
always_ff @(posedge clock) begin
    if (reset) begin // ??¦Ë???????????????
        rd_ptr <= 0;
    end else if (read_enable&&!empty) begin // ?????????????????????????????
        rd_ptr <= rd_ptr + 1;
    end else begin // ???????????????????
    end
end

// ?????????????????????
always_comb  begin
//    ptr_diff = $signed(wr_ptr) - $signed(rd_ptr);
//    ptr_diff = (wr_ptr) - (rd_ptr);
end

//logic data_out_valid_wait;
//logic [DATA_WIDTH-1:0] data_out_wait;
//logic [DEPTH:0] rd_ptr_wait;

always_ff @ (posedge clock) begin
  if(reset) 
    count <= 0;
  else begin
    if((write_enable)&&(read_enable&&!empty))
      count <= count ;
      else begin
        if(write_enable)
          count <= count +1 ;
        else begin
          if((read_enable&&!empty))
            count <= count -1;
          end
        end
    end
  end

always_comb begin
     empty = (wr_ptr[DEPTH] == rd_ptr[DEPTH]) && (wr_ptr[DEPTH-1:0] == rd_ptr[DEPTH-1:0]);
end
always_ff @(posedge clock) begin
     full   <= count > FIFO_DEPTH-10;
  end
  
always_comb begin
  data_out       = fifo_mem[rd_ptr[DEPTH-1:0]];
  data_out_valid = !((wr_ptr[DEPTH] == rd_ptr[DEPTH]) && (wr_ptr[DEPTH-1:0] == rd_ptr[DEPTH-1:0]));
end

endmodule

