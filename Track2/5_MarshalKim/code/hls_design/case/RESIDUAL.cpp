#include "src/common.h"
#include "src/utils.h"

// 设计的consideration：
// 1. 并行度转换，res_i_stream是unpack形式的（来自于gemm），而res_o_stream是pack形式的（去到rmsnorm）
// 2. 多层设计数据流，residual不参与cls，而是在判断如果整个设计需要跑cls，则在最后一个decoder的输出不是去往y_stream，而是再次去往res_o_stream
// 3. 预处理与后处理：预处理是从M_AXI获取到第一层输入写入到buffer，后处理是在最后一层将buffer写入到y_stream
// 4. 循环主体：每一层的主体是两次residual，一次MHA，一次MLP，每一次循环过程：
//     1) 将buffer写入到res_o_stream，直接输出
//     2) 从res_i_stream读取数据，inplace加到buffer上

// simulation hyperparameters
constexpr int L         = LLAMA_L;
constexpr int T_LOAD    = 128;  // saved seq length
constexpr int POS       = 96;   // random position

// model hyperparameters
constexpr int C         = LLAMA_C;
constexpr int G         = LLAMA_G;

// design hyperparameters
constexpr int T         = 8;
constexpr int TP        = 1;

// derived hyperparameters
constexpr int TT        = T / TP;
constexpr int CP        = G;
constexpr int CT        = C / CP;
constexpr int NUM_X     = T*C;
constexpr int NUM_OD    = T*C;

// dtypes: X_T
typedef X_T X_T;     // largest accumulated value

void top(
    // scalar inputs
    int     l_begin,
    int     l_close,
    // streams
    hls::stream<hls::vector<X_T, TP*CP> >& x_stream,
    hls::stream<hls::vector<X_T,    CP> >& res_i_stream,
    hls::stream<hls::vector<X_T, TP*CP> >& res_o_stream,
    hls::stream<hls::vector<X_T, TP*CP> >& y_stream
){
    #pragma HLS interface ap_ctrl_chain port=return
    // set interface
    #pragma HLS interface axis port=x_stream
    #pragma HLS interface axis port=res_i_stream
    #pragma HLS interface axis port=res_o_stream
    #pragma HLS interface axis port=y_stream
    // set aggregate pragma
    #pragma HLS aggregate variable=x_stream         compact=bit
    #pragma HLS aggregate variable=res_i_stream     compact=bit
    #pragma HLS aggregate variable=res_o_stream     compact=bit
    #pragma HLS aggregate variable=y_stream         compact=bit

    X_T x_buf[T][C];
    #pragma HLS array_reshape variable=x_buf cyclic factor=TP dim=1
    #pragma HLS array_reshape variable=x_buf cyclic factor=CP dim=2
    #pragma HLS bind_storage  variable=x_buf type=RAM_2P impl=URAM

    // prior to the loop, read the first layer's input and write to buffer
    // for each layer:
    //      1. directly write buffer to residual_o
    //      2. read residual_i, add to buffer
    // post loop, write buffer to y_stream or res_o_stream (if run_cls)

    // first, read x, write to buffer
    for(int tt=0; tt<TT; ++tt){
        for(int ct=0; ct<CT; ++ct){
            #pragma HLS pipeline II=1
            hls::vector<X_T, TP*CP> vec = x_stream.read();
            for(int tp=0; tp<TP; ++tp){
                for(int cp=0; cp<CP; ++cp){
                    #pragma HLS unroll
                    x_buf[tt*TP + tp][ct*CP + cp] = vec[tp*CP + cp];
                }
            }
        }
    }

    // for each layer, apply residual for twice: MHA & MLP
    // 不参与CLS
    for(int l=l_begin; l<l_close && l<LLAMA_L; ++l){
        for(int pass=0; pass<2; ++pass){
            // write buffer to residual_o directly
            for(int tt=0; tt<TT; ++tt){
                for(int ct=0; ct<CT; ++ct){
                    #pragma HLS pipeline II=1
                    hls::vector<X_T, TP*CP> vec;
                    for(int tp=0; tp<TP; ++tp){
                        for(int cp=0; cp<CP; ++cp){
                            #pragma HLS unroll
                            vec[tp*CP + cp] = x_buf[tt*TP + tp][ct*CP + cp];
                        }
                    }
                    res_o_stream.write(vec);
                }
            }
            // read residual_i, add to buffer, with order adjustment (since OD is unpacked)
            for(int ct=0; ct<CT; ++ct){
                for(int tt=0; tt<TT; ++tt){
                    #pragma HLS pipeline II=1
                    // declare vec
                    hls::vector<X_T, TP*CP> vec_i;
                    hls::vector<X_T, TP*CP> vec_buf;
                    // read unpacked tokens
                    for(int tp=0; tp<TP; ++tp){
                        hls::vector<X_T, CP> vec_cp = res_i_stream.read();
                        for(int cp=0; cp<CP; ++cp){
                            vec_i[tp*CP + cp] = vec_cp[cp];
                        }
                    }
                    // read from buffer
                    for(int tp=0; tp<TP; ++tp){
                        for(int cp=0; cp<CP; ++cp){
                            vec_buf[tp*CP + cp] = x_buf[tt*TP + tp][ct*CP + cp];
                        }
                    }
                    // add to buffer
                    for(int tp=0; tp<TP; ++tp){
                        for(int cp=0; cp<CP; ++cp){
                            x_buf[tt*TP + tp][ct*CP + cp] = vec_i[tp*CP + cp] + vec_buf[tp*CP + cp];
                        }
                    }
                }
            }
        }
    }


    bool run_cls = (l_close == LLAMA_L+1);
    // last, write to y_stream
    for(int tt=0; tt<TT; ++tt){
        for(int ct=0; ct<CT; ++ct){
            #pragma HLS pipeline II=1
            hls::vector<X_T, TP*CP> vec;
            for(int tp=0; tp<TP; ++tp){
                for(int cp=0; cp<CP; ++cp){
                    #pragma HLS unroll
                    vec[tp*CP + cp] = x_buf[tt*TP + tp][ct*CP + cp];
                }
            }
            if(run_cls)    res_o_stream    .write(vec);
            else           y_stream        .write(vec);
        }
    }
}

