`timescale 1ns / 1ps

module AdderTree(in_addends, out_sum);

parameter DATA_WIDTH = 1;
parameter LENGTH = 128;

localparam OUT_WIDTH = DATA_WIDTH + $clog2(LENGTH);
localparam LENGTH_A = LENGTH / 2;
localparam LENGTH_B = LENGTH - LENGTH_A;
localparam OUT_WIDTH_A = DATA_WIDTH + $clog2(LENGTH_A);
localparam OUT_WIDTH_B = DATA_WIDTH + $clog2(LENGTH_B);

input signed [DATA_WIDTH*LENGTH-1:0] in_addends;
output signed [OUT_WIDTH-1:0] out_sum;

generate
	if (LENGTH == 1) begin
		assign out_sum = in_addends;
	end else begin
		wire signed [OUT_WIDTH_A-1:0] sum_a;
		wire signed [OUT_WIDTH_B-1:0] sum_b;
		
		reg signed [DATA_WIDTH*LENGTH_A-1:0] addends_a;
		reg signed [DATA_WIDTH*LENGTH_B-1:0] addends_b;
		
		always@(*) begin
            addends_a = in_addends[DATA_WIDTH*LENGTH_A-1:0];
            addends_b = in_addends[DATA_WIDTH*LENGTH-1:DATA_WIDTH*LENGTH_A];
		end
		
		//divide set into two chunks, conquer
		AdderTree #(
			.DATA_WIDTH(DATA_WIDTH),
			.LENGTH(LENGTH_A)
		) subtree_a (
			.in_addends(addends_a),
			.out_sum(sum_a)
		);
		
		AdderTree #(
			.DATA_WIDTH(DATA_WIDTH),
			.LENGTH(LENGTH_B)
		) subtree_b (
			.in_addends(addends_b),
			.out_sum(sum_b)
		);
		
		assign out_sum = sum_a + sum_b;
	end
endgenerate

endmodule
