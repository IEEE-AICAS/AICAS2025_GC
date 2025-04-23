`timescale 1ns/1ps

module comp_dsp_mul_add(
    input wire [11:0] in1,
    input wire [11:0] in2,
    input wire [27:0] bias,
    output wire [27:0] out,
    input wire clk,
    input wire rst,
    input wire en
);

    dsp_macro_bypass u_mul(
        .CLK(clk),
        .SCLR(rst),
        .CE(en),
        .A({{15{in1[11]}}, in1}),
        .B({{6{in2[11]}}, in2}),
        .C({{20{bias[27]}}, bias}),
        .P(out)
    );
endmodule