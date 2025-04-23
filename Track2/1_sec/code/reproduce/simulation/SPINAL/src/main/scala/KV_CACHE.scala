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
class KV_CACHE_Blackbox extends BlackBox {
  val top_name: String = "KV_CACHE"
  setDefinitionName(top_name)
  private val verilog_file_path: String = s"src/main/verilog/$top_name/all.v"
  val io = new Bundle {
    val ap_clk:             Bool = in Bool()
    val ap_rst_n:           Bool = in Bool()

    val l_begin:            UInt = in UInt (ctrl_cfg.L_BITS   bits)
    val l_close:            UInt = in UInt (ctrl_cfg.L_BITS   bits)
    val pos_id:             UInt = in UInt (ctrl_cfg.POS_BITS bits)

    val memory_k_cache:     UInt = in UInt (64 bits)
//    val memory_v_cache:     UInt = in UInt (64 bits)

    val ap_ctrl:           ApChain = slave(ApChain())
    val m_axi_gmem1:       BlackboxAxi  = master(BlackboxAxi (BlackboxAxiConfig ("gmem1",             verilog_file_path)))
    val kq_cache_i_stream: BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("kq_cache_i_stream", verilog_file_path)))
    val kq_cache_o_stream: BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("kq_cache_o_stream", verilog_file_path)))
    val ks_cache_i_stream: BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("ks_cache_i_stream", verilog_file_path)))
    val ks_cache_o_stream: BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("ks_cache_o_stream", verilog_file_path)))
    val vq_cache_i_stream: BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("vq_cache_i_stream", verilog_file_path)))
    val vq_cache_o_stream: BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("vq_cache_o_stream", verilog_file_path)))
    val vs_cache_i_stream: BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("vs_cache_i_stream", verilog_file_path)))
    val vs_cache_o_stream: BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("vs_cache_o_stream", verilog_file_path)))
  }
  noIoPrefix()
  ApChainRenamer(io.ap_ctrl)
  BlackboxAxiRenamer(io.m_axi_gmem1)
  mapClockDomain(clock = io.ap_clk, reset = io.ap_rst_n, resetActiveLevel = LOW)
  addRTLPath(verilog_file_path)
}


class KV_CACHE extends Component {
  val top_name: String = "KV_CACHE"
  setDefinitionName(top_name + "_wrapper")
  private val black_box = new KV_CACHE_Blackbox()
  val io = new Bundle {
    val signals: DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
    val gmem1:                Axi4       = master(Axi4      (black_box.io.m_axi_gmem1      .config.to_std_config()))
    val kq_cache_i_stream:    Axi4Stream = master(Axi4Stream(black_box.io.kq_cache_i_stream.config.to_std_config()))
    val kq_cache_o_stream:    Axi4Stream = slave (Axi4Stream(black_box.io.kq_cache_o_stream.config.to_std_config()))
    val ks_cache_i_stream:    Axi4Stream = master(Axi4Stream(black_box.io.ks_cache_i_stream.config.to_std_config()))
    val ks_cache_o_stream:    Axi4Stream = slave (Axi4Stream(black_box.io.ks_cache_o_stream.config.to_std_config()))
    val vq_cache_i_stream:    Axi4Stream = master(Axi4Stream(black_box.io.vq_cache_i_stream.config.to_std_config()))
    val vq_cache_o_stream:    Axi4Stream = slave (Axi4Stream(black_box.io.vq_cache_o_stream.config.to_std_config()))
    val vs_cache_i_stream:    Axi4Stream = master(Axi4Stream(black_box.io.vs_cache_i_stream.config.to_std_config()))
    val vs_cache_o_stream:    Axi4Stream = slave (Axi4Stream(black_box.io.vs_cache_o_stream.config.to_std_config()))

    val idle: Bool = out Bool()
  }
  noIoPrefix()
  io.idle := black_box.io.ap_ctrl.ap_idle
  val manager = new Manager // itself will do multiple layers
  manager.io.signals                      <> io.signals
  manager.io.ap_ctrl                      <> black_box.io.ap_ctrl
  manager.io.signals.O.L_BEGIN            <> black_box.io.l_begin
  manager.io.signals.O.L_CLOSE            <> black_box.io.l_close
  manager.io.signals.O.POS_ID             <> black_box.io.pos_id
  manager.io.signals.O.MEMORY_K_CACHE     <> black_box.io.memory_k_cache
//  manager.io.signals.O.MEMORY_V_CACHE     <> black_box.io.memory_v_cache

  black_box.io.m_axi_gmem1      .connect2std(io.gmem1)
  black_box.io.kq_cache_i_stream.connect2std(io.kq_cache_i_stream)
  black_box.io.kq_cache_o_stream.connect2std(io.kq_cache_o_stream)
  black_box.io.ks_cache_i_stream.connect2std(io.ks_cache_i_stream)
  black_box.io.ks_cache_o_stream.connect2std(io.ks_cache_o_stream)
  black_box.io.vq_cache_i_stream.connect2std(io.vq_cache_i_stream)
  black_box.io.vq_cache_o_stream.connect2std(io.vq_cache_o_stream)
  black_box.io.vs_cache_i_stream.connect2std(io.vs_cache_i_stream)
  black_box.io.vs_cache_o_stream.connect2std(io.vs_cache_o_stream)

  Axi4SpecRenamer(io.gmem1)

  Axi4StreamSpecRenamer(io.kq_cache_i_stream)
  Axi4StreamSpecRenamer(io.kq_cache_o_stream)
  Axi4StreamSpecRenamer(io.ks_cache_i_stream)
  Axi4StreamSpecRenamer(io.ks_cache_o_stream)
  Axi4StreamSpecRenamer(io.vq_cache_i_stream)
  Axi4StreamSpecRenamer(io.vq_cache_o_stream)
  Axi4StreamSpecRenamer(io.vs_cache_i_stream)
  Axi4StreamSpecRenamer(io.vs_cache_o_stream)
}

