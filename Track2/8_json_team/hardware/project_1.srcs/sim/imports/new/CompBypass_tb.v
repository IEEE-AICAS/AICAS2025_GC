`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/22/2025 05:43:25 PM
// Design Name: 
// Module Name: CompBypass_tb
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


module CompBypass_tb();
    reg clk;
    reg rst;
    reg [15:0] io_in_0;
    reg [15:0] io_bypass_0;
    wire [15:0] io_out_0;
    reg io_pipeIn_valid;
    wire io_pipeOut_valid;
    wire io_pipeIn_ready;
    reg io_pipeOut_ready;
    reg [1:0] io_mode;

    CompBypass uut(
        .clock(clk),
        .reset(rst),
        .io_clk(clk),
        .io_rst(rst),
        .io_in_0(io_in_0),
        .io_in_1(0),
        .io_in_2(0),
        .io_in_3(0),
        .io_in_4(0),
        .io_in_5(0),
        .io_in_6(0),
        .io_in_7(0),
        .io_in_8(0),
        .io_in_9(0),
        .io_in_10(0),
        .io_in_11(0),
        .io_in_12(0),
        .io_in_13(0),
        .io_in_14(0),
        .io_in_15(0),
        .io_in_16(0),
        .io_in_17(0),
        .io_in_18(0),
        .io_in_19(0),
        .io_in_20(0),
        .io_in_21(0),
        .io_in_22(0),
        .io_in_23(0),
        .io_in_24(0),
        .io_in_25(0),
        .io_in_26(0),
        .io_in_27(0),
        .io_in_28(0),
        .io_in_29(0),
        .io_in_30(0),
        .io_in_31(0),
        .io_bypass_0(io_bypass_0),
        .io_bypass_1(0),
        .io_bypass_2(0),
        .io_bypass_3(0),
        .io_bypass_4(0),
        .io_bypass_5(0),
        .io_bypass_6(0),
        .io_bypass_7(0),
        .io_bypass_8(0),
        .io_bypass_9(0),
        .io_bypass_10(0),
        .io_bypass_11(0),
        .io_bypass_12(0),
        .io_bypass_13(0),
        .io_bypass_14(0),
        .io_bypass_15(0),
        .io_bypass_16(0),
        .io_bypass_17(0),
        .io_bypass_18(0),
        .io_bypass_19(0),
        .io_bypass_20(0),
        .io_bypass_21(0),
        .io_bypass_22(0),
        .io_bypass_23(0),
        .io_bypass_24(0),
        .io_bypass_25(0),
        .io_bypass_26(0),
        .io_bypass_27(0),
        .io_bypass_28(0),
        .io_bypass_29(0),
        .io_bypass_30(0),
        .io_bypass_31(0),
        .io_out_0(io_out_0),
        .io_out_1(),
        .io_out_2(),
        .io_out_3(),
        .io_out_4(),
        .io_out_5(),
        .io_out_6(),
        .io_out_7(),
        .io_out_8(),
        .io_out_9(),
        .io_out_10(),
        .io_out_11(),
        .io_out_12(),
        .io_out_13(),
        .io_out_14(),
        .io_out_15(),
        .io_out_16(),
        .io_out_17(),
        .io_out_18(),
        .io_out_19(),
        .io_out_20(),
        .io_out_21(),
        .io_out_22(),
        .io_out_23(),
        .io_out_24(),
        .io_out_25(),
        .io_out_26(),
        .io_out_27(),
        .io_out_28(),
        .io_out_29(),
        .io_out_30(),
        .io_out_31(),
        .io_pipeIn_ready(io_pipeIn_ready),
        .io_pipeIn_valid(io_pipeIn_valid),
        .io_pipeIn_bits('h114514),
        .io_pipeOut_ready(io_pipeOut_ready),
        .io_pipeOut_valid(io_pipeOut_valid),
        .io_pipeOut_bits(),
        .io_mode(io_mode)
    );

    initial begin
        clk=1;
        rst=0;
        io_pipeIn_valid=1;
        io_pipeOut_ready=1;
        io_mode=0;
        #10 rst=1;
        #30 rst=0;
        #102;
        io_in_0=16'h1234;
        io_bypass_0=16'h5678;
        io_mode=0;
        #10;
        io_in_0=16'h5ff7;
        io_bypass_0=16'h7be2;
        #10;
        io_in_0=16'he978;
        io_bypass_0=16'h2d9e;
        #10;
        io_in_0=16'ha489;
        io_bypass_0=16'ha723;
        #10;
        io_in_0=16'h629c;
        io_bypass_0=16'h79ae;
        #10;
        io_in_0=16'h1234;
        io_bypass_0=16'h5678;
        io_mode=1;
        #10;
        io_in_0=16'h5ff7;
        io_bypass_0=16'h7be2;
        #10;
        io_in_0=16'he978;
        io_bypass_0=16'h2d9e;
        #10;
        io_in_0=16'ha489;
        io_bypass_0=16'ha723;
        #10;
        io_in_0=16'h629c;
        io_bypass_0=16'h79ae;
        #10;
        io_in_0=16'h1234;
        io_bypass_0=16'h5678;
        io_mode=2;
        #10;
        io_in_0=16'h5ff7;
        io_bypass_0=16'h7be2;
        #10;
        io_in_0=16'he978;
        io_bypass_0=16'h2d9e;
        #10;
        io_in_0=16'ha489;
        io_bypass_0=16'ha723;
        #10;
        io_in_0=16'h629c;
        io_bypass_0=16'h79ae;
        #50;
        $finish;
    end

    always #5 clk=~clk;
endmodule
