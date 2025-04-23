`timescale 1ns/1ps

module ram_asup_core #(
    parameter WIDTH=512,
    parameter DEPTH=512
)(
    input wire [$clog2(DEPTH)-1:0] write_addr1,
    input wire [WIDTH-1:0] write_data1,
    input wire [WIDTH/8-1:0] write_mask1,
    input wire [$clog2(DEPTH)-1:0] read_addr1,
    output wire [WIDTH-1:0] read_data1,
    input wire [$clog2(DEPTH)-1:0] read_addr2,
    output wire [WIDTH-1:0] read_data2,
    input wire clk,
    input wire rst,
    input wire write_en1,
    input wire read_en1,
    input wire read_en2,
    output wire read_valid1,
    output wire read_valid2
);

    wire read_valid1_0;
    wire read_valid2_0;
    wire [WIDTH-1:0] read_data_bram;

    assign read_data1=read_data_bram;
    assign read_data2=read_data_bram;


    blk_mem_gen_asup u_core(
        .clka(clk),
        .ena(write_en1),
        .wea(write_mask1),
        .addra(write_addr1),
        .dina(write_data1),
        .clkb(clk),
        .enb(read_en1|read_valid1_0|read_en2|read_valid2_0),
        .addrb(read_en1 ? read_addr1 : read_addr2),
        .doutb(read_data_bram)
    );
    



    gen_dff #(.WIDTH(1)) u_read_valid1_0_reg(
        .d(read_en1),
        .q(read_valid1_0),
        .clk(clk),
        .rst(rst),
        .en(1)
    );
    gen_dff #(.WIDTH(1)) u_read_valid1_reg(
        .d(read_valid1_0),
        .q(read_valid1),
        .clk(clk),
        .rst(rst),
        .en(1)
    );

    gen_dff #(.WIDTH(1)) u_read_valid2_0_reg(
        .d(read_en2),
        .q(read_valid2_0),
        .clk(clk),
        .rst(rst),
        .en(1)
    );
    gen_dff #(.WIDTH(1)) u_read_valid2_reg(
        .d(read_valid2_0),
        .q(read_valid2),
        .clk(clk),
        .rst(rst),
        .en(1)
    );


endmodule

