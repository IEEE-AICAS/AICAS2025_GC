#include "src/common.h"
#include "src/rope_qk.h"
#include "src/cordic.h"
#include "src/quantizer.h"
#include "src/utils.h"

// simulation hyperparameters
constexpr int L         = SIM_L;
constexpr int T_LOAD    = 128;          // saved seq length, since T is in the inner loop
constexpr int POS       = 96;           // a random position

// model hyperparameters
constexpr int H         = LLAMA_H;
constexpr int G         = LLAMA_G;
constexpr int C         = LLAMA_C;

// design hyperparameters
constexpr int T         = 8;
constexpr int GEMM_TP   = T;            // for GEMM TP, before unpack
constexpr int CP        = G;            // at least 2! because rotation requires 2 elements

// derived hyperparameters
constexpr int NUM_QK    = 2*T*C;

CORDIC      <                      H, T,   1,       C, CP/2 > cordic_inst;
ROPE_QK     <                      H, T,   GEMM_TP, C, CP   > rope_qk_inst;
QUANTIZER   <ROT_T, AQ_T, AS_T,    2, T,   1,       C, CP, G> quantizer_inst;

constexpr int HC        = rope_qk_inst.HC;
constexpr int HC2       = rope_qk_inst.HC2;
constexpr int CP2       = rope_qk_inst.CP2;
constexpr int GEMM_TT   = rope_qk_inst.GEMM_TT;
constexpr int HCT       = rope_qk_inst.HCT;

void top(
    // scalar inputs
    int l_begin,
    int l_close,
    int pos_id,
    // streams
    hls::stream<hls::vector<QKV_TRUNC_T,   CP> > &qk_stream,
    hls::stream<hls::vector<AQ_T,          CP> > &rot_q_stream,
    hls::stream<hls::vector<AS_T,          1 > > &rot_s_stream
){
    #pragma HLS interface ap_ctrl_chain port=return
    #pragma HLS interface axis port=qk_stream
    #pragma HLS interface axis port=rot_q_stream
    #pragma HLS interface axis port=rot_s_stream

    #pragma HLS aggregate variable=qk_stream    compact=bit
    #pragma HLS aggregate variable=rot_q_stream compact=bit
    #pragma HLS aggregate variable=rot_s_stream compact=bit

    for(int l=l_begin; l<l_close && l<LLAMA_L; ++l){
        #pragma HLS dataflow

        hls::stream<hls::vector<COS_SIN_T, 2*CP2> > cos_sin_stream("cos_sin_stream");
        hls::stream<hls::vector<ROT_T,       CP > > rot_stream    ("rot_stream"    );
        // #pragma HLS stream variable=cos_sin_stream type=fifo depth=1024
        // #pragma HLS stream variable=rot_stream     type=fifo depth=1024

        cordic_inst     .do_cordic(pos_id,       cos_sin_stream                     );
        rope_qk_inst    .do_rope  (qk_stream,    cos_sin_stream,    rot_stream      );
        quantizer_inst  .do_quant (rot_stream,   rot_q_stream,      rot_s_stream    );
    }
}

// reference data
int64_t REF_QK      [H * 2 * T * HC ];
int8_t  REF_QKROT_Q [H * 2 * T * HC ];
int8_t  REF_QKROT_S [H * 2 * T * HCT];
// dut data
int8_t  DUT_QKROT_Q [H * 2 * T * HC ];
int8_t  DUT_QKROT_S [H * 2 * T * HCT];
// condensed input replacement
int64_t REF_CONDENSED_QK      [H * 2 * T * HC];


