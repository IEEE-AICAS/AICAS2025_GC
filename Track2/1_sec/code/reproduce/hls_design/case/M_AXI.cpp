#include "../src/common.h"
#include "../src/utils.h"

// 设计的consideration
// 1. 在同一个模块中，完成X的读取，多层W的读取，Y的写回
// 2. 将W的读取进行打包，解决WS并非byte-aligned的问题，每一块权重的读取是G*G个WQ，G个WS

// 一个loop中读取的wq的bit数：WQ_LOOP_BIT = WQ_CYCS × DW_MAXI
// 一个loop中读取的ws的bit数：WS_LOOP_BIT = WS_CYCS × DW_MAXI
// 这些bit数需要满足一定限制。两者的bit数之比应该等于实际数量之比：WQ_LOOP_BIT : WS_LOOP_BIT = DW_WQ×G : DW_WS×2
// 所以WQ_CYCS : WS_CYCS = DW_WQ×G : DW_WS×2

// model hyperparameters
constexpr int G                 = 8;
constexpr int T                 = 8;
constexpr int C                 = LLAMA_C;
constexpr int H                 = LLAMA_H;
constexpr int HC                = LLAMA_HC;
constexpr int CM                = LLAMA_CM;
constexpr int VOCAB             = LLAMA_VOCAB;

// design hyperparameters
constexpr int DW_X_MEM          = 32;           // in the memory_decoder_w, x and cls is 32 bit
constexpr int DW_MAXI           = 256;          // enough to consume 11.9 GB/s at 400MHz, 14.9 GB/s at 500MHz
constexpr int BYTE_PER_PACK     = DW_MAXI / 8;
constexpr int TP = 1;
constexpr int CP = G;
// in the perspective of weight_distributor, every (WQ_CYCS+WS_CYCS) cycles, distribute WQ_CYCS cycles to wq_queue, WS_CYCS cycles to ws_queue
constexpr int WQ_CYCS = (DW_WQ*G*G) / gcd(DW_WQ*G*G, DW_WS*2*G);
constexpr int WS_CYCS = (DW_WS*2*G) / gcd(DW_WQ*G*G, DW_WS*2*G);
// WQ和WS的整倍数无法对其到M_AXI的位宽，因此需要先打包再解压，中间需要一个最小公倍数
constexpr int WQ_CYCS_AGGR_SIZE = lcm(DW_MAXI, DW_WQ*G*G) / DW_MAXI;
constexpr int WS_CYCS_AGGR_SIZE = lcm(DW_MAXI, DW_WS*2*G) / DW_MAXI;
static_assert(WQ_CYCS % WQ_CYCS_AGGR_SIZE == 0, "WQ_CYCS must be a factor of WQ_CYCS_AGGR_SIZE");
static_assert(WS_CYCS % WS_CYCS_AGGR_SIZE == 0, "WS_CYCS must be a factor of WS_CYCS_AGGR_SIZE");
constexpr int WQ_CYCS_AGGR_NUM  = WQ_CYCS / WQ_CYCS_AGGR_SIZE;
constexpr int WS_CYCS_AGGR_NUM  = WS_CYCS / WS_CYCS_AGGR_SIZE;
// calculate how many packs are loaded in one aggregation
static_assert(DW_MAXI * WQ_CYCS_AGGR_SIZE % (DW_WQ*G*G) == 0);
static_assert(DW_MAXI * WS_CYCS_AGGR_SIZE % (DW_WS*2*G) == 0);
constexpr int WQ_PACK_PER_AGGR  = DW_MAXI * WQ_CYCS_AGGR_SIZE / (DW_WQ*G*G);
constexpr int WS_PACK_PER_AGGR  = DW_MAXI * WS_CYCS_AGGR_SIZE / (DW_WS*2*G);

