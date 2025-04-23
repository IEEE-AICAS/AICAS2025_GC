#ifndef __INT_BMM_H__
#define __INT_BMM_H__

#include "src/common.h"
#include "src/utils.h"

template<
    class a_t,
    class as_t,
    class w_t,
    class ws_t,
    class acc_t, 
    class of_t,

    int TRUNC,

    int H,        
    int T,
    int TP,
    int HC,
    int CIP,
    int CO,
    int COP
>
class BMM{
public:
    BMM(){}

    static constexpr int TT     = T  / TP;
    static constexpr int CIT    = HC / CIP;
    static constexpr int COT    = CO / COP;

    // checks
    static_assert(T  % TP  == 0, "T  % TP  != 0");
    static_assert(HC % CIP == 0, "HC % CIP != 0");
    static_assert(CO % COP == 0, "CO % COP != 0");

    void do_bmm(
        hls::stream<hls::vector<a_t,    TP *CIP> >& a_stream,
        hls::stream<hls::vector<as_t,   TP     > >& as_stream,
        hls::stream<hls::vector<w_t,    COP*CIP> >& w_stream,
        hls::stream<hls::vector<ws_t,   COP    > >& ws_stream,
        hls::stream<hls::vector<of_t,   TP *COP> >& o_stream
    ) {
        // allocate psum
        hls::vector<acc_t,   TP*COP> psum_vec(0);

        for(int h=0; h<H; ++h){
            for(int tt=0; tt<TT; ++tt){
                for(int cot=0; cot<COT; ++cot){
                    for(int cit=0; cit<CIT; ++cit){
                        #pragma HLS pipeline II=1

                        if(cit == 0){
                            // set output to zero
                            for(int tp=0; tp<TP; ++tp){
                                for(int cop=0; cop<COP; ++cop){
                                    #pragma HLS unroll
                                    psum_vec[tp*COP + cop] = 0;
                                }
                            }
                        }

                        hls::vector<a_t,    TP*CIP > a_vec  = a_stream. read();
                        hls::vector<as_t,   TP     > as_vec = as_stream.read();
                        hls::vector<w_t,    COP*CIP> w_vec  = w_stream. read();
                        hls::vector<ws_t,   COP    > ws_vec = ws_stream.read();

                        hls::vector<acc_t,  TP *COP> tile_psum_vec(0);

                        // do tile matmul
                        for(int tp=0; tp<TP; ++tp){
                            for(int cop=0; cop<COP; ++cop){
                                for(int cip=0; cip<CIP; ++cip){
                                    #pragma HLS unroll
                                    // auto mul_res = a_vec[tp*CIP + cip] * w_vec[cop*CIP + cip];
                                    // #pragma HLS bind_op variable=mul_res op=mul impl=dsp
                                    // tile_psum_vec[tp*COP + cop] += mul_res;
                                    tile_psum_vec[tp*COP + cop] += a_vec[tp*CIP + cip] * w_vec[cop*CIP + cip];
                                    #pragma HLS bind_op variable=tile_psum_vec op=mul impl=dsp
                                }
                            }
                        }

                        // apply shift and accumulate
                        for(int tp=0; tp<TP; ++tp){
                            for(int cop=0; cop<COP; ++cop){
                                #pragma HLS unroll
                                psum_vec[tp*COP + cop] += tile_psum_vec[tp*COP + cop] << (as_vec[tp] + ws_vec[cop]);
                            }
                        }

                        if(cit == CIT-1){
                            // apply truncation
                            hls::vector<of_t,   TP*COP> o_vec;
                            for(int tp=0; tp<TP; ++tp){
                                for(int cop=0; cop<COP; ++cop){
                                    #pragma HLS unroll
                                    o_vec[tp*COP + cop] = psum_vec[tp*COP + cop] >> TRUNC;
                                }
                            }
                            o_stream.write(o_vec);
                        }

                    } // end of CIT loop
                } // end of COT loop
            } // end of TT loop
        } // end of H loop
    } // end of function

};

#endif