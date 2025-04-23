import spinal.core.sim._
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.bus.amba4.axis.Axi4Stream
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream

import scala.language.postfixOps

// @formatter:off
class DEMUX_Blackbox extends BlackBox {
  val top_name: String = "DEMUX"
  setDefinitionName(top_name)
  private val verilog_file_path: String = s"src/main/verilog/$top_name/all.v"
  val io = new Bundle {
    val ap_clk:       Bool = in Bool()
    val ap_rst_n:     Bool = in Bool()

    val l_begin:      UInt = in UInt(ctrl_cfg.L_BITS bits)
    val l_close:      UInt = in UInt(ctrl_cfg.L_BITS bits)

    val ap_ctrl:      ApChain = slave(ApChain())
    val gemm_stream:  BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("gemm_stream",  verilog_file_path)))
    val qk_stream:    BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("qk_stream",    verilog_file_path)))
    val v_stream:     BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("v_stream",     verilog_file_path)))
    val ug_stream:    BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("ug_stream",    verilog_file_path)))
    val od_stream:    BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("od_stream",    verilog_file_path)))
    val cls_stream:   BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("cls_stream",   verilog_file_path)))
  }
  noIoPrefix()
  ApChainRenamer(io.ap_ctrl)
  mapClockDomain(clock = io.ap_clk, reset = io.ap_rst_n, resetActiveLevel = LOW)
  addRTLPath(verilog_file_path)
}

class DEMUX extends Component {
  val top_name: String = "DEMUX"
  setDefinitionName(top_name + "_wrapper")
  private val black_box = new DEMUX_Blackbox
  val io = new Bundle {
    val signals: DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
    val gemm_stream:  Axi4Stream = slave (Axi4Stream(black_box.io.gemm_stream.config.to_std_config()))
    val qk_stream:    Axi4Stream = master(Axi4Stream(black_box.io.qk_stream  .config.to_std_config()))
    val v_stream:     Axi4Stream = master(Axi4Stream(black_box.io.v_stream   .config.to_std_config()))
    val ug_stream:    Axi4Stream = master(Axi4Stream(black_box.io.ug_stream  .config.to_std_config()))
    val od_stream:    Axi4Stream = master(Axi4Stream(black_box.io.od_stream  .config.to_std_config()))
    val cls_stream:   Axi4Stream = master(Axi4Stream(black_box.io.cls_stream .config.to_std_config()))
  }
  noIoPrefix()
  val manager = new Manager
  manager.io.signals            <> io.signals
  manager.io.ap_ctrl            <> black_box.io.ap_ctrl
  manager.io.signals.O.L_BEGIN  <> black_box.io.l_begin
  manager.io.signals.O.L_CLOSE  <> black_box.io.l_close
  black_box.io.gemm_stream.connect2std(io.gemm_stream)
  black_box.io.qk_stream  .connect2std(io.qk_stream)
  black_box.io.v_stream   .connect2std(io.v_stream)
  black_box.io.ug_stream  .connect2std(io.ug_stream)
  black_box.io.od_stream  .connect2std(io.od_stream)
  black_box.io.cls_stream .connect2std(io.cls_stream)

  Axi4StreamSpecRenamer(io.gemm_stream)
  Axi4StreamSpecRenamer(io.qk_stream)
  Axi4StreamSpecRenamer(io.v_stream)
  Axi4StreamSpecRenamer(io.ug_stream)
  Axi4StreamSpecRenamer(io.od_stream)
}

object simulate_demux extends App {
  redirect_std("DEMUX.log")

  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )
  spinalConfig.generateVerilog(new DEMUX)

  SimConfig
    .withConfig(spinalConfig)
    .withFstWave
    .withWaveDepth(2)
    .allOptimisation
    .withVerilator
    .addSimulatorFlag("--unroll-count 1024")
    .addSimulatorFlag("-j 16")
    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
    .compile(new DEMUX)
    .doSimUntilVoid { dut =>

      // simulation hyperparameters
      val L = 1

      // model hyperparameters
      val C = 896
      val CM = 4864

      // design hyperparameters
      val T = 8
      val G = 8
      val CP = G

      // derived hyperparameters
      val CT = C / CP
      val CMT = CM / CP
      val NUM_Y = 3*T*C + T*C + 2*T*CM + T*C

      val data_path_prefix = ctrl_cfg.condense_prefix
      val format_str = s"$data_path_prefix%d/%s.bin"

      val REF_CONDENSED_GEMM_Y = read_multi_int64_files(format_str, L, "CONDENSED_GEMM_Y",       NUM_Y)
      val REF_CONDENSED_QK     = read_multi_int64_files(format_str, L, "CONDENSED_DEMUX_QK",     2*T*C)
      val REF_CONDENSED_V      = read_multi_int64_files(format_str, L, "CONDENSED_DEMUX_V",        T*C)
      val REF_CONDENSED_UG     = read_multi_int64_files(format_str, L, "CONDENSED_DEMUX_UG",     2*T*CM)
      val REF_CONDENSED_OD     = read_multi_int64_files(format_str, L, "CONDENSED_DEMUX_OD",     2*T*C)

      val DUT_CONDENSED_QK     = Array.ofDim[Long](L, 2*T*C)
      val DUT_CONDENSED_V      = Array.ofDim[Long](L, T*C)
      val DUT_CONDENSED_UG     = Array.ofDim[Long](L, 2*T*CM)
      val DUT_CONDENSED_OD     = Array.ofDim[Long](L, 2*T*C)

      // init ap_ctrl and streams
      init_i_stream(dut.io.gemm_stream)
      init_o_stream(dut.io.qk_stream)
      init_o_stream(dut.io.v_stream)
      init_o_stream(dut.io.ug_stream)
      init_o_stream(dut.io.od_stream)
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
          for (l <- 0 until L) array2stream(dut.io.gemm_stream, dut.clockDomain, REF_CONDENSED_GEMM_Y(l), 1, 1, 1, 1, NUM_Y,  CP,info="gemm_stream")
        },
        fork {
          for (l <- 0 until L) stream2array(dut.io.qk_stream,   dut.clockDomain, REF_CONDENSED_QK(l), DUT_CONDENSED_QK(l),     1, 1, 1, 2*T*C,  CP,info="qk_stream")
        },
        fork {
          for (l <- 0 until L) stream2array(dut.io.v_stream,    dut.clockDomain, REF_CONDENSED_V(l),  DUT_CONDENSED_V(l),      1, 1, 1,   T*C,  CP,info="v_stream")
        },
        fork {
          for (l <- 0 until L) stream2array(dut.io.ug_stream,   dut.clockDomain, REF_CONDENSED_UG(l), DUT_CONDENSED_UG(l),     1, 1, 1, 2*T*CM, CP,info="ug_stream")
        },
        fork {
          for (l <- 0 until L) stream2array(dut.io.od_stream,   dut.clockDomain, REF_CONDENSED_OD(l), DUT_CONDENSED_OD(l),     1, 1, 1, 2*T*C,  CP,info="od_stream")
        }
        // @formatter:on
      ).foreach(_.join())

      // at end, with 100 cycles
      dut.clockDomain.waitSampling(100)
      simSuccess()
    }
}

