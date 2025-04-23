`define DP //??????

typedef enum logic [1:0] {
        WAIT  = 2'b0,
        WORK = 2'b1,
        WRITE_BACK = 2'b10
    } state_1;


module gemm_muti #(
    parameter A_DATA_WIDTH = 8,      // ??A?????
    parameter B_DATA_WIDTH = 4,      // ??B?????
    parameter RESULT_WIDTH = 32,     // ?????????
    parameter WEIGHT_PORT = 1,
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
    input wire start,
    input wire p_wr_en_in ,
    input wire q_wr_en_in [WEIGHT_PORT-1:0] ,
    input wire r_wr_en_in ,      //c buffer????????
    input wire r_rd_en_in ,
    input wire [P_ADDR_WIDTH-1:0] p_addr_in ,
    input wire [Q_ADDR_WIDTH-1:0] q_addr_in [WEIGHT_PORT-1:0],
    input wire [R_ADDR_WIDTH-1:0] r_rd_addr_in ,
    input wire [R_ADDR_WIDTH-1:0] r_wr_addr_in ,
    input wire [M*K*A_DATA_WIDTH-1:0] matrix_a_in ,  // activation
    input wire [N*K*B_DATA_WIDTH-1:0] matrix_b_in [WEIGHT_PORT-1:0] ,  // weight
    input wire [M*N*RESULT_WIDTH-1:0] matrix_c_in ,  // accumulation

    output reg busy,
    output reg [M*N*RESULT_WIDTH-1:0] matrix_c_out,
    output reg                        c_vaild_out
);
    reg  p_rd_en;
    reg  q_rd_en;
    reg  r_rd_en;
//    reg  r_rd_en_reg;
    wire [P_ADDR_WIDTH-1:0] p_rd_addr;
    wire [Q_ADDR_WIDTH-1:0] q_rd_addr;
    wire [R_ADDR_WIDTH-1:0] r_rd_addr;
//    reg  [R_ADDR_WIDTH-1:0] r_rd_addr_reg;
    reg  r_wr_en;   //c buffer????????
    reg  r_wr_en_reg_0;
    reg  r_wr_en_reg_1;
    wire [R_ADDR_WIDTH-1:0] r_wr_addr;
    reg  [R_ADDR_WIDTH-1:0] r_wr_addr_reg_0;
    reg  [R_ADDR_WIDTH-1:0] r_wr_addr_reg_1;
    wire [M*K*A_DATA_WIDTH-1:0] matrix_a;
    wire [N*K*B_DATA_WIDTH-1:0] matrix_b;
    wire [M*N*RESULT_WIDTH-1:0] matrix_c;
    wire c_valid;

    logic a_valid;
    logic b_valid;

    buffer #(
        .DATA_WIDTH(M*K*A_DATA_WIDTH),
        .BUFFER_DEPTH(B_M*B_K),
        .ADDR_WIDTH(P_ADDR_WIDTH)
    ) p_buffer(
        .clk(clk),
        .rst(rst),
        .wr_en( p_wr_en_in),
        .rd_en(p_rd_en),
        .data_in(matrix_a_in),
        .rd_addr(p_rd_addr),
        .wr_addr(p_addr_in),
        .data_out(matrix_a),
        .valid_out(a_valid)
    );

    buffer_muti #(
        .DATA_WIDTH(N*K*B_DATA_WIDTH),
        .BUFFER_DEPTH(B_N*B_K),
        .WRITE_PORT(WEIGHT_PORT),
        .ADDR_WIDTH(Q_ADDR_WIDTH)
    ) q_buffer(
        .clk(clk),
        .rst(rst),
        .wr_en( q_wr_en_in),
        .rd_en(q_rd_en),
        .data_in(matrix_b_in),
        .rd_addr(q_rd_addr),
        .wr_addr(q_addr_in),
        .data_out(matrix_b),
        .valid_out(b_valid)
    );
    
//    logic r_wr_en ;
//    logic r_rd_en ;
//    logic [M*N*RESULT_WIDTH-1:0] data_in;
//    logic [R_ADDR_WIDTH-1:0] rd_addr;
//    logic [R_ADDR_WIDTH-1:0] wr_addr;
    
//    always_comb begin
//    r_wr_en = 
//    end
    
    buffer #(
        .DATA_WIDTH(M*N*RESULT_WIDTH),
        .BUFFER_DEPTH(B_M*B_N),
        .ADDR_WIDTH(R_ADDR_WIDTH)
    ) r_buffer(
        .clk(clk),
        .rst(rst),
        .wr_en  (busy ? r_wr_en_reg : r_wr_en_in),
        .rd_en  (busy ? r_rd_en_reg : r_rd_en_in),
        .data_in(busy ? result : matrix_c_in),
        .rd_addr(busy ? r_rd_addr_reg : r_rd_addr_in),
        .wr_addr(busy ? r_wr_addr_reg : r_wr_addr_in),
        .data_out(matrix_c),
        .valid_out(c_valid)
    );

    wire [M*N*RESULT_WIDTH-1:0] result;

    localparam B_M_WIDTH = $clog2(B_M);
    localparam B_N_WIDTH = $clog2(B_N);
    localparam B_K_WIDTH = $clog2(B_K);
    // reg [B_M_WIDTH+B_N_WIDTH+B_K_WIDTH-1:0] counter;
    reg [B_M_WIDTH+B_N_WIDTH+B_K_WIDTH-1:0] counter;

    always @(posedge clk ) begin
        if (rst) begin
            counter <= 0;
        end else if (state == WORK) begin
            counter <= counter + 1;
        end
    end

    OPorDP #(
        .A_DATA_WIDTH(A_DATA_WIDTH),
        .B_DATA_WIDTH(B_DATA_WIDTH),
        .RESULT_WIDTH(RESULT_WIDTH),
        .LATENCY(PIPELINE_DEPTH),
        .B_K(B_K),
        .M(M),
        .K(K),
        .N(N)
    ) opordp(
        .clk(clk),
        .rst(rst),
        .matrix_a_1d(matrix_a),
        .matrix_b_1d(matrix_b),
        .matrix_c_1d(matrix_c),
        .valid_i    (a_valid&&b_valid),
        .matrix_c_valid(c_valid),
        .valid_o    (r_wr_en_reg )  ,
        .result_1d(result)
    );

`ifdef DP //??

    wire [B_M_WIDTH-1:0] i;
    wire [B_N_WIDTH-1:0] j;
    wire [B_K_WIDTH-1:0] k;

    assign i = (B_M==1)?0:counter[B_M_WIDTH+B_N_WIDTH+B_K_WIDTH-1:B_N_WIDTH+B_K_WIDTH];
    assign j = (B_N==1)?0:counter[B_N_WIDTH+B_K_WIDTH-1:B_K_WIDTH];
    assign k = (B_K==1)?0:counter[B_K_WIDTH-1:0];

    assign p_rd_addr = {i, k};
    assign q_rd_addr = {j, k};
    assign r_rd_addr = {i, j};
    // assign r_wr_addr = {i, j};

