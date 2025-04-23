`timescale 1ns / 1ps

module tb_ip_scaler_dsp_v;

    // Parameters
    parameter M = 2;  // Example value for M
    parameter N = 4;  // Example value for N
    parameter K = 8;  // Example value for K
    parameter B_DATA_WIDTH = 4;  // Example value for B_DATA_WIDTH

    // Clock and reset signals
    reg clk;
    reg reset;

    // Testbench signals
    reg signed [7:0] matrix_a [0:M-1][0:K-1];          // Signed matrix_a
    reg signed [B_DATA_WIDTH-1:0] matrix_b [0:N-1][0:K-1]; // Signed matrix_b
    wire signed [25:0] mul_result_combined [0:M-1][0:(N/2)-1][0:K-1]; // Signed result from DSP
    logic signed [11:0] real_result[0:M-1][0:N-1][0:K-1];
    reg signed [11:0] expected_result [0:M-1][0:(N)-1][0:K-1];      // Expected result

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock
    end

    // Reset generation
    initial begin
        reset = 1;
        #20 reset = 0;
    end

    // Test stimulus
    initial begin
        // Initialize matrices with some signed values
        for (int i = 0; i < M; i++) begin
            for (int k = 0; k < K; k++) begin
                matrix_a[i][k] = $random;  // Random signed values
            end
        end

        for (int j = 0; j < N; j++) begin
            for (int k = 0; k < K; k++) begin
                matrix_b[j][k] = $random;  // Random signed values
            end
        end

        // Wait for a few clock cycles
        #1000;

        // Calculate expected results
        for (int i = 0; i < M; i++) begin
            for (int j = 0; j < N; j++) begin
                for (int k = 0; k < K; k++) begin
                    // Expected result: A * B + D
                    expected_result[i][j][k] = matrix_a[i][k]*matrix_b[j][k];
                        
                end
            end
        end

        // Display and compare results
        for (int i = 0; i < M; i++) begin
            for (int j = 0; j < N; j++) begin
                for (int k = 0; k < K; k++) begin
                    if (expected_result[i][j][k]!=real_result[i][j][k]) begin
                        $display("ERROR: Mismatch at [%0d][%0d][%0d]", i, j, k);
                    end else begin
//                        $display("PASS: Match at [%0d][%0d][%0d]", i, j, k);
                    end
                    
                end
            end
        end



        // Finish simulation
//        $finish;
    end
always_comb begin
    for (int i = 0; i < M; i++) begin
            for (int j = 0; j < N/2; j++) begin
                for (int k = 0; k < K; k++) begin
                    real_result[i][2*j][k] = {mul_result_combined[i][j][k][25],mul_result_combined[i][j][k][23:13]}+mul_result_combined[i][j][k][11];
                    real_result[i][2*j+1][k] = mul_result_combined[i][j][k][11:0];
                 end
             end
         end
end
    // Instantiate the DSP module
    generate
        for(genvar i=0; i<M; i++) begin : gen_i
            for(genvar j=0; j<N/2; j++) begin : gen_j
                for(genvar k=0; k<K; k++) begin : gen_k
                    ip_scaler_dsp_v ip_scaler_dsp_v_inst (
                        .CLK(clk),
                        .A({matrix_b[2*j][k], 13'd0}),  // Signed concatenation
                        .B(matrix_a[i][k]),              // Signed input
                        .D({{13{matrix_b[2*j+1][k][B_DATA_WIDTH-1]}}, matrix_b[2*j+1][k]}), // Signed extension
                        .P(mul_result_combined[i][j][k]) // Signed output
                    );
                end
            end
        end
    endgenerate

endmodule