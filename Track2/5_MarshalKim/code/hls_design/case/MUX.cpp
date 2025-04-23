#include "src/common.h"
#include "src/utils.h"
#include "src/buffer.h"

// This module is the mux for the Llama, the previous module of GEMM
// it takes 3 channels: XLN, A, XM
// XLN is RMSNORM result
// A is the attention result
// XM is the MLP multiplication result

// pay attention to the data order:
// XLN is normal order,     4x8 parallelism
// A is normal order,       4x8 parallelism
// XM is unpacked order,    1x8 parallelism

// simulation hyperparameters
constexpr int L         = SIM_L;
constexpr int T_LOAD    = 128;  // saved seq length

// model hyperparameters
constexpr int H         = LLAMA_H;
constexpr int G         = LLAMA_G;
constexpr int C         = LLAMA_C;
constexpr int HC        = LLAMA_HC;
constexpr int CM        = LLAMA_CM;
constexpr int VOCAB     = LLAMA_VOCAB;

// design hyperparameters
constexpr int T         = 8;
constexpr int TP        = 1;    // this TP is input parallelism
constexpr int CP        = G;    // for both input parallelism and output parallelism

// derived hyperparameters
constexpr int TT        = T     / TP;
constexpr int CT        = C     / CP;
constexpr int CMT       = CM    / CP;
constexpr int HCT       = HC    / CP;
constexpr int VOCABT    = VOCAB / CP;

constexpr int NUM_X     = (3*CT*T*C + CT*T*C + 2*CMT*T*C + CT*T*CM);
constexpr int NUM_WS     = NUM_X / G;

// dtypes
typedef ap_int  <DW_AQ      > aq_t;
typedef ap_uint <DW_AS  > as_t;

// calculate repeat times for each buffer
constexpr int R_QKV     = H * 3 * HCT;
constexpr int R_O       = H * 1 * HCT;
constexpr int R_M       =     2 * CMT;
constexpr int R_D       =     1 * CT;
constexpr int R_CLS     =     1 * VOCABT;


// implement a MUX for GEMM, fetching from mha, a, m, xm, to main-gemm
void GEMM_MUX(
    bool run_cls,   // exclusive
    bool run_mha,
    bool run_mlp,
    // input streams
    hls::stream<hls::vector<aq_t, T*CP> > &xlnq_buffered_stream,
    hls::stream<hls::vector<as_t, T   > > &xlns_buffered_stream,
    hls::stream<hls::vector<aq_t, T*CP> > &aq_buffered_stream,
    hls::stream<hls::vector<as_t, T   > > &as_buffered_stream,
    hls::stream<hls::vector<aq_t, T*CP> > &xmq_buffered_stream,
    hls::stream<hls::vector<as_t, T   > > &xms_buffered_stream,
    // ouptut streams
    hls::stream<hls::vector<aq_t, T*CP> > &q_stream,
    hls::stream<hls::vector<as_t, T   > > &s_stream
){
    int N_MHA = R_QKV*CT + R_O*CT;
    int N_MLP = R_M*CT   + R_D*CMT;
    int N_CLS = R_CLS*CT;

    int N = run_cls ? N_CLS :
            run_mha ? N_MHA :
            run_mlp ? N_MLP : 0;

    for(int n=0; n<N; ++n){
        #pragma HLS pipeline II=1
        hls::vector<aq_t, T*CP> q_vec;
        hls::vector<as_t, T   > s_vec;
        if(run_cls){
            q_vec = xlnq_buffered_stream.read();
            s_vec = xlns_buffered_stream.read();
        } else if(run_mha && n < R_QKV*CT){
            q_vec = xlnq_buffered_stream.read();
            s_vec = xlns_buffered_stream.read();
        } else if(run_mha && n >= R_QKV*CT){
            q_vec = aq_buffered_stream.read();
            s_vec = as_buffered_stream.read();
        } else if(run_mlp && n < R_M*CT){
            q_vec = xlnq_buffered_stream.read();
            s_vec = xlns_buffered_stream.read();
        } else if(run_mlp && n >= R_M*CT){
            q_vec = xmq_buffered_stream.read();
            s_vec = xms_buffered_stream.read();
        }
        q_stream.write(q_vec);
        s_stream.write(s_vec);
    }
}


