#include "src/common.h"
#include "src/rmsnorm.h"
#include "src/quantizer.h"

// 设计的Consideration：
// 1. 需要分TP计算
// 2. CLS有额外的LNW

// simulation hyperparameters
constexpr int L         = LLAMA_L;
constexpr int T_LOAD    = 128;         // saved seq length, since T is in the inner loop
constexpr int POS       = 96;          // random position

// model hyperparameters
constexpr int G         = LLAMA_G;
constexpr int C         = LLAMA_C;

// design hyperparameters
constexpr int T         = 8;
constexpr int TP        = 1;
constexpr int CP        = 8;

// instanciate the rmsnorm inst
RMSNORM  <LLAMA_L,              T, TP, C, CP   > rmsnorm_inst(RMSNORM_LNW, CLS_RMSNORM_LNW);
QUANTIZER<XLN_T, AQ_T, AS_T, 1, T, TP, C, CP, G> quantizer_inst;

// derived hyperparameters
constexpr int TT = rmsnorm_inst.TT;
constexpr int CT = rmsnorm_inst.CT;
constexpr int NUM_X     = 2*T*C;

// top function
void top(
    // input scalars
    int l_begin,
    int l_close,
    // streams
    hls::stream<hls::vector<X_T,  TP * CP> > &x_stream, 
    hls::stream<hls::vector<AQ_T, TP * CP> > &xlnq_stream,
    hls::stream<hls::vector<AS_T, TP     > > &xlns_stream
){
    #pragma HLS interface ap_ctrl_chain port=return
    #pragma HLS interface axis port=x_stream
    #pragma HLS interface axis port=xlnq_stream
    #pragma HLS interface axis port=xlns_stream

    #pragma HLS aggregate variable=x_stream    compact=bit
    #pragma HLS aggregate variable=xlnq_stream compact=bit
    #pragma HLS aggregate variable=xlns_stream compact=bit


    // declare streams
    hls::stream<hls::vector<XLN_T, TP * CP> > xln_stream;

    for(int l=l_begin; l<l_close; ++l){
        bool run_cls = l == LLAMA_L;
        for(int mha_or_mlp=0; mha_or_mlp<2-run_cls; ++mha_or_mlp){
            #pragma HLS dataflow
            rmsnorm_inst  .do_rmsnorm   (l,     mha_or_mlp,     x_stream,       xln_stream                 );
            quantizer_inst.do_quant     (                       xln_stream,     xlnq_stream,    xlns_stream);
        }
    }
}

// declare ref data
int64_t REF_X                   [2*T*C ];
int8_t  REF_XLN_Q               [2*T*C ];
int8_t  REF_XLN_S               [2*T*CT];
// declare dut data
int8_t  DUT_XLN_Q               [2*T*C ];
int8_t  DUT_XLN_S               [2*T*CT];


