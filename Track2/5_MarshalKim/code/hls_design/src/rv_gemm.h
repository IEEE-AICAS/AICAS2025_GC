#ifndef __INT_RV_GEMM_H__
#define __INT_RV_GEMM_H__

// 设计的Consideration：
// 1. R和V的来源不一致。R来自SOFTMAX，是well ordered的，仅需要repeat；V来自MainGEMM，需要re-tile、transpose、quantization
// 2. 其他与QK_GEMM类似，考虑retile产生OS数据流

#include "src/common.h"
#include "src/bmm.h"
#include "src/utils.h"
#include "src/quantizer.h"

template<
    class aq_t,
    class as_t,
    class w_t,      // since V need to be quantized inplace
    class acc_t,    // accumulate type
    class of_t,

    int TRUNC,

    int H,          // multiple heads
    int T,
    int TP,         // for R matrix, is well ordered
    int S,
    int SP,
    int HC,
    int CP
>
class RV_GEMM{
public:
    RV_GEMM(){}

    // some constexprs
    static constexpr int TT      = T / TP;
    static constexpr int TST     = T / SP;
    static constexpr int ST      = S / SP;
    static constexpr int CT      = HC / CP;

    // checks
    static_assert(T  % TP == 0, "T  % TP != 0");
    static_assert(S  % SP == 0, "S  % SP != 0");
    static_assert(HC % CP == 0, "HC % CP != 0");

    // create quantizer for V
    QUANTIZER<w_t, aq_t, as_t, 1, HC,  1, T, SP, SP> quantizer_inst;
    // create bmm
    BMM<aq_t, as_t, aq_t, as_t, acc_t, of_t, TRUNC, H, T, TP, S, SP, HC, CP>  bmm_inst;


    void do_rv_gemm(
        int pos,
        hls::stream<hls::vector<aq_t,   TP*SP > >& rq_stream,
        hls::stream<hls::vector<as_t,   TP    > >& rs_stream,
        hls::stream<hls::vector<w_t,       CP > >& v_stream,            // V is not quantized
        hls::stream<hls::vector<aq_t,      SP > >& vq_cache_i_stream,
        hls::stream<hls::vector<as_t,      1  > >& vs_cache_i_stream,
        hls::stream<hls::vector<aq_t,      SP > >& vq_cache_o_stream,
        hls::stream<hls::vector<as_t,      1  > >& vs_cache_o_stream,
        hls::stream<hls::vector<of_t,   TP*CP > >& o_stream
    ){
        // R streams
        hls::stream<hls::vector<aq_t,   TP*SP > > rq_stream_r ( "rq_stream_r"      );
        hls::stream<hls::vector<as_t,   TP    > > rs_stream_r ( "rs_stream_r"      );
        // V streams
        hls::stream<hls::vector<w_t,       SP > > vt_stream  ( "vt_stream"       );
        hls::stream<hls::vector<aq_t,      SP > > vq_stream  ( "vq_stream"       );
        hls::stream<hls::vector<as_t,      1  > > vs_stream  ( "vs_stream"       );
        hls::stream<hls::vector<aq_t,   CP*SP > > vq_stream_r ( "vq_stream_r"      );
        hls::stream<hls::vector<as_t,   CP    > > vs_stream_r ( "vs_stream_r"      );

        #pragma HLS dataflow

        int s_pos = pos / SP;

        for(int h=0; h<H; ++h){
            #pragma HLS dataflow

            w_t  v_buffer       [T ][HC];
            aq_t vq_cache_buffer[HC][S ];
            as_t vs_cache_buffer[HC][ST];

            #pragma HLS stream variable=v_buffer         type=pipo depth=1
            #pragma HLS stream variable=vq_cache_buffer  type=pipo depth=2
            #pragma HLS stream variable=vs_cache_buffer  type=pipo depth=2

            #pragma HLS array_reshape variable=v_buffer         cyclic factor=TP dim=1
            #pragma HLS array_reshape variable=v_buffer         cyclic factor=CP dim=2
            #pragma HLS array_reshape variable=vq_cache_buffer  cyclic factor=SP dim=2
            #pragma HLS array_reshape variable=vs_cache_buffer  cyclic factor=1  dim=2

            #pragma HLS bind_storage variable=v_buffer         type=ram_2p impl=lutram
            #pragma HLS bind_storage variable=vq_cache_buffer  type=ram_2p impl=bram
            #pragma HLS bind_storage variable=vs_cache_buffer  type=ram_2p impl=lutram

            // quantize v
            pack_tokens         <w_t,  T,           HC, CP> (         v_stream,                                             v_buffer        );
            transpose_tokens    <w_t,  T,   SP,     HC, 1 > (         v_buffer,                                             vt_stream       );
            quantizer_inst      .do_quant                   (         vt_stream,    vq_stream,          vs_stream                           );
            // concat cache
            update_v_cache      <aq_t, HC,  T,      S,  SP> (pos,     vq_stream,    vq_cache_i_stream,  vq_cache_o_stream,  vq_cache_buffer );
            update_v_cache      <as_t, HC,  TST,    ST, 1 > (s_pos,   vs_stream,    vs_cache_i_stream,  vs_cache_o_stream,  vs_cache_buffer );
            // repeat v
            repeat_w_tokens     <aq_t, TT,  HC, CP, S,  SP> (         vq_cache_buffer,                                      vq_stream_r     );
            repeat_w_tokens     <as_t, TT,  HC, CP, ST, 1 > (         vs_cache_buffer,                                      vs_stream_r     );
        }

        for(int h=0; h<H; ++h){
            #pragma HLS dataflow

            aq_t rq_buffer      [T ][S ];
            as_t rs_buffer      [T ][ST];
            #pragma HLS stream variable=rq_buffer        type=pipo depth=1
            #pragma HLS stream variable=rs_buffer        type=pipo depth=1
            #pragma HLS array_reshape variable=rq_buffer        cyclic factor=TP dim=1
            #pragma HLS array_reshape variable=rq_buffer        cyclic factor=SP dim=2
            #pragma HLS array_reshape variable=rs_buffer        cyclic factor=TP dim=1
            #pragma HLS array_reshape variable=rs_buffer        cyclic factor=1  dim=2

            #pragma HLS bind_storage variable=rq_buffer type=ram_2p impl=lutram
            #pragma HLS bind_storage variable=rs_buffer type=ram_2p impl=lutram

            // handling r
            buffer_tokens       <aq_t,      T,  TP, S,  SP> (         rq_stream,                                            rq_buffer       );
            buffer_tokens       <as_t,      T,  TP, ST, 1 > (         rs_stream,                                            rs_buffer       );
            repeat_x_tokens     <aq_t, CT,  T,  TP, S,  SP> (         rq_buffer,                                            rq_stream_r     );
            repeat_x_tokens     <as_t, CT,  T,  TP, ST, 1 > (         rs_buffer,                                            rs_stream_r     );
        }

        bmm_inst.do_bmm     (rq_stream_r,  rs_stream_r,  vq_stream_r, vs_stream_r, o_stream   );
    }

};

#endif