module async_gemm # (
    parameter A_DATA_WIDTH = 8,      // ??A?????
    parameter B_DATA_WIDTH = 4,      // ??B?????
    parameter RESULT_WIDTH = 32,     // ?????????
    parameter M = 8,                 // ?? A ??? / ?? C ???
    parameter N = 8,                 // ?? B ??? / ?? C ???
    parameter K = 8,                 // ?? A ??? / ?? B ???
    parameter B_M = 8,               // ?? P ??? / ?? R ???
    parameter B_N = 16,               // ?? Q ??? / ?? R ???
    parameter B_K = 8,               // ?? P ??? / ?? Q ???
    parameter P_ADDR_WIDTH = $clog2(B_M*B_K), // ?? P ?????
    parameter Q_ADDR_WIDTH = $clog2(B_N*B_K), // ?? Q ?????
    parameter R_ADDR_WIDTH = $clog2(B_M*B_N)  // ?? R ?????
)(
    input wire clk,
    input wire rst,
    input wire kernel_clk,
    input wire kernel_rst,
    input wire last_start,
    input wire p_wr_en_in ,
    input wire q_wr_en_in  ,
    input wire r_wr_en_in ,      //c buffer????????
    input wire r_rd_en_in ,
    input wire [P_ADDR_WIDTH-1:0] p_addr_in ,
    input wire [Q_ADDR_WIDTH-1:0] q_addr_in ,
    input wire [R_ADDR_WIDTH-1:0] r_rd_addr_in ,
    input wire [R_ADDR_WIDTH-1:0] r_wr_addr_in ,
    input wire [M*K*A_DATA_WIDTH-1:0] matrix_a_in ,  // activation
    input wire [N*K*B_DATA_WIDTH-1:0] matrix_b_in ,  // weight
    input wire [M*N*RESULT_WIDTH-1:0] matrix_c_in ,  // accumulation

    output reg busy,
    output logic next_block,
    output reg [M*N*RESULT_WIDTH-1:0] matrix_c_out,
    output reg                        c_vaild_out
);

//        logic kernel_clk;

