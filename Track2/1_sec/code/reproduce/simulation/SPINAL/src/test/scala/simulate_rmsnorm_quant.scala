import spinal.core._
import spinal.core.sim._
import utils._

// @formatter:off
object simulate_rmsnorm_quant extends App {
  redirect_std("RMSNORM_QUANT.log")

  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )
  spinalConfig.generateVerilog(new RMSNORM_QUANT)

  SimConfig
    .withConfig(spinalConfig)
    .withFstWave
    .withWaveDepth(2)
    .allOptimisation
    .withVerilator
    .addSimulatorFlag("--unroll-count 1024")
    .addSimulatorFlag("-j 16")
    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
    .compile(new RMSNORM_QUANT)
    .doSimUntilVoid { dut =>

      val LLAMA_L = 24

      // simulation hyperparameters
      val L_BEGIN = 0
      val L_CLOSE = LLAMA_L

      // model hyperparameters
      val C = 896

      // design hyperparameters
      val T = 8
      val TP = 1
      val CP = 8

      // derived hyperparameters
      val CT = C / CP

      val data_path_prefix = ctrl_cfg.binaries_prefix
      val format_str = s"$data_path_prefix%d/%s.bin"
      // arrays
      val REF_MHA_X     = read_multi_int64_files(format_str, LLAMA_L, "MHA_X",     T * C)
      val REF_MLP_X     = read_multi_int64_files(format_str, LLAMA_L, "MLP_X",     T * C)
      val REF_MHA_XLN_Q = read_multi_int8_files (format_str, LLAMA_L, "MHA_XLN_Q", T * C)
      val REF_MHA_XLN_S = read_multi_int8_files (format_str, LLAMA_L, "MHA_XLN_S", T * C)
      val REF_MLP_XLN_Q = read_multi_int8_files (format_str, LLAMA_L, "MLP_XLN_Q", T * C)
      val REF_MLP_XLN_S = read_multi_int8_files (format_str, LLAMA_L, "MLP_XLN_S", T * C)

      val REF_X     = Array.ofDim[Long](LLAMA_L, 2 * T * C)
      val REF_XLN_Q = Array.ofDim[Byte](LLAMA_L, 2 * T * C)
      val REF_XLN_S = Array.ofDim[Byte](LLAMA_L, 2 * T * CT)

      for(l <- 0 until LLAMA_L; t <- 0 until T; c <- 0 until C){
        REF_X    (l)(      t*C + c) = REF_MHA_X(l)(t*C + c)
        REF_X    (l)(T*C + t*C + c) = REF_MLP_X(l)(t*C + c)
        REF_XLN_Q(l)(      t*C + c) = REF_MHA_XLN_Q(l)(t*C + c)
        REF_XLN_Q(l)(T*C + t*C + c) = REF_MLP_XLN_Q(l)(t*C + c)
      }
      for(l <- 0 until LLAMA_L; t <- 0 until T; ct <- 0 until CT){
        REF_XLN_S(l)(       t*CT + ct) = REF_MHA_XLN_S(l)(t*CT + ct)
        REF_XLN_S(l)(T*CT + t*CT + ct) = REF_MLP_XLN_S(l)(t*CT + ct)
      }

      val DUT_XLN_Q = Array.ofDim[Byte](LLAMA_L, 2 * T * C)
      val DUT_XLN_S = Array.ofDim[Byte](LLAMA_L, 2 * T * C)

      // init ap_ctrl and streams
      init_i_stream(dut.io.x_stream)
      init_o_stream(dut.io.xlnq_stream)
      init_o_stream(dut.io.xlns_stream)
      init_daisy_chain(dut.io.signals)

      // fork clock
      init_clock(dut.clockDomain, 10)
      // threads
      Array(
        fork {
          // set scalar parameters
          dut.io.signals.I.L_BEGIN #= L_BEGIN
          dut.io.signals.I.L_CLOSE #= L_CLOSE
          // delay 20 cycles to make sure the signals are set
          dut.clockDomain.waitSampling(20)
          // launch with trigger
          dut.io.signals.I.T #= true
          dut.clockDomain.waitSampling()
          dut.io.signals.I.T #= false
        },
        // @formatter:off
        fork {
          for (l <- 0 until LLAMA_L) array2stream(dut.io.x_stream,    dut.clockDomain, REF_X(l),                1, 2, T, TP, C, CP)
        },
        fork {
          for (l <- 0 until LLAMA_L) stream2array(dut.io.xlnq_stream, dut.clockDomain, REF_XLN_Q(l), DUT_XLN_Q(l), 2, T, TP, C, CP, verbose = true, info = s"Q of layer $l", is_signed=true)
        },
        fork {
          for (l <- 0 until LLAMA_L) stream2array(dut.io.xlns_stream, dut.clockDomain, REF_XLN_S(l), DUT_XLN_S(l), 2, T, TP, CT,1,  verbose = false, info = s"S of layer $l", is_signed=false)
        }
        // @formatter:on
      ).foreach(_.join())
      simSuccess()
    }
}