// declare the refs
int64_t REF_X               [L][  T*C  ];
int64_t REF_Y               [L][  T*C  ];
int64_t REF_MHA_X           [L][  T*C  ];
int64_t REF_MHA_O           [L][  T*C  ];
int64_t REF_MLP_X           [L][  T*C  ];
int64_t REF_MLP_D           [L][  T*C  ];
int64_t REF_MHA_O_RES       [L][  T*C  ];
int64_t REF_MLP_XD_RES      [L][  T*C  ];
// declare the condensed input
int64_t REF_CONDENSED_OD    [L][2*NUM_X];
// delcare the ref output
int64_t REF_RESIDUAL_O      [L][3*T*C  ];
// declare the ref residual
int64_t DUT_Y                  [  T*C  ];
int64_t DUT_RESIDUAL_O      [L][3*T*C  ];


void prepare_decoder_data(
    int l,
    int l_begin,
    int l_close,
    const string& binaries_path,
    const string& condense_path,
    hls::stream<hls::vector<X_T, TP*CP> >& x_stream,
    hls::stream<hls::vector<X_T,    CP> >& res_i_stream
){
    //* condensed input res_i_stream
    auto CONDENSED_OD   = read_tensor<int64_t> (condense_path + "/CONDENSED_DEMUX_OD.bin");
    tensor2array<int64_t>(  CONDENSED_OD,   REF_CONDENSED_OD[l],    1,      1,      1,          1,      2*NUM_X,    2*NUM_X);

    //* read results
    auto MHA_X          = read_tensor<int64_t> (binaries_path + "/MHA_X.bin"     );
    auto MHA_O          = read_tensor<int64_t> (binaries_path + "/MHA_O.bin"     );
    auto MHA_O_RES      = read_tensor<int64_t> (binaries_path + "/MHA_O_RES.bin" );
    auto MLP_X          = read_tensor<int64_t> (binaries_path + "/MLP_X.bin"     );
    auto MLP_XD         = read_tensor<int64_t> (binaries_path + "/MLP_XD.bin"    );
    auto MLP_XD_RES     = read_tensor<int64_t> (binaries_path + "/MLP_XD_RES.bin");

    //             dtype,   tensor,         array,                      H_LOAD, H,      T_LOAD,     T_START,    T,      C_LOAD,     C
    tensor2array<int64_t>(  MHA_X,          REF_MHA_X       [l],        1,      1,      T_LOAD,     POS,        T,      C,          C      );
    tensor2array<int64_t>(  MHA_O,          REF_MHA_O       [l],        1,      1,      T_LOAD,     POS,        T,      C,          C      );
    tensor2array<int64_t>(  MLP_X,          REF_MLP_X       [l],        1,      1,      T_LOAD,     POS,        T,      C,          C      );
    tensor2array<int64_t>(  MLP_XD,         REF_MLP_D       [l],        1,      1,      T_LOAD,     POS,        T,      C,          C      );
    tensor2array<int64_t>(  MHA_O_RES,      REF_MHA_O_RES   [l],        1,      1,      T_LOAD,     POS,        T,      C,          C      );
    tensor2array<int64_t>(  MLP_XD_RES,     REF_MLP_XD_RES  [l],        1,      1,      T_LOAD,     POS,        T,      C,          C      );

    //* check the coherency of the input itself
    for(int t=0; t<T; ++t){
        for(int c=0; c<C; ++c){
            // MHA_X + MHA_O -> MLP_X
            assert(REF_MHA_X[l][t*C + c] + REF_MHA_O[l][t*C + c] == REF_MHA_O_RES [l][t*C + c]);
            // MLP_X + MLP_XD -> MLP_XD_RES
            assert(REF_MLP_X[l][t*C + c] + REF_MLP_D[l][t*C + c] == REF_MLP_XD_RES[l][t*C + c]);
        }
    }

    //* put REF_MHA_X and REF_MLP_X into the ref residual
    for(int pass=0; pass<2; ++pass){
        for(int t=0; t<T; ++t){
            for(int c=0; c<C; ++c){
                if(pass == 0) REF_RESIDUAL_O[l][pass*T*C + t*C + c] = REF_MHA_X[l][t*C + c];
                else          REF_RESIDUAL_O[l][pass*T*C + t*C + c] = REF_MLP_X[l][t*C + c];
            }
        }
    }

    //* put MLP_XD_RES into the ref y
    for(int t=0; t<T; ++t){
        for(int c=0; c<C; ++c){
            REF_Y[l][t*C + c] = REF_MLP_XD_RES[l][t*C + c];
        }
    }

    //* write stream
    array2stream<int64_t, X_T, 1, 1, 1, 1, 2*NUM_X, CP>(REF_CONDENSED_OD[l], res_i_stream, "CONDENSED OD", true);
    
    //* save condensed input
    save_condensed_tensor<int64_t, X_T, 2*NUM_X, CP>(condense_path + "/CONDENSED_RESIDUAL_I.bin", res_i_stream);

    //* stream in first layer
    if(l == l_begin){
        for(int t=0; t<T; ++t){
            for(int c=0; c<C; ++c){
                REF_X[l][t*C + c] = REF_MHA_X[l_begin][t*C + c];
            }
        }
        array2stream<int64_t, X_T, 1, 1, T, TP, C, CP>(REF_X[l],     x_stream,     "X",            true);
        //* save condensed input
        save_condensed_tensor<int64_t, X_T, T*C, TP*CP>(condense_path + "/CONDENSED_RESIDUAL_X.bin", x_stream);
    }
}