`else   //??
    wire [B_M_WIDTH-1:0] i;
    wire [B_N_WIDTH-1:0] j;
    wire [B_K_WIDTH-1:0] k;
    assign k = (B_K==1)?0:counter[B_K_WIDTH+B_M_WIDTH+B_N_WIDTH-1:B_M_WIDTH+B_N_WIDTH];
    assign i = (B_M==1)?0:counter[B_M_WIDTH+B_N_WIDTH-1:B_N_WIDTH];
    assign j = (B_N==1)?0:counter[B_N_WIDTH-1:0];

    assign p_rd_addr = {i, k};
    assign q_rd_addr = {j, k};
    assign r_rd_addr = {i, j};
    // assign r_wr_addr = {i, j};
`endif

logic [R_ADDR_WIDTH-1:0] r_wr_addr_reg;
logic [R_ADDR_WIDTH-1:0] r_rd_addr_reg;
logic                    r_rd_en_reg  ;
logic                    r_wr_en_reg  ;

always_ff @ (posedge clk) begin
    if(rst) begin
        r_wr_addr_reg <= 0;
    end
    else begin
        r_wr_addr_reg <= r_wr_addr_reg + r_wr_en_reg;
    end
end

localparam PIPELINE_DEPTH = $clog2(K)+1+2+3;

logic [P_ADDR_WIDTH-1:0] p_addr_pipe    [PIPELINE_DEPTH-1:0];
logic [Q_ADDR_WIDTH-1:0] q_addr_pipe    [PIPELINE_DEPTH-1:0];
logic [R_ADDR_WIDTH-1:0] r_addr_pipe    [PIPELINE_DEPTH-1:0];
logic                    r_rd_en_pipe   [PIPELINE_DEPTH-1:0];