object simulate_rmsnorm_quant_cls extends App {
  redirect_std("RMSNORM_QUANT_CLS.log")

  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )
  spinalConfig.generateVerilog(new RMSNORM_QUANT)

  SimConfig
    .withConfig(spinalConfig)
    .withFstWave
    .withWaveDepth(2)
    .allOptimisation
    .withVerilator
    .addSimulatorFlag("--unroll-count 1024")
    .addSimulatorFlag("-j 16")
    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
    .compile(new RMSNORM_QUANT)
    .doSimUntilVoid { dut =>

      val LLAMA_L = 24

      // simulation hyperparameters
      val L_BEGIN = LLAMA_L
      val L_CLOSE = LLAMA_L + 1

      // model hyperparameters
      val C = 896

      // design hyperparameters
      val T = 8
      val TP = 1
      val CP = 8

      // derived hyperparameters
      val CT = C / CP

      val data_path_prefix = ctrl_cfg.binaries_prefix
      val format_str = s"$data_path_prefix%d/%s.bin"
      // arrays
      val REF_CLS_X     = read_int64_file(format_str.format(LLAMA_L, "CLS_X"),      T*C)
      val REF_CLS_XLN_Q = read_int8_file (format_str.format(LLAMA_L, "CLS_XLN_Q"),  T*C)
      val REF_CLS_XLN_S = read_int8_file (format_str.format(LLAMA_L, "CLS_XLN_S"),  T*C)

      val DUT_XLN_Q = Array.ofDim[Byte](T * C)
      val DUT_XLN_S = Array.ofDim[Byte](T * C)

      // init ap_ctrl and streams
      init_i_stream(dut.io.x_stream)
      init_o_stream(dut.io.xlnq_stream)
      init_o_stream(dut.io.xlns_stream)
      init_daisy_chain(dut.io.signals)

      // fork clock
      init_clock(dut.clockDomain, 10)
      // threads
      Array(
        fork {
          // set scalar parameters
          dut.io.signals.I.L_BEGIN #= L_BEGIN
          dut.io.signals.I.L_CLOSE #= L_CLOSE
          // delay 20 cycles to make sure the signals are set
          dut.clockDomain.waitSampling(20)
          // launch with trigger
          dut.io.signals.I.T #= true
          dut.clockDomain.waitSampling()
          dut.io.signals.I.T #= false
        },
        // @formatter:off
        fork{
          array2stream(dut.io.x_stream,    dut.clockDomain, REF_CLS_X,             1, 1, T, TP, C, CP)
        },
        fork {
          stream2array(dut.io.xlnq_stream, dut.clockDomain, REF_CLS_XLN_Q, DUT_XLN_Q, 1, T, TP, C, CP, verbose = true, info = "Q of CLS", is_signed=true)
        },
        fork {
          stream2array(dut.io.xlns_stream, dut.clockDomain, REF_CLS_XLN_S, DUT_XLN_S, 1, T, TP, CT, 1, verbose = false, info = "S of CLS", is_signed=false)
        }
        // @formatter:on
      ).foreach(_.join())
      simSuccess()
    }
}

