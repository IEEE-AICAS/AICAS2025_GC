//import simulate_m_axi.spinalConfig
//import spinal.core.sim._
//import spinal.core._
//import spinal.lib.bus.amba4.axi.sim.{AxiMemorySim, AxiMemorySimConfig}
//import spinal.lib.bus.amba4.axi._
//import spinal.lib._
//import spinal.lib.bus.amba4.axilite.{AxiLite4, AxiLite4SpecRenamer}
//import utils._
//
//import scala.language.postfixOps
//import scala.reflect.ClassTag
//
//class ACCELERATOR_HIERARCHICAL extends Component {
//  // @formatter:off
//  private val inst_llama       = new LLAMA
//  private val inst_m_axi       = new M_AXI
//  private val inst_controller  = new Controller
//  // @formatter:on
//
//  val io = new Bundle {
//    val axilite: AxiLite4 = slave(AxiLite4(inst_controller.io.axilite.config))
//    val m_axi: Axi4 = master(Axi4(inst_m_axi.io.m_axi.config))
//    val idle: Bool = out Bool()
//  }
//  noIoPrefix()
//
//  // connect io signals
//  io.axilite <> inst_controller.io.axilite
//  io.m_axi <> inst_m_axi.io.m_axi
//  io.idle <> inst_m_axi.io.idle
//
//  // connect internal signals
//  inst_controller.io.idle <> inst_m_axi.io.idle
//
//  // connect daisy chain
//  inst_controller.io.signals <> inst_m_axi.io.signals.I
//  inst_m_axi.io.signals.O <> inst_llama.io.signals.I
//
//  // connect streams
//  // @formatter:off
//  inst_llama.io.x_stream              <> inst_m_axi.io.x_stream  .queue(512)
//  inst_llama.io.w_stream              <> inst_m_axi.io.wq_stream .queue(512)
//  inst_llama.io.s1_stream             <> inst_m_axi.io.ws1_stream.queue(512)
//  inst_llama.io.s2_stream             <> inst_m_axi.io.ws2_stream.queue(512)
//  inst_llama.io.y_stream.queue(512)   <> inst_m_axi.io.y_stream
//  // @formatter:on
//
//  // rename
//  Axi4SpecRenamer(io.m_axi)
//  AxiLite4SpecRenamer(io.axilite)
//}