// derived hyperparameters for decoder pack
constexpr int DECODER_NUM_WQ    = 4*C*C + 3*C*CM;
constexpr int DECODER_NUM_WS    = DECODER_NUM_WQ / G;
constexpr int DECODER_W_CYCS    = (DECODER_NUM_WQ*DW_WQ + DECODER_NUM_WS*DW_WS*2) / DW_MAXI;
constexpr int DECODER_LOOPS     = DECODER_W_CYCS / (WQ_CYCS + WS_CYCS);
// checks
static_assert(DECODER_W_CYCS % (WQ_CYCS + WS_CYCS) == 0, "WQ_CYCS + WS_CYCS must be a factor of TOTAL_CYCS");

// derived hyperparameters for cls pack
constexpr int CLS_NUM_WQ       = VOCAB*C;
constexpr int CLS_NUM_WS       = CLS_NUM_WQ / G;
constexpr int CLS_W_CYCS       = (CLS_NUM_WQ*DW_WQ + CLS_NUM_WS*DW_WS*2) / DW_MAXI;
constexpr int CLS_LOOPS        = CLS_W_CYCS / (WQ_CYCS + WS_CYCS);
// checks
static_assert(CLS_W_CYCS % (WQ_CYCS + WS_CYCS) == 0, "WQ_CYCS + WS_CYCS must be a factor of TOTAL_CYCS");


// reading x and writing y
constexpr int X_PACK_PER_TILE   = TP*CP*DW_X_MEM / DW_MAXI;
constexpr int X_PER_PACK        = DW_MAXI / DW_X_MEM;
// decoder
constexpr int NUM_X             = T*C;
constexpr int NUM_X_TILE        = NUM_X   / (TP*CP);
// cls
constexpr int NUM_CLS           = T*VOCAB;
constexpr int NUM_CLS_TILE      = NUM_CLS / (TP*CP);    // unpacked

// define data types
typedef ap_int <DW_MAXI      > maxi_t;
typedef ap_int <DW_X         > x_t;
typedef ap_int <DW_CLS_TRUNC > cls_t;
typedef ap_int <DW_X_MEM     > x_mem_t;
typedef ap_int <DW_AQ        > aq_t;
typedef ap_int <DW_AS        > as_t;
typedef ap_int <DW_WQ        > wq_t;
typedef ap_uint<DW_WS        > ws_t;
typedef ap_uint<DW_MAXI*WS_CYCS_AGGR_SIZE > ws_pack_t;  // repr1: bitwidth = DW_MAXI * WS_CYCS_AGGR_SIZE     repr2: bitwidth = DW_WS * 2 * G * WS_CYCS_AGGR_SIZE
typedef ap_uint<DW_MAXI*WQ_CYCS_AGGR_SIZE > wq_pack_t;


// read x from memory
void read_x(maxi_t* memory_decoder_x, hls::stream<hls::vector<x_t, TP*CP> >& x_stream){
    // TODO: insert dummy cycls, since M_AXI produces errors
    constexpr int X_DUMMY_READS = 4;
    for(int n_tile=-X_DUMMY_READS; n_tile<NUM_X_TILE; ++n_tile){
        hls::vector<x_t, TP*CP> vec;
        for(int n_pack=0; n_pack<X_PACK_PER_TILE; ++n_pack){
            #pragma HLS pipeline II=1
            maxi_t packet = memory_decoder_x[n_tile*X_PACK_PER_TILE + n_pack];
            for(int num_x=0; num_x<X_PER_PACK; ++num_x){
                #pragma HLS unroll
                vec[n_pack*X_PER_PACK + num_x] = packet.range(DW_X-1, 0);
                packet = packet >> DW_X_MEM;
            }
        }
        if(n_tile >= 0) x_stream.write(vec);
    }
}


