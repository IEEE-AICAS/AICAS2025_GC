package utils;

import spinal.core._
import spinal.lib.IMasterSlave
import spinal.lib.bus.amba4.axi._

import scala.language.postfixOps

// @formatter:off
case class BlackboxAxiConfig(
                              C_M_AXI_ID_WIDTH:      Int = 1,
                              C_M_AXI_ADDR_WIDTH:    Int = 64,
                              C_M_AXI_DATA_WIDTH:    Int = 32,
                              C_M_AXI_AWUSER_WIDTH:  Int = 1,
                              C_M_AXI_ARUSER_WIDTH:  Int = 1,
                              C_M_AXI_WUSER_WIDTH:   Int = 1,
                              C_M_AXI_RUSER_WIDTH:   Int = 1,
                              C_M_AXI_BUSER_WIDTH:   Int = 1
                            ) {
  val C_M_AXI_WSTRB_WIDTH: Int = C_M_AXI_DATA_WIDTH / 8

  def to_std_config(): Axi4Config = Axi4Config(
    idWidth       = C_M_AXI_ID_WIDTH,
    addressWidth  = C_M_AXI_ADDR_WIDTH,
    dataWidth     = C_M_AXI_DATA_WIDTH,
    arUserWidth   = C_M_AXI_ARUSER_WIDTH,
    awUserWidth   = C_M_AXI_AWUSER_WIDTH,
    rUserWidth    = C_M_AXI_RUSER_WIDTH,
    wUserWidth    = C_M_AXI_WUSER_WIDTH,
    bUserWidth    = C_M_AXI_BUSER_WIDTH
  )
}

object BlackboxAxiConfig {
  val default_map: Map[String, Int] = Map(
    "C_M_AXI_ID_WIDTH"      -> 1,
    "C_M_AXI_ADDR_WIDTH"    -> 64,
    "C_M_AXI_DATA_WIDTH"    -> 32,
    "C_M_AXI_AWUSER_WIDTH"  -> 1,
    "C_M_AXI_ARUSER_WIDTH"  -> 1,
    "C_M_AXI_WUSER_WIDTH"   -> 1,
    "C_M_AXI_RUSER_WIDTH"   -> 1,
    "C_M_AXI_BUSER_WIDTH"   -> 1
  )

  def apply(axi_name: String, field_value_map: Map[String, Int]): BlackboxAxiConfig = {
    val upper_axi_name = axi_name.toUpperCase
    new BlackboxAxiConfig(
      C_M_AXI_ID_WIDTH     = field_value_map(s"C_M_AXI_${upper_axi_name}_ID_WIDTH"),
      C_M_AXI_ADDR_WIDTH   = field_value_map(s"C_M_AXI_${upper_axi_name}_ADDR_WIDTH"),
      C_M_AXI_DATA_WIDTH   = field_value_map(s"C_M_AXI_${upper_axi_name}_DATA_WIDTH"),
      C_M_AXI_AWUSER_WIDTH = field_value_map(s"C_M_AXI_${upper_axi_name}_AWUSER_WIDTH"),
      C_M_AXI_ARUSER_WIDTH = field_value_map(s"C_M_AXI_${upper_axi_name}_ARUSER_WIDTH"),
      C_M_AXI_WUSER_WIDTH  = field_value_map(s"C_M_AXI_${upper_axi_name}_WUSER_WIDTH"),
      C_M_AXI_RUSER_WIDTH  = field_value_map(s"C_M_AXI_${upper_axi_name}_RUSER_WIDTH"),
      C_M_AXI_BUSER_WIDTH  = field_value_map(s"C_M_AXI_${upper_axi_name}_BUSER_WIDTH")
    )
  }

  def apply(axi_name: String, verilog_file_path: String): BlackboxAxiConfig = {
    var field_value_map: Map[String, Int] = Map()
    val source = scala.io.Source.fromFile(verilog_file_path)
    val lines = try source.mkString finally source.close()
    val pattern = "parameter\\s+(\\w+)\\s*=\\s*(\\d+)".r
    for (m <- pattern.findAllMatchIn(lines)) {
      // check if the field is a valid field name
      val field = m.group(1)
      val value = m.group(2).toInt
      if(field.startsWith("C_M_AXI")) {
        field_value_map += (field -> value)
      }
    }
    // print the map
    field_value_map.foreach(println)
    BlackboxAxiConfig(axi_name, field_value_map)
  }
}


