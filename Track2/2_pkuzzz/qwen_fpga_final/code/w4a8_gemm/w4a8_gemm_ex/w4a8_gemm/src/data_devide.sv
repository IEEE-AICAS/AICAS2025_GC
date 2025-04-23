`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/15/2025 07:44:05 PM
// Design Name: 
// Module Name: data_concat
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


module data_devide #(
    parameter INPUT_DATA_WIDTH = 1024,
    parameter OUTPUT_DATA_WIDTH = 256,
    parameter CONCAT_LEVEL = INPUT_DATA_WIDTH/OUTPUT_DATA_WIDTH
) (

    input                                    clk       ,
    input                                    areset    ,
    input                                    ap_start  ,
    input [INPUT_DATA_WIDTH-1:0]             data_in   ,
    input                                    valid_in  ,
    output logic [OUTPUT_DATA_WIDTH-1:0]     data_out  ,
    output logic                             valid_out ,
    input                                    ready_in  ,
    output                                   ready_out        
    );

    logic [INPUT_DATA_WIDTH-1:0] middle_data_reg;
    logic [$clog2(CONCAT_LEVEL):0] concat_counter ;
    logic                         fire_out;
    logic                         fire_in ;

    assign fire_out = valid_out && ready_in ;
    assign fire_in  = valid_in  && ready_out;

    assign valid_out = concat_counter!=CONCAT_LEVEL;
//    assign data_out  = middle_data_reg[INPUT_DATA_WIDTH-1:INPUT_DATA_WIDTH-OUTPUT_DATA_WIDTH];
    assign data_out  = middle_data_reg[OUTPUT_DATA_WIDTH-1:0];
    assign ready_out = (concat_counter==CONCAT_LEVEL)||((concat_counter==CONCAT_LEVEL-1)&&ready_in);

    always_ff @ (posedge clk) begin
        if(areset) begin
            middle_data_reg <= 0;
            concat_counter <= CONCAT_LEVEL;
        end
        else begin
            if(ap_start) begin
                middle_data_reg <= 0;
                concat_counter <= CONCAT_LEVEL;
            end
            else begin
                if(fire_in && fire_out) begin
                     middle_data_reg <= data_in;
                     concat_counter  <= 0      ;
                 end
                 else begin
                     if(fire_in) begin
                         middle_data_reg <= data_in;
                         concat_counter  <= 0      ;
                     end
                     else begin
                         if(fire_out) begin
                             middle_data_reg <= middle_data_reg>>OUTPUT_DATA_WIDTH;
                             concat_counter <= concat_counter + 1;
                         end
                     end
                 end
            end
        end
    end

endmodule
