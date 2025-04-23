import spinal.core.sim._
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.bus.amba4.axis.Axi4Stream
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream

import scala.language.postfixOps

// @formatter:off
class RV_GEMM_Blackbox extends BlackBox {
  val top_name: String = "RV_GEMM"
  setDefinitionName(top_name)
  private val verilog_file_path: String = s"src/main/verilog/$top_name/all.v"
  val io = new Bundle {
    val ap_clk:     Bool = in Bool()
    val ap_rst_n:   Bool = in Bool()

    val l_begin:    UInt = in UInt(ctrl_cfg.L_BITS bits)
    val l_close:    UInt = in UInt(ctrl_cfg.L_BITS bits)
    val pos_id:     UInt = in UInt(ctrl_cfg.POS_BITS bits)

    val ap_ctrl:            ApChain      = slave  (ApChain())
    val rq_stream:          BlackboxAxis = slave  (BlackboxAxis(BlackboxAxisConfig("rq_stream",         verilog_file_path)))
    val rs_stream:          BlackboxAxis = slave  (BlackboxAxis(BlackboxAxisConfig("rs_stream",         verilog_file_path)))
    val v_stream:           BlackboxAxis = slave  (BlackboxAxis(BlackboxAxisConfig("v_stream",          verilog_file_path)))  // v is not quantized
    val vq_cache_i_stream:  BlackboxAxis = slave  (BlackboxAxis(BlackboxAxisConfig("vq_cache_i_stream", verilog_file_path)))
    val vs_cache_i_stream:  BlackboxAxis = slave  (BlackboxAxis(BlackboxAxisConfig("vs_cache_i_stream", verilog_file_path)))
    val vq_cache_o_stream:  BlackboxAxis = master (BlackboxAxis(BlackboxAxisConfig("vq_cache_o_stream", verilog_file_path)))
    val vs_cache_o_stream:  BlackboxAxis = master (BlackboxAxis(BlackboxAxisConfig("vs_cache_o_stream", verilog_file_path)))
    val aq_stream:          BlackboxAxis = master (BlackboxAxis(BlackboxAxisConfig("aq_stream",         verilog_file_path)))
    val as_stream:          BlackboxAxis = master (BlackboxAxis(BlackboxAxisConfig("as_stream",         verilog_file_path)))
  }
  // no io prefix, this is essential for name matching
  noIoPrefix()
  ApChainRenamer(io.ap_ctrl)
  mapClockDomain(clock = io.ap_clk, reset = io.ap_rst_n, resetActiveLevel = LOW)
  addRTLPath(verilog_file_path)
}

class RV_GEMM extends Component {
  val top_name: String = "RV_GEMM"
  setDefinitionName(top_name + "_wrapper")
  private val black_box = new RV_GEMM_Blackbox
  val io = new Bundle {
    val signals: DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
    val rq_stream:          Axi4Stream = slave (Axi4Stream(black_box.io.rq_stream        .config.to_std_config()))
    val rs_stream:          Axi4Stream = slave (Axi4Stream(black_box.io.rs_stream        .config.to_std_config()))
    val v_stream:           Axi4Stream = slave (Axi4Stream(black_box.io.v_stream         .config.to_std_config()))
    val vq_cache_i_stream:  Axi4Stream = slave (Axi4Stream(black_box.io.vq_cache_i_stream.config.to_std_config()))
    val vs_cache_i_stream:  Axi4Stream = slave (Axi4Stream(black_box.io.vs_cache_i_stream.config.to_std_config()))
    val vq_cache_o_stream:  Axi4Stream = master(Axi4Stream(black_box.io.vq_cache_o_stream.config.to_std_config()))
    val vs_cache_o_stream:  Axi4Stream = master(Axi4Stream(black_box.io.vs_cache_o_stream.config.to_std_config()))
    val aq_stream:          Axi4Stream = master(Axi4Stream(black_box.io.aq_stream        .config.to_std_config()))
    val as_stream:          Axi4Stream = master(Axi4Stream(black_box.io.as_stream        .config.to_std_config()))
  }
  noIoPrefix()
  val manager = new Manager
  manager.io.signals            <> io.signals
  manager.io.ap_ctrl            <> black_box.io.ap_ctrl
  manager.io.signals.O.L_BEGIN  <> black_box.io.l_begin
  manager.io.signals.O.L_CLOSE  <> black_box.io.l_close
  manager.io.signals.O.POS_ID      <> black_box.io.pos_id

