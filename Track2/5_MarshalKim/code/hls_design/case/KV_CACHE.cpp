#include "../src/common.h"
#include "../src/utils.h"

// 设计的consideration
// 1. 在同一个模块中，完成X的读取，多层W的读取，Y的写回
// 2. 将W的读取进行打包，解决WS并非byte-aligned的问题，每一块权重的读取是G*G个WQ，G个WS

// model hyperparameters
constexpr int G                 = 8;
constexpr int T                 = 8;
constexpr int S                 = 192;  // reduced context length
constexpr int C                 = 896;
constexpr int H                 = 14;
constexpr int HC                = C / H;
constexpr int CM                = 4864;
constexpr int VOCAB             = 151936;
// design hyperparameters
constexpr int DW_KV_CACHE_PACK  = 128;  // 128 bit to pack 8 values and 1 scale (8*8 + 4 = 68 < 128)
constexpr int TP = 1;
constexpr int SP = G; 
constexpr int CP = G;
// derived hyperparameters
constexpr int HCT               = HC / CP;
constexpr int ST                = S  / SP;
constexpr int TST               = T  / SP;
constexpr int K_CACHE_BYTES     = LLAMA_L * H * S * HCT * DW_KV_CACHE_PACK / 8;
constexpr int V_CACHE_BYTES     = LLAMA_L * H * HC * ST * DW_KV_CACHE_PACK / 8;
constexpr int KV_CACHE_PACK     = K_CACHE_BYTES + V_CACHE_BYTES;
// K cache and V cache are adjacent in memory, use a unified memory interface
constexpr int V_CACHE_OFFSET    = LLAMA_L * H * S * HCT;

// define data types
typedef ap_int <DW_KV_CACHE_PACK> cache_pack_t;
typedef ap_int <DW_AQ           > aq_t;
typedef ap_int <DW_AS           > as_t;

static_assert(DW_AQ*CP+DW_AS <= cache_pack_t::width, "cache_pack_t is not wide enough");
static_assert(DW_AQ*SP+DW_AS <= cache_pack_t::width, "cache_pack_t is not wide enough");



void rd_kv_cache(
    int l_begin,
    int l_close,
    int pos_id,

    cache_pack_t* memory_k_cache,

    hls::stream<hls::vector<aq_t, CP> >& kq_cache_i_stream,
    hls::stream<hls::vector<as_t,  1> >& ks_cache_i_stream,
    hls::stream<hls::vector<aq_t, SP> >& vq_cache_i_stream,
    hls::stream<hls::vector<as_t,  1> >& vs_cache_i_stream
){
    for(int l=l_begin; l<l_close && l<LLAMA_L; ++l){
        for(int h=0; h<H; ++h){
            #pragma HLS dataflow
            // read K cache
            for(int s=0; s<S; ++s){
                for(int hct=0; hct<HCT; ++hct){
                    #pragma HLS pipeline II=1
                    hls::vector<aq_t, CP> kq_vec;
                    hls::vector<as_t, 1 > ks_vec;
                    cache_pack_t pack = memory_k_cache[l*H*S*HCT + h*S*HCT + s*HCT + hct];
                    // unpack
                    for(int cp=0; cp<CP; ++cp){
                        #pragma HLS unroll
                        kq_vec[cp] = pack.range((cp+1)*DW_AQ-1, cp*DW_AQ);
                    }
                    ks_vec[0] = pack.range(CP*DW_AQ+DW_AS-1, CP*DW_AQ);
                    kq_cache_i_stream.write(kq_vec);
                    ks_cache_i_stream.write(ks_vec);
                }
            }
            // read V cache
            for(int hc=0; hc<HC; ++hc){
                for(int st=0; st<ST; ++st){
                    #pragma HLS pipeline II=1
                    hls::vector<aq_t, SP> vq_vec;
                    hls::vector<as_t, 1 > vs_vec;
                    cache_pack_t pack = memory_k_cache[V_CACHE_OFFSET + l*H*HC*ST + h*HC*ST + hc*ST + st];
                    // unpack
                    for(int sp=0; sp<SP; ++sp){
                        #pragma HLS unroll
                        vq_vec[sp] = pack.range((sp+1)*DW_AQ-1, sp*DW_AQ);
                    }
                    vs_vec[0] = pack.range(SP*DW_AQ+DW_AS-1, SP*DW_AQ);
                    vq_cache_i_stream.write(vq_vec);
                    vs_cache_i_stream.write(vs_vec);
                }
            }
        }
    }
}



