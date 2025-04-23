#ifndef __INT_ROPE_QK_H__
#define __INT_ROPE_QK_H__

// 设计的Consideration：
// 1. QK的交织输入，复用同样的输入和输出，并且无需关心循环嵌套顺序
// 2. 数据类型非常特殊，因此不做template

#include "src/common.h"
#include "src/utils.h"

template<
    int H,
    int T,
    int GEMM_TP,        // the tp is only used to direct the unpack behavior
    int C,
    int CP
>
class ROPE_QK{
public:
    static constexpr int HC      = C  / H;
    static constexpr int GEMM_TT = T  / GEMM_TP;
    static constexpr int HCT     = HC / CP;
    static constexpr int CP2     = CP / 2;
    static constexpr int HC2     = HC / 2;

    ROPE_QK() = default;

    // stage 1: store sin and cos, and fetch them H times
    // stage 2: apply rotation

    void stage1_cache_cos_sin(
        hls::stream<hls::vector<COS_SIN_T, 2*CP2> > &cos_sin_stream,
        hls::stream<hls::vector<COS_SIN_T, 2*CP2> > &cache_stream
    ){
        // allocate memory for cos and sin, the data is shared between all heads
        COS_SIN_T cos_sin[2][T][HC2]; 
        // [0] for cos, [1] for sin
        #pragma HLS array_reshape variable=cos_sin complete                         dim=1
        #pragma HLS array_reshape variable=cos_sin cyclic       factor=CP2          dim=3
        #pragma bind_storage variable=cos_sin type=ram_2p impl=lutram

        // read all cos and sin
        for(int t=0; t<T; ++t){
            for(int hct=0; hct<HCT; ++hct){
                #pragma HLS pipeline II=1
                // read stream
                hls::vector<COS_SIN_T, CP> cos_sin_vec = cos_sin_stream.read();        
                // the layout: [0~GEMM_TP*CP2-1] for cos, [GEMM_TP*CP2~GEMM_TP*CP-1] for sin
                for(int cp2=0; cp2<CP2; ++cp2){
                    #pragma HLS unroll
                    cos_sin[0][t][hct*CP2 + cp2] = cos_sin_vec[0*CP2 + cp2];
                    cos_sin[1][t][hct*CP2 + cp2] = cos_sin_vec[1*CP2 + cp2];
                }
                // finished pipeline
            }
        }

        // write all cos and sin, H times
        for(int h=0; h<H; ++h){
            for(int qk=0; qk<2; ++qk){
                for(int tt=0; tt<GEMM_TT; ++tt){
                    for(int hct=0; hct<HCT; ++hct){
                        for(int tp=0; tp<GEMM_TP; ++tp){ // unpack derived loop
                            #pragma HLS pipeline II=1
                            // allocate output
                            hls::vector<COS_SIN_T, 2*CP2> o_vec;
                            // read from buffer
                            for(int cp2=0; cp2<CP2; ++cp2){
                                #pragma HLS unroll
                                o_vec[0*CP2 + cp2] = cos_sin[0][tt*GEMM_TP + tp][hct*CP2 + cp2];
                                o_vec[1*CP2 + cp2] = cos_sin[1][tt*GEMM_TP + tp][hct*CP2 + cp2];
                            }
                            // write to stream
                            cache_stream.write(o_vec);
                        }
                    }
                }
            }
        }
    }


    void stage2_apply_rotation(
        hls::stream<hls::vector<QKV_TRUNC_T,      CP  > > &qk_stream,
        hls::stream<hls::vector<COS_SIN_T,      2*CP2 > > &cache_stream,
        hls::stream<hls::vector<ROT_T,            CP  > > &rot_stream
    ){
        // read in sin and cos, and apply rotation on them
        for(int h=0; h<H; ++h){
            for(int qk=0; qk<2; ++qk){
                for(int tt=0; tt<GEMM_TT; ++tt){
                    for(int hct=0; hct<HCT; ++hct){
                        for(int tp=0; tp<GEMM_TP; ++tp){ 
                            // unpack derived loop
                            #pragma HLS pipeline II=1
                            // read in data
                            hls::vector<QKV_TRUNC_T,      CP > qk_vec      = qk_stream   .read();
                            hls::vector<COS_SIN_T,      2*CP2> cos_sin_vec = cache_stream.read();
                            hls::vector<ROT_T,            CP > rot_vec;
                            // apply rotation
                            for(int cp2=0; cp2<CP2; ++cp2){
                                #pragma HLS unroll
                                COS_SIN_T cur_cos = cos_sin_vec[0*CP2 + cp2];
                                COS_SIN_T cur_sin = cos_sin_vec[1*CP2 + cp2];
                                int idx = cp2*2;
                                rot_vec[idx + 0] = (qk_vec[idx + 0] * cur_cos - qk_vec[idx + 1] * cur_sin) >> MHA_TRUNC_ROT;
                                rot_vec[idx + 1] = (qk_vec[idx + 1] * cur_cos + qk_vec[idx + 0] * cur_sin) >> MHA_TRUNC_ROT;
                            }
                            // write out data
                            rot_stream.write(rot_vec);
                            // finished pipeline
                        }
                    }
                }
            }
        }
    }


    void do_rope(
        hls::stream<hls::vector<QKV_TRUNC_T,   CP > > &qk_stream,
        hls::stream<hls::vector<COS_SIN_T,   2*CP2> > &cos_sin_stream,
        hls::stream<hls::vector<ROT_T,         CP > > &rot_stream
    ){
        #pragma HLS interface ap_ctrl_chain port=return
        #pragma HLS interface axis port=qk_stream
        #pragma HLS interface axis port=cos_sin_stream
        #pragma HLS interface axis port=rot_stream

        #pragma HLS dataflow

        hls::stream<hls::vector<COS_SIN_T, 2*CP2> > cache_stream ("cache_stream");
        // #pragma HLS stream variable=cache_stream type=fifo depth=1024

        stage1_cache_cos_sin    (cos_sin_stream,    cache_stream            );
        stage2_apply_rotation   (qk_stream,         cache_stream, rot_stream);
    }

};

#endif