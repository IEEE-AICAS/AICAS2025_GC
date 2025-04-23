#ifndef DMA_APP_H
#define DMA_APP_H

#include <stdint.h>

void pspl_trans(int8_t* input_buffer, int32_t* output_buffer, int input_size, int output_size);

#endif // DMA_APP_H
