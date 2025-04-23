#include "src/common.h"
#include "src/tensor_core.h"
#include "src/accumulator.h"
#include "src/utils.h"

// 设计的consideration：
// 1. 多层设计与多层仿真：模块仅输入l_begin和l_close，自行判断是否是CLS
// 2. CLS的特殊情况：DEMUX会在CLS时将输出送到cls_stream


// simulation hyperparameters
constexpr int L             = LLAMA_L;
constexpr int T_LOAD        = 128;  // saved seq length
constexpr int POS           = 96;   // a random position

// model hyperparameters
constexpr int H             = LLAMA_H;
constexpr int KVH           = LLAMA_KVH;
constexpr int G             = LLAMA_G;
constexpr int C             = LLAMA_C;
constexpr int HC            = LLAMA_HC;
constexpr int CM            = LLAMA_CM;
constexpr int VOCAB         = LLAMA_VOCAB;

// design hyperparameters
constexpr int T             = 8;
constexpr int TP            = T;
constexpr int CP            = G;
constexpr int TRUNC_BASE    = LLAMA_TRUNC_BASE;

// derived hyperparameters
constexpr int HCT           = HC / CP;
constexpr int CMT           = CM / CP;
constexpr int CT            = C  / CP;
constexpr int VOCABT        = VOCAB / CP;
constexpr int NUM_Y         = 3*T*C + T*C + 2*T*CM + T*C;
constexpr int NUM_CLS       = T*VOCAB;

// dtypes
// QKV: 26
// O:   29
// UG:  27
// D:   31

// after base truncation:
// QKV: 26-8 = 18
// O:   29-8 = 21
// UG:  27-8 = 19
// D:   31-8 = 23
// GEMM_TRUNC_T is largest accumulated value

// QK:          QKV_TRUNC_T,    16bit
// V:           QKV_TRUNC_T,    16bit
// UG:          XUG_TRUNC_T,    16bit
// OD:          XD_TRUNC_T,     23bit
// Overall:     DW_TRUNC_T,     23bit

// complicated testbench, combining the gemm and the accumulator
// Main TENSOR_CORE is responsible for 7 matrix multiplications
// QKVOUGD
// QKVO: T*C  -> T*C
// UG:   T*C  -> T*CM
// D:    T*CM -> T*C
const int T_QKVO        = (T * C    ) / (1 * CP);  
const int T_UG          = (T * CM   ) / (1 * CP);
const int T_D           = (T * C    ) / (1 * CP);
const int T_CLS         = (T * VOCAB) / (1 * CP);
const int T_DECODER = T_QKVO*4 + T_UG*2 + T_D;

// q bias
constexpr int BQ        [L][  H*HC] = {
    #include "../src/ref/MHA_BQ.txt"
};
// k raw bias
constexpr int BK_RAW    [L][KVH*HC] = {
    #include "../src/ref/MHA_BK_RAW.txt"
};
// v raw bias
constexpr int BV_RAW    [L][KVH*HC] = {
    #include "../src/ref/MHA_BV_RAW.txt"
};

