`timescale 1ns / 1ps

module acc_16_adder #(
    parameter PRECISION_ADDER = 16 
) (
    input   wire                [PRECISION_ADDER*16-1:0]                 acc_din,
    output  wire   signed       [31:0]                    acc_dout
);
    
    wire   signed               [PRECISION_ADDER-1:0]                    first_adder_din[15:0];
    wire   signed               [PRECISION_ADDER:0]                      first_adder_dout[7:0];
    wire   signed               [PRECISION_ADDER+1:0]                    second_adder_dout[3:0];
    wire   signed               [PRECISION_ADDER+2:0]                    third_adder_dout[1:0];
    wire   signed               [PRECISION_ADDER+3:0]                    acc_dout_wire;
    
    /*Data line mapping*/
    genvar p;
    generate 
    for(p=0;p<16;p=p+1) begin
        assign first_adder_din[p] = acc_din[(p+1)*PRECISION_ADDER-1-:PRECISION_ADDER];
    end
    endgenerate    
    /*First stage adder*/
    generate 
    for(p=0;p<8;p=p+1) begin
        assign first_adder_dout[p] = first_adder_din[2*p]+first_adder_din[2*p+1];
    end
    endgenerate
    /*Second stage adder*/
    generate 
    for(p=0;p<4;p=p+1) begin
        assign second_adder_dout[p] = first_adder_dout[2*p]+first_adder_dout[2*p+1];
    end
    endgenerate
    /*Third stage adder*/
    generate 
    for(p=0;p<2;p=p+1) begin
        assign third_adder_dout[p] = second_adder_dout[2*p]+second_adder_dout[2*p+1];
    end
    endgenerate
    /*Fourth stage adder*/
    assign acc_dout_wire = third_adder_dout[0]+third_adder_dout[1];

    /*Data truncation for output*/
    //20bQ14->16bQ14
    assign acc_dout = acc_dout_wire;
    // assign acc_dout = acc_dout_wire[PRECISION_ADDER+3]?
    //         (acc_dout_wire[PRECISION_ADDER+2] && acc_dout_wire[PRECISION_ADDER+1] && acc_dout_wire[PRECISION_ADDER] && acc_dout_wire[PRECISION_ADDER-1]
    //         ?{1'b1,acc_dout_wire[PRECISION_ADDER-2:0]}:{1'b1,{PRECISION_ADDER-1{1'b0}}}):
    //         (acc_dout_wire[PRECISION_ADDER+2] || acc_dout_wire[PRECISION_ADDER+1] || acc_dout_wire[PRECISION_ADDER] || acc_dout_wire[PRECISION_ADDER-1]
    //         ?{1'b0,{PRECISION_ADDER-1{1'b1}}}:{1'b0,acc_dout_wire[PRECISION_ADDER-2:0]});

endmodule
