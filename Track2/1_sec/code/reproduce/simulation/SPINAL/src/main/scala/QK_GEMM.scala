import spinal.core.sim._
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.bus.amba4.axis.Axi4Stream
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream

import scala.language.postfixOps

// @formatter:off
class QK_GEMM_Blackbox extends BlackBox {
  val top_name: String = "QK_GEMM"
  setDefinitionName(top_name)
  private val verilog_file_path: String = s"src/main/verilog/$top_name/all.v"
  val io = new Bundle {
    val ap_clk:       Bool = in Bool()
    val ap_rst_n:     Bool = in Bool()

    val l_begin:      UInt = in  UInt(ctrl_cfg.L_BITS bits)
    val l_close:      UInt = in  UInt(ctrl_cfg.L_BITS bits)
    val pos_id:       UInt = in  UInt(ctrl_cfg.POS_BITS bits)

    val ap_ctrl:            ApChain      = slave  (ApChain())
    val qk_q_stream:        BlackboxAxis = slave  (BlackboxAxis(BlackboxAxisConfig("qk_q_stream",       verilog_file_path)))
    val qk_s_stream:        BlackboxAxis = slave  (BlackboxAxis(BlackboxAxisConfig("qk_s_stream",       verilog_file_path)))
    val kq_cache_i_stream:  BlackboxAxis = slave  (BlackboxAxis(BlackboxAxisConfig("kq_cache_i_stream", verilog_file_path)))
    val ks_cache_i_stream:  BlackboxAxis = slave  (BlackboxAxis(BlackboxAxisConfig("ks_cache_i_stream", verilog_file_path)))
    val kq_cache_o_stream:  BlackboxAxis = master (BlackboxAxis(BlackboxAxisConfig("kq_cache_o_stream", verilog_file_path)))
    val ks_cache_o_stream:  BlackboxAxis = master (BlackboxAxis(BlackboxAxisConfig("ks_cache_o_stream", verilog_file_path)))
    val r_stream:           BlackboxAxis = master (BlackboxAxis(BlackboxAxisConfig("r_stream",          verilog_file_path)))
  }
  // no io prefix, this is essential for name matching
  noIoPrefix()
  ApChainRenamer(io.ap_ctrl)
  mapClockDomain(clock = io.ap_clk, reset = io.ap_rst_n, resetActiveLevel = LOW)
  addRTLPath(verilog_file_path)
}

class QK_GEMM extends Component {
  val top_name: String = "QK_GEMM"
  setDefinitionName(top_name + "_wrapper")
  private val black_box = new QK_GEMM_Blackbox
  val io = new Bundle {
    val signals: DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
    val qk_q_stream:        Axi4Stream = slave (Axi4Stream(black_box.io.qk_q_stream      .config.to_std_config()))
    val qk_s_stream:        Axi4Stream = slave (Axi4Stream(black_box.io.qk_s_stream      .config.to_std_config()))
    val kq_cache_i_stream:  Axi4Stream = slave (Axi4Stream(black_box.io.kq_cache_i_stream.config.to_std_config()))
    val ks_cache_i_stream:  Axi4Stream = slave (Axi4Stream(black_box.io.ks_cache_i_stream.config.to_std_config()))
    val kq_cache_o_stream:  Axi4Stream = master(Axi4Stream(black_box.io.kq_cache_o_stream.config.to_std_config()))
    val ks_cache_o_stream:  Axi4Stream = master(Axi4Stream(black_box.io.ks_cache_o_stream.config.to_std_config()))
    val r_stream:           Axi4Stream = master(Axi4Stream(black_box.io.r_stream         .config.to_std_config()))
  }
  noIoPrefix()

  val manager = new Manager
  manager.io.signals            <> io.signals
  manager.io.ap_ctrl            <> black_box.io.ap_ctrl
  manager.io.signals.O.L_BEGIN  <> black_box.io.l_begin
  manager.io.signals.O.L_CLOSE  <> black_box.io.l_close
  manager.io.signals.O.POS_ID      <> black_box.io.pos_id

