`timescale 1ns/1ps

module Top_tb;
    reg clk;
    reg rst;
    reg [319:0] fromCPU_data;
    reg fromCPU_valid;
    wire fromCPU_ready;
    wire [191:0] toCPU_data;
    wire toCPU_valid;
    reg toCPU_ready;
    wire [19:0] fromDDR_addr;
    reg [19:0] fromDDR_addr_bypass;
    reg [19:0] fromDDR_addr_psup;
    reg [19:0] fromDDR_addr_asup;
    reg [19:0] fromDDR_addr_param;
    wire [511:0] fromDDR_data;
    wire [511:0] fromDDR_data_bypass;
    reg [511:0] fromDDR_data_psup;
    reg [511:0] fromDDR_data_asup;
    reg [511:0] fromDDR_data_param;
    reg [7:0] fromDDR_sel;
    reg fromDDR_valid;
    reg [19:0] toDDR_addr;
    wire [511:0] toDDR_data;
    reg toDDR_valid;
    wire toDDR_rsp_valid;

    Top uut(
        .clock(clk),
        .io_clk(clk),
        .reset(rst),
        .io_rst(rst),
        .io_ddr_addr({8'he0, (fromDDR_valid ? fromDDR_addr : toDDR_addr), 4'h0}),
        .io_ddr_dataWrite(fromDDR_data),
        .io_ddr_dataRead(toDDR_data),
        .io_ddr_en(toDDR_valid|fromDDR_valid),
        .io_ddr_writeEn({64{fromDDR_valid}}),
        .io_fromCPU_bits(fromCPU_data),
        .io_fromCPU_valid(fromCPU_valid),
        .io_fromCPU_ready(fromCPU_ready),
        .io_toCPU_bits(toCPU_data),
        .io_toCPU_valid(toCPU_valid),
        .io_toCPU_ready(toCPU_ready)
    );
    
    initial fork 
        clk=1;
        rst=0;
        #200 fromDDR_sel=1;
        #200 fromDDR_addr_bypass=20'h1fffc;
        // #200 fromDDR_data_bypass={64{32'h48444038}};
        // #200 fromDDR_data_bypass={{64{8'h48}}, {64{8'h44}}, {64{8'h40}}, {64{8'h38}}};
        // #200 fromDDR_data_bypass={{64{8'h48}}, {64{8'h44}}, {64{8'h40}}, {64{8'h38}}};
        #200 fromDDR_valid=1;
        #200 toCPU_ready=1;
        #15 rst=1;
        #100 rst=0;
        #100 toDDR_addr=20'h0;
        #100 toDDR_valid=0;
        #27080 fromDDR_sel=2;
        #27080 fromDDR_addr_psup=20'h41ff8;
        #27080 fromDDR_data_psup={16{32'h3c003c00}};
        #27580 fromDDR_sel=3;
        #27580 fromDDR_addr_asup=20'h45ffc;
        #27580 fromDDR_data_asup={16{32'h48004800}};
        #28080 fromDDR_sel=4;
        #28080 fromDDR_addr_param=20'h4fffc;
        #28080 fromDDR_data_param={16{32'he2e2e2e2}};
        // fromCPU_data=320'h00000075_30004300_45002000_46004400_30005000_01000100_01000080_00020002_00400002_00000000;
        #47780 fromCPU_data=320'h00ff0247_70004000_00000000_30002000_00000000_00000e00_00800040_00020002_000e0040_00000000;
        #47780 fromCPU_valid=1;
        // #47790 fromCPU_data=320'h00ee0411_47000000_46004200_40000000_30005000_00000000_07000380_0001001c_000e0040_00000000;
        // #47800 fromCPU_data=320'h00dd000b_47000000_46004200_38004000_30005000_00000e00_07000380_0001001c_000e0040_00000000;
        // #47810 fromCPU_data=320'h00cc0047_47004400_46004200_30002000_38005000_00000e00_07000380_0001001c_000e0040_00000000;

        #47790 fromCPU_data=320'h00ee0863_70004000_60002000_22a00000_30005000_01000000_07000380_00020004_000e0040_00000000;
        #47800 fromCPU_data=320'h00dd0083_00004000_60002000_32a00000_30005000_00000000_07000380_00020004_000e0040_00000000;
        #47810 fromCPU_data=320'h00cc00e3_70004000_60002000_30000000_30005000_01000000_07000380_00020004_000e0040_00000000;
        #47820 fromCPU_data=320'h00bb0123_70000000_60002000_40800000_300022a0_00000000_00800040_00010006_000e0040_00000000;
        #47830 fromCPU_data=320'h00aa0103_70000000_60002000_30000000_408032a0_00000000_018000c0_00010002_000e0040_00000000;
        #47840 fromCPU_valid=0;
        #140000 fromDDR_valid=0;
        #150000 toDDR_addr=20'h20000;
        #150000 toDDR_valid=1;
    join
    
    always #5 clk=~clk;
    always #10 fromDDR_addr_bypass<=fromDDR_addr_bypass+'h4;
    always #10 fromDDR_addr_psup<=fromDDR_addr_psup+'h4;
    always #10 fromDDR_addr_asup<=fromDDR_addr_asup+'h4;
    always #10 fromDDR_addr_param<=fromDDR_addr_param+'h4;
    always #10 toDDR_addr<=toDDR_addr+'h4;
    // always #10 fromDDR_data_bypass<={fromDDR_data_bypass[2039:0], fromDDR_data_bypass[2047:2040]};

    assign fromDDR_addr=
        fromDDR_sel=='h1 ? fromDDR_addr_bypass : 
        fromDDR_sel=='h2 ? fromDDR_addr_psup :
        fromDDR_sel=='h3 ? fromDDR_addr_asup : 
        fromDDR_sel=='h4 ? fromDDR_addr_param : 0;
    assign fromDDR_data=
        fromDDR_sel=='h1 ? fromDDR_data_bypass[511:0] : 
        fromDDR_sel=='h2 ? fromDDR_data_psup : 
        fromDDR_sel=='h3 ? fromDDR_data_asup : 
        fromDDR_sel=='h4 ? fromDDR_data_param : 0; 

    assign fromDDR_data_bypass=
        fromDDR_addr[3:2]=='h3 ? {32{16'h4400}} :
        fromDDR_addr[3:2]=='h2 ? {32{16'h4200}} : 
        fromDDR_addr[3:2]=='h1 ? {32{16'h4000}} : {32{16'h3c00}};
endmodule