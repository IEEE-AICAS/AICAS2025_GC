#ifndef __INT_UTILS_H__
#define __INT_UTILS_H__

#include <stack>
using namespace std;


// ********************************************************
// ****************  DESIGN UTILS  ************************

constexpr int gcd(int a, int b) {
    return (b == 0) ? a : gcd(b, a % b);
}

constexpr int lcm(int a, int b) {
    return a / gcd(a, b) * b;
}


template <typename T>
constexpr const T& const_max(const T& a) {
    return a;
}
template <typename T, typename... Args>
constexpr std::common_type_t<T, Args...> const_max(const T& a, const Args&... args) {
    auto m = const_max(args...);
    return (a > m) ? a : m;
}
template <typename T>
constexpr const T& const_min(const T& a) {
    return a;
}
template <typename T, typename... Args>
constexpr std::common_type_t<T, Args...> const_min(const T& a, const Args&... args) {
    auto m = const_min(args...);
    return (a < m) ? a : m;
}


template<typename _typename, typename _val_t>
_typename clamp(_typename val, _val_t min_val, _val_t max_val) {
    if (val < min_val) return min_val;
    if (val > max_val) return max_val;
    return val;
}


template<typename _typename>
_typename quantize_clamp(_typename val, int bits, bool is_signed) {
    int min_val, max_val;
    if (is_signed) {
        min_val = -(1 << (bits - 1));
        max_val = +(1 << (bits - 1)) - 1;
    } else {
        min_val = 0;
        max_val = (1 << bits) - 1;
    }
    return clamp(val, min_val, max_val);
}


template<
    class data_t,
    int T,
    int C,
    int CP>
void pack_tokens(
    hls::stream<hls::vector<data_t, CP> >& data_stream,
    data_t buffer[T][C]
){
    // some constexprs
    //* core feature of our design, fully unroll token dim
    constexpr int CT      = C / CP;

    for(int ct=0; ct<CT; ++ct){
        for(int t=0; t<T; ++t){
            #pragma HLS pipeline II=1
            // read data
            hls::vector<data_t, CP> data_vec = data_stream.read();
            // write to buffer
            for(int cp=0; cp<CP; ++cp){
                #pragma HLS unroll
                buffer[t][ct*CP + cp] = data_vec[cp];
            }
        } // end of t loop
    } // end of CT loop
}


template<
    class data_t,
    int T,
    int TP,
    int C,
    int CP>
void buffer_tokens(
    hls::stream<hls::vector<data_t, TP*CP> >& data_stream,
    data_t buffer[T][C]
){
    // some constexprs
    constexpr int TT = T / TP;
    constexpr int CT = C / CP;

    for(int tt=0; tt<TT; ++tt){
        for(int ct=0; ct<CT; ++ct){
            #pragma HLS pipeline II=1
            // read data
            hls::vector<data_t, TP*CP> data_vec = data_stream.read();
            // write to buffer
            for(int tp=0; tp<TP; ++tp){
                for(int cp=0; cp<CP; ++cp){
                    #pragma HLS unroll
                    buffer[tt*TP + tp][ct*CP + cp] = data_vec[tp*CP + cp];
                }
            } // end of TP loop
        } // end of CT loop
    } // end of TT loop
}



template<
    class data_t,
    int T,
    int TP,
    int C,
    int CP>
void retile_tokens(
    data_t buffer[T][C],
    hls::stream<hls::vector<data_t, TP*CP> >& data_stream
){
    hls::vector<data_t, TP*CP> data_vec;

    // some constexprs
    constexpr int TT = T / TP;
    constexpr int CT = C / CP;

    for(int tt=0; tt<TT; ++tt){
        for(int ct=0; ct<CT; ++ct){
            #pragma HLS pipeline II=1
            // read from buffer
            for(int tp=0; tp<TP; ++tp){
                for(int cp=0; cp<CP; ++cp){
                    #pragma HLS unroll
                    data_vec[tp*CP + cp] = buffer[tt*TP + tp][ct*CP + cp];
                }
            }
            // write to stream
            data_stream.write(data_vec);
        } // end of CT loop
    } // end of TT loop
}


