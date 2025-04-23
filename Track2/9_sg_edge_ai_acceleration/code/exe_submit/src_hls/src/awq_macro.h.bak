#ifndef AWQ_MACRO_H
#define AWQ_MACRO_H

#include <cstdint>
#include <ap_int.h>       // For HLS-specific types
#include <hls_stream.h>   // For HLS streams
#include <hls_vector.h>
// Constants
const uint16_t _MACRO_W = 8;        // Number of output channels
const uint16_t _MACRO_H = 64;       // Number of input features
const uint16_t _MACRO_SIZE = 288;   // Size in bytes
const uint16_t _MACRO_SIZE_U32 = _MACRO_SIZE / sizeof(uint32_t); // 72
const uint16_t _MACRO_SIZE_U128 = _MACRO_SIZE_U32/4 ; // 72


// Function prototypes

// Half to float conversion
float half_to_float(uint16_t h);

// Reference functions
void Macro_MAC_Acc4_ref(
    __uint128_t out_x4[8],
    __uint128_t *xi_part,
    __uint128_t *macro0,
    __uint128_t *macro1,
    __uint128_t *macro2,
    __uint128_t *macro3,
    uint16_t row
);

// HLS top-level function
void Macro_MAC_Acc4_top(
    hls::vector<float,    4 >   *out,
    hls::vector<float,    4 >   *xi,
    hls::vector<uint32_t, 4 >   *mro0,
    hls::vector<uint32_t, 4 >   *mro1,
    hls::vector<uint32_t, 4 >   *mro2,
    hls::vector<uint32_t, 4 >   *mro3,
    uint16_t row //TEST WITH 14;
);

// Internal functions (for reference and HLS)
static void split_uint32_to_uint4(uint8_t out[8], uint32_t in);
static void split_uint32_to_uint4_hls(ap_uint<4> output[8], ap_uint<32> value);
static void _Macro_MAC_ref(float *xo, float *xi, uint32_t *awq_macro);

#endif // AWQ_MACRO_H