//        clk_wiz_0 clk_inst(
//            .clk_in1(clk),
//            .clk_out1(kernel_clk)
//        );

        logic [M*K*A_DATA_WIDTH + P_ADDR_WIDTH:0] matrix_a_slow_req;
        logic [M*K*A_DATA_WIDTH + P_ADDR_WIDTH:0] matrix_a_fast_req;
        logic [N*K*B_DATA_WIDTH + Q_ADDR_WIDTH:0] matrix_b_slow_req;
        logic [N*K*B_DATA_WIDTH + Q_ADDR_WIDTH:0] matrix_b_fast_req;
        logic [M*N*RESULT_WIDTH + 2*R_ADDR_WIDTH + 1:0] matrix_c_slow_req;
        logic [M*N*RESULT_WIDTH + 2*R_ADDR_WIDTH + 1:0] matrix_c_fast_req;

        logic matrix_a_req_cdc_valid_o;
        logic matrix_b_req_cdc_valid_o;
        logic matrix_c_req_cdc_valid_o;

        always_comb begin
            matrix_a_slow_req = {matrix_a_in,p_addr_in,p_wr_en_in};
            matrix_b_slow_req = {matrix_b_in,q_addr_in,q_wr_en_in};
            matrix_c_slow_req = {matrix_c_in,r_wr_addr_in,r_rd_addr_in,r_wr_en_in,r_rd_en_in};
        end

        async_fifo #(
            .DATA_DEPTH (8),                // 2^LOG_DEPTH = 2^2
            .DATA_WIDTH (M*K*A_DATA_WIDTH + P_ADDR_WIDTH + 1)
        ) matrix_a_req_cdc_fifo (
            // 写侧（源时钟域）
            .wr_data     (matrix_a_slow_req),           // 输入数据
            .wr_clk      (clk),                        // 源时钟
            .wr_rst_n    (!rst),                       // 源异步复位（低有效）
            .wr_en       (matrix_a_slow_req[0]),        // 写使能（沿用原valid信号）

            // 读侧（目的时钟域）
            .rd_clk      (kernel_clk),                 // 目的时钟
            .rd_rst_n    (!kernel_rst),                // 目的异步复位（低有效）
            .rd_en       (1'b1),                       // 持续接收数据
            .rd_data     (matrix_a_fast_req),           // 输出数据

            // 状态信号
            .fifo_full   (),                           // 可选的满信号（原未连接）
            .fifo_valid  (matrix_a_req_cdc_valid_o)     // 数据有效信号
        );

        // matrix_b_req_cdc_fifo 转换
        async_fifo #(
            .DATA_DEPTH (8),                // 2^LOG_DEPTH = 2^2 = 4
            .DATA_WIDTH (N*K*B_DATA_WIDTH + Q_ADDR_WIDTH + 1)
        ) matrix_b_req_cdc_fifo (
            // 写侧（源时钟域）
            .wr_data     (matrix_b_slow_req),           // 输入数据
            .wr_clk      (clk),                        // 源时钟
            .wr_rst_n    (!rst),                       // 源异步复位（低有效）
            .wr_en       (matrix_b_slow_req[0]),        // 写使能（组合信号）

            // 读侧（目的时钟域）
            .rd_clk      (kernel_clk),                 // 目的时钟
            .rd_rst_n    (!kernel_rst),                // 目的异步复位
            .rd_en       (1'b1),                       // 持续接收数据
            .rd_data     (matrix_b_fast_req),           // 输出数据

            // 状态信号
            .fifo_full   (),                           // 满信号（未连接）
            .fifo_valid  (matrix_b_req_cdc_valid_o)     // 有效信号
        );

        // matrix_c_req_cdc_fifo 转换
        async_fifo #(
            .DATA_DEPTH (B_M*B_N/2),                // 2^LOG_DEPTH = 2^2 = 4
            .DATA_WIDTH (M*N*RESULT_WIDTH + 2*R_ADDR_WIDTH + 2)
        ) matrix_c_req_cdc_fifo (
            // 写侧（源时钟域）
            .wr_data     (matrix_c_slow_req),           // 输入数据
            .wr_clk      (clk),                        // 源时钟
            .wr_rst_n    (!rst),                       // 源异步复位
            .wr_en       (matrix_c_slow_req[0] || matrix_c_slow_req[1]), // 组合有效信号

            // 读侧（目的时钟域）
            .rd_clk      (kernel_clk),                 // 目的时钟
            .rd_rst_n    (!kernel_rst),                // 目的异步复位
            .rd_en       (1'b1),                       // 持续接收数据
            .rd_data     (matrix_c_fast_req),           // 输出数据

            // 状态信号
            .fifo_full   (),                           // 满信号（未连接）
            .fifo_valid  (matrix_c_req_cdc_valid_o)     // 有效信号
        );

        logic start_fast;
        logic start_cdc_valid_o;

        async_fifo #(
        .DATA_DEPTH (4),                // 2^LOG_DEPTH = 2^2 = 4
        .DATA_WIDTH (1)
    ) start_cdc_fifo (
        // 写侧（源时钟域）
        .wr_data     (last_start),           // 输入数据
        .wr_clk      (clk),             // 源时钟
        .wr_rst_n    (!rst),            // 源异步复位（低有效）
        .wr_en       (last_start),           // 写使能（与数据相同）

        // 读侧（目的时钟域）
        .rd_clk      (kernel_clk),      // 目的时钟
        .rd_rst_n    (!kernel_rst),     // 目的异步复位
        .rd_en       (1'b1),            // 持续接收数据
        .rd_data     (start_fast),      // 输出数据

        // 状态信号
        .fifo_full   (),                // 满信号（未连接）
        .fifo_valid  (start_cdc_valid_o) // 有效信号
    );

        logic p_wr_en_fast_in;
        logic q_wr_en_fast_in;
        logic r_wr_en_fast_in;
        logic r_rd_en_fast_in;
        logic start_fast_reg ;
        logic [M*K*A_DATA_WIDTH + P_ADDR_WIDTH:0]       matrix_a_fast_req_reg;
        logic [N*K*B_DATA_WIDTH + Q_ADDR_WIDTH:0]       matrix_b_fast_req_reg;
        logic [M*N*RESULT_WIDTH + 2*R_ADDR_WIDTH+1:0]       matrix_c_fast_req_reg;
//        logic [R_ADDR_WIDTH : 0                 ]       matrix_c_fast_rd_req

        always_ff @ (posedge kernel_clk) begin
            if(kernel_rst) begin
                p_wr_en_fast_in <= 0;
                q_wr_en_fast_in <= 0;
                r_wr_en_fast_in <= 0;
                r_rd_en_fast_in <= 0;
                start_fast_reg  <= 0;
                matrix_a_fast_req_reg <= 0;
                matrix_b_fast_req_reg <= 0;
                matrix_c_fast_req_reg <= 0;
            end
            else begin
                p_wr_en_fast_in <= matrix_a_req_cdc_valid_o && matrix_a_fast_req[0];
                q_wr_en_fast_in <= matrix_b_req_cdc_valid_o && matrix_b_fast_req[0];
                r_wr_en_fast_in <= matrix_c_req_cdc_valid_o && matrix_c_fast_req[1];
                r_rd_en_fast_in <= matrix_c_req_cdc_valid_o && matrix_c_fast_req[0];
                start_fast_reg  <= start_cdc_valid_o        && start_fast          ;
                matrix_a_fast_req_reg <= matrix_a_fast_req;
                matrix_b_fast_req_reg <= matrix_b_fast_req;
                matrix_c_fast_req_reg <= matrix_c_fast_req;
            end
        end

        logic next_block_fast;
        logic next_block_slow;

        gemm # (
        .M                 (M                 ),
        .N                 (N                 ),
        .K                 (K                 ),
        .B_M               (B_M               ),
        .B_N               (B_N               ),
        .B_K               (B_K               ),
        .A_DATA_WIDTH      (A_DATA_WIDTH),
        .B_DATA_WIDTH      (B_DATA_WIDTH),
        .RESULT_WIDTH      (RESULT_WIDTH      )
        )  gemm_inst (
        .clk         (kernel_clk       ),                            
        .rst         (kernel_rst       ),                            
        .last_start       (start_fast_reg    ),                            
        .p_wr_en_in  (p_wr_en_fast_in),                            
        .q_wr_en_in  (q_wr_en_fast_in),                            
        .r_wr_en_in  (r_wr_en_fast_in),                            
        .r_rd_en_in  (r_rd_en_fast_in ),                            
        .p_addr_in   (matrix_a_fast_req_reg[P_ADDR_WIDTH:1] ),         
        .q_addr_in   (matrix_b_fast_req_reg[Q_ADDR_WIDTH:1] ),         
        .r_rd_addr_in(matrix_c_fast_req_reg[R_ADDR_WIDTH+1:2] ),         
        .r_wr_addr_in(matrix_c_fast_req_reg[2*R_ADDR_WIDTH+1:R_ADDR_WIDTH+2]  ),         
        .matrix_a_in (matrix_a_fast_req_reg[M*K*A_DATA_WIDTH+P_ADDR_WIDTH:P_ADDR_WIDTH+1] ),
        .matrix_b_in (matrix_b_fast_req_reg[N*K*B_DATA_WIDTH+Q_ADDR_WIDTH:Q_ADDR_WIDTH+1] ),
        .matrix_c_in (matrix_c_fast_req_reg[M*N*RESULT_WIDTH+2*R_ADDR_WIDTH+1:2*R_ADDR_WIDTH+2] ),     

        .busy        (busy_fast         ),                   
        .next_block  (next_block_fast),         
        .matrix_c_out(matrix_c_fast_rsp[M*N*RESULT_WIDTH:1]          )     ,
        .c_vaild_out (matrix_c_fast_rsp[0] )
        );

        logic busy_slow;
        logic busy_cdc_valid_o;
        logic [M*N*RESULT_WIDTH:0] matrix_c_fast_rsp;
        logic [M*N*RESULT_WIDTH:0] matrix_c_slow_rsp;
        logic                      matrix_c_rsp_cdc_valid_o;
        
        logic [31:0] wr_cnt;
        logic [31:0] rd_cnt;
        logic rsp_fifo_full;
        
        always_ff @ (posedge kernel_clk) begin
            if(kernel_rst) begin
                wr_cnt <= 0;
            end
            else begin
                wr_cnt <= wr_cnt +( matrix_c_fast_rsp[0] && !rsp_fifo_full);
            end
        end

        async_fifo #(
            .DATA_DEPTH (B_M*B_N/2),                // 2^LOG_DEPTH = 2^2 = 4
            .DATA_WIDTH (M*N*RESULT_WIDTH + 1)
        ) matrix_c_rsp_cdc_fifo (
            // 写侧（源时钟域）
            .wr_data     (matrix_c_fast_rsp),           // 输入数据
            .wr_clk      (kernel_clk),                 // 源时钟
            .wr_rst_n    (!kernel_rst),                // 源异步复位（低有效）
            .wr_en       (matrix_c_fast_rsp[0]),        // 写使能（组合信号）

            // 读侧（目的时钟域）
            .rd_clk      (clk),                        // 目的时钟
            .rd_rst_n    (!rst),                       // 目的异步复位
            .rd_en       (1'b1),                       // 持续接收数据
            .rd_data     (matrix_c_slow_rsp),           // 输出数据

            // 状态信号
            .fifo_full   (rsp_fifo_full),                           // 满信号（未连接）
            .fifo_valid  (matrix_c_rsp_cdc_valid_o)     // 有效信号
        );
        
        logic not_busy_pulse;
        logic busy_fast_reg;
        
        always_ff @ (posedge kernel_clk) begin
            busy_fast_reg <= busy_fast;
        end
        
        assign not_busy_pulse = busy_fast_reg && !busy_fast;

        async_fifo #(
            .DATA_DEPTH (4),                // 2^LOG_DEPTH = 2^2 = 4
            .DATA_WIDTH (1)
        ) busy_cdc_fifo (
            // 写侧（源时钟域）
            .wr_data     (not_busy_pulse),       // 输入数据
            .wr_clk      (kernel_clk),      // 源时钟
            .wr_rst_n    (!kernel_rst),     // 源异步复位（低有效）
            .wr_en       (not_busy_pulse),       // 写使能（与数据相同）

            // 读侧（目的时钟域）
            .rd_clk      (clk),             // 目的时钟
            .rd_rst_n    (!rst),            // 目的异步复位
            .rd_en       (1'b1),            // 持续接收数据
            .rd_data     (busy_slow),       // 输出数据

            // 状态信号
            .fifo_full   (),                // 满信号（未连接）
            .fifo_valid  (busy_cdc_valid_o)  // 有效信号
        );

        logic next_block_pulse;
        logic next_block_fast_reg;
        logic next_block_cdc_valid_o;

        always_ff @ (posedge kernel_clk) begin
            next_block_fast_reg <= next_block_fast;
        end

        assign next_block_pulse = !next_block_fast_reg&&next_block_fast;

        async_fifo #(
            .DATA_DEPTH (4),                // 2^LOG_DEPTH = 2^2 = 4
            .DATA_WIDTH (1)
        ) next_block_cdc_fifo (
            // 写侧（源时钟域）
            .wr_data     (next_block_pulse),       // 输入数据
            .wr_clk      (kernel_clk),      // 源时钟
            .wr_rst_n    (!kernel_rst),     // 源异步复位（低有效）
            .wr_en       (next_block_pulse),       // 写使能（与数据相同）

            // 读侧（目的时钟域）
            .rd_clk      (clk),             // 目的时钟
            .rd_rst_n    (!rst),            // 目的异步复位
            .rd_en       (1'b1),            // 持续接收数据
            .rd_data     (next_block_slow),       // 输出数据

            // 状态信号
            .fifo_full   (),                // 满信号（未连接）
            .fifo_valid  (next_block_cdc_valid_o)  // 有效信号
        );

        always_ff @ (posedge clk) begin
            if(rst) begin
                matrix_c_out <= 0;
                c_vaild_out <= 0;
                busy        <= 0;
                next_block  <= 0;
            end
            else begin
                matrix_c_out <= matrix_c_slow_rsp [M*N*RESULT_WIDTH:1];
                c_vaild_out  <= matrix_c_rsp_cdc_valid_o && matrix_c_slow_rsp[0];
                busy         <= busy_cdc_valid_o && busy_slow;
                next_block   <= next_block_cdc_valid_o && next_block_slow;
            end
        end

endmodule