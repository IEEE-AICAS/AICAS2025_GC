#ifndef __INT_COMMON_H__
#define __INT_COMMON_H__

// standard library
#include <cassert>
#include <ctime>
#include <iostream>
#include <cstdint>
#include <random>
#include <fstream>
#include <numeric>

// hls library
#include <ap_int.h>
#include <ap_axi_sdata.h>
#include <hls_stream.h>
#include <hls_vector.h>

// user defined library
#include "adapter.h"
#include "utils.h"

using namespace std;

constexpr int log2ce(int n){
    return (n <= 1) ? 0 : 1 + log2ce(n / 2);
}

// RAM styles
constexpr int BRAM_STYLE = 0;
constexpr int URAM_STYLE = 1;
constexpr int LRAM_STYLE = 2;

// some hyper parameters
constexpr int DECODER_HYPERPARAMS[] = {
    #include "src/ref/DECODER_HYPERPARAMS.txt"
};
constexpr int LLAMA_C       = DECODER_HYPERPARAMS[0];
constexpr int LLAMA_GA      = DECODER_HYPERPARAMS[1];
constexpr int LLAMA_GW      = DECODER_HYPERPARAMS[2];
constexpr int LLAMA_GR      = DECODER_HYPERPARAMS[3];
constexpr int LLAMA_H       = DECODER_HYPERPARAMS[4];
// constexpr int LLAMA_KVH     = DECODER_HYPERPARAMS[5];
constexpr int LLAMA_KVH     = 2; // overwrite
constexpr int LLAMA_HC      = DECODER_HYPERPARAMS[6];
constexpr int LLAMA_CM      = DECODER_HYPERPARAMS[7];
constexpr int LLAMA_VOCAB   = DECODER_HYPERPARAMS[8];
constexpr int DW_AQ         = DECODER_HYPERPARAMS[9];   
constexpr int DW_WQ         = DECODER_HYPERPARAMS[10];  
constexpr int LLAMA_L       = 24;
constexpr int LLAMA_S       = 256;                     // maximum support sequence length

// static checks
static_assert(LLAMA_GA == LLAMA_GW && LLAMA_GW == LLAMA_GR,     "GA, GW, GR must be equal"  );
constexpr int LLAMA_G = LLAMA_GA;

static_assert(LLAMA_HC * LLAMA_H == LLAMA_C,                    "HC * H must be equal to C" );


// MHA trunc
constexpr int MHA_TRUNCS[] = {
    #include "src/ref/MHA_TRUNCS.txt"
};
constexpr int MHA_TRUNC_QK  = MHA_TRUNCS[0];
constexpr int MHA_TRUNC_V   = MHA_TRUNCS[1];
constexpr int MHA_TRUNC_ROT = MHA_TRUNCS[2];
constexpr int MHA_TRUNC_R   = MHA_TRUNCS[3];
constexpr int MHA_TRUNC_A   = MHA_TRUNCS[4];
constexpr int MHA_TRUNC_O   = MHA_TRUNCS[5];

// MLP trunc
constexpr int MLP_TRUNCS[] = {
    #include "src/ref/MLP_TRUNCS.txt"
};
constexpr int MLP_TRUNC_UG  = MLP_TRUNCS[0];
constexpr int MLP_TRUNC_MUL = MLP_TRUNCS[1];
constexpr int MLP_TRUNC_D   = MLP_TRUNCS[2];

// CLS trunc
constexpr int CLS_TRUNC     = 9;

// trunc base
constexpr int LLAMA_TRUNC_BASE = const_min(
    MHA_TRUNC_QK,
    MHA_TRUNC_V,
    MHA_TRUNC_O,
    MLP_TRUNC_UG,
    MLP_TRUNC_D,
    CLS_TRUNC
);

// constants derived from C++ statistics
constexpr int MASK_NEG_INF = -(1 << 12);

// // data types, reference to LLM project's output
// constexpr int DW_X              = 24;
// constexpr int DW_X_POW2SUM      = 47;
// constexpr int DW_X_RSQRT        = 18;
// constexpr int DW_LNW            = 17;   // MHA&MLP: 10,    HEAD: 11
// constexpr int DW_XLN            = 18;
// constexpr int DW_QKV            = 24;
// constexpr int DW_QKV_TRUNC      = 18;   // 事实上V是15，为了统一位宽使用16
// constexpr int DW_POS            = 12;   // maximum position sequence length
// constexpr int DW_FREQS          = 20;
// constexpr int DW_COS_SIN        = 14;
// constexpr int DW_ROT            = 15;
// constexpr int DW_R              = 27;
// constexpr int DW_R_TRUNC        = 15;
// constexpr int DW_R_MASKED       = 15;   // the mask use -(1<<14)
// constexpr int DW_EXP            = 9;
// constexpr int DW_EXP_SUM        = 14;
// constexpr int DW_RECIP          = 18;
// constexpr int DW_SOFTMAX        = 14;
// constexpr int DW_A              = 30;
// constexpr int DW_A_TRUNC        = 18;
// constexpr int DW_O              = 28;
// constexpr int DW_O_TRUNC        = 17;   // O_RES is equal to X
// constexpr int DW_XUG            = 27;
// constexpr int DW_XUG_TRUNC      = 19;   // SILU is the same with XG_TRUNC
// constexpr int DW_SILU           = 18;
// constexpr int DW_XM_TRUNC       = 22;
// constexpr int DW_XD             = 33;
// constexpr int DW_XD_TRUNC       = 24;   // calculated, 31 - 8 = 23
// constexpr int DW_CLS            = 20;
// constexpr int DW_CLS_TRUNC      = 15;   // calculated, 27 - 8 = 19

