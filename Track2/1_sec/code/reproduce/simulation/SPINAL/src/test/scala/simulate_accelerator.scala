import spinal.core._
import spinal.core.sim._
import spinal.lib.bus.amba4.axi.sim.{AxiMemorySim, AxiMemorySimConfig}
import utils.{AddressSeparableAxiLite4Driver, compare_array, ctrl_cfg, cut_array, init_clock, read_int64_file, read_int8_file, read_multi_int64_files, read_multi_int8_files, redirect_std}

// @formatter:off
object simulate_accelerator extends App {
  redirect_std("ACCELERATOR.log")
  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC,
      resetActiveLevel = LOW
    )
  )
  SpinalVerilog(spinalConfig)(new ACCELERATOR).mergeRTLSource()

  // simulation hyperparameters
  val LLAMA_L         = 24
  val L_BEGIN         = 0
  val L_CLOSE         = 1
  // model hyperparameters
  val T               = 8
  val S               = 192  // context length
  val C               = 896
  val H               = 14
  val CM              = 4864
  val VOCAB           = 151936
  // loading parameters
  val T_LOAD          = 128
  val S_LOAD          = 128
  // design hyperparameters
  val TP              = 1
  val GEMM_TP         = T
  val G               = 8
  val CP              = G
  val SP              = G
  // derived hyperparameters
  val TT              = T     / TP
  val ST              = S     / SP
  val TST             = T     / SP
  val CT              = C     / CP
  val HC              = C     / H
  val HCT             = HC    / CP
  val GEMM_TT         = T     / GEMM_TP
  val VOCABT          = VOCAB / CP
  val ST_LOAD         = S_LOAD / SP
  // WQ parallelism required: G**2, WS parallelism required: G
  val DW_WQ           = 5
  val DW_WS           = 3   // including s1 and s2
  val DW_MAXI         = 256
  val BYTES_PER_X     = 32 / 8
  // decoder
  val DECODER_NUM_WQ  = 3*C*C + C*C + 2*CM*C + C*CM
  val DECODER_NUM_WS  = DECODER_NUM_WQ / G
  val DECODER_W_BYTES = (DECODER_NUM_WQ*DW_WQ + DECODER_NUM_WS*DW_WS*2) / 8
  // cls
  val CLS_NUM_WQ      = VOCAB*C
  val CLS_NUM_WS      = CLS_NUM_WQ / G
  val CLS_W_BYTES     = (CLS_NUM_WQ*DW_WQ + CLS_NUM_WS*DW_WS*2) / 8
  // cache
  val DW_AQ           = 8
  val DW_AS           = 4
  val AQ_MASK         = (1 << DW_AQ) - 1
  val AS_MASK         = (1 << DW_AS) - 1
  val DW_CACHE_PACK   = 128
  assert(DW_AQ*CP + DW_AS <= DW_CACHE_PACK)
  assert(DW_AQ*SP + DW_AS <= DW_CACHE_PACK)
  val K_CACHE_BYTES   = LLAMA_L * (S*C) / CP * DW_CACHE_PACK / 8
  val V_CACHE_BYTES   = LLAMA_L * (S*C) / SP * DW_CACHE_PACK / 8
  val KV_CACHE_BYTES  = K_CACHE_BYTES + V_CACHE_BYTES
  // K and V cache are adjacent in memory, calculate V_CACHE_OFFSET
  val V_CACHE_OFFSET  = K_CACHE_BYTES / (DW_CACHE_PACK / 8)
  // decoder x
  val DECODER_NUM_X   = T * C
  val DECODER_X_BITS  = DECODER_NUM_X * 32
  val DECODER_X_BYTES = DECODER_X_BITS / 8
  // cls y
  val CLS_NUM_Y       = T * VOCAB
  val CLS_Y_BITS      = CLS_NUM_Y * 32
  val CLS_Y_BYTES     = CLS_Y_BITS / 8

  // calculate the address for memory x and memory y
  val BASE_OFFSET       = 0x000000100L
  val MEMORY_DECODER_X  = BASE_OFFSET
  val MEMORY_DECODER_Y  = MEMORY_DECODER_X      + BYTES_PER_X     * DECODER_NUM_X
  val MEMORY_CLS_Y      = MEMORY_DECODER_Y      + BYTES_PER_X     * DECODER_NUM_X
  val MEMORY_DECODER_W  = MEMORY_CLS_Y          + BYTES_PER_X     * CLS_NUM_Y
  val MEMORY_CLS_W      = MEMORY_DECODER_W      + DECODER_W_BYTES * LLAMA_L.toLong
  val MEMORY_K_CACHE    = MEMORY_CLS_W          + CLS_W_BYTES
