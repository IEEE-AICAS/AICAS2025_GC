import spinal.core.{ClockDomainConfig, LOW, SYNC, SpinalConfig}
import spinal.core.sim._
import utils._


// @formatter:off
object simulate_gemm extends App {
  redirect_std(s"GEMM.log")

  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )
  spinalConfig.generateVerilog(new GEMM)

  // do simulation
  SimConfig
    .withConfig(spinalConfig)
//    .withFstWave
    .withWaveDepth(1)
    .allOptimisation
    .withVerilator
    .addSimulatorFlag("--unroll-count 1024")
    .addSimulatorFlag("-j 16")
    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
    .compile(new GEMM)
    .doSimUntilVoid { dut =>

      val LLAMA_L = 24

      // simulation hyperparameters
      val L_BEGIN = 1
      val L_CLOSE = 2

      // model hyperparameters
      val C = 896
      val CM = 4864
      val VOCAB = 151936

      // design hyperparameters
      val T = 8
      val TP = T
      val CIP = 8
      val COP = 8

      // derived hyperparameters
      val CT = C / CIP
      val CMT = CM / CIP

      // read multiple data
      val data_path_prefix = ctrl_cfg.binaries_prefix
      val format_str = s"$data_path_prefix%d/%s.bin"
      val REF_MHA_XLN_Q   = read_multi_int8_files(format_str, LLAMA_L, "MHA_XLN_Q", T * C)
      val REF_MHA_XLN_S   = read_multi_int8_files(format_str, LLAMA_L, "MHA_XLN_S", T * CT)
      val REF_MHA_A_Q     = read_multi_int8_files(format_str, LLAMA_L, "MHA_A_Q",   T * C)
      val REF_MHA_A_S     = read_multi_int8_files(format_str, LLAMA_L, "MHA_A_S",   T * CT)
      val REF_MLP_XLN_Q   = read_multi_int8_files(format_str, LLAMA_L, "MLP_XLN_Q", T * C)
      val REF_MLP_XLN_S   = read_multi_int8_files(format_str, LLAMA_L, "MLP_XLN_S", T * CT)
      val REF_MLP_XM_Q    = read_multi_int8_files(format_str, LLAMA_L, "MLP_XM_Q",  T * CM)
      val REF_MLP_XM_S    = read_multi_int8_files(format_str, LLAMA_L, "MLP_XM_S",  T * CMT)

      val REF_WQ_Q        = read_multi_int8_files(format_str, LLAMA_L, "MHA_WQ_Q",  C * C)
      val REF_WQ_S1       = read_multi_int8_files(format_str, LLAMA_L, "MHA_WQ_S1", C * CT)
      val REF_WQ_S2       = read_multi_int8_files(format_str, LLAMA_L, "MHA_WQ_S2", C * CT)
      val REF_WK_Q        = read_multi_int8_files(format_str, LLAMA_L, "MHA_WK_Q",  C * C)
      val REF_WK_S1       = read_multi_int8_files(format_str, LLAMA_L, "MHA_WK_S1", C * CT)
      val REF_WK_S2       = read_multi_int8_files(format_str, LLAMA_L, "MHA_WK_S2", C * CT)
      val REF_WV_Q        = read_multi_int8_files(format_str, LLAMA_L, "MHA_WV_Q",  C * C)
      val REF_WV_S1       = read_multi_int8_files(format_str, LLAMA_L, "MHA_WV_S1", C * CT)
      val REF_WV_S2       = read_multi_int8_files(format_str, LLAMA_L, "MHA_WV_S2", C * CT)
      val REF_WO_Q        = read_multi_int8_files(format_str, LLAMA_L, "MHA_WO_Q",  C * C)
      val REF_WO_S1       = read_multi_int8_files(format_str, LLAMA_L, "MHA_WO_S1", C * CT)
      val REF_WO_S2       = read_multi_int8_files(format_str, LLAMA_L, "MHA_WO_S2", C * CT)
      val REF_WU_Q        = read_multi_int8_files(format_str, LLAMA_L, "MLP_WU_Q",  CM * C)
      val REF_WU_S1       = read_multi_int8_files(format_str, LLAMA_L, "MLP_WU_S1", CM * CT)
      val REF_WU_S2       = read_multi_int8_files(format_str, LLAMA_L, "MLP_WU_S2", CM * CT)
      val REF_WG_Q        = read_multi_int8_files(format_str, LLAMA_L, "MLP_WG_Q",  CM * C)
      val REF_WG_S1       = read_multi_int8_files(format_str, LLAMA_L, "MLP_WG_S1", CM * CT)
      val REF_WG_S2       = read_multi_int8_files(format_str, LLAMA_L, "MLP_WG_S2", CM * CT)
      val REF_WD_Q        = read_multi_int8_files(format_str, LLAMA_L, "MLP_WD_Q",  C * CM)
      val REF_WD_S1       = read_multi_int8_files(format_str, LLAMA_L, "MLP_WD_S1", C * CMT)
      val REF_WD_S2       = read_multi_int8_files(format_str, LLAMA_L, "MLP_WD_S2", C * CMT)

      val REF_MHA_Q       = read_multi_int64_files(format_str, LLAMA_L, "MHA_Q",  T * C)
      val REF_MHA_K       = read_multi_int64_files(format_str, LLAMA_L, "MHA_K",  T * C)
      val REF_MHA_V       = read_multi_int64_files(format_str, LLAMA_L, "MHA_V",  T * C)
      val REF_MHA_O       = read_multi_int64_files(format_str, LLAMA_L, "MHA_O",  T * C)
      val REF_MLP_U       = read_multi_int64_files(format_str, LLAMA_L, "MLP_XU", T * CM)
      val REF_MLP_G       = read_multi_int64_files(format_str, LLAMA_L, "MLP_XG", T * CM)
      val REF_MLP_D       = read_multi_int64_files(format_str, LLAMA_L, "MLP_XD", T * C)

      val REF_CLS_X       = read_int64_file (format_str.format(LLAMA_L, "CLS_X"), T * C)
      val REF_CLS         = read_int64_file (format_str.format(LLAMA_L, "CLS"), T * VOCAB)

      val DUT_MHA_Q       = Array.ofDim[Long](LLAMA_L, T * C)
      val DUT_MHA_K       = Array.ofDim[Long](LLAMA_L, T * C)
      val DUT_MHA_V       = Array.ofDim[Long](LLAMA_L, T * C)
      val DUT_MHA_O       = Array.ofDim[Long](LLAMA_L, T * C)
      val DUT_MLP_U       = Array.ofDim[Long](LLAMA_L, T * CM)
      val DUT_MLP_G       = Array.ofDim[Long](LLAMA_L, T * CM)
      val DUT_MLP_D       = Array.ofDim[Long](LLAMA_L, T * C)

      // Truncate
      val TRUNC_QK    = 12
      val TRUNC_V     = 6
      val TRUNC_O     = 11
      val TRUNC_UG    = 8
      val TRUNC_D     = 9

      val TRUNC_BASE  = 6 // minimum truncation

      // initialize streams
      init_i_stream(dut.io.i_stream)
      init_i_stream(dut.io.w_stream)
      init_i_stream(dut.io.s_stream)
      init_i_stream(dut.io.s1_stream)
      init_i_stream(dut.io.s2_stream)
      init_o_stream(dut.io.o_stream)
      init_daisy_chain(dut.io.signals)

      // fork clock
      init_clock(dut.clockDomain, 10)

      // fork streams
      Array(
        fork {
          dut.io.signals.I.L_BEGIN #= L_BEGIN
          dut.io.signals.I.L_CLOSE #= L_CLOSE
          // delay 20 cycles to make sure the signals are set
          dut.clockDomain.waitSampling(20)
          // launch with trigger
          dut.io.signals.I.T #= true
          dut.clockDomain.waitSampling()
          dut.io.signals.I.T #= false
        },
        // quantized input data streams
        fork {
          for (l <- L_BEGIN until L_CLOSE) {
            array2stream(dut.io.i_stream, dut.clockDomain, REF_MHA_XLN_Q(l), CT,  1, T, TP, C, CIP, info = "XLN_Q for Q") // Q
            array2stream(dut.io.i_stream, dut.clockDomain, REF_MHA_XLN_Q(l), CT,  1, T, TP, C, CIP, info = "XLN_Q for K") // K
            array2stream(dut.io.i_stream, dut.clockDomain, REF_MHA_XLN_Q(l), CT,  1, T, TP, C, CIP, info = "XLN_Q for V") // V
            array2stream(dut.io.i_stream, dut.clockDomain, REF_MHA_A_Q(l),   CT,  1, T, TP, C, CIP, info = "A_Q   for O") // A
            array2stream(dut.io.i_stream, dut.clockDomain, REF_MLP_XLN_Q(l), CMT, 1, T, TP, C, CIP, info = "XLN_Q for U") // U
            array2stream(dut.io.i_stream, dut.clockDomain, REF_MLP_XLN_Q(l), CMT, 1, T, TP, C, CIP, info = "XLN_Q for G") // G
            array2stream(dut.io.i_stream, dut.clockDomain, REF_MLP_XM_Q(l),  CT,  1, T, TP, CM, CIP, info = "XM_Q  for D") // D
          }
        },
        // quantized input scales streams
        fork {
          for (l <- L_BEGIN until L_CLOSE) {
            array2stream(dut.io.s_stream, dut.clockDomain, REF_MHA_XLN_S(l), CT,  1, T, TP, CT, 1, info = "XLN_S for Q") // Q
            array2stream(dut.io.s_stream, dut.clockDomain, REF_MHA_XLN_S(l), CT,  1, T, TP, CT, 1, info = "XLN_S for K") // K
            array2stream(dut.io.s_stream, dut.clockDomain, REF_MHA_XLN_S(l), CT,  1, T, TP, CT, 1, info = "XLN_S for V") // V
            array2stream(dut.io.s_stream, dut.clockDomain, REF_MHA_A_S(l),   CT,  1, T, TP, CT, 1, info = "A_S   for O") // A
            array2stream(dut.io.s_stream, dut.clockDomain, REF_MLP_XLN_S(l), CMT, 1, T, TP, CT, 1, info = "XLN_S for U") // U
            array2stream(dut.io.s_stream, dut.clockDomain, REF_MLP_XLN_S(l), CMT, 1, T, TP, CT, 1, info = "XLN_S for G") // G
            array2stream(dut.io.s_stream, dut.clockDomain, REF_MLP_XM_S(l),  CT,  1, T, TP, CMT, 1, info = "XM_S  for D") // D
          }
        },
        // quantized weights streams
        fork {
          for (l <- L_BEGIN until L_CLOSE) {
            array2stream(dut.io.w_stream, dut.clockDomain, REF_WQ_Q(l), 1, 1, C, COP, C, CIP, verbose = true, info = "WQ for Q") // WQ
            array2stream(dut.io.w_stream, dut.clockDomain, REF_WK_Q(l), 1, 1, C, COP, C, CIP, verbose = true, info = "WK for K") // WK
            array2stream(dut.io.w_stream, dut.clockDomain, REF_WV_Q(l), 1, 1, C, COP, C, CIP, verbose = true, info = "WV for V") // WV
            array2stream(dut.io.w_stream, dut.clockDomain, REF_WO_Q(l), 1, 1, C, COP, C, CIP, verbose = true, info = "WO for O") // WO
            array2stream(dut.io.w_stream, dut.clockDomain, REF_WU_Q(l), 1, 1, CM, COP, C, CIP, verbose = true, info = "WU for U") // WU
            array2stream(dut.io.w_stream, dut.clockDomain, REF_WG_Q(l), 1, 1, CM, COP, C, CIP, verbose = true, info = "WG for G") // WG
            array2stream(dut.io.w_stream, dut.clockDomain, REF_WD_Q(l), 1, 1, C, COP, CM, CIP, verbose = true, info = "WD for D") // WD
          }
        },
        // quantized weights scales streams 1
        fork {
          for (l <- L_BEGIN until L_CLOSE) {
            array2stream(dut.io.s1_stream, dut.clockDomain, REF_WQ_S1(l), 1, 1, C, COP, CT, 1, info = "WS1 for Q") // WQ
            array2stream(dut.io.s1_stream, dut.clockDomain, REF_WK_S1(l), 1, 1, C, COP, CT, 1, info = "WS1 for K") // WK
            array2stream(dut.io.s1_stream, dut.clockDomain, REF_WV_S1(l), 1, 1, C, COP, CT, 1, info = "WS1 for V") // WV
            array2stream(dut.io.s1_stream, dut.clockDomain, REF_WO_S1(l), 1, 1, C, COP, CT, 1, info = "WS1 for O") // WO
            array2stream(dut.io.s1_stream, dut.clockDomain, REF_WU_S1(l), 1, 1, CM, COP, CT, 1, info = "WS1 for U") // WU
            array2stream(dut.io.s1_stream, dut.clockDomain, REF_WG_S1(l), 1, 1, CM, COP, CT, 1, info = "WS1 for G") // WG
            array2stream(dut.io.s1_stream, dut.clockDomain, REF_WD_S1(l), 1, 1, C, COP, CMT, 1, info = "WS1 for D") // WD
          }
        },
        // quantized weights scales streams 2
        fork {
          for (l <- L_BEGIN until L_CLOSE) {
            array2stream(dut.io.s2_stream, dut.clockDomain, REF_WQ_S2(l), 1, 1, C, COP, CT, 1, info = "WS2 for Q") // WQ
            array2stream(dut.io.s2_stream, dut.clockDomain, REF_WK_S2(l), 1, 1, C, COP, CT, 1, info = "WS2 for K") // WK
            array2stream(dut.io.s2_stream, dut.clockDomain, REF_WV_S2(l), 1, 1, C, COP, CT, 1, info = "WS2 for V") // WV
            array2stream(dut.io.s2_stream, dut.clockDomain, REF_WO_S2(l), 1, 1, C, COP, CT, 1, info = "WS2 for O") // WO
            array2stream(dut.io.s2_stream, dut.clockDomain, REF_WU_S2(l), 1, 1, CM, COP, CT, 1, info = "WS2 for U") // WU
            array2stream(dut.io.s2_stream, dut.clockDomain, REF_WG_S2(l), 1, 1, CM, COP, CT, 1, info = "WS2 for G") // WG
            array2stream(dut.io.s2_stream, dut.clockDomain, REF_WD_S2(l), 1, 1, C, COP, CMT, 1, info = "WS2 for D") // WD
          }
        },
        // output streams
        fork {
          for (l <- L_BEGIN until L_CLOSE) {
            stream2array(dut.io.o_stream, dut.clockDomain, REF_MHA_Q(l), DUT_MHA_Q(l), 1, T, TP, C,  COP, TRUNC_QK - TRUNC_BASE, info = "MHA_Q", unpack = true)
            stream2array(dut.io.o_stream, dut.clockDomain, REF_MHA_K(l), DUT_MHA_K(l), 1, T, TP, C,  COP, TRUNC_QK - TRUNC_BASE, info = "MHA_K", unpack = true)
            stream2array(dut.io.o_stream, dut.clockDomain, REF_MHA_V(l), DUT_MHA_V(l), 1, T, TP, C,  COP, TRUNC_V  - TRUNC_BASE, info = "MHA_V", unpack = true)
            stream2array(dut.io.o_stream, dut.clockDomain, REF_MHA_O(l), DUT_MHA_O(l), 1, T, TP, C,  COP, TRUNC_O  - TRUNC_BASE, info = "MHA_O", unpack = true)
            stream2array(dut.io.o_stream, dut.clockDomain, REF_MLP_U(l), DUT_MLP_U(l), 1, T, TP, CM, COP, TRUNC_UG - TRUNC_BASE, info = "MLP_U", unpack = true)
            stream2array(dut.io.o_stream, dut.clockDomain, REF_MLP_G(l), DUT_MLP_G(l), 1, T, TP, CM, COP, TRUNC_UG - TRUNC_BASE, info = "MLP_G", unpack = true)
            stream2array(dut.io.o_stream, dut.clockDomain, REF_MLP_D(l), DUT_MLP_D(l), 1, T, TP, C,  COP, TRUNC_D  - TRUNC_BASE, info = "MLP_D", unpack = true)
          }
        }
      ).foreach(_.join())

      println(f"L_BEGIN: $L_BEGIN%d, L_CLOSE: $L_CLOSE%d")
      simSuccess()
    }
}

