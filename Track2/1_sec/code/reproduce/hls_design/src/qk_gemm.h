#ifndef __INT_QK_GEMM_H__
#define __INT_QK_GEMM_H__

// 设计的Consideration：
// 1. 复用了RoPE的输出，而原始数据来源是GEMM，因此需要进行输入的pack
// 2. 在OS数据流之下，Q和K的访问模式恰好一致，使用同样的pack和retile来产生带TP的数据流

#include "src/common.h"
#include "src/bmm.h"
#include "src/buffer.h"
#include "src/utils.h"

template<
    class aq_t,
    class as_t,
    class acc_t,                      
    class of_t,

    int TRUNC,

    int H,          // multiple heads
    int T,
    int TP,         // token parallelism
    int S,
    int SP,         // output channel parallelism
    int HC,
    int CP
>
class QK_GEMM{
public:
    QK_GEMM(){}

    static constexpr int TT         = T  / TP;
    static constexpr int ST         = S  / SP;
    static constexpr int HCT        = HC / CP;

    // checks
    static_assert(T  % TP == 0, "T % TP  != 0");
    static_assert(S  % SP == 0, "S % SP  != 0");
    static_assert(HC % CP == 0, "HC % CP != 0");

    // create bmm
    BMM     <aq_t, as_t, aq_t, as_t, acc_t, of_t, TRUNC, H, T, TP, HC, CP, S, SP>  bmm_inst;

    void do_qk_gemm(
        int pos,
        hls::stream<hls::vector<aq_t,      CP > >& qk_q_stream,         // unpacked tokens
        hls::stream<hls::vector<as_t,      1  > >& qk_s_stream,
        hls::stream<hls::vector<aq_t,      CP > >& kq_cache_i_stream,   // T dim not unrolled, just for loading
        hls::stream<hls::vector<as_t,      1  > >& ks_cache_i_stream,
        hls::stream<hls::vector<aq_t,      CP > >& kq_cache_o_stream,
        hls::stream<hls::vector<as_t,      1  > >& ks_cache_o_stream,
        hls::stream<hls::vector<of_t,   TP*SP > >& o_stream
    ){
        #pragma HLS dataflow
        // distributed streams
        hls::stream<hls::vector<aq_t,      CP > > qq_stream     ("qq_stream"  );
        hls::stream<hls::vector<as_t,      1  > > qs_stream     ("qs_stream"  );
        hls::stream<hls::vector<aq_t,      CP > > kq_stream     ("kq_stream"  );
        hls::stream<hls::vector<as_t,      1  > > ks_stream     ("ks_stream"  );

        hls::stream<hls::vector<aq_t,   TP*CP > > qq_stream_r   ("qq_stream_r");
        hls::stream<hls::vector<as_t,   TP    > > qs_stream_r   ("qs_stream_r");
        hls::stream<hls::vector<aq_t,   SP*CP > > kq_stream_r   ("kq_stream_r");
        hls::stream<hls::vector<as_t,   SP    > > ks_stream_r   ("ks_stream_r");

        split_interleaved_streams<aq_t, H, T, 1, HC,  CP>(qk_q_stream, qq_stream, kq_stream);
        split_interleaved_streams<as_t, H, T, 1, HCT, 1 >(qk_s_stream, qs_stream, ks_stream);

        for(int h=0; h<H; ++h){
            aq_t qq_buffer      [T][HC ];
            as_t qs_buffer      [T][HCT];
            #pragma HLS stream        variable=qq_buffer       type=pipo depth=2
            #pragma HLS stream        variable=qs_buffer       type=pipo depth=2
            #pragma HLS array_reshape variable=qq_buffer       cyclic factor=TP dim=1
            #pragma HLS array_reshape variable=qq_buffer       cyclic factor=CP dim=2
            #pragma HLS array_reshape variable=qs_buffer       cyclic factor=TP dim=1
            #pragma HLS array_reshape variable=qs_buffer       cyclic factor=1  dim=2

            #pragma HLS bind_storage variable=qq_buffer type=ram_2p impl=lutram

            #pragma HLS dataflow

            // pack gemm tokens
            pack_tokens    <aq_t,        T,         HC,   CP>(      qq_stream,                                         qq_buffer        );
            pack_tokens    <as_t,        T,         HCT,  1 >(      qs_stream,                                         qs_buffer        );
            // repeat tokens
            repeat_x_tokens<aq_t,   ST,  T,  TP,    HC,   CP>(      qq_buffer,                                         qq_stream_r      );
            repeat_x_tokens<as_t,   ST,  T,  TP,    HCT,  1 >(      qs_buffer,                                         qs_stream_r      );
        }


        for(int h=0; h<H; ++h){
            aq_t kq_cache_buffer[S][HC ];
            as_t ks_cache_buffer[S][HCT];
            #pragma HLS stream variable=kq_cache_buffer type=pipo depth=2
            #pragma HLS stream variable=ks_cache_buffer type=pipo depth=2
            #pragma HLS array_reshape variable=kq_cache_buffer cyclic factor=CP dim=2
            #pragma HLS array_reshape variable=ks_cache_buffer cyclic factor=1  dim=2
            #pragma HLS bind_storage variable=kq_cache_buffer type=ram_2p impl=bram
            #pragma HLS bind_storage variable=ks_cache_buffer type=ram_2p impl=lutram

            #pragma HLS dataflow

            // concat k and k_cache
            update_k_cache <aq_t,        T,  S,     HC,   CP>(pos,  kq_stream,  kq_cache_i_stream,  kq_cache_o_stream, kq_cache_buffer  );
            update_k_cache <as_t,        T,  S,     HCT,  1 >(pos,  ks_stream,  ks_cache_i_stream,  ks_cache_o_stream, ks_cache_buffer  );
            // repeat tokens
            repeat_w_tokens<aq_t,   TT,  S,  SP,    HC,   CP>(      kq_cache_buffer,                                   kq_stream_r      );
            repeat_w_tokens<as_t,   TT,  S,  SP,    HCT,  1 >(      ks_cache_buffer,                                   ks_stream_r      );
        }


        bmm_inst.do_bmm (qq_stream_r, qs_stream_r, kq_stream_r, ks_stream_r, o_stream);
    }

};

#endif