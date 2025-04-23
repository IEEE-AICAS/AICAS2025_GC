#ifndef __INT_MAIN_TENSOR_CORE_H__
#define __INT_MAIN_TENSOR_CORE_H__

#include "src/common.h"
#include "src/utils.h"

// 该模块被设计用来“永远处理小块矩阵乘法”
// 累积的任务被甩锅给了累加器

template<
    class if_t,
    class w_t,
    class of_t,

    int TP,
    int CIP,
    int COP,
    int T_DECODER,
    int T_CLS
>
class TENSOR_CORE{
public:

    TENSOR_CORE() {}

    void do_tensor_core(
        // scalar input
        bool run_cls,
        // streams
        hls::stream<hls::vector<if_t, TP *CIP> >& i_stream, 
        hls::stream<hls::vector<w_t,  COP*CIP> >& w_stream,
        hls::stream<hls::vector<of_t, TP *COP> >& o_stream
    ) {
        int N = run_cls ? T_CLS : T_DECODER;

        #ifndef __SYNTHESIS__
        ProgressBar pb("TENSOR_CORE", N / 1000 + 1);
        // pb.start();
        #endif

        for(int n=0; n<N; ++n) {
            #pragma HLS pipeline II=1

            #ifndef __SYNTHESIS__
            if(n % 1000 == 0) pb.update(1);
            #endif

            hls::vector<if_t, TP *CIP> i_vec = i_stream.read();
            hls::vector<w_t,  COP*CIP> w_vec = w_stream.read();
            hls::vector<of_t, TP *COP> o_vec;

            // initialize the output vector
            for(int tp=0; tp<TP; ++tp) {
                for(int cop=0; cop<COP; ++cop) {
                    #pragma HLS unroll
                    o_vec[tp*COP + cop] = 0;
                }
            }

            // completely unrolled matmul
            for(int tp=0; tp<TP; ++tp) {
                for(int cop=0; cop<COP; ++cop) {
                    for(int cip=0; cip<CIP; ++cip) {
                        #pragma HLS unroll
                        auto mul_res = i_vec[tp*CIP + cip] * w_vec[cop*CIP + cip];
                        #pragma HLS bind_op variable=mul_res op=mul impl=dsp
                        o_vec[tp*COP + cop] += mul_res;
                    }
                }
            }

            // write the output vector
            o_stream.write(o_vec);
        }
    }

};

#endif