void compare_decoder_data(
    int l,
    int l_begin,
    int l_close,
    const string& binaries_path,
    const string& condense_path,
    hls::stream<hls::vector<X_T, TP*CP> >& res_o_stream,
    hls::stream<hls::vector<X_T, TP*CP> >& y_stream
){
    //* save condensed output
    hls::stream<hls::vector<X_T, TP*CP> > sim_res_o_stream("sim_res_o_stream");
    stream2stream                 <X_T, 2*T*C, TP*CP>(res_o_stream, sim_res_o_stream);
    save_condensed_tensor<int64_t, X_T, 2*T*C, TP*CP>(condense_path + "/CONDENSED_RESIDUAL_O.bin", sim_res_o_stream);
    //* readout
    stream2array<int64_t, X_T, 2, T, TP, C, CP>(sim_res_o_stream, DUT_RESIDUAL_O[l], "RESIDUAL O", true);
    //* check stream size
    assert(sim_res_o_stream.size() == 0);
    //* compare residual
    compare<int64_t>(REF_RESIDUAL_O[l], DUT_RESIDUAL_O[l], 2*T*C, "RESIDUAL");

    //* compare y
    if(l == l_close-1){
        hls::stream<hls::vector<X_T, TP*CP> > sim_y_stream("sim_y_stream");
        stream2stream                 <X_T, T*C, TP*CP>(y_stream, sim_y_stream);
        save_condensed_tensor<int64_t, X_T, T*C, TP*CP>(condense_path + "/CONDENSED_RESIDUAL_Y.bin", sim_y_stream);
        stream2array<int64_t, X_T, 1, T, TP, C, CP>(sim_y_stream, DUT_Y, "Y", true);
        compare<int64_t>(REF_Y[l], DUT_Y, T*C, "Y");
    }
}


void test_layer(int l_begin, int l_close){
    //* create streams
    hls::stream<hls::vector<X_T, TP*CP> > x_stream       ("X");
    hls::stream<hls::vector<X_T,    CP> > res_i_stream   ("RESIDUAL I");
    hls::stream<hls::vector<X_T, TP*CP> > res_o_stream   ("RESIDUAL O");
    hls::stream<hls::vector<X_T, TP*CP> > y_stream       ("Y");


    //* for each layer, prepare the data
    for(int l=l_begin; l<l_close && l<LLAMA_L; ++l){
        prepare_decoder_data(
            l,
            l_begin,
            l_close,
            BINARIES_PATH + to_string(l),
            CONDENSE_PATH + to_string(l),
            x_stream,
            res_i_stream
        );
    }


    //* call top function
    top(l_begin, l_close, x_stream, res_i_stream, res_o_stream, y_stream);


    //* for each layer, compare the residual data
    for(int l=l_begin; l<l_close && l<LLAMA_L; ++l){
        compare_decoder_data(
            l,
            l_begin,
            l_close,
            BINARIES_PATH + to_string(l),
            CONDENSE_PATH + to_string(l),
            res_o_stream,
            y_stream
        );
    }

}


int main(){
    // test_layer(0, LLAMA_L);

    // test_layer(0, 1);

    for(int l=0; l<L; ++l){
        test_layer(l, l+1);
        printf("Layer %d passed\n", l);
    }

    return 0;
}