object simulate_gemm_cls extends App {
  redirect_std(s"GEMM.log")

  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )
  spinalConfig.generateVerilog(new GEMM)

  // do simulation
  SimConfig
    .withConfig(spinalConfig)
    .withFstWave
    .withWaveDepth(1)
    .allOptimisation
    .withVerilator
    .addSimulatorFlag("--unroll-count 1024")
    .addSimulatorFlag("-j 16")
    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
    .compile(new GEMM)
    .doSimUntilVoid { dut =>

      val LLAMA_L = 32

      // model hyperparameters
      val C = 4096
      val VOCAB = 32000

      // design hyperparameters
      val T = 8
      val G = 8
      val TP = T
      val CP = G

      // derived hyperparameters
      val CT = C / CP
      val VOCABT = VOCAB / CP

      // read multiple data
      val data_path_prefix = ctrl_cfg.binaries_prefix
      val format_str = s"$data_path_prefix%d/%s.bin"

      val REF_CLS_XLN_Q   = read_int8_file (format_str.format(LLAMA_L, "CLS_XLN_Q"), T  * C)
      val REF_CLS_XLN_S   = read_int8_file (format_str.format(LLAMA_L, "CLS_XLN_S"), T  * CT)
      val REF_CLS_W_Q     = read_int8_file (format_str.format(LLAMA_L, "CLS_W_Q"),   C  * VOCAB)
      val REF_CLS_W_S1    = read_int8_file (format_str.format(LLAMA_L, "CLS_W_S1"),  CT * VOCAB)
      val REF_CLS_W_S2    = read_int8_file (format_str.format(LLAMA_L, "CLS_W_S2"),  CT * VOCAB)

      val REF_CLS         = read_int64_file (format_str.format(LLAMA_L, "CLS"),       T * VOCAB)
      val DUT_CLS         = Array.ofDim[Long](T * VOCAB)

      // Truncate
      val TRUNC_CLS = 10
      val TRUNC_BASE = 8 // minimum truncation

      // initialize streams
      init_i_stream(dut.io.i_stream)
      init_i_stream(dut.io.w_stream)
      init_i_stream(dut.io.s_stream)
      init_i_stream(dut.io.s1_stream)
      init_i_stream(dut.io.s2_stream)
      init_o_stream(dut.io.o_stream)
      init_daisy_chain(dut.io.signals)

      // fork clock
      init_clock(dut.clockDomain, 10)

      // fork streams
      Array(
        fork {
          dut.io.signals.I.L_BEGIN #= LLAMA_L
          dut.io.signals.I.L_CLOSE #= LLAMA_L + 1
          // delay 20 cycles to make sure the signals are set
          dut.clockDomain.waitSampling(20)
          // launch with trigger
          dut.io.signals.I.T #= true
          dut.clockDomain.waitSampling()
          dut.io.signals.I.T #= false
        },
        // quantized input data streams
        fork {
          array2stream(dut.io.i_stream, dut.clockDomain, REF_CLS_XLN_Q, VOCABT, 1, T, TP, C, CP, info="XLN_Q")
        },
        // quantized input scales streams
        fork {
          array2stream(dut.io.s_stream, dut.clockDomain, REF_CLS_XLN_S, VOCABT, 1, T, TP, CT, 1, info="XLN_S")
        },
        // quantized weights streams
        fork {
          array2stream(dut.io.w_stream, dut.clockDomain, REF_CLS_W_Q, 1, 1, VOCAB, CP, C, CP, info="W_Q", verbose = true)
        },
        // quantized weights scales streams 1
        fork {
          array2stream(dut.io.s1_stream, dut.clockDomain, REF_CLS_W_S1, 1, 1, VOCAB, CP, CT, 1, info="W_S1")
        },
        // quantized weights scales streams 2
        fork {
          array2stream(dut.io.s2_stream, dut.clockDomain, REF_CLS_W_S2, 1, 1, VOCAB, CP, CT, 1, info="W_S2")
        },
        // output streams
        fork {
          stream2array(dut.io.o_stream, dut.clockDomain, REF_CLS, DUT_CLS, 1, T, TP, VOCAB, CP, TRUNC_CLS - TRUNC_BASE, info="CLS", unpack = true)
        }
      ).foreach(_.join())

      simSuccess()
    }
}

// @formatter:on
