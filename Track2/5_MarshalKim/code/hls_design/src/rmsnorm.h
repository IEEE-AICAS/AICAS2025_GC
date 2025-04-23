#ifndef __INT_RMSNORM_H__
#define __INT_RMSNORM_H__

#include "src/common.h"
#include "src/utils.h"

// LLM constants
constexpr int RMSNORM_HYPERPARAMS   [] = {
    #include "src/ref/RMSNORM_HYPERPARAMS.txt"
};

// RMSNORM_RSQRT
constexpr int RSQRT_BITS            = RMSNORM_HYPERPARAMS[0];
constexpr int RSQRT_ENTRIES         = RMSNORM_HYPERPARAMS[1];
constexpr int RSQRT_NUM_TABLES      = RMSNORM_HYPERPARAMS[2];
constexpr int RSQRT_TRUNC_MUL1      = RMSNORM_HYPERPARAMS[3];
constexpr int RSQRT_TRUNC_MUL2      = RMSNORM_HYPERPARAMS[4];
// arrays
constexpr int RSQRT_LOG2DENOMS      [] = { 
    #include "ref/RMSNORM_LOG2DENOMS.txt"
};
constexpr int64_t RSQRT_ALPHAS      [] = { 
    #include "ref/RMSNORM_ALPHAS.txt"
};
constexpr int RSQRT_TABLES          [] = {
    #include "ref/RMSNORM_TABLES.txt"
};
constexpr int RSQRT_OFFSETS_DIFF    [] = {
    #include "ref/RMSNORM_OFFSETS_DIFF.txt"
};
// RMSNORM weight
constexpr int RMSNORM_LNW           [] = {
    #include "ref/RMSNORM_LNW.txt"
};
// RMSNORM cls weight
constexpr int CLS_RMSNORM_LNW       [] = {
    #include "ref/CLS_RMSNORM_LNW.txt"
};

template<
    int L,
    int T,
    int TP,
    int C,
    int CP
>
class RMSNORM{
public:

    static_assert(T % TP == 0, "T % TP != 0");
    static_assert(C % CP == 0, "C % CP != 0");

    static constexpr int TT = T / TP;
    static constexpr int CT = C / CP;

    // L is number of decoders
    LNW_T       LNW         [2*L+1][C];     // each decoder contains 2 layers, and final layer is cls

    X_T         X_BUF       [TP][C];
    X_POW2SUM_T X_POW2SUM   [TP];
    X_RSQRT_T   X_RSQRT     [TP];

    template<typename init_t>
    RMSNORM(const init_t lnw_init[2*L*C], const init_t cls_lnw_init[C]){
        // init decoder LNWs
        for(int l=0; l<L; ++l){
            for(int mha_or_mlp=0; mha_or_mlp<2; ++mha_or_mlp){
                for(int c=0; c<C; ++c){
                    LNW[l*2 + mha_or_mlp][c] = lnw_init[l*2*C + mha_or_mlp*C + c];
                }
            }
        }
        // init cls LNWs
        for(int c=0; c<C; ++c){
            LNW[L*2][c] = cls_lnw_init[c];
        }
    }

    void do_rmsnorm(int l, int mha_or_mlp, hls::stream<hls::vector<X_T, TP * CP> > &i_stream, hls::stream<hls::vector<XLN_T, TP * CP> > &o_stream){
        // shaping
        #pragma HLS array_reshape variable=X_BUF        complete              dim=1
        #pragma HLS array_reshape variable=X_BUF        cyclic      factor=CP dim=2
        #pragma HLS array_reshape variable=X_POW2SUM    complete
        #pragma HLS array_reshape variable=X_RSQRT      complete
        #pragma HLS array_reshape variable=LNW          cyclic      factor=CP dim=2
        // bind storage
        #pragma HLS bind_storage variable=X_BUF         type=ram_2p impl=URAM
        #pragma HLS bind_storage variable=X_POW2SUM     type=ram_2p impl=LUTRAM
        #pragma HLS bind_storage variable=X_RSQRT       type=ram_2p impl=LUTRAM
        #pragma HLS bind_storage variable=LNW           type=ram_2p impl=URAM

        // This function loop includes layers
        LOOP_TT: for(int tt=0; tt<TT; ++tt){

            // pass1: read input stream, as well as calculate X_SUM
            LOOP_CT1: for(int ct=0; ct<CT; ++ct){ 
                #pragma HLS pipeline II=1
            
                hls::vector<X_T, TP * CP> i_vec = i_stream.read();

                if(ct == 0){
                    // reset X_POW2SUM
                    for(int tp=0; tp<TP; ++tp){
                        #pragma HLS unroll
                        X_POW2SUM[tp] = 0;
                    }
                }

                for(int tp=0; tp<TP; ++tp){
                    for(int cp=0; cp<CP; ++cp){
                        #pragma HLS unroll
                        // buffer, and accumulate X_POW2SUM
                        X_BUF[tp][ct*CP + cp]   = i_vec[tp*CP + cp];
                        X_POW2SUM[tp]           = X_POW2SUM[tp] + i_vec[tp*CP + cp] * i_vec[tp*CP + cp];
                    }
                }
            }

            // pass1 post: calculate X_RSQRT, and XLN
            LOOP_TP2: for(int tp=0; tp<TP; ++tp){
                #pragma HLS pipeline off

                int LUT_IDX = 0;
                for(int i=0; i<RSQRT_NUM_TABLES; ++i){
                    #pragma HLS unroll
                    if(X_POW2SUM[tp] >= RSQRT_ALPHAS[i]){
                        LUT_IDX = i;
                    }
                }
                auto ALPHA          = RSQRT_ALPHAS      [LUT_IDX];
                auto LOG2DENOM      = RSQRT_LOG2DENOMS  [LUT_IDX];
                auto OFFSET_DIFF    = RSQRT_OFFSETS_DIFF[LUT_IDX];
                auto INDEX          = clamp((X_POW2SUM[tp] - ALPHA) >> LOG2DENOM, 0, RSQRT_ENTRIES - 1);

                X_RSQRT[tp] = RSQRT_TABLES[LUT_IDX * RSQRT_ENTRIES + INDEX] << OFFSET_DIFF;
            }


            // pass2: calculate XLN
            LOOP_CT2: for(int ct=0; ct<CT; ++ct){
                #pragma HLS pipeline II=1
                hls::vector<XLN_T, TP * CP> o_vec;
                for(int tp=0; tp<TP; ++tp){
                    for(int cp=0; cp<CP; ++cp){
                        #pragma HLS unroll
                        // calculate X_MUL_X_RSQRT
                        auto X_MUL_X_RSQRT = (X_BUF[tp][ct * CP + cp] * X_RSQRT[tp]) >> RSQRT_TRUNC_MUL1;
                        int sub_l = l*2 + mha_or_mlp;
                        o_vec[tp * CP + cp] = (X_MUL_X_RSQRT * LNW[sub_l][ct * CP + cp]) >> RSQRT_TRUNC_MUL2;
                    }
                }
                o_stream.write(o_vec);
            } // end of ct loop
        } // end of tt loop

    }

};

#endif