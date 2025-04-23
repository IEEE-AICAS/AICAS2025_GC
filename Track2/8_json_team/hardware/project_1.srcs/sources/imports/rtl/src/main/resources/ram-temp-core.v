`timescale 1ns/1ps

module ram_temp_core #(
    parameter WIDTH=512,
    parameter DEPTH=1024
)(
    input wire [$clog2(DEPTH)-1:0] write_addr,
    input wire [WIDTH-1:0] write_data,
    input wire [$clog2(DEPTH)-1:0] read_addr,
    output wire [WIDTH-1:0] read_data,
    input wire clk,
    input wire rst,
    input wire read_en,
    input wire write_en,
    output wire read_valid
);

    wire read_valid_0;

    blk_mem_gen_temp u_core(
        .clka(clk),
        .ena(write_en),
        .wea(write_en),
        .addra(write_addr),
        .dina(write_data),
        .clkb(clk),
        .enb(read_en|read_valid_0),
        .addrb(read_addr),
        .doutb(read_data)
    ); 
    
    gen_dff #(.WIDTH(1)) u_read_valid_0_dff(
        .d(read_en),
        .q(read_valid_0),
        .clk(clk),
        .rst(rst),
        .en(1)
    );

    gen_dff #(.WIDTH(1)) u_read_valid_dff(
        .d(read_valid_0),
        .q(read_valid),
        .clk(clk),
        .rst(rst),
        .en(1)
    );
endmodule

