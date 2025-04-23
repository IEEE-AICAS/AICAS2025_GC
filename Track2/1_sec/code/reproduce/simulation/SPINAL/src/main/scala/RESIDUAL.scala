import spinal.core.sim._
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.bus.amba4.axis.Axi4Stream
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream

import scala.language.postfixOps

// @formatter:off
class RESIDUAL_Blackbox extends BlackBox {
  val top_name: String = "RESIDUAL"
  setDefinitionName(top_name)
  private val verilog_file_path: String = s"src/main/verilog/$top_name/all.v"
  val io = new Bundle {
    val ap_clk:   Bool = in Bool()
    val ap_rst_n: Bool = in Bool()

    val l_begin: UInt = in UInt (32 bits)
    val l_close: UInt = in UInt (32 bits)

    val ap_ctrl:      ApChain = slave(ApChain())
    val x_stream:     BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("x_stream",     verilog_file_path)))
    val res_i_stream: BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("res_i_stream", verilog_file_path)))
    val res_o_stream: BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("res_o_stream", verilog_file_path)))
    val y_stream:     BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("y_stream",     verilog_file_path)))
  }
  noIoPrefix()
  ApChainRenamer(io.ap_ctrl)
  mapClockDomain(clock = io.ap_clk, reset = io.ap_rst_n, resetActiveLevel = LOW)
  addRTLPath(verilog_file_path)
}

class RESIDUAL extends Component {
  val top_name: String = "RESIDUAL"
  setDefinitionName(top_name + "_wrapper")
  private val black_box = new RESIDUAL_Blackbox
  val io = new Bundle {
    val signals: DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
    val x_stream:     Axi4Stream = slave (Axi4Stream(black_box.io.x_stream    .config.to_std_config()))
    val res_i_stream: Axi4Stream = slave (Axi4Stream(black_box.io.res_i_stream.config.to_std_config()))
    val res_o_stream: Axi4Stream = master(Axi4Stream(black_box.io.res_o_stream.config.to_std_config()))
    val y_stream:     Axi4Stream = master(Axi4Stream(black_box.io.y_stream    .config.to_std_config()))
  }
  noIoPrefix()
  val manager = new Manager
  manager.io.signals            <> io.signals
  manager.io.ap_ctrl            <> black_box.io.ap_ctrl
  manager.io.signals.O.L_BEGIN  <> black_box.io.l_begin
  manager.io.signals.O.L_CLOSE  <> black_box.io.l_close

  black_box.io.x_stream    .connect2std(io.x_stream)
  black_box.io.res_i_stream.connect2std(io.res_i_stream)
  black_box.io.res_o_stream.connect2std(io.res_o_stream)
  black_box.io.y_stream    .connect2std(io.y_stream)

  Axi4StreamSpecRenamer(io.x_stream)
  Axi4StreamSpecRenamer(io.res_i_stream)
  Axi4StreamSpecRenamer(io.res_o_stream)
  Axi4StreamSpecRenamer(io.y_stream)
}

object simulate_residual extends App {
  redirect_std("RESIDUAL.log")

  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )
  spinalConfig.generateVerilog(new RESIDUAL)

  SimConfig
    .withConfig(spinalConfig)
    .withFstWave
    .withWaveDepth(2)
    .allOptimisation
    .withVerilator
    .addSimulatorFlag("--unroll-count 1024")
    .addSimulatorFlag("-j 16")
    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
    .compile(new RESIDUAL)
    .doSimUntilVoid { dut =>

      // simulation hyperparameters
      val L = 24

      // model hyperparameters
      val C = 896

      // design hyperparameters
      val G = 8
      val T = 8
      val TP = 1
      val CP = G

      val data_path_prefix = ctrl_cfg.condense_prefix

      val format_str = s"$data_path_prefix%d/%s.bin"
      val REF_CONDENSED_X      = read_int64_file(ctrl_cfg.condense_prefix + "0/CONDENSED_RESIDUAL_X.bin", T*C)
      val REF_CONDENSED_RES_I  = read_multi_int64_files(format_str, L,    "CONDENSED_RESIDUAL_I",       2*T*C)
      val REF_CONDENSED_RES_O  = read_multi_int64_files(format_str, L,    "CONDENSED_RESIDUAL_O",     2*T*C)
      val REF_CONDENSED_Y      = read_int64_file(format_str.format(L-1,   "CONDENSED_RESIDUAL_Y"),      T*C)

      val DUT_CONDENSED_RES_O  = Array.ofDim[Long](L, L*2*T*C)
      val DUT_CONDENSED_Y      = Array.ofDim[Long](T*C)

      // init ap_ctrl and streams
      init_i_stream(dut.io.x_stream)
      init_i_stream(dut.io.res_i_stream)
      init_o_stream(dut.io.res_o_stream)
      init_o_stream(dut.io.y_stream)

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
        fork {
          array2stream(dut.io.x_stream,     dut.clockDomain, REF_CONDENSED_X,     1,                    1, T, TP, C,     CP,  info="x stream", verbose=true)
        },
        fork {
          for(l <- 0 until L) array2stream(dut.io.res_i_stream, dut.clockDomain, REF_CONDENSED_RES_I(l), 1,                      1, 1, 1, 2*T*C,    CP,  info="res_i stream", verbose=true)
        },
        fork {
          for(l <- 0 until L) stream2array(dut.io.res_o_stream, dut.clockDomain, REF_CONDENSED_RES_O(l), DUT_CONDENSED_RES_O(l), 1, 1, 1, 2*T*C, TP*CP,  info="res_o stream")
        },
        fork {
          stream2array(dut.io.y_stream,     dut.clockDomain, REF_CONDENSED_Y,     DUT_CONDENSED_Y,     1, 1, 1,     T*C, TP*CP,  info="y stream")
        }
        // @formatter:on
      ).foreach(_.join())

      dut.clockDomain.waitSampling(100)
      simSuccess()
    }
}

