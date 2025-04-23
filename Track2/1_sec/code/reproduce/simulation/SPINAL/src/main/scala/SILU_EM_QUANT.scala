import spinal.core.sim._
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.bus.amba4.axis.Axi4Stream
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream

import scala.language.postfixOps

// @formatter:off
class SILU_EM_QUANT_Blackbox extends BlackBox {
  val top_name: String = "SILU_EM_QUANT"
  setDefinitionName(top_name)
  private val verilog_file_path: String = s"src/main/verilog/$top_name/all.v"
  val io = new Bundle {
    val ap_clk:     Bool = in Bool()
    val ap_rst_n:   Bool = in Bool()

    val l_begin:    UInt = in  UInt(ctrl_cfg.L_BITS bits)
    val l_close:    UInt = in  UInt(ctrl_cfg.L_BITS bits)

    val ap_ctrl:    ApChain = slave(ApChain())
    val ug_stream:  BlackboxAxis = slave(BlackboxAxis(BlackboxAxisConfig("ug_stream", verilog_file_path)))
    val q_stream:   BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("q_stream", verilog_file_path)))
    val s_stream:   BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("s_stream", verilog_file_path)))
  }
  noIoPrefix()
  ApChainRenamer(io.ap_ctrl)
  mapClockDomain(clock = io.ap_clk, reset = io.ap_rst_n, resetActiveLevel = LOW)
  addRTLPath(verilog_file_path)
}

class SILU_EM_QUANT extends Component {
  val top_name: String = "SILU_EM_QUANT"
  setDefinitionName(top_name + "_wrapper")
  private val black_box = new SILU_EM_QUANT_Blackbox
  val io = new Bundle {
    val signals: DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
    val ug_stream: Axi4Stream = slave(Axi4Stream(black_box.io.ug_stream.config.to_std_config()))
    val q_stream: Axi4Stream = master(Axi4Stream(black_box.io.q_stream.config.to_std_config()))
    val s_stream: Axi4Stream = master(Axi4Stream(black_box.io.s_stream.config.to_std_config()))
  }
  noIoPrefix()

  val manager = new Manager
  manager.io.signals            <> io.signals
  manager.io.ap_ctrl            <> black_box.io.ap_ctrl
  manager.io.signals.O.L_BEGIN  <> black_box.io.l_begin
  manager.io.signals.O.L_CLOSE  <> black_box.io.l_close
  black_box.io.ug_stream.connect2std(io.ug_stream)
  black_box.io.q_stream .connect2std(io.q_stream)
  black_box.io.s_stream .connect2std(io.s_stream)

  Axi4StreamSpecRenamer(io.ug_stream)
  Axi4StreamSpecRenamer(io.q_stream)
  Axi4StreamSpecRenamer(io.s_stream)
}

object simulate_silu_em_quant extends App {
  redirect_std("SILU_EM_QUANT.log")

  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )
  spinalConfig.generateVerilog(new SILU_EM_QUANT)

  SimConfig
    .withConfig(spinalConfig)
    .withFstWave
    .allOptimisation
    .withVerilator
    .addSimulatorFlag("--unroll-count 1024")
    .addSimulatorFlag("-j 16")
    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
    .compile(new SILU_EM_QUANT)
    .doSimUntilVoid { dut =>

      // simulation hyperparameters
      val L = 2
      val T_LOAD = 128

      // model hyperparameters
      val H = 14
      val C = 896

      // design hyperparameters
      val T = 8
      val GEMM_TP = T // fully unrolled in GEMM
      val G = 8
      val CP = G

      // derived hyperparameters
      val TT = T / GEMM_TP
      val CT = C / CP

      val data_path_prefix = ctrl_cfg.binaries_prefix
      val format_str = s"$data_path_prefix%d/%s.bin"
      // ref arrays
      val REF_XU    = read_multi_int64_files(format_str, L, "MLP_XU",   T * C)
      val REF_XG    = read_multi_int64_files(format_str, L, "MLP_XG",   T * C)
      val REF_XM_Q  = read_multi_int8_files (format_str, L, "MLP_XM_Q", T * C)
      val REF_XM_S  = read_multi_int8_files (format_str, L, "MLP_XM_S", T * CT)
      // dut arrays
      val DUT_XM_Q  = Array.ofDim[Byte](L, T * C)
      val DUT_XM_S  = Array.ofDim[Byte](L, T * CT)
      // merge XU and XG
      val REF_UG = Array.ofDim[Long](L, 2 * T * C)
      // handcrafted permutation
      for(l <- 0 until L; tt <- 0 until TT; ct <- 0 until CT; ug <- 0 until 2; tp <- 0 until GEMM_TP; cp <- 0 until CP){
        val global_index = tt*CT*2*GEMM_TP*CP + ct*2*GEMM_TP*CP + ug*GEMM_TP*CP + tp*CP + cp
        val local_index  = tt*CT*  GEMM_TP*CP + ct*  GEMM_TP*CP +                 tp*CP + cp
        REF_UG(l)(global_index) = (if (ug == 0) REF_XU else REF_XG)(l)(local_index)
      }

      // init ap_ctrl and streams
      init_i_stream(dut.io.ug_stream)
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
          for (l <- 0 until L) array2stream(dut.io.ug_stream, dut.clockDomain, REF_UG(l),   1,            2, T, 1, C,  CP, info="ug stream", verbose=true)
        },
        fork {
          for (l <- 0 until L) stream2array(dut.io.q_stream,  dut.clockDomain, REF_XM_Q(l), DUT_XM_Q(l),  1, T, 1, C,  CP, info="xm_q stream")
        },
        fork {
          for (l <- 0 until L) stream2array(dut.io.s_stream,  dut.clockDomain, REF_XM_S(l), DUT_XM_S(l),  1, T, 1, CT, 1, info="xm_s stream")
        }
        // @formatter:on
      ).foreach(_.join())

      // calculate max of XM_S
      val max_XM_S = DUT_XM_S.flatten.max
      println(s"max_XM_S = $max_XM_S")

      simSuccess()
    }
}

