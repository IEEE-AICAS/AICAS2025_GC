`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/19/2025 11:22:52 PM
// Design Name: 
// Module Name: CompExpSilu_tb
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


module CompExpSILU_tb;
    reg clock;
    reg reset;
    reg io_pipeIn_valid;
    wire io_pipeIn_ready;
    wire io_pipeOut_valid;
    reg io_pipeOut_ready;
    reg [15:0] io_in_0;
    wire [15:0] io_out_0;
    reg [1:0] io_mode;

    CompExpSILU dut(
        .clock(clock),
        .reset(reset),
        .io_pipeIn_valid(io_pipeIn_valid),
        .io_pipeIn_ready(io_pipeIn_ready),
        .io_pipeOut_valid(io_pipeOut_valid),
        .io_pipeOut_ready(io_pipeOut_ready),
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
        .io_in_32(0),
        .io_in_33(0),
        .io_in_34(0),
        .io_in_35(0),
        .io_in_36(0),
        .io_in_37(0),
        .io_in_38(0),
        .io_in_39(0),
        .io_in_40(0),
        .io_in_41(0),
        .io_in_42(0),
        .io_in_43(0),
        .io_in_44(0),
        .io_in_45(0),
        .io_in_46(0),
        .io_in_47(0),
        .io_in_48(0),
        .io_in_49(0),
        .io_in_50(0),
        .io_in_51(0),
        .io_in_52(0),
        .io_in_53(0),
        .io_in_54(0),
        .io_in_55(0),
        .io_in_56(0),
        .io_in_57(0),
        .io_in_58(0),
        .io_in_59(0),
        .io_in_60(0),
        .io_in_61(0),
        .io_in_62(0),
        .io_in_63(0),
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
        .io_out_32(),
        .io_out_33(),
        .io_out_34(),
        .io_out_35(),
        .io_out_36(),
        .io_out_37(),
        .io_out_38(),
        .io_out_39(),
        .io_out_40(),
        .io_out_41(),
        .io_out_42(),
        .io_out_43(),
        .io_out_44(),
        .io_out_45(),
        .io_out_46(),
        .io_out_47(),
        .io_out_48(),
        .io_out_49(),
        .io_out_50(),
        .io_out_51(),
        .io_out_52(),
        .io_out_53(),
        .io_out_54(),
        .io_out_55(),
        .io_out_56(),
        .io_out_57(),
        .io_out_58(),
        .io_out_59(),
        .io_out_60(),
        .io_out_61(),
        .io_out_62(),
        .io_out_63(),
        .io_mode(io_mode)
    );

    initial begin
        clock=1;
        reset=0;
        io_pipeIn_valid=1;
        io_pipeOut_ready=1;
        io_in_0=0;
        io_mode=1;
        #5 reset=1;
        #100 reset=0;
    end

    always #5 clock=~clock;
    always #10 io_in_0<=io_in_0+1;
endmodule
