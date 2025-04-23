#ifndef __INT_ROPE_H__
#define __INT_ROPE_H__

#include "src/common.h"
#include "src/utils.h"

// LLM constants

template<
    int H,
    int T,
    int TP,
    int C,
    int CP
>
class ROPE{
public:
    static constexpr int HC     = C  / H;

    static constexpr int TT     = T  / TP;
    static constexpr int HCT    = HC / CP;

    static constexpr int CP2    = CP / 2;
    static constexpr int HC2    = HC / 2;

    ROPE() = default;

    // interleaved Q & K encoding, call it twice for Q and K

    // stage 1: store sin and cos, and fetch them H times
    // stage 2: apply rotation
    // TODO: insert inplace quantization
    // TODO: add call times for interleaved Q and K, reuse not only on heads, but also on Q&K

    void stage1_cache_cos_sin(
        hls::stream<hls::vector<COS_SIN_T, 2*TP*CP2> > &cos_sin_stream,
        hls::stream<hls::vector<COS_SIN_T, 2*TP*CP2> > &cache_stream
    ){
        // allocate memory for cos and sin, the data is shared between all heads
        COS_SIN_T cos_sin[2][T][HC2]; // [0] for cos, [1] for sin
        #pragma HLS array_reshape variable=cos_sin cyclic factor=CP2 dim=2
        #pragma HLS array_reshape variable=cos_sin complete          dim=3

        // read all cos and sin
        for(int tt=0; tt<TT; ++tt){
            for(int hct=0; hct<HCT; ++hct){
                #pragma HLS pipeline II=1
                // read stream
                hls::vector<COS_SIN_T, TP * CP> cos_sin_vec = cos_sin_stream.read();        // the layout: [0~TP*CP2-1] for cos, [TP*CP2~TP*CP-1] for sin
                // write to buffer
                for(int tp=0; tp<TP; ++tp){
                    for(int cp2=0; cp2<CP2; ++cp2){
                        #pragma HLS unroll
                        cos_sin[0][tt*TP + tp][hct*CP2 + cp2] = cos_sin_vec[0*TP*CP2 + tp*CP2 + cp2];
                        cos_sin[1][tt*TP + tp][hct*CP2 + cp2] = cos_sin_vec[1*TP*CP2 + tp*CP2 + cp2];
                    }
                }
                // finished pipeline
            }
        }

        // write all cos and sin, H times
        for(int h=0; h<H; ++h){
            for(int tt=0; tt<TT; ++tt){
                for(int hct=0; hct<HCT; ++hct){
                    #pragma HLS pipeline II=1
                    // allocate output
                    hls::vector<COS_SIN_T, 2*TP*CP2> o_vec;
                    // read from buffer
                    for(int tp=0; tp<TP; ++tp){
                        for(int cp2=0; cp2<CP2; ++cp2){
                            #pragma HLS unroll
                            o_vec[0*TP*CP2 + tp*CP2 + cp2] = cos_sin[0][tt*TP + tp][hct*CP2 + cp2];
                            o_vec[1*TP*CP2 + tp*CP2 + cp2] = cos_sin[1][tt*TP + tp][hct*CP2 + cp2];
                        }
                    }
                    // write to stream
                    cache_stream.write(o_vec);
                    // finished pipeline
                }
            }
        }
    }


    void stage2_apply_rotation(
        hls::stream<hls::vector<QKV_TRUNC_T,      TP*CP     > > &qk_stream,
        hls::stream<hls::vector<COS_SIN_T,      2*TP*CP2    > > &cache_stream,
        hls::stream<hls::vector<ROT_T,            TP*CP     > > &rot_stream
    ){

        // read in sin and cos, and apply rotation on them
        for(int h=0; h<H; ++h){
            for(int tt=0; tt<TT; ++tt){
                for(int hct=0; hct<HCT; ++hct){
                    #pragma HLS pipeline II=1
                    // read in data
                    hls::vector<QKV_TRUNC_T,      TP*CP > qk_vec      = qk_stream   .read();
                    hls::vector<COS_SIN_T,      2*TP*CP2> cos_sin_vec = cache_stream.read();
                    hls::vector<ROT_T,            TP*CP > rot_vec;
                    // apply rotation
                    for(int tp=0; tp<TP; ++tp){
                        for(int cp2=0; cp2<CP2; ++cp2){
                            #pragma HLS unroll
                            COS_SIN_T cur_cos = cos_sin_vec[0*TP*CP2 + tp*CP2 + cp2];
                            COS_SIN_T cur_sin = cos_sin_vec[1*TP*CP2 + tp*CP2 + cp2];
                            int idx = tp*CP + cp2*2;
                            rot_vec[idx + 0] = (qk_vec[idx + 0] * cur_cos - qk_vec[idx + 1] * cur_sin) >> MHA_TRUNC_ROT;
                            rot_vec[idx + 1] = (qk_vec[idx + 1] * cur_cos + qk_vec[idx + 0] * cur_sin) >> MHA_TRUNC_ROT;
                        }
                    }
                    rot_stream.write(rot_vec);
                    // finished pipeline
                }
            }
        }
    }

    void do_rope(
        hls::stream<hls::vector<QKV_TRUNC_T,   TP*CP > > &qk_stream,
        hls::stream<hls::vector<COS_SIN_T,   2*TP*CP2> > &cos_sin_stream,
        hls::stream<hls::vector<ROT_T,         TP*CP > > &rot_stream
    ){
        #pragma HLS dataflow

        hls::stream<hls::vector<COS_SIN_T, 2*TP*CP2> > cache_stream ("cache_stream");

        stage1_cache_cos_sin    (cos_sin_stream,    cache_stream            );
        stage2_apply_rotation   (qk_stream,         cache_stream, rot_stream);
    }

};

#endif