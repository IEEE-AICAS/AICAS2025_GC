typedef enum logic [2:0]{
        EMPTY            = 3'b000,
        LOAD            = 3'b001,
        STALL           = 3'b010,
        COMPUTE         = 3'b011,
        COMPUTE_DONE    = 3'b100,
        W_B             = 3'b101
    } state_2;

module double_buffer #(
    parameter DATA_WIDTH = 2048,    // 数据位宽
    parameter BUFFER_DEPTH = 16,  // 单个buffer深度
    parameter ADDR_WIDTH = 4      // 地址位宽（log2(BUFFER_DEPTH)）
)(
    input  wire                         clk,
    input  wire                         rst,
    input  wire                         wr_en,          // 写使能
    input  wire                         rd_en,          // 读使能
    input  wire                         buffer_sel_load,  // 新增缓冲区切换信号
    input  wire                         buffer_sel_comp,  // 计算缓冲区切换信号
    input  wire [DATA_WIDTH-1:0]        data_in,        // 输入数据
    input  wire [ADDR_WIDTH-1:0]        wr_addr,        // 写地址
    input  wire [ADDR_WIDTH-1:0]        rd_addr,        // 读地址
    
    output wire [DATA_WIDTH-1:0]        data_out,       // 输出数据
    output reg                          valid_out       // 数据有效标志
);

    //------------------------------------------
    // double buffer存储定义
    //------------------------------------------
    reg [DATA_WIDTH-1:0] buffer_mem [0:2*BUFFER_DEPTH-1]; // 双缓冲存储器
    // reg buffer_sel_load;                                    // buffer读的选择标志
    // reg buffer_sel_comp;                                    // buffer计算的选择标志 
    // reg buffer_sel_wb  ;                                    // buffer写回的选择标志
    reg [DATA_WIDTH-1:0] data_out_reg;

    //------------------------------------------
    // 写操作逻辑
    //------------------------------------------
    always @(posedge clk) begin
        if (wr_en) begin
            buffer_mem[{buffer_sel_load,wr_addr}] <= data_in; // 写入当前buffer
        end
    end

    //------------------------------------------
    // 读操作逻辑
    //------------------------------------------
    always @(posedge clk) begin
        if (rd_en) begin
            data_out_reg <= buffer_mem[{buffer_sel_comp,rd_addr}];
        end
        valid_out <= rd_en; // 输出有效标志
    end

    assign data_out = data_out_reg;

endmodule