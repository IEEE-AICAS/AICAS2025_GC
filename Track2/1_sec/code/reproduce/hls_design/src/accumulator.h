#ifndef __INT_MAIN_ACCUMULATOR_H__
#define __INT_MAIN_ACCUMULATOR_H__

#include "src/common.h"
#include "src/utils.h"

// For QKVOUG, they all use C=4096  as input channel
// For D                use C=11008 as input channel

// Therefore, there are two stages. 
// For the first stage,     4096  is reduction times
// For the second stage,    11008 is reduction times

// ACC_CYCS1: 在第一阶段，每消耗A1个周期，产生一次完整的累加；且通道并行度已被考虑在内
// ACC_REPEAT1: 第一阶段的累加总共重复N1次，即总共消耗N1*A1个周期

// 具体的例子：
// LLAMA中，QKVOUG的输入通道数为4096，D的输入通道数为11008
// 因此前6个矩阵乘的A可以统一，而最后一个矩阵为另一个A
// 设置通道reduction并行度为G=8
// ACC_CYCS1 =  4096/8 = 512
// ACC_CYCS2 = 11008/8 = 1376
// 而N的计算同时受到矩阵个数和矩阵输出通道数的贡献
// 其中QKVO的输出通道为4096，UG的输出通道为11008
// 设置输出通道并行度同样为G=8，对齐量化的group size
// ACC_REPEAT1 = (四个矩阵 * 4096 / 8) + (两个矩阵 * 11008 / 8) = 2048 + 2752 = 4800
// ACC_REPEAT2 = 一个矩阵 * 11008 / 8 = 1376
// 上述例子中均没有涉及到TP，因为在权重全广播的GEMM设计中，T必须等于TP，导致TT=1


// 由于Token并行度很大时，输出位宽可能会超过4096的hls::stream限制，因此拆分两个通道输出

template<
    class if_t,
    class as_t,
    class ws_t,
    class acc_t,
    class of_t,

    int TRUNC_BASE,     // basic truncation after accumulation

    int TP,             // input token   parallelism
    int CP,             // input channel parallelism

    int ACC_CYCS1,      // stage 1 accumulate times
    int ACC_CYCS2,      // stage 2 accumulate times
    int ACC_CYCS3,      // stage 3 accumulate times

    int ACC_REPEAT1,    // stage 1 repeat time
    int ACC_REPEAT2,    // stage 2 repeat time
    int ACC_REPEAT3,    // stage 3 repeat time

    int G               // group size
>
class ACCUMULATOR{
public:

    // total repeat time
    static constexpr int DECODER_TOTAL_CYCS = ACC_REPEAT1*ACC_CYCS1 + ACC_REPEAT2*ACC_CYCS2;
    static constexpr int DECODER_BOUND_CYCS = ACC_REPEAT1*ACC_CYCS1;

    static constexpr int CLS_TOTAL_CYCS     = ACC_REPEAT3*ACC_CYCS3;

    // #ifndef __SYNTHESIS__
    // ProgressBar pb;
    // ACCUMULATOR(): pb("ACCUMULATOR", DECODER_TOTAL_CYCS / 1000 + 1) {}
    // #else
    // ACCUMULATOR() {}
    // #endif

    ACCUMULATOR() {}

