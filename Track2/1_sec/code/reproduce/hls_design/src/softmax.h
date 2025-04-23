#ifndef __INT_SOFTMAX_H__
#define __INT_SOFTMAX_H__

#include "src/common.h"
#include "src/utils.h"
#include "src/adapter.h"

// LLM constants
constexpr int SOFTMAX_HYPERPARAMS   [] = {
    #include "src/ref/MHA_SOFTMAX_HYPERPARAMS.txt"
};

// SOFTMAX_RSQRT
constexpr int EXP_LOG2DENOM     = SOFTMAX_HYPERPARAMS[0];
constexpr int EXP_ENTRIES       = SOFTMAX_HYPERPARAMS[1];
constexpr int RECIP_NUM_TABLES  = SOFTMAX_HYPERPARAMS[2];
constexpr int RECIP_ENTRIES     = SOFTMAX_HYPERPARAMS[3];
constexpr int SOFTMAX_TRUNC_MUL = SOFTMAX_HYPERPARAMS[4];
// arrays
constexpr int EXP_TABLE            [] = {
    #include "src/ref/MHA_SOFTMAX_EXP_TABLE.txt"
};
constexpr int RECIP_TABLES         [] = {
    #include "src/ref/MHA_SOFTMAX_RECIP_TABLES.txt"
};
constexpr int RECIP_ALPHAS         [] = {
    #include "src/ref/MHA_SOFTMAX_RECIP_ALPHAS.txt"
};
constexpr int RECIP_LOG2DENOMS     [] = {
    #include "src/ref/MHA_SOFTMAX_RECIP_LOG2DENOMS.txt"
};
constexpr int RECIP_OFFSETS_DIFF   [] = {
    #include "src/ref/MHA_SOFTMAX_RECIP_OFFSETS_DIFF.txt"
};


template<
    class r_t,
    class r_masked_t,
    class exp_t,
    class exp_sum_t,
    class recip_t,
    class softmax_t,

    int H,
    int T,
    int TP,
    int S,
    int SAP,
    int SP
>
class SOFTMAX{
public:
    // check divisibility
    static_assert(T % TP == 0, "T must be divisible by TP");
    static_assert(S % SP == 0, "S must be divisible by SP");

    static constexpr int TT = T / TP;
    static constexpr int ST = S / SP;

    // some internal buffers
    r_masked_t  R_BUF       [TP][S];
    exp_t       R_EXP       [TP][S];
    r_masked_t  R_MAXVAL    [TP];
    exp_sum_t   R_EXP_SUM   [TP];
    recip_t     R_RECIP     [TP];

    SOFTMAX(){}

