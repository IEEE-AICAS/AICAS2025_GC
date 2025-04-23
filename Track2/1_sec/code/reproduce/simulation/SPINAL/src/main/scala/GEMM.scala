import spinal.core.sim._
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.bus.amba4.axis.Axi4Stream
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream

import scala.language.postfixOps

// @formatter:off
class GEMMBlackbox extends BlackBox {
  val top_name: String = "GEMM_PERMUTE"
  setDefinitionName(top_name)
  private val verilog_file_path: String = s"src/main/verilog/$top_name/all.v"
  val io = new Bundle {
    val ap_clk:     Bool = in Bool()
    val ap_rst_n:   Bool = in Bool()

    val l_begin:    UInt = in UInt (ctrl_cfg.L_BITS bits)
    val l_close:    UInt = in UInt (ctrl_cfg.L_BITS bits)

    val ap_ctrl:    ApChain = slave(ApChain())
    val i_stream:   BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("i_stream",  verilog_file_path)))
    val w_stream:   BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("w_stream",  verilog_file_path)))
    val s_stream:   BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("s_stream",  verilog_file_path)))
    val s1_stream:  BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("s1_stream", verilog_file_path)))
    val s2_stream:  BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("s2_stream", verilog_file_path)))
    val o_stream:   BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("o_stream",  verilog_file_path)))
  }
  noIoPrefix()
  ApChainRenamer(io.ap_ctrl)
  mapClockDomain(clock = io.ap_clk, reset = io.ap_rst_n, resetActiveLevel = LOW)
  addRTLPath(verilog_file_path)
}

class GEMM extends Component {
  val top_name: String = "GEMM"
  setDefinitionName(top_name + "_wrapper")
  private val black_box = new GEMMBlackbox
  val io = new Bundle {
    val signals: DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
    val i_stream:  Axi4Stream = slave (Axi4Stream(black_box.io.i_stream .config.to_std_config()))
    val w_stream:  Axi4Stream = slave (Axi4Stream(black_box.io.w_stream .config.to_std_config()))
    val s_stream:  Axi4Stream = slave (Axi4Stream(black_box.io.s_stream .config.to_std_config()))
    val s1_stream: Axi4Stream = slave (Axi4Stream(black_box.io.s1_stream.config.to_std_config()))
    val s2_stream: Axi4Stream = slave (Axi4Stream(black_box.io.s2_stream.config.to_std_config()))
    val o_stream:  Axi4Stream = master(Axi4Stream(black_box.io.o_stream .config.to_std_config()))
  }
  noIoPrefix()
  val manager = new Manager
  manager.io.signals            <> io.signals
  manager.io.ap_ctrl            <> black_box.io.ap_ctrl
  manager.io.signals.O.L_BEGIN  <> black_box.io.l_begin
  manager.io.signals.O.L_CLOSE  <> black_box.io.l_close
  black_box.io.i_stream .connect2std(io.i_stream )
  black_box.io.w_stream .connect2std(io.w_stream )
  black_box.io.s_stream .connect2std(io.s_stream )
  black_box.io.s1_stream.connect2std(io.s1_stream)
  black_box.io.s2_stream.connect2std(io.s2_stream)
  black_box.io.o_stream .connect2std(io.o_stream )

  Axi4StreamSpecRenamer(io.i_stream )
  Axi4StreamSpecRenamer(io.w_stream )
  Axi4StreamSpecRenamer(io.s_stream )
  Axi4StreamSpecRenamer(io.s1_stream)
  Axi4StreamSpecRenamer(io.s2_stream)
  Axi4StreamSpecRenamer(io.o_stream )
}