  black_box.io.rq_stream        .connect2std(io.rq_stream)
  black_box.io.rs_stream        .connect2std(io.rs_stream)
  black_box.io.v_stream         .connect2std(io.v_stream)
  black_box.io.vq_cache_i_stream.connect2std(io.vq_cache_i_stream)
  black_box.io.vs_cache_i_stream.connect2std(io.vs_cache_i_stream)
  black_box.io.vq_cache_o_stream.connect2std(io.vq_cache_o_stream)
  black_box.io.vs_cache_o_stream.connect2std(io.vs_cache_o_stream)
  black_box.io.aq_stream        .connect2std(io.aq_stream)
  black_box.io.as_stream        .connect2std(io.as_stream)

  Axi4StreamSpecRenamer(io.rq_stream)
  Axi4StreamSpecRenamer(io.rs_stream)
  Axi4StreamSpecRenamer(io.v_stream)
  Axi4StreamSpecRenamer(io.vq_cache_i_stream)
  Axi4StreamSpecRenamer(io.vs_cache_i_stream)
  Axi4StreamSpecRenamer(io.vq_cache_o_stream)
  Axi4StreamSpecRenamer(io.vs_cache_o_stream)
  Axi4StreamSpecRenamer(io.aq_stream)
  Axi4StreamSpecRenamer(io.as_stream)
}

