#ifndef __INT_GEMM_BUFFER_H__
#define __INT_GEMM_BUFFER_H__

#include "src/common.h"
#include "src/utils.h"

template<
    class data_t,
    int H,
    int T,
    int TP,
    // T is complete unrolled when fetched, but tiled when streaming in
    int C,
    int CP>
class BUFFER{
public:

    static_assert(T % TP == 0, "T must be multiple of TP");
    static_assert(C % CP == 0, "C must be multiple of CP");

    static constexpr int TT = T / TP;
    static constexpr int CT = C / CP;


    void stream2buffer(
        data_t BUF[H][TT][TP][CT][CP],
        hls::stream<hls::vector<data_t, TP*CP> > &i_stream
    ){
        #pragma HLS inline
        // first, fetch from xln stream, granularity is TP*CP
        for(int h=0; h<H; ++h){
            for(int tt=0; tt<TT; ++tt){
                for(int ct=0; ct<CT; ++ct){
                    #pragma HLS pipeline II=1
                    // #pragma HLS pipeline off
                    hls::vector<data_t, TP*CP> i_vec = i_stream.read();
                    for(int tp=0; tp<TP; ++tp){
                        for(int cp=0; cp<CP; ++cp){
                            #pragma HLS unroll
                            BUF[h][tt][tp][ct][cp] = i_vec[tp*CP+cp];
                        }
                    }
                }
            }
        }
    }

    void stream2buffer_unpack(
        data_t BUF[H][TT][TP][CT][CP],
        hls::stream<hls::vector<data_t, CP> > &i_stream
    ){
        #pragma HLS inline
        // unpacked input data, although the tile shape is TP*CP, it is unpacked to CP; need to read multiple times
        for(int h=0; h<H; ++h){
            for(int ct=0; ct<CT; ++ct){
                for(int tt=0; tt<TT; ++tt){
                    for(int tp=0; tp<TP; ++tp){
                        #pragma HLS pipeline II=1
                        // #pragma HLS pipeline off
                        hls::vector<data_t, CP> i_vec = i_stream.read();
                        for(int cp=0; cp<CP; ++cp){
                            #pragma HLS unroll
                            BUF[h][tt][tp][ct][cp] = i_vec[cp];
                        }
                    }
                }
            }
        }
    }

    void buffer2stream(
        data_t BUF[H][TT][TP][CT][CP],
        int R, 
        hls::stream<hls::vector<data_t, T*CP> > &o_stream
    ){
        #pragma HLS inline
        // fetch from xln buffer, fully unroll T, repeat multiple times to generate all heads / QKV / output channels
        for(int h=0; h<H; ++h){
            for(int r=0; r<R; ++r){
                for(int ct=0; ct<CT; ++ct){
                    #pragma HLS pipeline II=1
                    hls::vector<data_t, T*CP> o_vec;
                    for(int tt=0; tt<TT; ++tt){
                        for(int tp=0; tp<TP; ++tp){
                            for(int cp=0; cp<CP; ++cp){
                                #pragma HLS unroll
                                o_vec[tt*TP*CP+tp*CP+cp] = BUF[h][tt][tp][ct][cp];
                            }
                        }
                    }
                    // buffer2stream to stream
                    o_stream.write(o_vec);
                }
            }
        }
    }

    void buffer2stream_merge(
        data_t BUF[H][TT][TP][CT][CP],
        int R, 
        hls::stream<hls::vector<data_t, T*CP> > &o_stream
    ){
        #pragma HLS inline
        // exchange the order
        for(int r=0; r<R; ++r){
            for(int h=0; h<H; ++h){
                for(int ct=0; ct<CT; ++ct){
                    #pragma HLS pipeline II=1
                    hls::vector<data_t, T*CP> o_vec;
                    for(int tt=0; tt<TT; ++tt){
                        for(int tp=0; tp<TP; ++tp){
                            for(int cp=0; cp<CP; ++cp){
                                #pragma HLS unroll
                                o_vec[tt*TP*CP+tp*CP+cp] = BUF[h][tt][tp][ct][cp];
                            }
                        }
                    }
                    // buffer2stream to stream
                    o_stream.write(o_vec);
                }
            }
        }
    }


    void do_buffer(
        bool trigger,
        int R,
        hls::stream<hls::vector<data_t, TP*CP> > &i_stream,
        hls::stream<hls::vector<data_t, T *CP> > &o_stream
    ){
        if(!trigger) return;

        data_t BUF[H][TT][TP][CT][CP]; // buffer
        #pragma HLS array_partition variable=BUF complete dim=2
        #pragma HLS array_reshape   variable=BUF complete dim=3
        #pragma HLS array_reshape   variable=BUF complete dim=5

        #pragma HLS bind_storage variable=BUF type=ram_2p impl=lutram

        stream2buffer(BUF,            i_stream);
        buffer2stream(BUF,      R,    o_stream);
    }

    void do_buffer_merge(
        bool trigger,
        int R,
        hls::stream<hls::vector<data_t, TP*CP> > &i_stream,
        hls::stream<hls::vector<data_t, T *CP> > &o_stream
    ){
        if(!trigger) return;
        data_t BUF[H][TT][TP][CT][CP]; // buffer
        #pragma HLS array_partition variable=BUF complete dim=2
        #pragma HLS array_reshape   variable=BUF complete dim=3
        #pragma HLS array_reshape   variable=BUF complete dim=5

        #pragma HLS bind_storage variable=BUF type=ram_2p impl=lutram

        stream2buffer      (BUF,                i_stream);
        buffer2stream_merge(BUF,        R,      o_stream);
    }

    void do_buffer_unpack(
        bool trigger,
        int R,
        hls::stream<hls::vector<data_t,    CP> > &i_stream,
        hls::stream<hls::vector<data_t, T *CP> > &o_stream
    ){
        if(!trigger) return;
        data_t BUF[H][TT][TP][CT][CP]; // buffer
        #pragma HLS array_partition variable=BUF complete dim=2
        #pragma HLS array_reshape   variable=BUF complete dim=3
        #pragma HLS array_reshape   variable=BUF complete dim=5

        #pragma HLS bind_storage variable=BUF type=ram_2p impl=bram

        stream2buffer_unpack(BUF,              i_stream);
        buffer2stream       (BUF,       R,     o_stream);
    }

};




#endif