void test_layer(int l){
    // read input data and reference data
    const string binaries_path = BINARIES_PATH + to_string(LLAMA_L);
    const string condense_path = CONDENSE_PATH + to_string(LLAMA_L);
    string file_path = BINARIES_PATH + to_string(l);
    string save_path = CONDENSE_PATH + to_string(l);
    {
        // read refs
        auto REF_Q_TENSOR       = read_tensor<int64_t>(file_path + "/MHA_Q_SPLIT_HEADS.bin");
        auto REF_K_TENSOR       = read_tensor<int64_t>(file_path + "/MHA_K_SPLIT_HEADS.bin");
        // read output refs
        auto REF_QROT_Q_TENSOR  = read_tensor<int8_t> (file_path + "/MHA_Q_Q.bin");
        auto REF_KROT_Q_TENSOR  = read_tensor<int8_t> (file_path + "/MHA_K_Q.bin");
        auto REF_QROT_S_TENSOR  = read_tensor<int8_t> (file_path + "/MHA_Q_S.bin");
        auto REF_KROT_S_TENSOR  = read_tensor<int8_t> (file_path + "/MHA_K_S.bin");
        // check tensor size
        assert(REF_Q_TENSOR     .size() == H*T_LOAD*HC );
        assert(REF_K_TENSOR     .size() == H*T_LOAD*HC );
        assert(REF_QROT_Q_TENSOR.size() == H*T_LOAD*HC );
        assert(REF_KROT_Q_TENSOR.size() == H*T_LOAD*HC );
        assert(REF_QROT_S_TENSOR.size() == H*T_LOAD*HCT);
        assert(REF_KROT_S_TENSOR.size() == H*T_LOAD*HCT);
        // apply token position offset, without using tensor2array
        for(int h=0; h<H; ++h){
            for(int qk=0; qk<2; ++qk){
                for(int t=0; t<T; ++t){
                    for(int hc=0; hc<HC; ++hc){
                        REF_QK     [h*2*T*HC + qk*T*HC + t*HC + hc] = (qk == 0 ? REF_Q_TENSOR      : REF_K_TENSOR     )[h*T_LOAD*HC + (t+POS)*HC + hc];
                        REF_QKROT_Q[h*2*T*HC + qk*T*HC + t*HC + hc] = (qk == 0 ? REF_QROT_Q_TENSOR : REF_KROT_Q_TENSOR)[h*T_LOAD*HC + (t+POS)*HC + hc];
                    }
                }
            }
        }
        // put results into the reference array
        for(int h=0; h<H; ++h){
            for(int qk=0; qk<2; ++qk){
                for(int t=0; t<T; ++t){
                    for(int hct=0; hct<HCT; ++hct){
                        REF_QKROT_S[h*2*T*HCT + qk*T*HCT + t*HCT + hct] = (qk == 0 ? REF_QROT_S_TENSOR : REF_KROT_S_TENSOR)[h*T_LOAD*HCT + (t+POS)*HCT + hct];
                    }
                }
            }
        }
    } // end of scope, release the memory


    //* read condensed input tensor
    auto CONDENSED_QK_TENSOR = read_tensor<int64_t>(save_path + "/CONDENSED_DEMUX_QK.bin");


    //* check tensor size
    assert(CONDENSED_QK_TENSOR.size() == NUM_QK);


    //* put results into the reference array
    tensor2array<int64_t>(CONDENSED_QK_TENSOR, REF_CONDENSED_QK, 1, 1, 1, 1, NUM_QK, NUM_QK);


    //* create streams
    hls::stream<hls::vector<QKV_TRUNC_T, CP > > qk_stream     ("qk_stream"   );
    hls::stream<hls::vector<AQ_T,        CP > > rot_q_stream  ("rot_q_stream");
    hls::stream<hls::vector<AS_T,        1  > > rot_s_stream  ("rot_s_stream");
    array2stream<int64_t, QKV_TRUNC_T,  1,      1,      1,      1,      NUM_QK,     CP>(REF_CONDENSED_QK, qk_stream, "QK", true);


    //* call top function
    top(l, l+1, POS, qk_stream, rot_q_stream, rot_s_stream);


    //* save condensed output
    save_condensed_tensor<int8_t, AQ_T, NUM_QK  , CP>(save_path + "/CONDENSED_ROPE_QK_QUANT_ROT_Q.bin", rot_q_stream);
    save_condensed_tensor<int8_t, AS_T, NUM_QK/G, 1 >(save_path + "/CONDENSED_ROPE_QK_QUANT_ROT_S.bin", rot_s_stream);


    //* read output stream
    stream2array_unpack<int8_t, AQ_T,               H*2, T, GEMM_TP, HC,  CP>(rot_q_stream, DUT_QKROT_Q, "QKROT_Q", true);
    stream2array_unpack<int8_t, AS_T,               H*2, T, GEMM_TP, HCT, 1 >(rot_s_stream, DUT_QKROT_S, "QKROT_S", true);


    //* check
    compare<int8_t>(REF_QKROT_Q, DUT_QKROT_Q, H*2*T*HC, "QKROT_Q");
}

int main(){

    for(int l=0; l<L; ++l){
        test_layer(l);
        printf("Layer %d passed\n", l);
    }

    // test_layer(0);

    return 0;
}