always_ff @ (posedge clk) begin
    for (int i=1;i<PIPELINE_DEPTH;i++) begin
        p_addr_pipe [i] <= p_addr_pipe[i-1] ;
        q_addr_pipe [i] <= q_addr_pipe[i-1] ;
        r_addr_pipe [i] <= r_addr_pipe[i-1] ;
        r_rd_en_pipe[i] <= r_rd_en_pipe[i-1];
    end
end

always_comb begin
    p_addr_pipe [0] = p_rd_addr ;
    q_addr_pipe [0] = q_rd_addr ;
    r_addr_pipe [0] = r_rd_addr ;
    r_rd_en_pipe[0] = (state==WORK)&& k==0   ;
    r_rd_addr_reg   = r_addr_pipe [PIPELINE_DEPTH-1];
    r_rd_en_reg     = r_rd_en_pipe[PIPELINE_DEPTH-1];
end

always_comb begin
        if(state == WORK) begin
            p_rd_en = 1;
            q_rd_en = 1;
        end else begin
            p_rd_en = 0;
            q_rd_en = 0;
        end
    end


state_1 state ;

always_ff @ (posedge clk) begin
    if(rst) begin
        state <= WAIT;
    end
    else begin
        case (state)
            WAIT: begin
                if(start) begin
                    state <= WORK;
                end
            end
            WORK:begin
                if((counter==B_K*B_M*B_N-1)) begin
                    state <= WRITE_BACK;
                end
            end
            WRITE_BACK:begin
                if((r_wr_addr_reg==B_M*B_N-1)&&r_wr_en_reg) begin
                    state <= WAIT;
                end
            end
            default: begin
                state <= state;
            end
        endcase
    end
end

assign busy = state!=WAIT;

always_comb begin
        if (state != WAIT) begin
            matrix_c_out = 0;
            c_vaild_out = 0;
        end else begin
            matrix_c_out = matrix_c;
            c_vaild_out = c_valid;
        end
    end


endmodule


module gemm #(
    parameter A_DATA_WIDTH = 8,      // 矩阵A元素的位宽
    parameter B_DATA_WIDTH = 4,      // 矩阵B元素的位宽
    parameter RESULT_WIDTH = 32,     // 结果矩阵元素的位宽
    parameter M = 8,                 // 矩阵 A 的行数 / 矩阵 C 的行数
    parameter N = 8,                 // 矩阵 B 的列数 / 矩阵 C 的列数
    parameter K = 8,                 // 矩阵 A 的列数 / 矩阵 B 的行数
    parameter B_M = 8,               // 矩阵 P 的行数 / 矩阵 R 的行数
    parameter B_N = 16,               // 矩阵 Q 的列数 / 矩阵 R 的列数
    parameter B_K = 8,               // 矩阵 P 的列数 / 矩阵 Q 的行数
    parameter P_ADDR_WIDTH = $clog2(B_M*B_K), // 矩阵 P 的地址位宽
    parameter Q_ADDR_WIDTH = $clog2(B_N*B_K), // 矩阵 Q 的地址位宽
    parameter R_ADDR_WIDTH = $clog2(B_M*B_N)  // 矩阵 R 的地址位宽
)(
   input wire clk,
    input wire rst,
    input wire last_start,
    input wire p_wr_en_in ,
    input wire q_wr_en_in ,
    input wire r_wr_en_in ,      //c buffer外部写入使能信号
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
    reg  p_rd_en;
    reg  q_rd_en;
    reg  r_rd_en;
    reg  r_rd_en_reg;
    wire [P_ADDR_WIDTH-1:0] p_rd_addr;
    wire [Q_ADDR_WIDTH-1:0] q_rd_addr;
    wire [R_ADDR_WIDTH-1:0] r_rd_addr;
    reg  [R_ADDR_WIDTH-1:0] r_rd_addr_reg;
    reg  r_wr_en;   //c buffer内部写入使能信号
    reg  r_wr_en_reg_0;
    reg  r_wr_en_reg_1;
    wire [R_ADDR_WIDTH-1:0] r_wr_addr;
    reg  [R_ADDR_WIDTH-1:0] r_wr_addr_reg_0;
    reg  [R_ADDR_WIDTH-1:0] r_wr_addr_reg_1;
    wire [M*K*A_DATA_WIDTH-1:0] matrix_a;
    wire [N*K*B_DATA_WIDTH-1:0] matrix_b;
    wire [M*N*RESULT_WIDTH-1:0] matrix_c;
    wire c_valid;

    logic a_valid;
    logic b_valid;

    double_buffer #(
        .DATA_WIDTH(M*K*A_DATA_WIDTH),
        .BUFFER_DEPTH(B_M*B_K),
        .ADDR_WIDTH(P_ADDR_WIDTH)
    ) p_buffer(
        .clk(clk),
        .rst(rst),
        .wr_en( p_wr_en_in),
        .rd_en(p_rd_en),
        .buffer_sel_load(buffer_sel_load),
        .buffer_sel_comp(buffer_sel_comp),
        .data_in(matrix_a_in),
        .rd_addr(p_rd_addr),
        .wr_addr(p_addr_in),

        .data_out(matrix_a),
        .valid_out(a_valid)
    );

    double_buffer #(
        .DATA_WIDTH(N*K*B_DATA_WIDTH),
        .BUFFER_DEPTH(B_N*B_K),
        .ADDR_WIDTH(Q_ADDR_WIDTH)
    ) q_buffer(
        .clk(clk),
        .rst(rst),
        .wr_en( q_wr_en_in),
        .rd_en(q_rd_en),
        .buffer_sel_load(buffer_sel_load),
        .buffer_sel_comp(buffer_sel_comp),
        .data_in(matrix_b_in),
        .rd_addr(q_rd_addr),
        .wr_addr(q_addr_in),

        .data_out(matrix_b),
        .valid_out(b_valid)
    );
    
