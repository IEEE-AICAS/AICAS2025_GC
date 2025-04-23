(* use_dsp = "yes" *)
module matmul#(
    parameter GS        = 64,
    parameter Q_WIDTH   = 8,
    parameter S_WIDTH   = 32,
    parameter I_DIM     = 128
)(
    input wire                      clk,
    input wire                      rst_n,
    input wire                      matmul_valid,
    input wire [GS*Q_WIDTH-1 : 0]   x_q_data,
    input wire [S_WIDTH-1 : 0]      x_s_data,
    input wire [GS*Q_WIDTH-1 : 0]   w_q_data,
    input wire [S_WIDTH-1 : 0]      w_s_data,
    input wire                      START,

    output reg                      DONE,
    output reg [S_WIDTH-1 : 0]      x_out_data,
    output wire                     matmul_ready
);
    //加法数结果位宽
    localparam ADDTREE_WIDTH = Q_WIDTH*2 + $clog2(GS);
    //状态机
    localparam  IDLE        = 0,
                LOAD_DATA   = 1,
                UPDATE_ACC  = 2,
                NEXT_GROUP  = 3,
                WIRE_OUT    = 4;
    
    //索引i->in_dim/gs
    reg [15:0]          i;
    reg [2:0]           state;
    //valid signal
    reg                         scale_valid;//2 scaling valid
    reg                         xw_valid;//int*int valid
    reg                         o_cache_valid;//every group MAC result
    reg [S_WIDTH-1:0]           o_cache;//cache add data
    reg [Q_WIDTH*2*GS-1:0]      xw_q_reg;

    wire [Q_WIDTH*2*GS-1:0]  xw_q_buf;
    wire [Q_WIDTH-1:0]  x_q_buf[0:GS-1];
    wire [Q_WIDTH-1:0]  w_q_buf[0:GS-1];
    //quant data buffer
    wire [ADDTREE_WIDTH-1:0] xw_sum;
    wire [S_WIDTH-1:0]       xw_sum_32;//convert to signed 32bit
    wire                     scale_mult_valid;//s*s data calid
    wire                     convert_valid;//int to float data valid
    wire                     dequant_mult_valid;//dequantize data valid
    wire                     acc_group_valid;//accumulate each group
    wire                     valid_signal;
    assign valid_signal = ~(scale_mult_valid | convert_valid
                            |dequant_mult_valid | acc_group_valid);
    assign matmul_ready = (state == LOAD_DATA);
    //ip core output
    wire [S_WIDTH-1:0]  int2float_out;
    wire [S_WIDTH-1:0]  scale_mult_out;
    wire [S_WIDTH-1:0]  dequant_mult_out;
    wire [S_WIDTH-1:0]  float_add_out;
    //divide quantized data
    generate
        genvar k1;
        for(k1 = 0; k1 < GS; k1 = k1 + 1) 
        begin: divide_q
            assign x_q_buf[k1] = x_q_data[k1*Q_WIDTH +: Q_WIDTH];
            assign w_q_buf[k1] = w_q_data[k1*Q_WIDTH +: Q_WIDTH];
        end
    endgenerate
    //x*w data ->16bit


    generate
        genvar k2;
        for(k2 = 0; k2 < GS; k2 = k2 + 1) 
        begin: mult_int
            assign xw_q_buf[Q_WIDTH*2*(k2+1)-1 -: Q_WIDTH*2]
            = ($signed(x_q_buf[k2])) * ($signed(w_q_buf[k2]));
        end
    endgenerate

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            xw_q_reg <= 'd0;
        end
        else begin
            xw_q_reg <= xw_q_buf;
        end
    end
    //accumulate ->22bit
    AdderTree #(
        .DATA_WIDTH(Q_WIDTH*2),
        .LENGTH(GS)
    ) uut (
        .in_addends(xw_q_reg),
        .out_sum(xw_sum)
    ); 
    //convert to 32bit int
    assign xw_sum_32 = xw_sum; 
    //flaot ip core usage
    //x, w scaling 相乘
    float_mult u_scale_mult (
        .aclk(clk),
        .aresetn(rst_n),
        .s_axis_a_tvalid(scale_valid),
        .s_axis_a_tdata(x_s_data),
        .s_axis_b_tvalid(scale_valid),
        .s_axis_b_tdata(w_s_data),
        .m_axis_result_tvalid(scale_mult_valid),
        .m_axis_result_tdata(scale_mult_out)
    );
    //int32 to float
    int_to_float u_int2float (
        .aclk(clk),
        .aresetn(rst_n),
        .s_axis_a_tvalid(xw_valid),
        .s_axis_a_tdata(xw_sum_32),
        .m_axis_result_tvalid(convert_valid),
        .m_axis_result_tdata(int2float_out)
    );
    //反量化
    float_mult u_dequant_mult (
        .aclk(clk),
        .aresetn(rst_n),
        .s_axis_a_tvalid(convert_valid),
        .s_axis_a_tdata(int2float_out),
        .s_axis_b_tvalid(scale_mult_valid),
        .s_axis_b_tdata(scale_mult_out),
        .m_axis_result_tvalid(dequant_mult_valid),
        .m_axis_result_tdata(dequant_mult_out)
    );
    //累加该Group结果
    float_add u_float_add (
        .aclk(clk),
        .aresetn(rst_n),
        .s_axis_a_tvalid(dequant_mult_valid),
        .s_axis_a_tdata(dequant_mult_out),
        .s_axis_b_tvalid(o_cache_valid),
        .s_axis_b_tdata(o_cache),
        .m_axis_result_tvalid(acc_group_valid),
        .m_axis_result_tdata(float_add_out)
    );


    //状态机block
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            DONE <= 1'b0;
            x_out_data <= 32'd0;
            i <= 16'd0;
            o_cache <= 0;
            state <= IDLE;
        end
        else begin
            case(state)
                IDLE: begin
                    DONE <= 1'b0;
                    if(START) begin
                        x_out_data <= 32'd0;
                        i <= 16'd0;
                        o_cache <= 0;
                        state <= LOAD_DATA;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                
                LOAD_DATA: begin
                    if(matmul_valid) begin
                        state <= UPDATE_ACC;
                    end
                    else begin
                        state <= LOAD_DATA;
                    end
                end
                UPDATE_ACC: begin
                    if(acc_group_valid) begin
                        o_cache <= float_add_out;
                        state <= NEXT_GROUP;
                    end 
                    else begin
                        state <= UPDATE_ACC;
                    end
                end

                NEXT_GROUP: begin
                    i <= i + 1;
                    if(i < I_DIM/GS-1) begin
                        state <= LOAD_DATA;
                    end
                    else begin
                        state <= WIRE_OUT;
                    end
                end

                WIRE_OUT : begin
                    i <= i + 1;
                    x_out_data <= o_cache;
                    DONE <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

    //valid 信号控制
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            scale_valid = 1'b0;
            xw_valid = 1'b0;
            o_cache_valid = 1'b0;
        end
        else if(state == UPDATE_ACC) begin
            if(matmul_valid) begin
                scale_valid = 1'b1;
                xw_valid = 1'b1;
                o_cache_valid = 1'b1;
            end
            else if(acc_group_valid)begin
                o_cache_valid = 1'b0;
                xw_valid = 1'b0;
                scale_valid = 1'b0;
            end
        end
        else begin
            scale_valid = 1'b0;
            xw_valid = 1'b0;
            o_cache_valid = 1'b0;
        end
    end



endmodule