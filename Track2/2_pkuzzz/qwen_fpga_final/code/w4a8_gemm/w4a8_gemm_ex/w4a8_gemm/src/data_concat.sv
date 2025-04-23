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


module data_concat #(
    parameter INPUT_DATA_WIDTH = 256,
    parameter OUTPUT_DATA_WIDTH = 1024,
    parameter CONCAT_LEVEL = OUTPUT_DATA_WIDTH/INPUT_DATA_WIDTH
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

    logic [OUTPUT_DATA_WIDTH-1:0] middle_data_reg;
    logic [$clog2(CONCAT_LEVEL):0] concat_counter ;
    logic                         fire_out;
    logic                         fire_in ;

    assign fire_out = valid_out && ready_in ;
    assign fire_in  = valid_in  && ready_out;

    assign valid_out = (concat_counter==CONCAT_LEVEL);
    assign ready_out = ready_in || (concat_counter!=CONCAT_LEVEL);
    assign data_out  = middle_data_reg ;

    always_ff @ (posedge clk) begin
        if(areset) begin
            middle_data_reg <= 0;
            concat_counter <= 0;
        end
        else begin
            if(ap_start) begin
                middle_data_reg <= 0;
                concat_counter <= 0;
            end
            else begin
                if(fire_out&&fire_in) begin
                    concat_counter <=  1;
                    middle_data_reg <= OUTPUT_DATA_WIDTH==INPUT_DATA_WIDTH?data_in:{data_in,middle_data_reg[OUTPUT_DATA_WIDTH-1:INPUT_DATA_WIDTH]};
                end
                else begin
                    if(fire_out) begin
                        concat_counter <= 0;
                        middle_data_reg <= 0;
                    end
                    else begin
                        if(fire_in) begin
                            concat_counter <=  concat_counter + 1;
                            middle_data_reg <= OUTPUT_DATA_WIDTH==INPUT_DATA_WIDTH?data_in:{data_in,middle_data_reg[OUTPUT_DATA_WIDTH-1:INPUT_DATA_WIDTH]};
                        end
                    end
                end
            end
        end
    end

endmodule
