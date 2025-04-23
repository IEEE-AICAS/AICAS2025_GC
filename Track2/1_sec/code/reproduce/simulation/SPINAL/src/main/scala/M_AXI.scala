import spinal.core.sim._
import spinal.core._
import spinal.lib.bus.amba4.axi.sim.{AxiMemorySim, AxiMemorySimConfig}
import spinal.lib.bus.amba4.axi._
import spinal.lib._
import spinal.lib.bus.amba4.axis.Axi4Stream
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream
import utils._

import scala.language.postfixOps

// @formatter:off
class M_AXI_Blackbox extends BlackBox {
  val top_name: String = "M_AXI"
  setDefinitionName(top_name)
  private val verilog_file_path: String = s"src/main/verilog/$top_name/all.v"
  val io = new Bundle {
    val ap_clk:             Bool = in Bool()
    val ap_rst_n:           Bool = in Bool()

    val l_begin:            UInt = in UInt (ctrl_cfg.L_BITS bits)
    val l_close:            UInt = in UInt (ctrl_cfg.L_BITS bits)
//    val pos_id:             UInt = in UInt (ctrl_cfg.POS_BITS bits)

    val memory_decoder_x:   UInt = in UInt (64 bits)
    val memory_decoder_y:   UInt = in UInt (64 bits)
    val memory_cls_y:       UInt = in UInt (64 bits)
    val memory_decoder_w:   UInt = in UInt (64 bits)
    val memory_cls_w:       UInt = in UInt (64 bits)

    val ap_ctrl:           ApChain = slave(ApChain())
    val m_axi_gmem:        BlackboxAxi  = master(BlackboxAxi (BlackboxAxiConfig ("gmem",              verilog_file_path)))
    val x_stream:          BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("x_stream",          verilog_file_path)))
    val wq_stream:         BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("wq_stream",         verilog_file_path)))
    val ws1_stream:        BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("ws1_stream",        verilog_file_path)))
    val ws2_stream:        BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("ws2_stream",        verilog_file_path)))
    val y_stream:          BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("y_stream",          verilog_file_path)))
    val cls_stream:        BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("cls_stream",        verilog_file_path)))
  }
  noIoPrefix()
  ApChainRenamer(io.ap_ctrl)
  BlackboxAxiRenamer(io.m_axi_gmem)
  mapClockDomain(clock = io.ap_clk, reset = io.ap_rst_n, resetActiveLevel = LOW)
  addRTLPath(verilog_file_path)
}


class M_AXI extends Component {
  val top_name: String = "M_AXI"
  setDefinitionName(top_name + "_wrapper")
  private val black_box = new M_AXI_Blackbox()
  val io = new Bundle {
    val signals: DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
    val gmem:                 Axi4       = master(Axi4      (black_box.io.m_axi_gmem       .config.to_std_config()))
    val x_stream:             Axi4Stream = master(Axi4Stream(black_box.io.x_stream         .config.to_std_config()))
    val wq_stream:            Axi4Stream = master(Axi4Stream(black_box.io.wq_stream        .config.to_std_config()))
    val ws1_stream:           Axi4Stream = master(Axi4Stream(black_box.io.ws1_stream       .config.to_std_config()))
    val ws2_stream:           Axi4Stream = master(Axi4Stream(black_box.io.ws2_stream       .config.to_std_config()))
    val y_stream:             Axi4Stream = slave (Axi4Stream(black_box.io.y_stream         .config.to_std_config()))
    val cls_stream:           Axi4Stream = slave (Axi4Stream(black_box.io.cls_stream       .config.to_std_config()))

    val idle: Bool = out Bool()
  }
  noIoPrefix()
  io.idle := black_box.io.ap_ctrl.ap_idle
  val manager = new Manager // itself will do multiple layers
  manager.io.signals                      <> io.signals
  manager.io.ap_ctrl                      <> black_box.io.ap_ctrl
  manager.io.signals.O.L_BEGIN            <> black_box.io.l_begin
  manager.io.signals.O.L_CLOSE            <> black_box.io.l_close
//  manager.io.signals.O.POS_ID             <> black_box.io.pos_id
  manager.io.signals.O.MEMORY_DECODER_X   <> black_box.io.memory_decoder_x
  manager.io.signals.O.MEMORY_DECODER_Y   <> black_box.io.memory_decoder_y
  manager.io.signals.O.MEMORY_CLS_Y       <> black_box.io.memory_cls_y
  manager.io.signals.O.MEMORY_DECODER_W   <> black_box.io.memory_decoder_w
  manager.io.signals.O.MEMORY_CLS_W       <> black_box.io.memory_cls_w

