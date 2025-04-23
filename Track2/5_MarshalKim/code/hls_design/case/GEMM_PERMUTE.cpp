#include "src/common.h"
#include "src/tensor_core.h"
#include "src/accumulator.h"
#include "src/utils.h"

// 设计的consideration：
// 1. 权重的全广播：为了实现单周期消耗掉读入权重的所有数据依赖，必须将该权重广播到所有token，T被全展开，T==TP
// 2. unpack：gemm产生的输出数据位宽非常高，accumulator每隔很多个周期才会产生一个结果。unpack就是“完全解开T维度”的输出，而下一级需要再pack回来。
// 3. 多层设计与多层仿真：模块仅输入l_begin和l_close，自行判断是否是CLS

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
constexpr int CIP           = G;    // forced alignment, therefore the s can be bypassed
constexpr int COP           = G;    // forced alignment, therefore quantization can be done inplace
constexpr int TRUNC_BASE    = LLAMA_TRUNC_BASE;

// derived hyperparameters
constexpr int CT            = C     / CIP; // channel tripcount
constexpr int CMT           = CM    / CIP;
constexpr int VOCABT        = VOCAB / CIP;

// data types
typedef ap_int  <DW_AQ           > aq_t;
typedef ap_uint <DW_AS           > as_t;
typedef ap_int  <DW_WQ           > wq_t;
typedef ap_uint <DW_WS           > ws_t;
typedef ap_int  <DW_GEMM         > gemm_t;
typedef ap_int  <DW_GEMM_ACC     > acc_t;   // largest accumulated value
typedef ap_int  <DW_GEMM_TRUNC   > of_t;    // after base truncation

// derived simulation hyperparameters
// QKVOUGD
// QKVO:  T*C  -> T*C
// UG:    T*C  -> T*CM
// D:     T*CM -> T*C
// CLASS: T*C  -> T*CLASS
const int T_QKVO        = (C  * C    ) / (CIP * COP);  // CI and CO tripcounts for one matrix
const int T_UG          = (C  * CM   ) / (CIP * COP);
const int T_D           = (CM * C    ) / (CIP * COP);
const int T_CLS         = (C  * VOCAB) / (CIP * COP);
const int T_DECODER     = T_QKVO*4 + T_UG*2 + T_D;
// next for accumulator, need to determine ACC_CYCS1, ACC_CYCS2, ACC_CYCS3, ACC_REPEAT1, ACC_REPEAT2, ACC_REPEAT3
const int ACC_CYCS1     = C  / CIP;
const int ACC_CYCS2     = CM / CIP;
const int ACC_CYCS3     = C  / CIP;
// total repeat times, of two stages
const int N_QKVO        = C  / COP;
const int N_UG          = CM / COP;
const int N_D           = C  / COP;
const int N_CLS         = VOCAB / COP;
const int ACC_REPEAT1   = N_QKVO*4 + N_UG*2;
const int ACC_REPEAT2   = N_D;
const int ACC_REPEAT3   = N_CLS;

// instanciation
TENSOR_CORE <        aq_t, wq_t, gemm_t,                  T, CIP, COP, T_DECODER, T_CLS                                                         > tensor_core_inst;
ACCUMULATOR <gemm_t, as_t, ws_t, acc_t, of_t, TRUNC_BASE, T,      COP, ACC_CYCS1, ACC_CYCS2, ACC_CYCS3, ACC_REPEAT1, ACC_REPEAT2, ACC_REPEAT3, G> accumulator_inst;

// top function
void top_helper(
    bool run_cls,
    // streams
    hls::stream<hls::vector<aq_t,    T  *CIP> >& i_stream,
    hls::stream<hls::vector<as_t,    T      > >& s_stream,
    hls::stream<hls::vector<wq_t,    COP*CIP> >& w_stream,
    hls::stream<hls::vector<ws_t,    COP    > >& s1_stream,
    hls::stream<hls::vector<ws_t,    COP    > >& s2_stream,
    hls::stream<hls::vector<of_t,    COP    > >& o_stream
){
    #pragma HLS interface ap_ctrl_chain port=return

    #pragma HLS interface axis port=i_stream
    #pragma HLS interface axis port=w_stream
    #pragma HLS interface axis port=s_stream
    #pragma HLS interface axis port=s1_stream
    #pragma HLS interface axis port=s2_stream
    #pragma HLS interface axis port=o_stream

    // set aggregate pragma
    #pragma HLS aggregate variable=i_stream  compact=bit
    #pragma HLS aggregate variable=w_stream  compact=bit
    #pragma HLS aggregate variable=s_stream  compact=bit
    #pragma HLS aggregate variable=s1_stream compact=bit
    #pragma HLS aggregate variable=s2_stream compact=bit
    #pragma HLS aggregate variable=o_stream  compact=bit

    hls::stream<hls::vector<gemm_t, T *COP> > gemm_stream ("gemm_stream");

    #pragma HLS dataflow

    tensor_core_inst.   do_tensor_core  (run_cls,  i_stream,   w_stream,   gemm_stream                                                );
    accumulator_inst.   do_accumulator  (run_cls,                          gemm_stream,   s_stream,   s1_stream,  s2_stream,  o_stream);
}

// top function
void top(
    // scalar inputs
    int l_begin,
    int l_close,
    // streams
    hls::stream<hls::vector<aq_t,    T  *CIP> >& i_stream,
    hls::stream<hls::vector<as_t,    T      > >& s_stream,
    hls::stream<hls::vector<wq_t,    COP*CIP> >& w_stream,
    hls::stream<hls::vector<ws_t,    COP    > >& s1_stream,
    hls::stream<hls::vector<ws_t,    COP    > >& s2_stream,
    hls::stream<hls::vector<of_t,    COP    > >& o_stream
){
    #pragma HLS interface ap_ctrl_chain port=return

    #pragma HLS interface axis port=i_stream
    #pragma HLS interface axis port=w_stream
    #pragma HLS interface axis port=s_stream
    #pragma HLS interface axis port=s1_stream
    #pragma HLS interface axis port=s2_stream
    #pragma HLS interface axis port=o_stream

    // set aggregate pragma
    #pragma HLS aggregate variable=i_stream  compact=bit
    #pragma HLS aggregate variable=w_stream  compact=bit
    #pragma HLS aggregate variable=s_stream  compact=bit
    #pragma HLS aggregate variable=s1_stream compact=bit
    #pragma HLS aggregate variable=s2_stream compact=bit
    #pragma HLS aggregate variable=o_stream  compact=bit

    for(int l=l_begin; l<l_close; ++l){
        bool run_cls = (l == LLAMA_L);
        top_helper(run_cls, i_stream, s_stream, w_stream, s1_stream, s2_stream, o_stream);
    }

}


