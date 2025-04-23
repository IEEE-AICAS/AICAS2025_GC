`timescale 1ns/1ps

module ram_param_core#(
    parameter DATA_WIDTH=512,
    parameter DATA_GROUP=7,
    parameter URAM_WIDTH=72,
    parameter URAM_DEPTH=4096,
    parameter URAM_NUM=56
)(
    input wire [$clog2(URAM_DEPTH)+$clog2(DATA_GROUP)+1:0] write_addr,
    input wire [DATA_WIDTH-1:0] write_data,
    input wire [DATA_WIDTH/8-1:0] write_mask,
    input wire [$clog2(URAM_DEPTH)+$clog2(DATA_GROUP)+1:0] read_addr,
    output wire [DATA_WIDTH/4-1:0] read_data,
    input wire clk,
    input wire rst,
    input wire write_en,
    input wire read_en,
    output wire read_valid
);

    wire [URAM_NUM*URAM_WIDTH-1:0] read_data_full;
    wire [DATA_WIDTH-1:0] read_data_512;
    wire [URAM_NUM-1:0] read_valid_uram;
    wire [$clog2(DATA_GROUP)-1:0] read_addr_msb_0;
    wire [$clog2(DATA_GROUP)-1:0] read_addr_msb;
    wire [1:0] read_addr_lsb_0;
    wire [1:0] read_addr_lsb;
    wire read_valid0;

    wire [URAM_NUM*URAM_WIDTH-1:0] write_data_full={DATA_GROUP{write_data}};
    wire [URAM_NUM*URAM_WIDTH/8-1:0] write_mask_full=
        {{(URAM_NUM*URAM_WIDTH/8-DATA_WIDTH/8){1'b0}}, write_mask}<<((DATA_WIDTH/8)*write_addr[$clog2(URAM_DEPTH)+$clog2(DATA_GROUP)+1:$clog2(URAM_DEPTH)+2]);
    wire [URAM_NUM*URAM_WIDTH/8-1:0] read_mask_full=
        {{(URAM_NUM*URAM_WIDTH/8-DATA_WIDTH/8){1'b0}}, {(DATA_WIDTH/8){1'b1}}}<<((DATA_WIDTH/8)*read_addr[$clog2(URAM_DEPTH)+$clog2(DATA_GROUP)+1:$clog2(URAM_DEPTH)+2]);
    assign read_data_512=read_data_full>>(DATA_WIDTH*read_addr_msb);
    assign read_data=
        read_addr_lsb=='h0 ? read_data_512[127:0] : 
        read_addr_lsb=='h1 ? read_data_512[255:128] :
        read_addr_lsb=='h2 ? read_data_512[383:256] :
        read_addr_lsb=='h3 ? read_data_512[511:384] : 0;
    assign read_valid=|read_valid_uram;

    gen_dff #(.WIDTH($clog2(DATA_GROUP))) u_read_addr_msb_0_dff(
        .d(read_addr[$clog2(URAM_DEPTH)+$clog2(DATA_GROUP)+1:$clog2(URAM_DEPTH)+2]),
        .q(read_addr_msb_0),
        .clk(clk),
        .rst(rst),
        .en(1)
    );

    gen_dff #(.WIDTH($clog2(DATA_GROUP))) u_read_addr_msb_dff(
        .d(read_addr_msb_0),
        .q(read_addr_msb),
        .clk(clk),
        .rst(rst),
        .en(1)
    );

    gen_dff #(.WIDTH(2)) u_read_addr_lsb_0_dff(
        .d(read_addr[1:0]),
        .q(read_addr_lsb_0),
        .clk(clk),
        .rst(rst),
        .en(1)
    );

    gen_dff #(.WIDTH(2)) u_read_addr_lsb_dff(
        .d(read_addr_lsb_0),
        .q(read_addr_lsb),
        .clk(clk),
        .rst(rst),
        .en(1)
    );

    

    genvar i;
    generate
        for(i=0; i<URAM_NUM; i=i+1) begin: loop_ram
            wire write_en_uram=
                write_en&(write_mask_full[URAM_WIDTH/8*(i+1)-1:URAM_WIDTH/8*i]);
            wire read_en_uram=
                read_en&(|read_mask_full[URAM_WIDTH/8*(i+1)-1:URAM_WIDTH/8*i]);
            wire read_valid0_uram;

            gen_dff #(.WIDTH(1)) u_read_valid0_dff(
                .d(read_en_uram),
                .q(read_valid0_uram),
                .clk(clk),
                .rst(rst),
                .en(1)
            );

            URAM288 #(
                .AUTO_SLEEP_LATENCY(8),            // Latency requirement to enter sleep mode
                .AVG_CONS_INACTIVE_CYCLES(10),     // Average consecutive inactive cycles when is SLEEP mode for power
                .BWE_MODE_A("PARITY_INDEPENDENT"), // Port A Byte write control
                .BWE_MODE_B("PARITY_INDEPENDENT"), // Port B Byte write control
                .CASCADE_ORDER_A("NONE"),          // Port A position in cascade chain
                .CASCADE_ORDER_B("NONE"),          // Port B position in cascade chain
                .EN_AUTO_SLEEP_MODE("FALSE"),      // Enable to automatically enter sleep mode
                .EN_ECC_RD_A("FALSE"),             // Port A ECC encoder
                .EN_ECC_RD_B("FALSE"),             // Port B ECC encoder
                .EN_ECC_WR_A("FALSE"),             // Port A ECC decoder
                .EN_ECC_WR_B("FALSE"),             // Port B ECC decoder
                .IREG_PRE_A("TRUE"),              // Optional Port A input pipeline registers
                .IREG_PRE_B("TRUE"),              // Optional Port B input pipeline registers
                .IS_CLK_INVERTED(1'b0),            // Optional inverter for read_addr_uramCLK
                .IS_EN_A_INVERTED(1'b0),           // Optional inverter for Port A enable
                .IS_EN_B_INVERTED(1'b0),           // Optional inverter for Port B enable
                .IS_RDB_WR_A_INVERTED(1'b0),       // Optional inverter for Port A read/write select
                .IS_RDB_WR_B_INVERTED(1'b0),       // Optional inverter for Port B read/write select
                .IS_RST_A_INVERTED(1'b0),          // Optional inverter for Port A reset
                .IS_RST_B_INVERTED(1'b0),          // Optional inverter for Port B reset
                .OREG_A("FALSE"),                  // Optional Port A output pipeline registers
                .OREG_B("FALSE"),                  // Optional Port B output pipeline registers
                .OREG_ECC_A("FALSE"),              // Port A ECC decoder output
                .OREG_ECC_B("FALSE"),              // Port B output ECC decoder
                .REG_CAS_A("FALSE"),               // Optional Port A cascade register
                .REG_CAS_B("FALSE"),               // Optional Port B cascade register
                .RST_MODE_A("ASYNC"),               // Port A reset mode
                .RST_MODE_B("ASYNC"),               // Port B reset mode
                .SELF_ADDR_A(12'h000),             // Port A self-address value
                .SELF_ADDR_B(12'h000),             // Port B self-address value
                .SELF_MASK_A(12'hfff),             // Port A self-address mask
                .SELF_MASK_B(12'hfff),             // Port B self-address mask
                .USE_EXT_CE_A("FALSE"),            // Enable Port A external CE inputs for output registers
                .USE_EXT_CE_B("FALSE")             // Enable Port B external CE inputs for output registers
            )
            u_uram_core (
                .CAS_OUT_ADDR_A(),         // 23-bit output: Port A cascade output address
                .CAS_OUT_ADDR_B(),         // 23-bit output: Port B cascade output address
                .CAS_OUT_BWE_A(),           // 9-bit output: Port A cascade Byte-write enable output
                .CAS_OUT_BWE_B(),           // 9-bit output: Port B cascade Byte-write enable output
                .CAS_OUT_DBITERR_A(),   // 1-bit output: Port A cascade double-bit error flag output
                .CAS_OUT_DBITERR_B(),   // 1-bit output: Port B cascade double-bit error flag output
                .CAS_OUT_DIN_A(),           // 72-bit output: Port A cascade output write mode data
                .CAS_OUT_DIN_B(),           // 72-bit output: Port B cascade output write mode data
                .CAS_OUT_DOUT_A(),         // 72-bit output: Port A cascade output read mode data
                .CAS_OUT_DOUT_B(),         // 72-bit output: Port B cascade output read mode data
                .CAS_OUT_EN_A(),             // 1-bit output: Port A cascade output enable
                .CAS_OUT_EN_B(),             // 1-bit output: Port B cascade output enable
                .CAS_OUT_RDACCESS_A(), // 1-bit output: Port A cascade read status output
                .CAS_OUT_RDACCESS_B(), // 1-bit output: Port B cascade read status output
                .CAS_OUT_RDB_WR_A(),     // 1-bit output: Port A cascade read/write select output
                .CAS_OUT_RDB_WR_B(),     // 1-bit output: Port B cascade read/write select output
                .CAS_OUT_SBITERR_A(),   // 1-bit output: Port A cascade single-bit error flag output
                .CAS_OUT_SBITERR_B(),   // 1-bit output: Port B cascade single-bit error flag output
                .DBITERR_A(),                   // 1-bit output: Port A double-bit error flag status
                .DBITERR_B(),                   // 1-bit output: Port B double-bit error flag status
                .DOUT_A(),                         // 72-bit output: Port A read data output
                .DOUT_B(read_data_full[URAM_WIDTH*(i+1)-1:URAM_WIDTH*i]),                         // 72-bit output: Port B read data output
                .RDACCESS_A(),                 // 1-bit output: Port A read status
                .RDACCESS_B(read_valid_uram[i]),                 // 1-bit output: Port B read status
                .SBITERR_A(),                   // 1-bit output: Port A single-bit error flag status
                .SBITERR_B(),                   // 1-bit output: Port B single-bit error flag status
                .ADDR_A(write_addr[$clog2(URAM_DEPTH)+1:2]),                         // 23-bit input: Port A address
                .ADDR_B(read_addr[$clog2(URAM_DEPTH)+1:2]),                         // 23-bit input: Port B address
                .BWE_A(write_mask_full[URAM_WIDTH/8*(i+1)-1:URAM_WIDTH/8*i]),   // 9-bit input: Port A Byte-write enable
                .BWE_B(0),                           // 9-bit input: Port B Byte-write enable
                .CAS_IN_ADDR_A(0),           // 23-bit input: Port A cascade input address
                .CAS_IN_ADDR_B(0),           // 23-bit input: Port B cascade input address
                .CAS_IN_BWE_A(0),             // 9-bit input: Port A cascade Byte-write enable input
                .CAS_IN_BWE_B(0),             // 9-bit input: Port B cascade Byte-write enable input
                .CAS_IN_DBITERR_A(0),     // 1- 72-bit input: Port B cascade input read mode data
                .CAS_IN_DBITERR_B(0),     // 1- 72-bit input: Port B cascade input read mode data
                .CAS_IN_EN_A(0),               // 1-bit input: Port A cascade enable input
                .CAS_IN_EN_B(0),               // 1-bit input: Port B cascade enable input
                .CAS_IN_DIN_A(0),           // 72-bit input: Port A cascade input write mode data
                .CAS_IN_DIN_B(0),           // 72-bit input: Port B cascade input write mode data
                .CAS_IN_DOUT_A(0),         // 72-bit input: Port A cascade input read mode data
                .CAS_IN_DOUT_B(0),         // 72-bit input: Port B cascade input read mode data
                .CAS_IN_RDACCESS_A(0),   // 1-bit input: Port A cascade read status input
                .CAS_IN_RDACCESS_B(0),   // 1-bit input: Port B cascade read status input
                .CAS_IN_RDB_WR_A(0),       // 1-bit input: Port A cascade read/write select input
                .CAS_IN_RDB_WR_B(0),       // 1-bit input: Port B cascade read/write select input
                .CAS_IN_SBITERR_A(0),     // 1-bit input: Port A cascade single-bit error flag input
                .CAS_IN_SBITERR_B(0),     // 1-bit input: Port B cascade single-bit error flag input
                .CLK(clk),                               // 1-bit input: Clock source
                .DIN_A(write_data_full[URAM_WIDTH*(i+1)-1:URAM_WIDTH*i]),                           // 72-bit input: Port A write data input
                .DIN_B(0),                           // 72-bit input: Port B write data input
                .EN_A(write_en_uram),                             // 1-bit input: Port A enable
                .EN_B(read_en_uram|read_valid0_uram),                             // 1-bit input: Port B enable
                .INJECT_DBITERR_A(0),     // 1-bit input: Port A double-bit error injection
                .INJECT_DBITERR_B(0),     // 1-bit input: Port B double-bit error injection
                .INJECT_SBITERR_A(0),     // 1-bit input: Port A single-bit error injection
                .INJECT_SBITERR_B(0),     // 1-bit input: Port B single-bit error injection
                .OREG_CE_A(1),                   // 1-bit input: Port A output register clock enable
                .OREG_CE_B(1),                   // 1-bit input: Port B output register clock enable
                .OREG_ECC_CE_A(0),           // 1-bit input: Port A ECC decoder output register clock enable
                .OREG_ECC_CE_B(0),           // 1-bit input: Port B ECC decoder output register clock enable
                .RDB_WR_A(1),                     // 1-bit input: Port A read/write select
                .RDB_WR_B(0),                     // 1-bit input: Port B read/write select
                .RST_A(rst),                           // 1-bit input: Port A asynchronous or synchronous reset for
                .RST_B(rst),                           // 1-bit input: Port B asynchronous or synchronous reset for
                .SLEEP(0)                             // 1-bit input: Dynamic power gating control
            );
        end
    endgenerate
endmodule