object simulate_rv_gemm extends App{
  redirect_std("RV_GEMM.log")

  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )
  spinalConfig.generateVerilog(new RV_GEMM)

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
    .compile(new RV_GEMM)
    .doSimUntilVoid { dut =>
      val LLAMA_L = 1

      // simulation hyperparameters
      val L_BEGIN: Int = 0
      val L_CLOSE: Int = 1
      val T_LOAD: Int = 128
      val S_LOAD: Int = 128
      val POS: Int = 96

      // model hyperparameters
      val LLAMA_C = 896
      val H = 14
      val C = LLAMA_C / H

      // design hyperparameters
      val G = 8
      val T = 8
      val TP = 1
      val CP = G
      val S = 256
      val SP = G

      // derived hyperparameters
      val CT = C / CP
      val ST = S / SP
      val TST = T / SP
      val ST_LOAD = S_LOAD / SP

      val data_path_prefix = ctrl_cfg.condense_prefix
      val format_str = s"$data_path_prefix%d/%s.bin"
      // arrays
      val REF_R_Q         = read_multi_int8_files (format_str, LLAMA_L, "CONDENSED_SOFTMAX_QUANT_R_Q",  H * T * S)
      val REF_R_S         = read_multi_int8_files (format_str, LLAMA_L, "CONDENSED_SOFTMAX_QUANT_R_S",  H * T * ST)
      val REF_V           = read_multi_int64_files(format_str, LLAMA_L, "CONDENSED_DEMUX_V",            H * T * C)
      val REF_VQ_CACHE_I  = read_multi_int8_files (format_str, LLAMA_L, "CONDENSED_RV_GEMM_V_Q_CACHE",  H * C * S)
      val REF_VS_CACHE_I  = read_multi_int8_files (format_str, LLAMA_L, "CONDENSED_RV_GEMM_V_S_CACHE",  H * C * ST)
      val REF_VQ_CACHE_O  = read_multi_int8_files (format_str, LLAMA_L, "CONDENSED_RV_GEMM_V_Q",        H * T * S)
      val REF_VS_CACHE_O  = read_multi_int8_files (format_str, LLAMA_L, "CONDENSED_RV_GEMM_V_S",        H * T * ST)
      val REF_AQ          = read_multi_int8_files (format_str, LLAMA_L, "CONDENSED_RV_GEMM_A_Q",        H * T * S)
      val REF_AS          = read_multi_int8_files (format_str, LLAMA_L, "CONDENSED_RV_GEMM_A_S",        H * T * ST)

      // DUT array
      val DUT_VQ_CACHE_O = Array.ofDim[Byte](LLAMA_L, H * T * S)
      val DUT_VS_CACHE_O = Array.ofDim[Byte](LLAMA_L, H * T * ST)
      val DUT_AQ         = Array.ofDim[Byte](LLAMA_L, H * T * S)
      val DUT_AS         = Array.ofDim[Byte](LLAMA_L, H * T * ST)

      // initialize streams
      init_i_stream(dut.io.rq_stream)
      init_i_stream(dut.io.rs_stream)
      init_i_stream(dut.io.v_stream)
      init_i_stream(dut.io.vq_cache_i_stream)
      init_i_stream(dut.io.vs_cache_i_stream)
      init_o_stream(dut.io.vq_cache_o_stream)
      init_o_stream(dut.io.vs_cache_o_stream)
      init_o_stream(dut.io.aq_stream)
      init_o_stream(dut.io.as_stream)
      init_daisy_chain(dut.io.signals)

      // fork clock
      init_clock(dut.clockDomain, 10)

      // threads
      Array(
        fork{
          dut.io.signals.I.L_BEGIN #= L_BEGIN
          dut.io.signals.I.L_CLOSE #= L_CLOSE
          dut.io.signals.I.POS_ID     #= POS
          // delay 20 cycles to make sure the signals are set
          dut.clockDomain.waitSampling(20)
          // launch with trigger
          dut.io.signals.I.T #= true
          dut.clockDomain.waitSampling()
          dut.io.signals.I.T #= false
        },
        fork{ for(l <- L_BEGIN until L_CLOSE) array2stream(dut.io.rq_stream,          dut.clockDomain, REF_R_Q(l),                          1, 1, 1, 1, H*T*S,  TP*SP, verbose=false, info="RQ") },
        fork{ for(l <- L_BEGIN until L_CLOSE) array2stream(dut.io.rs_stream,          dut.clockDomain, REF_R_S(l),                          1, 1, 1, 1, H*T*ST, TP   , verbose=false, info="RS") },
        fork{ for(l <- L_BEGIN until L_CLOSE) array2stream(dut.io.v_stream,           dut.clockDomain, REF_V(l),                            1, 1, 1, 1, H*T*C,     CP, verbose=false, info="V") },
        fork{ for(l <- L_BEGIN until L_CLOSE) array2stream(dut.io.vq_cache_i_stream,  dut.clockDomain, REF_VQ_CACHE_I(l),                   1, 1, 1, 1, H*C*S,     SP, verbose=false, info="VQ_CACHE_I") },
        fork{ for(l <- L_BEGIN until L_CLOSE) array2stream(dut.io.vs_cache_i_stream,  dut.clockDomain, REF_VS_CACHE_I(l),                   1, 1, 1, 1, H*C*ST,     1, verbose=false, info="VS_CACHE_I") },
        fork{ for(l <- L_BEGIN until L_CLOSE) stream2array(dut.io.vq_cache_o_stream,  dut.clockDomain, REF_VQ_CACHE_O(l), DUT_VQ_CACHE_O(l),   1, 1, 1, H*C*T,     SP, verbose=false, info="VQ_CACHE_O") },
        fork{ for(l <- L_BEGIN until L_CLOSE) stream2array(dut.io.vs_cache_o_stream,  dut.clockDomain, REF_VS_CACHE_O(l), DUT_VS_CACHE_O(l),   1, 1, 1, H*C*TST,    1, verbose=false, info="VS_CACHE_O") },
        fork{ for(l <- L_BEGIN until L_CLOSE) stream2array(dut.io.aq_stream,          dut.clockDomain, REF_AQ(l), DUT_AQ(l),                   1, 1, 1, H*T*C,  TP*CP, verbose=true, info="AQ") },
        fork{ for(l <- L_BEGIN until L_CLOSE) stream2array(dut.io.as_stream,          dut.clockDomain, REF_AS(l), DUT_AS(l),                   1, 1, 1, H*T*CT, TP   , verbose=false, info="AS") }
      ).foreach(_.join)

      simSuccess()
    }
}