// declare ref input arrays
int8_t  REF_MHA_XLN_Q   [L][T *C     ]; // QKV input
int8_t  REF_MHA_XLN_S   [L][T *CT    ]; // QKV input
int8_t  REF_MHA_A_Q     [L][T *C     ]; // A input
int8_t  REF_MHA_A_S     [L][T *CT    ]; // A input
int8_t  REF_MLP_XLN_Q   [L][T *C     ]; // UG input
int8_t  REF_MLP_XLN_S   [L][T *CT    ]; // UG input
int8_t  REF_MLP_XM_Q    [L][T *CM    ]; // D input
int8_t  REF_MLP_XM_S    [L][T *CMT   ]; // D input
// CLS
int8_t  REF_CLS_XLN_Q      [T *C     ]; // head input
int8_t  REF_CLS_XLN_S      [T *CT    ]; // head input
// declare weights
int8_t  REF_WQ_Q           [C *C     ]; // Q weight
int8_t  REF_WQ_S1          [C *CT    ]; // Q shift1
int8_t  REF_WQ_S2          [C *CT    ]; // Q shift2
int8_t  REF_WK_Q           [C *C     ]; // K weight
int8_t  REF_WK_S1          [C *CT    ]; // K shift1
int8_t  REF_WK_S2          [C *CT    ]; // K shift2
int8_t  REF_WV_Q           [C *C     ]; // V weight
int8_t  REF_WV_S1          [C *CT    ]; // V shift1
int8_t  REF_WV_S2          [C *CT    ]; // V shift2
int8_t  REF_WO_Q           [C *C     ]; // O weight
int8_t  REF_WO_S1          [C *CT    ]; // O shift1
int8_t  REF_WO_S2          [C *CT    ]; // O shift2
int8_t  REF_WU_Q           [CM*C     ]; // U weight
int8_t  REF_WU_S1          [CM*CT    ]; // U shift1
int8_t  REF_WU_S2          [CM*CT    ]; // U shift2
int8_t  REF_WG_Q           [CM*C     ]; // G weight
int8_t  REF_WG_S1          [CM*CT    ]; // G shift1
int8_t  REF_WG_S2          [CM*CT    ]; // G shift2
int8_t  REF_WD_Q           [C *CM    ]; // D weight
int8_t  REF_WD_S1          [C *CMT   ]; // D shift1
int8_t  REF_WD_S2          [C *CMT   ]; // D shift2
int8_t  REF_CLS_W_Q        [C *VOCAB ]; // VOCAB weight
int8_t  REF_CLS_W_S1       [C *VOCABT]; // VOCAB shift1
int8_t  REF_CLS_W_S2       [C *VOCABT]; // VOCAB shift2
// declare the bias here
int64_t REF_BQ          [L][C        ]; // Q bias
int64_t REF_BK          [L][C        ]; // K bias
int64_t REF_BV          [L][C        ]; // V bias
int64_t REF_BK_RAW      [L][KVH*HC   ]; // K raw bias
int64_t REF_BV_RAW      [L][KVH*HC   ]; // V raw bias
// declare the ref output
int64_t REF_MHA_Q       [L][T *C     ]; // Q output
int64_t REF_MHA_K       [L][T *C     ]; // K output
int64_t REF_MHA_V       [L][T *C     ]; // V output
int64_t REF_MHA_O       [L][T *C     ]; // O output
int64_t REF_MLP_U       [L][T *CM    ]; // U output
int64_t REF_MLP_G       [L][T *CM    ]; // G output
int64_t REF_MLP_D       [L][T *C     ]; // D output
int64_t REF_CLS            [T *VOCAB ]; // CLASS output
// declare the ref permuted input
int64_t REF_MHA_PERM_QKV[L][H  *3*T*HC   ];
int64_t REF_MHA_PERM_O  [L][H    *T*HC   ];
int64_t REF_MLP_PERM_UG [L][CMT*2*T*COP  ];
int64_t REF_MLP_PERM_D  [L][      T*C    ];
int64_t REF_CLS_PERM       [      T*VOCAB];
// declare the ref permuted output
int64_t DUT_MHA_PERM_QKV   [H  *3*T*HC   ];
int64_t DUT_MHA_PERM_O     [H    *T*HC   ];
int64_t DUT_MLP_PERM_UG    [CMT*2*T*COP  ];
int64_t DUT_MLP_PERM_D     [      T*C    ];
int64_t DUT_CLS_PERM       [      T*VOCAB];