void top(
    // scalar inputs
    int l_begin,
    int l_close,
    // streams
    hls::stream<hls::vector<GEMM_TRUNC_T,   CP> >& gemm_stream,
    hls::stream<hls::vector<QKV_TRUNC_T,    CP> >& qk_stream,
    hls::stream<hls::vector<QKV_TRUNC_T,    CP> >& v_stream,
    hls::stream<hls::vector<XUG_TRUNC_T,    CP> >& ug_stream,
    hls::stream<hls::vector<XD_TRUNC_T,     CP> >& od_stream,
    hls::stream<hls::vector<CLS_TRUNC_T,    CP> >& cls_stream
){
    #pragma HLS interface ap_ctrl_chain port=return
    // set interface
    #pragma HLS interface axis port=gemm_stream
    #pragma HLS interface axis port=qk_stream
    #pragma HLS interface axis port=v_stream
    #pragma HLS interface axis port=ug_stream
    #pragma HLS interface axis port=od_stream
    #pragma HLS interface axis port=cls_stream
    // set aggregate pragma
    #pragma HLS aggregate variable=gemm_stream compact=bit
    #pragma HLS aggregate variable=qk_stream   compact=bit
    #pragma HLS aggregate variable=v_stream    compact=bit
    #pragma HLS aggregate variable=ug_stream   compact=bit
    #pragma HLS aggregate variable=od_stream   compact=bit
    #pragma HLS aggregate variable=cls_stream  compact=bit

    #pragma HLS array_reshape variable=BQ       cyclic factor=CP dim=2
    #pragma HLS array_reshape variable=BK_RAW   cyclic factor=CP dim=2
    #pragma HLS array_reshape variable=BV_RAW   cyclic factor=CP dim=2

    for(int l=l_begin; l<l_close; ++l){
        bool run_cls = l == LLAMA_L;
        //* DECODER case
        if(!run_cls){
        //* handle QKV first
            for(int h=0; h<H; ++h){
                for(int qkv=0; qkv<3; ++qkv){
                    for(int hct=0; hct<HCT; ++hct){
                        for(int t=0; t<T; ++t){
                            #pragma HLS pipeline II=1
                            hls::vector<GEMM_TRUNC_T, CP> gemm_vec = gemm_stream.read();
                            hls::vector<QKV_TRUNC_T,  CP> qkv_vec;
                            // extra truncation
                            for(int cp=0; cp<CP; ++cp){
                                #pragma HLS unroll
                                auto TRUNC = (qkv == 0 || qkv == 1) ? MHA_TRUNC_QK : MHA_TRUNC_V;
                                qkv_vec[cp] = gemm_vec[cp] >> (TRUNC - TRUNC_BASE);
                            }
                            // add bias
                            for(int cp=0; cp<CP; ++cp){
                                #pragma HLS unroll
                                int kvh = h / (H/KVH);
                                auto bias = qkv == 0 ? BQ    [l][  h*HC + hct*CP + cp] :
                                            qkv == 1 ? BK_RAW[l][kvh*HC + hct*CP + cp] :
                                            qkv == 2 ? BV_RAW[l][kvh*HC + hct*CP + cp] : 0;
                                qkv_vec[cp] += bias;
                            }

                            // write to stream
                            if(qkv == 0 || qkv == 1){
                                qk_stream.write(qkv_vec);
                            } else if(qkv == 2){
                                v_stream .write(qkv_vec);
                            }
                        }
                    }
                }
            }
            //* handle left O, U, G, D
            for(int iter=3*T_QKVO; iter<T_DECODER; ++iter){
                #pragma HLS pipeline II=1
                hls::vector<GEMM_TRUNC_T, CP> gemm_vec = gemm_stream.read();
                if          (iter < 4*T_QKVO){
                    hls::vector<XD_TRUNC_T, CP> o_vec;
                    for(int cp=0; cp<CP; ++cp){
                        #pragma HLS unroll
                        o_vec[cp] = gemm_vec[cp] >> (MHA_TRUNC_O   - TRUNC_BASE);
                    }
                    od_stream.write(o_vec);
                } else if   (iter < 4*T_QKVO + 2*T_UG){
                    hls::vector<XUG_TRUNC_T, CP> ug_vec;
                    for(int cp=0; cp<CP; ++cp){
                        #pragma HLS unroll
                        ug_vec[cp] = gemm_vec[cp] >> (MLP_TRUNC_UG  - TRUNC_BASE);
                    }
                    ug_stream.write(ug_vec);
                } else {
                    hls::vector<XD_TRUNC_T, CP> d_vec;
                    for(int cp=0; cp<CP; ++cp){
                        #pragma HLS unroll
                        d_vec[cp] = gemm_vec[cp] >> (MLP_TRUNC_D   - TRUNC_BASE);
                    }
                    od_stream.write(d_vec);
                }
            }
        } else {
            //* handle CLS
            for(int iter=0; iter<T_CLS; ++iter){
                #pragma HLS pipeline II=1
                hls::vector<GEMM_TRUNC_T, CP> gemm_vec = gemm_stream.read();
                hls::vector<CLS_TRUNC_T,  CP> cls_vec;
                for(int cp=0; cp<CP; ++cp){
                    #pragma HLS unroll
                    cls_vec[cp] = gemm_vec[cp] >> (CLS_TRUNC - TRUNC_BASE);
                }
                cls_stream.write(cls_vec);
            }
        }
    }
}


