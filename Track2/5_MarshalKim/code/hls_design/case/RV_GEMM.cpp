#include "src/common.h"
#include "src/rv_gemm.h"
#include "src/utils.h"

// 设计的consideration：见src/rv_gemm.h

// simulation hyperparameters
constexpr int L         = SIM_L;
constexpr int T_LOAD    = 128;          
constexpr int S_LOAD    = 128;          
constexpr int POS       = 96;           // a random position

// model hyperparameters
constexpr int H         = LLAMA_H;
constexpr int G         = LLAMA_G;
constexpr int HC        = LLAMA_HC;

// design hyperparameters
constexpr int T         = 8;           
constexpr int S         = 192;          // reduced context length
constexpr int TP        = 1;          
constexpr int CP        = G;         
constexpr int SP        = G;

// derived hyperparameters
constexpr int TT        = T      / TP;
constexpr int ST        = S      / SP;
constexpr int TST       = T      / SP;
constexpr int HCT       = HC     / CP;
constexpr int ST_LOAD   = S_LOAD / SP;   // for transposed loading

// dtypes
typedef ap_int  <DW_QKV_TRUNC> w_t;      // not quantized V matrix data type
typedef ap_int  <DW_AQ       > aq_t;     
typedef ap_uint <DW_AS   > as_t;
typedef ap_int  <DW_A        > acc_t;   
typedef ap_int  <DW_A_TRUNC  > of_t;  

// other hyperparameters
constexpr int TRUNC         = MHA_TRUNC_A;

// instanciate the gemm inst
RV_GEMM     <aq_t, as_t, w_t, acc_t, of_t, TRUNC, H, T, TP, S, SP, HC, CP>  rv_gemm_inst;
// inplace output quantization
QUANTIZER   <of_t, aq_t, as_t, H, T, 1, HC, CP, G>  quantizer_inst;
// quantizer adapters
Adapter     <of_t,   H*TT*HCT, 1, TP*CP, TP*CP,    CP> adapter_1;
Adapter     <aq_t,   H*TT*HCT, 1, TP*CP,    CP, TP*CP> adapter_2;
Adapter     <as_t,   H*TT*HCT, 1, TP   ,    1 , TP   > adapter_3;

void top(
    // scalar inputs
    int l_begin,
    int l_close,
    int pos_id,
    // streams
    hls::stream<hls::vector<aq_t,      TP*SP > >& rq_stream,
    hls::stream<hls::vector<as_t,      TP    > >& rs_stream,
    hls::stream<hls::vector<w_t,          CP > >& v_stream,     // V is not quantized, and is GEMM unpacked
    hls::stream<hls::vector<aq_t,         SP > >& vq_cache_i_stream,
    hls::stream<hls::vector<as_t,         1  > >& vs_cache_i_stream,
    hls::stream<hls::vector<aq_t,         SP > >& vq_cache_o_stream,
    hls::stream<hls::vector<as_t,         1  > >& vs_cache_o_stream,
    hls::stream<hls::vector<aq_t,      TP*CP > >& aq_stream,
    hls::stream<hls::vector<as_t,      TP    > >& as_stream
){
    #pragma HLS interface ap_ctrl_chain port=return

    // set interface
    #pragma HLS interface axis port=rq_stream
    #pragma HLS interface axis port=rs_stream
    #pragma HLS interface axis port=v_stream
    #pragma HLS interface axis port=vq_cache_i_stream
    #pragma HLS interface axis port=vs_cache_i_stream
    #pragma HLS interface axis port=vq_cache_o_stream
    #pragma HLS interface axis port=vs_cache_o_stream
    #pragma HLS interface axis port=aq_stream
    #pragma HLS interface axis port=as_stream

    // set aggregate pragma
    #pragma HLS aggregate variable=rq_stream            compact=bit
    #pragma HLS aggregate variable=rs_stream            compact=bit
    #pragma HLS aggregate variable=v_stream             compact=bit
    #pragma HLS aggregate variable=vq_cache_i_stream    compact=bit
    #pragma HLS aggregate variable=vs_cache_i_stream    compact=bit
    #pragma HLS aggregate variable=vq_cache_o_stream    compact=bit
    #pragma HLS aggregate variable=vs_cache_o_stream    compact=bit
    #pragma HLS aggregate variable=aq_stream            compact=bit
    #pragma HLS aggregate variable=as_stream            compact=bit

    // declare internal streams
    hls::stream<hls::vector<of_t, TP*CP> > a_stream        ("a_stream"      );
    hls::stream<hls::vector<of_t,    CP> > a_stream_adpt   ("a_stream_adpt" );
    hls::stream<hls::vector<aq_t,    CP> > aq_stream_adpt  ("aq_stream_adpt");
    hls::stream<hls::vector<as_t,    1 > > as_stream_adpt  ("as_stream_adpt");

    // call funcs
    for(int l=l_begin; l<l_close && l<LLAMA_L; ++l){
        #pragma HLS dataflow
        
        rv_gemm_inst  .do_rv_gemm (
            pos_id,  
            rq_stream, 
            rs_stream, 
            v_stream, 
            vq_cache_i_stream, 
            vs_cache_i_stream, 
            vq_cache_o_stream, 
            vs_cache_o_stream, 
            a_stream
        );

        adapter_1     .do_adapt   (         a_stream,               a_stream_adpt                                                                               );
        quantizer_inst.do_quant   (         a_stream_adpt,          aq_stream_adpt,         as_stream_adpt                                                      );
        adapter_2     .do_adapt   (         aq_stream_adpt,         aq_stream                                                                                   );
        adapter_3     .do_adapt   (         as_stream_adpt,         as_stream                                                                                   );
    }
}