void prepare_decoder_data(
    int l,
    int l_begin,
    int l_close,
    hls::stream<hls::vector<aq_t,    T  *CIP> >& i_stream,
    hls::stream<hls::vector<as_t,    T      > >& s_stream,
    hls::stream<hls::vector<wq_t,    COP*CIP> >& w_stream,
    hls::stream<hls::vector<ws_t,    COP    > >& s1_stream,
    hls::stream<hls::vector<ws_t,    COP    > >& s2_stream
){
    const string binaries_path = BINARIES_PATH + to_string(l);
    const string condense_path = CONDENSE_PATH + to_string(l);

    auto MHA_XLN_Q      = read_tensor<int8_t>  (binaries_path + "/MHA_XLN_Q.bin"    );
    auto MHA_XLN_S      = read_tensor<int8_t>  (binaries_path + "/MHA_XLN_S.bin"    );
    auto MHA_A_Q        = read_tensor<int8_t>  (binaries_path + "/MHA_A_Q.bin"      );
    auto MHA_A_S        = read_tensor<int8_t>  (binaries_path + "/MHA_A_S.bin"      );
    auto MLP_XLN_Q      = read_tensor<int8_t>  (binaries_path + "/MLP_XLN_Q.bin"    );
    auto MLP_XLN_S      = read_tensor<int8_t>  (binaries_path + "/MLP_XLN_S.bin"    );
    auto MLP_XM_Q       = read_tensor<int8_t>  (binaries_path + "/MLP_XM_Q.bin"     );
    auto MLP_XM_S       = read_tensor<int8_t>  (binaries_path + "/MLP_XM_S.bin"     );
    // read weights
    auto MHA_WQ_Q       = read_tensor<int8_t>  (binaries_path + "/MHA_WQ_Q.bin"     );
    auto MHA_WQ_S1      = read_tensor<int8_t>  (binaries_path + "/MHA_WQ_S1.bin"    );
    auto MHA_WQ_S2      = read_tensor<int8_t>  (binaries_path + "/MHA_WQ_S2.bin"    );
    auto MHA_WK_Q       = read_tensor<int8_t>  (binaries_path + "/MHA_WK_Q.bin"     );
    auto MHA_WK_S1      = read_tensor<int8_t>  (binaries_path + "/MHA_WK_S1.bin"    );
    auto MHA_WK_S2      = read_tensor<int8_t>  (binaries_path + "/MHA_WK_S2.bin"    );
    auto MHA_WV_Q       = read_tensor<int8_t>  (binaries_path + "/MHA_WV_Q.bin"     );
    auto MHA_WV_S1      = read_tensor<int8_t>  (binaries_path + "/MHA_WV_S1.bin"    );
    auto MHA_WV_S2      = read_tensor<int8_t>  (binaries_path + "/MHA_WV_S2.bin"    );
    auto MHA_WO_Q       = read_tensor<int8_t>  (binaries_path + "/MHA_WO_Q.bin"     );
    auto MHA_WO_S1      = read_tensor<int8_t>  (binaries_path + "/MHA_WO_S1.bin"    );
    auto MHA_WO_S2      = read_tensor<int8_t>  (binaries_path + "/MHA_WO_S2.bin"    );
    auto MLP_WU_Q       = read_tensor<int8_t>  (binaries_path + "/MLP_WU_Q.bin"     );
    auto MLP_WU_S1      = read_tensor<int8_t>  (binaries_path + "/MLP_WU_S1.bin"    );
    auto MLP_WU_S2      = read_tensor<int8_t>  (binaries_path + "/MLP_WU_S2.bin"    );
    auto MLP_WG_Q       = read_tensor<int8_t>  (binaries_path + "/MLP_WG_Q.bin"     );
    auto MLP_WG_S1      = read_tensor<int8_t>  (binaries_path + "/MLP_WG_S1.bin"    );
    auto MLP_WG_S2      = read_tensor<int8_t>  (binaries_path + "/MLP_WG_S2.bin"    );
    auto MLP_WD_Q       = read_tensor<int8_t>  (binaries_path + "/MLP_WD_Q.bin"     );
    auto MLP_WD_S1      = read_tensor<int8_t>  (binaries_path + "/MLP_WD_S1.bin"    );
    auto MLP_WD_S2      = read_tensor<int8_t>  (binaries_path + "/MLP_WD_S2.bin"    );
    // read bias
    auto BQ             = read_tensor<int64_t> (binaries_path + "/MHA_BQ.bin"       );
    auto BK             = read_tensor<int64_t> (binaries_path + "/MHA_BK.bin"       );
    auto BV             = read_tensor<int64_t> (binaries_path + "/MHA_BV.bin"       );
    auto BK_RAW         = read_tensor<int64_t> (binaries_path + "/MHA_BK_RAW.bin"   );
    auto BV_RAW         = read_tensor<int64_t> (binaries_path + "/MHA_BV_RAW.bin"   );
    // read results
    auto MHA_Q          = read_tensor<int64_t> (binaries_path + "/MHA_Q.bin"        );
    auto MHA_K          = read_tensor<int64_t> (binaries_path + "/MHA_K.bin"        );
    auto MHA_V          = read_tensor<int64_t> (binaries_path + "/MHA_V.bin"        );
    auto MHA_O          = read_tensor<int64_t> (binaries_path + "/MHA_O.bin"        );
    auto MLP_U          = read_tensor<int64_t> (binaries_path + "/MLP_XU.bin"       );
    auto MLP_G          = read_tensor<int64_t> (binaries_path + "/MLP_XG.bin"       );
    auto MLP_D          = read_tensor<int64_t> (binaries_path + "/MLP_XD.bin"       );
    // put input refs
    //                      tensor,         array,                  H_LOAD,     H,          T_LOAD,     T_START,    T,          C_LOAD,     C
    tensor2array<int8_t>(   MHA_XLN_Q,      REF_MHA_XLN_Q[l],       1,          1,          T_LOAD,     POS,        T,          C,          C   );
    tensor2array<int8_t>(   MHA_XLN_S,      REF_MHA_XLN_S[l],       1,          1,          T_LOAD,     POS,        T,          CT,         CT  );
    tensor2array<int8_t>(   MHA_A_Q,        REF_MHA_A_Q  [l],       1,          1,          T_LOAD,     POS,        T,          C,          C   );
    tensor2array<int8_t>(   MHA_A_S,        REF_MHA_A_S  [l],       1,          1,          T_LOAD,     POS,        T,          CT,         CT  );
    tensor2array<int8_t>(   MLP_XLN_Q,      REF_MLP_XLN_Q[l],       1,          1,          T_LOAD,     POS,        T,          C,          C   );
    tensor2array<int8_t>(   MLP_XLN_S,      REF_MLP_XLN_S[l],       1,          1,          T_LOAD,     POS,        T,          CT,         CT  );
    tensor2array<int8_t>(   MLP_XM_Q,       REF_MLP_XM_Q [l],       1,          1,          T_LOAD,     POS,        T,          CM,         CM  );
    tensor2array<int8_t>(   MLP_XM_S,       REF_MLP_XM_S [l],       1,          1,          T_LOAD,     POS,        T,          CMT,        CMT );
    // put weight refs
    tensor2array<int8_t>(   MHA_WQ_Q,       REF_WQ_Q        ,       1,          1,          C,                      C,          C,          C   );
    tensor2array<int8_t>(   MHA_WQ_S1,      REF_WQ_S1       ,       1,          1,          C,                      C,          CT,         CT  );
    tensor2array<int8_t>(   MHA_WQ_S2,      REF_WQ_S2       ,       1,          1,          C,                      C,          CT,         CT  );
    tensor2array<int8_t>(   MHA_WK_Q,       REF_WK_Q        ,       1,          1,          C,                      C,          C,          C   );
    tensor2array<int8_t>(   MHA_WK_S1,      REF_WK_S1       ,       1,          1,          C,                      C,          CT,         CT  );
    tensor2array<int8_t>(   MHA_WK_S2,      REF_WK_S2       ,       1,          1,          C,                      C,          CT,         CT  );
    tensor2array<int8_t>(   MHA_WV_Q,       REF_WV_Q        ,       1,          1,          C,                      C,          C,          C   );
    tensor2array<int8_t>(   MHA_WV_S1,      REF_WV_S1       ,       1,          1,          C,                      C,          CT,         CT  );
    tensor2array<int8_t>(   MHA_WV_S2,      REF_WV_S2       ,       1,          1,          C,                      C,          CT,         CT  );
    tensor2array<int8_t>(   MHA_WO_Q,       REF_WO_Q        ,       1,          1,          C,                      C,          C,          C   );
    tensor2array<int8_t>(   MHA_WO_S1,      REF_WO_S1       ,       1,          1,          C,                      C,          CT,         CT  );
    tensor2array<int8_t>(   MHA_WO_S2,      REF_WO_S2       ,       1,          1,          C,                      C,          CT,         CT  );
    tensor2array<int8_t>(   MLP_WU_Q,       REF_WU_Q        ,       1,          1,          CM,                     CM,         C,          C   );
    tensor2array<int8_t>(   MLP_WU_S1,      REF_WU_S1       ,       1,          1,          CM,                     CM,         CT,         CT  );
    tensor2array<int8_t>(   MLP_WU_S2,      REF_WU_S2       ,       1,          1,          CM,                     CM,         CT,         CT  );
    tensor2array<int8_t>(   MLP_WG_Q,       REF_WG_Q        ,       1,          1,          CM,                     CM,         C,          C   );
    tensor2array<int8_t>(   MLP_WG_S1,      REF_WG_S1       ,       1,          1,          CM,                     CM,         CT,         CT  );
    tensor2array<int8_t>(   MLP_WG_S2,      REF_WG_S2       ,       1,          1,          CM,                     CM,         CT,         CT  );
    tensor2array<int8_t>(   MLP_WD_Q,       REF_WD_Q        ,       1,          1,          C,                      C,          CM,         CM  );
    tensor2array<int8_t>(   MLP_WD_S1,      REF_WD_S1       ,       1,          1,          C,                      C,          CMT,        CMT );
    tensor2array<int8_t>(   MLP_WD_S2,      REF_WD_S2       ,       1,          1,          C,                      C,          CMT,        CMT );
    // put bias
    tensor2array<int64_t>(  BQ,             REF_BQ       [l],       1,          1,          C,                      C,          1,          1   );
    tensor2array<int64_t>(  BK,             REF_BK       [l],       1,          1,          C,                      C,          1,          1   );
    tensor2array<int64_t>(  BV,             REF_BV       [l],       1,          1,          C,                      C,          1,          1   );
    tensor2array<int64_t>(  BK_RAW,         REF_BK_RAW   [l],       1,          1,          KVH*HC,                 KVH*HC,     1,          1   );
    tensor2array<int64_t>(  BV_RAW,         REF_BV_RAW   [l],       1,          1,          KVH*HC,                 KVH*HC,     1,          1   );
    // put results
    tensor2array<int64_t>(  MHA_Q,          REF_MHA_Q    [l],       1,          1,          T_LOAD,     POS,        T,          C,          C   );
    tensor2array<int64_t>(  MHA_K,          REF_MHA_K    [l],       1,          1,          T_LOAD,     POS,        T,          C,          C   );
    tensor2array<int64_t>(  MHA_V,          REF_MHA_V    [l],       1,          1,          T_LOAD,     POS,        T,          C,          C   );
    tensor2array<int64_t>(  MHA_O,          REF_MHA_O    [l],       1,          1,          T_LOAD,     POS,        T,          C,          C   );
    tensor2array<int64_t>(  MLP_U,          REF_MLP_U    [l],       1,          1,          T_LOAD,     POS,        T,          CM,         CM  );
    tensor2array<int64_t>(  MLP_G,          REF_MLP_G    [l],       1,          1,          T_LOAD,     POS,        T,          CM,         CM  );
    tensor2array<int64_t>(  MLP_D,          REF_MLP_D    [l],       1,          1,          T_LOAD,     POS,        T,          C,          C   );

    //* HANDCRAFTED PERMUTATION
    //* for QKV, divide output channel in the granularity of head, and interleave
    for(int h=0; h<H; ++h){
        for(int qkv=0; qkv<3; ++qkv){
            for(int t=0; t<T; ++t){
                for(int hc=0; hc<HC; ++hc){
                    REF_MHA_PERM_QKV[l][h*3*T*HC + qkv*T*HC + t*HC + hc] = 
                        qkv == 0 ? REF_MHA_Q[l][t*C + h*HC + hc] :
                        qkv == 1 ? REF_MHA_K[l][t*C + h*HC + hc] :
                        qkv == 2 ? REF_MHA_V[l][t*C + h*HC + hc] : 0;
                }
            }
        }
    }
    //* for O, normal, split head as well
    for(int h=0; h<H; ++h){
        for(int t=0; t<T; ++t){
            for(int hc=0; hc<HC; ++hc){
                REF_MHA_PERM_O[l][h*T*HC + t*HC + hc] = REF_MHA_O[l][t*C + h*HC + hc];
            }
        }
    }
    //* for UG, divide output channel in the granularity of COP, and interleave
    for(int cot=0; cot<CMT; ++cot){
        for(int ug=0; ug<2; ++ug){
            for(int t=0; t<T; ++t){
                for(int cop=0; cop<COP; ++cop){
                    REF_MLP_PERM_UG[l][cot*2*T*COP + ug*T*COP + t*COP + cop] =
                        ug == 0 ? REF_MLP_U[l][t*CM + cot*COP + cop] :
                        ug == 1 ? REF_MLP_G[l][t*CM + cot*COP + cop] : 0;
                }
            }
        }
    }
    //* for D, normal
    for(int t=0; t<T; ++t){
        for(int c=0; c<C; ++c){
            REF_MLP_PERM_D[l][t*C + c] = REF_MLP_D[l][t*C + c];
        }
    }

    //* declare simulated streams
    hls::stream<hls::vector<aq_t,    T  *CIP> > sim_i_stream ("sim_i_stream");
    hls::stream<hls::vector<as_t,    T      > > sim_s_stream ("sim_s_stream");
    hls::stream<hls::vector<wq_t,    COP*CIP> > sim_w_stream ("sim_w_stream");
    hls::stream<hls::vector<ws_t,    COP    > > sim_s1_stream("sim_s1_stream");
    hls::stream<hls::vector<ws_t,    COP    > > sim_s2_stream("sim_s2_stream");

    //*write decoder input data to stream
    // MHA_XLN: 3 times to generate QKV
    // A:       1 time to generate O
    // MLP_XLN: 2 times to generate UG
    // XM:      1 time to generate D

    // input quantized data
    //              tensor_t,   stream_t,   REPEAT,     H,      T,      TP,     C,      CP
    array2stream<   int8_t,     aq_t,       3*CT,       1,      T,      T,      C,      CIP>(REF_MHA_XLN_Q[l],         sim_i_stream, "Input QKV  ",  true  ); // Q,K,V
    array2stream<   int8_t,     aq_t,       CT,         1,      T,      T,      C,      CIP>(REF_MHA_A_Q  [l],         sim_i_stream, "Input O    ",  true  ); // O
    array2stream<   int8_t,     aq_t,       2*CMT,      1,      T,      T,      C,      CIP>(REF_MLP_XLN_Q[l],         sim_i_stream, "Input UG   ",  true  ); // U,G
    array2stream<   int8_t,     aq_t,       CT,         1,      T,      T,      CM,     CIP>(REF_MLP_XM_Q [l],         sim_i_stream, "Input D    ",  true  ); // D
    array2stream<   int8_t,     as_t,       3*CT,       1,      T,      T,      CT,     1  >(REF_MHA_XLN_S[l],         sim_s_stream, "Input QKV S",  true  ); // Q,K,V
    array2stream<   int8_t,     as_t,       CT,         1,      T,      T,      CT,     1  >(REF_MHA_A_S  [l],         sim_s_stream, "Input O   S",  true  ); // O
    array2stream<   int8_t,     as_t,       2*CMT,      1,      T,      T,      CT,     1  >(REF_MLP_XLN_S[l],         sim_s_stream, "Input UG  S",  true  ); // U,G 
    array2stream<   int8_t,     as_t,       CT,         1,      T,      T,      CMT,    1  >(REF_MLP_XM_S [l],         sim_s_stream, "Input D   S",  true  ); // D
    //* for QKV, divide output channel in the granularity of head
    for(int h=0; h<H; ++h){
    array2stream<   int8_t,     wq_t,       1,          1,      HC,     COP,         C,      CIP>(REF_WQ_Q  + h*HC*C,       sim_w_stream                        ); // Q
    array2stream<   int8_t,     wq_t,       1,          1,      HC,     COP,         C,      CIP>(REF_WK_Q  + h*HC*C,       sim_w_stream                        ); // K
    array2stream<   int8_t,     wq_t,       1,          1,      HC,     COP,         C,      CIP>(REF_WV_Q  + h*HC*C,       sim_w_stream                        ); // V
    array2stream<   int8_t,     ws_t,       1,          1,      HC,     COP,         CT,     1  >(REF_WQ_S1 + h*HC*CT,      sim_s1_stream                       ); // Q
    array2stream<   int8_t,     ws_t,       1,          1,      HC,     COP,         CT,     1  >(REF_WK_S1 + h*HC*CT,      sim_s1_stream                       ); // K
    array2stream<   int8_t,     ws_t,       1,          1,      HC,     COP,         CT,     1  >(REF_WV_S1 + h*HC*CT,      sim_s1_stream                       ); // V
    array2stream<   int8_t,     ws_t,       1,          1,      HC,     COP,         CT,     1  >(REF_WQ_S2 + h*HC*CT,      sim_s2_stream                       ); // Q
    array2stream<   int8_t,     ws_t,       1,          1,      HC,     COP,         CT,     1  >(REF_WK_S2 + h*HC*CT,      sim_s2_stream                       ); // K
    array2stream<   int8_t,     ws_t,       1,          1,      HC,     COP,         CT,     1  >(REF_WV_S2 + h*HC*CT,      sim_s2_stream                       ); // V
    }
    //* for O, not permuted; although it is head splitted, it is the same order
    array2stream<   int8_t,     wq_t,       1,          1,      C,      COP,         C,      CIP>(REF_WO_Q,                 sim_w_stream                        ); // O
    array2stream<   int8_t,     ws_t,       1,          1,      C,      COP,         CT,     1  >(REF_WO_S1,                sim_s1_stream                       ); // O
    array2stream<   int8_t,     ws_t,       1,          1,      C,      COP,         CT,     1  >(REF_WO_S2,                sim_s2_stream                       ); // O
    //* for UG, divide output channel in the granularity of COP
    for(int cot=0; cot<CMT; ++cot){
    array2stream<   int8_t,     wq_t,       1,          1,      COP,    COP,         C,      CIP>(REF_WU_Q  + cot*COP*C,    sim_w_stream                        ); // U
    array2stream<   int8_t,     wq_t,       1,          1,      COP,    COP,         C,      CIP>(REF_WG_Q  + cot*COP*C,    sim_w_stream                        ); // G
    array2stream<   int8_t,     ws_t,       1,          1,      COP,    COP,         CT,     1  >(REF_WU_S1 + cot*COP*CT,   sim_s1_stream                       ); // U
    array2stream<   int8_t,     ws_t,       1,          1,      COP,    COP,         CT,     1  >(REF_WG_S1 + cot*COP*CT,   sim_s1_stream                       ); // G
    array2stream<   int8_t,     ws_t,       1,          1,      COP,    COP,         CT,     1  >(REF_WU_S2 + cot*COP*CT,   sim_s2_stream                       ); // U
    array2stream<   int8_t,     ws_t,       1,          1,      COP,    COP,         CT,     1  >(REF_WG_S2 + cot*COP*CT,   sim_s2_stream                       ); // G
    }
    //* for D, normal
    array2stream<   int8_t,     wq_t,       1,          1,      C,      COP,         CM,     CIP>(REF_WD_Q,                 sim_w_stream                        ); // D
    array2stream<   int8_t,     ws_t,       1,          1,      C,      COP,         CMT,    1  >(REF_WD_S1,                sim_s1_stream                       ); // D
    array2stream<   int8_t,     ws_t,       1,          1,      C,      COP,         CMT,    1  >(REF_WD_S2,                sim_s2_stream                       ); // D

    //* save condensed input and weight
    const int NUM_X  = (3*CT*T*C + CT*T*C + 2*CMT*T*C + CT*T*CM);
    const int NUM_W  = (3*C*C    + C*C    + 2*CM*C    + C*CM   );
    const int NUM_Y  = (3*T*C    + T*C    + 2*T*CM    + T*C    );
    const int NUM_XS = NUM_X / CIP;
    const int NUM_WS = NUM_W / CIP;
    save_condensed_tensor<int8_t, aq_t, NUM_X,  T  *CIP>(condense_path + "/CONDENSED_GEMM_X_Q.bin" , sim_i_stream );
    save_condensed_tensor<int8_t, as_t, NUM_XS, T      >(condense_path + "/CONDENSED_GEMM_X_S.bin" , sim_s_stream );
    save_condensed_tensor<int8_t, wq_t, NUM_W,  COP*CIP>(condense_path + "/CONDENSED_GEMM_W_Q.bin" , sim_w_stream );
    save_condensed_tensor<int8_t, ws_t, NUM_WS, COP    >(condense_path + "/CONDENSED_GEMM_W_S1.bin", sim_s1_stream);
    save_condensed_tensor<int8_t, ws_t, NUM_WS, COP    >(condense_path + "/CONDENSED_GEMM_W_S2.bin", sim_s2_stream);

    //* move the simulated streams to real streams
    stream2stream<  aq_t,   T  *CIP>(sim_i_stream,  i_stream );
    stream2stream<  as_t,   T      >(sim_s_stream,  s_stream );
    stream2stream<  wq_t,   COP*CIP>(sim_w_stream,  w_stream );
    stream2stream<  ws_t,   COP    >(sim_s1_stream, s1_stream);
    stream2stream<  ws_t,   COP    >(sim_s2_stream, s2_stream);
}