// declare the ref input
int64_t REF_CONDENSED_Y [L][      NUM_Y  ];    // condensed Y
int64_t REF_CONDENSED_CLS  [      NUM_CLS];    // condensed CLS
// declare the ref output
int64_t REF_MHA_Q       [L][      T*C    ];    // Q
int64_t REF_MHA_K       [L][      T*C    ];    // K
int64_t REF_MHA_V       [L][      T*C    ];    // V
int64_t REF_MHA_O       [L][      T*C    ];    // O
int64_t REF_MLP_U       [L][      T*CM   ];    // U
int64_t REF_MLP_G       [L][      T*CM   ];    // G
int64_t REF_MLP_D       [L][      T*C    ];    // D
int64_t REF_CLS            [      T*VOCAB];    // CLS
// declare the permuted ref output
int64_t REF_PERM_QK     [L][H  *2*T*HC   ];    // QK permuted
int64_t REF_PERM_V      [L][H*    T*HC   ];    // V  permuted
int64_t REF_PERM_O      [L][H*    T*HC   ];    // O  permuted
int64_t REF_PERM_UG     [L][CMT*2*T*CP   ];    // UG permuted
int64_t REF_PERM_D      [L][      T*C    ];    // D  permuted
int64_t REF_PERM_CLS       [      T*VOCAB];    // CLS permuted
// declare the permuted dut output
int64_t DUT_PERM_QK        [H  *2*T*HC   ];    // QK permuted
int64_t DUT_PERM_V         [H*    T*HC   ];    // V  permuted
int64_t DUT_PERM_O         [H*    T*HC   ];    // O  permuted
int64_t DUT_PERM_UG        [CMT*2*T*CP   ];    // UG permuted
int64_t DUT_PERM_D         [      T*C    ];    // D  permuted
int64_t DUT_PERM_CLS       [      T*VOCAB];    // CLS permuted


