#ifndef __INT_SILU_H__
#define __INT_SILU_H__

#include "src/common.h"
#include "src/utils.h"
#include "src/adapter.h"

// LLM constants
constexpr int SILU_HYPERPARAMS   [] = {
    #include "src/ref/MLP_SILU_HYPERPARAMS.txt"
};

// SILU
constexpr int SILU_LOG2DENOM        = SILU_HYPERPARAMS[0];
constexpr int SILU_ENTRIES          = SILU_HYPERPARAMS[1];
constexpr int SILU_O_BACK           = SILU_HYPERPARAMS[2];

// arrays
constexpr int SILU_TABLE          [] = {
    #include "ref/MLP_SILU_TABLE.txt"
};

template<
    class if_t,
    class silu_t,
    int T,
    int TP,
    int CM,
    int CMP,
    int CMAP
>
class SILU{
public:

    static constexpr int TT     = T     / TP;
    static constexpr int CMT    = CM    / CMP;

    SILU(){}

    void do_silu_parallel(hls::stream<hls::vector<if_t, TP * CMP> > &i_stream, hls::stream<hls::vector<silu_t, TP * CMP> > &o_stream){
        // This function loop includes layers
        for(int tt=0; tt<TT; ++tt){
            for(int cmt=0; cmt<CMT; ++cmt){
                #pragma HLS pipeline II=1

                hls::vector<if_t, TP * CMP>    xug_vec = i_stream.read();
                hls::vector<silu_t, TP * CMP>   silu_vec;
                
                for(int tp=0; tp<TP; ++tp){
                    for(int cmp=0; cmp<CMP; ++cmp){
                        #pragma HLS unroll
                        // index
                        int idx = tp * CMP + cmp;
                        int LUT_IDX = abs(xug_vec[idx]) >> SILU_LOG2DENOM;
                        LUT_IDX = clamp(LUT_IDX, 0, SILU_ENTRIES - 1);
                        auto DIFF = SILU_TABLE[LUT_IDX];
                        auto RELU = max(xug_vec[idx], (if_t)0);
                        silu_vec[idx] = RELU - (DIFF << SILU_O_BACK);
                    }
                }

                o_stream.write(silu_vec);

            } // end of cmt loop
        } // end of tt loop
    } // end of do_silu

    void do_silu(hls::stream<hls::vector<if_t, TP * CMAP> > &i_stream, hls::stream<hls::vector<silu_t, TP * CMAP> > &o_stream){
        Adapter<if_t,  T, TP, CM, CMAP, CMP > adapter_i;
        Adapter<silu_t, T, TP, CM, CMP, CMAP> adapter_o;

        hls::stream<hls::vector<if_t,   TP * CMP> > adpt_stream("adpt_stream");
        hls::stream<hls::vector<silu_t, TP * CMP> > silu_stream("silu_stream");

        #pragma HLS dataflow
        adapter_i.do_adapt  (i_stream, adpt_stream   );
        do_silu_parallel    (adpt_stream, silu_stream);
        adapter_o.do_adapt  (silu_stream, o_stream   );
    }

};

#endif