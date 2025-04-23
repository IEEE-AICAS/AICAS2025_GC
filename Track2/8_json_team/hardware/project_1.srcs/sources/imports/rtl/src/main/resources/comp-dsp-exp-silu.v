`timescale 1ns/1ps

module comp_dsp_exp_silu(
    input wire [15:0] mul1,
    input wire [15:0] mul2,
    input wire [15:0] bias,
    output wire [15:0] out
);

    wire [47:0] result;

    dsp_macro_exp_silu u_mul(
        .A({2'b0, mul1}),
        .B({{2{mul2[15]}}, mul2}),
        .C({{10{bias[15]}}, bias, 10'b0}),
        .P(result)
    );

    assign out=result[25:10];
endmodule