import spinal.core.sim._
import spinal.core._
import spinal.lib.bus.amba4.axis.Axi4Stream
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream
import spinal.lib.{master, slave}
import utils._

import scala.language.postfixOps

// @formatter:off
class SOFTMAX_QUANT_Blackbox extends BlackBox {
  val top_name: String = "SOFTMAX_QUANT"
  setDefinitionName(top_name)
  private val verilog_file_path: String = s"src/main/verilog/$top_name/all.v"
  val io = new Bundle {
    val ap_clk: Bool = in Bool()
    val ap_rst_n: Bool = in Bool()

    val l_begin: UInt = in  UInt(ctrl_cfg.L_BITS bits)
    val l_close: UInt = in  UInt(ctrl_cfg.L_BITS bits)
    val pos_id:  UInt = in  UInt(ctrl_cfg.POS_BITS bits)

    val ap_ctrl:    ApChain      = slave  (ApChain())
    val r_stream:   BlackboxAxis = slave  (BlackboxAxis(BlackboxAxisConfig("r_stream",  verilog_file_path)))
    val rq_stream:  BlackboxAxis = master (BlackboxAxis(BlackboxAxisConfig("rq_stream", verilog_file_path)))
    val rs_stream:  BlackboxAxis = master (BlackboxAxis(BlackboxAxisConfig("rs_stream", verilog_file_path)))
    // @formatter:on
  }
  noIoPrefix()
  ApChainRenamer(io.ap_ctrl)
  mapClockDomain(clock = io.ap_clk, reset = io.ap_rst_n, resetActiveLevel = LOW)
  addRTLPath(verilog_file_path)
}

class SOFTMAX_QUANT extends Component {
  val top_name: String = "SOFTMAX_QUANT"
  setDefinitionName(top_name + "_wrapper")
  private val black_box = new SOFTMAX_QUANT_Blackbox
  val io = new Bundle {
    val signals: DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
    val r_stream:   Axi4Stream = slave (Axi4Stream(black_box.io.r_stream. config.to_std_config()))
    val rq_stream:  Axi4Stream = master(Axi4Stream(black_box.io.rq_stream.config.to_std_config()))
    val rs_stream:  Axi4Stream = master(Axi4Stream(black_box.io.rs_stream.config.to_std_config()))
  }
  noIoPrefix()

  val manager = new Manager
  manager.io.signals            <> io.signals
  manager.io.ap_ctrl            <> black_box.io.ap_ctrl
  manager.io.signals.O.L_BEGIN  <> black_box.io.l_begin
  manager.io.signals.O.L_CLOSE  <> black_box.io.l_close
  manager.io.signals.O.POS_ID      <> black_box.io.pos_id

  black_box.io.r_stream .connect2std(io.r_stream)
  black_box.io.rq_stream.connect2std(io.rq_stream)
  black_box.io.rs_stream.connect2std(io.rs_stream)

  Axi4StreamSpecRenamer(io.r_stream)
  Axi4StreamSpecRenamer(io.rq_stream)
  Axi4StreamSpecRenamer(io.rs_stream)
}

object simulate_softmax_quant extends App {
  redirect_std("SOFTMAX_QUANT.log")

  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )

  SimConfig
    .withConfig(spinalConfig)
    .withFstWave
    .allOptimisation
    .withVerilator
    .addSimulatorFlag("--unroll-count 1024")
    .addSimulatorFlag("-j 16")
    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
    .compile(new SOFTMAX_QUANT)
    .doSimUntilVoid { dut =>

      val LLAMA_L = 24

      // simulation hyperparameters
      val L_BEGIN = 0
      val L_CLOSE = LLAMA_L
      val T_LOAD = 128
      val S_LOAD = 128
      val POS = 96

      // model hyperparameters
      val H = 14

      // design hyperparameters
      val T = 8
      val TP = 1
      val S = 256
      val SP = 8 // interface parallelism, actually the hardware parallelism is 2

      // derived hyperparameters
      val ST = S / SP
      val ST_LOAD = S_LOAD / SP

      // arrays
      val data_path_prefix = ctrl_cfg.binaries_prefix
      val format_str = s"$data_path_prefix%d/%s.bin"

      val REF_R        = cut_array[Long](read_multi_int64_files(format_str, LLAMA_L, "MHA_R",         H * T_LOAD * S_LOAD ), H, H, T_LOAD, POS, T, S_LOAD,  S)
      val REF_R_Q      = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_R_Q",       H * T_LOAD * S_LOAD ), H, H, T_LOAD, POS, T, S_LOAD,  S)
      val REF_R_S      = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_R_S",       H * T_LOAD * ST_LOAD), H, H, T_LOAD, POS, T, ST_LOAD, ST)
      val DUT_R_Q      = Array.ofDim[Byte](LLAMA_L, H * T * S)
      val DUT_R_S      = Array.ofDim[Byte](LLAMA_L, H * T * ST)

      // init ap_ctrl and streams
      init_i_stream(dut.io.r_stream)
      init_o_stream(dut.io.rq_stream)
      init_o_stream(dut.io.rs_stream)
      init_daisy_chain(dut.io.signals)
      // fork clock
      init_clock(dut.clockDomain, 10)
      // threads
      Array(
        fork {
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
        fork {
          for (l <- L_BEGIN until L_CLOSE) array2stream(dut.io.r_stream,  dut.clockDomain, REF_R(l), 1,            H, T, TP, S, SP)
        },
        fork {
          for (l <- L_BEGIN until L_CLOSE) stream2array(dut.io.rq_stream, dut.clockDomain, REF_R_Q(l), DUT_R_Q(l), H, T, TP, S, SP)
        },
        fork {
          for (l <- L_BEGIN until L_CLOSE) stream2array(dut.io.rs_stream, dut.clockDomain, REF_R_S(l), DUT_R_S(l), H, T, TP, ST, 1, verbose = true, info="Output R_S")
        }
        // @formatter:on
      ).foreach(_.join())
      simSuccess()
    }
}
