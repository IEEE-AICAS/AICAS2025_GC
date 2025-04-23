import spinal.core.sim._
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.bus.amba4.axis.Axi4Stream
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream

import scala.language.postfixOps

// gradually build up the LLAMA accelerator
class LLAMA extends Component {
  // @formatter:off
    val gemm          = new GEMM()
    val demux         = new DEMUX()
    val rope_qk_quant = new ROPE_QK_QUANT()
    val qk_gemm       = new QK_GEMM()
    val softmax_quant = new SOFTMAX_QUANT()
    val rv_gemm       = new RV_GEMM()
    val silu_em_quant = new SILU_EM_QUANT()
    val residual      = new RESIDUAL()
    val rmsnorm_quant = new RMSNORM_QUANT()
    val mux           = new MUX()

    val io = new Bundle {
      val signals: DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
      val x_stream:     Axi4Stream = slave (Axi4Stream(residual       .io.x_stream    .config))
      val w_stream:     Axi4Stream = slave (Axi4Stream(gemm           .io.w_stream    .config))
      val s1_stream:    Axi4Stream = slave (Axi4Stream(gemm           .io.s1_stream   .config))
      val s2_stream:    Axi4Stream = slave (Axi4Stream(gemm           .io.s2_stream   .config))
      val y_stream:     Axi4Stream = master(Axi4Stream(residual       .io.y_stream    .config))
    }
    noIoPrefix()
    // connect signals
                   io.signals.I               <>      mux             .io.signals.I
    mux           .io.signals.O               <>      gemm            .io.signals.I
    gemm          .io.signals.O               <>      demux           .io.signals.I
    demux         .io.signals.O               <>      rope_qk_quant   .io.signals.I
    rope_qk_quant .io.signals.O               <>      qk_gemm         .io.signals.I
    qk_gemm       .io.signals.O               <>      softmax_quant   .io.signals.I
    softmax_quant .io.signals.O               <>      rv_gemm         .io.signals.I
    rv_gemm       .io.signals.O               <>      silu_em_quant   .io.signals.I
    silu_em_quant .io.signals.O               <>      residual        .io.signals.I
    residual      .io.signals.O               <>      rmsnorm_quant   .io.signals.I
    rmsnorm_quant .io.signals.O               <>                       io.signals.O
    // connect streams
                   io.x_stream                <>      residual        .io.x_stream
                   io.w_stream                <>      gemm            .io.w_stream
                   io.s1_stream               <>      gemm            .io.s1_stream
                   io.s2_stream               <>      gemm            .io.s2_stream
    mux           .io.q_stream                <>      gemm            .io.i_stream
    mux           .io.s_stream.queue(512)     <>      gemm            .io.s_stream
    gemm          .io.o_stream                <>      demux           .io.gemm_stream
    demux         .io.qk_stream               <>      rope_qk_quant   .io.qk_stream
    demux         .io.v_stream                <>      rv_gemm         .io.v_stream
    demux         .io.ug_stream               <>      silu_em_quant   .io.ug_stream
    demux         .io.od_stream               <>      residual        .io.res_i_stream
    rope_qk_quant .io.rot_q_stream            <>      qk_gemm         .io.qk_q_stream
    rope_qk_quant .io.rot_s_stream            <>      qk_gemm         .io.qk_s_stream
    qk_gemm       .io.r_stream                <>      softmax_quant   .io.r_stream
    softmax_quant .io.rq_stream               <>      rv_gemm         .io.rq_stream
    softmax_quant .io.rs_stream               <>      rv_gemm         .io.rs_stream
    residual      .io.res_o_stream            <>      rmsnorm_quant   .io.x_stream
    residual      .io.y_stream                <>                       io.y_stream
    // feed back path
    rv_gemm       .io.aq_stream               <>      mux.             io.aq_stream
    rv_gemm       .io.as_stream               <>      mux.             io.as_stream
    silu_em_quant .io.q_stream                <>      mux.             io.xmq_stream
    silu_em_quant .io.s_stream                <>      mux.             io.xms_stream
    rmsnorm_quant .io.xlnq_stream             <>      mux.             io.xlnq_stream
    rmsnorm_quant .io.xlns_stream             <>      mux.             io.xlns_stream

    // rename
    Axi4StreamSpecRenamer(io.x_stream)
    Axi4StreamSpecRenamer(io.w_stream)
    Axi4StreamSpecRenamer(io.s1_stream)
    Axi4StreamSpecRenamer(io.s2_stream)
    Axi4StreamSpecRenamer(io.y_stream)
  // @formatter:on
}