void prepare_decoder_data(
    int l,
    int l_begin,
    int l_close,
    hls::stream<hls::vector<GEMM_TRUNC_T,   CP> >& gemm_stream
){
    const string binaries_path = BINARIES_PATH + to_string(l);
    const string condense_path = CONDENSE_PATH + to_string(l);
    //* read decoder condensed input
    auto CONDENSED_Y    = read_tensor<int64_t> (condense_path + "/CONDENSED_GEMM_Y.bin");
    //* read decoder results
    auto MHA_Q          = read_tensor<int64_t> (binaries_path + "/MHA_Q.bin" );
    auto MHA_K          = read_tensor<int64_t> (binaries_path + "/MHA_K.bin" );
    auto MHA_V          = read_tensor<int64_t> (binaries_path + "/MHA_V.bin" );
    auto MHA_O          = read_tensor<int64_t> (binaries_path + "/MHA_O.bin" );
    auto MLP_U          = read_tensor<int64_t> (binaries_path + "/MLP_XU.bin");
    auto MLP_G          = read_tensor<int64_t> (binaries_path + "/MLP_XG.bin");
    auto MLP_D          = read_tensor<int64_t> (binaries_path + "/MLP_XD.bin");
    //* put input into ref
    tensor2array<int64_t>(  CONDENSED_Y,    REF_CONDENSED_Y[l],    1,      1,      1,      1,      NUM_Y,  NUM_Y);
    //* put results into ref
    //           dtype,     TENSOR,         ARRAY,                 H_LOAD, H,      T_LOAD,      T_START,    T,      C_LOAD, C
    tensor2array<int64_t>(  MHA_Q,          REF_MHA_Q[l],          1,      1,      T_LOAD,      POS,        T,      C,      C    );
    tensor2array<int64_t>(  MHA_K,          REF_MHA_K[l],          1,      1,      T_LOAD,      POS,        T,      C,      C    );
    tensor2array<int64_t>(  MHA_V,          REF_MHA_V[l],          1,      1,      T_LOAD,      POS,        T,      C,      C    );
    tensor2array<int64_t>(  MHA_O,          REF_MHA_O[l],          1,      1,      T_LOAD,      POS,        T,      C,      C    );
    tensor2array<int64_t>(  MLP_U,          REF_MLP_U[l],          1,      1,      T_LOAD,      POS,        T,      CM,     CM   );
    tensor2array<int64_t>(  MLP_G,          REF_MLP_G[l],          1,      1,      T_LOAD,      POS,        T,      CM,     CM   );
    tensor2array<int64_t>(  MLP_D,          REF_MLP_D[l],          1,      1,      T_LOAD,      POS,        T,      C,      C    );
    //* PERMUTATION
    //* for QK, divide channel by in the granularity of head
    for(int h=0; h<H; ++h){
        for(int qk=0; qk<2; ++qk){
            for(int t=0; t<T; ++t){
                for(int hc=0; hc<HC; ++hc){
                    REF_PERM_QK[l][h*2*T*HC + qk*T*HC + t*HC + hc] = 
                        (qk == 0 ? 
                            REF_MHA_Q[l][t*C + h*HC + hc] : 
                            REF_MHA_K[l][t*C + h*HC + hc]
                        );
                }
            }
        }
    }
    //* for V, divide channel by in the granularity of head
    for(int h=0; h<H; ++h){
        for(int t=0; t<T; ++t){
            for(int hc=0; hc<HC; ++hc){
                REF_PERM_V[l][h*T*HC + t*HC + hc] = REF_MHA_V[l][t*C + h*HC + hc];
            }
        }
    }
    //* for O, divide channel by in the granularity of head
    for(int h=0; h<H; ++h){
        for(int t=0; t<T; ++t){
            for(int hc=0; hc<HC; ++hc){
                REF_PERM_O[l][h*T*HC + t*HC + hc] = REF_MHA_O[l][t*C + h*HC + hc];
            }
        }
    }
    //* for UG, divide channel by in the granularity of COP, and interleave
    for(int cot=0; cot<CMT; ++cot){
        for(int ug=0; ug<2; ++ug){
            for(int t=0; t<T; ++t){
                for(int cop=0; cop<CP; ++cop){
                    REF_PERM_UG[l][cot*2*T*CP + ug*T*CP + t*CP + cop] =
                        ug == 0 ? REF_MLP_U[l][t*CM + cot*CP + cop] : 
                                  REF_MLP_G[l][t*CM + cot*CP + cop];
                }
            }
        }
    }
    //* for D, normal
    for(int t=0; t<T; ++t){
        for(int c=0; c<C; ++c){
            REF_PERM_D[l][t*C + c] = REF_MLP_D[l][t*C + c];
        }
    }

    //* write decoder input data to stream
    array2stream       <int64_t,        GEMM_TRUNC_T,     1,          1,      1,      1,      NUM_Y,    CP>(REF_CONDENSED_Y[l], gemm_stream, "Input Y"  );
}


void prepare_cls_data(
    hls::stream<hls::vector<GEMM_TRUNC_T,   CP> >& gemm_stream
){
    const string binaries_path = BINARIES_PATH + to_string(LLAMA_L);
    const string condense_path = CONDENSE_PATH + to_string(LLAMA_L);
    //* read cls condensed input
    auto CONDENSED_CLS  = read_tensor<int64_t> (condense_path + "/CONDENSED_GEMM_Y.bin");
    //* read cls results
    auto CLS            = read_tensor<int64_t> (binaries_path + "/CLS.bin");
    //* put input into ref
    tensor2array<int64_t>(  CONDENSED_CLS,  REF_CONDENSED_CLS,  1,      1,      1,      1,      NUM_CLS,    NUM_CLS);
    //* put results into ref
    tensor2array<int64_t>(  CLS,            REF_CLS,            1,      1,      T_LOAD, T,      VOCAB,      VOCAB  );
    //* PERMUTATION
    //* for CLS, normal order
    for(int t=0; t<T; ++t){
        for(int vocab=0; vocab<VOCAB; ++vocab){
            REF_PERM_CLS[t*VOCAB + vocab] = REF_CLS[t*VOCAB + vocab];
        }
    }

    //* write cls input data to stream
    array2stream       <int64_t,        GEMM_TRUNC_T,     1,          1,      1,      1,      NUM_CLS,  CP>(REF_CONDENSED_CLS, gemm_stream, "Input VOCAB");
}


