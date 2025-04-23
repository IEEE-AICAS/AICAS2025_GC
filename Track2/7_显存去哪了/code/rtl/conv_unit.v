`timescale 1ns / 1ps

module conv_unit #(
    parameter MAX_KERNEL_NUMBER = 16,
    parameter WEIGHT_PRECISION = 8,
    parameter FEATURE_MAP_PRECISION = 8,
    parameter BIAS_PRECISION = 32,
    parameter PRECISION_ADDER = 16
)(
	input   wire								       			                clk,                        //clk
	input   wire						     						            rst_n,                      //reset negative
	input   wire                                                                enable,                     //enable
	input   wire            [WEIGHT_PRECISION*MAX_KERNEL_NUMBER-1:0]            din_weight,                 //input data of weights
    input   wire            [FEATURE_MAP_PRECISION*MAX_KERNEL_NUMBER-1:0]       din_fm,                     //input data of feature map
    input   wire            [BIAS_PRECISION-1:0]                                din_bias,                   //input data of bias, need to require
    input   wire                                                                fm_updata_valid,            //valid signal of feature map
    input   wire                                                                weight_updata_valid,        //valid signal of weights
    input   wire                                                                bias_or_not,                //whether the layer need bias data
    output  wire  signed    [31:0]                               dout,                       //output data
    output  wire                                                                dout_valid                  //valid signal of output data
	);
	 
	/*local reg for PE*/
    reg    signed           [WEIGHT_PRECISION-1:0]                              weight_buffer[MAX_KERNEL_NUMBER-1:0];
    reg    signed           [FEATURE_MAP_PRECISION-1:0]                         fm_buffer[MAX_KERNEL_NUMBER-1:0];
    reg    signed           [BIAS_PRECISION-1:0]                                bias_buffer;
    wire   signed           [PRECISION_ADDER-1:0]                               product[MAX_KERNEL_NUMBER-1:0];
	wire   signed           [PRECISION_ADDER*MAX_KERNEL_NUMBER-1:0]             acc_din;
	wire   signed           [31:0]                               acc_dout;
	reg                                                                         buffer_ready_flag[MAX_KERNEL_NUMBER-1:0];//buffer have data that is  ready for mul
	reg                                                                         dout_valid_r;

	/*Load din to first stage buffer*/
    genvar p;
    generate 
    for(p=0;p<MAX_KERNEL_NUMBER;p=p+1) begin:data_buffer_block
        always@(posedge clk or negedge rst_n) begin
            if( !rst_n ) begin
                weight_buffer[p] <= {WEIGHT_PRECISION{1'b0}};
                fm_buffer[p] <= {FEATURE_MAP_PRECISION{1'b0}};
                buffer_ready_flag[p] <= 1'b0;
            end else if(enable) begin
                buffer_ready_flag[p] <= enable;
                if(weight_updata_valid) begin
                    weight_buffer[p] <= din_weight[(p+1)*WEIGHT_PRECISION-1-:WEIGHT_PRECISION];
                end
                if(fm_updata_valid) begin
                    fm_buffer[p] <= din_fm[(p+1)*FEATURE_MAP_PRECISION-1-:FEATURE_MAP_PRECISION];
                end
            end
        end
    end
    endgenerate

    /*control the data of bias and wgap*/
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bias_buffer <= {BIAS_PRECISION{1'b0}};
        end else if (bias_or_not) begin
            bias_buffer <= din_bias;
        end else
            bias_buffer <= {BIAS_PRECISION{1'b0}};
    end


	/*Multiplication block*/
	generate
	for(p=0;p<MAX_KERNEL_NUMBER;p=p+1) begin:multiplier_block
        assign product[p] = weight_buffer[p]*fm_buffer[p];
        /*The multiplexer shields the accumulator from unwanted inputs*/
        assign acc_din[(p+1)*PRECISION_ADDER-1-:PRECISION_ADDER] = (buffer_ready_flag[p])?product[p]:{PRECISION_ADDER{1'b0}};
    end
	endgenerate

    /*16-input accumulator*/
    acc_16_adder # (
        .PRECISION_ADDER (PRECISION_ADDER)
    )acc_ins(
        .acc_din(acc_din),
        .acc_dout(acc_dout)
        );

    /*add bias*/
    assign dout = acc_dout + bias_buffer;
	/*Get dout_valid signel*/
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_valid_r <= 0;
        end else if (enable && fm_updata_valid) begin
            dout_valid_r <= 1;
        end else begin
            dout_valid_r <= 0;
        end
    end
    assign dout_valid = dout_valid_r;

endmodule