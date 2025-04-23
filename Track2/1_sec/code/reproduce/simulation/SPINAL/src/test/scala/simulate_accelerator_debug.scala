//import spinal.core._
//import spinal.core.sim._
//import spinal.lib.bus.amba4.axi.sim._
//import utils._
//import spinal.lib.bus.amba4.axi.Axi4
//import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream
//import spinal.sim.SimThread
//
//
//// @formatter:off
//object simulate_accelerator_debug extends App {
//  redirect_std("ACCELERATOR_DEBUG.log")
//
//  // spinal config
//  val spinalConfig: SpinalConfig = SpinalConfig(
//    defaultConfigForClockDomains = ClockDomainConfig(
//      resetKind = SYNC,
//      resetActiveLevel = LOW
//    )
//  )
//  SpinalVerilog(spinalConfig)(new ACCELERATOR_DEBUG).mergeRTLSource()
//
//  def save_stream(sm: Axi4Stream, clockDomain: ClockDomain, filename: String, cycles: Int): SimThread = {
//    val thread = fork {
//      val file = new java.io.PrintWriter(new java.io.File(filename))
//      try {
//        for (cycle <- 0 until cycles) {
//          clockDomain.waitSamplingWhere(sm.valid.toBoolean)
//          file.println(sm.payload.data.toBigInt.toString(16))
//        }
//      }
//      finally {
//        file.close()
//      }
//    }
//    thread
//  }
//
//  def save_axi(axi: Axi4, clockDomain: ClockDomain, filename: String, cycles: Int): Unit = {
//    val ar_thread = fork {
//      val ar_file = new java.io.PrintWriter(new java.io.File(filename + "_ar"))
//      try {
//        for (cycle <- 0 until cycles) {
//          clockDomain.waitSamplingWhere(axi.ar.valid.toBoolean && axi.ar.ready.toBoolean)
//          ar_file.println(axi.ar.addr.toBigInt.toString(16))
//        }
//      } finally {
//        ar_file.close()
//      }
//    }
//
//    val aw_thread = fork {
//      val aw_file = new java.io.PrintWriter(new java.io.File(filename + "_aw"))
//      try {
//        for (cycle <- 0 until cycles) {
//          clockDomain.waitSamplingWhere(axi.aw.valid.toBoolean && axi.aw.ready.toBoolean)
//          aw_file.println(axi.aw.addr.toBigInt.toString(16))
//        }
//      } finally {
//        aw_file.close()
//      }
//    }
//
//    val w_thread = fork {
//      val w_file = new java.io.PrintWriter(new java.io.File(filename + "_w"))
//      try {
//        for (cycle <- 0 until cycles) {
//          clockDomain.waitSamplingWhere(axi.w.valid.toBoolean && axi.w.ready.toBoolean)
//          w_file.println(axi.w.data.toBigInt.toString(16))
//        }
//      } finally {
//        w_file.close()
//      }
//    }
//
//    val b_thread = fork {
//      val b_file = new java.io.PrintWriter(new java.io.File(filename + "_b"))
//      try {
//        for (cycle <- 0 until cycles) {
//          clockDomain.waitSamplingWhere(axi.b.valid.toBoolean && axi.b.ready.toBoolean)
//          b_file.println(axi.b.resp.toBigInt.toString(16))
//        }
//      } finally {
//        b_file.close()
//      }
//    }
//
//    val r_thread = fork {
//      val r_file = new java.io.PrintWriter(new java.io.File(filename + "_r"))
//      try {
//        for (cycle <- 0 until cycles) {
//          clockDomain.waitSamplingWhere(axi.r.valid.toBoolean && axi.r.ready.toBoolean)
//          r_file.println(axi.r.data.toBigInt.toString(16))
//        }
//      } finally {
//        r_file.close()
//      }
//    }
//  }
//
//  val LLAMA_L = 32
//
//  // simulation hyperparameters
//
//  val L_BEGIN = LLAMA_L - 1
//  val L_CLOSE = LLAMA_L + 1
//
////  val L_BEGIN = 0
////  val L_CLOSE = 1
//
//  // model hyperparameters
//  val T = 8
//  val C = 4096
//  val CM = 11008
//  val VOCAB = 32000
//  // design hyperparameters
//  val TP = 1
//  val GEMM_TP = 8
//  val G = 8
//  val CP = G
//  // derived hyperparameters
//  val TT = T / TP
//  val GEMM_TT = T / GEMM_TP
//  val CT = C / CP
//  val VOCABT = VOCAB / CP
//  // WQ parallelism required: G**2, WS parallelism required: G
//  val DW_WQ = 4
//  val DW_WS = 3 // including s1 and s2
//  val DW_MAXI = G * G * DW_WQ // use WQ as standard, and align multiple WS to WQ
//  val BYTES_PER_X = 32 / 8
//
//  val DECODER_NUM_WQ = 3*C*C + C*C + 2*CM*C + C*CM
//  val DECODER_NUM_WS = DECODER_NUM_WQ / G
//  val DECODER_W_BYTES = (DECODER_NUM_WQ*DW_WQ + DECODER_NUM_WS*DW_WS*2) / 8
//
//  val CLS_NUM_WQ = VOCAB * C
//  val CLS_NUM_WS = CLS_NUM_WQ / G
//  val CLS_W_BYTES = (CLS_NUM_WQ*DW_WQ + CLS_NUM_WS*DW_WS*2) / 8
//
//  val DECODER_NUM_X = T * C
//  val DECODER_X_BITS = DECODER_NUM_X * 32
//  val DECODER_X_BYTES = DECODER_X_BITS / 8
//
//  val CLS_NUM_Y = T * VOCAB
//  val CLS_Y_BITS = CLS_NUM_Y * 32
//  val CLS_Y_BYTES = CLS_Y_BITS / 8
//
//  println(s"DECODER_NUM_WQ:   $DECODER_NUM_WQ")
//  println(s"DECODER_NUM_WS:   $DECODER_NUM_WS")
//  println(s"DECODER_W_BYTES:  $DECODER_W_BYTES")
//  println(s"CLS_NUM_WQ:       $CLS_NUM_WQ")
//  println(s"CLS_NUM_WS:       $CLS_NUM_WS")
//  println(s"CLS_W_BYTES:      $CLS_W_BYTES")
//  println(s"DECODER_NUM_X:    $DECODER_NUM_X")
//  println(s"DECODER_X_BITS:   $DECODER_X_BITS")
//  println(s"DECODER_X_BYTES:  $DECODER_X_BYTES")
//  println(s"CLS_NUM_Y:        $CLS_NUM_Y")
//  println(s"CLS_Y_BITS:       $CLS_Y_BITS")
//  println(s"CLS_Y_BYTES:      $CLS_Y_BYTES")
//
//
//
//  // @formatter:off
//  SimConfig
//    .withConfig(spinalConfig)
//    .allOptimisation
//    .withFstWave
//    .withWaveDepth(1)
//    .withVerilator
//    .addSimulatorFlag("--unroll-count 1024")
//    .addSimulatorFlag("-j 16")
//    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
//    .compile(new ACCELERATOR_DEBUG)
//    .doSimUntilVoid { dut =>
//      val drv = AddressSeparableAxiLite4Driver(dut.io.axilite, dut.clockDomain)
//      val axi_sim = AxiMemorySim(dut.io.m_axi, dut.clockDomain,
//        AxiMemorySimConfig(
//          maxOutstandingReads = 32,
//          maxOutstandingWrites = 16,
//          readResponseDelay = 50,
//          writeResponseDelay = 50,
//          interruptProbability = 0, // TODO: if not 0, consuming more time
//          interruptMaxDelay = 50,
//          defaultBurstType = 1,
//          useAlteraBehavior = false
//        )
//      )
//
//      // calculate the address for memory x and memory y
//      val base_offset       = 0x10000000
//      val memory_decoder_x  = base_offset
//      val memory_decoder_y  = memory_decoder_x      + BYTES_PER_X     * DECODER_NUM_X
//      val memory_cls_y      = memory_decoder_y      + BYTES_PER_X     * DECODER_NUM_X
//      val memory_decoder_w  = memory_cls_y          + BYTES_PER_X     * CLS_NUM_Y
//      val memory_cls_w      = memory_decoder_w      + DECODER_W_BYTES * (L_CLOSE - L_BEGIN)
//
//      // read files
//      val format_str = s"${ctrl_cfg.binaries_prefix}%d/%s.bin"
//      // load decoder X and Y
//      val REF_DECODER_X     = read_multi_int64_files  (format_str, LLAMA_L, "MHA_X",      DECODER_NUM_X)
//      val REF_DECODER_Y     = read_multi_int64_files  (format_str, LLAMA_L, "MLP_XD_RES", DECODER_NUM_X)
//
//      for (l <- L_BEGIN until L_CLOSE) {
//        val condensed_decoder_weight_path = s"${ctrl_cfg.condense_prefix}${l}/CONDENSED_WEIGHT.bin"
//        println(s"Loading $condensed_decoder_weight_path")
//        if(l == LLAMA_L){
//          // load cls weight
//          println(s"Loading cls weight")
//          val CONDENSED_W = read_int8_file(condensed_decoder_weight_path, CLS_W_BYTES)
//          println("CONDENSED_CLS_W:\n " + CONDENSED_W.take     (32).map(x => f"0x${x.toInt}%02x").mkString(", "))
//          println("CONDENSED_CLS_W:\n " + CONDENSED_W.takeRight(32).map(x => f"0x${x.toInt}%02x").mkString(", "))
//          axi_sim.memory.writeArray(memory_cls_w, CONDENSED_W)
//        } else {
//          // load decoder weight
//          println(s"Loading decoder weight $l")
//          val CONDENSED_W = read_int8_file(condensed_decoder_weight_path, DECODER_W_BYTES)
//          println("CONDENSED_DECODER_W:\n " + CONDENSED_W.take     (32).map(x => f"0x${x.toInt}%02x").mkString(", "))
//          println("CONDENSED_DECODER_W:\n " + CONDENSED_W.takeRight(32).map(x => f"0x${x.toInt}%02x").mkString(", "))
//          axi_sim.memory.writeArray(memory_decoder_w + l*DECODER_W_BYTES.toLong, CONDENSED_W)
//        }
//      }
//
//      // load cls X and Y
//      val REF_CLS_X         = read_int64_file(format_str.format(LLAMA_L, "CLS_X"), DECODER_NUM_X)
//      // print first 10 elements of REF_CLS_X, in hex
//      println("REF_CLS_X:\n " + REF_CLS_X.take     (32).map(x => f"0x${x.toInt}%08x").mkString(", "))
//      println("REF_CLS_X:\n " + REF_CLS_X.takeRight(32).map(x => f"0x${x.toInt}%08x").mkString(", "))
//      val REF_CLS           = read_int64_file(format_str.format(LLAMA_L, "CLS"  ), CLS_NUM_Y)
//
//      // declare DUT_Y and DUT_CLS
//      val DUT_Y   = Array.ofDim[Long](T*C)
//      val DUT_CLS = Array.ofDim[Long](T*VOCAB)
//
//      // load decoder X into memory
//      for(tt <- 0 until TT; ct <- 0 until CT; tp <- 0 until TP; cp <- 0 until CP) {
//        // original    loop: TT -> TP -> CT -> CP
//        // accelerator loop: TT -> CT -> TP -> CP
//        val ref_idx = tt*TP*CT*CP + tp*CT*CP + ct*CP + cp
//        val axi_idx = tt*CT*TP*CP + ct*TP*CP + tp*CP + cp
//        // consider the sign problem, if <0, convert to complement
//        val ref_val = BigInt{
//          if (L_BEGIN == LLAMA_L) REF_CLS_X(ref_idx)
//          else REF_DECODER_X(L_BEGIN)(ref_idx)
//        }
//        val axi_val = if (ref_val < 0) (BigInt(1) << 32) + ref_val else ref_val
//        axi_sim.memory.writeBigInt(memory_decoder_x + axi_idx * BYTES_PER_X, axi_val, BYTES_PER_X)
//      }
//      println("axi memory_decoder_x write done")
//
//      // create saving stream array
//      val saving_array = Array(
//        save_stream(dut.io.debug_demux_od_stream,             dut.clockDomain, "compare/golden/ila1_slot0_golden",  16384),
//        save_stream(dut.io.debug_demux_qk_stream,             dut.clockDomain, "compare/golden/ila1_slot1_golden",  16384),
//        save_stream(dut.io.debug_demux_ug_stream,             dut.clockDomain, "compare/golden/ila1_slot2_golden",  16384),
//        save_stream(dut.io.debug_demux_v_stream,              dut.clockDomain, "compare/golden/ila1_slot3_golden",  16384),
//        save_stream(dut.io.debug_demux_cls_stream,            dut.clockDomain, "compare/golden/ila1_slot11_golden",  16384),
//        save_stream(dut.io.debug_gemm_o_stream,               dut.clockDomain, "compare/golden/ila1_slot4_golden",  16384),
//        save_stream(dut.io.debug_inst_m_axi_wq_stream,        dut.clockDomain, "compare/golden/ila1_slot5_golden",  16384),
//        save_stream(dut.io.debug_inst_m_axi_ws1_stream,       dut.clockDomain, "compare/golden/ila1_slot6_golden",  16384),
//        save_stream(dut.io.debug_inst_m_axi_ws2_stream,       dut.clockDomain, "compare/golden/ila1_slot7_golden",  16384),
//        save_stream(dut.io.debug_inst_m_axi_x_stream,         dut.clockDomain, "compare/golden/ila1_slot8_golden",  16384),
//        save_stream(dut.io.debug_mux_q_stream,                dut.clockDomain, "compare/golden/ila1_slot9_golden",  16384),
//        save_stream(dut.io.debug_mux_s_stream,                dut.clockDomain, "compare/golden/ila1_slot10_golden", 16384),
//
//        save_stream(dut.io.debug_qk_gemm_r_stream,            dut.clockDomain, "compare/golden/ila2_slot0_golden",  16384),
//        save_stream(dut.io.debug_residual_res_o_stream,       dut.clockDomain, "compare/golden/ila2_slot1_golden",  16384),
//        save_stream(dut.io.debug_residual_y_stream,           dut.clockDomain, "compare/golden/ila2_slot2_golden",  16384),
//        save_stream(dut.io.debug_rmsnorm_quant_xlnq_stream,   dut.clockDomain, "compare/golden/ila2_slot3_golden",  16384),
//        save_stream(dut.io.debug_rmsnorm_quant_xlns_stream,   dut.clockDomain, "compare/golden/ila2_slot4_golden",  16384),
//        save_stream(dut.io.debug_rope_qk_quant_rot_q_stream,  dut.clockDomain, "compare/golden/ila2_slot5_golden",  16384),
//        save_stream(dut.io.debug_rope_qk_quant_rot_s_stream,  dut.clockDomain, "compare/golden/ila2_slot6_golden",  16384),
//        save_stream(dut.io.debug_rv_gemm_aq_stream,           dut.clockDomain, "compare/golden/ila2_slot7_golden",  16384),
//        save_stream(dut.io.debug_rv_gemm_as_stream,           dut.clockDomain, "compare/golden/ila2_slot8_golden",  16384),
//        save_stream(dut.io.debug_silu_em_quant_q_stream,      dut.clockDomain, "compare/golden/ila2_slot9_golden",  16384),
//        save_stream(dut.io.debug_silu_em_quant_s_stream,      dut.clockDomain, "compare/golden/ila2_slot10_golden", 16384),
//
//        save_stream(dut.io.debug_softmax_quant_rq_stream,     dut.clockDomain, "compare/golden/ila3_slot0_golden",  16384),
//        save_stream(dut.io.debug_softmax_quant_rs_stream,     dut.clockDomain, "compare/golden/ila3_slot1_golden",  16384),
//        save_axi   (dut.io.m_axi,                             dut.clockDomain, "compare/golden/ila3_slot2_golden",  16384)
//      )
//
//      init_clock(dut.clockDomain, 10)
//      axi_sim.reset()
//      drv.reset()
//      // write parameters
//      drv.write(ctrl_cfg.ADDR_L_BEGIN, L_BEGIN)
//      drv.write(ctrl_cfg.ADDR_L_CLOSE, L_CLOSE)
//      drv.write(ctrl_cfg.ADDR_MEMORY_DECODER_X, memory_decoder_x)
//      drv.write(ctrl_cfg.ADDR_MEMORY_DECODER_Y, memory_decoder_y)
//      drv.write(ctrl_cfg.ADDR_MEMORY_CLS_Y,     memory_cls_y)
//      drv.write(ctrl_cfg.ADDR_MEMORY_DECODER_W, memory_decoder_w)
//      drv.write(ctrl_cfg.ADDR_MEMORY_CLS_W,     memory_cls_w)
//      drv.write(ctrl_cfg.ADDR_POS, 0)
//
//      // try to read the config back and print
//      println(f"Reading L_BEGIN:          ${drv.read(ctrl_cfg.ADDR_L_BEGIN)}")
//      println(f"Reading L_CLOSE:          ${drv.read(ctrl_cfg.ADDR_L_CLOSE)}")
//      println(f"Reading MEMORY_DECODER_X: 0x${drv.read(ctrl_cfg.ADDR_MEMORY_DECODER_X)}%X")
//      println(f"Reading MEMORY_DECODER_Y: 0x${drv.read(ctrl_cfg.ADDR_MEMORY_DECODER_Y)}%X")
//      println(f"Reading MEMORY_CLS_Y:     0x${drv.read(ctrl_cfg.ADDR_MEMORY_CLS_Y)}%X")
//      println(f"Reading MEMORY_DECODER_W: 0x${drv.read(ctrl_cfg.ADDR_MEMORY_DECODER_W)}%X")
//      println(f"Reading MEMORY_CLS_W:     0x${drv.read(ctrl_cfg.ADDR_MEMORY_CLS_W)}%X")
//      println(f"Reading POS:              ${drv.read(ctrl_cfg.ADDR_POS)}")
//      // delay 20 cycles to make sure the signals are set
//      dut.clockDomain.waitSampling(20)
//      // try to read if idle
//      println("idle status: " + drv.read(ctrl_cfg.ADDR_IDLE))
//      // launch with trigger
//      drv.write(ctrl_cfg.ADDR_T, 1)
//      dut.clockDomain.waitSampling(100)
//
//      // wait until idle
//      dut.clockDomain.waitSamplingWhere(dut.io.idle.toBoolean)
//      println("idle status: " + drv.read(ctrl_cfg.ADDR_IDLE))
//      dut.clockDomain.waitSampling(10000)
//
//      // read from axi_sim and put into DUT_Y, transposed
//      for(tt <- 0 until TT; ct <- 0 until CT; tp <- 0 until TP; cp <- 0 until CP) {
//        val axi_idx = tt*CT*TP*CP + ct*TP*CP + tp*CP + cp
//        val dut_idx = tt*TP*CT*CP + tp*CT*CP + ct*CP + cp
//        val axi_val = axi_sim.memory.readBigInt(memory_decoder_y + axi_idx * BYTES_PER_X, BYTES_PER_X)
//        val out_val = if ((axi_val >> 31) == 1) (axi_val - (BigInt(1) << 32)).toLong else axi_val.toLong
//        DUT_Y(dut_idx) = out_val
//      }
//
//      // read from axi_sim and put into DUT_CLS
//      for(tt <- 0 until GEMM_TT; vocabt <- 0 until VOCABT; tp <- 0 until GEMM_TP; cp <- 0 until CP) {
//        val axi_idx = tt*VOCABT*GEMM_TP*CP + vocabt*GEMM_TP*CP + tp*CP     + cp
//        val dut_idx = tt*GEMM_TP*VOCABT*CP + tp*VOCABT*CP      + vocabt*CP + cp
//        val axi_val = axi_sim.memory.readBigInt(memory_cls_y + axi_idx * BYTES_PER_X, BYTES_PER_X)
//        val out_val = if ((axi_val >> 31) == 1) (axi_val - (BigInt(1) << 32)).toLong else axi_val.toLong
//        DUT_CLS(dut_idx) = out_val
//      }
//
//      // compare results
//      if(L_CLOSE == LLAMA_L+1){
//        compare_array(REF_CLS, DUT_CLS, in_hex=true)
//      } else {
//        compare_array(REF_DECODER_Y(L_CLOSE-1), DUT_Y, in_hex=true)
//      }
//
//
//      // close all threads
//      //      saving_array.foreach(_.join())
//
//      // simulation done
//      simSuccess()
//    }
//}
//// @formatter:on