//    logic r_wr_en ;
//    logic r_rd_en ;
//    logic [M*N*RESULT_WIDTH-1:0] data_in;
//    logic [R_ADDR_WIDTH-1:0] rd_addr;
//    logic [R_ADDR_WIDTH-1:0] wr_addr;
    
//    always_comb begin
//    r_wr_en = 
//    end
    logic busy_intra;
    logic [M*N*RESULT_WIDTH-1:0] result;
    buffer #(
        .DATA_WIDTH(M*N*RESULT_WIDTH),
        .BUFFER_DEPTH(B_M*B_N),
        .ADDR_WIDTH(R_ADDR_WIDTH)
    ) r_buffer(
        .clk(clk),
        .rst(rst),
        .wr_en  (busy_intra ? r_wr_en_reg : r_wr_en_in),
        .rd_en  (busy_intra ? r_rd_en_reg : r_rd_en_in),
        .data_in(busy_intra ? result : matrix_c_in),
        .rd_addr(busy_intra ? r_rd_addr_reg : r_rd_addr_in),
        .wr_addr(busy_intra ? r_wr_addr_reg : r_wr_addr_in),
        .data_out(matrix_c),
        .valid_out(c_valid)
    );

    

    localparam B_M_WIDTH = $clog2(B_M);
    localparam B_N_WIDTH = $clog2(B_N);
    localparam B_K_WIDTH = $clog2(B_K);
    // reg [B_M_WIDTH+B_N_WIDTH+B_K_WIDTH-1:0] counter;
    reg [B_M_WIDTH+B_N_WIDTH+B_K_WIDTH-1:0] counter;

    always @(posedge clk ) begin
        if (rst) begin
            counter <= 0;
        end else if (state == WORK) begin
            counter <= counter + 1;
        end
    end
    
    localparam DATA_PATH_DEPTH = 1;
    
    logic [M*K*A_DATA_WIDTH-1:0] matrix_a_pipe [DATA_PATH_DEPTH:0];
    logic [N*K*B_DATA_WIDTH-1:0] matrix_b_pipe [DATA_PATH_DEPTH:0];
    logic [M*N*RESULT_WIDTH-1:0] matrix_c_pipe [DATA_PATH_DEPTH:0];
    logic                        a_valid_pipe  [DATA_PATH_DEPTH:0];
    logic                        b_valid_pipe  [DATA_PATH_DEPTH:0];
    logic                        c_valid_pipe  [DATA_PATH_DEPTH:0];
    
    always_ff @ (posedge clk) begin
        for(int i=1;i<DATA_PATH_DEPTH+1;i++) begin
            matrix_a_pipe[i]   <= matrix_a_pipe[i-1];
            matrix_b_pipe[i]   <= matrix_b_pipe[i-1];
            matrix_c_pipe[i]   <= matrix_c_pipe[i-1];
            a_valid_pipe [i]   <= a_valid_pipe [i-1];
            b_valid_pipe [i]   <= b_valid_pipe [i-1];
            c_valid_pipe [i]   <= c_valid_pipe [i-1];
        end
    end
    
    always_comb begin
    matrix_a_pipe[0] = matrix_a;
    matrix_b_pipe[0] = matrix_b;
    matrix_c_pipe[0] = matrix_c;
    a_valid_pipe [0] = a_valid;
    b_valid_pipe [0] = b_valid;
    c_valid_pipe [0] = c_valid;
    end
    

    OPorDP #(
        .A_DATA_WIDTH(A_DATA_WIDTH),
        .B_DATA_WIDTH(B_DATA_WIDTH),
        .RESULT_WIDTH(RESULT_WIDTH),
        .LATENCY(PIPELINE_DEPTH),
        .M(M),
        .K(K),
        .N(N),
        .B_K(B_K)
    ) opordp(
        .clk(clk),
        .rst(rst),
        .matrix_a_1d(matrix_a_pipe[DATA_PATH_DEPTH]),
        .matrix_b_1d(matrix_b_pipe[DATA_PATH_DEPTH]),
        .matrix_c_1d(matrix_c_pipe[DATA_PATH_DEPTH]),
        .valid_i    (a_valid_pipe[DATA_PATH_DEPTH]&&b_valid_pipe[DATA_PATH_DEPTH]),
        .matrix_c_valid(c_valid_pipe[DATA_PATH_DEPTH]),
        .valid_o    (r_wr_en_reg )  ,
        .result_1d(result)
    );