template<
    class data_t,
    int R,
    int T,
    int TP,
    int C,
    int CP>
void repeat_x_tokens(
    hls::stream<hls::vector<data_t, TP*CP> >& data_stream,
    hls::stream<hls::vector<data_t, TP*CP> >& data_stream_repeat
){
    constexpr int TT = T / TP;
    constexpr int CT = C / CP;
    data_t buffer[TT][CT][TP][CP];
    #pragma HLS array_reshape variable=buffer complete dim=3
    #pragma HLS array_reshape variable=buffer complete dim=4

    for(int tt=0; tt<TT; ++tt){
        for(int repeat=0; repeat<R; ++repeat){ // repeat inside TT loop to generate all output channels
            for(int ct=0; ct<CT; ++ct){
                #pragma HLS pipeline II=1

                hls::vector<data_t, TP*CP> data_vec;
                if(repeat == 0){ 
                    // read and store first
                    data_vec = data_stream.read();
                    for(int tp=0; tp<TP; ++tp){
                        for(int cp=0; cp<CP; ++cp){
                            #pragma HLS unroll
                            buffer[tt][ct][tp][cp] = data_vec[tp*CP + cp];
                        }
                    }
                } else {
                    // generate output
                    for(int tp=0; tp<TP; ++tp){
                        for(int cp=0; cp<CP; ++cp){
                            #pragma HLS unroll
                            data_vec[tp*CP + cp] = buffer[tt][ct][tp][cp];
                        }
                    }
                }

                data_stream_repeat.write(data_vec);

            }
        }
    }
}


// array input version of repeat_x_tokens
template<
    class data_t,
    int R,
    int T,
    int TP,
    int C,
    int CP>
void repeat_x_tokens(
    data_t src[T][C],
    hls::stream<hls::vector<data_t, TP*CP> >& data_stream_repeat
){
    constexpr int TT = T / TP;
    constexpr int CT = C / CP;

    for(int tt=0; tt<TT; ++tt){
        for(int repeat=0; repeat<R; ++repeat){ // repeat inside TT loop to generate all output channels
            for(int ct=0; ct<CT; ++ct){
                #pragma HLS pipeline II=1

                // always use src array
                hls::vector<data_t, TP*CP> data_vec;
                for(int tp=0; tp<TP; ++tp){
                    for(int cp=0; cp<CP; ++cp){
                        #pragma HLS unroll
                        data_vec[tp*CP + cp] = src[tt*TP + tp][ct*CP + cp];
                    }
                }

                data_stream_repeat.write(data_vec);

            }
        }
    }
}


template<
    class data_t,
    int R,
    int T,
    int TP,
    int C,
    int CP>
void repeat_w_tokens(
    hls::stream<hls::vector<data_t, TP*CP> >& data_stream,
    hls::stream<hls::vector<data_t, TP*CP> >& data_stream_repeat
){
    constexpr int TT = T / TP;
    constexpr int CT = C / CP;
    data_t buffer[TT][CT][TP][CP];
    #pragma HLS array_reshape variable=buffer complete dim=3
    #pragma HLS array_reshape variable=buffer complete dim=4

    for(int repeat=0; repeat<R; ++repeat){ // repeat outside TT loop to generate all output tokens
        for(int tt=0; tt<TT; ++tt){
            for(int ct=0; ct<CT; ++ct){
                #pragma HLS pipeline II=1

                hls::vector<data_t, TP*CP> data_vec;
                if(repeat == 0){ 
                    // read and store first
                    data_vec = data_stream.read();
                    for(int tp=0; tp<TP; ++tp){
                        for(int cp=0; cp<CP; ++cp){
                            #pragma HLS unroll
                            buffer[tt][ct][tp][cp] = data_vec[tp*CP + cp];
                        }
                    }
                } else {
                    // generate output
                    for(int tp=0; tp<TP; ++tp){
                        for(int cp=0; cp<CP; ++cp){
                            #pragma HLS unroll
                            data_vec[tp*CP + cp] = buffer[tt][ct][tp][cp];
                        }
                    }
                }

                data_stream_repeat.write(data_vec);

            }
        }
    }
}