// data types, reference to LLM project's output
//* expand width to avoid future overflowing
constexpr int DW_X              = 26;
constexpr int DW_X_POW2SUM      = 49;
constexpr int DW_X_RSQRT        = 20;
constexpr int DW_LNW            = 19;   // MHA&MLP: 10,    HEAD: 11
constexpr int DW_XLN            = 20;
constexpr int DW_QKV            = 26;
constexpr int DW_QKV_TRUNC      = 20;   
constexpr int DW_BIAS           = 17;
constexpr int DW_POS            = 12;   // maximum position sequence length
constexpr int DW_FREQS          = 22;
constexpr int DW_COS_SIN        = 16;
constexpr int DW_ROT            = 17;
constexpr int DW_R              = 29;
constexpr int DW_R_TRUNC        = 17;
constexpr int DW_R_MASKED       = 17;   // the mask use -(1<<14)
constexpr int DW_EXP            = 11;
constexpr int DW_EXP_SUM        = 16;
constexpr int DW_RECIP          = 20;
constexpr int DW_SOFTMAX        = 16;
constexpr int DW_A              = 32;
constexpr int DW_A_TRUNC        = 20;
constexpr int DW_O              = 30;
constexpr int DW_O_TRUNC        = 19;   // O_RES is equal to X
constexpr int DW_XUG            = 29;
constexpr int DW_XUG_TRUNC      = 21;   // SILU is the same with XG_TRUNC
constexpr int DW_SILU           = 20;
constexpr int DW_XM_TRUNC       = 24;
constexpr int DW_XD             = 35;
constexpr int DW_XD_TRUNC       = 26;   // calculated, 31 - 8 = 23
constexpr int DW_CLS            = 22;
constexpr int DW_CLS_TRUNC      = 17;   // calculated, 27 - 8 = 19


constexpr int DW_WS             = 3;
constexpr int DW_AS             = 4;    // quantization scale bitwidth

// derived data types
constexpr int DW_GEMM           = DW_AQ + DW_WQ + log2ce(LLAMA_G);
constexpr int DW_GEMM_ACC       = const_max(DW_QKV, DW_O, DW_XUG, DW_XD);
constexpr int DW_GEMM_TRUNC     = DW_GEMM_ACC - LLAMA_TRUNC_BASE;
// base truncation:
//      QKV:    26-8 = 18
//      O:      29-8 = 21
//      UG:     27-8 = 19
//      D:      31-8 = 23
//      HEAD:   27-8 = 19

// define data types
typedef ap_int<DW_X             > X_T;
typedef ap_int<DW_X_POW2SUM     > X_POW2SUM_T;
typedef ap_int<DW_X_RSQRT       > X_RSQRT_T;
typedef ap_int<DW_LNW           > LNW_T;
typedef ap_int<DW_XLN           > XLN_T;
typedef ap_int<DW_QKV           > QKV_T;
typedef ap_int<DW_QKV_TRUNC     > QKV_TRUNC_T;
typedef ap_int<DW_BIAS          > BIAS_T;
// typedef ap_int<DW_POS           > POS_T;
typedef ap_int<DW_FREQS         > FREQS_T;
typedef ap_int<DW_COS_SIN       > COS_SIN_T;
typedef ap_int<DW_ROT           > ROT_T;
typedef ap_int<DW_R             > R_T;
typedef ap_int<DW_R_TRUNC       > R_TRUNC_T;
typedef ap_int<DW_R_MASKED      > R_MASKED_T;
typedef ap_int<DW_EXP           > EXP_T;
typedef ap_int<DW_EXP_SUM       > EXP_SUM_T;
typedef ap_int<DW_RECIP         > RECIP_T;
typedef ap_int<DW_SOFTMAX       > SOFTMAX_T;
typedef ap_int<DW_A             > A_T;
typedef ap_int<DW_A_TRUNC       > A_TRUNC_T;
typedef ap_int<DW_O             > O_T;
typedef ap_int<DW_O_TRUNC       > O_TRUNC_T;
typedef ap_int<DW_XUG           > XUG_T;
typedef ap_int<DW_XUG_TRUNC     > XUG_TRUNC_T;
typedef ap_int<DW_SILU          > SILU_T;
typedef ap_int<DW_XM_TRUNC      > XM_T;
typedef ap_int<DW_XD            > XD_T;
typedef ap_int<DW_XD_TRUNC      > XD_TRUNC_T;
typedef ap_int<DW_CLS           > CLS_T;
typedef ap_int<DW_CLS_TRUNC     > CLS_TRUNC_T;
typedef ap_int<DW_GEMM_TRUNC    > GEMM_TRUNC_T;

typedef ap_int <DW_AQ           > AQ_T;
typedef ap_uint<DW_AS       > AS_T;
typedef ap_int <DW_WQ           > WQ_T;
typedef ap_uint<DW_WS       > WS_T;


// simulation L
constexpr int SIM_L = 24;

// simulation path
const string BINARIES_PATH="C:/projects/AAAProjects/PROJ17_LLM_QWEN/LLM_CPP/cmake-build-debug/binaries/decoder_";
const string CONDENSE_PATH="C:/projects/AAAProjects/PROJ17_LLM_QWEN/LLM_CPP/cmake-build-debug/condense/decoder_";

#endif