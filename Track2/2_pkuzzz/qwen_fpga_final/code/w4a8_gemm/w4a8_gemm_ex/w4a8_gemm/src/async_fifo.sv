//深度为8，数据位宽为8的异步FIFO
module async_fifo #(
    parameter   DATA_DEPTH = 8,	//深度为8
    parameter   DATA_WIDTH = 8,	//数据位宽为8
    parameter   PTR_WIDTH  = $clog2(DATA_DEPTH)	//读写指针位宽为3
    )(
    input  [DATA_WIDTH - 1 : 0] wr_data, 	//写数据
    input                   	wr_clk,	 	//写时钟
    input                   	wr_rst_n,	//写时钟复位
    input                   	wr_en,		//写使能
    input                   	rd_clk,		//读数据
    input                   	rd_rst_n,	//读时钟复位
    input                   	rd_en,		//读使能
    output reg                 	fifo_full,	//“满”标志位
    output reg                 	fifo_valid,	//“空”标志位
    output reg [DATA_WIDTH - 1 : 0] rd_data //写时钟
);

/*-----------------------------------------------------------------
-----------------------------伪双口RAM模块--------------------------
------------------------------------------------------------------*/

//定义一个宽度为8，深度为DEPTH的8的RAM_FIFO
reg [DATA_WIDTH - 1 : 0] ram_fifo [DATA_DEPTH - 1 : 0];

logic fifo_empty;

//写指针计数
reg [PTR_WIDTH : 0]  wr_ptr; //信息位+地址位所以指针位宽为4
always@ (posedge wr_clk ) begin
    if(!wr_rst_n) begin
        wr_ptr <= 0;
    end
    else if(wr_en && !fifo_full) begin
        wr_ptr <= wr_ptr + 1;
    end
    else begin
        wr_ptr <= wr_ptr;
    end
end

//RAM写入数据
wire [PTR_WIDTH -1 : 0]  wr_addr; 
assign wr_addr = wr_ptr[PTR_WIDTH -1 : 0];	//RAM写数据只需要地址位不需要信息位，所以寻址地址位宽为3
always@ (posedge wr_clk ) begin
    // if(!wr_rst_n) begin
    //     ram_fifo[wr_addr] <= 0;	//复位
    // end
    if(wr_en && !fifo_full) begin
        ram_fifo[wr_addr] <= wr_data;	//数据写入
    end
    
end


//读指针计数
reg [PTR_WIDTH : 0]  rd_ptr;
always@ (posedge rd_clk) begin
    if(!rd_rst_n) begin
        rd_ptr <= 0;
    end
    else if(rd_en && !fifo_empty) begin
        rd_ptr <= rd_ptr + 1;
    end
    else begin
        rd_ptr <= rd_ptr;
    end
end

//RAM读出数据
wire [PTR_WIDTH -1 : 0]  rd_addr;
assign rd_addr = rd_ptr[PTR_WIDTH -1 : 0];//RAM读数据只需要地址位不需要信息位，所以寻址地址位宽为3
// always@ (posedge rd_clk) begin
//     // if(!rd_rst_n) begin
//     //     rd_data <= 0;	//复位
//     // end
//     if(rd_en && !fifo_empty) begin
//         rd_data <= ram_fifo[rd_addr];	//读数据
//     end
//     // else begin
//     //     rd_data <= rd_data;		//保持不变
//     // end
// end

assign rd_data = ram_fifo[rd_addr];

/*--------------------------------------------------------------------
------------------------读写指针（格雷码）转换与跨时钟域同步模块------
---------------------------------------------------------------------------------------*/

//读写指针转换成格雷码
wire [PTR_WIDTH : 0] wr_ptr_gray;
wire [PTR_WIDTH : 0] rd_ptr_gray;
assign wr_ptr_gray = wr_ptr ^ (wr_ptr >> 1);
assign rd_ptr_gray = rd_ptr ^ (rd_ptr >> 1);

//写指针同步到读时钟域
//打两拍
reg [PTR_WIDTH : 0] wr_ptr_gray_r1;
reg [PTR_WIDTH : 0] wr_ptr_gray_r2;
always@ (posedge rd_clk ) begin
    if(!rd_rst_n) begin
        wr_ptr_gray_r1 <= 0;
        wr_ptr_gray_r2 <= 0;
    end
    else begin
        wr_ptr_gray_r1 <= wr_ptr_gray;
        wr_ptr_gray_r2 <= wr_ptr_gray_r1;
    end
end