  black_box.io.qk_q_stream      .connect2std(io.qk_q_stream)
  black_box.io.qk_s_stream      .connect2std(io.qk_s_stream)
  black_box.io.kq_cache_i_stream.connect2std(io.kq_cache_i_stream)
  black_box.io.ks_cache_i_stream.connect2std(io.ks_cache_i_stream)
  black_box.io.kq_cache_o_stream.connect2std(io.kq_cache_o_stream)
  black_box.io.ks_cache_o_stream.connect2std(io.ks_cache_o_stream)
  black_box.io.r_stream         .connect2std(io.r_stream)

  Axi4StreamSpecRenamer(io.qk_q_stream)
  Axi4StreamSpecRenamer(io.qk_s_stream)
  Axi4StreamSpecRenamer(io.kq_cache_i_stream)
  Axi4StreamSpecRenamer(io.ks_cache_i_stream)
  Axi4StreamSpecRenamer(io.kq_cache_o_stream)
  Axi4StreamSpecRenamer(io.ks_cache_o_stream)
  Axi4StreamSpecRenamer(io.r_stream)
}

object simulate_qk_gemm extends App {
  redirect_std("QK_GEMM.log")

  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )
  spinalConfig.generateVerilog(new QK_GEMM)

  // do simulation
  SimConfig
    .withConfig(spinalConfig)
    .withFstWave
    .withWaveDepth(1)
    .allOptimisation
    .withVerilator
    .addSimulatorFlag("--unroll-count 1024")
    .addSimulatorFlag("-j 16")
    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
    .compile(new QK_GEMM)
    .doSimUntilVoid { dut =>

      val LLAMA_L = 24

      // simulation hyperparameters
      val L_BEGIN = 0
      val L_CLOSE = 1
      val T_LOAD = 128
      val S_LOAD = 128
      val POS = 96

      // model hyperparameters
      val LLAMA_C = 896
      val H = 14
      val HC = LLAMA_C / H

      // design hyperparameters
      val G = 8
      val T = 8
      val TP = 1
      val CP = G
      val S = 256
      val SP = G
      val HCT = HC / CP

      val data_path_prefix = ctrl_cfg.binaries_prefix
      val format_str = s"$data_path_prefix%d/%s.bin"
      // arrays
      val Q_Q       = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_Q_Q", H * T_LOAD * HC     ), H, H, T_LOAD, POS, T, HC,       HC)
      val Q_S       = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_Q_S", H * T_LOAD * HCT    ), H, H, T_LOAD, POS, T, HCT,      HCT)
      val K_Q       = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_K_Q", H * S_LOAD * HC     ), H, H, T_LOAD, POS, T, HC,       HC)
      val K_S       = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_K_S", H * S_LOAD * HCT    ), H, H, T_LOAD, POS, T, HCT,      HCT)
      val R         = cut_array[Long](read_multi_int64_files(format_str, LLAMA_L, "MHA_R",   H * T_LOAD * S_LOAD ), H, H, T_LOAD, POS, T, S_LOAD,   S)
      val K_Q_CACHE = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_K_Q", H * T_LOAD * HC     ), H, H, S_LOAD, 0,   S, HC,       HC)
      val K_S_CACHE = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_K_S", H * T_LOAD * HCT    ), H, H, S_LOAD, 0,   S, HCT,      HCT)
      // create interleaved QK arrays
      val QK_Q = Array.ofDim[Byte](LLAMA_L, H * 2 * T * HC)
      val QK_S = Array.ofDim[Byte](LLAMA_L, H * 2 * T * HCT)

      for(l <- 0 until LLAMA_L; h <- 0 until H; qk <- 0 until 2; t <- 0 until T){
        for(hc <- 0 until HC){
          val GLOBAL_INDEX = h*2*T*HC + qk*T*HC + t*HC + hc
          val LOCAL_INDEX  = h  *T*HC +           t*HC + hc
          QK_Q(l)(GLOBAL_INDEX) = (if (qk == 0) Q_Q else K_Q)(l)(LOCAL_INDEX)
        }
        for(hct <- 0 until HCT){
          val GLOBAL_INDEX = h*2*T*HCT + qk*T*HCT + t*HCT + hct
          val LOCAL_INDEX  = h  *T*HCT +            t*HCT + hct
          QK_S(l)(GLOBAL_INDEX) = (if (qk == 0) Q_S else K_S)(l)(LOCAL_INDEX)
        }
      }

      // overwrite K cache, for s>POS
      for(l <- 0 until LLAMA_L; h <- 0 until H; s <- POS until S){
        for(hc <- 0 until HC){
          K_Q_CACHE(l)(h*S*HC + s*HC + hc) = 0;
        }
        for(hct <- 0 until HCT){
          K_S_CACHE(l)(h*S*HCT + s*HCT + hct) = 0;
        }
      }

      // DUT array
      val DUT_R  = Array.ofDim[Long](LLAMA_L, H * T * S)
      val DUT_KQ = Array.ofDim[Byte](LLAMA_L, H * T * HC)
      val DUT_KS = Array.ofDim[Byte](LLAMA_L, H * T * HCT)

      // initialize streams
      init_i_stream(dut.io.qk_q_stream)
      init_i_stream(dut.io.qk_s_stream)
      init_o_stream(dut.io.r_stream)
      init_daisy_chain(dut.io.signals)

      // fork clock
      init_clock(dut.clockDomain, 10)
      // threads
      // @formatter:off
      Array(
        fork{
          dut.io.signals.I.L_BEGIN #= L_BEGIN
          dut.io.signals.I.L_CLOSE #= L_CLOSE
          dut.io.signals.I.POS_ID #= POS
          // delay 20 cycles to make sure the signals are set
          dut.clockDomain.waitSampling(20)
          // launch with trigger
          dut.io.signals.I.T #= true
          dut.clockDomain.waitSampling()
          dut.io.signals.I.T #= false
        },
        // input
        fork {  for(l <- L_BEGIN until L_CLOSE) array2stream(dut.io.qk_q_stream,       dut.clockDomain, QK_Q(l),      1,      2*H,  T,    T,    HC,    CP,    unpack=true, info = "Q_Q")},
        fork {  for(l <- L_BEGIN until L_CLOSE) array2stream(dut.io.qk_s_stream,       dut.clockDomain, QK_S(l),      1,      2*H,  T,    T,    HCT,   1,     unpack=true, info = "Q_S")},
        fork {  for(l <- L_BEGIN until L_CLOSE) array2stream(dut.io.kq_cache_i_stream, dut.clockDomain, K_Q_CACHE(l), 1,      H,    S,    1,    HC,    CP,    info = "K_Q_CACHE")},
        fork {  for(l <- L_BEGIN until L_CLOSE) array2stream(dut.io.ks_cache_i_stream, dut.clockDomain, K_S_CACHE(l), 1,      H,    S,    1,    HCT,   1,     info = "K_S_CACHE")},
        fork {  for(l <- L_BEGIN until L_CLOSE) stream2array(dut.io.r_stream,          dut.clockDomain, R(l),   DUT_R(l),     H,    T,    TP,    S,    SP,    verbose=true, info = "R", compare=false)},
        fork {  for(l <- L_BEGIN until L_CLOSE) stream2array(dut.io.kq_cache_o_stream, dut.clockDomain, K_Q(l), DUT_KQ(l),    H,    T,    1,     HC,   CP,    info = "K_Q_CACHE")},
        fork {  for(l <- L_BEGIN until L_CLOSE) stream2array(dut.io.ks_cache_o_stream, dut.clockDomain, K_S(l), DUT_KS(l),    H,    T,    1,     HCT,  1,     info = "K_S_CACHE")}
      ).foreach(_.join())

      // compare R and DUT_R, manually, for only s<POS+T
      for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; t <- 0 until T; s <- 0 until POS+T){
        val idx = h*T*S + t*S + s
        if (R(l)(idx) != DUT_R(l)(idx)){
          println(f"At l=$l%2d, h=$h%2d, t=$t%4d, s=$s%4d, R=${R(l)(idx)}%8d, DUT_R=${DUT_R(l)(idx)}%8d")
        }
      }

      simSuccess()
    }
}