// read weight from memory
void weight_producer(
    int l, 
    maxi_t* memory_decoder_w, 
    maxi_t* memory_cls_w,
    hls::stream<maxi_t>& mem_stream
){
    bool run_cls = (l == LLAMA_L);
    int TOTAL_CYCS = run_cls ? CLS_W_CYCS : DECODER_W_CYCS;
    // must use different loops, or there will be bubbles
    if(run_cls){
        for(int n=0; n<CLS_W_CYCS; ++n){
            #pragma HLS pipeline II=1
            maxi_t packet = memory_cls_w[n];
            mem_stream.write(packet);
        }
    } else {
        for(int n=0; n<DECODER_W_CYCS; ++n){
            #pragma HLS pipeline II=1
            maxi_t packet = memory_decoder_w[l*DECODER_W_CYCS + n];
            mem_stream.write(packet);
        }
    }
}

// distribute weight to wq and ws
void weight_distributor(
    int l, 
    hls::stream<maxi_t>& mem_stream, 
    hls::stream<maxi_t>& wq_queue, 
    hls::stream<maxi_t>& ws_queue
){
    int TOTAL_LOOPS = (l == LLAMA_L) ? CLS_LOOPS : DECODER_LOOPS;
    // process useful data
    for(int loop=0; loop<TOTAL_LOOPS; ++loop){
        for(int cyc=0; cyc<WQ_CYCS+WS_CYCS; ++cyc){
            #pragma HLS pipeline II=1
            maxi_t packet = mem_stream.read();
            if(cyc < WQ_CYCS)   wq_queue.write(packet);
            else                ws_queue.write(packet);
        }
    }
}


void compose_ws_stage1(
    int l, 
    hls::stream<maxi_t   >& ws_queue, 
    hls::stream<ws_pack_t>& ws_pack_stream
){
    int LOOPS = (l == LLAMA_L) ? CLS_LOOPS : DECODER_LOOPS;
    for(int loop=0; loop<LOOPS; ++loop){
        for(int aggr=0; aggr<WS_CYCS_AGGR_NUM; ++aggr){
            ws_pack_t pack = 0;
            // collect multiple maxit_t into one ws_pack_t
            for(int i=0; i<WS_CYCS_AGGR_SIZE; ++i){
                #pragma HLS pipeline II=1
                maxi_t packet = ws_queue.read();
                pack >>= DW_MAXI;
                pack.range(DW_MAXI*WS_CYCS_AGGR_SIZE-1, DW_MAXI*(WS_CYCS_AGGR_SIZE-1)) = packet;
            }
            ws_pack_stream.write(pack);
        }
    }
}

void compose_ws_stage2(
    int l,
    hls::stream<ws_pack_t>& ws_pack_stream,
    hls::stream<hls::vector<ws_t, G> >& ws1_stream,
    hls::stream<hls::vector<ws_t, G> >& ws2_stream
){
    int LOOPS = (l == LLAMA_L) ? CLS_LOOPS : DECODER_LOOPS;
    for(int loop=0; loop<LOOPS; ++loop){
        for(int aggr=0; aggr<WS_CYCS_AGGR_NUM; ++aggr){
            ws_pack_t pack = ws_pack_stream.read();
            // the pack contains many ws_t, distribute them to ws1 and ws2
            for(int i=0; i<WS_PACK_PER_AGGR; ++i){
                #pragma HLS pipeline II=1
                hls::vector<ws_t, G> vec1, vec2;
                for(int g=0; g<G; ++g){
                    #pragma HLS unroll
                    vec1[g] = pack.range(DW_WS*1-1, DW_WS*0);
                    vec2[g] = pack.range(DW_WS*2-1, DW_WS*1);
                    pack = pack >> (DW_WS*2);
                }
                ws1_stream.write(vec1);
                ws2_stream.write(vec2);
            }
        }
    }
}


