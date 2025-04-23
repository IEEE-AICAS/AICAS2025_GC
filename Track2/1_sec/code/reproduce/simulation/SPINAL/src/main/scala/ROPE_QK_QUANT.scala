import spinal.core.sim._
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.bus.amba4.axis.Axi4Stream
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream

import scala.language.postfixOps

// @formatter:off
class ROPE_QK_QUANT_Blackbox extends BlackBox {
  val top_name: String = "ROPE_QK_QUANT"
  setDefinitionName(top_name)
  private val verilog_file_path: String = s"src/main/verilog/$top_name/all.v"
  val io = new Bundle {
    val ap_clk:       Bool = in Bool()
    val ap_rst_n:     Bool = in Bool()

    val pos_id:       UInt = in UInt (ctrl_cfg.POS_BITS bits)
    val l_begin:      UInt = in UInt (ctrl_cfg.L_BITS bits)
    val l_close:      UInt = in UInt (ctrl_cfg.L_BITS bits)

    val ap_ctrl:      ApChain = slave(ApChain())
    val qk_stream:    BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("qk_stream",    verilog_file_path)))
    val rot_q_stream: BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("rot_q_stream", verilog_file_path)))
    val rot_s_stream: BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("rot_s_stream", verilog_file_path)))
  }
  // no io prefix, this is essential for name matching
  noIoPrefix()
  ApChainRenamer(io.ap_ctrl)
  mapClockDomain(clock = io.ap_clk, reset = io.ap_rst_n, resetActiveLevel = LOW)
  addRTLPath(verilog_file_path)
}

class ROPE_QK_QUANT extends Component {
  val top_name: String = "ROPE_QK_QUANT"
  setDefinitionName(top_name + "_wrapper")
  private val black_box = new ROPE_QK_QUANT_Blackbox
  val io = new Bundle {
    val signals:      DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
    val qk_stream:    Axi4Stream = slave (Axi4Stream(black_box.io.qk_stream   .config.to_std_config()))
    val rot_q_stream: Axi4Stream = master(Axi4Stream(black_box.io.rot_q_stream.config.to_std_config()))
    val rot_s_stream: Axi4Stream = master(Axi4Stream(black_box.io.rot_s_stream.config.to_std_config()))
  }
  noIoPrefix()

  val manager = new Manager
  manager.io.signals           <> io.signals
  manager.io.ap_ctrl           <> black_box.io.ap_ctrl
  manager.io.signals.O.POS_ID     <> black_box.io.pos_id
  manager.io.signals.O.L_BEGIN <> black_box.io.l_begin
  manager.io.signals.O.L_CLOSE <> black_box.io.l_close

  black_box.io.qk_stream   .connect2std(io.qk_stream)
  black_box.io.rot_q_stream.connect2std(io.rot_q_stream)
  black_box.io.rot_s_stream.connect2std(io.rot_s_stream)

  Axi4StreamSpecRenamer(io.qk_stream)
  Axi4StreamSpecRenamer(io.rot_q_stream)
  Axi4StreamSpecRenamer(io.rot_s_stream)
}


object simulate_rope_qk_quant extends App {
  redirect_std("ROPE_QK_QUANT.log")

  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )
  spinalConfig.generateVerilog(new ROPE_QK_QUANT)

  SimConfig
    .withConfig(spinalConfig)
    .withFstWave
    .withWaveDepth(2)
    .allOptimisation
    .withVerilator
    .addSimulatorFlag("--unroll-count 1024")
    .addSimulatorFlag("-j 16")
    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
    .compile(new ROPE_QK_QUANT)
    .doSimUntilVoid { dut =>
      // some hyper parameters

      val G = 8
      val L = 4

      val T = 8
      val C = 896
      val CP = G
      val CT = C / CP

      val POS_OFFSET = 96

      val data_path_prefix = ctrl_cfg.condense_prefix
      val format_str = s"$data_path_prefix%d/%s.bin"
      // arrays
      // @formatter:off
      val REF_CONDENSED_QK      = read_multi_int64_files(format_str, L, "CONDENSED_DEMUX_QK",            2 * T * C)
      val REF_CONDENSED_QKROT_Q = read_multi_int8_files (format_str, L, "CONDENSED_ROPE_QK_QUANT_ROT_Q", 2 * T * C)
      val REF_CONDENSED_QKROT_S = read_multi_int8_files (format_str, L, "CONDENSED_ROPE_QK_QUANT_ROT_S", 2 * T * CT)
      val DUT_CONDENSED_QKROT_Q = Array.ofDim[Byte](L, 2 * T * C)
      val DUT_CONDENSED_QKROT_S = Array.ofDim[Byte](L, 2 * T * CT)
      // @formatter:on

      // init ap_ctrl and streams
      init_i_stream(dut.io.qk_stream)
      init_o_stream(dut.io.rot_q_stream)
      init_o_stream(dut.io.rot_s_stream)
      init_daisy_chain(dut.io.signals)

      // fork clock
      init_clock(dut.clockDomain, 10)
      // threads
      Array(
        fork {
          dut.io.signals.I.L_BEGIN #= 0
          dut.io.signals.I.L_CLOSE #= L
          dut.io.signals.I.POS_ID #= 96
          // delay 20 cycles to make sure the signals are set
          dut.clockDomain.waitSampling(20)
          // launch with trigger
          dut.io.signals.I.T #= true
          dut.clockDomain.waitSampling()
          dut.io.signals.I.T #= false
        },
        // @formatter:off
        fork {
          for (l <- 0 until L) array2stream(dut.io.qk_stream,    dut.clockDomain, REF_CONDENSED_QK(l),      1,                        1, 1, 1, 2*T*C, CP, info="input stream", verbose=true, random_stall=false)
        },
        fork {
          for (l <- 0 until L) stream2array(dut.io.rot_q_stream, dut.clockDomain, REF_CONDENSED_QKROT_Q(l), DUT_CONDENSED_QKROT_Q(l), 1, 1, 1, 2*T*C, CP, info="rot_q stream")
        },
        fork {
          for (l <- 0 until L) stream2array(dut.io.rot_s_stream, dut.clockDomain, REF_CONDENSED_QKROT_S(l), DUT_CONDENSED_QKROT_S(l), 1, 1, 1, 2*T*CT, 1, info="rot_s stream")
        }
        // @formatter:on
      ).foreach(_.join())

      // at end, with 100 cycles
      dut.clockDomain.waitSampling(100)
      simSuccess()
    }
}