`ifdef DP //内积

    wire [B_M_WIDTH-1:0] i;
    wire [B_N_WIDTH-1:0] j;
    wire [B_K_WIDTH-1:0] k;

    assign i = (B_M==1)?0:counter[B_M_WIDTH+B_N_WIDTH+B_K_WIDTH-1:B_N_WIDTH+B_K_WIDTH];
    assign j = (B_N==1)?0:counter[B_N_WIDTH+B_K_WIDTH-1:B_K_WIDTH];
    assign k = (B_K==1)?0:counter[B_K_WIDTH-1:0];

    assign p_rd_addr = {i, k};
    assign q_rd_addr = {j, k};
    assign r_rd_addr = {i, j};
    // assign r_wr_addr = {i, j};

`else   //外积
    wire [B_M_WIDTH-1:0] i;
    wire [B_N_WIDTH-1:0] j;
    wire [B_K_WIDTH-1:0] k;
    assign k = (B_K==1)?0:counter[B_K_WIDTH+B_M_WIDTH+B_N_WIDTH-1:B_M_WIDTH+B_N_WIDTH];
    assign i = (B_M==1)?0:counter[B_M_WIDTH+B_N_WIDTH-1:B_N_WIDTH];
    assign j = (B_N==1)?0:counter[B_N_WIDTH-1:0];

    assign p_rd_addr = {i, k};
    assign q_rd_addr = {j, k};
    assign r_rd_addr = {i, j};
    // assign r_wr_addr = {i, j};