  black_box.io.m_axi_gmem       .connect2std(io.gmem )
  black_box.io.x_stream         .connect2std(io.x_stream)
  black_box.io.wq_stream        .connect2std(io.wq_stream)
  black_box.io.ws1_stream       .connect2std(io.ws1_stream)
  black_box.io.ws2_stream       .connect2std(io.ws2_stream)
  black_box.io.y_stream         .connect2std(io.y_stream)
  black_box.io.cls_stream       .connect2std(io.cls_stream)

  Axi4SpecRenamer(io.gmem )

  Axi4StreamSpecRenamer(io.x_stream)
  Axi4StreamSpecRenamer(io.wq_stream)
  Axi4StreamSpecRenamer(io.ws1_stream)
  Axi4StreamSpecRenamer(io.ws2_stream)
  Axi4StreamSpecRenamer(io.y_stream)
  Axi4StreamSpecRenamer(io.cls_stream)
}

// Simulation code
object simulate_m_axi extends App {
  redirect_std("M_AXI.log")

  // SpinalConfig
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )
  spinalConfig.generateVerilog(new M_AXI).mergeRTLSource()

  SimConfig
    .withConfig(spinalConfig)
    .withFstWave
    .withWaveDepth(1)
    .allOptimisation
    .withVerilator
    .addSimulatorFlag("--unroll-count 1024")
    .addSimulatorFlag("-j 16")
    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
    .compile(new M_AXI)
    .doSimUntilVoid { dut =>

      // simulation hyperparameters
      val L = 1

      // model hyperparameters
      val C = 896
      val CM = 4864

      // design hyperparameters
      val T = 8
      val TP = 1
      val G = 8
      val CP = G
      val DW_WQ = 5
      val DW_WS = 3 // including s1 and s2

      // derived hyperparameters
      val BYTES_PER_X = 32 / 8
      val TT = T / TP
      val CT = C / CP

      val DECODER_NUM_WQ  = 3*C*C + C*C + 2*CM*C + C*CM
      val DECODER_NUM_WS  = DECODER_NUM_WQ / G
      val DECODER_W_BITS  = DECODER_NUM_WQ * DW_WQ + DECODER_NUM_WS * DW_WS * 2
      val DECODER_W_BYTES = DECODER_W_BITS / 8
      val NUM_X   = T*C

      // calculate the address for memory x and memory y
      val addr_w = 0
      val addr_x = 0x10000000L
      val addr_y = addr_x + NUM_X * BYTES_PER_X

      val binaries_format_str = s"${ctrl_cfg.binaries_prefix}%d/%s.bin"
      val condense_format_str = s"${ctrl_cfg.condense_prefix}%d/%s.bin"

      // separate weights
      val REF_CONDENSED_WQ          = read_multi_int8_files (condense_format_str, L, "CONDENSED_GEMM_W_Q",   DECODER_NUM_WQ)
      val REF_CONDENSED_WS1         = read_multi_int8_files (condense_format_str, L, "CONDENSED_GEMM_W_S1",  DECODER_NUM_WS)
      val REF_CONDENSED_WS2         = read_multi_int8_files (condense_format_str, L, "CONDENSED_GEMM_W_S2",  DECODER_NUM_WS)
      // composed weights
      val REF_CONDENSED_WEIGHT      = read_multi_int8_files (condense_format_str, L, "CONDENSED_WEIGHT",     DECODER_W_BYTES)

      val REF_X                     = read_int64_file       (binaries_format_str.format(0,   "MHA_X"       ), T*C)
      val REF_Y                     = read_int64_file       (binaries_format_str.format(L,   "MHA_X"       ), T*C)

      val DUT_CONDENSED_WQ          = Array.ofDim[Byte](L, DECODER_NUM_WQ)
      val DUT_CONDENSED_WS1         = Array.ofDim[Byte](L, DECODER_NUM_WS)
      val DUT_CONDENSED_WS2         = Array.ofDim[Byte](L, DECODER_NUM_WS)

      val DUT_X                     = Array.ofDim[Long](T*C)
      val DUT_Y                     = Array.ofDim[Long](T*C)

      // Initialize AXI memory_w simulator
      val axi_sim = AxiMemorySim(dut.io.gmem , dut.clockDomain, AxiMemorySimConfig())
      axi_sim.reset()

      for(l <- 0 until L){
        axi_sim.memory.writeArray(addr_w + l*DECODER_W_BYTES, REF_CONDENSED_WEIGHT(l))
      }

      // initialize input x into memory
      for (tt <- 0 until TT) {
        for (ct <- 0 until CT) {
          for (tp <- 0 until TP) {
            for (cp <- 0 until CP) {
              // original    loop: TT -> TP -> CT -> CP
              // accelerator loop: TT -> CT -> TP -> CP
              val ref_idx = tt * TP * CT * CP + tp * CT * CP + ct * CP + cp
              val axi_idx = tt * CT * TP * CP + ct * TP * CP + tp * CP + cp
              // consider the sign problem, if <0, convert to complement
              val ref_val = BigInt(REF_X(ref_idx))
              val axi_val = if (ref_val < 0) (BigInt(1) << 32) + ref_val else ref_val
              axi_sim.memory.writeBigInt(addr_x + axi_idx * BYTES_PER_X, axi_val, BYTES_PER_X)
            }
          }
        }
      }

      // fill dummy area of x, 0xff0_0000 - 0xfff_ffff
      for (addr <- 0xff000000L until 0x100000000L) {
        axi_sim.memory.write(addr, 0)
      }

      axi_sim.reset()
      println("axi memory_w write done")

      // init streams and daisy chain
      init_o_stream(dut.io.x_stream)
      init_o_stream(dut.io.wq_stream)
      init_o_stream(dut.io.ws1_stream)
      init_o_stream(dut.io.ws2_stream)
      init_i_stream(dut.io.y_stream)
      init_daisy_chain(dut.io.signals)

      // fork clock
      init_clock(dut.clockDomain, 10)

      // set parameter and trigger
      dut.io.signals.I.L_BEGIN #= 0
      dut.io.signals.I.L_CLOSE #= L
      dut.io.signals.I.MEMORY_DECODER_W #= addr_w
      dut.io.signals.I.MEMORY_DECODER_X #= addr_x
      dut.io.signals.I.MEMORY_DECODER_Y #= addr_y
      // delay 20 cycles to make sure the signals are set
      dut.clockDomain.waitSampling(20)
      // launch with trigger
      dut.io.signals.I.T #= true
      dut.clockDomain.waitSampling()
      dut.io.signals.I.T #= false
      dut.clockDomain.waitSampling(20)

      // threads
      stream2array(dut.io.x_stream, dut.clockDomain, REF_X, DUT_X, 1, T, TP, C, CP, info = "x_stream", verbose = true)

      Array(
        fork {
          for (l <- 0 until L) stream2array(dut.io.wq_stream, dut.clockDomain, REF_CONDENSED_WQ(l), DUT_CONDENSED_WQ(l), 1, 1, 1, DECODER_NUM_WQ, G * G, info = "wq_stream", verbose = true)
        },
        fork {
          for (l <- 0 until L) stream2array(dut.io.ws1_stream, dut.clockDomain, REF_CONDENSED_WS1(l), DUT_CONDENSED_WS1(l), 1, 1, 1, DECODER_NUM_WS, G, info = "ws1_stream", is_signed = false)
        },
        fork {
          for (l <- 0 until L) stream2array(dut.io.ws2_stream, dut.clockDomain, REF_CONDENSED_WS2(l), DUT_CONDENSED_WS2(l), 1, 1, 1, DECODER_NUM_WS, G, info = "ws2_stream", is_signed = false)
        }
      ).foreach(_.join())

      array2stream(dut.io.y_stream, dut.clockDomain, REF_Y, 1, 1, T, TP, C, CP, info = "y_stream", verbose = true)

      // at end, with 10000 cycles
      dut.clockDomain.waitSampling(10000)

      for(tt <- 0 until TT; ct <- 0 until CT; tp <- 0 until TP; cp <- 0 until CP){
        val axi_idx = tt*CT*TP*CP + ct*TP*CP + tp*CP + cp
        val dut_idx = tt*TP*CT*CP + tp*CT*CP + ct*CP + cp
        val axi_val = axi_sim.memory.readBigInt(addr_y + axi_idx*BYTES_PER_X, BYTES_PER_X)
//        val out_val = if((axi_val >> 31) == 1) (axi_val - (BigInt(1) << 32)).toLong else axi_val.toLong
        val out_val = axi_val.toInt.toLong
        DUT_Y(dut_idx) = out_val
      }

      compare_array(REF_Y, DUT_Y)

      simSuccess()
    }
}