void compare_decoder_data(
    int l,
    int l_begin,
    int l_close,
    hls::stream<hls::vector<QKV_TRUNC_T,    CP> >& qk_stream,
    hls::stream<hls::vector<QKV_TRUNC_T,    CP> >& v_stream,
    hls::stream<hls::vector<XUG_TRUNC_T,    CP> >& ug_stream,
    hls::stream<hls::vector<XD_TRUNC_T,     CP> >& od_stream
){
    const string binaries_path = BINARIES_PATH + to_string(l);
    const string condense_path = CONDENSE_PATH + to_string(l);
    //* save condensed output
    const int NUM_QK = 2*T*C;
    const int NUM_V  =   T*C;
    const int NUM_UG = 2*T*CM;
    const int NUM_OD = 2*T*C;
    //* create simulating streams
    hls::stream<hls::vector<QKV_TRUNC_T, CP> > sim_qk_stream("sim_qk_stream");
    hls::stream<hls::vector<QKV_TRUNC_T, CP> > sim_v_stream ("sim_v_stream" );
    hls::stream<hls::vector<XUG_TRUNC_T, CP> > sim_ug_stream("sim_ug_stream");
    hls::stream<hls::vector<XD_TRUNC_T,  CP> > sim_od_stream("sim_od_stream");
    //* copy streams
    stream2stream<QKV_TRUNC_T, NUM_QK, CP>(qk_stream, sim_qk_stream);
    stream2stream<QKV_TRUNC_T, NUM_V,  CP>(v_stream,  sim_v_stream );
    stream2stream<XUG_TRUNC_T, NUM_UG, CP>(ug_stream, sim_ug_stream);
    stream2stream<XD_TRUNC_T,  NUM_OD, CP>(od_stream, sim_od_stream);
    //* save condensed tensor
    save_condensed_tensor<int64_t,  QKV_TRUNC_T, 2*T*C,  CP>(condense_path + "/CONDENSED_DEMUX_QK.bin", sim_qk_stream);
    save_condensed_tensor<int64_t,  QKV_TRUNC_T, T*C,    CP>(condense_path + "/CONDENSED_DEMUX_V.bin" , sim_v_stream );
    save_condensed_tensor<int64_t,  XUG_TRUNC_T, 2*T*CM, CP>(condense_path + "/CONDENSED_DEMUX_UG.bin", sim_ug_stream);
    save_condensed_tensor<int64_t,  XD_TRUNC_T,  2*T*C,  CP>(condense_path + "/CONDENSED_DEMUX_OD.bin", sim_od_stream); // OD is special, contains T*C + T*C elements
    //* stream out and put into perm result
    stream2array_unpack<int64_t,    QKV_TRUNC_T,   H*2,    T,     T,      HC,     CP    >(sim_qk_stream,     DUT_PERM_QK,    "Output QK", true);
    stream2array_unpack<int64_t,    QKV_TRUNC_T,   H,      T,     T,      HC,     CP    >(sim_v_stream,      DUT_PERM_V,     "Output V",  true);
    stream2array_unpack<int64_t,    XD_TRUNC_T,    H,      T,     T,      HC,     CP    >(sim_od_stream,     DUT_PERM_O,     "Output O",  true);
    stream2array_unpack<int64_t,    XUG_TRUNC_T,   CMT*2,  T,     T,      CP,     CP    >(sim_ug_stream,     DUT_PERM_UG,    "Output UG", true);
    stream2array_unpack<int64_t,    XD_TRUNC_T,    1,      T,     T,      C,      CP    >(sim_od_stream,     DUT_PERM_D,     "Output D",  true);
    //* compare
    compare<int64_t>(REF_PERM_QK[l], DUT_PERM_QK, H  *2*T*HC, "QK");
    compare<int64_t>(REF_PERM_V [l], DUT_PERM_V,  H    *T*HC, "V" );
    compare<int64_t>(REF_PERM_O [l], DUT_PERM_O,  H    *T*HC, "O" );
    compare<int64_t>(REF_PERM_UG[l], DUT_PERM_UG, CMT*2*T*CP, "UG");
    compare<int64_t>(REF_PERM_D [l], DUT_PERM_D,        T*C,  "D" );
}

