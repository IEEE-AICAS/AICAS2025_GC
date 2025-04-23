`timescale 1ns/1ps

module comp_dsp_wx2(
    input wire signed [26:0] dsp_a, 
    input wire signed [7:0] dsp_b,
    input wire signed [23:0] partsum0_pre,
    input wire signed [23:0] partsum1_pre,
    output wire signed [23:0] partsum0, 
    output wire signed [23:0] partsum1, 
    
    input wire clk,
    input wire rst,
    input wire comp_valid,
    input wire pipe_valid,
    input wire param_wide_mode,
    output wire output_valid
);

    wire signed [47:0] dsp_c;
    wire signed [26:0] dsp_d;
    wire signed [47:0] dsp_p;
    wire [1:0] dsp_mode;

    // assign dsp_a=param_wide_mode ? 
    //     (param0[7] ? $signed({~param1, 11'h0, ~param0}) : 
    //     $signed({param1, 11'h0, param0})) : 
    //     (param0[3] ? $signed({~param1[3:0], 19'h0, ~param0[3:0]}) : 
    //     $signed({param1[3:0], 19'h0, param0[3:0]}));
    // assign dsp_b=param_wide_mode ? 
    //     (param0[7] ? $signed($signed(~act0)+'h1) : act0) :
    //     (param0[3] ? $signed($signed(~act0)+'h1) : act0);
    // assign dsp_c=pipe_valid3|(~input_valid3) ? 0 : param_wide_mode3 ?
    //     $signed({dsp_p[47:19], 1'b0, dsp_p[17:0]}) :
    //     $signed({dsp_p[47:23], 1'b0, dsp_p[21:0]});
    // assign dsp_d=param_wide_mode ? {8'h1, 19'h1} : {4'h1, 23'h1};
    // assign partsum0=param_wide_mode ? 
    //     $signed({{6{dsp_p[DSP_A_WIDTH-PARAM_WIDE_WIDTH-2]}}, dsp_p[17:0]}) :
    //     $signed({{2{dsp_p[DSP_A_WIDTH-PARAM_WIDTH-2]}}, dsp_p[21:0]});
    // assign partsum1=param_wide_mode ?
    //     $signed(dsp_p[47:19]) :
    //     $signed(dsp_p[47:23]);
    // assign dsp_mode=param_wide_mode ? param0[7] : param0[3];


    assign dsp_c=param_wide_mode ? 
        {{5{partsum1_pre[20]}}, partsum1_pre, partsum0_pre[20:0]} : 
        {partsum1_pre[22], partsum1_pre, partsum0_pre[22:0]};
    assign dsp_d=param_wide_mode ? 
        (dsp_a[7] ? 27'h7ffff00 : 27'h0) :
        (dsp_a[3] ? 27'h7fffff0 : 27'h0);
    assign partsum0=param_wide_mode ? 
        $signed({{5{dsp_p[20]}}, dsp_p[20:0]}) :
        $signed({dsp_p[22], dsp_p[22:0]});
    assign partsum1=param_wide_mode ? $signed(dsp_p[44:21]) : $signed(dsp_p[46:23]);
    assign dsp_mode={pipe_valid, param_wide_mode ? dsp_a[7] : dsp_a[3]};

    dsp_macro_0 u_dsp_0(
        .CLK(clk),
        .SCLR(rst),
        .CE(comp_valid|pipe_valid),
        .SEL(dsp_mode),
        .A(dsp_a),
        .B({{10{dsp_b[7]}}, dsp_b}),
        .C(dsp_c),
        .D(dsp_d),
        .P(dsp_p)
    );

    // gen_dff #(.WIDTH(1)) u_output_valid(
    //     .d(pipe_valid),
    //     .q(output_valid),
    //     .clk(clk),
    //     .rst(rst),
    //     .en(1)
    // );
endmodule