void wr_kv_cache(
    int l_begin,
    int l_close,
    int pos_id,

    cache_pack_t* memory_k_cache,

    hls::stream<hls::vector<aq_t, CP> >& kq_cache_o_stream,
    hls::stream<hls::vector<as_t,  1> >& ks_cache_o_stream,

    hls::stream<hls::vector<aq_t, SP> >& vq_cache_o_stream,
    hls::stream<hls::vector<as_t,  1> >& vs_cache_o_stream
){
    int chunk = pos_id / SP;
    // write only a block of cache: pos_id~pos_id+T
    for(int l=l_begin; l<l_close && l<LLAMA_L; ++l){
        for(int h=0; h<H; ++h){
            // directly write to memory, no buffer
            for(int t=0; t<T; ++t){
                for(int hct=0; hct<HCT; ++hct){
                    #pragma HLS pipeline II=1
                    hls::vector<aq_t, CP> kq_vec = kq_cache_o_stream.read();
                    hls::vector<as_t, 1 > ks_vec = ks_cache_o_stream.read();
                    cache_pack_t pack = 0;
                    // pack
                    for(int cp=0; cp<CP; ++cp){
                        #pragma HLS unroll
                        pack.range((cp+1)*DW_AQ-1, cp*DW_AQ) = kq_vec[cp];
                    }
                    pack.range(CP*DW_AQ+DW_AS-1, CP*DW_AQ) = ks_vec[0];
                    memory_k_cache[l*H*S*HCT + h*S*HCT + (pos_id+t)*HCT + hct] = pack;
                }
            }
            for(int hc=0; hc<HC; ++hc){
                for(int st=chunk; st<chunk+TST; ++st){
                    #pragma HLS pipeline II=1
                    hls::vector<aq_t, SP> vq_vec = vq_cache_o_stream.read();
                    hls::vector<as_t, 1 > vs_vec = vs_cache_o_stream.read();
                    cache_pack_t pack = 0;
                    // pack
                    for(int sp=0; sp<SP; ++sp){
                        #pragma HLS unroll
                        pack.range((sp+1)*DW_AQ-1, sp*DW_AQ) = vq_vec[sp];
                    }
                    pack.range(SP*DW_AQ+DW_AS-1, SP*DW_AQ) = vs_vec[0];
                    memory_k_cache[V_CACHE_OFFSET + l*H*HC*ST + h*HC*ST + hc*ST + st] = pack;
                }
            }
        }
    }
}


void top(
    int l_begin,
    int l_close,
    int pos_id,

    cache_pack_t* memory_k_cache,

    // cache streams
    hls::stream<hls::vector<aq_t, CP> >& kq_cache_i_stream,
    hls::stream<hls::vector<aq_t, CP> >& kq_cache_o_stream,
    hls::stream<hls::vector<as_t,  1> >& ks_cache_i_stream,
    hls::stream<hls::vector<as_t,  1> >& ks_cache_o_stream,

    hls::stream<hls::vector<aq_t, SP> >& vq_cache_i_stream,
    hls::stream<hls::vector<aq_t, SP> >& vq_cache_o_stream,
    hls::stream<hls::vector<as_t,  1> >& vs_cache_i_stream,
    hls::stream<hls::vector<as_t,  1> >& vs_cache_o_stream
){
    #pragma HLS interface ap_ctrl_chain port=return

    #pragma HLS interface mode=m_axi bundle=gmem1 port=memory_k_cache     depth=K_CACHE_BYTES    offset=direct

    #pragma HLS interface axis port=kq_cache_i_stream
    #pragma HLS interface axis port=kq_cache_o_stream
    #pragma HLS interface axis port=ks_cache_i_stream
    #pragma HLS interface axis port=ks_cache_o_stream
    #pragma HLS interface axis port=vq_cache_i_stream
    #pragma HLS interface axis port=vq_cache_o_stream
    #pragma HLS interface axis port=vs_cache_i_stream
    #pragma HLS interface axis port=vs_cache_o_stream

    #pragma HLS aggregate variable=kq_cache_i_stream compact=bit
    #pragma HLS aggregate variable=kq_cache_o_stream compact=bit
    #pragma HLS aggregate variable=ks_cache_i_stream compact=bit
    #pragma HLS aggregate variable=ks_cache_o_stream compact=bit
    #pragma HLS aggregate variable=vq_cache_i_stream compact=bit
    #pragma HLS aggregate variable=vq_cache_o_stream compact=bit
    #pragma HLS aggregate variable=vs_cache_i_stream compact=bit

    #pragma HLS dataflow

    // rd_k_cache(l_begin, l_close, pos_id, memory_k_cache, kq_cache_i_stream, ks_cache_i_stream);
    // rd_v_cache(l_begin, l_close, pos_id, memory_v_cache, vq_cache_i_stream, vs_cache_i_stream);
    // wr_k_cache(l_begin, l_close, pos_id, memory_k_cache, kq_cache_o_stream, ks_cache_o_stream);
    // wr_v_cache(l_begin, l_close, pos_id, memory_v_cache, vq_cache_o_stream, vs_cache_o_stream);

    rd_kv_cache(l_begin, l_close, pos_id, memory_k_cache, kq_cache_i_stream, ks_cache_i_stream, vq_cache_i_stream, vs_cache_i_stream);

    wr_kv_cache(l_begin, l_close, pos_id, memory_k_cache, kq_cache_o_stream, ks_cache_o_stream, vq_cache_o_stream, vs_cache_o_stream);
}