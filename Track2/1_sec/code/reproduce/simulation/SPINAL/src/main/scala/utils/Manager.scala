package utils

import spinal.core._
import spinal.lib._
import spinal.lib.fsm.{EntryPoint, State, StateMachine}

import scala.language.postfixOps

// @formatter:off
case class ApChain() extends Bundle with IMasterSlave {
  // Xilinx ap chain control signals
  val ap_start:     Bool = Bool()
  val ap_continue:  Bool = Bool()
  val ap_idle:      Bool = Bool()
  val ap_ready:     Bool = Bool()
  val ap_done:      Bool = Bool()

  override def asMaster(): Unit = {
    out(ap_start)
    out(ap_continue)
    in(ap_idle)
    in(ap_ready)
    in(ap_done)
  }

  override def asSlave(): Unit = {
    in(ap_start)
    in(ap_continue)
    out(ap_idle)
    out(ap_ready)
    out(ap_done)
  }
}

object ApChainRenamer {
  def apply(that: ApChain): Unit = {
    def doIt(): Unit = {
      that.flatten.foreach(bt =>
        bt.setName(bt.getName().replace("ap_ctrl_", ""))
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

case class DaisyChain[T <: Data](gen: T) extends Bundle {
  // daisy chain IO
  val I: T = in(cloneOf(gen))
  val O: T = out(cloneOf(gen))
}

object ctrl_cfg {
  val L_BITS: Int = 32 // how many layers to process
  val POS_BITS: Int = 32 // current pos id

  val axilite_addr_width = 16
  val axilite_data_width = 64 // indexing more than 4GB

  // register space for controller
  val ADDR_L_BEGIN              = 0x0000
  val ADDR_L_CLOSE              = 0x0010
  val ADDR_MEMORY_DECODER_X     = 0x0020
  val ADDR_MEMORY_DECODER_Y     = 0x0030
  val ADDR_MEMORY_CLS_Y         = 0x0040
  val ADDR_MEMORY_DECODER_W     = 0x0050
  val ADDR_MEMORY_CLS_W         = 0x0060
  val ADDR_MEMORY_K_CACHE       = 0x0070
  val ADDR_MEMORY_V_CACHE       = 0x0080
  val ADDR_POS                  = 0x0090
  val ADDR_T                    = 0x00A0
  val ADDR_IDLE                 = 0x00B0

  val binaries_prefix = "C:/projects/AAAProjects/PROJ17_LLM_QWEN/LLM_CPP/cmake-build-debug/binaries/decoder_"
  val condense_prefix = "C:/projects/AAAProjects/PROJ17_LLM_QWEN/LLM_CPP/cmake-build-debug/condense/decoder_"
}

case class ManagerSignals() extends Bundle {
  val L_BEGIN:            UInt = UInt(ctrl_cfg.L_BITS bits)       // start layer
  val L_CLOSE:            UInt = UInt(ctrl_cfg.L_BITS bits)       // close layer, exclusive
  val MEMORY_DECODER_X:   UInt = UInt(64 bits)                    // memory address
  val MEMORY_DECODER_Y:   UInt = UInt(64 bits)                    // memory address
  val MEMORY_CLS_Y:       UInt = UInt(64 bits)                    // memory address
  val MEMORY_DECODER_W:   UInt = UInt(64 bits)                    // memory address
  val MEMORY_CLS_W:       UInt = UInt(64 bits)                    // memory address
  val MEMORY_K_CACHE:     UInt = UInt(64 bits)                    // memory address
  val MEMORY_V_CACHE:     UInt = UInt(64 bits)                    // memory address

  val POS_ID:             UInt = UInt(ctrl_cfg.POS_BITS bits)     // current pos id
  val T: Bool = Bool()                                            // Trigger
}

class Manager extends Component {
  val io = new Bundle {
    val signals: DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
    val ap_ctrl: ApChain = master(ApChain())
  }

  noIoPrefix()

//  io.signals.O.L_BEGIN            := RegNext(io.signals.I.L_BEGIN)              // pass L_BEGIN
//  io.signals.O.L_CLOSE            := RegNext(io.signals.I.L_CLOSE)              // pass L_CLOSE
//  io.signals.O.MEMORY_DECODER_X   := RegNext(io.signals.I.MEMORY_DECODER_X)     // pass MEMORY_X
//  io.signals.O.MEMORY_DECODER_Y   := RegNext(io.signals.I.MEMORY_DECODER_Y)     // pass MEMORY_Y
//  io.signals.O.MEMORY_CLS_Y       := RegNext(io.signals.I.MEMORY_CLS_Y)         // pass MEMORY_CLS
//  io.signals.O.MEMORY_DECODER_W   := RegNext(io.signals.I.MEMORY_DECODER_W)     // pass MEMORY_W
//  io.signals.O.MEMORY_CLS_W       := RegNext(io.signals.I.MEMORY_CLS_W)         // pass MEMORY_CLS
//  io.signals.O.MEMORY_K_CACHE     := RegNext(io.signals.I.MEMORY_K_CACHE)       // pass MEMORY_K
//  io.signals.O.MEMORY_V_CACHE     := RegNext(io.signals.I.MEMORY_V_CACHE)       // pass MEMORY_V
//  io.signals.O.POS_ID             := RegNext(io.signals.I.POS_ID)               // pass POS
//  io.signals.O.T                  := RegNext(io.signals.I.T)                    // pass trigger

  io.signals.O := RegNext(io.signals.I) // pass all signals

  io.ap_ctrl.ap_continue  := True  // always continue
  io.ap_ctrl.ap_start     := False // default value

  val fsm: StateMachine = new StateMachine {
    val s_idle = new State with EntryPoint
    val s_work = new State

    s_idle.whenIsActive {
      when(io.signals.I.T) {
        goto(s_work)
      }
    } // end of s_idle

    s_work.whenIsActive {
      io.ap_ctrl.ap_start := True
      when(io.ap_ctrl.ap_ready) { // handshake with ap_ready
          goto(s_idle)
      } // else, wait for ap_ready
    } // end of s_work

  } // end of fsm
}

object genManager extends App {
  SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = ASYNC,
      resetActiveLevel = LOW
    ),
    mode = Verilog
  ).generate(new Manager)
}