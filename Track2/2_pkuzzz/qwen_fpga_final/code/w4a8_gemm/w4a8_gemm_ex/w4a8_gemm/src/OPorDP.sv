`define USE_DP

module OPorDP #(
    parameter A_DATA_WIDTH = 8,      // 矩阵元素的位宽
    parameter B_DATA_WIDTH = 4,      // 矩阵元素的位宽
    parameter RESULT_WIDTH = 32,     // 结果矩阵元素的位宽
    parameter LATENCY = 8,
    parameter M = 8,                 // 矩阵 A 的行数 / 矩阵 C 的行数
    parameter N = 8,                 // 矩阵 B 的列数 / 矩阵 C 的列数
    parameter K = 8,                  // 矩阵 A 的列数 / 矩阵 B 的行数
    parameter B_K = 8
)(
    input wire clk,
    input wire rst,

    input wire [M*K*A_DATA_WIDTH-1:0] matrix_a_1d,    // activation 
    input wire [N*K*B_DATA_WIDTH-1:0] matrix_b_1d,    // weight
    input wire [M*N*RESULT_WIDTH-1:0] matrix_c_1d,  // accumulation

    input                             valid_i,
    input                             matrix_c_valid,
    output logic                      valid_o,

    output reg [M*N*RESULT_WIDTH-1:0] result_1d
);

    reg signed [A_DATA_WIDTH-1:0] matrix_a [0:M-1][0:K-1]; // M×K 矩阵 A
    reg signed [B_DATA_WIDTH-1:0] matrix_b [0:N-1][0:K-1]; // N×K 矩阵 B
    reg signed [RESULT_WIDTH-1:0] matrix_c [0:M-1][0:N-1]; // M×N 累加矩阵 C
    reg signed [RESULT_WIDTH-1:0] result [0:M-1][0:N-1];   // M×N 结果矩阵 C

    // reg signed [RESULT_WIDTH-1:0] partial_sum [0:M-1][0:N-1];   //部分和
    
    // (* use_dsp48 = "yes" *) reg signed [A_DATA_WIDTH+B_DATA_WIDTH-1+1:0] mul_result [0:M-1][0:N-1][0:K-1];    //乘积的中间结果
    reg signed [A_DATA_WIDTH+B_DATA_WIDTH-1:0] mul_result [0:M-1][0:N-1][0:K-1];    //乘积的中间结果

//    integer i, j, k;

    always_comb begin
        for (int i = 0; i < M; i = i + 1) begin
            for (int j = 0; j < K; j = j + 1) begin
                matrix_a[i][j] = matrix_a_1d[(i * K + j) * A_DATA_WIDTH +: A_DATA_WIDTH];
            end
        end
        for (int i = 0; i < N; i = i + 1) begin
            for (int j = 0; j < K; j = j + 1) begin
                matrix_b[i][j] = matrix_b_1d[(i * K + j) * B_DATA_WIDTH +: B_DATA_WIDTH];
            end
        end
        for (int i = 0; i < M; i = i + 1) begin
            for (int j = 0; j < N; j = j + 1) begin
                matrix_c[i][j] = matrix_c_1d[(i * N + j) * RESULT_WIDTH +: RESULT_WIDTH];
            end
        end
        for (int i = 0; i < M; i = i + 1) begin
            for (int j = 0; j < N; j = j + 1) begin
                result_1d[(i * N + j) * RESULT_WIDTH +: RESULT_WIDTH] = result[i][j];
            end
        end
    end

    logic [25:0] mul_result_combined [M-1:0][(N/2)-1:0][K-1:0];    //乘积的中间结果

 generate
    for(genvar i=0;i<M;i++) begin
        for(genvar j=0;j<N/2;j++) begin
            for(genvar k=0;k<K;k++) begin
                ip_scaler_dsp_v ip_scaler_dsp_v_inst (
                .CLK( clk                     ),  // input wire CLK
                .A  ( { matrix_b[2*j][k], 13'd0}          ),  // input  wire [16 : 0] A
                .B  ( matrix_a[i][k]                   ),  // input  wire [ 7 : 0] B
                .D  ( {{13{matrix_b[2*j+1][k][B_DATA_WIDTH-1]}}, matrix_b[2*j+1][k]} ),  // input  wire [16 : 0] D
                .P  ( mul_result_combined[i][j][k]   )   // output wire [25 : 0] P
            );
            end
        end
    end
endgenerate

    // always_ff @(posedge clk) begin
    always_comb begin
        for (int i = 0; i < M; i = i + 1) begin
            for (int j = 0; j < N/2; j = j + 1) begin
                for (int k = 0; k < K; k = k + 1) begin
                    mul_result[i][2*j]  [k] = {mul_result_combined[i][j][k][25],mul_result_combined[i][j][k][23:13]}+mul_result_combined[i][j][k][11];
                    mul_result[i][2*j+1][k] = mul_result_combined[i][j][k][11:0];
                end
            end
        end
    end
    
    reg signed [A_DATA_WIDTH+B_DATA_WIDTH-1:0] mul_result_gold [0:M-1][0:N-1][0:K-1];    //乘积的中间结果
    reg signed [A_DATA_WIDTH+B_DATA_WIDTH-1:0] mul_result_gold_pipe [0:M-1][0:N-1][0:K-1];

     always_ff @(posedge clk) begin
         for (int i = 0; i < M; i = i + 1) begin
             for (int j = 0; j < N; j = j + 1) begin
                 for (int k = 0; k < K; k = k + 1) begin
                     mul_result_gold[i][j][k] <= matrix_a[i][k] * matrix_b[j][k];
                     mul_result_gold_pipe[i][j][k] <= mul_result_gold[i][j][k];
                 end
             end
         end
     end

//    localparam LATENCY = $clog2(K) + 1+2+3;

    logic valid_pipe [LATENCY-1:0];

    always_ff @ (posedge clk) begin
        for(int i=1;i<LATENCY;i++) begin
            valid_pipe[i] <= valid_pipe[i-1];
        end
    end

    assign valid_pipe [0] = valid_i;

    logic signed [A_DATA_WIDTH+B_DATA_WIDTH+$clog2(K)-1:0] middle_sum     [M-1:0][N-1:0];
    logic signed [RESULT_WIDTH-1:0] middle_sum_reg [M-1:0][N-1:0];

    always_ff @ (posedge clk) begin
        for(int i=0;i<M;i++) begin
            for(int j=0;j<N;j++) begin
                if(matrix_c_valid) begin
                    middle_sum_reg [i][j] <= matrix_c [i][j] + middle_sum[i][j];
                end
                else begin
                    if(valid_pipe[LATENCY-1]) begin
                        middle_sum_reg [i][j] <= middle_sum_reg[i][j] + middle_sum[i][j];
                    end
                end
            end
        end
    end

    generate
        for(genvar i=0;i<M;i++) begin
            for(genvar j=0;j<N;j++) begin

                recursive_adder # (
                    .N(K),
                    .INPUT_WIDTH(A_DATA_WIDTH+B_DATA_WIDTH)
                ) adder_tree (
                    .clk(clk),
                    .inputs(mul_result[i][j]),
                    .final_sum(middle_sum[i][j])
                );

            end
        end
    endgenerate

    logic [$clog2(B_K)-1:0] reduction_counter;

    always_ff @ (posedge clk) begin
        if (rst) begin
            reduction_counter <= 0;
        end
        else begin
            if (valid_pipe[LATENCY-1]) begin
                reduction_counter <= reduction_counter + 1;
            end
        end
    end
    
    always_ff @ (posedge clk) begin
        for (int i=0;i<M;i++) begin
            for(int j=0;j<N;j++) begin
                result[i][j] <= middle_sum_reg [i][j] + middle_sum[i][j];
            end
        end
        valid_o <= ((|(~reduction_counter))==0)&&(valid_pipe[LATENCY-1]);
    end



endmodule // OPorDP