template<
    class data_t,
    int R,
    int T,
    int TP,
    int C,
    int CP>
void repeat_w_tokens(
    data_t src[T][C],
    hls::stream<hls::vector<data_t, TP*CP> >& data_stream_repeat
){
    constexpr int TT = T / TP;
    constexpr int CT = C / CP;

    for(int repeat=0; repeat<R; ++repeat){ // repeat outside TT loop to generate all output tokens
        for(int tt=0; tt<TT; ++tt){
            for(int ct=0; ct<CT; ++ct){
                #pragma HLS pipeline II=1

                // always use src array
                hls::vector<data_t, TP*CP> data_vec;
                for(int tp=0; tp<TP; ++tp){
                    for(int cp=0; cp<CP; ++cp){
                        #pragma HLS unroll
                        data_vec[tp*CP + cp] = src[tt*TP + tp][ct*CP + cp];
                    }
                }

                data_stream_repeat.write(data_vec);

            }
        }
    }
}


template<
    class data_t,
    int T,
    int TP,
    int C,
    int CP>
void transpose_tokens(
    data_t buffer[T][C],
    hls::stream<hls::vector<data_t, CP*TP> >& data_stream
){
    #pragma HLS array_reshape variable=buffer cyclic factor=TP dim=2
    hls::vector<data_t, CP*TP> data_vec;

    // some constexprs
    constexpr int TT = T / TP;
    constexpr int CT = C / CP;

    // transpose, loop nest order: 
    // TT -> CT -> TP -> CP 
    // => 
    // CT -> TT -> CP -> TP
    for(int ct=0; ct<CT; ++ct){
        for(int tt=0; tt<TT; ++tt){
            #pragma HLS pipeline II=1
            // read from buffer
            for(int cp=0; cp<CP; ++cp){
                for(int tp=0; tp<TP; ++tp){
                    #pragma HLS unroll
                    // data_vec[cp*TP + tp] = buffer[(tt*TP + tp)*C + ct*CP + cp];
                    data_vec[cp*TP + tp] = buffer[tt*TP + tp][ct*CP + cp];
                }
            }
            // write to stream
            data_stream.write(data_vec);
        }
    }
}


template<
    class data_t,
    int T,
    int TP,
    int C,
    int CP>
void transpose_tokens(
    data_t src[T][C],
    data_t dst[C][T]
){
    // some constexprs
    constexpr int TT = T / TP;
    constexpr int CT = C / CP;

    // transpose, loop nest order: 
    // TT -> CT -> TP -> CP 
    // => 
    // CT -> TT -> CP -> TP
    for(int ct=0; ct<CT; ++ct){
        for(int tt=0; tt<TT; ++tt){
            #pragma HLS pipeline II=1
            for(int cp=0; cp<CP; ++cp){
                for(int tp=0; tp<TP; ++tp){
                    #pragma HLS unroll
                    dst[ct*CP + cp][tt*TP + tp] = src[tt*TP + tp][ct*CP + cp];
                }
            }
        }
    }
}


template<
    class data_t,
    int T,
    int S,
    int C,
    int CP>
