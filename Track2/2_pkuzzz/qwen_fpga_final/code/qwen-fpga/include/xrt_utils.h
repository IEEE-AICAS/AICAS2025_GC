#ifndef _XRT_UTILS_H
#define _XRT_UTILS_H

// XRT includes
#include <xrt/xrt_bo.h>
#include <experimental/xrt_xclbin.h>
#include <xrt/xrt_device.h>
#include <xrt/xrt_kernel.h>

#include "params.h"

typedef struct 
{
    xrtBufferHandle bo;
    void *ptr;
    size_t size;
} xrt_buffer_t;

typedef struct
{
    xrtDeviceHandle device;
    uuid_t uuid;
    xrtKernelHandle gemm_kernel;
    xrtKernelHandle gemv_kernel;
    xrtRunHandle gemm_run;
    xrtRunHandle gemv_run;
    xrt_buffer_t buffers[MAX_XRT_BUFFER_NUM];
    unsigned num_buffers;
} xrt_states_t;

extern xrt_states_t xrt_states;

int xrt_setup();

void xrt_free_buffers();

void xrt_cleanup();

xrt_buffer_t *xrt_malloc_buffer(size_t size);

void *xrt_malloc(size_t size);

void *xrt_malloc_ptr(size_t size);

xrtBufferHandle xrt_malloc_bo(size_t size);

xrtBufferHandle xrt_ptr_to_bo(const void *ptr);

#endif // _XRT_UTILS_H