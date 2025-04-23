`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2025 04:14:45 PM
// Design Name: 
// Module Name: w4a8_controler
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

 typedef enum logic [1:0] {
        IDLE  = 2'b00,
        START = 2'b01,
        RUN   = 2'b10,
        STOP  = 2'b11
    } state_t;

module w4a8_controler # (
    parameter WEIGHT_BLOCK_SIZE     = 4096,
    parameter ACTIVATION_BLOCK_SIZE = 4096,
    parameter RESULT_BLOCK_SIZE     = 32*1024,
    parameter GEMM                  = 1

)(
    input ap_clk,
    input areset,

    input [31:0]    M              ,
    input [31:0]    N              ,
    input [31:0]    K              ,

    input [63:0]    axi00_ptr0         ,
    input [63:0]    axi01_ptr0         ,
    input [63:0]    axi02_ptr0         ,

    output logic [63:0]   addr_weight       ,
    output logic [63:0]   addr_activation   ,
    output logic [63:0]   addr_result       ,

    output logic [31:0]   op_code             ,

    input           ap_start            ,
    output logic          ap_done             ,

    input           block_done          ,
    output logic          block_start
    );



    logic [15:0] M_counter;
    logic [15:0] N_counter;
    logic [15:0] K_counter;

    logic [15:0] M_reg;
    logic [15:0] N_reg;
    logic [15:0] K_reg;

    logic [63:0] axi00_ptr0_reg;
    logic [63:0] axi01_ptr0_reg;
    logic [63:0] axi02_ptr0_reg;

    always_ff @ (posedge ap_clk) begin
        if(areset) begin
            M_reg           <= 0;
            N_reg           <= 0;
            K_reg           <= 0;
            axi00_ptr0_reg  <= 0;
            axi01_ptr0_reg  <= 0;
            axi02_ptr0_reg  <= 0;
        end
        else begin
            if(ap_start) begin
                M_reg           <= M;
                N_reg           <= N;
                K_reg           <= K;
                axi00_ptr0_reg  <= axi00_ptr0;
                axi01_ptr0_reg  <= axi01_ptr0;
                axi02_ptr0_reg  <= axi02_ptr0;
            end
        end
    end

    // logic working;

    // always_ff @ (posedge ap_clk) begin
    //     if(areset) begin
    //         working <= 0;
    //     end
    //     else
    //     begin
    //         if(ap_start) begin
    //             working <= 1;
    //         end
    //         else begin
    //             if(ap_done) begin
    //                 working <= 0;
    //             end
    //         end
    //     end
    // end

    state_t state;

    always_ff @ (posedge ap_clk) begin
        if(areset) begin
            state  <= IDLE;
        end
        else begin
            if(ap_start) begin
                state <= START;
            end
            else begin
                case(state)
                IDLE:begin
                    if(ap_start) begin
                        state <= START;
                    end
                end
                START:begin
                    state <= RUN;
                end
                RUN:begin
                    if((M_counter==M_reg-1)&&(N_counter==N_reg-1)&&(K_counter==K_reg-1)&&block_done) begin
                        state <= STOP;
                    end
                end
                STOP:begin
                    state <= IDLE;
                end
                default: begin
                    state <= state;
                end
                endcase
            end
        end
    end

    always_ff @ (posedge ap_clk) begin
        if(areset) begin
            M_counter   <= 0;
            N_counter   <= 0;
            K_counter   <= 0;
        end
        else begin
            if(ap_start) begin
                M_counter   <= 0;
                N_counter   <= 0;
                K_counter   <= 0;
            end
            else begin
                if(block_done) begin
                    K_counter <= (K_counter==K_reg-1) ? 0 :K_counter + 1;
                end

                if((K_counter==K_reg-1)&&block_done) begin
                    N_counter <= (N_counter==N_reg-1) ? 0 : N_counter + 1;
                end

                if((K_counter==K_reg-1)&&(N_counter==N_reg-1)&&block_done) begin
                    M_counter <= (M_counter==M_reg-1) ? 0 : M_counter + 1;
                end
            end
        end
    end
    
    logic block_start_;

    always_ff @ (posedge ap_clk) begin
        block_start_ <= (state==START)||((state==RUN)&&block_done&&!((M_counter==M_reg-1)&&(N_counter==N_reg-1)&&(K_counter==K_reg-1)));
        block_start  <= block_start_;
        addr_activation <= (M_counter*K_reg+K_counter)*ACTIVATION_BLOCK_SIZE + axi00_ptr0_reg;
        addr_weight     <= (N_counter*K_reg+K_counter)*WEIGHT_BLOCK_SIZE     + axi01_ptr0_reg;
        addr_result     <= (M_counter*N_reg+N_counter)*RESULT_BLOCK_SIZE     + axi02_ptr0_reg;
        op_code [31:16] <= 0;
        op_code [15:12] <= (K_counter==K_reg-1)? 1 : 0;
        op_code [11:8]  <= (K_counter==0)? 2 : 0;
        op_code [7:4]   <= 1;
        op_code [3:0]   <= (GEMM == 1) ? 0 : 1;
    end

//    always_comb begin
//        addr_activation = (M_counter*K_reg+K_counter)*ACTIVATION_BLOCK_SIZE + axi00_ptr0_reg;
//        addr_weight     = (N_counter*K_reg+K_counter)*WEIGHT_BLOCK_SIZE     + axi01_ptr0_reg;
//        addr_result     = (M_counter*N_reg+N_counter)*RESULT_BLOCK_SIZE     + axi02_ptr0_reg;
//    end

    assign ap_done = state == STOP;

//    always_comb begin
//        op_code [31:16] = 0;
//        op_code [15:12] = (K_counter==K_reg-1)? 1 : 0;
//        op_code [11:8]  = (K_counter==0)? 2 : 0;
//        op_code [7:4]   = 1;
//        op_code [3:0]   = (GEMM == 1) ? 0 : 1;
//    end





endmodule