case class BlackboxAxi(config: BlackboxAxiConfig) extends Bundle with IMasterSlave {
  // default master axi

  // aw channel
  val AWVALID:   Bool = out Bool()
  val AWREADY:   Bool = in  Bool()
  val AWADDR:    UInt = out UInt (config.C_M_AXI_ADDR_WIDTH    bits)
  val AWID:      UInt = out UInt (config.C_M_AXI_ID_WIDTH      bits) // not use
  val AWUSER:    Bits = out Bits (config.C_M_AXI_AWUSER_WIDTH  bits)
  // default width
  val AWREGION:  Bits = out Bits (4 bits)
  val AWLEN:     UInt = out UInt (8 bits)
  val AWSIZE:    UInt = out UInt (3 bits)
  val AWBURST:   Bits = out Bits (2 bits)
  val AWLOCK:    Bits = out Bits (1 bits)
  val AWCACHE:   Bits = out Bits (4 bits)
  val AWQOS:     Bits = out Bits (4 bits)
  val AWPROT:    Bits = out Bits (3 bits)
  // w channel
  val WVALID:    Bool = out Bool()
  val WREADY:    Bool = in  Bool()
  val WDATA:     Bits = out Bits(config.C_M_AXI_DATA_WIDTH   bits)
  val WSTRB:     Bits = out Bits(config.C_M_AXI_WSTRB_WIDTH  bits) // 32 bit data bus
  val WLAST:     Bool = out Bool()
  val WID:       Bits = out Bits(config.C_M_AXI_ID_WIDTH     bits)
  val WUSER:     Bits = out Bits(config.C_M_AXI_WUSER_WIDTH  bits)
  // ar channel
  val ARVALID:   Bool = out Bool()
  val ARREADY:   Bool = in Bool()
  val ARADDR:    UInt = out UInt (config.C_M_AXI_ADDR_WIDTH  bits)
  val ARID:      UInt = out UInt (config.C_M_AXI_ID_WIDTH    bits)
  val ARUSER:    Bits = out Bits (config.C_M_AXI_ARUSER_WIDTH bits)
  // default width
  val ARREGION:  Bits = out Bits (4 bits)
  val ARLEN:     UInt = out UInt (8 bits)
  val ARSIZE:    UInt = out UInt (3 bits)
  val ARBURST:   Bits = out Bits (2 bits)
  val ARLOCK:    Bits = out Bits (1 bits)
  val ARCACHE:   Bits = out Bits (4 bits)
  val ARQOS:     Bits = out Bits (4 bits)
  val ARPROT:    Bits = out Bits (3 bits)
  // r channel slave
  val RVALID:    Bool = in  Bool()
  val RREADY:    Bool = out Bool()
  val RDATA:     Bits = in  Bits (config.C_M_AXI_DATA_WIDTH   bits)
  val RLAST:     Bool = in  Bool()
  val RID:       UInt = in  UInt (config.C_M_AXI_ID_WIDTH     bits)
  val RUSER:     Bits = in  Bits (config.C_M_AXI_RUSER_WIDTH  bits)
  // default width
  val RRESP:     Bits = in  Bits (2 bits)
  // b channel slave
  val BVALID:    Bool = in  Bool()
  val BREADY:    Bool = out Bool()
  val BID:       UInt = in  UInt (config.C_M_AXI_ID_WIDTH    bits)
  val BUSER:     Bits = in  Bits (config.C_M_AXI_BUSER_WIDTH bits)
  // default width
  val BRESP: Bits = in Bits (2 bits)

  override def asMaster(): Unit = {
    out(AWVALID  )
    in (AWREADY  )
    out(AWADDR   )
    out(AWID     )
    out(AWLEN    )
    out(AWSIZE   )
    out(AWBURST  )
    out(AWLOCK   )
    out(AWCACHE  )
    out(AWPROT   )
    out(AWQOS    )
    out(AWREGION )
    out(AWUSER   )
    out(WVALID   )
    in (WREADY   )
    out(WDATA    )
    out(WSTRB    )
    out(WLAST    )
    out(WID      )
    out(WUSER    )
    out(ARVALID  )
    in (ARREADY  )
    out(ARADDR   )
    out(ARID     )
    out(ARLEN    )
    out(ARSIZE   )
    out(ARBURST  )
    out(ARLOCK   )
    out(ARCACHE  )
    out(ARPROT   )
    out(ARQOS    )
    out(ARREGION )
    out(ARUSER   )
    in (RVALID   )
    out(RREADY   )
    in (RDATA    )
    in (RLAST    )
    in (RID      )
    in (RUSER    )
    in (RRESP    )
    in (BVALID   )
    out(BREADY   )
    in (BRESP    )
    in (BID      )
    in (BUSER    )
  }

  override def asSlave(): Unit = {
    in (AWVALID  )
    out(AWREADY  )
    in (AWADDR   )
    in (AWID     )
    in (AWLEN    )
    in (AWSIZE   )
    in (AWBURST  )
    in (AWLOCK   )
    in (AWCACHE  )
    in (AWPROT   )
    in (AWQOS    )
    in (AWREGION )
    in (AWUSER   )
    in (WVALID   )
    out(WREADY   )
    in (WDATA    )
    in (WSTRB    )
    in (WLAST    )
    in (WID      )
    in (WUSER    )
    in (ARVALID  )
    out(ARREADY  )
    in (ARADDR   )
    in (ARID     )
    in (ARLEN    )
    in (ARSIZE   )
    in (ARBURST  )
    in (ARLOCK   )
    in (ARCACHE  )
    in (ARPROT   )
    in (ARQOS    )
    in (ARREGION )
    in (ARUSER   )
    out(RVALID   )
    in (RREADY   )
    out(RDATA    )
    out(RLAST    )
    out(RID      )
    out(RUSER    )
    out(RRESP    )
    out(BVALID   )
    in (BREADY   )
    out(BRESP    )
    out(BID      )
    out(BUSER    )
  }

  def connect2std(Axi: Axi4): Unit = {
    AWVALID  <> Axi.aw.valid
    AWREADY  <> Axi.aw.ready
    AWADDR   <> Axi.aw.addr
    AWID     <> Axi.aw.id
    AWLEN    <> Axi.aw.len
    AWSIZE   <> Axi.aw.size
    AWBURST  <> Axi.aw.burst
    AWLOCK   <> Axi.aw.lock
    AWCACHE  <> Axi.aw.cache
    AWPROT   <> Axi.aw.prot
    AWQOS    <> Axi.aw.qos
    AWREGION <> Axi.aw.region
    AWUSER   <> Axi.aw.user
    WVALID   <> Axi.w.valid
    WREADY   <> Axi.w.ready
    WDATA    <> Axi.w.data
    WSTRB    <> Axi.w.strb
    WLAST    <> Axi.w.last
    //    gmem_WID <> Axi.w.id // not implemented in Spinal
    WUSER    <> Axi.w.user
    ARVALID  <> Axi.ar.valid
    ARREADY  <> Axi.ar.ready
    ARADDR   <> Axi.ar.addr
    ARID     <> Axi.ar.id
    ARLEN    <> Axi.ar.len
    ARSIZE   <> Axi.ar.size
    ARBURST  <> Axi.ar.burst
    ARLOCK   <> Axi.ar.lock
    ARCACHE  <> Axi.ar.cache
    ARPROT   <> Axi.ar.prot
    ARQOS    <> Axi.ar.qos
    ARREGION <> Axi.ar.region
    ARUSER   <> Axi.ar.user
    RVALID   <> Axi.r.valid
    RREADY   <> Axi.r.ready
    RDATA    <> Axi.r.data
    RLAST    <> Axi.r.last
    RID      <> Axi.r.id
    RUSER    <> Axi.r.user
    RRESP    <> Axi.r.resp
    BVALID   <> Axi.b.valid
    BREADY   <> Axi.b.ready
    BRESP    <> Axi.b.resp
    BID      <> Axi.b.id
    BUSER    <> Axi.b.user
  }
}

object BlackboxAxiRenamer {
  def apply(that: BlackboxAxi): Unit = {
    // rename the signals, make sure it matches the verilog signals
    // remove the "blackbox_axi_" prefix
    def doIt(): Unit = {
      that.flatten.foreach(bt =>
        bt.setName(bt.getName().replace("blackbox_axi_", ""))
      )
    }

    if (Component.current == that.component)
      that.component.addPrePopTask(() => {
        doIt()
      })
    else
      doIt()
  }
}