void compose_wq_stage1(
    int l,
    hls::stream<maxi_t>& wq_queue,
    hls::stream<wq_pack_t>& wq_stream
){
    int LOOPS = (l == LLAMA_L) ? CLS_LOOPS : DECODER_LOOPS;
    for(int loop=0; loop<LOOPS; ++loop){
        for(int aggr=0; aggr<WQ_CYCS_AGGR_NUM; ++aggr){
            wq_pack_t pack = 0;
            // collect multiple maxi_t into one ws_pack_t
            for(int i=0; i<WQ_CYCS_AGGR_SIZE; ++i){
                #pragma HLS pipeline II=1
                maxi_t packet = wq_queue.read();
                pack >>= DW_MAXI;
                pack.range(DW_MAXI*WQ_CYCS_AGGR_SIZE-1, DW_MAXI*(WQ_CYCS_AGGR_SIZE-1)) = packet;
            }
            wq_stream.write(pack);
        }
    }
}


void compose_wq_stage2(
    int l,
    hls::stream<wq_pack_t>& wq_pack_stream,
    hls::stream<hls::vector<wq_t, G*G> >& wq_stream
){
    int LOOPS = (l == LLAMA_L) ? CLS_LOOPS : DECODER_LOOPS;
    for(int loop=0; loop<LOOPS; ++loop){
        for(int aggr=0; aggr<WQ_CYCS_AGGR_NUM; ++aggr){
            wq_pack_t pack = wq_pack_stream.read();
            // the pack contains many wq_t, distribute them to wq
            for(int i=0; i<WQ_PACK_PER_AGGR; ++i){
                #pragma HLS pipeline II=1
                hls::vector<wq_t, G*G> vec;
                for(int g=0; g<G*G; ++g){
                    #pragma HLS unroll
                    vec[g] = pack.range(DW_WQ-1, 0);
                    pack = pack >> DW_WQ;
                }
                wq_stream.write(vec);
            }
        }
    }
}



// dataflow of read w
void read_w(
    int l,
    maxi_t* memory_decoder_w,
    maxi_t* memory_cls_w,
    hls::stream<hls::vector<wq_t, G*G> >& wq_stream,
    hls::stream<hls::vector<ws_t, G  > >& ws1_stream,
    hls::stream<hls::vector<ws_t, G  > >& ws2_stream
){
    #pragma HLS dataflow
    hls::stream<maxi_t   > mem_stream;
    hls::stream<maxi_t   > wq_queue;
    hls::stream<maxi_t   > ws_queue;
    hls::stream<wq_pack_t> wq_pack_stream;
    hls::stream<ws_pack_t> ws_pack_stream;

    weight_producer     (l,     memory_decoder_w,   memory_cls_w,   mem_stream  );
    weight_distributor  (l,     mem_stream,         wq_queue,       ws_queue    );
    compose_wq_stage1   (l,     wq_queue,           wq_pack_stream              );
    compose_wq_stage2   (l,     wq_pack_stream,     wq_stream                   );
    compose_ws_stage1   (l,     ws_queue,           ws_pack_stream              );
    compose_ws_stage2   (l,     ws_pack_stream,     ws1_stream,     ws2_stream  );
}

void write_cls(
    maxi_t* memory_cls_y,
    hls::stream<hls::vector<cls_t, CP> >& cls_stream
){
    for(int n_tile=0; n_tile<NUM_CLS_TILE; ++n_tile){
        hls::vector<cls_t, TP*CP> vec;
        for(int tp=0; tp<TP; ++tp){
            #pragma HLS pipeline II=1
            hls::vector<cls_t, CP> vec_cp = cls_stream.read();
            for(int cp=0; cp<CP; ++cp){
                #pragma HLS unroll
                vec[tp*CP + cp] = vec_cp[cp];
            }
        }
        // share same setting as X, since X and CLS have same bitwidth
        for(int n_pack=0; n_pack<X_PACK_PER_TILE; ++n_pack){
            #pragma HLS pipeline II=1
            maxi_t packet = 0;
            for(int num_y=X_PER_PACK-1; num_y>=0; --num_y){
                #pragma HLS unroll
                packet = packet << DW_X_MEM;
                packet.range(DW_X_MEM-1, 0) = vec[n_pack*X_PER_PACK + num_y];
            }
            memory_cls_y[n_tile*X_PACK_PER_TILE + n_pack] = packet;
        }
    }
}