void test_layer(int l){
    bool run_cls = l == LLAMA_L;
    // l now is the order of decoder
    string file_path = BINARIES_PATH + to_string(l);
    string save_path = CONDENSE_PATH + to_string(l);
    {
        // read refs, both MHA and MLP
        auto MHA_XLN_Q              = read_tensor<int8_t >(file_path + "/MHA_XLN_Q.bin"        );
        auto MHA_XLN_S              = read_tensor<int8_t >(file_path + "/MHA_XLN_S.bin"        );
        auto MLP_XLN_Q              = read_tensor<int8_t >(file_path + "/MLP_XLN_Q.bin"        );
        auto MLP_XLN_S              = read_tensor<int8_t >(file_path + "/MLP_XLN_S.bin"        );
        //            dtype,  tensor,       array,              H_LOAD, H,      T_LOAD,     T_START,    T,      C_LOAD,   C
        tensor2array<int8_t >(MHA_XLN_Q,    REF_XLN_Q,          1,      1,      T_LOAD,     POS,        T,      C,        C );
        tensor2array<int8_t >(MHA_XLN_S,    REF_XLN_S,          1,      1,      T_LOAD,     POS,        T,      CT,       CT);
        tensor2array<int8_t >(MLP_XLN_Q,    REF_XLN_Q + T*C,    1,      1,      T_LOAD,     POS,        T,      C,        C );
        tensor2array<int8_t >(MLP_XLN_S,    REF_XLN_S + T*CT,   1,      1,      T_LOAD,     POS,        T,      CT,       CT);
    } 

    //* use condensed input
    auto CONDENSED_X            = read_tensor<int64_t>(save_path + "/CONDENSED_RESIDUAL_O.bin");
    tensor2array<int64_t>(CONDENSED_X, REF_X, 1, 1, 1, 1, NUM_X, NUM_X);

    //* create streams
    hls::stream<hls::vector<X_T,     TP * CP> > x_stream;
    hls::stream<hls::vector<AQ_T,    TP * CP> > xlnq_stream;
    hls::stream<hls::vector<AS_T,    TP     > > xlns_stream;


    //* write stream
    array2stream<int64_t, X_T, 1, 1, 1, 1, NUM_X, TP*CP>(REF_X, x_stream, "X", true);


    //* call top function
    top(l, l+1, x_stream, xlnq_stream, xlns_stream);


    //* save condensed output
    save_condensed_tensor<int8_t, AQ_T, 2*T*C,  TP*CP>(save_path + "/CONDENSED_XLN_Q.bin", xlnq_stream);
    save_condensed_tensor<int8_t, AS_T, 2*T*CT, TP   >(save_path + "/CONDENSED_XLN_S.bin", xlns_stream);


    //* read the output
    stream2array<int8_t, AQ_T, 2, T, TP, C,  CP>(xlnq_stream, DUT_XLN_Q, "XLN_Q", true);
    stream2array<int8_t, AS_T, 2, T, TP, CT, 1 >(xlns_stream, DUT_XLN_S, "XLN_S", true);
    assert(x_stream   .empty());
    assert(xlnq_stream.empty());
    assert(xlns_stream.empty());


    //* compare the results
    compare<int8_t >(REF_XLN_Q, DUT_XLN_Q, 2*T*C,  "XLN_Q");
    compare<int8_t >(REF_XLN_S, DUT_XLN_S, 2*T*CT, "XLN_S");
}


void test_cls(){
    // l now is the order of decoder
    string file_path = BINARIES_PATH + to_string(LLAMA_L);
    string save_path = CONDENSE_PATH + to_string(LLAMA_L);
    constexpr int NUM_CLS_X = T*C;
    {
        // read refs, both MHA and MLP
        auto CLS_X      = read_tensor<int64_t>(file_path + "/CLS_X.bin"            );
        auto CLS_XLN_Q  = read_tensor<int8_t >(file_path + "/CLS_XLN_Q.bin"        );
        auto CLS_XLN_S  = read_tensor<int8_t >(file_path + "/CLS_XLN_S.bin"        );
        tensor2array<int64_t>(CLS_X,        REF_X,              1, 1, T_LOAD, T, C, C );
        tensor2array<int8_t >(CLS_XLN_Q,    REF_XLN_Q,          1, 1, T_LOAD, T, C, C );
        tensor2array<int8_t >(CLS_XLN_S,    REF_XLN_S,          1, 1, T_LOAD, T, CT,CT);
    } 

    //* create streams
    hls::stream<hls::vector<X_T,     TP * CP> > x_stream;
    hls::stream<hls::vector<AQ_T,    TP * CP> > xlnq_stream;
    hls::stream<hls::vector<AS_T,    TP     > > xlns_stream;

    //* write stream
    array2stream<int64_t, X_T, 1, 1, T, TP, C, CP>(REF_X, x_stream, "X", true);
    
    //* call top function
    top(LLAMA_L, LLAMA_L+1, x_stream, xlnq_stream, xlns_stream);

    //* save condensed output
    save_condensed_tensor<int8_t, AQ_T, T*C,  TP*CP>(save_path + "/CONDENSED_XLN_Q.bin", xlnq_stream);
    save_condensed_tensor<int8_t, AS_T, T*CT, TP   >(save_path + "/CONDENSED_XLN_S.bin", xlns_stream);

    //* read the output
    stream2array<int8_t, AQ_T, 1, T, TP, C,  CP>(xlnq_stream, DUT_XLN_Q, "XLN_Q", true);
    stream2array<int8_t, AS_T, 1, T, TP, CT, 1 >(xlns_stream, DUT_XLN_S, "XLN_S", true);

    //* compare the results
    compare<int8_t >(REF_XLN_Q, DUT_XLN_Q, T*C,  "XLN_Q");
    compare<int8_t >(REF_XLN_S, DUT_XLN_S, T*CT, "XLN_S");
}

int main(){
    for(int l=0; l<L; ++l){
        test_layer(l);
        printf("Test %d passed\n", l);
    }

    test_cls();

    // test_layer(0);

    return 0;
}