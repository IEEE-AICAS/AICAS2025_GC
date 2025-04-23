`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2025 01:10:36 AM
// Design Name: 
// Module Name: dff
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


module gen_dff #(parameter WIDTH=32)(
    input wire [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q,
    input wire clk,
    input wire rst,
    input wire en
);

    always @(posedge clk or posedge rst)
        if(rst)
            q<=0;
        else
            q<=en ? d : q;
endmodule