void compare_cls_data(
    hls::stream<hls::vector<CLS_TRUNC_T,    CP> >& cls_stream
){
    const string binaries_path = BINARIES_PATH + to_string(LLAMA_L);
    const string condense_path = CONDENSE_PATH + to_string(LLAMA_L);
    //* save condensed output
    const int NUM_Y  = T*VOCAB;
    hls::stream<hls::vector<CLS_TRUNC_T, CP> > sim_cls_stream("sim_cls_stream");
    stream2stream        <         CLS_TRUNC_T, NUM_Y, CP>(cls_stream, sim_cls_stream);
    save_condensed_tensor<int64_t, CLS_TRUNC_T, NUM_Y, CP>(condense_path + "/CONDENSED_DEMUX_OD.bin", sim_cls_stream);
    //* interleaved read out
    stream2array_unpack<int64_t,    CLS_TRUNC_T, 1,      T,     T,      VOCAB,    CP    >(sim_cls_stream,    DUT_PERM_CLS,  "Output CLS", true);
    //* check stream size
    assert(sim_cls_stream .size() == 0);
    //* compare
    compare<int64_t>(REF_PERM_CLS, DUT_PERM_CLS, T*VOCAB, "CLS");
}


void test_layer(int l_begin, int l_close){
    //* create streams
    hls::stream<hls::vector<GEMM_TRUNC_T,   CP> > gemm_stream( "gemm_stream");
    hls::stream<hls::vector<QKV_TRUNC_T,    CP> > qk_stream  ( "qk_stream"  );
    hls::stream<hls::vector<QKV_TRUNC_T,    CP> > v_stream   ( "v_stream"   );
    hls::stream<hls::vector<XUG_TRUNC_T,    CP> > ug_stream  ( "ug_stream"  );
    hls::stream<hls::vector<XD_TRUNC_T,     CP> > od_stream  ( "od_stream"  );
    hls::stream<hls::vector<CLS_TRUNC_T,    CP> > cls_stream ( "cls_stream" );

    //* for each layer, prepare input data & write to stream
    for(int l=l_begin; l<l_close; ++l){
        bool run_cls = l == LLAMA_L;
        //* prepare decoder data
        if(!run_cls) prepare_decoder_data(
            l,
            l_begin,
            l_close,
            gemm_stream
        );
        else prepare_cls_data(
            gemm_stream
        );
    }


    //* call top function
    top(l_begin, l_close, gemm_stream, qk_stream, v_stream, ug_stream, od_stream, cls_stream);

    
    //* check input stream size
    assert(gemm_stream.size() == 0);


    //* for each layer, compare the output
    for(int l=l_begin; l<l_close; ++l){
        bool run_cls = l == LLAMA_L;
        //* compare decoder data
        if(!run_cls) compare_decoder_data(
            l,
            l_begin,
            l_close,
            qk_stream,
            v_stream,
            ug_stream,
            od_stream
        );
        else compare_cls_data(
            cls_stream
        );
    }

}

int main(){
    // a simple case
    // test_layer(0, 1);

    // test_layer(1, 2);

    // // test cls only
    // test_layer(LLAMA_L, LLAMA_L+1); // PASSED

    // // test last decoder and cls
    // test_layer(LLAMA_L-1, LLAMA_L+1);

    // ultimate test
    // test_layer(0, LLAMA_L+1);
    test_layer(0, LLAMA_L);
}