BUFFER<aq_t, 1, T, TP, C,   CP> xln_buffer_q;
BUFFER<as_t, 1, T, TP, CT,  1 > xln_buffer_s;

BUFFER<aq_t, H, T, TP, HC,  CP> a_buffer_q;
BUFFER<as_t, H, T, TP, HCT, 1 > a_buffer_s;

BUFFER<aq_t, 1, T, TP, CM,  CP> xm_buffer_q;
BUFFER<as_t, 1, T, TP, CMT, 1 > xm_buffer_s;


void top(
    // scalar input
    int l_begin,
    int l_close,
    // input streams
    hls::stream<hls::vector<aq_t, TP*CP> > &xlnq_stream,
    hls::stream<hls::vector<as_t, TP   > > &xlns_stream,
    hls::stream<hls::vector<aq_t, TP*CP> > &aq_stream,
    hls::stream<hls::vector<as_t, TP   > > &as_stream,
    hls::stream<hls::vector<aq_t,    CP> > &xmq_stream,
    hls::stream<hls::vector<as_t,    1 > > &xms_stream,
    // output streams
    hls::stream<hls::vector<aq_t, T* CP> > &q_stream,    // fully unrolled output parallelism
    hls::stream<hls::vector<as_t, T* 1 > > &s_stream
){
    #pragma HLS interface ap_ctrl_chain port=return
    // set interface
    #pragma HLS interface axis port=xlnq_stream
    #pragma HLS interface axis port=xlns_stream
    #pragma HLS interface axis port=aq_stream
    #pragma HLS interface axis port=as_stream
    #pragma HLS interface axis port=xmq_stream
    #pragma HLS interface axis port=xms_stream
    #pragma HLS interface axis port=q_stream
    #pragma HLS interface axis port=s_stream
    // set aggregate pragma
    #pragma HLS aggregate variable=xlnq_stream compact=bit
    #pragma HLS aggregate variable=xlns_stream compact=bit
    #pragma HLS aggregate variable=aq_stream   compact=bit
    #pragma HLS aggregate variable=as_stream   compact=bit
    #pragma HLS aggregate variable=xmq_stream  compact=bit
    #pragma HLS aggregate variable=xms_stream  compact=bit
    #pragma HLS aggregate variable=q_stream    compact=bit
    #pragma HLS aggregate variable=s_stream    compact=bit



    for(int l=l_begin; l<l_close; ++l){
        for(int mha_or_mlp=0; mha_or_mlp<2; ++mha_or_mlp){
            #pragma HLS dataflow

            bool run_cls = (l==LLAMA_L) && (mha_or_mlp==0);
            bool run_mha = (l!=LLAMA_L) && (mha_or_mlp==0);
            bool run_mlp = (l!=LLAMA_L) && (mha_or_mlp==1);

            int R_XLN = run_cls ? R_CLS :
                        run_mha ? R_QKV :
                        run_mlp ? R_M   : 0;

            // declare internal streams
            hls::stream<hls::vector<aq_t, T*CP> > xlnq_buffered_stream       ( "xlnq_buffered_stream"  );
            hls::stream<hls::vector<as_t, T   > > xlns_buffered_stream       ( "xlns_buffered_stream"  );
            hls::stream<hls::vector<aq_t, T*CP> > aq_buffered_stream         ( "aq_buffered_stream"    );
            hls::stream<hls::vector<as_t, T   > > as_buffered_stream         ( "as_buffered_stream"    );
            hls::stream<hls::vector<aq_t, T*CP> > xmq_buffered_stream        ( "xmq_buffered_stream"   );
            hls::stream<hls::vector<as_t, T   > > xms_buffered_stream        ( "xms_buffered_stream"   );

            // dataflow
            xln_buffer_q  .do_buffer          (run_mha || run_mlp || run_cls,   R_XLN,     xlnq_stream,        xlnq_buffered_stream    );
            xln_buffer_s  .do_buffer          (run_mha || run_mlp || run_cls,   R_XLN,     xlns_stream,        xlns_buffered_stream    );
            a_buffer_q    .do_buffer_merge    (run_mha,                         R_O,       aq_stream,          aq_buffered_stream      );
            a_buffer_s    .do_buffer_merge    (run_mha,                         R_O,       as_stream,          as_buffered_stream      );
            xm_buffer_q   .do_buffer_unpack   (run_mlp,                         R_D,       xmq_stream,         xmq_buffered_stream     );
            xm_buffer_s   .do_buffer_unpack   (run_mlp,                         R_D,       xms_stream,         xms_buffered_stream     );

            GEMM_MUX(
                // scalar input
                run_cls,
                run_mha,
                run_mlp,
                // streams
                xlnq_buffered_stream,
                xlns_buffered_stream,
                aq_buffered_stream,
                as_buffered_stream,
                xmq_buffered_stream,
                xms_buffered_stream,
                // output streams
                q_stream,
                s_stream
            );
        }
    }

}