void prepare_cls_data(
    hls::stream<hls::vector<aq_t,    T  *CIP> >& i_stream,
    hls::stream<hls::vector<as_t,    T      > >& s_stream,
    hls::stream<hls::vector<wq_t,    COP*CIP> >& w_stream,
    hls::stream<hls::vector<ws_t,    COP    > >& s1_stream,
    hls::stream<hls::vector<ws_t,    COP    > >& s2_stream
){
    const string binaries_path = BINARIES_PATH + to_string(LLAMA_L);
    const string condense_path = CONDENSE_PATH + to_string(LLAMA_L);
    //* prepare head data
    // read input refs
    auto CLS_XLN_Q  = read_tensor<int8_t>  (binaries_path + "/CLS_XLN_Q.bin" );
    auto CLS_XLN_S  = read_tensor<int8_t>  (binaries_path + "/CLS_XLN_S.bin" );
    // read weights
    auto CLS_W_Q    = read_tensor<int8_t>  (binaries_path + "/CLS_W_Q.bin"   );
    auto CLS_W_S1   = read_tensor<int8_t>  (binaries_path + "/CLS_W_S1.bin"  );
    auto CLS_W_S2   = read_tensor<int8_t>  (binaries_path + "/CLS_W_S2.bin"  );
    // read results
    auto CLS        = read_tensor<int64_t> (binaries_path + "/CLS.bin"       );
    // put input refs
    //                      tensor,         array,          H_LOAD,     H,      T_LOAD,     T,          C_LOAD,     C
    tensor2array<int8_t>(   CLS_XLN_Q,      REF_CLS_XLN_Q,  1,          1,      T_LOAD,     T,          C,          C    );
    tensor2array<int8_t>(   CLS_XLN_S,      REF_CLS_XLN_S,  1,          1,      T_LOAD,     T,          CT,         CT   );
    // put weight refs
    tensor2array<int8_t>(   CLS_W_Q,        REF_CLS_W_Q,    1,          1,      VOCAB,      VOCAB,      C,          C    );
    tensor2array<int8_t>(   CLS_W_S1,       REF_CLS_W_S1,   1,          1,      VOCAB,      VOCAB,      CT,         CT   );
    tensor2array<int8_t>(   CLS_W_S2,       REF_CLS_W_S2,   1,          1,      VOCAB,      VOCAB,      CT,         CT   );
    // put results
    tensor2array<int64_t>(  CLS,            REF_CLS,        1,          1,      T_LOAD,     T,          VOCAB,      VOCAB);

    //* HANDCRAFTED PERMUTATION
    //* for CLASS, normal
    for(int t=0; t<T; ++t){
        for(int vocab=0; vocab<VOCAB; ++vocab){
            REF_CLS_PERM[t*VOCAB + vocab] = CLS[t*VOCAB + vocab];
        }
    }

    //* declare simulated streams
    hls::stream<hls::vector<aq_t,    T * CIP> > sim_i_stream ("sim_i_stream");
    hls::stream<hls::vector<as_t,    T      > > sim_s_stream ("sim_s_stream");
    hls::stream<hls::vector<wq_t,    COP*CIP> > sim_w_stream ("sim_w_stream");
    hls::stream<hls::vector<ws_t,    COP    > > sim_s1_stream("sim_s1_stream");
    hls::stream<hls::vector<ws_t,    COP    > > sim_s2_stream("sim_s2_stream");

    //* write input data to stream
    // VOCAB: 1 time to generate CLS
    array2stream<   int8_t,     aq_t,       VOCABT,     1,      T,          T,      C,      CIP>(REF_CLS_XLN_Q,    sim_i_stream, "Input CLS X",   true );  
    array2stream<   int8_t,     as_t,       VOCABT,     1,      T,          T,      CT,     1  >(REF_CLS_XLN_S,    sim_s_stream, "Input CLS X S", true );  
    array2stream<   int8_t,     wq_t,       1,          1,      VOCAB,      COP,    C,      CIP>(REF_CLS_W_Q,      sim_w_stream                        );  
    array2stream<   int8_t,     ws_t,       1,          1,      VOCAB,      COP,    CT,     1  >(REF_CLS_W_S1,     sim_s1_stream                       ); 
    array2stream<   int8_t,     ws_t,       1,          1,      VOCAB,      COP,    CT,     1  >(REF_CLS_W_S2,     sim_s2_stream                       ); 

    //* save condensed input and weight
    const int NUM_X  = VOCABT*T*C;
    const int NUM_W  = VOCAB*C;
    const int NUM_Y  = T*VOCAB;
    const int NUM_XS = NUM_X / CIP;
    const int NUM_WS = NUM_W / CIP;
    save_condensed_tensor<int8_t, aq_t, NUM_X,  T*  CIP>(condense_path + "/CONDENSED_GEMM_X_Q.bin" , sim_i_stream );
    save_condensed_tensor<int8_t, as_t, NUM_XS, T      >(condense_path + "/CONDENSED_GEMM_X_S.bin" , sim_s_stream );
    save_condensed_tensor<int8_t, wq_t, NUM_W,  COP*CIP>(condense_path + "/CONDENSED_GEMM_W_Q.bin" , sim_w_stream );
    save_condensed_tensor<int8_t, ws_t, NUM_WS, COP    >(condense_path + "/CONDENSED_GEMM_W_S1.bin", sim_s1_stream);
    save_condensed_tensor<int8_t, ws_t, NUM_WS, COP    >(condense_path + "/CONDENSED_GEMM_W_S2.bin", sim_s2_stream);

    //* move the simulated streams to real streams
    stream2stream<  aq_t,   T  *CIP>(sim_i_stream,  i_stream );
    stream2stream<  as_t,   T      >(sim_s_stream,  s_stream );
    stream2stream<  wq_t,   COP*CIP>(sim_w_stream,  w_stream );
    stream2stream<  ws_t,   COP    >(sim_s1_stream, s1_stream);
    stream2stream<  ws_t,   COP    >(sim_s2_stream, s2_stream);
}


