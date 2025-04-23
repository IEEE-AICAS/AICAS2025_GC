module recursive_adder #(
    parameter N = 4,
    parameter LEVEL = $clog2(N),
    parameter INPUT_WIDTH = 8
    ) (
    input  logic clk,                     // 时钟信号
    input  logic signed [INPUT_WIDTH-1:0] inputs [N-1:0], // 有符号输入数组
    output logic signed [INPUT_WIDTH+LEVEL-1:0] final_sum       // 有符号最终和（增加1位防止溢出）
);

    // 内部信号
    logic signed [INPUT_WIDTH:0] intermediate_sum [N/2-1:0]; // 中间结果增加1位

    // 递归终止条件
    if (N == 1) begin
        always_ff @(posedge clk) begin
            final_sum <= inputs[0]; // 直接输出输入值
        end
    end
    // 递归逻辑
    else begin
        // 将相邻的两个数相加
        always_ff @(posedge clk) begin
            for (int i = 0; i < N/2; i++) begin
                intermediate_sum[i] <= inputs[2*i] + inputs[2*i+1]; // 有符号相加
            end
        end

        // 递归实例化
        recursive_adder #(.N(N/2), .INPUT_WIDTH(INPUT_WIDTH+1)) next_level (
            .clk(clk),
            .inputs(intermediate_sum),
            .final_sum(final_sum)
        );
    end

endmodule