void update_k_cache(
    int pos,
    hls::stream<hls::vector<data_t, CP> >& i_stream,         // unpacked input stream, from GEMM
    hls::stream<hls::vector<data_t, CP> >& cache_i_stream,
    hls::stream<hls::vector<data_t, CP> >& cache_o_stream,
    data_t cache[S][C]
){
    // consts
    constexpr int CT = C / CP;

    // pack cache
    buffer_tokens<data_t, S, 1, C, CP>(cache_i_stream,  cache);

    // overwrite cur to cache, with given pos, unpacked order to read in
    for(int ct=0; ct<CT; ++ct){
        for(int t=0; t<T; ++t){
            // #pragma HLS pipeline II=1
            #pragma HLS pipeline off
            hls::vector<data_t, CP> cache_vec = i_stream.read();
            for(int cp=0; cp<CP; ++cp){
                #pragma HLS unroll
                cache[pos+t][ct*CP + cp] = cache_vec[cp];
            }
        }
    }

    // write cache_o_stream, normal order
    for(int t=0; t<T; ++t){
        for(int ct=0; ct<CT; ++ct){
            #pragma HLS pipeline II=1
            hls::vector<data_t, CP> cache_vec;
            for(int cp=0; cp<CP; ++cp){
                #pragma HLS unroll
                cache_vec[cp] = cache[pos+t][ct*CP + cp];
            }
            cache_o_stream.write(cache_vec);
        }
    }
}


template<
    class data_t,
    int C,
    int T,
    int S,
    int SP>
void update_v_cache(
    int pos,
    hls::stream<hls::vector<data_t, SP> >& i_stream,
    hls::stream<hls::vector<data_t, SP> >& cache_i_stream,
    hls::stream<hls::vector<data_t, SP> >& cache_o_stream,
    data_t cache[C][S]
){
    // consts
    constexpr int TST = T / SP;
    int s_pos = pos / SP;

    // pack cache
    buffer_tokens<data_t, C, 1, S, SP>(cache_i_stream,  cache);

    // overwrite cur to cache, with given pos, since input is already packed and transposed, normal order
    for(int c=0; c<C; ++c){
        for(int tst=0; tst<TST; ++tst){
            #pragma HLS pipeline II=1
            hls::vector<data_t, SP> cache_vec = i_stream.read();
            for(int sp=0; sp<SP; ++sp){
                #pragma HLS unroll
                cache[c][(s_pos+tst)*SP + sp] = cache_vec[sp];
            }
            cache_o_stream.write(cache_vec);
        }
    }
}



template<
    class data_t,
    int H,
    int T,
    int TP,
    int C,
    int CP>
void split_interleaved_streams(
    hls::stream<hls::vector<data_t, TP*CP> >& i_stream,
    hls::stream<hls::vector<data_t, TP*CP> >& o_stream1,
    hls::stream<hls::vector<data_t, TP*CP> >& o_stream2
){
    // some constexprs
    constexpr int TT = T / TP;
    constexpr int CT = C / CP;

    for(int h=0; h<H; ++h){
        for(int stream_id=0; stream_id<2; ++stream_id){
            for(int tt=0; tt<TT; ++tt){
                for(int ct=0; ct<CT; ++ct){
                    #pragma HLS pipeline II=1
                    // read from input stream
                    hls::vector<data_t, TP*CP> i_vec = i_stream.read();
                    // write to output stream
                    if(stream_id == 0){
                        o_stream1.write(i_vec);
                    } else {
                        o_stream2.write(i_vec);
                    }
                } // end of CT loop
            } // end of TT loop
        } // end of stream_id loop
    }

}



// ********************************************************
// ****************  SIMULATION UTILS  ********************



template<typename _typename>
vector<_typename> read_tensor(const std::string &file_path) {
    std::ifstream file(file_path, std::ios::binary | std::ios::ate);
    if (!file.is_open()) {
        std::cerr << "Cannot open file: " << file_path << std::endl;
        exit(1);
    }

    std::streamsize size = file.tellg();
    file.seekg(0, std::ios::beg);

    vector<_typename> tensor(size / sizeof(_typename));

    if (!file.read(reinterpret_cast<char *>(tensor.data()), size)) {
        std::cerr << "Cannot read file: " << file_path << std::endl;
        exit(1);
    }

    return tensor;
}