`endif

logic [R_ADDR_WIDTH-1:0] r_wr_addr_reg;
//logic [R_ADDR_WIDTH-1:0] r_rd_addr_reg;
//logic                    r_rd_en_reg  ;
logic                    r_wr_en_reg  ;

always_ff @ (posedge clk) begin
    if(rst) begin
        r_wr_addr_reg <= 0;
    end
    else begin
        r_wr_addr_reg <= r_wr_addr_reg + r_wr_en_reg;
    end
end

localparam PIPELINE_DEPTH = $clog2(K)+1+2+3;

logic [P_ADDR_WIDTH-1:0] p_addr_pipe    [PIPELINE_DEPTH-1:0];
logic [Q_ADDR_WIDTH-1:0] q_addr_pipe    [PIPELINE_DEPTH-1:0];
logic [R_ADDR_WIDTH-1:0] r_addr_pipe    [PIPELINE_DEPTH-1:0];
logic                    r_rd_en_pipe   [PIPELINE_DEPTH-1:0];

always_ff @ (posedge clk) begin
    for (int i=1;i<PIPELINE_DEPTH;i++) begin
        p_addr_pipe [i] <= p_addr_pipe[i-1] ;
        q_addr_pipe [i] <= q_addr_pipe[i-1] ;
        r_addr_pipe [i] <= r_addr_pipe[i-1] ;
        r_rd_en_pipe[i] <= r_rd_en_pipe[i-1];
    end
end

always_comb begin
    p_addr_pipe [0] = p_rd_addr ;
    q_addr_pipe [0] = q_rd_addr ;
    r_addr_pipe [0] = r_rd_addr ;
    r_rd_en_pipe[0] = (state==WORK)&& k==0   ;
    r_rd_addr_reg   = r_addr_pipe [PIPELINE_DEPTH-1];
    r_rd_en_reg     = r_rd_en_pipe[PIPELINE_DEPTH-1];
end

always_comb begin
        if(state == WORK) begin
            p_rd_en = 1;
            q_rd_en = 1;
            // r_rd_en = 1;
            // r_wr_en = 1;
        end else begin
            p_rd_en = 0;
            q_rd_en = 0;
            // r_rd_en = 0;
            // r_wr_en = 0;
        end
    end


state_1 state ;

always_ff @ (posedge clk) begin
    if(rst) begin
        state <= WAIT;
    end
    else begin
        case (state)
            WAIT: begin
                if((buffer_state[buffer_sel_comp]==STALL)) begin
                    state <= WORK;
                end
            end
            WORK:begin
                if((counter==B_K*B_M*B_N-1)) begin
                    state <= WRITE_BACK;
                end
            end
            WRITE_BACK:begin
                if((r_wr_addr_reg==B_M*B_N-1)&&r_wr_en_reg) begin
                    state <= WAIT;
                end
            end
            default: begin
                state <= state;
            end
        endcase
    end
end

assign busy_intra = state!=WAIT;

logic load_done;
logic compute_done;
logic [1:0] buffer_free;

assign buffer_free[0] = (buffer_state[0]==EMPTY);
assign buffer_free[1] = (buffer_state[1]==EMPTY);

// logic next_block;
logic no_next_block;
assign no_next_block = !(((buffer_state[0]==EMPTY)&&(buffer_state[1]==LOAD))||((buffer_state[1]==EMPTY)&&(buffer_state[0]==LOAD)));

assign next_block = no_next_block&&(|buffer_free);


// logic next_load;
// logic next_compute;
// assign next_load = buffer_state[buffer_sel_load]==EMPTY;

always_comb begin
        if (busy_intra) begin
            matrix_c_out = 0;
            c_vaild_out = 0;
        end else begin
            matrix_c_out = matrix_c;
            c_vaild_out = c_valid;
        end
    end



state_2 buffer_a_state, buffer_b_state;
logic buffer_sel_load;
logic buffer_sel_comp;
logic buffer_sel_wb;

reg [1:0] p_load_done   ;
reg [1:0] q_load_done   ;




//a buffer状态机
always_ff @ (posedge clk) begin
    if(rst) begin
        buffer_a_state <= EMPTY;
    end
    else begin
        case (buffer_a_state)
            EMPTY:begin//
                if ((~buffer_sel_load)&&(p_wr_en_in||q_wr_en_in||r_wr_en_in)&&(buffer_b_state!=LOAD)) begin //¿ªÊ¼ÐÅºÅÌ§¸ß
                    buffer_a_state <= LOAD;
                end
            end
            LOAD:begin
                if ((p_load_done[0]&&q_load_done[0])) begin
                    buffer_a_state <= STALL;
                end
            end
            STALL:begin
                if ((state==WAIT)) begin
                    buffer_a_state <= COMPUTE;
                end
            end
            COMPUTE:begin
                if (counter == B_K*B_M*B_N-1) begin
                    buffer_a_state <= COMPUTE_DONE;
                end
            end
            COMPUTE_DONE:begin
                    buffer_a_state <= EMPTY;
            end
            default:buffer_a_state <= EMPTY;
        endcase
    end
end

//b buffer×´Ì¬»ú   
always_ff @ (posedge clk) begin
    if(rst) begin
        buffer_b_state <= EMPTY;
    end
    else begin
        case (buffer_b_state)
            EMPTY:begin
                if ((buffer_sel_load)&&(p_wr_en_in||q_wr_en_in||r_wr_en_in)&&(buffer_a_state!=LOAD)) begin //¿ªÊ¼ÐÅºÅÌ§¸ß
                    buffer_b_state <= LOAD;
                end
            end
            LOAD:begin//µÃÏÈÓÃreg´æÒ»ÏÂ
                if (p_load_done[1]&&q_load_done[1])
                begin
                    buffer_b_state <= STALL;
                end
            end
            STALL:begin
                if (state==WAIT) begin
                    buffer_b_state <= COMPUTE;
                end
            end
            COMPUTE:begin
                if (counter == B_K*B_M*B_N-1) begin
                    buffer_b_state <= COMPUTE_DONE;
                end
            end
            COMPUTE_DONE:begin
                buffer_b_state <= EMPTY;
            end
            default:buffer_b_state <= EMPTY;
        endcase
    end
end

//switch_buffer切换信号
logic switch_buffer_load    ;
logic switch_buffer_compute ;
logic switch_buffer_wb      ;

state_2 [1:0] buffer_state ;

assign buffer_state[0] = buffer_a_state;
assign buffer_state[1] = buffer_b_state;

//复位和buffer切换逻辑            //把这些信号放到gemm.sv里面，然后把信号拉出来接到该文件的输入端口
always @(posedge clk) begin
    if (rst) begin
        // 初始化双缓冲所有存储单元为0
        buffer_sel_load <= 0;
        buffer_sel_comp <= 0;
        buffer_sel_wb <= 0  ;
    end else begin
        // buffer切换逻辑
        if (switch_buffer_load) buffer_sel_load <= ~buffer_sel_load;
        if (switch_buffer_compute) buffer_sel_comp <= ~buffer_sel_comp;
        if (switch_buffer_wb) buffer_sel_wb <= ~buffer_sel_wb;
    end
end

always_ff @ (posedge clk) begin
    if(rst) begin
        p_load_done <=0;
        q_load_done <=0;
        // r_load_done <=0;
    end
    else begin
        if((p_wr_en_in)&&(p_addr_in==(1 << (B_M_WIDTH + B_K_WIDTH)) - 1)) begin
            p_load_done [buffer_sel_load] <= 1;
        end
        if((q_wr_en_in)&&(q_addr_in==(1 << (B_N_WIDTH + B_K_WIDTH)) - 1)) begin
            q_load_done [buffer_sel_load] <= 1;
        end

        if(switch_buffer_load) begin
            p_load_done [buffer_sel_load] <= 0;
            q_load_done [buffer_sel_load] <= 0;
        end

    end
end

always_ff  @ (posedge clk) begin
    if(rst) begin
        switch_buffer_load <= 0;
        switch_buffer_compute <= 0;
        switch_buffer_wb <= 0;
    end else begin
        if (p_load_done[buffer_sel_load]&&q_load_done[buffer_sel_load]&&!switch_buffer_load) begin
            switch_buffer_load <= 1;
        end
        else begin
            switch_buffer_load <= 0;
        end
        if ((buffer_state[buffer_sel_comp]==COMPUTE_DONE)) begin
            switch_buffer_compute <= 1;
        end
        else begin
            switch_buffer_compute <= 0;
        end
            switch_buffer_wb <= 0;
    end
end

assign a_buffer_state = buffer_a_state;
assign b_buffer_state = buffer_b_state;

logic [1:0] last_buffer_id;
logic compute_done_reg;
state_2 last_buffer_state_reg;

always_ff @ (posedge clk) begin
    if(rst) begin
        last_buffer_id <= 2;
        last_buffer_state_reg <= EMPTY;
        compute_done_reg <= 0;
    end
    else begin
        if(last_start) begin
            last_buffer_id <= (buffer_state[0]>buffer_state[1])||(buffer_state[0]==EMPTY);
        end
        else begin
            if(busy) begin
                last_buffer_id <= 2;
            end
        end
//        last_buffer_state_reg <= buffer_state[last_buffer_id];
        if(last_buffer_id==2) begin
            last_buffer_state_reg <= EMPTY;
        end
        else begin
            last_buffer_state_reg <= buffer_state[last_buffer_id];
        end
        
        if(last_buffer_state_reg==COMPUTE_DONE) begin
            compute_done_reg <= 1;
        end
        else begin
            if(busy) begin
                compute_done_reg <= 0;
            end
        end
    end
end

assign busy = (compute_done_reg)&&!busy_intra;

endmodule
