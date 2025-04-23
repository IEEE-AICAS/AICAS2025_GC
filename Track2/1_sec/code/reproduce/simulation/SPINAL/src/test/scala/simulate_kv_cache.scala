//import spinal.core._
//import spinal.core.sim._
//import spinal.lib.bus.amba4.axi.sim.{AxiMemorySim, AxiMemorySimConfig}
//import utils._
//
//// @formatter:off
//object simulate_kv_cache extends App {
//  redirect_std("KV_CACHE.log")
//  // spinal config
//  val spinalConfig: SpinalConfig = SpinalConfig(
//    defaultConfigForClockDomains = ClockDomainConfig(
//      resetKind = SYNC,
//      resetActiveLevel = LOW
//    )
//  )
//  SpinalVerilog(spinalConfig)(new KV_CACHE).mergeRTLSource()
//
//  // simulation hyperparameters
//  val LLAMA_L = 24
//  val L_BEGIN = 0
//  val L_CLOSE = 1
//  val POS = 8
//  // model hyperparameters
//  val H = 14
//  val T = 8
//  val T_LOAD = 128
//  val S_LOAD = 128
//  val S = 256  // context length
//  val C = 896
//  val HC = C / H
//  val CM = 4846
//  val VOCAB = 151936
//  // design hyperparameters
//  val TP = 1
//  val G = 8
//  val CP = G
//  val SP = G
//  // derived hyperparameters
//  val CHUNK = POS / SP
//  val TT = T / TP
//  val ST_LOAD = S_LOAD / TP
//  val TST = T / SP
//  val ST = S / SP
//  val CT = C / CP
//  val HCT = HC / CP
//  val VOCABT = VOCAB / CP
//  // cache
//  val DW_AQ = 8
//  val DW_AS = 4
//  val AQ_MASK = (1 << DW_AQ) - 1
//  val AS_MASK = (1 << DW_AS) - 1
//  val DW_CACHE_PACK = 128
//  assert(DW_AQ*CP + DW_AS <= DW_CACHE_PACK)
//  assert(DW_AQ*SP + DW_AS <= DW_CACHE_PACK)
//  val K_CACHE_BYTES = LLAMA_L * (S*C) / CP * DW_CACHE_PACK / 8
//  val V_CACHE_BYTES = LLAMA_L * (S*C) / SP * DW_CACHE_PACK / 8
//
//  // calculate the address for memory x and memory y
//  val BASE_OFFSET       = 0x000000100L
//  val MEMORY_K_CACHE    = BASE_OFFSET
//  val MEMORY_V_CACHE    = MEMORY_K_CACHE        + K_CACHE_BYTES
//
//  // print the memory address in hex
//  println(s"MEMORY_K_CACHE: 0x${MEMORY_K_CACHE.toHexString}")
//  println(s"MEMORY_V_CACHE: 0x${MEMORY_V_CACHE.toHexString}")
//
//  println(s"K_CACHE_BYTES:    $K_CACHE_BYTES")
//  println(s"V_CACHE_BYTES:    $V_CACHE_BYTES")
//
//  // load KV cache data
//  val format_str = s"${ctrl_cfg.binaries_prefix}%d/%s.bin"
//  val KQ_CACHE = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_K_Q",  H*T_LOAD*HC      ), H, H, S_LOAD,   0,  S,   HC,      HC )
//  val KS_CACHE = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_K_S",  H*T_LOAD*HCT     ), H, H, S_LOAD,   0,  S,   HCT,     HCT)
//  val VQ_CACHE = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_VT_Q", H*HC    *S_LOAD  ), H, H, HC,       0,  HC,  S_LOAD,  S  )
//  val VS_CACHE = cut_array[Byte](read_multi_int8_files (format_str, LLAMA_L, "MHA_VT_S", H*HC    *ST_LOAD ), H, H, HC,       0,  HC,  ST_LOAD, ST )
//
//
//  def launch_sim(dut: KV_CACHE, pos: Int): Unit = {
//    // set input scalars
//    dut.io.signals.I.L_BEGIN          #= L_BEGIN
//    dut.io.signals.I.L_CLOSE          #= L_CLOSE
//    dut.io.signals.I.POS_ID           #= pos
//    dut.io.signals.I.MEMORY_K_CACHE   #= MEMORY_K_CACHE
//    dut.io.signals.I.MEMORY_V_CACHE   #= MEMORY_V_CACHE
//    dut.clockDomain.waitSampling()
//    // trigger
//    dut.io.signals.I.T #= true
//    dut.clockDomain.waitSampling()
//    dut.io.signals.I.T #= false
//
//    dut.clockDomain.waitSamplingWhere(dut.io.idle.toBoolean)
//  }
//
//  SimConfig
//    .withConfig(spinalConfig)
//    .allOptimisation
//    .withFstWave
//    .withWaveDepth(1)
//    .withVerilator
//    .addSimulatorFlag("--unroll-count 1024")
//    .addSimulatorFlag("-j 16")
//    .addSimulatorFlag("-O3 --x-assign fast --x-initial fast --noassert")
//    .compile(new KV_CACHE)
//    .doSimUntilVoid { dut =>
//      val axi_mem_config = AxiMemorySimConfig(
//        maxOutstandingReads   = 32,
//        maxOutstandingWrites  = 16,
//        readResponseDelay     = 50,
//        writeResponseDelay    = 50,
//        interruptProbability  = 0, // TODO: if not 0, consuming more time
//        interruptMaxDelay     = 50,
//        defaultBurstType      = 1,
//        useAlteraBehavior     = false
//      )
//      val axi_sim_gmem1 = AxiMemorySim(dut.io.gmem1, dut.clockDomain, axi_mem_config)
//      val axi_sim_gmem2 = AxiMemorySim(dut.io.gmem2, dut.clockDomain, axi_mem_config)
//      axi_sim_gmem1.reset()
//      axi_sim_gmem2.reset()
//
//      // set KV cache to 0
//      axi_sim_gmem1.memory.writeBigInt(MEMORY_K_CACHE, 0, K_CACHE_BYTES)
//      axi_sim_gmem2.memory.writeBigInt(MEMORY_V_CACHE, 0, V_CACHE_BYTES)
//
//      // prepare ref input cache and dut output cache
//      val REF_KQ_CACHE  = Array.ofDim[Byte](LLAMA_L, H  *S  *HC )
//      val REF_KS_CACHE  = Array.ofDim[Byte](LLAMA_L, H  *S  *HCT)
//      val DUT_KQ_CACHE  = Array.ofDim[Byte](LLAMA_L, H  *S  *HC )
//      val DUT_KS_CACHE  = Array.ofDim[Byte](LLAMA_L, H  *S  *HCT)
//
//      val REF_VQ_CACHE  = Array.ofDim[Byte](LLAMA_L, H  *HC *S  )
//      val REF_VS_CACHE  = Array.ofDim[Byte](LLAMA_L, H  *HC *ST )
//      val DUT_VQ_CACHE  = Array.ofDim[Byte](LLAMA_L, H  *HC *S  )
//      val DUT_VS_CACHE  = Array.ofDim[Byte](LLAMA_L, H  *HC *ST )
//
//      val REF_KQ        = Array.ofDim[Byte](LLAMA_L, H  *T  *HC )
//      val REF_KS        = Array.ofDim[Byte](LLAMA_L, H  *T  *HCT)
//      val REF_VQ        = Array.ofDim[Byte](LLAMA_L, H  *HC *T  )
//      val REF_VS        = Array.ofDim[Byte](LLAMA_L, H  *HC *TST)
//
//      // put KV cache (length=pos) into memory
//      // K CACHE order: [L, H, S, HCT, CP]
//      for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; s <- 0 until POS; hct <- 0 until HCT){
//        // fetch a tile of CP size
//        val kq_vec = new Array[Byte](CP)
//        val ks_vec = new Array[Byte](1)
//        for(cp <- 0 until CP) {
//          kq_vec(cp) = KQ_CACHE(l)(h*S*HCT*CP + s*HCT*CP + hct*CP + cp)
//        }
//        ks_vec(0) = KS_CACHE(l)(h*S*HCT + s*HCT + hct)
//        // concat to one bigint, lower index on lower bits
//        var k_cache_bigint: BigInt = BigInt(0)
//        for(cp <- 0 until CP){
//          k_cache_bigint = k_cache_bigint | (BigInt( kq_vec(cp) ) & AQ_MASK) << (DW_AQ*cp)
//        }
//        k_cache_bigint = k_cache_bigint | (BigInt( ks_vec(0) ) & AS_MASK) << (DW_AQ*CP)
//        // write into gmem
//        val k_cache_addr = MEMORY_K_CACHE + (l*H*S*HCT + h*S*HCT + s*HCT + hct) * DW_CACHE_PACK / 8
//        axi_sim_gmem1.memory.writeBigInt(k_cache_addr, k_cache_bigint, DW_CACHE_PACK / 8)
//        // write into ref cache
//        for(cp <- 0 until CP){
//          REF_KQ_CACHE(l)(h*S*HCT*CP + s*HCT*CP + hct*CP + cp) = kq_vec(cp)
//        }
//        REF_KS_CACHE(l)(h*S*HCT + s*HCT + hct) = ks_vec(0)
//      }
//
//      // put V cache (length=pos) into memory
//      // V CACHE order: [L, H, HC, ST, SP]
//      for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; hc <- 0 until HC; st <- 0 until CHUNK){
//        val vq_vec = new Array[Byte](SP)
//        val vs_vec = new Array[Byte](1)
//        for(sp <- 0 until SP){
//          vq_vec(sp) = VQ_CACHE(l)(h*HC*ST*SP + hc*ST*SP + st*SP + sp)
//        }
//        vs_vec(0) = VS_CACHE(l)(h*HC*ST + hc*ST + st)
//        // concat to one bigint, lower index on lower bits
//        var v_cache_bigint: BigInt = BigInt(0)
//        for(sp <- 0 until SP){
//          v_cache_bigint = v_cache_bigint | (BigInt( vq_vec(sp) ) & AQ_MASK) << (DW_AQ*sp)
//        }
//        v_cache_bigint = v_cache_bigint | (BigInt( vs_vec(0) ) & AS_MASK) << (DW_AQ*SP)
//        // write into gmem
//        val v_cache_addr = MEMORY_V_CACHE + (l*H*HC*ST + h*HC*ST + hc*ST + st) * DW_CACHE_PACK / 8
//        axi_sim_gmem2.memory.writeBigInt(v_cache_addr, v_cache_bigint, DW_CACHE_PACK / 8)
//        // write into ref cache
//        for(sp <- 0 until SP){
//          REF_VQ_CACHE(l)(h*HC*ST*SP + hc*ST*SP + st*SP + sp) = vq_vec(sp)
//        }
//        REF_VS_CACHE(l)(h*HC*ST + hc*ST + st) = vs_vec(0)
//      }
//
//      // put into REF CACHE, with given offset POS
//      // put K CACHE
//      for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; s <- POS until POS+T; hct <- 0 until HCT){
//        for(cp <- 0 until CP){
//          REF_KQ(l)(h*T*HC + (s-POS)*HC + hct*CP + cp) = KQ_CACHE(l)(h*S*HCT*CP + s*HCT*CP + hct*CP + cp)
//        }
//        REF_KS(l)(h*T*HCT + (s-POS)*HCT + hct) = KS_CACHE(l)(h*S*HCT + s*HCT + hct)
//      }
//      // put V CACHE
//      for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; hc <- 0 until HC; st <- CHUNK until CHUNK+TST){
//        for(sp <- 0 until SP){
//          REF_VQ(l)(h*HC*T + hc*T + (st-CHUNK)*SP + sp) = VQ_CACHE(l)(h*HC*ST*SP + hc*ST*SP + st*SP + sp)
//        }
//        REF_VS(l)(h*HC*TST + hc*TST + (st-CHUNK)) = VS_CACHE(l)(h*HC*ST + hc*ST + st)
//      }
//
//      // initialization
//      init_clock(dut.clockDomain, 10)
//      // launch simulation
//      Array(
//        fork{ launch_sim(dut, POS) },
//        fork{for(l <- L_BEGIN until L_CLOSE) {stream2array(dut.io.kq_cache_i_stream, dut.clockDomain, REF_KQ_CACHE(l), DUT_KQ_CACHE(l),   H,  S,  1,  HC,   CP, info = "load KQ_CACHE", compare=false)}},
//        fork{for(l <- L_BEGIN until L_CLOSE) {array2stream(dut.io.kq_cache_o_stream, dut.clockDomain, REF_KQ(l), 1,                       H,  T,  1,  HC,   CP, info = "overwrite KQ")}},
//        fork{for(l <- L_BEGIN until L_CLOSE) {stream2array(dut.io.ks_cache_i_stream, dut.clockDomain, REF_KS_CACHE(l), DUT_KS_CACHE(l),   H,  S,  1,  HCT,  1,  info = "load KS_CACHE", compare=false)}},
//        fork{for(l <- L_BEGIN until L_CLOSE) {array2stream(dut.io.ks_cache_o_stream, dut.clockDomain, REF_KS(l), 1,                       H,  T,  1,  HCT,  1,  info = "overwrite KS")}},
//        fork{for(l <- L_BEGIN until L_CLOSE) {stream2array(dut.io.vq_cache_i_stream, dut.clockDomain, REF_VQ_CACHE(l), DUT_VQ_CACHE(l),   H,  HC, 1,  S,    SP, info = "load VQ_CACHE", compare=false)}},
//        fork{for(l <- L_BEGIN until L_CLOSE) {array2stream(dut.io.vq_cache_o_stream, dut.clockDomain, REF_VQ(l), 1,                       H,  HC, 1,  T,    SP, info = "overwrite VQ")}},
//        fork{for(l <- L_BEGIN until L_CLOSE) {stream2array(dut.io.vs_cache_i_stream, dut.clockDomain, REF_VS_CACHE(l), DUT_VS_CACHE(l),   H,  HC, 1,  ST,   1,  info = "load VS_CACHE", compare=false)}},
//        fork{for(l <- L_BEGIN until L_CLOSE) {array2stream(dut.io.vs_cache_o_stream, dut.clockDomain, REF_VS(l), 1,                       H,  HC, 1,  TST,  1,  info = "overwrite VS")}}
//      ).foreach(_.join)
//
//      dut.clockDomain.waitSampling(1000)
//
//      // compare the CACHE, only in the range of POS
//      // compare KQ_CACHE and KS_CACHE
//      for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; s <- 0 until POS; hct <- 0 until HCT){
//        for(cp <- 0 until CP){
//          assert(DUT_KQ_CACHE(l)(h*S*HCT*CP + s*HCT*CP + hct*CP + cp) == REF_KQ_CACHE(l)(h*S*HCT*CP + s*HCT*CP + hct*CP + cp))
//        }
//        assert(DUT_KS_CACHE(l)(h*S*HCT + s*HCT + hct) == REF_KS_CACHE(l)(h*S*HCT + s*HCT + hct))
//      }
//      // compare VQ_CACHE and VS_CACHE
//      for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; hc <- 0 until HC; st <- 0 until CHUNK){
//        for(sp <- 0 until SP){
//          assert(DUT_VQ_CACHE(l)(h*HC*ST*SP + hc*ST*SP + st*SP + sp) == REF_VQ_CACHE(l)(h*HC*ST*SP + hc*ST*SP + st*SP + sp))
//        }
//        assert(DUT_VS_CACHE(l)(h*HC*ST + hc*ST + st) == REF_VS_CACHE(l)(h*HC*ST + hc*ST + st))
//      }
//
//      // check written K and V cache, read from memory, unpack and compare
//      // check K CACHE
//      for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; s <- POS until POS+T; hct <- 0 until HCT){
//        val k_cache_addr = MEMORY_K_CACHE + (l*H*S*HCT + h*S*HCT + s*HCT + hct) * DW_CACHE_PACK / 8
//        val k_cache_bigint = axi_sim_gmem1.memory.readBigInt(k_cache_addr, DW_CACHE_PACK / 8)
//        for(cp <- 0 until CP){
//          var kq = (k_cache_bigint >> (DW_AQ*cp)) & AQ_MASK
////          if(kq >= 32) kq = kq - 64
//          if(kq >= (1<<DW_AQ-1)) kq = kq - (1<<DW_AQ)
//          val kq_ref = REF_KQ(l)(h*T*HC + (s-POS)*HC + hct*CP + cp)
//          if(kq != kq_ref) {
//            println(s"KQ l=$l, h=$h, s=$s, hct=$hct, cp=$cp, kq=$kq, ref=$kq_ref")
//          }
//        }
//        val ks = (k_cache_bigint >> (DW_AQ*CP)) & AS_MASK
//        val ks_ref = REF_KS(l)(h*T*HCT + (s-POS)*HCT + hct)
//        if(ks != ks_ref) {
//          println(s"KS l=$l, h=$h, s=$s, hct=$hct, ks=$ks, ref=${ks_ref}")
//        }
//      }
//
//      // check V CACHE
//      for(l <- L_BEGIN until L_CLOSE; h <- 0 until H; hc <- 0 until HC; st <- CHUNK until CHUNK+TST){
//        val v_cache_addr = MEMORY_V_CACHE + (l*H*HC*ST + h*HC*ST + hc*ST + st) * DW_CACHE_PACK / 8
//        val v_cache_bigint = axi_sim_gmem2.memory.readBigInt(v_cache_addr, DW_CACHE_PACK / 8)
//        for(sp <- 0 until SP){
//          var vq = (v_cache_bigint >> (DW_AQ*sp)) & AQ_MASK
////          if(vq >= 32) vq = vq - 64
//          if(vq >= (1<<DW_AQ-1)) vq = vq - (1<<DW_AQ)
//          val vq_ref = REF_VQ(l)(h*HC*T + hc*T + (st-CHUNK)*SP + sp)
//          if(vq != vq_ref) {
//            println(s"VQ l=$l, h=$h, hc=$hc, st=$st, sp=$sp, vq=$vq, ref=$vq_ref")
//          }
//        }
//        val vs = (v_cache_bigint >> (DW_AQ*SP)) & AS_MASK
//        val vs_ref = REF_VS(l)(h*HC*TST + hc*TST + (st-CHUNK))
//        if(vs != vs_ref) {
//          println(s"VS l=$l, h=$h, hc=$hc, st=$st, vs=$vs, ref=$vs_ref")
//        }
//      }
//
//      // simulation done
//      simSuccess()
//    }
//}