template<typename _typename>
void save_tensor(const std::string &file_path, const vector<_typename> &tensor) {
    std::ofstream file(file_path, std::ios::binary);
    if (!file.is_open()) {
        std::cerr << "Cannot open file: " << file_path << std::endl;
        exit(1);
    }

    file.write(reinterpret_cast<const char *>(tensor.data()), tensor.size() * sizeof(_typename));
}




template<typename _typename>
void save_tensor(const std::string &file_path, const _typename *tensor, size_t size) {
    std::ofstream file(file_path, std::ios::binary);
    if (!file.is_open()) {
        std::cerr << "Cannot open file: " << file_path << std::endl;
        exit(1);
    }

    file.write(reinterpret_cast<const char *>(tensor), size * sizeof(_typename));
}



// random number generator
int rand_int(int b, bool is_signed) {
    // Create a random number generator and distribution
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dist(0, (1 << b) - 1);

    // Generate a random number in the range [0, 2^b - 1]
    int r = dist(gen);

    // If signed, shift the range to [-2^(b-1), 2^(b-1) - 1]
    if (is_signed) {
        r -= (1 << (b - 1));
    }
    return r;
}


class ProgressBar {
private:
    std::string info;
    int total;
    int current;

    int time_start;
    int time_end;

    int last_percentage;  // 记录上一次打印时的百分比

public:
    ProgressBar(const std::string& _info, int _total)
        : info(_info), total(_total), current(0), time_start(0), time_end(-1), last_percentage(-10) {}

    void update(int step) {
        current += step;
        int percentage = static_cast<int>((current * 100.0) / total);

        // 检查是否超过10%的进度
        if (percentage - last_percentage >= 10 || current >= total) {
            last_percentage = percentage;

            int progress = static_cast<int>((50 * current) / total);
            std::string bar(progress, '=');
            bar.append(50 - progress, ' ');

            // 获取当前时间
            time_end = clock();
            // 估算剩余时间
            int elapsed = time_end - time_start;
            int remaining = (current > 0) ? elapsed * (total - current) / current : 0;
            int total_time = elapsed + remaining;

            std::cerr << "\r[" << std::string(info).append(20 - info.length(), ' ')
                      << "][" << bar << "] " << percentage << "%  "
                      << "Estimated total time: " << total_time / 1000 << "s, "
                      << "Estimated remaining time: " << remaining / 1000 << "s";

            if (current >= total) {
                std::cerr << std::endl;  // 进度完成后换行
            }
        }
    }

    void start() {
        current = 0;
        time_start = clock();
        last_percentage = -10;  // 重置上一次打印的进度
    }

    void finish() {
        update(total - current);  // 完成进度条
    }
};



template<class data_t>
void tensor2array(
    vector<data_t>& tensor,
    data_t array[],
    int H_LOAD,
    int H,
    int T_LOAD,
    int T,
    int C_LOAD,
    int C
){
    // check tensor size
    // assert(tensor.size() == H_LOAD * T_LOAD * C_LOAD);
    if(tensor.size() != H_LOAD * T_LOAD * C_LOAD){
        std::cerr << "tensor size: " << tensor.size() << " != " << H_LOAD * T_LOAD * C_LOAD << std::endl;
        std::cerr << "H_LOAD: " << H_LOAD << ", T_LOAD: " << T_LOAD << ", C_LOAD: " << C_LOAD << std::endl;
        exit(1);
    }
    // put the data into array
    for(int h=0; h<H && h<H_LOAD; ++h){
        for(int t=0; t<T && t<T_LOAD; ++t){
            for(int c=0; c<C && c<C_LOAD; ++c){
                array[h*T*C + t*C + c] = tensor[h*T_LOAD*C_LOAD + t*C_LOAD + c];
            }
        }
    }
}


