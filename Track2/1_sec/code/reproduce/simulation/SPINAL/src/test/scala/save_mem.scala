import utils._

import scala.language.postfixOps

// @formatter:off
object save_mem extends App {
  // model hyperparameters
  val L = 24
  val C = 896
  val CM = 4864
  val VOCAB = 151936

  // design hyperparameters
  val T = 8
  val G = 8 // WQ parallelism: G*G, WS parallelism: G
  val DW_WQ = 5
  val DW_WS = 3 // including s1 and s2
  val DW_MAXI = 256 // use WQ as standard, and align multiple WS to WQ
  val BYTE_PER_PACK = DW_MAXI / 8
  val WQ_CYCS = 20
  val WS_CYCS = 3

  // derived hyperparameters
  val WQ_PACK_PER_LOOP  = WQ_CYCS*DW_MAXI / (DW_WQ*G*G)
  val WS_PACK_PER_LOOP  = WS_CYCS*DW_MAXI / (DW_WS*2*G)

  val DECODER_NUM_WQ    = 3*C*C + C*C + 2*CM*C + C*CM
  val DECODER_NUM_WS    = DECODER_NUM_WQ / G
  val DECODER_W_CYCS    = (DECODER_NUM_WQ*DW_WQ + DECODER_NUM_WS*DW_WS*2) / DW_MAXI
  val DECODER_LOOPS     = DECODER_W_CYCS / (WQ_CYCS + WS_CYCS)

  val CLS_NUM_WQ        = VOCAB*C
  val CLS_NUM_WS        = CLS_NUM_WQ / G
  val CLS_W_CYCS        = (CLS_NUM_WQ*DW_WQ + CLS_NUM_WS*DW_WS*2) / DW_MAXI
  val CLS_LOOPS         = CLS_W_CYCS / (WQ_CYCS + WS_CYCS)

  // load reference data
  val data_path_prefix = ctrl_cfg.condense_prefix
  val format_str = s"$data_path_prefix%d/%s.bin"

  val REF_CONDENSED_WQ          = read_multi_int8_files (format_str, L,       "CONDENSED_GEMM_W_Q",   DECODER_NUM_WQ)
  val REF_CONDENSED_WS1         = read_multi_int8_files (format_str, L,       "CONDENSED_GEMM_W_S1",  DECODER_NUM_WS)
  val REF_CONDENSED_WS2         = read_multi_int8_files (format_str, L,       "CONDENSED_GEMM_W_S2",  DECODER_NUM_WS)

  val REF_CONDENSED_WQ_CLS      = read_int8_file        (format_str.format(L, "CONDENSED_GEMM_W_Q"),   CLS_NUM_WQ)
  val REF_CONDENSED_WS1_CLS     = read_int8_file        (format_str.format(L, "CONDENSED_GEMM_W_S1"),  CLS_NUM_WS)
  val REF_CONDENSED_WS2_CLS     = read_int8_file        (format_str.format(L, "CONDENSED_GEMM_W_S2"),  CLS_NUM_WS)

  def save_layer(
                  l:Int,
                  w_cycs:Int,
                  loops:Int,
                  ref_wq:Array[Byte],
                  ref_ws1:Array[Byte],
                  ref_ws2:Array[Byte]
                ): Unit = {
    println(s"Composing CONDENSED_W for layer $l")
    val condensed_w = Array.ofDim[Byte](w_cycs * BYTE_PER_PACK)
    for (loop <- 0 until loops) {
      val loop_wq = new Array[BigInt](WQ_PACK_PER_LOOP * G * G)
      val loop_ws = new Array[BigInt](WS_PACK_PER_LOOP * G * 2)
      for (idx <- 0 until WQ_PACK_PER_LOOP * G * G) {
        loop_wq(idx) = BigInt(ref_wq(loop * WQ_PACK_PER_LOOP * G * G + idx))
      }
      for (idx <- 0 until WS_PACK_PER_LOOP * G) {
        loop_ws(idx * 2 + 0) = BigInt(ref_ws1(loop * WS_PACK_PER_LOOP * G + idx))
        loop_ws(idx * 2 + 1) = BigInt(ref_ws2(loop * WS_PACK_PER_LOOP * G + idx))
      }
      val loop_wq_bigint = compose_tile(loop_wq, DW_WQ)
      val loop_ws_bigint = compose_tile(loop_ws, DW_WS)
      val loop_wq_resolved = resolve_tile(loop_wq_bigint, 8, WQ_CYCS * BYTE_PER_PACK, is_signed = false).map(_.toByte)
      val loop_ws_resolved = resolve_tile(loop_ws_bigint, 8, WS_CYCS * BYTE_PER_PACK, is_signed = false).map(_.toByte)
      for (idx <- 0 until WQ_CYCS * BYTE_PER_PACK) {
        condensed_w(loop * (WQ_CYCS + WS_CYCS) * BYTE_PER_PACK + idx) = loop_wq_resolved(idx)
      }
      for (idx <- 0 until WS_CYCS * BYTE_PER_PACK) {
        condensed_w(loop * (WQ_CYCS + WS_CYCS) * BYTE_PER_PACK + WQ_CYCS * BYTE_PER_PACK + idx) = loop_ws_resolved(idx)
      }
    }
    val condensed_file_name = format_str.format(l, s"CONDENSED_WEIGHT")
    val file = new java.io.FileOutputStream(condensed_file_name)
    file.write(condensed_w)
    file.close()
    println(s"Writing to $condensed_file_name done")
  }

    (0 until L+1).par.foreach { l =>
//  Array(0, 1, 2, L).par.foreach { l =>
    if (l < L) {
      save_layer(l, DECODER_W_CYCS, DECODER_LOOPS,  REF_CONDENSED_WQ(l),  REF_CONDENSED_WS1(l),   REF_CONDENSED_WS2(l))
    } else {
      save_layer(l, CLS_W_CYCS,     CLS_LOOPS,      REF_CONDENSED_WQ_CLS, REF_CONDENSED_WS1_CLS,  REF_CONDENSED_WS2_CLS)
    }
  }
}