//读指针同步到写时钟域
//打两拍
reg [PTR_WIDTH : 0] rd_ptr_gray_r1;
reg [PTR_WIDTH : 0] rd_ptr_gray_r2;
always@ (posedge wr_clk) begin
    if(!wr_rst_n) begin
        rd_ptr_gray_r1 <= 0;
        rd_ptr_gray_r2 <= 0;
    end
    else begin
        rd_ptr_gray_r1 <= rd_ptr_gray;
        rd_ptr_gray_r2 <= rd_ptr_gray_r1;
    end
end

/*--------------------------------------------------------------------------------------
--------------------------------------空满信号判断模块-----------------------------------
---------------------------------------------------------------------------------------*/

//组合逻辑判断写满
always@ (*) begin
    if( wr_ptr_gray == { ~rd_ptr_gray_r2[PTR_WIDTH : PTR_WIDTH - 1],
                               rd_ptr_gray_r2[PTR_WIDTH - 2 : 0] }) begin
        fifo_full = 1;
    end
    else begin
        fifo_full = 0;
    end
end

//组合逻辑判断读空
always@ (*) begin
    if(rd_ptr_gray == wr_ptr_gray_r2) begin
        fifo_empty = 1;
    end
    else begin
        fifo_empty = 0;
    end
end

assign fifo_valid = !fifo_empty;

endmodule