template<class data_t>
void tensor2array(
    vector<data_t>& tensor,
    data_t array[],
    int H_LOAD,
    int H,
    int T_LOAD,
    int T_START,
    int T,
    int C_LOAD,
    int C
){
    // check tensor size
    if(tensor.size() != H_LOAD * T_LOAD * C_LOAD){
        std::cerr << "tensor size: " << tensor.size() << " != " << H_LOAD * T_LOAD * C_LOAD << std::endl;
        std::cerr << "H_LOAD: " << H_LOAD << ", T_LOAD: " << T_LOAD << ", C_LOAD: " << C_LOAD << std::endl;
        exit(1);
    }
    // put the data into array
    for(int h=0; h<H && h<H_LOAD; ++h){
        for(int t=0; t<T && t<T_LOAD; ++t){
            for(int c=0; c<C && c<C_LOAD; ++c){
                array[h*T*C + t*C + c] = tensor[h*T_LOAD*C_LOAD + (t+T_START)*C_LOAD + c];
            }
        }
    }
}



template<class data_t>
void split_heads(
    data_t array[],
    int H,
    int T,
    int C
){
    // shape: (T, H, C) -> (H, T, C)
    data_t tmp_array[H*T*C];
    for(int h=0; h<H; ++h){
        for(int t=0; t<T; ++t){
            for(int c=0; c<C; ++c){
                tmp_array[h*T*C + t*C + c] = array[t*H*C + h*C + c];
            }
        }
    }
    for(int h=0; h<H; ++h){
        for(int t=0; t<T; ++t){
            for(int c=0; c<C; ++c){
                array[h*T*C + t*C + c] = tmp_array[h*T*C + t*C + c];
            }
        }
    }
}

template<class data_t>
void merge_heads(
    data_t array[],
    int H,
    int T,
    int C
){
    // shape: (H, T, C) -> (T, H, C)
    data_t tmp_array[H*T*C];
    for(int h=0; h<H; ++h){
        for(int t=0; t<T; ++t){
            for(int c=0; c<C; ++c){
                tmp_array[t*H*C + h*C + c] = array[h*T*C + t*C + c];
            }
        }
    }
    for(int h=0; h<H; ++h){
        for(int t=0; t<T; ++t){
            for(int c=0; c<C; ++c){
                array[t*H*C + h*C + c] = tmp_array[t*H*C + h*C + c];
            }
        }
    }
}


template<class data_t>
void truncate(data_t array[], int size, int trunc){
    for(int i=0; i<size; ++i){
        array[i] = array[i] >> trunc;
    }
}

template<class data_t>
void upshift(data_t array[], int size, int shift){
    for(int i=0; i<size; ++i){
        array[i] <<= shift;
    }
}


// a function to put the data into stream
template<
    class data_t,
    class stream_t,
    int REPEAT,
    int H,      // number of heads, for single op, H=1
    int T,
    int TP,
    int C,
    int CP>
void array2stream(
    data_t data[],
    hls::stream<hls::vector<stream_t, TP*CP> >& stream,
    const string& info = "",
    bool verbose=false
){
    int TT = T / TP;
    int CT = C / CP;

    // instantiate a progress bar
    ProgressBar progress_bar(info, H*TT);

    progress_bar.start();

    for(int h=0; h<H; ++h){
        for(int tt=0; tt<TT; ++tt){
            // update the progress bar
            if(verbose) progress_bar.update(1);

            for(int repeat=0; repeat<REPEAT; ++repeat){
                for(int ct=0; ct<CT; ++ct){
                    // write the data to stream
                    hls::vector<stream_t, TP*CP> vec;
                    for(int tp=0; tp<TP; ++tp){
                        for(int cp=0; cp<CP; ++cp){
                            vec[tp*CP + cp] = data[h*T*C + (tt*TP + tp)*C + ct*CP + cp];
                        }
                    }
                    stream.write(vec);
                }
            }
        }
    }
}