    void do_softmax_func(int pos, hls::stream<hls::vector<r_t, TP * SP> > &i_stream, hls::stream<hls::vector<softmax_t, TP * SP> > &o_stream){
        // shaping
        #pragma HLS array_reshape   variable=R_BUF        complete                dim=1
        #pragma HLS array_reshape   variable=R_BUF        cyclic      factor=SP   dim=2
        #pragma HLS array_reshape   variable=R_EXP        complete                dim=1
        #pragma HLS array_reshape   variable=R_EXP        cyclic      factor=SP   dim=2
        #pragma HLS array_reshape   variable=R_MAXVAL     complete                dim=1
        #pragma HLS array_reshape   variable=R_EXP_SUM    complete                dim=1
        #pragma HLS array_reshape   variable=R_RECIP      complete                dim=1
        // bind storage

        // don't merge the loops, each status has its own pipeline
        LOOP_H: for(int h=0; h<H; ++h){
            LOOP_TT: for(int tt=0; tt<TT; ++tt){

                // pass 1: read input stream, as well as get R_MAXVAL
                for(int st=0; st<ST; ++st){
                    #pragma HLS pipeline II=1

                    hls::vector<r_t,        TP*SP> i_vec        = i_stream.read();
                    hls::vector<r_masked_t, TP*SP> masked_vec;

                    // apply causal mask
                    for(int tp=0; tp<TP; ++tp){
                        for(int sp=0; sp<SP; ++sp){
                            #pragma HLS unroll
                            int t = tt*TP + tp;
                            int s = st*SP + sp;
                            masked_vec[tp*SP + sp] = (pos+t >= s) ? r_masked_t(i_vec[tp*SP + sp]) : r_masked_t(MASK_NEG_INF + i_vec[tp*SP + sp]);
                        }
                    }

                    if(st == 0){
                        // reset R_MAXVAL to possible minimum
                        for(int tp=0; tp<TP; ++tp){
                            #pragma HLS unroll
                            R_MAXVAL [tp] = r_masked_t(MASK_NEG_INF);
                            R_EXP_SUM[tp] = 0;
                        }
                    }

                    for(int tp=0; tp<TP; ++tp){
                        for(int sp=0; sp<SP; ++sp){
                            #pragma HLS unroll
                            // buffer, and record R_MAXVAL
                            R_BUF   [tp][st*SP + sp] = masked_vec[tp*SP + sp];
                            R_MAXVAL[tp]             = max(R_MAXVAL[tp], masked_vec[tp*SP + sp]);
                        }
                    }
                }

                // pass 2: calculate R_EXP and R_EXP_SUM
                for(int st=0; st<ST; ++st){
                    #pragma HLS pipeline II=1

                    for(int tp=0; tp<TP; ++tp){
                        for(int sp=0; sp<SP; ++sp){
                            #pragma HLS unroll
                            // calculate R_EXP
                            int     INDEX       = clamp((R_MAXVAL[tp] - R_BUF[tp][st*SP + sp]) >> EXP_LOG2DENOM, 0, EXP_ENTRIES - 1);
                            exp_t   EXP_VAL     = EXP_TABLE[INDEX];
                            // overwrite R_BUF and accumulate R_EXP_SUM
                            R_EXP       [tp][st*SP + sp] = EXP_VAL;
                            R_EXP_SUM   [tp]             = R_EXP_SUM[tp] + EXP_VAL;
                        }
                    }
                }

                // pass 2 post: calculate R_RECIP
                for(int tp=0; tp<TP; ++tp){
                    #pragma HLS pipeline off

                    int LUT_IDX = 0;
                    for(int i=0; i<RECIP_NUM_TABLES; ++i){
                        #pragma HLS unroll
                        if(R_EXP_SUM[tp] >= RECIP_ALPHAS[i]){
                            LUT_IDX = i;
                        }
                    }
                    auto ALPHA          = RECIP_ALPHAS      [LUT_IDX];
                    auto LOG2DENOM      = RECIP_LOG2DENOMS  [LUT_IDX];
                    auto OFFSET_DIFF    = RECIP_OFFSETS_DIFF[LUT_IDX];
                    auto INDEX          = clamp((R_EXP_SUM[tp] - ALPHA) >> LOG2DENOM, 0, RECIP_ENTRIES - 1);

                    R_RECIP[tp] = RECIP_TABLES[LUT_IDX * RECIP_ENTRIES + INDEX] << OFFSET_DIFF;
                }

                // pass 3: calculate R_SOFTMAX
                for(int st=0; st<ST; ++st){
                    #pragma HLS pipeline II=1
                    hls::vector<softmax_t, TP * SP> o_vec;
                    for(int tp=0; tp<TP; ++tp){
                        for(int sp=0; sp<SP; ++sp){
                            #pragma HLS unroll
                            o_vec[tp*SP + sp] = (R_EXP[tp][st*SP + sp] * R_RECIP[tp]) >> SOFTMAX_TRUNC_MUL;
                        }
                    }
                    // write to output stream
                    o_stream.write(o_vec);
                }
            }
        }
    }

    void do_softmax(
        int pos,
        hls::stream<hls::vector<r_t,        TP*SAP> > &i_stream,
        hls::stream<hls::vector<softmax_t,  TP*SAP> > &o_stream
    ){
        // adapters
        Adapter<r_t,        H*T, TP, S, SAP, SP > adapter_i;
        Adapter<softmax_t,  H*T, TP, S, SP,  SAP> adapter_o;

        // internal streams
        hls::stream<hls::vector<r_t,        TP*SP> > i_stream_adapted;
        hls::stream<hls::vector<softmax_t,  TP*SP> > softmax_stream;

        #pragma HLS dataflow
        adapter_i.do_adapt      (       i_stream,              i_stream_adapted);
        do_softmax_func         (pos,   i_stream_adapted,      softmax_stream  );
        adapter_o.do_adapt      (       softmax_stream,        o_stream        );
    }

};

#endif