void write_y(
    maxi_t* memory_decoder_y,
    hls::stream<hls::vector<x_t, TP*CP> >& y_stream
){
    for(int n_tile=0; n_tile<NUM_X_TILE; ++n_tile){
        hls::vector<x_t, TP*CP> vec = y_stream.read();
        for(int n_pack=0; n_pack<X_PACK_PER_TILE; ++n_pack){
            #pragma HLS pipeline II=1
            maxi_t packet = 0;
            for(int num_y=X_PER_PACK-1; num_y>=0; --num_y){
                #pragma HLS unroll
                packet = packet << DW_X_MEM;
                packet.range(DW_X_MEM-1, 0) = vec[n_pack*X_PER_PACK + num_y];
            }
            memory_decoder_y[n_tile*X_PACK_PER_TILE + n_pack] = packet;
        }
    }
}


void top(
    int l_begin,
    int l_close,

    maxi_t*    memory_decoder_x,
    maxi_t*    memory_decoder_y,
    maxi_t*    memory_cls_y,        // reuse decoder_x as input if cls only
    maxi_t*    memory_decoder_w,
    maxi_t*    memory_cls_w,

    hls::stream<hls::vector<x_t,    TP*CP   > >& x_stream,          // to accelerator
    hls::stream<hls::vector<wq_t,   G*G     > >& wq_stream,         // to accelerator
    hls::stream<hls::vector<ws_t,   G       > >& ws1_stream,        // to accelerator
    hls::stream<hls::vector<ws_t,   G       > >& ws2_stream,        // to accelerator
    hls::stream<hls::vector<x_t,    TP*CP   > >& y_stream,          // from accelerator
    hls::stream<hls::vector<cls_t,     CP   > >& cls_stream        // from accelerator
){
    #pragma HLS interface ap_ctrl_chain port=return

    #pragma HLS interface mode=m_axi bundle=gmem port=memory_decoder_x   depth=NUM_X            offset=direct
    #pragma HLS interface mode=m_axi bundle=gmem port=memory_decoder_y   depth=NUM_X            offset=direct
    #pragma HLS interface mode=m_axi bundle=gmem port=memory_cls_y       depth=NUM_CLS          offset=direct
    #pragma HLS interface mode=m_axi bundle=gmem port=memory_decoder_w   depth=DECODER_W_CYCS   offset=direct
    #pragma HLS interface mode=m_axi bundle=gmem port=memory_cls_w       depth=CLS_W_CYCS       offset=direct

    #pragma HLS interface axis port=x_stream
    #pragma HLS interface axis port=wq_stream
    #pragma HLS interface axis port=ws1_stream
    #pragma HLS interface axis port=ws2_stream
    #pragma HLS interface axis port=y_stream
    #pragma HLS interface axis port=cls_stream

    #pragma HLS aggregate variable=x_stream          compact=bit
    #pragma HLS aggregate variable=wq_stream         compact=bit
    #pragma HLS aggregate variable=ws1_stream        compact=bit
    #pragma HLS aggregate variable=ws2_stream        compact=bit
    #pragma HLS aggregate variable=y_stream          compact=bit
    #pragma HLS aggregate variable=cls_stream        compact=bit

    #pragma HLS dataflow

    read_x(memory_decoder_x, x_stream);

    // read weight
    for(int l=l_begin; l<l_close; ++l){
        read_w(l, memory_decoder_w, memory_cls_w, wq_stream, ws1_stream, ws2_stream);
    }

    // write result
    if(l_close == LLAMA_L+1){
        write_cls(memory_cls_y, cls_stream);
    } else {
        write_y(memory_decoder_y, y_stream);
    }

}