template<
    class data_t,
    class stream_t,
    int REPEAT,
    int H,      // number of heads, for single op, H=1
    int T,
    int GEMM_TP,
    int C,
    int CP>
void array2stream_unpack(
    data_t data[],
    hls::stream<hls::vector<stream_t, CP> >& stream,
    const string& info = "",
    bool verbose=false
){
    int TT = T / GEMM_TP;
    int CT = C / CP;

    // instantiate a progress bar
    ProgressBar progress_bar(info, H*TT);

    progress_bar.start();

    for(int h=0; h<H; ++h){
        for(int tt=0; tt<TT; ++tt){
            // update the progress bar
            if(verbose) progress_bar.update(1);
            for(int repeat=0; repeat<REPEAT; ++repeat){
                for(int ct=0; ct<CT; ++ct){
                    // unpacked
                    for(int tp=0; tp<GEMM_TP; ++tp){
                        hls::vector<stream_t, CP> vec;
                        for(int cp=0; cp<CP; ++cp){
                            vec[cp] = data[h*T*C + (tt*GEMM_TP + tp)*C + ct*CP + cp];
                        }
                        stream.write(vec);
                    }
                }
            }
        }
    }
}


template<
    class data_t,
    class stream_t,
    int H,
    int T,
    int TP,
    int C,
    int CP>
void stream2array(
    hls::stream<hls::vector<stream_t, TP*CP> >& stream,
    data_t data[H*T*C],
    const string& info="",
    bool verbose=false
){
    int TT = T / TP;
    int CT = C / CP;

    // instantiate a progress bar
    ProgressBar progress_bar(info, H*TT);

    progress_bar.start();

    for(int h=0; h<H; ++h){
        for(int tt=0; tt<TT; ++tt){
            // update the progress bar
            if(verbose) progress_bar.update(1);
            for(int ct=0; ct<CT; ++ct){
                // read the data from stream
                hls::vector<stream_t, TP*CP> tmp_vec = stream.read();
                for(int tp=0; tp<TP; ++tp){
                    for(int cp=0; cp<CP; ++cp){
                        data[h*T*C + (tt*TP + tp)*C + ct*CP + cp] = tmp_vec[tp*CP + cp];
                    }
                }
            }
        }
    }
}


template<
    class data_t,
    class stream_t,
    int H,
    int T,
    int GEMM_TP,
    int C,
    int CP>
void stream2array_unpack(
    // GEMM_TP unpacked
    hls::stream<hls::vector<stream_t, CP> >& stream,
    data_t data[H*T*C],
    const string& info="",
    bool verbose=false
){
    int TT = T / GEMM_TP;
    int CT = C / CP;

    // instantiate a progress bar
    ProgressBar progress_bar(info, H*TT);

    progress_bar.start();

    for(int h=0; h<H; ++h){
        for(int tt=0; tt<TT; ++tt){
            // update the progress bar
            if(verbose) progress_bar.update(1);
            for(int ct=0; ct<CT; ++ct){
                // unpack or not?
                for(int tp=0; tp<GEMM_TP; ++tp){
                    // read the data from stream
                    hls::vector<stream_t, CP> tmp_vec = stream.read();
                    for(int cp=0; cp<CP; ++cp){
                        data[h*T*C + (tt*GEMM_TP + tp)*C + ct*CP + cp] = tmp_vec[cp];
                    }
                }
            }
        }
    }
}


template<class stream_t, int P>
void stream2stream(
    hls::stream<hls::vector<stream_t, P> >& i_stream,
    hls::stream<hls::vector<stream_t, P> >& o_stream
){
    while(!i_stream.empty()){
        o_stream.write(i_stream.read());
    }
}