//  val MEMORY_V_CACHE    = MEMORY_K_CACHE        + K_CACHE_BYTES

  println(s"DECODER_NUM_WQ:   $DECODER_NUM_WQ")
  println(s"DECODER_NUM_WS:   $DECODER_NUM_WS")
  println(s"DECODER_W_BYTES:  $DECODER_W_BYTES")
  println(s"CLS_NUM_WQ:       $CLS_NUM_WQ")
  println(s"CLS_NUM_WS:       $CLS_NUM_WS")
  println(s"CLS_W_BYTES:      $CLS_W_BYTES")
  println(s"DECODER_NUM_X:    $DECODER_NUM_X")
  println(s"DECODER_X_BITS:   $DECODER_X_BITS")
  println(s"DECODER_X_BYTES:  $DECODER_X_BYTES")
  println(s"CLS_NUM_Y:        $CLS_NUM_Y")
  println(s"CLS_Y_BITS:       $CLS_Y_BITS")
  println(s"CLS_Y_BYTES:      $CLS_Y_BYTES")
  println(s"K_CACHE_BYTES:    $K_CACHE_BYTES")
  println(s"V_CACHE_BYTES:    $V_CACHE_BYTES")

  def launch_sim(drv: AddressSeparableAxiLite4Driver, dut: ACCELERATOR, pos: Int): Unit = {
    // write parameters
    drv.write(ctrl_cfg.ADDR_L_BEGIN,          L_BEGIN         )
    drv.write(ctrl_cfg.ADDR_L_CLOSE,          L_CLOSE         )
    drv.write(ctrl_cfg.ADDR_MEMORY_DECODER_X, MEMORY_DECODER_X)
    drv.write(ctrl_cfg.ADDR_MEMORY_DECODER_Y, MEMORY_DECODER_Y)
    drv.write(ctrl_cfg.ADDR_MEMORY_CLS_Y,     MEMORY_CLS_Y    )
    drv.write(ctrl_cfg.ADDR_MEMORY_DECODER_W, MEMORY_DECODER_W)
    drv.write(ctrl_cfg.ADDR_MEMORY_CLS_W,     MEMORY_CLS_W    )
    drv.write(ctrl_cfg.ADDR_MEMORY_K_CACHE,   MEMORY_K_CACHE  )
//    drv.write(ctrl_cfg.ADDR_MEMORY_V_CACHE,   MEMORY_V_CACHE  )
    drv.write(ctrl_cfg.ADDR_POS,              pos             )
    // read the config back and print
    println(f"Reading L_BEGIN:            ${drv.read(ctrl_cfg.ADDR_L_BEGIN          )}")
    println(f"Reading L_CLOSE:            ${drv.read(ctrl_cfg.ADDR_L_CLOSE          )}")
    println(f"Reading MEMORY_DECODER_X: 0x${drv.read(ctrl_cfg.ADDR_MEMORY_DECODER_X )}%X")
    println(f"Reading MEMORY_DECODER_Y: 0x${drv.read(ctrl_cfg.ADDR_MEMORY_DECODER_Y )}%X")
    println(f"Reading MEMORY_CLS_Y:     0x${drv.read(ctrl_cfg.ADDR_MEMORY_CLS_Y     )}%X")
    println(f"Reading MEMORY_DECODER_W: 0x${drv.read(ctrl_cfg.ADDR_MEMORY_DECODER_W )}%X")
    println(f"Reading MEMORY_CLS_W:     0x${drv.read(ctrl_cfg.ADDR_MEMORY_CLS_W     )}%X")
    println(f"Reading MEMORY_K_CACHE:   0x${drv.read(ctrl_cfg.ADDR_MEMORY_K_CACHE   )}%X")
//    println(f"Reading MEMORY_V_CACHE:   0x${drv.read(ctrl_cfg.ADDR_MEMORY_V_CACHE   )}%X")
    println(f"Reading POS:                ${drv.read(ctrl_cfg.ADDR_POS              )}")
    // delay 20 cycles to make sure the signals are set
    dut.clockDomain.waitSampling(20)
    // try to read if idle
    println("idle status: " + drv.read(ctrl_cfg.ADDR_IDLE))
    // launch with trigger
    drv.write(ctrl_cfg.ADDR_T, 1)
    dut.clockDomain.waitSampling(100)
    // wait until idle
    dut.clockDomain.waitSamplingWhere(dut.io.idle.toBoolean)
    println("idle status: " + drv.read(ctrl_cfg.ADDR_IDLE))
    dut.clockDomain.waitSampling(100)
  }

  def load_weight(axi_sim_gmem1: AxiMemorySim): Unit = {
    for (l <- L_BEGIN until L_CLOSE) {
      val condensed_decoder_weight_path = s"${ctrl_cfg.condense_prefix}${l}/CONDENSED_WEIGHT.bin"
      println(s"Loading $condensed_decoder_weight_path")
      if(l == LLAMA_L){
        // load cls weight
        println(s"Loading cls weight")
        val CONDENSED_W = read_int8_file(condensed_decoder_weight_path, CLS_W_BYTES)
        println("CONDENSED_CLS_W:\n " + CONDENSED_W.take     (32).map(x => f"0x${x.toInt}%02x").mkString(", "))
        println("CONDENSED_CLS_W:\n " + CONDENSED_W.takeRight(32).map(x => f"0x${x.toInt}%02x").mkString(", "))
        axi_sim_gmem1.memory.writeArray(MEMORY_CLS_W, CONDENSED_W)
      } else {
        // load decoder weight
        println(s"Loading decoder weight $l")
        val CONDENSED_W = read_int8_file(condensed_decoder_weight_path, DECODER_W_BYTES)
        println("CONDENSED_DECODER_W:\n " + CONDENSED_W.take     (32).map(x => f"0x${x.toInt}%02x").mkString(", "))
        println("CONDENSED_DECODER_W:\n " + CONDENSED_W.takeRight(32).map(x => f"0x${x.toInt}%02x").mkString(", "))
        axi_sim_gmem1.memory.writeArray(MEMORY_DECODER_W + l*(DECODER_W_BYTES).toLong, CONDENSED_W)
      }
    }
  }

  // prepare all reference data
  val format_str = s"${ctrl_cfg.binaries_prefix}%d/%s.bin"
  val num_chunks = 128 / T // saved length is 128
  // load decoder X and Y
  val REF_DECODER_X     = read_multi_int64_files  (format_str, LLAMA_L, "MHA_X",      DECODER_NUM_X*num_chunks)
  val REF_DECODER_Y     = read_multi_int64_files  (format_str, LLAMA_L, "MLP_XD_RES", DECODER_NUM_X*num_chunks)
  // load cls X and Y
  val REF_CLS_X         = read_int64_file(format_str.format(LLAMA_L,    "CLS_X"),     DECODER_NUM_X*num_chunks)
  val REF_CLS_Y         = read_int64_file(format_str.format(LLAMA_L,    "CLS"  ),     CLS_NUM_Y    *num_chunks)


  // load KV cache data
  val KQ_CACHE = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_K_Q",  H*T_LOAD*HC      ), H, H, S_LOAD,   0,  S,   HC,      HC )
  val KS_CACHE = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_K_S",  H*T_LOAD*HCT     ), H, H, S_LOAD,   0,  S,   HCT,     HCT)
  val VQ_CACHE = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_VT_Q", H*HC    *S_LOAD  ), H, H, HC,       0,  HC,  S_LOAD,  S  )
  val VS_CACHE = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_VT_S", H*HC    *ST_LOAD ), H, H, HC,       0,  HC,  ST_LOAD, ST )

  val REF_KQ        = Array.ofDim[Byte](LLAMA_L, H  *T  *HC )
  val REF_KS        = Array.ofDim[Byte](LLAMA_L, H  *T  *HCT)
  val REF_VQ        = Array.ofDim[Byte](LLAMA_L, H  *HC *T  )
  val REF_VS        = Array.ofDim[Byte](LLAMA_L, H  *HC *TST)


  def load_k_cache(pos: Int, axi_sim_gmem2: AxiMemorySim): Unit = {
    // put KV cache (length=pos) into memory
    // K CACHE order: [L, H, S, HCT, CP]
    for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; s <- 0 until pos; hct <- 0 until HCT){
      // fetch a tile of CP size
      val kq_vec = new Array[Byte](CP)
      val ks_vec = new Array[Byte](1)
      for(cp <- 0 until CP) {
        kq_vec(cp) = KQ_CACHE(l)(h*S*HCT*CP + s*HCT*CP + hct*CP + cp)
      }
      ks_vec(0) = KS_CACHE(l)(h*S*HCT + s*HCT + hct)
      // concat to one bigint, lower index on lower bits
      var k_cache_bigint: BigInt = BigInt(0)
      for(cp <- 0 until CP){
        k_cache_bigint = k_cache_bigint | (BigInt( kq_vec(cp) ) & AQ_MASK) << (DW_AQ*cp)
      }
      k_cache_bigint = k_cache_bigint | (BigInt( ks_vec(0) ) & AS_MASK) << (DW_AQ*CP)
      // write into gmem
      val k_cache_addr = MEMORY_K_CACHE + (l*H*S*HCT + h*S*HCT + s*HCT + hct) * DW_CACHE_PACK / 8
      axi_sim_gmem2.memory.writeBigInt(k_cache_addr, k_cache_bigint, DW_CACHE_PACK / 8)
    }
  }

  def load_v_cache(pos: Int, axi_sim_gmem2: AxiMemorySim): Unit = {
    val chunk_id = pos / T
    // put V cache (length=pos) into memory
    // V CACHE order: [L, H, HC, ST, SP]
    for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; hc <- 0 until HC; st <- 0 until chunk_id){
      val vq_vec = new Array[Byte](SP)
      val vs_vec = new Array[Byte](1)
      for(sp <- 0 until SP){
        vq_vec(sp) = VQ_CACHE(l)(h*HC*ST*SP + hc*ST*SP + st*SP + sp)
      }
      vs_vec(0) = VS_CACHE(l)(h*HC*ST + hc*ST + st)
      // concat to one bigint, lower index on lower bits
      var v_cache_bigint: BigInt = BigInt(0)
      for(sp <- 0 until SP){
        v_cache_bigint = v_cache_bigint | (BigInt( vq_vec(sp) ) & AQ_MASK) << (DW_AQ*sp)
      }
      v_cache_bigint = v_cache_bigint | (BigInt( vs_vec(0) ) & AS_MASK) << (DW_AQ*SP)
      // write into gmem
      val v_cache_addr = MEMORY_K_CACHE + (V_CACHE_OFFSET + l*H*HC*ST + h*HC*ST + hc*ST + st) * DW_CACHE_PACK / 8
      axi_sim_gmem2.memory.writeBigInt(v_cache_addr, v_cache_bigint, DW_CACHE_PACK / 8)
    }
  }

  def check_kv_cache(pos: Int, axi_sim_gmem2: AxiMemorySim): Unit = {
    val chunk_id = pos / T
    // get reference KQ, KS, VQ, VS
    for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; s <- pos until pos+T; hct <- 0 until HCT){
      for(cp <- 0 until CP){
        REF_KQ(l)(h*T*HC + (s-pos)*HC + hct*CP + cp) = KQ_CACHE(l)(h*S*HCT*CP + s*HCT*CP + hct*CP + cp)
      }
      REF_KS(l)(h*T*HCT + (s-pos)*HCT + hct) = KS_CACHE(l)(h*S*HCT + s*HCT + hct)
    }
    // put V CACHE
    for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; hc <- 0 until HC; st <- chunk_id until chunk_id+TST){
      for(sp <- 0 until SP){
        REF_VQ(l)(h*HC*T + hc*T + (st-chunk_id)*SP + sp) = VQ_CACHE(l)(h*HC*ST*SP + hc*ST*SP + st*SP + sp)
      }
      REF_VS(l)(h*HC*TST + hc*TST + (st-chunk_id)) = VS_CACHE(l)(h*HC*ST + hc*ST + st)
    }

    // check K CACHE
    for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; s <- pos until pos+T; hct <- 0 until HCT){
      val k_cache_addr = MEMORY_K_CACHE + (l*H*S*HCT + h*S*HCT + s*HCT + hct) * DW_CACHE_PACK / 8
      val k_cache_bigint = axi_sim_gmem2.memory.readBigInt(k_cache_addr, DW_CACHE_PACK / 8)
      for(cp <- 0 until CP){
        var kq = (k_cache_bigint >> (DW_AQ*cp)) & AQ_MASK
//        if(kq >= 32) kq = kq - 64
        if(kq >= (1<<(DW_AQ-1))) kq = kq - (1<<DW_AQ)
        val kq_ref = REF_KQ(l)(h*T*HC + (s-pos)*HC + hct*CP + cp)
        if(kq != kq_ref) {
          println(s"Different KQ l=$l, h=$h, s=$s, hct=$hct, cp=$cp, kq=$kq, ref=$kq_ref")
        } else {
//          println(s"Same KQ l=$l, h=$h, s=$s, hct=$hct, cp=$cp, kq=$kq, ref=$kq_ref")
        }
      }
      val ks = (k_cache_bigint >> (DW_AQ*CP)) & AS_MASK
      val ks_ref = REF_KS(l)(h*T*HCT + (s-pos)*HCT + hct)
      if(ks != ks_ref) {
        println(s"Different KS l=$l, h=$h, s=$s, hct=$hct, ks=$ks, ref=${ks_ref}")
      }
    }

    // check V CACHE
    for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; hc <- 0 until HC; st <- chunk_id until chunk_id+TST){
      val v_cache_addr = MEMORY_K_CACHE + (V_CACHE_OFFSET + l*H*HC*ST + h*HC*ST + hc*ST + st) * DW_CACHE_PACK / 8
      val v_cache_bigint = axi_sim_gmem2.memory.readBigInt(v_cache_addr, DW_CACHE_PACK / 8)
      for(sp <- 0 until SP){
        var vq = (v_cache_bigint >> (DW_AQ*sp)) & AQ_MASK
//        if(vq >= 32) vq = vq - 64
        if(vq >= (1<<(DW_AQ-1))) vq = vq - (1<<DW_AQ)
        val vq_ref = REF_VQ(l)(h*HC*T + hc*T + (st-chunk_id)*SP + sp)
        if(vq != vq_ref) {
          println(s"VQ l=$l, h=$h, hc=$hc, st=$st, sp=$sp, vq=$vq, ref=$vq_ref")
        }
      }
      val vs = (v_cache_bigint >> (DW_AQ*SP)) & AS_MASK
      val vs_ref = REF_VS(l)(h*HC*TST + hc*TST + (st-chunk_id))
      if(vs != vs_ref) {
        println(s"VS l=$l, h=$h, hc=$hc, st=$st, vs=$vs, ref=$vs_ref")
      }
    }
  }

  def load_data(pos: Int, axi_sim_gmem1: AxiMemorySim): Array[Long] = {
    val chunk_id = pos / T
    // load decoder X into memory
    for(tt <- 0 until TT; ct <- 0 until CT; tp <- 0 until TP; cp <- 0 until CP) {
      // original    loop: TT -> TP -> CT -> CP
      // accelerator loop: TT -> CT -> TP -> CP
      val ref_idx = tt*TP*CT*CP + tp*CT*CP + ct*CP + cp + chunk_id*DECODER_NUM_X
      val axi_idx = tt*CT*TP*CP + ct*TP*CP + tp*CP + cp
      val ref_val = BigInt{
        if (L_BEGIN == LLAMA_L) REF_CLS_X(ref_idx)
        else REF_DECODER_X(L_BEGIN)(ref_idx)
      }
      // consider the sign problem, if <0, convert to complement
      val axi_val = if (ref_val < 0) (BigInt(1) << 32) + ref_val else ref_val
      axi_sim_gmem1.memory.writeBigInt(MEMORY_DECODER_X + axi_idx * BYTES_PER_X, axi_val, BYTES_PER_X)
    }
    // create reference y and return
    val REF_Y   = Array.ofDim[Long](T*C)
    val REF_CLS = Array.ofDim[Long](T*VOCAB)
    if(L_CLOSE == LLAMA_L){
      // put REF_CLS_Y into REF_CLS, with token offset
      for(t <- 0 until T; vocab <- 0 until VOCAB) {
        val ref_idx = t*VOCAB + vocab + chunk_id*T*VOCAB
        REF_CLS(t*VOCAB + vocab) = REF_CLS_Y(ref_idx)
      }
      REF_CLS
    } else {
      // put REF_DECODER_Y into REF_Y, with token offset
      for(t <- 0 until T; c <- 0 until C) {
        val ref_idx = t*C + c + chunk_id*T*C
        REF_Y(t*C + c) = REF_DECODER_Y(L_CLOSE-1)(ref_idx)
      }
      REF_Y
    }
  }

  def get_result(axi_sim_gmem1: AxiMemorySim): Array[Long] = {
    // declare DUT_Y and DUT_CLS
    val DUT_Y             = Array.ofDim[Long](T*C)
    val DUT_CLS           = Array.ofDim[Long](T*VOCAB)

    if(L_CLOSE == LLAMA_L){
      // read from axi_sim and put into DUT_CLS
      for(tt <- 0 until GEMM_TT; vocabt <- 0 until VOCABT; tp <- 0 until GEMM_TP; cp <- 0 until CP) {
        val axi_idx = tt*VOCABT*GEMM_TP*CP + vocabt*GEMM_TP*CP + tp*CP     + cp
        val dut_idx = tt*GEMM_TP*VOCABT*CP + tp*VOCABT*CP      + vocabt*CP + cp
        val axi_val = axi_sim_gmem1.memory.readBigInt(MEMORY_CLS_Y + axi_idx * BYTES_PER_X, BYTES_PER_X)
        val out_val = if ((axi_val >> 31) == 1) (axi_val - (BigInt(1) << 32)).toLong else axi_val.toLong
        DUT_CLS(dut_idx) = out_val
      }
      DUT_CLS
    } else {
      // read from axi_sim and put into DUT_Y, transposed
      for(tt <- 0 until TT; ct <- 0 until CT; tp <- 0 until TP; cp <- 0 until CP) {
        val axi_idx = tt*CT*TP*CP + ct*TP*CP + tp*CP + cp
        val dut_idx = tt*TP*CT*CP + tp*CT*CP + ct*CP + cp
        val axi_val = axi_sim_gmem1.memory.readBigInt(MEMORY_DECODER_Y + axi_idx * BYTES_PER_X, BYTES_PER_X)
        val out_val = if ((axi_val >> 31) == 1) (axi_val - (BigInt(1) << 32)).toLong else axi_val.toLong
        DUT_Y(dut_idx) = out_val
      }
      DUT_Y
    }
  }


  SimConfig
    .withConfig(spinalConfig)
    .allOptimisation
    .withFstWave
    .withWaveDepth(2)
    .withVerilator
    .addSimulatorFlag("--unroll-count 1024")
    .addSimulatorFlag("-j 16")
    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
    .compile(new ACCELERATOR)
    .doSimUntilVoid { dut =>
      val drv = AddressSeparableAxiLite4Driver(dut.io.axilite, dut.clockDomain)
      val axi_mem_config = AxiMemorySimConfig(
        maxOutstandingReads   = 32,
        maxOutstandingWrites  = 16,
        readResponseDelay     = 50,
        writeResponseDelay    = 50,
        interruptProbability  = 0, // TODO: if not 0, consuming more time
        interruptMaxDelay     = 50,
        defaultBurstType      = 1,
        useAlteraBehavior     = false
      )
      val axi_sim_gmem1 = AxiMemorySim(dut.io.gmem1, dut.clockDomain, axi_mem_config)
      val axi_sim_gmem2 = AxiMemorySim(dut.io.gmem2, dut.clockDomain, axi_mem_config)


      // load weight
      load_weight (axi_sim_gmem1)
      // set KV cache to 0
      axi_sim_gmem2.memory.writeBigInt(MEMORY_K_CACHE, 0, KV_CACHE_BYTES)
      // initialization
      init_clock(dut.clockDomain, 10)
      axi_sim_gmem1.reset()
      axi_sim_gmem2.reset()
      drv.reset()

//      load_k_cache(8, axi_sim_gmem2)
//      load_v_cache(8, axi_sim_gmem3)
//      check_kv_cache(0, axi_sim_gmem2, axi_sim_gmem3)

      for(chunk_id <- 0 until 5){
        val pos = chunk_id * T
//        load_k_cache(pos, axi_sim_gmem2)
//        load_v_cache(pos, axi_sim_gmem3)
        val ref_result = load_data(pos, axi_sim_gmem1)
        launch_sim(drv, dut, pos)
        val dut_result = get_result(axi_sim_gmem1)
        compare_array(ref_result, dut_result)
        check_kv_cache(pos, axi_sim_gmem2)
      }
      // should produce correct result

      // simulation done
      simSuccess()
    }
}