    void stage1_accumulation(
        // scalar input
        bool run_cls,
        // streams
        hls::stream<hls::vector<if_t, TP*CP     > >& i_stream,
        hls::stream<hls::vector<as_t, TP        > >& s_stream,
        hls::stream<hls::vector<ws_t, CP        > >& s1_stream,
        hls::stream<hls::vector<ws_t, CP        > >& s2_stream,
        hls::stream<hls::vector<of_t, TP*CP/2   > >& o1_stream,
        hls::stream<hls::vector<of_t, TP*CP/2   > >& o2_stream
    ) {
        // #ifndef __SYNTHESIS__
        // pb.start();
        // #endif

        acc_t psum[TP*CP];
        #pragma HLS array_reshape variable=psum complete dim=1

        int TOTAL_CYCS = run_cls ? CLS_TOTAL_CYCS : DECODER_TOTAL_CYCS;

        for(int cyc=0, sub_cyc=0; cyc<TOTAL_CYCS; ++cyc){
            #pragma HLS pipeline II=1
            #pragma HLS EXPRESSION_BALANCE OFF

            if(sub_cyc == 0){
                // initialize inside the loop
                for(int tp = 0; tp < TP; tp++) {
                    for(int cp = 0; cp < CP; cp++) {
                        #pragma HLS unroll
                        psum[tp*CP + cp] = 0;
                    }
                }
            }

            // #ifndef __SYNTHESIS__
            // if(cyc % 1000 == 0) pb.update(1);
            // #endif

            hls::vector<if_t, TP*CP>    i_vec   =   i_stream .read();
            hls::vector<as_t, TP   >    s_vec   =   s_stream .read();
            hls::vector<ws_t, CP   >    s1_vec  =   s1_stream.read();
            hls::vector<ws_t, CP   >    s2_vec  =   s2_stream.read();

            // add pre-shift and second-shift type
            constexpr int s1_width = if_t::width + (1 <<  as_t::width     ) - 1;
            constexpr int s2_width = if_t::width + (1 << (as_t::width + 1)) - 1;
            typedef ap_int<s1_width> if_s1_t;
            typedef ap_int<s2_width> if_s2_t;

            // accumulate with shift
            for(int tp = 0; tp < TP; tp++) {
                for(int cp = 0; cp < CP; cp++) {
                    #pragma HLS unroll
                    auto x_val     = i_vec [tp*CP + cp];
                    auto s_val     = s_vec [tp];
                    auto s1_val    = s1_vec[cp];
                    auto s2_val    = s2_vec[cp];

                    auto x_shift   = if_s1_t(x_val) << s_val;

                    // if_s2_t acc = (if_s2_t(x_shift) << s1_val) + (if_s2_t(x_shift) << s2_val);
                    // psum[tp*CP + cp] += acc;
                    // #pragma HLS bind_op variable=acc  op=add impl=dsp
                    // #pragma HLS bind_op variable=psum op=add impl=dsp
                    psum[tp*CP + cp] += (if_s2_t(x_shift) << s1_val) + (if_s2_t(x_shift) << s2_val);
                }
            }

            // determine whether to output
            int SUB_CYCS =  run_cls                    ? ACC_CYCS3 : 
                            (cyc < DECODER_BOUND_CYCS) ? ACC_CYCS1 : ACC_CYCS2;

            // reach the accumulate times
            if(sub_cyc+1 == SUB_CYCS){
                // reset counter
                sub_cyc = 0;
                // write, but split into two
                hls::vector<of_t, TP*CP/2> o1_vec;
                hls::vector<of_t, TP*CP/2> o2_vec;
                for(int index=0; index<TP*CP/2; ++index){
                    #pragma HLS unroll
                    o1_vec[index] = psum[index          ] >> TRUNC_BASE;
                    o2_vec[index] = psum[index + TP*CP/2] >> TRUNC_BASE;
                }
                // write
                o1_stream.write(o1_vec);
                o2_stream.write(o2_vec);
            } else {
                ++sub_cyc;
            }
        } // end of for(cyc)

    }

    void stage2_unpack(
        // scalar input
        bool run_cls,
        // streams
        hls::stream<hls::vector<of_t, TP*CP/2> >& o1_stream,
        hls::stream<hls::vector<of_t, TP*CP/2> >& o2_stream,
        hls::stream<hls::vector<of_t, CP     > >& o_stream
    ) {
        // total repeat time, which is the number of results
        int NUM_OUTPUT = run_cls ? ACC_REPEAT3 : (ACC_REPEAT1 + ACC_REPEAT2);

        for(int num_output=0; num_output<NUM_OUTPUT; ++num_output){
            // read two channels
            hls::vector<of_t, TP*CP/2> o1_vec = o1_stream.read();
            hls::vector<of_t, TP*CP/2> o2_vec = o2_stream.read();
            // merge two channels to avoid hls::stream width limitation
            of_t obuf[TP*CP];
            #pragma HLS array_reshape variable=obuf complete dim=1
            // merge
            for(int index=0; index<TP*CP/2; ++index){
                #pragma HLS unroll
                obuf[index          ] = o1_vec[index];
                obuf[index + TP*CP/2] = o2_vec[index];
            }

            // unpack TP dim
            for(int tp=0; tp<TP; ++tp){
                #pragma HLS pipeline II=1
                hls::vector<of_t, CP> o_vec;

                // assign lower to o_vec
                for(int cp=0; cp<CP; ++cp){
                    #pragma HLS unroll
                    o_vec[cp] = obuf[cp];
                }
                // shift down obuf
                for(int tp=0; tp<TP-1; ++tp){
                    for(int cp=0; cp<CP; ++cp){
                        #pragma HLS unroll
                        obuf[tp*CP + cp] = obuf[(tp+1)*CP + cp];
                    }
                }
                // write
                o_stream.write(o_vec);
            }
        }
    }

    void do_accumulator(
        // scalar inputs
        bool run_cls,
        // streams
        hls::stream<hls::vector<if_t, TP*CP > >& i_stream,
        hls::stream<hls::vector<as_t, TP    > >& s_stream,
        hls::stream<hls::vector<ws_t, CP    > >& s1_stream,
        hls::stream<hls::vector<ws_t, CP    > >& s2_stream,
        hls::stream<hls::vector<of_t, CP    > >& o_stream
    ) {
        #pragma HLS interface ap_ctrl_chain port=return
        #pragma HLS interface axis port=i_stream
        #pragma HLS interface axis port=s_stream
        #pragma HLS interface axis port=s1_stream
        #pragma HLS interface axis port=s2_stream
        #pragma HLS interface axis port=o_stream
        
        #pragma HLS dataflow

        hls::stream<hls::vector<of_t, TP*CP/2> > o1_stream;
        hls::stream<hls::vector<of_t, TP*CP/2> > o2_stream;

        stage1_accumulation (run_cls,  i_stream,  s_stream,   s1_stream, s2_stream, o1_stream, o2_stream           );
        stage2_unpack       (run_cls,                                               o1_stream, o2_stream,  o_stream);
    }

};

#endif