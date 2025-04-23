
//可配置的buffer
module buffer #(
    parameter DATA_WIDTH = 64,    //  数据位宽
    parameter BUFFER_DEPTH = 64,  //  缓冲区的深度
    parameter ADDR_WIDTH = 64     //  地址位宽
    // parameter NUM_PORTS = 2 // 支持多端口//
)(
    input  wire                         clk,            
    input  wire                         rst,            
    input  wire                         wr_en ,          
    input  wire                         rd_en,          
    input  wire [DATA_WIDTH-1:0]        data_in ,        
    input  wire [ADDR_WIDTH-1:0]        rd_addr,     
    input  wire [ADDR_WIDTH-1:0]        wr_addr ,   
    // input  wire                         valid,
    output logic [DATA_WIDTH-1:0]        data_out,
    output logic                          valid_out
    // output reg                          ready           
);

    //  
    reg [DATA_WIDTH-1:0] buffer_mem [0:BUFFER_DEPTH-1]; //   用于存储数据的存储器，深度为 BUFFER_DEPTH，每个单元的数据宽度为 DATA_WIDTH。
    // wire internal_wr_en = wr_en & valid;
    reg [DATA_WIDTH-1:0] data_out_reg;

    // integer i;

    // 
    always @(posedge clk) begin
        // if (rst) begin
        //     ready <= 0;
            // for (i=0; i<BUFFER_DEPTH; i = i+1) begin
            //     buffer_mem[i] <= 0;
            // end
        // end else if (internal_wr_en) begin
        // end else 
            if (wr_en) begin
                buffer_mem[wr_addr] <= data_in;         //将 data_in 写入存储器中 wr_addr 指定的单元
            end
    end

    //  
    logic valid_out_reg;
    // assign data_out = (rd_en)? buffer_mem[rd_addr] : 0;     //当读数据使能信号为1，从mem中找到对应地址的数据读出
    always @(posedge clk) begin
        if (rd_en) begin
//            data_out_reg <= (wr_en && (wr_addr == rd_addr) )? data_in:buffer_mem[rd_addr];
            data_out_reg <= buffer_mem[rd_addr];
        end 
        valid_out <= rd_en;
        // else begin
        //     data_out_reg <= 0;
        // end
    end
    assign data_out = data_out_reg;  
       

endmodule

