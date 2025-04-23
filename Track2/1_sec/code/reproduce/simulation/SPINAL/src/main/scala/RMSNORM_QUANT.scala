import spinal.core.sim._
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.bus.amba4.axis.Axi4Stream
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream

import scala.language.postfixOps

// @formatter:off
class RMSNORM_QUANT_Blackbox extends BlackBox {
  val top_name: String = "RMSNORM_QUANT"
  setDefinitionName(top_name)
  private val rtl_file_path: String = s"src/main/verilog/$top_name"
  private val verilog_file_path: String = s"$rtl_file_path/all.v"
  val io = new Bundle {
    val ap_clk:       Bool = in Bool()
    val ap_rst_n:     Bool = in Bool()

    val l_begin:      UInt = in UInt (ctrl_cfg.L_BITS bits)
    val l_close:      UInt = in UInt (ctrl_cfg.L_BITS bits)

//    val pos:          UInt = in UInt (ctrl_cfg.POS_BITS bits)

    val ap_ctrl:      ApChain = slave(ApChain())
    val x_stream:     BlackboxAxis = slave (BlackboxAxis(BlackboxAxisConfig("x_stream",    verilog_file_path)))
    val xlnq_stream:  BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("xlnq_stream", verilog_file_path)))
    val xlns_stream:  BlackboxAxis = master(BlackboxAxis(BlackboxAxisConfig("xlns_stream", verilog_file_path)))
  }
  noIoPrefix()
  ApChainRenamer(io.ap_ctrl)
  mapClockDomain(clock = io.ap_clk, reset = io.ap_rst_n, resetActiveLevel = LOW)
  addRTLPath(verilog_file_path)
}

class RMSNORM_QUANT extends Component {
  val top_name: String = "RMSNORM_QUANT"
  setDefinitionName(top_name + "_wrapper")
  private val black_box = new RMSNORM_QUANT_Blackbox
  val io = new Bundle {
    val signals: DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
    val x_stream:    Axi4Stream = slave(Axi4Stream(black_box.io.x_stream.config.to_std_config()))
    val xlnq_stream: Axi4Stream = master(Axi4Stream(black_box.io.xlnq_stream.config.to_std_config()))
    val xlns_stream: Axi4Stream = master(Axi4Stream(black_box.io.xlns_stream.config.to_std_config()))
  }
  noIoPrefix()
  val manager = new Manager
  manager.io.signals            <> io.signals
  manager.io.signals.O.L_BEGIN  <> black_box.io.l_begin
  manager.io.signals.O.L_CLOSE  <> black_box.io.l_close
//  manager.io.signals.O.POS_ID      <> black_box.io.pos
  manager.io.ap_ctrl            <> black_box.io.ap_ctrl
  black_box.io.x_stream   .connect2std(io.x_stream)
  black_box.io.xlnq_stream.connect2std(io.xlnq_stream)
  black_box.io.xlns_stream.connect2std(io.xlns_stream)

  Axi4StreamSpecRenamer(io.x_stream)
  Axi4StreamSpecRenamer(io.xlnq_stream)
  Axi4StreamSpecRenamer(io.xlns_stream)
}

