#ifndef __INT_ROPE_QK_H__
#define __INT_ROPE_QK_H__

#include "src/common.h"
#include "src/utils.h"
#include "src/silu.h"
#include "src/quantizer.h"

template<
    class if_t,
    class silu_t,
    class mul_t,
    class aq_t,
    class as_t,
    int T,
    int C,
    int CP,         // also =G
    int SILU_CP,
    int TRUNC
>
class SILU_EM_QUANT{    // EM: element-wise multiplication
public:
    static constexpr int CT     = C  / CP;

    SILU_EM_QUANT() = default;

    static constexpr int G = CP;

    // interleaved U & G, apply SILU on G, and element-wise multiply with U, and quantization

    // declare SILU and quantizer
    // after unpack, TP=1
    SILU        <if_t,  silu_t,           T, 1, C, SILU_CP,  CP   > silu_inst;
    QUANTIZER   <mul_t, AQ_T, AS_T, 1,    T, 1, C,           CP, G> quantizer_inst;

    void stream_split(
        hls::stream<hls::vector<if_t,   CP> > &ug_stream,
        hls::stream<hls::vector<if_t,   CP> > &u_stream,
        hls::stream<hls::vector<if_t,   CP> > &g_stream
    ){
        // for one MM, loop order: TT -> CT -> TP
        // each time has CP elements
        // interleaved U and G:    TT -> CT -> UG -> TP
        for(int ct=0; ct<CT; ++ct){
            for(int ug=0; ug<2; ++ug){
                for(int t=0; t<T; ++t){
                    #pragma HLS pipeline II=1
                    hls::vector<if_t, CP> ug_vec = ug_stream.read();
                    if(ug == 0){
                        u_stream.write(ug_vec);
                    }else{
                        g_stream.write(ug_vec);
                    }
                }
            }
        }
    }

    void stream_merge(
        hls::stream<hls::vector<if_t,   CP> > &u_stream,
        hls::stream<hls::vector<silu_t, CP> > &silu_stream,
        hls::stream<hls::vector<mul_t,  CP> > &mul_stream
    ){
        // for one MM, loop order: TT -> CT -> TP
        // each time has CP elements
        // interleaved U and G:    TT -> CT -> UG -> TP

        for(int ct=0; ct<CT; ++ct){
            for(int t=0; t<T; ++t){
                #pragma HLS pipeline II=1
                hls::vector<if_t,   CP> u_vec    = u_stream   .read();
                hls::vector<silu_t, CP> silu_vec = silu_stream.read();
                hls::vector<mul_t,  CP> mul_vec;
                for(int cp=0; cp<CP; ++cp){
                    mul_vec[cp] = (u_vec[cp] * silu_vec[cp]) >> TRUNC;
                }
                mul_stream.write(mul_vec);
            }
        }
    }

    void do_silu_em_quant(
        hls::stream<hls::vector<if_t, CP> > &ug_stream,
        hls::stream<hls::vector<aq_t,  CP> > &q_stream,
        hls::stream<hls::vector<as_t,  1 > > &s_stream
    ){
        #pragma HLS interface ap_ctrl_chain port=return
        #pragma HLS interface axis port=ug_stream
        #pragma HLS interface axis port=q_stream
        #pragma HLS interface axis port=s_stream

        #pragma HLS aggregate variable=ug_stream compact=bit
        #pragma HLS aggregate variable=q_stream  compact=bit
        #pragma HLS aggregate variable=s_stream  compact=bit

        #pragma HLS dataflow

        // declare streams
        hls::stream<hls::vector<if_t,   CP> > u_stream    ("u_stream"    );
        hls::stream<hls::vector<if_t,   CP> > g_stream    ("g_stream"    );
        hls::stream<hls::vector<silu_t, CP> > silu_stream ("silu_stream" );
        hls::stream<hls::vector<mul_t,  CP> > mul_stream  ("mul_stream"  );

        #pragma HLS stream variable=u_stream    depth=16
        // #pragma HLS stream variable=g_stream    depth=16
        // #pragma HLS stream variable=silu_stream depth=16
        // #pragma HLS stream variable=mul_stream  depth=16


        stream_split           (ug_stream,  u_stream,       g_stream    );
        silu_inst.do_silu      (g_stream,   silu_stream                 );
        stream_merge           (u_stream,   silu_stream,    mul_stream  );
        quantizer_inst.do_quant(mul_stream, q_stream,       s_stream    );
    }



};

#endif