void compare_decoder_data(
    int l,
    int l_begin,
    int l_close,
    hls::stream<hls::vector<of_t,    COP         > >& o_stream
){
    const string binaries_path = BINARIES_PATH + to_string(l);
    const string condense_path = CONDENSE_PATH + to_string(l);
    //* save condensed output
    const int NUM_Y  = (H*3*T*HC + H*T*HC + 2*T*CM + T*C);
    hls::stream<hls::vector<of_t, COP> > sim_o_stream("sim_o_stream");
    stream2stream        <         of_t, NUM_Y, COP>(o_stream, sim_o_stream);
    save_condensed_tensor<int64_t, of_t, NUM_Y, COP>(condense_path + "/CONDENSED_GEMM_Y.bin", sim_o_stream);
    //* interleaved read out
    stream2array_unpack<int64_t,    of_t,   H*3,    T,  T,  HC,    COP>(sim_o_stream,      DUT_MHA_PERM_QKV, "Output QKV", true);
    stream2array_unpack<int64_t,    of_t,   H,      T,  T,  HC,    COP>(sim_o_stream,      DUT_MHA_PERM_O,   "Output O",   true);
    stream2array_unpack<int64_t,    of_t,   CMT*2,  T,  T,  COP,   COP>(sim_o_stream,      DUT_MLP_PERM_UG,  "Output UG",  true);
    stream2array_unpack<int64_t,    of_t,   1,      T,  T,  C,     COP>(sim_o_stream,      DUT_MLP_PERM_D,   "Output D",   true);
    //* check stream size
    assert(sim_o_stream .size() == 0);
    //* do extra truncation
    for(int h=0; h<H; ++h){
        for(int qkv=0; qkv<3; ++qkv){
            int extra_trunc = (qkv == 0 || qkv == 1) ? (MHA_TRUNC_QK - TRUNC_BASE) : (MHA_TRUNC_V - TRUNC_BASE);
            truncate<int64_t>(DUT_MHA_PERM_QKV + h*3*T*HC + qkv*T*HC, T*HC, extra_trunc);
        }
    }
    truncate<int64_t>(DUT_MHA_PERM_O,   H*T*HC,   (MHA_TRUNC_O   - TRUNC_BASE));
    truncate<int64_t>(DUT_MLP_PERM_UG,  2*T*CM,   (MLP_TRUNC_UG  - TRUNC_BASE));
    truncate<int64_t>(DUT_MLP_PERM_D,   T*C,      (MLP_TRUNC_D   - TRUNC_BASE));
    //* add bias
    for(int h=0; h<H; ++h){
        for(int qkv=0; qkv<3; ++qkv){
            for(int t=0; t<T; ++t){
                for(int hc=0; hc<HC; ++hc){
                    int kvh = h / (H/KVH);
                    auto bias = qkv == 0 ? REF_BQ    [l][  h*HC + hc] :
                                qkv == 1 ? REF_BK_RAW[l][kvh*HC + hc] :
                                qkv == 2 ? REF_BV_RAW[l][kvh*HC + hc] : 0;
                    DUT_MHA_PERM_QKV[h*3*T*HC + qkv*T*HC + t*HC + hc] += bias;
                }
            }
        }
    }
    //* compare
    compare<int64_t>(REF_MHA_PERM_QKV[l], DUT_MHA_PERM_QKV, H*3*T*HC, "MHA_PERM_QKV");
    compare<int64_t>(REF_MHA_PERM_O  [l], DUT_MHA_PERM_O,   H*T*HC,   "MHA_PERM_O"  );
    compare<int64_t>(REF_MLP_PERM_UG [l], DUT_MLP_PERM_UG,  2*T*CM,   "MLP_PERM_UG" );
    compare<int64_t>(REF_MLP_PERM_D  [l], DUT_MLP_PERM_D,   T*C,      "MLP_PERM_D"  );
}


