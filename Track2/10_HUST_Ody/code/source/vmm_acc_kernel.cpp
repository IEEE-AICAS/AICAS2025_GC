#include <hls_stream.h>
#include <ap_int.h>
#include <hls_math.h>

#define D 128
#define N 896
#define GS 64

void load_data(
    int8_t* x, float* xs,int8_t* w0, int8_t* w1,float* ws,int8_t local_x[N],
    float local_xs[N / GS],ap_uint<512> local_w512[D][N / 64],float local_ws[D][N / GS]) {
#pragma HLS INLINE
    // Load x
    for (int i = 0; i < N; i++) {
    #pragma HLS PIPELINE II=1
    #pragma HLS UNROLL factor=8
        local_x[i] = x[i];
    }

    // Load xs
    for (int i = 0; i < N / GS; i++) {
        local_xs[i] = xs[i];
    }

    // Load weights (from 2 axi ports w0 and w1)
    const int words_per_row = N / 64;  // 14
    const int half_d = D / 2;          // 64
    ap_uint<512>* w0_512 = reinterpret_cast<ap_uint<512>*>(w0);  //we load width=512b at a time, i.e. load 64 elements of w
    ap_uint<512>* w1_512 = reinterpret_cast<ap_uint<512>*>(w1);

    for (int i = 0; i < half_d; i++) {
    #pragma HLS PIPELINE II=14
        for (int j = 0; j < words_per_row; j++) {
    #pragma HLS UNROLL //load w form 2 axi ports
            int idx = i * words_per_row + j;
            local_w512[i][j]          = w0_512[idx];       // first half
            local_w512[i + half_d][j] = w1_512[idx];       // second half
        }
    }


    // Load ws
    for (int i = 0; i < D; i++) {
    #pragma HLS PIPELINE II=7
        for (int j = 0; j < N / GS; j++) {
        #pragma HLS UNROLL
            local_ws[i][j] = ws[i * (N / GS) + j];
        }
    }
}

void compute_matmul(
    float* xout,int8_t local_x[N], float local_xs[N / GS], ap_uint<512> local_w512[D][N / 64], float local_ws[D][N / GS]) {
//#pragma HLS INLINE
    for (int i = 0; i < D; i++) {
    #pragma HLS PIPELINE II=3

        float partial_results[N / GS];

        for (int j = 0; j < N; j += GS) {
            int32_t isum = 0;
            int chunk = j / 64;
            ap_uint<512> w_word = local_w512[i][chunk];

            for (int k = 0; k < GS; k++) {
            #pragma HLS UNROLL
                int offset = (j + k) % 64;
                ap_uint<8> byte = w_word.range((offset + 1) * 8 - 1, offset * 8); 
                int8_t w_val = (int8_t)byte;
                isum += local_x[j + k] * w_val;
            }

            partial_results[j / GS] = (float)isum * local_ws[i][j / GS] * local_xs[j / GS];
        }

        // Tree-based reduction
        float stage1[7];
        #pragma HLS ARRAY_PARTITION variable=stage1 complete
        for (int i = 0; i < 7; i++) {
        #pragma HLS UNROLL
            stage1[i] = partial_results[2 * i] + partial_results[2 * i + 1];
        }

        float stage2[4];
        #pragma HLS ARRAY_PARTITION variable=stage2 complete
        for (int i = 0; i < 3; i++) {
        #pragma HLS UNROLL
            stage2[i] = stage1[2 * i] + stage1[2 * i + 1];
        }
        stage2[3] = stage1[6];

        float stage3_0 = stage2[0] + stage2[1];
        float stage3_1 = stage2[2] + stage2[3];

        xout[i] = stage3_0 + stage3_1;
    }
}

void matmul(float* xout, int8_t* x, float* xs, int8_t* w0, int8_t* w1, float* ws) {
#pragma HLS INTERFACE m_axi port=xout bundle=gmem0 depth=128 max_widen_bitwidth=512
#pragma HLS INTERFACE m_axi port=x  bundle=gmem0 depth=896 max_widen_bitwidth=128
#pragma HLS INTERFACE m_axi port=xs bundle=gmem1 depth=14 max_widen_bitwidth=128
#pragma HLS INTERFACE m_axi port=w0  bundle=gmem2 depth=57344 max_widen_bitwidth=512
#pragma HLS INTERFACE m_axi port=w1  bundle=gmem3 depth=57344 max_widen_bitwidth=512
#pragma HLS INTERFACE m_axi port=ws  bundle=gmem4 depth=1792 max_widen_bitwidth=512
#pragma HLS INTERFACE s_axilite port=xout bundle=control
#pragma HLS INTERFACE s_axilite port=x    bundle=control
#pragma HLS INTERFACE s_axilite port=xs   bundle=control
#pragma HLS INTERFACE s_axilite port=w0   bundle=control
#pragma HLS INTERFACE s_axilite port=w1   bundle=control
#pragma HLS INTERFACE s_axilite port=ws   bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control
#pragma HLS INTERFACE ap_ctrl_hs port=return


    int8_t local_x[N];
    float local_xs[N / GS];
    ap_uint<512> local_w512[D][N / 64];
    float local_ws[D][N / GS];

#pragma HLS bind_storage variable=local_w512 type=ram_1p impl=uram
#pragma HLS ARRAY_PARTITION variable=local_x cyclic factor=8 dim=1
#pragma HLS ARRAY_PARTITION variable=local_xs complete dim=1
#pragma HLS ARRAY_PARTITION variable=local_w512 cyclic factor=6 dim=2
#pragma HLS ARRAY_PARTITION variable=local_ws complete dim=2


    load_data(x, xs, w0, w1, ws, local_x, local_xs, local_w512, local_ws);

    compute_matmul(xout, local_x, local_xs, local_w512, local_ws);

    return;
}
