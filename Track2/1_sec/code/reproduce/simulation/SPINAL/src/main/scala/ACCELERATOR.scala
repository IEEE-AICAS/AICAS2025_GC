import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.amba4.axilite.{AxiLite4, AxiLite4SpecRenamer}
import utils._

import scala.language.postfixOps

// @formatter:off
class ACCELERATOR extends Component {
  private val inst_m_axi      = new M_AXI

  private val inst_kv_cache   = new KV_CACHE
  private val inst_controller = new Controller

  // sub modules
  val gemm              = new GEMM
  val demux             = new DEMUX()
  val rope_qk_quant     = new ROPE_QK_QUANT()
  val qk_gemm           = new QK_GEMM()
  val softmax_quant     = new SOFTMAX_QUANT()
  val rv_gemm           = new RV_GEMM()
  val silu_em_quant     = new SILU_EM_QUANT()
  val residual          = new RESIDUAL()
  val rmsnorm_quant     = new RMSNORM_QUANT()
  val mux               = new MUX()

  // daisy chain
  inst_controller .io .signals       <>    inst_m_axi     .io .signals.I
  inst_m_axi      .io .signals.O     <>    inst_kv_cache  .io .signals.I
  inst_kv_cache   .io .signals.O     <>    mux            .io .signals.I
  mux             .io .signals.O     <>    gemm           .io .signals.I
  gemm            .io .signals.O     <>    demux          .io .signals.I
  demux           .io .signals.O     <>    rope_qk_quant  .io .signals.I
  rope_qk_quant   .io .signals.O     <>    qk_gemm        .io .signals.I
  qk_gemm         .io .signals.O     <>    softmax_quant  .io .signals.I
  softmax_quant   .io .signals.O     <>    rv_gemm        .io .signals.I
  rv_gemm         .io .signals.O     <>    silu_em_quant  .io .signals.I
  silu_em_quant   .io .signals.O     <>    residual       .io .signals.I
  residual        .io .signals.O     <>    rmsnorm_quant  .io .signals.I

  // forward
  inst_m_axi    .io .x_stream                <> residual      .io .x_stream
  inst_m_axi    .io .wq_stream  .queue(4000) <> gemm          .io .w_stream
  inst_m_axi    .io .ws1_stream .queue(4000) <> gemm          .io .s1_stream
  inst_m_axi    .io .ws2_stream .queue(4000) <> gemm          .io .s2_stream
  mux           .io .q_stream                <> gemm          .io .i_stream
  mux           .io .s_stream   .queue(16)   <> gemm          .io .s_stream
  gemm          .io .o_stream                <> demux         .io .gemm_stream
  demux         .io .qk_stream               <> rope_qk_quant .io .qk_stream
  demux         .io .v_stream                <> rv_gemm       .io .v_stream
  demux         .io .ug_stream               <> silu_em_quant .io .ug_stream
  demux         .io .od_stream               <> residual      .io .res_i_stream
  demux         .io .cls_stream              <> inst_m_axi    .io .cls_stream
  rope_qk_quant .io .rot_q_stream            <> qk_gemm       .io .qk_q_stream
  rope_qk_quant .io .rot_s_stream            <> qk_gemm       .io .qk_s_stream
  qk_gemm       .io .r_stream                <> softmax_quant .io .r_stream
  softmax_quant .io .rq_stream               <> rv_gemm       .io .rq_stream
  softmax_quant .io .rs_stream               <> rv_gemm       .io .rs_stream
  residual      .io .res_o_stream            <> rmsnorm_quant .io .x_stream
  residual      .io .y_stream                <> inst_m_axi    .io .y_stream

  // feedback
  rv_gemm       .io .aq_stream               <> mux  .io .aq_stream
  rv_gemm       .io .as_stream               <> mux  .io .as_stream
  silu_em_quant .io .q_stream                <> mux  .io .xmq_stream
  silu_em_quant .io .s_stream                <> mux  .io .xms_stream
  rmsnorm_quant .io .xlnq_stream             <> mux  .io .xlnq_stream
  rmsnorm_quant .io .xlns_stream             <> mux  .io .xlns_stream

  // kv cache
  inst_kv_cache .io .kq_cache_i_stream       <> qk_gemm.io.kq_cache_i_stream
  inst_kv_cache .io .ks_cache_i_stream       <> qk_gemm.io.ks_cache_i_stream
  inst_kv_cache .io .kq_cache_o_stream       <> qk_gemm.io.kq_cache_o_stream.queue(256)
  inst_kv_cache .io .ks_cache_o_stream       <> qk_gemm.io.ks_cache_o_stream.queue(256)
  inst_kv_cache .io .vq_cache_i_stream       <> rv_gemm.io.vq_cache_i_stream
  inst_kv_cache .io .vs_cache_i_stream       <> rv_gemm.io.vs_cache_i_stream
  inst_kv_cache .io .vq_cache_o_stream       <> rv_gemm.io.vq_cache_o_stream.queue(256)
  inst_kv_cache .io .vs_cache_o_stream       <> rv_gemm.io.vs_cache_o_stream.queue(256)

  // define io
  val io = new Bundle {
    val axilite:  AxiLite4  = slave (AxiLite4 (inst_controller.io.axilite.config))
    val gmem1:    Axi4      = master(Axi4     (inst_m_axi     .io.gmem.config   ))
    val gmem2:    Axi4      = master(Axi4     (inst_kv_cache  .io.gmem1.config  ))
    val idle:     Bool      = out Bool()
  }
  noIoPrefix()

  // io connection
  io  .axilite  <> inst_controller  .io .axilite
  io  .gmem1    <> inst_m_axi       .io .gmem
  io  .gmem2    <> inst_kv_cache    .io .gmem1
  io  .idle     <> inst_m_axi       .io .idle

  // non protocol connection
  inst_controller.io.idle <> inst_m_axi.io.idle

  // io rename
  Axi4SpecRenamer(io.gmem1)
  Axi4SpecRenamer(io.gmem2)
  AxiLite4SpecRenamer(io.axilite)
}
//@formatter:on

