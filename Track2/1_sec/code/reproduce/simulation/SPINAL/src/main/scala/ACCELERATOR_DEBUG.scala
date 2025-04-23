//import spinal.core._
//import spinal.lib.bus.amba4.axi._
//import spinal.lib._
//import spinal.lib.bus.amba4.axilite.{AxiLite4, AxiLite4SpecRenamer}
//import utils._
//import spinal.lib.bus.amba4.axis.Axi4Stream
//import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream
//
//import scala.language.postfixOps
//
//// @formatter:off
//class ACCELERATOR_DEBUG extends Component {
//  private val inst_m_axi = new M_AXI
//  private val inst_controller = new Controller
//
//  // sub modules
//  val gemm              = new GEMM()
//  val demux             = new DEMUX()
//  val rope_qk_quant     = new ROPE_QK_QUANT()
//  val qk_gemm           = new QK_GEMM()
//  val softmax_quant     = new SOFTMAX_QUANT()
//  val rv_gemm           = new RV_GEMM()
//  val silu_em_quant     = new SILU_EM_QUANT()
//  val residual          = new RESIDUAL()
//  val rmsnorm_quant     = new RMSNORM_QUANT()
//  val mux               = new MUX()
//
//  // daisy chain
//  inst_controller .io .signals       <>    inst_m_axi     .io .signals.I
//  inst_m_axi      .io .signals.O     <>    mux            .io .signals.I
//  mux             .io .signals.O     <>    gemm           .io .signals.I
//  gemm            .io .signals.O     <>    demux          .io .signals.I
//  demux           .io .signals.O     <>    rope_qk_quant  .io .signals.I
//  rope_qk_quant   .io .signals.O     <>    qk_gemm        .io .signals.I
//  qk_gemm         .io .signals.O     <>    softmax_quant  .io .signals.I
//  softmax_quant   .io .signals.O     <>    rv_gemm        .io .signals.I
//  rv_gemm         .io .signals.O     <>    silu_em_quant  .io .signals.I
//  silu_em_quant   .io .signals.O     <>    residual       .io .signals.I
//  residual        .io .signals.O     <>    rmsnorm_quant  .io .signals.I
//
//  // forward
//  inst_m_axi    .io .x_stream                <> residual      .io .x_stream
//  inst_m_axi    .io .wq_stream   .queue(512) <> gemm          .io .w_stream
//  inst_m_axi    .io .ws1_stream  .queue(512) <> gemm          .io .s1_stream
//  inst_m_axi    .io .ws2_stream  .queue(512) <> gemm          .io .s2_stream
//  mux           .io .q_stream                <> gemm          .io .i_stream
//  mux           .io .s_stream    .queue(512) <> gemm          .io .s_stream
//  gemm          .io .o_stream                <> demux         .io .gemm_stream
//  demux         .io .qk_stream               <> rope_qk_quant .io .qk_stream
//  demux         .io .v_stream                <> rv_gemm       .io .v_stream
//  demux         .io .ug_stream               <> silu_em_quant .io .ug_stream
//  demux         .io .od_stream               <> residual      .io .res_i_stream
//  demux         .io .cls_stream              <> inst_m_axi    .io .cls_stream
//  rope_qk_quant .io .rot_q_stream            <> qk_gemm       .io .qk_q_stream
//  rope_qk_quant .io .rot_s_stream            <> qk_gemm       .io .qk_s_stream
//  qk_gemm       .io .r_stream                <> softmax_quant .io .r_stream
//  softmax_quant .io .rq_stream               <> rv_gemm       .io .rq_stream
//  softmax_quant .io .rs_stream               <> rv_gemm       .io .rs_stream
//  residual      .io .res_o_stream            <> rmsnorm_quant .io .x_stream
//  residual      .io .y_stream                <> inst_m_axi    .io .y_stream
//
//  // feedback
//  rv_gemm       .io .aq_stream               <> mux  .io .aq_stream
//  rv_gemm       .io .as_stream               <> mux  .io .as_stream
//  silu_em_quant .io .q_stream                <> mux  .io .xmq_stream
//  silu_em_quant .io .s_stream                <> mux  .io .xms_stream
//  rmsnorm_quant .io .xlnq_stream             <> mux  .io .xlnq_stream
//  rmsnorm_quant .io .xlns_stream             <> mux  .io .xlns_stream
//
//  // print each stream bit width
//  println(s"inst_m_axi.     x_stream:         ${inst_m_axi    .io .x_stream     .config.dataWidth}")
//  println(s"inst_m_axi.     wq_stream:        ${inst_m_axi    .io .wq_stream    .config.dataWidth}")
//  println(s"inst_m_axi.     ws1_stream:       ${inst_m_axi    .io .ws1_stream   .config.dataWidth}")
//  println(s"inst_m_axi.     ws2_stream:       ${inst_m_axi    .io .ws2_stream   .config.dataWidth}")
//  println(s"mux.            q_stream:         ${mux           .io .q_stream     .config.dataWidth}")
//  println(s"mux.            s_stream:         ${mux           .io .s_stream     .config.dataWidth}")
//  println(s"gemm.           o_stream:         ${gemm          .io .o_stream     .config.dataWidth}")
//  println(s"demux.          qk_stream:        ${demux         .io .qk_stream    .config.dataWidth}")
//  println(s"demux.          v_stream:         ${demux         .io .v_stream     .config.dataWidth}")
//  println(s"demux.          ug_stream:        ${demux         .io .ug_stream    .config.dataWidth}")
//  println(s"demux.          od_stream:        ${demux         .io .od_stream    .config.dataWidth}")
//  println(s"rope_qk_quant.  rot_q_stream:     ${rope_qk_quant .io .rot_q_stream .config.dataWidth}")
//  println(s"rope_qk_quant.  rot_s_stream:     ${rope_qk_quant .io .rot_s_stream .config.dataWidth}")
//  println(s"qk_gemm.        r_stream:         ${qk_gemm       .io .r_stream     .config.dataWidth}")
//  println(s"softmax_quant.  rq_stream:        ${softmax_quant .io .rq_stream    .config.dataWidth}")
//  println(s"softmax_quant.  rs_stream:        ${softmax_quant .io .rs_stream    .config.dataWidth}")
//  println(s"residual.       res_o_stream:     ${residual      .io .res_o_stream .config.dataWidth}")
//  println(s"residual.       y_stream:         ${residual      .io .y_stream     .config.dataWidth}")
//  println(s"rv_gemm.        aq_stream:        ${rv_gemm       .io .aq_stream    .config.dataWidth}")
//  println(s"rv_gemm.        as_stream:        ${rv_gemm       .io .as_stream    .config.dataWidth}")
//  println(s"silu_em_quant.  q_stream:         ${silu_em_quant .io .q_stream     .config.dataWidth}")
//  println(s"silu_em_quant.  s_stream:         ${silu_em_quant .io .s_stream     .config.dataWidth}")
//  println(s"rmsnorm_quant.  xlnq_stream:      ${rmsnorm_quant .io .xlnq_stream  .config.dataWidth}")
//  println(s"rmsnorm_quant.  xlns_stream:      ${rmsnorm_quant .io .xlns_stream  .config.dataWidth}")
//
//  // define io
//  val io = new Bundle {
//    val axilite:  AxiLite4  = slave (AxiLite4 (inst_controller.io.axilite.config))
//    val m_axi:    Axi4      = master(Axi4     (inst_m_axi.io.m_axi.config       ))
//    val idle:     Bool      = out Bool()
//    // debug interfaces
//    val debug_inst_m_axi_x_stream         :Axi4Stream = master(Axi4Stream(inst_m_axi.io.x_stream.config))
//    val debug_inst_m_axi_wq_stream        :Axi4Stream = master(Axi4Stream(inst_m_axi.io.wq_stream.config))
//    val debug_inst_m_axi_ws1_stream       :Axi4Stream = master(Axi4Stream(inst_m_axi.io.ws1_stream.config))
//    val debug_inst_m_axi_ws2_stream       :Axi4Stream = master(Axi4Stream(inst_m_axi.io.ws2_stream.config))
//    val debug_mux_q_stream                :Axi4Stream = master(Axi4Stream(mux.io.q_stream.config))
//    val debug_mux_s_stream                :Axi4Stream = master(Axi4Stream(mux.io.s_stream.config))
//    val debug_gemm_o_stream               :Axi4Stream = master(Axi4Stream(gemm.io.o_stream.config))
//    val debug_demux_qk_stream             :Axi4Stream = master(Axi4Stream(demux.io.qk_stream.config))
//    val debug_demux_v_stream              :Axi4Stream = master(Axi4Stream(demux.io.v_stream.config))
//    val debug_demux_ug_stream             :Axi4Stream = master(Axi4Stream(demux.io.ug_stream.config))
//    val debug_demux_od_stream             :Axi4Stream = master(Axi4Stream(demux.io.od_stream.config))
//    val debug_demux_cls_stream            :Axi4Stream = master(Axi4Stream(demux.io.cls_stream.config))
//    val debug_rope_qk_quant_rot_q_stream  :Axi4Stream = master(Axi4Stream(rope_qk_quant.io.rot_q_stream.config))
//    val debug_rope_qk_quant_rot_s_stream  :Axi4Stream = master(Axi4Stream(rope_qk_quant.io.rot_s_stream.config))
//    val debug_qk_gemm_r_stream            :Axi4Stream = master(Axi4Stream(qk_gemm.io.r_stream.config))
//    val debug_softmax_quant_rq_stream     :Axi4Stream = master(Axi4Stream(softmax_quant.io.rq_stream.config))
//    val debug_softmax_quant_rs_stream     :Axi4Stream = master(Axi4Stream(softmax_quant.io.rs_stream.config))
//    val debug_residual_res_o_stream       :Axi4Stream = master(Axi4Stream(residual.io.res_o_stream.config))
//    val debug_residual_y_stream           :Axi4Stream = master(Axi4Stream(residual.io.y_stream.config))
//    val debug_rv_gemm_aq_stream           :Axi4Stream = master(Axi4Stream(rv_gemm.io.aq_stream.config))
//    val debug_rv_gemm_as_stream           :Axi4Stream = master(Axi4Stream(rv_gemm.io.as_stream.config))
//    val debug_silu_em_quant_q_stream      :Axi4Stream = master(Axi4Stream(silu_em_quant.io.q_stream.config))
//    val debug_silu_em_quant_s_stream      :Axi4Stream = master(Axi4Stream(silu_em_quant.io.s_stream.config))
//    val debug_rmsnorm_quant_xlnq_stream   :Axi4Stream = master(Axi4Stream(rmsnorm_quant.io.xlnq_stream.config))
//    val debug_rmsnorm_quant_xlns_stream   :Axi4Stream = master(Axi4Stream(rmsnorm_quant.io.xlns_stream.config))
//  }
//  noIoPrefix()
//
//  // io connection
//  io  .axilite  <> inst_controller  .io .axilite
//  io  .m_axi    <> inst_m_axi       .io .m_axi
//  io  .idle     <> inst_m_axi       .io .idle
//
//  // non protocol connection
//  inst_controller.io.idle <> inst_m_axi.io.idle
//
//  // io rename
//  Axi4SpecRenamer(io.m_axi)
//  AxiLite4SpecRenamer(io.axilite)
//
//  // connect debug
//  private def connect_debug(debug_port: Axi4Stream, inst_port: Axi4Stream): Unit = {
//    debug_port.data  <> inst_port.data
//    debug_port.valid <> (inst_port.valid && inst_port.ready)
//    // ready from outside is not used
//    if (inst_port.config.useLast) {
//      debug_port.last <> inst_port.last
//    }
//    // Rename
//    Axi4StreamSpecRenamer(debug_port)
//  }
//  connect_debug(io.debug_inst_m_axi_x_stream,         inst_m_axi.io.x_stream)
//  connect_debug(io.debug_inst_m_axi_wq_stream,        inst_m_axi.io.wq_stream)
//  connect_debug(io.debug_inst_m_axi_ws1_stream,       inst_m_axi.io.ws1_stream)
//  connect_debug(io.debug_inst_m_axi_ws2_stream,       inst_m_axi.io.ws2_stream)
//  connect_debug(io.debug_mux_q_stream,                mux.io.q_stream)
//  connect_debug(io.debug_mux_s_stream,                mux.io.s_stream)
//  connect_debug(io.debug_gemm_o_stream,               gemm.io.o_stream)
//  connect_debug(io.debug_demux_qk_stream,             demux.io.qk_stream)
//  connect_debug(io.debug_demux_v_stream,              demux.io.v_stream)
//  connect_debug(io.debug_demux_ug_stream,             demux.io.ug_stream)
//  connect_debug(io.debug_demux_od_stream,             demux.io.od_stream)
//  connect_debug(io.debug_demux_cls_stream,            demux.io.cls_stream)
//  connect_debug(io.debug_rope_qk_quant_rot_q_stream,  rope_qk_quant.io.rot_q_stream)
//  connect_debug(io.debug_rope_qk_quant_rot_s_stream,  rope_qk_quant.io.rot_s_stream)
//  connect_debug(io.debug_qk_gemm_r_stream,            qk_gemm.io.r_stream)
//  connect_debug(io.debug_softmax_quant_rq_stream,     softmax_quant.io.rq_stream)
//  connect_debug(io.debug_softmax_quant_rs_stream,     softmax_quant.io.rs_stream)
//  connect_debug(io.debug_residual_res_o_stream,       residual.io.res_o_stream)
//  connect_debug(io.debug_residual_y_stream,           residual.io.y_stream)
//  connect_debug(io.debug_rv_gemm_aq_stream,           rv_gemm.io.aq_stream)
//  connect_debug(io.debug_rv_gemm_as_stream,           rv_gemm.io.as_stream)
//  connect_debug(io.debug_silu_em_quant_q_stream,      silu_em_quant.io.q_stream)
//  connect_debug(io.debug_silu_em_quant_s_stream,      silu_em_quant.io.s_stream)
//  connect_debug(io.debug_rmsnorm_quant_xlnq_stream,   rmsnorm_quant.io.xlnq_stream)
//  connect_debug(io.debug_rmsnorm_quant_xlns_stream,   rmsnorm_quant.io.xlns_stream)
//}
////@formatter:on
//
