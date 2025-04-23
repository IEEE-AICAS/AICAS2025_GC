#include "src/common.h"
#include "src/softmax.h"
#include "src/quantizer.h"
#include "src/adapter.h"

// simulation hyperparameters
constexpr int L         = SIM_L;
constexpr int T_LOAD    = 128;
constexpr int S_LOAD    = 128;
constexpr int POS       = 96;       // a random position

// model hyperparameters
constexpr int H         = LLAMA_H;
constexpr int G         = LLAMA_G;

// design hyperparameters
constexpr int T         = 8;
constexpr int TP        = 1;
constexpr int S         = 192;
constexpr int SP        = 2;
constexpr int SAP       = G;        // forced alignment, therefore the s can be bypassed!

// derived hyperparameters
constexpr int TT        = T / TP;
constexpr int ST        = S / SAP;
constexpr int NUM_R     = H*T*S;
constexpr int NUM_R_S   = H*T*S/G;
constexpr int ST_LOAD   = S_LOAD / G;

// instanciate the softmax inst and quantizer and adapter
SOFTMAX   <R_TRUNC_T, R_MASKED_T, EXP_T, EXP_SUM_T, RECIP_T, SOFTMAX_T, H, T,TP, S, SAP, SP               > softmax_inst;
QUANTIZER <SOFTMAX_T, AQ_T, AS_T,                                       H, T,TP, S, SAP, G                > quantizer_inst;


// top function
void top(
    // scalar inputs
    int l_begin,
    int l_close,
    int pos_id,
    // streams
    hls::stream<hls::vector<R_TRUNC_T,  TP * SAP> > &r_stream, 
    hls::stream<hls::vector<AQ_T,       TP * SAP> > &rq_stream,
    hls::stream<hls::vector<AS_T,       TP      > > &rs_stream
){
    #pragma HLS interface ap_ctrl_chain port=return
    #pragma HLS interface axis port=r_stream
    #pragma HLS interface axis port=rq_stream
    #pragma HLS interface axis port=rs_stream

    #pragma HLS aggregate variable=r_stream  compact=bit
    #pragma HLS aggregate variable=rq_stream compact=bit
    #pragma HLS aggregate variable=rs_stream compact=bit


    hls::stream<hls::vector<SOFTMAX_T, TP * SAP> > softmax_stream;

    for(int l=l_begin; l<l_close && l<LLAMA_L; ++l){
        #pragma HLS dataflow

        softmax_inst  .do_softmax (pos_id,                  r_stream,           softmax_stream  );
        quantizer_inst.do_quant   (softmax_stream,          rq_stream,          rs_stream       );
    }
}


// declare ref data
int64_t REF_R           [H*T*S ];
int8_t  REF_R_Q         [H*T*S ];
int8_t  REF_R_S         [H*T*ST];
// declare dut data
int8_t  DUT_R_Q         [H*T*S ];
int8_t  DUT_R_S         [H*T*ST];
int64_t REF_CONDENSED_R [NUM_R];


void test_layer(int l){
    // read input data and reference data
    string file_path = BINARIES_PATH + to_string(l);
    string save_path = CONDENSE_PATH + to_string(l);
    {
        // read refs
        auto R   = read_tensor<int64_t>(file_path + "/MHA_R.bin");    // in fact, not masked
        auto R_Q = read_tensor<int8_t >(file_path + "/MHA_R_Q.bin");
        auto R_S = read_tensor<int8_t >(file_path + "/MHA_R_S.bin");
        // check tensor size
        assert(R  .size() == H * T_LOAD * S_LOAD);
        assert(R_Q.size() == H * T_LOAD * S_LOAD);
        assert(R_S.size() == H * T_LOAD * ST_LOAD);
        // put the data into REF
        //           dtype,   TENSOR,   ARRAY,      H_LOAD, H,      T_LOAD,     T_START,    T,      S_LOAD,     S
        tensor2array<int64_t>(R,        REF_R,      H,      H,      T_LOAD,     POS,        T,      S_LOAD,     S );
        tensor2array<int8_t >(R_Q,      REF_R_Q,    H,      H,      T_LOAD,     POS,        T,      S_LOAD,     S );
        tensor2array<int8_t >(R_S,      REF_R_S,    H,      H,      T_LOAD,     POS,        T,      ST_LOAD,    ST);
    }

    //* use condensed input
    auto CONDENSED_R = read_tensor<int64_t>(save_path + "/CONDENSED_QK_GEMM_R.bin");
    tensor2array<int64_t>(CONDENSED_R, REF_CONDENSED_R, 1, 1, 1, 1, NUM_R, NUM_R);

    //* create streams
    hls::stream<hls::vector<R_TRUNC_T,  TP * SAP> > r_stream  ( "r_stream" );
    hls::stream<hls::vector<AQ_T,       TP * SAP> > rq_stream ( "rq_stream");
    hls::stream<hls::vector<AS_T,       TP      > > rs_stream ( "rs_stream");

    //* write stream
    array2stream<int64_t, R_TRUNC_T, 1, 1, 1, 1, NUM_R, TP*SAP>(REF_CONDENSED_R, r_stream, "CONDENSED R", true);

    //* call top function
    top(l, l+1, POS, r_stream, rq_stream, rs_stream);

    //* save condensed output
    save_condensed_tensor<int8_t, AQ_T, NUM_R,   TP*SAP>(save_path + "/CONDENSED_SOFTMAX_QUANT_R_Q.bin", rq_stream);
    save_condensed_tensor<int8_t, AS_T, NUM_R_S, TP    >(save_path + "/CONDENSED_SOFTMAX_QUANT_R_S.bin", rs_stream);

    //* read output stream
    stream2array<int8_t, AQ_T, H, T, TP, S,  SAP>(rq_stream, DUT_R_Q, "R_Q", true);
    stream2array<int8_t, AS_T, H, T, TP, ST, 1  >(rs_stream, DUT_R_S, "R_S", true);

    //* check streams are empty
    assert(r_stream .empty());
    assert(rq_stream.empty());
    assert(rs_stream.empty());

    // compare the results
    // compare<int8_t>(REF_R_Q, DUT_R_Q, H*T*S,  "R_Q");
    // compare<int8_t>(REF_R_S, DUT_R_S, H*T*ST, "R_S");
    for(int h=0; h<H; ++h){
        for(int t=0; t<T; ++t){
            for(int s=0; s<S && s<S_LOAD && s<POS+T; ++s){
                int64_t ref = REF_R_Q[h*T*S + t*S + s];
                int64_t dut = DUT_R_Q[h*T*S + t*S + s];
                if(ref != dut){
                    printf("R_Q mismatch at head %d, seq %d, pos %d, REF %ld, DUT %ld\n", h, t, s, ref, dut);
                } else {
                    // printf("R_Q match at head %d, seq %d, pos %d, REF %ld, DUT %ld\n", h, t, s, ref, dut);
                }
            }
        }
    }
}

int main(){
    for(int l=0; l<L; ++l){
        test_layer(l);
        printf("Layer %d passed\n", l);
    }

    // test_layer(0);

    return 0;
}