void compare_cls_data(
    hls::stream<hls::vector<of_t,    COP         > >& o_stream
){
    const string binaries_path = BINARIES_PATH + to_string(LLAMA_L);
    const string condense_path = CONDENSE_PATH + to_string(LLAMA_L);
    //* save condensed output
    const int NUM_Y  = T*VOCAB;
    hls::stream<hls::vector<of_t, COP> > sim_o_stream("sim_o_stream");
    stream2stream        <         of_t, NUM_Y, COP>(o_stream, sim_o_stream);
    save_condensed_tensor<int64_t, of_t, NUM_Y, COP>(condense_path + "/CONDENSED_GEMM_Y.bin", sim_o_stream);
    //* interleaved read out
    stream2array_unpack<int64_t,    of_t,           1,      T,          T,      VOCAB,     COP>(sim_o_stream,      DUT_CLS_PERM, "Output CLS", true);
    //* check stream size
    assert(sim_o_stream .size() == 0);
    //* do extra truncation
    truncate<int64_t>(DUT_CLS_PERM, T*VOCAB, (CLS_TRUNC - TRUNC_BASE));
    //* compare
    compare<int64_t>(REF_CLS_PERM, DUT_CLS_PERM, T*VOCAB, "CLS_PERM");
}


void test_layer(int l_begin, int l_close){
    //* create streams
    hls::stream<hls::vector<aq_t,  T  *CIP> > i_stream   ( "i_stream"   );
    hls::stream<hls::vector<as_t,  T      > > s_stream   ( "s_stream"   );
    hls::stream<hls::vector<wq_t,  COP*CIP> > w_stream   ( "w_stream"   );
    hls::stream<hls::vector<ws_t,  COP    > > s1_stream  ( "s1_stream"  );
    hls::stream<hls::vector<ws_t,  COP    > > s2_stream  ( "s2_stream"  );
    hls::stream<hls::vector<of_t,  COP    > > o_stream   ( "o_stream"   );

    //* for each layer, prepare input data & write to stream
    for(int l=l_begin; l<l_close; ++l){
        bool run_cls = l == LLAMA_L;
        //* prepare decoder data
        if(!run_cls) prepare_decoder_data(
            l,
            l_begin,
            l_close,
            i_stream,
            s_stream,
            w_stream,
            s1_stream,
            s2_stream
        );
        else prepare_cls_data(
            i_stream,
            s_stream,
            w_stream,
            s1_stream,
            s2_stream
        );
    }


    // //* before calling top, print the stream
    // print_stream<  aq_t, T  *CIP, 64>(i_stream,  "i_stream" );
    // print_stream<  as_t, T      , 64>(s_stream,  "s_stream" );
    // print_stream<  wq_t, COP*CIP, 64>(w_stream,  "w_stream" );
    // print_stream<  ws_t, COP    , 64>(s1_stream, "s1_stream");
    // print_stream<  ws_t, COP    , 64>(s2_stream, "s2_stream");


    //* call the top function
    top(l_begin, l_close, i_stream, s_stream, w_stream, s1_stream, s2_stream, o_stream);


    // // * after calling top, print the stream
    // print_stream<  of_t, COP, 64>(o_stream, "o_stream");

    
    //* check input stream size
    assert(i_stream .size() == 0);
    assert(s_stream .size() == 0);
    assert(w_stream .size() == 0);
    assert(s1_stream.size() == 0);
    assert(s2_stream.size() == 0);


    //* for each layer, get output
    for(int l=l_begin; l<l_close; ++l){
        bool run_cls = l == LLAMA_L;
        //* compare decoder data
        if(!run_cls)  compare_decoder_data(l, l_begin, l_close, o_stream);
        else          compare_cls_data    (                     o_stream);
    }

}


int main(){
    // a simple case
    test_layer(0, 1); // PASSED
    
    // test head only
    // test_layer(LLAMA_L, LLAMA_L+1); // PASSED

    // test second decoder
    // test_layer(1, 2); // PASSED

    // test first two layers
    // test_layer(0, 2); // 

    // test last 2 decoder and CLS
    // test_layer(LLAMA_L-1, LLAMA_L+1); // PASSED

    // ultimate test
    // test_layer(0, LLAMA_L);
    // test_layer(0, LLAMA_L+1);

    return 0;
}
