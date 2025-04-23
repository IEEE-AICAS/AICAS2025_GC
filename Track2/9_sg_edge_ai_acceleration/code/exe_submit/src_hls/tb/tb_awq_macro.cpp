//main.cpp
#include "awq_macro.h"
#include <iostream>
#include <cstdlib>
#include <cmath>
#include <hls_vector.h>

using namespace std;

const float EPSILON = 1e-5;

// Function to generate half-precision float as uint16_t
uint16_t generate_half(float value) {
    uint32_t f = *reinterpret_cast<uint32_t*>(&value);
    uint16_t h = 
        ((f >> 16) & 0x8000) |                         // Sign bit
        ((((f & 0x7f800000) - 0x38000000) >> 13)) |    // Exponent
        ((f & 0x007fffff) >> 13);                      // Mantissa
    return h;
}

int main() {
    const uint16_t row = 2;
    const uint16_t num_xi = row * _MACRO_H;                // 128 floats
    const uint16_t macro_size_u32 = _MACRO_SIZE_U32;       // 72 uint32_t per row

    // Allocate and initialize xi array (all 1.0f)
    float *xi = (float*)aligned_alloc(16, num_xi * sizeof(float));
    fill_n(xi, num_xi, 1.0f);

    // Function to initialize macro parameters
    auto init_macro = [](uint32_t* macro, int rows) {
        for (int r = 0; r < rows; ++r) {
            // pzero_val: 8 4-bit values (0-7)
            macro[r * _MACRO_SIZE_U32 + 0] = 0x01234567;
            
            // pscale: 8 scales of 1.0 (half-precision 0x3C00)
            for (int j = 0; j < 4; ++j) {
                macro[r * _MACRO_SIZE_U32 + 4 + j] = 
                    (generate_half(1.0f) << 16) | generate_half(1.0f);
            }
            
            // weight_val: Weights as mod 8 of input index
            for (int i = 0; i < _MACRO_H; ++i) {
                uint8_t wvals[8] = {i%8, i%8, i%8, i%8, i%8, i%8, i%8, i%8};
                macro[r * _MACRO_SIZE_U32 + 8 + i] = 
                    (wvals[7] << 28) | (wvals[6] << 24) |
                    (wvals[5] << 20) | (wvals[4] << 16) |
                    (wvals[3] << 12) | (wvals[2] << 8) |
                    (wvals[1] << 4)  | wvals[0];
            }
        }
    };

    // Allocate and initialize macro parameter arrays
    uint32_t *macro0 = new uint32_t[row * macro_size_u32]();
    uint32_t *macro1 = new uint32_t[row * macro_size_u32]();
    uint32_t *macro2 = new uint32_t[row * macro_size_u32]();
    uint32_t *macro3 = new uint32_t[row * macro_size_u32]();
    init_macro(macro0, row);
    init_macro(macro1, row);
    init_macro(macro2, row);
    init_macro(macro3, row);

    // Reference implementation for verification
    __uint128_t out_ref[8];
    Macro_MAC_Acc4_ref(
        out_ref,
        reinterpret_cast<__uint128_t*>(xi),
        reinterpret_cast<__uint128_t*>(macro0),
        reinterpret_cast<__uint128_t*>(macro1),
        reinterpret_cast<__uint128_t*>(macro2),
        reinterpret_cast<__uint128_t*>(macro3),
        row
    );
    float* ref_floats = reinterpret_cast<float*>(out_ref);

    // HLS buffers
    const int num_out_vectors = 8;                  // 32 floats / 4
    const int num_xi_vectors = num_xi / 4;          // 128 / 4 = 32
    const int num_mro_vectors = (row * macro_size_u32) / 4; // 144 / 4 = 36

    hls::vector<float, 4>       *out_buffer  =(hls::vector<float,4>*)aligned_alloc(64, num_out_vectors * sizeof(hls::vector<float,4>)); 
    hls::vector<float, 4>       *xi_buffer   =(hls::vector<float,4>*)aligned_alloc(64, num_xi_vectors * sizeof(hls::vector<float,4>)); 
    hls::vector<uint32_t, 4>    *mro0_buffer =(hls::vector<uint32_t,4>*)aligned_alloc(64, num_mro_vectors * sizeof(hls::vector<uint32_t,4>));
    hls::vector<uint32_t, 4>    *mro1_buffer =(hls::vector<uint32_t,4>*)aligned_alloc(64, num_mro_vectors * sizeof(hls::vector<uint32_t,4>)); 
    hls::vector<uint32_t, 4>    *mro2_buffer =(hls::vector<uint32_t,4>*)aligned_alloc(64, num_mro_vectors * sizeof(hls::vector<uint32_t,4>)); 
    hls::vector<uint32_t, 4>    *mro3_buffer =(hls::vector<uint32_t,4>*)aligned_alloc(64, num_mro_vectors * sizeof(hls::vector<uint32_t,4>)); 

    // Fill xi_buffer
    for (int i = 0; i < num_xi_vectors; ++i) {
        for (int j = 0; j < 4; ++j) {
            xi_buffer[i][j] = xi[i * 4 + j];
        }
    }
    // memcpy(xi_buffer, xi, num_xi * sizeof(float));

    // Function to fill mro buffers
    auto fill_mro_buffer = [](hls::vector<uint32_t, 4>* buffer, uint32_t* data, int num_vectors) {
        for (int i = 0; i < num_vectors; ++i) {
            for (int j = 0; j < 4; ++j) {
                buffer[i][j] = data[i * 4 + j];
            }
        }
    };
    fill_mro_buffer(mro0_buffer, macro0, num_mro_vectors);
    fill_mro_buffer(mro1_buffer, macro1, num_mro_vectors);
    fill_mro_buffer(mro2_buffer, macro2, num_mro_vectors);
    fill_mro_buffer(mro3_buffer, macro3, num_mro_vectors);

    // Call Macro_MAC_Acc4_top
    Macro_MAC_Acc4_top(
        out_buffer, xi_buffer,
        mro0_buffer, mro1_buffer,
        mro2_buffer, mro3_buffer,
        row
    );

    // Extract HLS output
    float hls_floats[32];
    for (int i = 0; i < num_out_vectors; ++i) {
        for (int j = 0; j < 4; ++j) {
            hls_floats[i * 4 + j] = out_buffer[i][j];
        }
    }

    // Verify results
    bool match = true;
    for (int i = 0; i < 32; ++i) {
        if (fabs(ref_floats[i] - hls_floats[i]) > EPSILON) {
            cout << "[INFO]: Mismatch at " << i << ": Ref=" << ref_floats[i] 
                 << ", HLS=" << hls_floats[i] << endl;
            match = false;
        } else {
            cout << "[INFO]: Checking at " << i << ": Ref=" << ref_floats[i] 
                 << ", HLS=" << hls_floats[i] << endl;
        }
    }
    cout << (match ? "TEST PASSED" : "TEST FAILED") << endl;

    // Clean up
    free(xi);
    delete[] macro0;
    delete[] macro1;
    delete[] macro2;
    delete[] macro3;

    return 0;
}