object simulate_llama extends App {
  redirect_std("LLAMA.log")

  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )
  spinalConfig.generateVerilog(new LLAMA)

  SimConfig
    .withConfig(spinalConfig)
    .withFstWave
    .withWaveDepth(2)
    .allOptimisation
    .withVerilator
    .addSimulatorFlag("--unroll-count 1024")
    .addSimulatorFlag("-j 16")
    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
    .compile(new LLAMA)
    .doSimUntilVoid { dut =>
      // some hyper parameters

      val H = 32
      val G = 8

      val L = 2

      val T = 32
      val TP = 4 // used many places

      val S = 32 // sequence length
      val SP = G
      val ST = S / SP

      val C = 4096
      val CM = 11008
      val CP = G
      val CT = C / CP
      val CMT = CM / CP

      // @formatter:off
            val NUM_X   = 3*CT*T*C + CT*T*C + 2*CMT*T*C + CT*T*CM
            val NUM_XS  = NUM_X / G
            val NUM_W   = 3*C*C + C*C + 2*CM*C + C*CM
            val NUM_WS  = NUM_W / G
            val NUM_Y   = 3*T*C + T*C + 2*T*CM + T*C
            // @formatter:on

      val data_path_prefix = "C:/projects/ClionProjects/LLM/cmake-build-debug/binaries_renamed/decoder_"
      val format_str = s"$data_path_prefix%d/%s.bin"
      // arrays
      // @formatter:off
            val REF_X                     = read_int64_file       (format_str.format(0,   "MHA_X"),                   T*C)
            val REF_CONDENSED_Y           = read_int64_file       (format_str.format(L-1, "CONDENSED_RESIDUAL_Y"),    T*C)
            val REF_CONDENSED_WQ          = read_multi_int8_files (format_str, L, "CONDENSED_GEMM_W_Q",             NUM_W)
            val REF_CONDENSED_WS1         = read_multi_int8_files (format_str, L, "CONDENSED_GEMM_W_S1",            NUM_WS)
            val REF_CONDENSED_WS2         = read_multi_int8_files (format_str, L, "CONDENSED_GEMM_W_S2",            NUM_WS)

            val DUT_CONDENSED_Y           = Array.ofDim[Long](     T*C)
            // @formatter:on

      // init ap_ctrl and streams
      init_i_stream(dut.io.x_stream)
      init_i_stream(dut.io.w_stream)
      init_i_stream(dut.io.s1_stream)
      init_i_stream(dut.io.s2_stream)
      init_o_stream(dut.io.y_stream)
      init_daisy_chain(dut.io.signals)

      // fork clock
      init_clock(dut.clockDomain, 10)

      // set parameter and trigger
      dut.io.signals.I.L_BEGIN #= 0
      dut.io.signals.I.L_CLOSE #= L
      dut.io.signals.I.POS_ID #= 0
      // delay 20 cycles to make sure the signals are set
      dut.clockDomain.waitSampling(20)
      // launch with trigger
      dut.io.signals.I.T #= true
      dut.clockDomain.waitSampling()
      dut.io.signals.I.T #= false
      dut.clockDomain.waitSampling(20)

      // threads
      Array(
        // @formatter:off
                fork {
                                                array2stream(dut.io.x_stream,       dut.clockDomain, REF_X,      1,                        1, T, TP, C, CP, info="x_stream", verbose=true)
                },
                fork {
                    for (l <- 0 until L) array2stream(dut.io.w_stream,      dut.clockDomain, REF_CONDENSED_WQ(l),      1,                        1, 1, 1, NUM_W, CP*CP,    info="w_stream", verbose=true)
                },
                fork {
                    for (l <- 0 until L) array2stream(dut.io.s1_stream,     dut.clockDomain, REF_CONDENSED_WS1(l),     1,                        1, 1, 1, NUM_WS, CP   ,   info="s1_stream")
                },
                fork {
                    for (l <- 0 until L) array2stream(dut.io.s2_stream,     dut.clockDomain, REF_CONDENSED_WS2(l),     1,                        1, 1, 1, NUM_WS, CP   ,   info="s2_stream")
                },
                fork {
                                                stream2array(dut.io.y_stream,       dut.clockDomain, REF_CONDENSED_Y, DUT_CONDENSED_Y, 1, 1, 1, T*C, TP*CP, info="y_stream")
                }
                // @formatter:on
      ).foreach(_.join())

      // at end, with 100 cycles
      dut.clockDomain.waitSampling(100)

      simSuccess()
    }
}


object generate_llama extends App {
  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )
  spinalConfig.generateVerilog(new LLAMA).mergeRTLSource()
}