// declare the ref data here
int8_t  REF_R_Q                 [H*T*S ];
int8_t  REF_R_S                 [H*T*ST];
int64_t REF_V                   [H*T*HC];
int8_t  REF_VQ                  [H*HC*T];
int8_t  REF_VS                  [H*HC*TST];
// declare V cache
int8_t  REF_VQ_CACHE            [H*HC*S ];
int8_t  REF_VS_CACHE            [H*HC*ST];
// declare head interleaved data
int8_t  REF_A_Q                 [H*T*HC ];
int8_t  REF_A_S                 [H*T*HCT];
// declare dut data
int8_t  DUT_VQ                  [H*HC*T];
int8_t  DUT_VS                  [H*HC*TST];
int8_t  DUT_A_Q                 [H*T*HC ];
int8_t  DUT_A_S                 [H*T*HCT];
// declare condensed input
int8_t  REF_CONDENSED_MHA_R_Q   [H*T*S  ];
int8_t  REF_CONDENSED_MHA_R_S   [H*T*ST ];
int64_t REF_CONDENSED_MHA_V     [H*T*HC ];


void test_layer(int l){
    // read input data and reference data
    string file_path = BINARIES_PATH + to_string(l);
    string save_path = CONDENSE_PATH + to_string(l);
    {
        // read input refs
        auto R_Q  = read_tensor<int8_t >(file_path + "/MHA_R_Q.bin"          );
        auto R_S  = read_tensor<int8_t >(file_path + "/MHA_R_S.bin"          );
        auto V    = read_tensor<int64_t>(file_path + "/MHA_V_SPLIT_HEADS.bin");
        auto VT_Q = read_tensor<int8_t >(file_path + "/MHA_VT_Q.bin"         );
        auto VT_S = read_tensor<int8_t >(file_path + "/MHA_VT_S.bin"         );
        auto A_Q  = read_tensor<int8_t >(file_path + "/MHA_A_Q.bin"          );
        auto A_S  = read_tensor<int8_t >(file_path + "/MHA_A_S.bin"          );
        //          <dtype >    TENSOR, ARRAY,          H_LOAD, H,      T_LOAD,     T_START,    T,      C_LOAD,    C
        tensor2array<int8_t>(   R_Q,    REF_R_Q,        H,      H,      T_LOAD,     POS,        T,      S_LOAD,    S    );
        tensor2array<int8_t>(   R_S,    REF_R_S,        H,      H,      T_LOAD,     POS,        T,      ST_LOAD,   ST   );
        tensor2array<int64_t>(  V,      REF_V,          H,      H,      T_LOAD,     POS,        T,      HC,        HC   );
        // load as much V cache as possible
        tensor2array<int8_t>(   VT_Q,   REF_VQ_CACHE,   H,      H,      HC,                     HC,     S_LOAD,    S    );
        tensor2array<int8_t>(   VT_S,   REF_VS_CACHE,   H,      H,      HC,                     HC,     ST_LOAD,   ST   );
        // load result
        tensor2array<int8_t>(   A_Q,    REF_A_Q,        1,      1,      T_LOAD,     POS,        T,      H*HC,      H*HC  );
        tensor2array<int8_t>(   A_S,    REF_A_S,        1,      1,      T_LOAD,     POS,        T,      H*HCT,     H*HCT );

        // put VT_Q into REF_VQ, at POS offset
        for(int h=0; h<H; ++h){
            for(int hc=0; hc<HC; ++hc){
                for(int t=0; t<T; ++t){
                    REF_VQ[h*HC*T + hc*T + t]       = VT_Q[h*HC*S_LOAD  + hc*S_LOAD  + t  +POS];
                }
                for(int tst=0; tst<TST; ++tst){
                    REF_VS[h*HC*TST + hc*TST + tst] = VT_S[h*HC*ST_LOAD + hc*ST_LOAD + tst+POS/SP];
                }
            }
        }

        // overwrite the V cache after POS, because there's causation
        for(int h=0; h<H; ++h){
            for(int c=0; c<HC; ++c){
                for(int s=POS; s<S; ++s){
                    REF_VQ_CACHE[h*HC*S + c*S + s] = 0;
                }
                for(int st=POS/SP; st<ST; ++st){
                    REF_VS_CACHE[h*HC*ST + c*ST + st] = 0;
                }
            }
        }
    } // end of scope, release the memory

    //* split heads of A_Q and A_S
    split_heads<int8_t>(REF_A_Q, H, T, HC );
    split_heads<int8_t>(REF_A_S, H, T, HCT);

    //* create streams
    hls::stream<hls::vector<aq_t,    TP*SP> > rq_stream             ( "rq_stream"       );
    hls::stream<hls::vector<as_t,    TP   > > rs_stream             ( "rs_stream"       );
    hls::stream<hls::vector<w_t,     CP   > > v_stream              ( "v_stream"        );
    hls::stream<hls::vector<aq_t,       SP> > vq_cache_i_stream     ( "vq_cache_i_stream" );
    hls::stream<hls::vector<as_t,       1 > > vs_cache_i_stream     ( "vs_cache_i_stream" );
    hls::stream<hls::vector<aq_t,       SP> > vq_cache_o_stream     ( "vq_cache_o_stream" );
    hls::stream<hls::vector<as_t,       1 > > vs_cache_o_stream     ( "vs_cache_o_stream" );
    hls::stream<hls::vector<aq_t,    TP*CP> > aq_stream             ( "aq_stream"       );
    hls::stream<hls::vector<as_t,    TP   > > as_stream             ( "as_stream"       );

    //* use condensed input
    auto CONDENSED_MHA_R_Q = read_tensor<int8_t >(save_path + "/CONDENSED_SOFTMAX_QUANT_R_Q.bin");
    auto CONDENSED_MHA_R_S = read_tensor<int8_t >(save_path + "/CONDENSED_SOFTMAX_QUANT_R_S.bin");
    auto CONDENSED_MHA_V   = read_tensor<int64_t>(save_path + "/CONDENSED_DEMUX_V.bin"          );

    //* put the condensed input into the ref data array
    tensor2array<int8_t >(CONDENSED_MHA_R_Q, REF_CONDENSED_MHA_R_Q, 1, 1, 1, 1, H*T*S,  H*T*S);
    tensor2array<int8_t >(CONDENSED_MHA_R_S, REF_CONDENSED_MHA_R_S, 1, 1, 1, 1, H*T*ST, H*T*ST);
    tensor2array<int64_t>(CONDENSED_MHA_V,   REF_CONDENSED_MHA_V,   1, 1, 1, 1, H*T*HC, H*T*HC);

    //* put the condensed input into the stream
    array2stream<int8_t, aq_t, 1, 1, 1, 1, H*T*S,  TP*CP>(REF_CONDENSED_MHA_R_Q, rq_stream, "CONDENSED RQ", true);
    array2stream<int8_t, as_t, 1, 1, 1, 1, H*T*ST, TP   >(REF_CONDENSED_MHA_R_S, rs_stream, "CONDENSED RS", true);
    array2stream<int64_t,w_t,  1, 1, 1, 1, H*T*HC, CP   >(REF_CONDENSED_MHA_V,   v_stream,  "CONDENSED V",  true);

    //* put cache into stream
    array2stream<int8_t, aq_t, 1, H, HC, 1, S,  SP>(REF_VQ_CACHE, vq_cache_i_stream, "VQ Cache", true);
    array2stream<int8_t, as_t, 1, H, HC, 1, ST, 1 >(REF_VS_CACHE, vs_cache_i_stream, "VS Cache", true);

    //* save condensed cache
    save_condensed_tensor<int8_t, aq_t, H*HC*S,     SP>(save_path + "/CONDENSED_RV_GEMM_V_Q_CACHE.bin", vq_cache_i_stream);
    save_condensed_tensor<int8_t, as_t, H*HC*ST,    1 >(save_path + "/CONDENSED_RV_GEMM_V_S_CACHE.bin", vs_cache_i_stream);

    //* call top function
    top(l, l+1, POS, rq_stream, rs_stream, v_stream, vq_cache_i_stream, vs_cache_i_stream, vq_cache_o_stream, vs_cache_o_stream, aq_stream, as_stream);

    //* save condensed output
    save_condensed_tensor<int8_t, aq_t, H*T*HC,  CP   >(save_path + "/CONDENSED_RV_GEMM_V_Q.bin", vq_cache_o_stream);
    save_condensed_tensor<int8_t, as_t, H*T*HCT, 1    >(save_path + "/CONDENSED_RV_GEMM_V_S.bin", vs_cache_o_stream);
    save_condensed_tensor<int8_t, aq_t, H*T*HC,  TP*CP>(save_path + "/CONDENSED_RV_GEMM_A_Q.bin", aq_stream);
    save_condensed_tensor<int8_t, as_t, H*T*HCT, TP   >(save_path + "/CONDENSED_RV_GEMM_A_S.bin", as_stream);

    //* read output stream
    stream2array<   int8_t,    aq_t,                  H,      HC,     1,           T,      SP >(vq_cache_o_stream, DUT_VQ, "Output VQ", true);
    stream2array<   int8_t,    as_t,                  H,      HC,     1,           TST,    1  >(vs_cache_o_stream, DUT_VS, "Output VS", true);
    stream2array<   int8_t,    aq_t,                  H,      T,      TP,          HC,     CP >(aq_stream, DUT_A_Q, "Output A", true);
    stream2array<   int8_t,    as_t,                  H,      T,      TP,          HCT,    1  >(as_stream, DUT_A_S, "Output A", true);



    //* check stream size
    assert(rq_stream.size() == 0);
    assert(rs_stream.size() == 0);
    assert(v_stream .size() == 0);
    assert(aq_stream.size() == 0);
    assert(as_stream.size() == 0);


    //* compare the results
    compare<int8_t>(REF_VQ,      DUT_VQ,      H*T*HC,  "VQ", true);
    compare<int8_t>(REF_VS,      DUT_VS,      H*T*HCT, "VS", true);
    compare<int8_t>(REF_A_Q, DUT_A_Q, H*T*HC,  "A_Q", true);
    compare<int8_t>(REF_A_S, DUT_A_S, H*T*HCT, "A_S", true);
}

int main(){
    for(int l=0; l<L; ++l){
        test_layer(l);
        printf("Layer %d passed\n", l);
    }

    // test_layer(0);

    return 0;
}
