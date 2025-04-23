#include "src/common.h"
#include "src/qk_gemm.h"
#include "src/utils.h"

// 设计的consideration：
// 1. 输入stream的复用：由于q和k都经过了rope编码，因此共享输入接口
// 2. 在生命周期分析中，Q和K必须进行乒乓，因此stage1使用显式PIPO

// simulation hyperparameters
constexpr int L         = SIM_L;
constexpr int T_LOAD    = 128;          // saved seq length, since T is in the inner loop
constexpr int S_LOAD    = T_LOAD;       // saved seq length, since T is in the inner loop
constexpr int POS       = 96;           // a random position

// model hyperparameters
constexpr int H         = LLAMA_H;
constexpr int G         = LLAMA_GW;
constexpr int HC        = LLAMA_HC;

// design hyperparameters
constexpr int T         = 8;            
constexpr int S         = 192;          // reduced context length
constexpr int TP        = 1;                                                 
constexpr int CP        = G;            // forced alignment, therefore the s can be bypassed!
constexpr int SP        = G;            // SP is for output channel parallelism

// derived hyperparameters
constexpr int TT        = T / TP;
constexpr int ST        = S / SP;
constexpr int HCT       = HC / CP;

// dtypes
typedef ap_int  <DW_AQ      > aq_t;
typedef ap_uint <DW_AS  > as_t;
typedef ap_int  <DW_R       > acc_t;    // largest accumulated value
typedef ap_int  <DW_R_TRUNC > of_t;  

// other hyperparameters
constexpr int NUM_QK    = 2*H*T*HC;
constexpr int NUM_QK_S  = 2*H*T*HCT;
constexpr int NUM_R     =   H*T*S;
constexpr int TRUNC     = MHA_TRUNC_R;


// instanciate the gemm inst
QK_GEMM <aq_t, as_t, acc_t, of_t, TRUNC, H, T, TP, S, SP, HC, CP>  qk_gemm_inst;


void top(
    // scalar inputs
    int l_begin,
    int l_close,
    int pos_id,
    // streams
    hls::stream<hls::vector<aq_t,    CP > >& qk_q_stream,
    hls::stream<hls::vector<as_t,     1 > >& qk_s_stream,
    hls::stream<hls::vector<aq_t, TP*CP > >& kq_cache_i_stream,
    hls::stream<hls::vector<as_t, TP    > >& ks_cache_i_stream,
    hls::stream<hls::vector<aq_t,    CP > >& kq_cache_o_stream,
    hls::stream<hls::vector<as_t,     1 > >& ks_cache_o_stream,
    hls::stream<hls::vector<of_t, TP*SP > >& r_stream
){
    #pragma HLS interface ap_ctrl_chain port=return

    // set interface
    #pragma HLS interface axis port=qk_q_stream
    #pragma HLS interface axis port=qk_s_stream
    #pragma HLS interface axis port=kq_cache_i_stream
    #pragma HLS interface axis port=ks_cache_i_stream
    #pragma HLS interface axis port=kq_cache_o_stream
    #pragma HLS interface axis port=ks_cache_o_stream
    #pragma HLS interface axis port=r_stream

    // set aggregate pragma
    #pragma HLS aggregate variable=qk_q_stream          compact=bit
    #pragma HLS aggregate variable=qk_s_stream          compact=bit
    #pragma HLS aggregate variable=kq_cache_i_stream    compact=bit
    #pragma HLS aggregate variable=ks_cache_i_stream    compact=bit
    #pragma HLS aggregate variable=kq_cache_o_stream    compact=bit
    #pragma HLS aggregate variable=ks_cache_o_stream    compact=bit
    #pragma HLS aggregate variable=r_stream             compact=bit

    for(int l=l_begin; l<l_close && l<LLAMA_L; ++l){
        qk_gemm_inst.do_qk_gemm(
            pos_id, 
            qk_q_stream, 
            qk_s_stream, 
            kq_cache_i_stream, 
            ks_cache_i_stream, 
            kq_cache_o_stream, 
            ks_cache_o_stream, 
            r_stream
        );
    }
}


// declare reference data
int8_t  REF_Q_Q             [H*T*HC ];
int8_t  REF_Q_S             [H*T*HCT];
int8_t  REF_K_Q             [H*S*HC ];
int8_t  REF_K_S             [H*S*HCT];
// declare K cache
int8_t  REF_K_Q_CACHE       [H*S*HC ];
int8_t  REF_K_S_CACHE       [H*S*HCT];
// declare head interleaved data
int8_t  REF_QK_Q            [2*H*T*HC ];
int8_t  REF_QK_S            [2*H*T*HCT];
// declare reference data
int64_t REF_R               [H*T*S ];
// declare dut data
int8_t  DUT_K_Q             [H*T*HC ];
int8_t  DUT_K_S             [H*T*HCT];
int64_t DUT_R               [H*T*S  ];
// declare condensed input
int8_t  REF_CONDENSED_ROT_Q     [NUM_QK  ];
int8_t  REF_CONDENSED_ROT_S     [NUM_QK_S];