template<class stream_t, int TENSOR_SIZE, int P>
void stream2stream(
    hls::stream<hls::vector<stream_t, P> >& i_stream,
    hls::stream<hls::vector<stream_t, P> >& o_stream
){
    static_assert(TENSOR_SIZE % P == 0, "TENSOR_SIZE must be multiple of P");
    int NUM_TILE = TENSOR_SIZE / P;
    for(int i=0; i<NUM_TILE; ++i){
        o_stream.write(i_stream.read());
    }
}


template<class data_t>
void compare(
    data_t data1[],
    data_t data2[],
    int N,
    const string& info,
    bool verbose=false
){
    bool match = true;
    // const int MAX_MISMATCH = 500;
    const int MAX_MISMATCH = 1e8;
    int mismatch_count = 0;
    for(int i=0; i<N; ++i){
        if(data1[i] != data2[i]){
            printf("%s mismatch at [%5d]: %5d vs %5d\n", info.c_str(), i, data1[i], data2[i]);
            match = false;
            mismatch_count++;
        }
        if(!match && mismatch_count > MAX_MISMATCH){
            break;
        }
    }
    if(match){
        if(verbose){
            printf("%s match\n", info.c_str());
        }
    } else {
        printf("%s mismatch, mismatch number is %d\n", info.c_str(), mismatch_count);
    }
}



template<typename data_t, typename stream_t, int TENSOR_SIZE, int P>
void save_condensed_tensor(
    const std::string &file_path, 
    hls::stream<hls::vector<stream_t, P> >& stream
){
    // number of tiles
    static_assert(TENSOR_SIZE % P == 0, "TENSOR_SIZE must be multiple of P");
    int NUM_TILE = TENSOR_SIZE / P;
    // create a vector
    static data_t condensed_array[TENSOR_SIZE];
    // read stream, and put it to vector
    stream2array<data_t, stream_t, 1, 1, 1, TENSOR_SIZE, P>(stream, condensed_array);
    // save tensor
    save_tensor<data_t>(file_path, condensed_array, TENSOR_SIZE);
    // read tensor
    vector<data_t> condensed_tensor_read = read_tensor<data_t>(file_path);
    tensor2array<data_t>(condensed_tensor_read, condensed_array, 1, 1, 1, 1, TENSOR_SIZE, TENSOR_SIZE);
    // write back to stream
    array2stream<data_t, stream_t, 1, 1, 1, 1, TENSOR_SIZE, P>(condensed_array, stream);
}


template<typename data_t>
void print_ap_int(data_t data){
    constexpr int W = data_t::width;
    stack<int> st;
    // print in hex
    while(data != 0){
        int lo = data & 0xf;
        // printf("%x", lo);
        st.push(lo);
        data = data >> 4;
    }
    while(!st.empty()){
        int lo = st.top();
        printf("%x", lo);
        st.pop();
    }
}


template<typename data_t, int P, int N>
void print_stream(
    hls::stream<hls::vector<data_t, P> >& stream,
    const string& info
){
    // calculate the total bits of a vector
    constexpr int V = data_t::width * P;
    typedef ap_uint<V> vec_t;
    hls::stream<hls::vector<data_t, P> > stream_copy("stream_copy");
    printf("************************** %s **************************\n", info.c_str());
    // copy the stream
    while(!stream.empty()){
        stream_copy.write(stream.read());
    }
    for(int n=0; n<N; ++n){
        hls::vector<data_t, P> vec = stream_copy.read();
        // put back
        stream.write(vec);
        // concat the vector to a single vec_t, smaller index on lower bits
        vec_t vec_concat = 0;

        for(int p=0; p<P; ++p){
            vec_concat = (vec_concat << data_t::width) | vec[P-1-p].range(data_t::width-1, 0);
        }
        // print in hex
        print_ap_int(vec_concat);
        printf("\n");
    }
    // put back the rest
    while(!stream_copy.empty()){
        stream.write(stream_copy.read());
    }
    printf("********************************************************\n");
}



#endif
