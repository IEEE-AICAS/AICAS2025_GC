import spinal.core.sim._
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.bus.amba4.axis.Axi4Stream
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream

import scala.language.postfixOps

// @formatter:off
class MUX_Blackbox extends BlackBox {
  val top_name: String = "MUX"
  setDefinitionName(top_name)
  private val verilog_file_path: String = s"src/main/verilog/$top_name/all.v"
  val io = new Bundle {
    val ap_clk:       Bool = in Bool()
    val ap_rst_n:     Bool = in Bool()

    val l_begin:      UInt = in UInt(ctrl_cfg.L_BITS bits)
    val l_close:      UInt = in UInt(ctrl_cfg.L_BITS bits)

    val ap_ctrl:      ApChain = slave(ApChain())
    val xlnq_stream:  BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("xlnq_stream",  verilog_file_path)))
    val xlns_stream:  BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("xlns_stream",  verilog_file_path)))
    val aq_stream:    BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("aq_stream",    verilog_file_path)))
    val as_stream:    BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("as_stream",    verilog_file_path)))
    val xmq_stream:   BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("xmq_stream",   verilog_file_path)))
    val xms_stream:   BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("xms_stream",   verilog_file_path)))
    val q_stream:     BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("q_stream",     verilog_file_path)))
    val s_stream:     BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("s_stream",     verilog_file_path)))
  }
  noIoPrefix()
  ApChainRenamer(io.ap_ctrl)
  mapClockDomain(clock = io.ap_clk, reset = io.ap_rst_n, resetActiveLevel = LOW)
  addRTLPath(verilog_file_path)
}

class MUX extends Component {
  val top_name: String = "MUX"
  setDefinitionName(top_name + "_wrapper")
  private val black_box = new MUX_Blackbox
  val io = new Bundle {
    val signals: DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
    val xlnq_stream:  Axi4Stream = slave (Axi4Stream(black_box.io.xlnq_stream.config.to_std_config()))
    val xlns_stream:  Axi4Stream = slave (Axi4Stream(black_box.io.xlns_stream.config.to_std_config()))
    val aq_stream:    Axi4Stream = slave (Axi4Stream(black_box.io.aq_stream  .config.to_std_config()))
    val as_stream:    Axi4Stream = slave (Axi4Stream(black_box.io.as_stream  .config.to_std_config()))
    val xmq_stream:   Axi4Stream = slave (Axi4Stream(black_box.io.xmq_stream .config.to_std_config()))
    val xms_stream:   Axi4Stream = slave (Axi4Stream(black_box.io.xms_stream .config.to_std_config()))
    val q_stream:     Axi4Stream = master(Axi4Stream(black_box.io.q_stream   .config.to_std_config()))
    val s_stream:     Axi4Stream = master(Axi4Stream(black_box.io.s_stream   .config.to_std_config()))
  }
  noIoPrefix()
  val manager = new Manager
  manager.io.signals            <> io.signals
  manager.io.ap_ctrl            <> black_box.io.ap_ctrl
  manager.io.signals.O.L_BEGIN  <> black_box.io.l_begin
  manager.io.signals.O.L_CLOSE  <> black_box.io.l_close

  black_box.io.xlnq_stream.connect2std(io.xlnq_stream)
  black_box.io.xlns_stream.connect2std(io.xlns_stream)
  black_box.io.aq_stream  .connect2std(io.aq_stream)
  black_box.io.as_stream  .connect2std(io.as_stream)
  black_box.io.xmq_stream .connect2std(io.xmq_stream)
  black_box.io.xms_stream .connect2std(io.xms_stream)
  black_box.io.q_stream   .connect2std(io.q_stream)
  black_box.io.s_stream   .connect2std(io.s_stream)

  Axi4StreamSpecRenamer(io.xlnq_stream)
  Axi4StreamSpecRenamer(io.xlns_stream)
  Axi4StreamSpecRenamer(io.aq_stream)
  Axi4StreamSpecRenamer(io.as_stream)
  Axi4StreamSpecRenamer(io.xmq_stream)
  Axi4StreamSpecRenamer(io.xms_stream)
  Axi4StreamSpecRenamer(io.q_stream)
  Axi4StreamSpecRenamer(io.s_stream)
}