void test_layer(int l){
    // read input data and reference data
    string file_path = BINARIES_PATH + to_string(l);
    string save_path = CONDENSE_PATH + to_string(l);
    {
        // read input refs
        auto Q_Q = read_tensor<int8_t >(file_path + "/MHA_Q_Q.bin");
        auto Q_S = read_tensor<int8_t >(file_path + "/MHA_Q_S.bin");
        auto K_Q = read_tensor<int8_t >(file_path + "/MHA_K_Q.bin");
        auto K_S = read_tensor<int8_t >(file_path + "/MHA_K_S.bin");
        auto R   = read_tensor<int64_t>(file_path + "/MHA_R.bin");
        //          <dtype >    TENSOR,     ARRAY,          H_LOAD, H,      T_LOAD,     T_START,    T,          C_LOAD,     HC
        tensor2array<int8_t>(   Q_Q,        REF_Q_Q,        H,      H,      T_LOAD,     POS,        T,          HC,         HC  );
        tensor2array<int8_t>(   Q_S,        REF_Q_S,        H,      H,      T_LOAD,     POS,        T,          HCT,        HCT );
        tensor2array<int8_t>(   K_Q,        REF_K_Q,        H,      H,      T_LOAD,     POS,        T,          HC,         HC  );
        tensor2array<int8_t>(   K_S,        REF_K_S,        H,      H,      T_LOAD,     POS,        T,          HCT,        HCT );
        // load as much cache as possible
        tensor2array<int8_t>(   K_Q,        REF_K_Q_CACHE,  H,      H,      S_LOAD,     0,          S,          HC,         HC  );
        tensor2array<int8_t>(   K_S,        REF_K_S_CACHE,  H,      H,      S_LOAD,     0,          S,          HCT,        HCT );
        // load result
        tensor2array<int64_t>(  R,          REF_R,          H,      H,      T_LOAD,     POS,        T,          S_LOAD,     S   );

        //* legacy code to make head interleaved
        // for(int h=0; h<H; ++h){
        //     for(int qk=0; qk<2; ++qk){
        //         for(int t=0; t<T; ++t){
        //             for(int c=0; c<HC; ++c){
        //                 int GLOBAL_INDEX = h*2*T*HC + qk*T*HC + t*HC + c;
        //                 int LOCAL_INDEX  = h  *T*HC +           t*HC + c;
        //                 REF_QK_Q[GLOBAL_INDEX] = (qk == 0? REF_Q_Q : REF_K_Q)[LOCAL_INDEX];
        //             }
        //             for(int ct=0; ct<HCT; ++ct){
        //                 int GLOBAL_INDEX = h*2*T*HCT + qk*T*HCT + t*HCT + ct;
        //                 int LOCAL_INDEX  = h  *T*HCT +            t*HCT + ct;
        //                 REF_QK_S[GLOBAL_INDEX] = (qk == 0? REF_Q_S : REF_K_S)[LOCAL_INDEX];
        //             }
        //         }
        //     }
        // }

        // overwrite K cache after POS, because there's causation
        for(int h=0; h<H; ++h){
            for(int s=POS; s<S; ++s){
                for(int c=0; c<HC; ++c){
                    REF_K_Q_CACHE[h*S*HC  + s*HC  + c ] = 0;
                }
                for(int ct=0; ct<HCT; ++ct){
                    REF_K_S_CACHE[h*S*HCT + s*HCT + ct] = 0;
                }
            }
        }


    } // end of scope, release the memory


    //* create streams
    hls::stream<hls::vector<aq_t,        CP > > qk_q_stream         ( "qk_q_stream"         );
    hls::stream<hls::vector<as_t,        1  > > qk_s_stream         ( "qk_s_stream"         );
    hls::stream<hls::vector<aq_t,        CP > > kq_cache_i_stream   ( "kq_cache_i_stream"   );
    hls::stream<hls::vector<as_t,        1  > > ks_cache_i_stream   ( "ks_cache_i_stream"   );
    hls::stream<hls::vector<aq_t,        CP > > kq_cache_o_stream   ( "kq_cache_o_stream"   );
    hls::stream<hls::vector<as_t,        1  > > ks_cache_o_stream   ( "ks_cache_o_stream"   );
    hls::stream<hls::vector<of_t,   TP * SP > > r_stream            ( "r_stream"            );

    //* use condensed input
    auto CONDENSED_ROT_Q = read_tensor<int8_t>(save_path + "/CONDENSED_ROPE_QK_QUANT_ROT_Q.bin");
    auto CONDENSED_ROT_S = read_tensor<int8_t>(save_path + "/CONDENSED_ROPE_QK_QUANT_ROT_S.bin");
    tensor2array<int8_t>(CONDENSED_ROT_Q, REF_CONDENSED_ROT_Q, 1, 1, 1, 1, NUM_QK,   NUM_QK  );
    tensor2array<int8_t>(CONDENSED_ROT_S, REF_CONDENSED_ROT_S, 1, 1, 1, 1, NUM_QK_S, NUM_QK_S);

    //* put data into stream
    array2stream<int8_t, aq_t, 1, 1, 1, 1, NUM_QK,  CP>(REF_CONDENSED_ROT_Q, qk_q_stream, "QK_Q", true);
    array2stream<int8_t, as_t, 1, 1, 1, 1, NUM_QK_S, 1>(REF_CONDENSED_ROT_S, qk_s_stream, "QK_S", true);
    
    //* put cache into stream
    array2stream<int8_t, aq_t, 1, H, S, 1, HC, CP>(REF_K_Q_CACHE, kq_cache_i_stream, "KQ_CACHE", true);
    array2stream<int8_t, as_t, 1, H, S, 1, HCT, 1>(REF_K_S_CACHE, ks_cache_i_stream, "KS_CACHE", true);

    //* save condensed k cache
    save_condensed_tensor<int8_t, aq_t, H*S*HC,  CP>(save_path + "/CONDENSED_KQ_CACHE.bin", kq_cache_i_stream);
    save_condensed_tensor<int8_t, as_t, H*S*HCT,  1>(save_path + "/CONDENSED_KS_CACHE.bin", ks_cache_i_stream);

    //* call top function
    top(l, l+1, POS, qk_q_stream, qk_s_stream, kq_cache_i_stream, ks_cache_i_stream, kq_cache_o_stream, ks_cache_o_stream, r_stream);

    //* save condensed output
    save_condensed_tensor<int64_t, of_t, NUM_R, TP*SP>(save_path + "/CONDENSED_QK_GEMM_R.bin", r_stream);

    //* read output stream
    stream2array        <   int64_t,    of_t,               H,      T,      TP,         S,     SP >(r_stream,           DUT_R,      "Output R",     true);
    stream2array        <   int8_t,     aq_t,               H,      T,       1,        HC,     CP >(kq_cache_o_stream,  DUT_K_Q,    "Output KQ",    true);
    stream2array        <   int8_t,     as_t,               H,      T,       1,       HCT,      1 >(ks_cache_o_stream,  DUT_K_S,    "Output KS",    true);

    //* check stream size
    assert(qk_q_stream.size() == 0);
    assert(qk_s_stream.size() == 0);
    assert(r_stream   .size() == 0);


    //* compare the results
    // compare<int64_t>(REF_R, DUT_R, H*T*S, "R");
    for(int h=0; h<H; ++h){
        for(int t=0; t<T && t<T_LOAD; ++t){
            for(int s=0; s<S && s<S_LOAD && s<T+POS; ++s){
            // for(int s=0; s<S && s<S_LOAD; ++s){
                int REF_IDX = h*T*S + t*S + s;
                int DUT_IDX = h*T*S + t*S + s;
                if(REF_R[REF_IDX] != DUT_R[DUT_IDX]){
                    printf("Mismatch at layer %d, head %d, seq %d, pos %d, REF %ld, DUT %ld\n", l, h, t, s, REF_R[REF_IDX], DUT_R[DUT_IDX]);
                } else {
                    // printf("Match at layer %d, head %d, seq %d, pos %d, REF %ld, DUT %ld\n", l, h, t, s, REF_R[REF_IDX], DUT_R[DUT_IDX]);
                }
            }
        }
    }

    // compare the output cache
    compare<int8_t>(REF_K_Q, DUT_K_Q, H*T*HC,  "KQ Cache");
    compare<int8_t>(REF_K_S, DUT_K_S, H*T*HCT, "KS Cache");
}

int main(){
    for(int l=0; l<L; ++l){
        test_layer(l);
        printf("Layer %d passed\n", l);
    }

    // test_layer(0);

    return 0;
}