`include "registers.svh"

(* no_ungroup *)
(* no_boundary_optimization *)

/// A gray code to binary converter.
/* verilator lint_off DECLFILENAME */
module gray_to_binary #(
    parameter int N = -1
)(
    input  logic [N-1:0] A,
    output logic [N-1:0] Z
);
    for (genvar i = 0; i < N; i++)
        assign Z[i] = ^A[N-1:i];
endmodule
/* verilator lint_off DECLFILENAME */
module binary_to_gray #(
    parameter int N = -1
)(
    input  logic [N-1:0] A,
    output logic [N-1:0] Z
);
    assign Z = A ^ (A >> 1);
endmodule
/* verilator lint_off DECLFILENAME */
module sync #(
    parameter int unsigned STAGES = 2,
    parameter bit ResetValue = 1'b0
) (
    input  logic clk_i,
    input  logic rst_ni,
    input  logic serial_i,
    output logic serial_o
);

   (* dont_touch = "true" *)
   (* async_reg = "true" *)
   logic [STAGES-1:0] reg_q;

    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
            reg_q <= {STAGES{ResetValue}};
        end else begin
            reg_q <= {reg_q[STAGES-2:0], serial_i};
        end
    end

    assign serial_o = reg_q[STAGES-1];

endmodule
/* verilator lint_off DECLFILENAME */
module spill_register #(
  parameter type T      = logic,
  parameter bit  Bypass = 1'b0     // make this spill register transparent
) (
  input  logic clk_i   ,
  input  logic rst_ni  ,
  input  logic valid_i ,
  output logic ready_o ,
  input  T     data_i  ,
  output logic valid_o ,
  input  logic ready_i ,
  output T     data_o
);

  spill_register_flushable #(
    .T(T),
    .Bypass(Bypass)
  ) spill_register_flushable_i (
    .clk_i,
    .rst_ni,
    .valid_i,
    .flush_i(1'b0),
    .ready_o,
    .data_i,
    .valid_o,
    .ready_i,
    .data_o
  );

endmodule
/* verilator lint_off DECLFILENAME */
module spill_register_flushable #(
  parameter type T           = logic,
  parameter bit  Bypass      = 1'b0   // make this spill register transparent
) (
  input  logic clk_i   ,
  input  logic rst_ni  ,
  input  logic valid_i ,
  input  logic flush_i ,
  output logic ready_o ,
  input  T     data_i  ,
  output logic valid_o ,
  input  logic ready_i ,
  output T     data_o
);

  if (Bypass) begin : gen_bypass
    assign valid_o = valid_i;
    assign ready_o = ready_i;
    assign data_o  = data_i;
  end else begin : gen_spill_reg
    // The A register.
    T a_data_q;
    logic a_full_q;
    logic a_fill, a_drain;

    always_ff @(posedge clk_i or negedge rst_ni) begin : ps_a_data
      if (!rst_ni)
        a_data_q <= '0;
      else if (a_fill)
        a_data_q <= data_i;
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin : ps_a_full
      if (!rst_ni)
        a_full_q <= 0;
      else if (a_fill || a_drain)
        a_full_q <= a_fill;
    end

    // The B register.
    T b_data_q;
    logic b_full_q;
    logic b_fill, b_drain;

    always_ff @(posedge clk_i or negedge rst_ni) begin : ps_b_data
      if (!rst_ni)
        b_data_q <= '0;
      else if (b_fill)
        b_data_q <= a_data_q;
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin : ps_b_full
      if (!rst_ni)
        b_full_q <= 0;
      else if (b_fill || b_drain)
        b_full_q <= b_fill;
    end

    // Fill the A register when the A or B register is empty. Drain the A register
    // whenever it is full and being filled, or if a flush is requested.
    assign a_fill = valid_i && ready_o && (!flush_i);
    assign a_drain = (a_full_q && !b_full_q) || flush_i;

    // Fill the B register whenever the A register is drained, but the downstream
    // circuit is not ready. Drain the B register whenever it is full and the
    // downstream circuit is ready, or if a flush is requested.
    assign b_fill = a_drain && (!ready_i) && (!flush_i);
    assign b_drain = (b_full_q && ready_i) || flush_i;

    // We can accept input as long as register B is not full.
    // Note: flush_i and valid_i must not be high at the same time,
    // otherwise an invalid handshake may occur
    assign ready_o = !a_full_q || !b_full_q;

    // The unit provides output as long as one of the registers is filled.
    assign valid_o = a_full_q | b_full_q;

    // We empty the spill register before the slice register.
    assign data_o = b_full_q ? b_data_q : a_data_q;

    // pragma translate_off
    `ifndef VERILATOR
    flush_valid : assert property (
      @(posedge clk_i) disable iff (~rst_ni) (flush_i |-> ~valid_i)) else
      $warning("Trying to flush and feed the spill register simultaneously. You will lose data!");
   `endif
     // pragma translate_on
  end
endmodule

/* verilator lint_off DECLFILENAME */
module cdc_fifo_gray #(
  /// The width of the default logic type.
  parameter int unsigned WIDTH = 1,
  /// The data type of the payload transported by the FIFO.
  parameter type T = logic [WIDTH-1:0],
  /// The FIFO's depth given as 2**LOG_DEPTH.
  parameter int LOG_DEPTH = 3,
  /// The number of synchronization registers to insert on the async pointers.
  /* verilator lint_off UNUSED */
  parameter int SYNC_STAGES = 2
) (
  input  logic src_rst_ni,
  input  logic src_clk_i,
  input  T     src_data_i,
  input  logic src_valid_i,
  output logic src_ready_o,

  input  logic dst_rst_ni,
  input  logic dst_clk_i,
  output T     dst_data_o,
  output logic dst_valid_o,
  input  logic dst_ready_i
);

  (* ram_style = "block" *) T [2**LOG_DEPTH-1:0] async_data;
  logic [LOG_DEPTH:0]  async_wptr;
  logic [LOG_DEPTH:0]  async_rptr;

  cdc_fifo_gray_src #(
    .T         ( T         ),
    .LOG_DEPTH ( LOG_DEPTH )
  ) i_src (
    .src_rst_ni,
    .src_clk_i,
    .src_data_i,
    .src_valid_i,
    .src_ready_o,

    (* async *) .async_data_o ( async_data ),
    (* async *) .async_wptr_o ( async_wptr ),
    (* async *) .async_rptr_i ( async_rptr )
  );

  cdc_fifo_gray_dst #(
    .T         ( T         ),
    .LOG_DEPTH ( LOG_DEPTH )
  ) i_dst (
    .dst_rst_ni,
    .dst_clk_i,
    .dst_data_o,
    .dst_valid_o,
    .dst_ready_i,

    (* async *) .async_data_i ( async_data ),
    (* async *) .async_wptr_i ( async_wptr ),
    (* async *) .async_rptr_o ( async_rptr )
  );

  // Check the invariants.
  // pragma translate_off
  `ifndef VERILATOR
  initial assert(LOG_DEPTH > 0);
  initial assert(SYNC_STAGES >= 2);
  `endif
  // pragma translate_on

endmodule


(* no_ungroup *)
(* no_boundary_optimization *)
module cdc_fifo_gray_src #(
  parameter type T = logic,
  parameter int LOG_DEPTH = 3,
  parameter int SYNC_STAGES = 2
)(
  input  logic src_rst_ni,
  input  logic src_clk_i,
  input  T     src_data_i,
  input  logic src_valid_i,
  output logic src_ready_o,

  output T [2**LOG_DEPTH-1:0] async_data_o,
  output logic [LOG_DEPTH:0]  async_wptr_o,
  input  logic [LOG_DEPTH:0]  async_rptr_i
);

  localparam int PtrWidth = LOG_DEPTH+1;
  localparam logic [PtrWidth-1:0] PtrFull = (1 << LOG_DEPTH);

  (* keep *) T [2**LOG_DEPTH-1:0] data_q;
  logic [PtrWidth-1:0] wptr_q, wptr_d, wptr_bin, wptr_next, rptr, rptr_bin;

  // Data FIFO.
  assign async_data_o = data_q;
  for (genvar i = 0; i < 2**LOG_DEPTH; i++) begin : gen_word
    `FFLNR(data_q[i], src_data_i,
          src_valid_i & src_ready_o & (wptr_bin[LOG_DEPTH-1:0] == i), src_clk_i)
  end

  // Read pointer.
  for (genvar i = 0; i < PtrWidth; i++) begin : gen_sync
    sync #(.STAGES(SYNC_STAGES)) i_sync (
      .clk_i    ( src_clk_i       ),
      .rst_ni   ( src_rst_ni      ),
      .serial_i ( async_rptr_i[i] ),
      .serial_o ( rptr[i]         )
    );
  end
  gray_to_binary #(PtrWidth) i_rptr_g2b (.A(rptr), .Z(rptr_bin));

  // Write pointer.
  assign wptr_next = wptr_bin+1;
  gray_to_binary #(PtrWidth) i_wptr_g2b (.A(wptr_q), .Z(wptr_bin));
  binary_to_gray #(PtrWidth) i_wptr_b2g (.A(wptr_next), .Z(wptr_d));
  `FFLARN(wptr_q, wptr_d, src_valid_i & src_ready_o, '0, src_clk_i, src_rst_ni)
  assign async_wptr_o = wptr_q;

  // The pointers into the FIFO are one bit wider than the actual address into
  // the FIFO. This makes detecting critical states very simple: if all but the
  // topmost bit of rptr and wptr agree, the FIFO is in a critical state. If the
  // topmost bit is equal, the FIFO is empty, otherwise it is full.
  assign src_ready_o = ((wptr_bin ^ rptr_bin) != PtrFull);

endmodule


(* no_ungroup *)
(* no_boundary_optimization *)
module cdc_fifo_gray_dst #(
  parameter type T = logic,
  parameter int LOG_DEPTH = 3,
  parameter int SYNC_STAGES = 2
)(
  input  logic dst_rst_ni,
  input  logic dst_clk_i,
  output T     dst_data_o,
  output logic dst_valid_o,
  input  logic dst_ready_i,

  input  T [2**LOG_DEPTH-1:0] async_data_i,
  input  logic [LOG_DEPTH:0]  async_wptr_i,
  output logic [LOG_DEPTH:0]  async_rptr_o
);

  localparam int PtrWidth = LOG_DEPTH+1;
  localparam logic [PtrWidth-1:0] PtrEmpty = '0;

  (* keep *) T dst_data;
  /* verilator lint_off UNUSED */
  logic [PtrWidth-1:0] rptr_q, rptr_d, rptr_bin, rptr_bin_d, rptr_next, wptr, wptr_bin;
  logic dst_valid, dst_ready;
  // Data selector and register.
  assign dst_data = async_data_i[rptr_bin[LOG_DEPTH-1:0]];

  // Read pointer.
  assign rptr_next = rptr_bin+1;
  gray_to_binary #(PtrWidth) i_rptr_g2b (.A(rptr_q), .Z(rptr_bin));
  binary_to_gray #(PtrWidth) i_rptr_b2g (.A(rptr_next), .Z(rptr_d));
  `FFLARN(rptr_q, rptr_d, dst_valid & dst_ready, '0, dst_clk_i, dst_rst_ni)
  assign async_rptr_o = rptr_q;

  // Write pointer.
  for (genvar i = 0; i < PtrWidth; i++) begin : gen_sync
    sync #(.STAGES(SYNC_STAGES)) i_sync (
      .clk_i    ( dst_clk_i       ),
      .rst_ni   ( dst_rst_ni      ),
      .serial_i ( async_wptr_i[i] ),
      .serial_o ( wptr[i]         )
    );
  end
  gray_to_binary #(PtrWidth) i_wptr_g2b (.A(wptr), .Z(wptr_bin));

  // The pointers into the FIFO are one bit wider than the actual address into
  // the FIFO. This makes detecting critical states very simple: if all but the
  // topmost bit of rptr and wptr agree, the FIFO is in a critical state. If the
  // topmost bit is equal, the FIFO is empty, otherwise it is full.
  assign dst_valid = ((wptr_bin ^ rptr_bin) != PtrEmpty);

  // Cut the combinatorial path with a spill register.
  spill_register #(
    .T       ( T           )
  ) i_spill_register (
    .clk_i   ( dst_clk_i   ),
    .rst_ni  ( dst_rst_ni  ),
    .valid_i ( dst_valid   ),
    .ready_o ( dst_ready   ),
    .data_i  ( dst_data    ),
    .valid_o ( dst_valid_o ),
    .ready_i ( dst_ready_i ),
    .data_o  ( dst_data_o  )
  );

endmodule