object simulate_mux extends App {
  redirect_std("MUX.log")

  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )
  spinalConfig.generateVerilog(new MUX)

  SimConfig
    .withConfig(spinalConfig)
    .withFstWave
    .withWaveDepth(4)
    .allOptimisation
    .withVerilator
    .addSimulatorFlag("--unroll-count 1024")
    .addSimulatorFlag("-j 16")
    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
    .compile(new MUX)
    .doSimUntilVoid { dut =>

      // simulation hyperparameters
      val L = 1

      // model hyperparameters
      val C = 896
      val CM = 4864

      // design hyperparameters
      val G = 8
      val T = 8
      val TP = 1
      val CP = G

      // derived hyperparameters
      val CT = C / CP
      val CMT = CM / CP
      val NUM_X = 3*CT*T*C + CT*T*C + 2*CMT*T*C + CT*T*CM
      val NUM_S = NUM_X / G

      val data_path_prefix = ctrl_cfg.condense_prefix
      val format_str = s"$data_path_prefix%d/%s.bin"

      val CONDENSED_XLN_Q = read_multi_int8_files(format_str, L, "CONDENSED_XLN_Q",                 2*T*C )
      val CONDENSED_XLN_S = read_multi_int8_files(format_str, L, "CONDENSED_XLN_S",                 2*T*CT)
      val CONDENSED_A_Q   = read_multi_int8_files(format_str, L, "CONDENSED_RV_GEMM_A_Q",             T*C )
      val CONDENSED_A_S   = read_multi_int8_files(format_str, L, "CONDENSED_RV_GEMM_A_S",             T*CT)
      val CONDENSED_XM_Q  = read_multi_int8_files(format_str, L, "CONDENSED_SILU_EM_QUANT_XM_Q",      T*CM)
      val CONDENSED_XM_S  = read_multi_int8_files(format_str, L, "CONDENSED_SILU_EM_QUANT_XM_S",      T*CMT)
      val CONDENSED_Q     = read_multi_int8_files(format_str, L, "CONDENSED_GEMM_X_Q",              NUM_X)
      val CONDENSED_S     = read_multi_int8_files(format_str, L, "CONDENSED_GEMM_X_S",              NUM_X)

      val MHA_XLN_Q = Array.ofDim[Byte](L, T*C)
      val MHA_XLN_S = Array.ofDim[Byte](L, T*CT)
      val MLP_XLN_Q = Array.ofDim[Byte](L, T*C)
      val MLP_XLN_S = Array.ofDim[Byte](L, T*CT)

      // handcrafted permutation
      for(l <- 0 until L; mha_or_mlp <- 0 until 2; t <- 0 until T; c <- 0 until C){
        val global_index = mha_or_mlp*T*C + t*C + c
        val local_index  = t*C + c
        if(mha_or_mlp == 0) {
          MHA_XLN_Q(l)(local_index) = CONDENSED_XLN_Q(l)(global_index)
        } else {
          MLP_XLN_Q(l)(local_index) = CONDENSED_XLN_Q(l)(global_index)
        }
      }
      for(l <- 0 until L; mha_or_mlp <- 0 until 2; t <- 0 until T; ct <- 0 until CT){
        val global_index = mha_or_mlp*T*CT + t*CT + ct
        val local_index  = t*CT + ct
        if(mha_or_mlp == 0) {
          MHA_XLN_S(l)(local_index) = CONDENSED_XLN_S(l)(global_index)
        } else {
          MLP_XLN_S(l)(local_index) = CONDENSED_XLN_S(l)(global_index)
        }
      }

      val R_QKV = 3 * CT
      val R_O = CT
      val R_M = 2 * CMT
      val R_D = CT
      val REF_CONDENSED_MHA_XLN_Q = Array.ofDim[Byte](L, R_QKV*T*C)
      val REF_CONDENSED_MHA_XLN_S = Array.ofDim[Byte](L, R_QKV*T*CT)
      val REF_CONDENSED_A_Q       = Array.ofDim[Byte](L, R_O  *T*C)
      val REF_CONDENSED_A_S       = Array.ofDim[Byte](L, R_O  *T*CT)
      val REF_CONDENSED_MLP_XLN_Q = Array.ofDim[Byte](L, R_M  *T*C)
      val REF_CONDENSED_MLP_XLN_S = Array.ofDim[Byte](L, R_M  *T*CT)
      val REF_CONDENSED_XM_Q      = Array.ofDim[Byte](L, R_D  *T*CM)
      val REF_CONDENSED_XM_S      = Array.ofDim[Byte](L, R_D  *T*CMT)
      // put condensed q and condensed s to them
      for(l <- 0 until L){
        for(num_x <- 0 until NUM_X){
          if(num_x < R_QKV*T*C){
            REF_CONDENSED_MHA_XLN_Q(l)(num_x) = CONDENSED_Q(l)(num_x)
          } else if(num_x < R_QKV*T*C + R_O*T*C){
            REF_CONDENSED_A_Q(l)(num_x - R_QKV*T*C) = CONDENSED_Q(l)(num_x)
          } else if(num_x < R_QKV*T*C + R_O*T*C + R_M*T*C){
            REF_CONDENSED_MLP_XLN_Q(l)(num_x - R_QKV*T*C - R_O*T*C) = CONDENSED_Q(l)(num_x)
          } else {
            REF_CONDENSED_XM_Q(l)(num_x - R_QKV*T*C - R_O*T*C - R_M*T*C) = CONDENSED_Q(l)(num_x)
          }
        }
        for(num_s <- 0 until NUM_S){
          if(num_s < R_QKV*T*CT){
            REF_CONDENSED_MHA_XLN_S(l)(num_s) = CONDENSED_S(l)(num_s)
          } else if(num_s < R_QKV*T*CT + R_O*T*CT){
            REF_CONDENSED_A_S(l)(num_s - R_QKV*T*CT) = CONDENSED_S(l)(num_s)
          } else if(num_s < R_QKV*T*CT + R_O*T*CT + R_M*T*CT){
            REF_CONDENSED_MLP_XLN_S(l)(num_s - R_QKV*T*CT - R_O*T*CT) = CONDENSED_S(l)(num_s)
          } else {
            REF_CONDENSED_XM_S(l)(num_s - R_QKV*T*CT - R_O*T*CT - R_M*T*CT) = CONDENSED_S(l)(num_s)
          }
        }
      }
      val DUT_CONDENSED_MHA_XLN_Q = Array.ofDim[Byte](L, R_QKV*T*C)
      val DUT_CONDENSED_MHA_XLN_S = Array.ofDim[Byte](L, R_QKV*T*CT)
      val DUT_CONDENSED_A_Q       = Array.ofDim[Byte](L, R_O  *T*C)
      val DUT_CONDENSED_A_S       = Array.ofDim[Byte](L, R_O  *T*CT)
      val DUT_CONDENSED_MLP_XLN_Q = Array.ofDim[Byte](L, R_M  *T*C)
      val DUT_CONDENSED_MLP_XLN_S = Array.ofDim[Byte](L, R_M  *T*CT)
      val DUT_CONDENSED_XM_Q      = Array.ofDim[Byte](L, R_D  *T*CM)
      val DUT_CONDENSED_XM_S      = Array.ofDim[Byte](L, R_D  *T*CMT)

      // init ap_ctrl and streams
      init_i_stream(dut.io.xlnq_stream)
      init_i_stream(dut.io.xlns_stream)
      init_i_stream(dut.io.aq_stream)
      init_i_stream(dut.io.as_stream)
      init_i_stream(dut.io.xmq_stream)
      init_i_stream(dut.io.xms_stream)
      init_o_stream(dut.io.q_stream)
      init_o_stream(dut.io.s_stream)
      init_daisy_chain(dut.io.signals)

      // fork clock
      init_clock(dut.clockDomain, 10)
      // threads
      Array(
        fork {
          dut.io.signals.I.L_BEGIN #= 0
          dut.io.signals.I.L_CLOSE #= L
          // delay 20 cycles to make sure the signals are set
          dut.clockDomain.waitSampling(20)
          // launch with trigger
          dut.io.signals.I.T #= true
          dut.clockDomain.waitSampling()
          dut.io.signals.I.T #= false
        },
        // @formatter:off
        fork {
          for(l <- 0 until L) {
            array2stream(dut.io.xlnq_stream,  dut.clockDomain, MHA_XLN_Q(l),                1,                          1, 1, 1,       T*C, TP*CP,  info="xlnq_stream", verbose=true)
            stream2array(dut.io.q_stream,     dut.clockDomain, REF_CONDENSED_MHA_XLN_Q(l),  DUT_CONDENSED_MHA_XLN_Q(l), 1, 1, 1, R_QKV*T*C, T *CP,  info="q_stream",    verbose=true)
            array2stream(dut.io.aq_stream,    dut.clockDomain, CONDENSED_A_Q(l),            1,                          1, 1, 1,       T*C, TP*CP,  info="aq_stream",   verbose=true)
            stream2array(dut.io.q_stream,     dut.clockDomain, REF_CONDENSED_A_Q(l),        DUT_CONDENSED_A_Q(l),       1, 1, 1,   R_O*T*C, T *CP,  info="q_stream",    verbose=true)
            array2stream(dut.io.xlnq_stream,  dut.clockDomain, MLP_XLN_Q(l),                1,                          1, 1, 1,       T*C, TP*CP,  info="xlnq_stream", verbose=true)
            stream2array(dut.io.q_stream,     dut.clockDomain, REF_CONDENSED_MLP_XLN_Q(l),  DUT_CONDENSED_MLP_XLN_Q(l), 1, 1, 1,   R_M*T*C, T *CP,  info="q_stream",    verbose=true)
            array2stream(dut.io.xmq_stream,   dut.clockDomain, CONDENSED_XM_Q(l),           1,                          1, 1, 1,       T*CM,   CP,  info="xmq_stream",  verbose=true)
            stream2array(dut.io.q_stream,     dut.clockDomain, REF_CONDENSED_XM_Q(l),       DUT_CONDENSED_XM_Q(l),      1, 1, 1,   R_D*T*CM,T *CP,  info="q_stream",    verbose=true)
          }
        },
        fork{
          for(l <- 0 until L){
            array2stream(dut.io.xlns_stream,  dut.clockDomain, MHA_XLN_S(l),                1,                          1, 1, 1,       T*CT,  TP,  info="xlns_stream", verbose=true)
            stream2array(dut.io.s_stream,     dut.clockDomain, REF_CONDENSED_MHA_XLN_S(l),  DUT_CONDENSED_MHA_XLN_S(l), 1, 1, 1, R_QKV*T*CT,  T ,  info="s_stream")
            array2stream(dut.io.as_stream,    dut.clockDomain, CONDENSED_A_S(l),            1,                          1, 1, 1,       T*CT,  TP,  info="as_stream",   verbose=true)
            stream2array(dut.io.s_stream,     dut.clockDomain, REF_CONDENSED_A_S(l),        DUT_CONDENSED_A_S(l),       1, 1, 1,   R_O*T*CT,  T ,  info="s_stream")
            array2stream(dut.io.xlns_stream,  dut.clockDomain, MLP_XLN_S(l),                1,                          1, 1, 1,       T*CT,  TP,  info="xlns_stream", verbose=true)
            stream2array(dut.io.s_stream,     dut.clockDomain, REF_CONDENSED_MLP_XLN_S(l),  DUT_CONDENSED_MLP_XLN_S(l), 1, 1, 1,   R_M*T*CT,  T ,  info="s_stream")
            array2stream(dut.io.xms_stream,   dut.clockDomain, CONDENSED_XM_S(l),           1,                          1, 1, 1,       T*CMT, 1 ,  info="xms_stream",  verbose=true)
            stream2array(dut.io.s_stream,     dut.clockDomain, REF_CONDENSED_XM_S(l),       DUT_CONDENSED_XM_S(l),      1, 1, 1,   R_D*T*CMT, T ,  info="s_stream")
          }
        }
        // @formatter:on
      ).foreach(_.join())

      // at end, with 100 cycles
      dut.clockDomain.waitSampling(100)
      simSuccess()
    }
}