// declare the ref data here
int8_t REF_MHA_XLN_Q    [T  *C  ];  // mha input
int8_t REF_MHA_XLN_S    [T  *CT ];  // mha input
int8_t REF_MLP_XLN_Q    [T  *C  ];  // UG input
int8_t REF_MLP_XLN_S    [T  *CT ];  // UG input

int8_t REF_XLN_Q        [T*2*C  ];  // XLN input
int8_t REF_XLN_S        [T*2*CT ];  // XLN input

int8_t REF_MHA_A_Q      [T  *C  ];  // A input
int8_t REF_MHA_A_S      [T  *CT ];  // A input

int8_t REF_MLP_XM_Q     [T  *CM ];  // D input
int8_t REF_MLP_XM_S     [T  *CMT];  // D input

// declare output ref data
int8_t REF_X_Q          [NUM_X];
int8_t REF_X_S          [NUM_WS];

// declare the dut output here
int8_t DUT_X_Q          [NUM_X];
int8_t DUT_X_S          [NUM_WS];

void test_layer(int l){
    //* copy from GEMM testbench, create i_stream_ref and s_stream_ref, as golden reference
    string file_path = BINARIES_PATH + to_string(l);
    string save_path = CONDENSE_PATH + to_string(l);
    {
        // use condensed input instead
        auto CONDENSED_XLN_Q    = read_tensor<int8_t>  (save_path + "/CONDENSED_XLN_Q.bin");
        auto CONDENSED_XLN_S    = read_tensor<int8_t>  (save_path + "/CONDENSED_XLN_S.bin");
        auto CONDENSED_A_Q      = read_tensor<int8_t>  (save_path + "/CONDENSED_RV_GEMM_A_Q.bin");
        auto CONDENSED_A_S      = read_tensor<int8_t>  (save_path + "/CONDENSED_RV_GEMM_A_S.bin");
        auto CONDENSED_XM_Q     = read_tensor<int8_t>  (save_path + "/CONDENSED_SILU_EM_QUANT_XM_Q.bin");
        auto CONDENSED_XM_S     = read_tensor<int8_t>  (save_path + "/CONDENSED_SILU_EM_QUANT_XM_S.bin");

        //            dtype,    tensor,             array,          H_LOAD,     H,      T_LOAD,     T,      C_LOAD,  C
        tensor2array<int8_t>(   CONDENSED_XLN_Q,    REF_XLN_Q,      1,          1,      1,          1,      2*T*C,   2*T*C  );
        tensor2array<int8_t>(   CONDENSED_XLN_S,    REF_XLN_S,      1,          1,      1,          1,      2*T*CT,  2*T*CT );
        tensor2array<int8_t>(   CONDENSED_A_Q,      REF_MHA_A_Q,    1,          1,      1,          1,        T*C,     T*C  );
        tensor2array<int8_t>(   CONDENSED_A_S,      REF_MHA_A_S,    1,          1,      1,          1,        T*CT,    T*CT );
        tensor2array<int8_t>(   CONDENSED_XM_Q,     REF_MLP_XM_Q,   1,          1,      1,          1,        T*CM,    T*CM );
        tensor2array<int8_t>(   CONDENSED_XM_S,     REF_MLP_XM_S,   1,          1,      1,          1,        T*CMT,   T*CMT);

        // read condensed output refs
        auto X_Q            = read_tensor<int8_t>  (save_path + "/CONDENSED_GEMM_X_Q.bin");
        auto X_S            = read_tensor<int8_t>  (save_path + "/CONDENSED_GEMM_X_S.bin");

        tensor2array<int8_t>(   X_Q,        REF_X_Q,        1,      1,      1,      1,      NUM_X,   NUM_X);
        tensor2array<int8_t>(   X_S,        REF_X_S,        1,      1,      1,      1,      NUM_WS,  NUM_WS);
    }

    // create streams
    hls::stream<hls::vector<aq_t, TP*CP> > xlnq_stream ( "xlnq_stream" );
    hls::stream<hls::vector<as_t, TP   > > xlns_stream ( "xlns_stream" );
    hls::stream<hls::vector<aq_t, TP*CP> > aq_stream   ( "aq_stream"   );
    hls::stream<hls::vector<as_t, TP   > > as_stream   ( "as_stream"   );
    hls::stream<hls::vector<aq_t,    CP> > xmq_stream  ( "xmq_stream"  );
    hls::stream<hls::vector<as_t,    1 > > xms_stream  ( "xms_stream"  );
    hls::stream<hls::vector<aq_t, T* CP> > q_stream    ( "q_stream"    );
    hls::stream<hls::vector<as_t, T    > > s_stream    ( "s_stream"    );

    // use condensed input
    array2stream<int8_t, aq_t, 1, 1, 1, 1,   2*T*C,    TP*CP>(REF_XLN_Q,     xlnq_stream,    "XLN Q", true);
    array2stream<int8_t, as_t, 1, 1, 1, 1,   2*T*CT,   TP   >(REF_XLN_S,     xlns_stream,    "XLN S", true);
    array2stream<int8_t, aq_t, 1, 1, 1, 1,     T*C,    TP*CP>(REF_MHA_A_Q,   aq_stream,      "A Q",   true);
    array2stream<int8_t, as_t, 1, 1, 1, 1,     T*CT,   TP   >(REF_MHA_A_S,   as_stream,      "A S",   true);
    array2stream<int8_t, aq_t, 1, 1, 1, 1,     T*CM,      CP>(REF_MLP_XM_Q,  xmq_stream,     "XM Q",  true);
    array2stream<int8_t, as_t, 1, 1, 1, 1,     T*CMT,     1 >(REF_MLP_XM_S,  xms_stream,     "XM S",  true);

    // call the top function
    top(l, l+1, xlnq_stream, xlns_stream, aq_stream, as_stream, xmq_stream, xms_stream, q_stream, s_stream);

    // check q stream size
    printf("q_stream size: %d\n", q_stream.size());
    printf("s_stream size: %d\n", s_stream.size());
    printf("NUM_X: %d\n", NUM_X);
    printf("NUM_WS: %d\n", NUM_WS);

    // read the output streams
    stream2array<int8_t, aq_t, 1, 1, 1, NUM_X,  T*CP>(q_stream, DUT_X_Q, "X Q", true);
    stream2array<int8_t, as_t, 1, 1, 1, NUM_WS, T   >(s_stream, DUT_X_S, "X S", true);

    // compare the output streams
    compare<int8_t>(REF_X_Q, DUT_X_Q, NUM_X,  "X Q", true);
    compare<int8_t>(REF_X_S, DUT_X_S, NUM_WS, "X S", true);
}


int main(){
    // read input data and reference data

    for(int l=0; l<L; ++l){
        test_layer(l);
        printf("Layer %d passed\n", l);
    }

    // test_layer(0);

}


