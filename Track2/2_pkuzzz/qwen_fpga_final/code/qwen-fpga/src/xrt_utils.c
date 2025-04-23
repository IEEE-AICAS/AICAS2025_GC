#include "xrt_utils.h"
#include <stdio.h>
#include <stdlib.h>

#include <assert.h>
#include "profile.h"
#include "params.h"

xrt_states_t xrt_states;

int xrt_setup()
{
    const char *xclbin_file = XCLBIN_PATH;
    const int device_index = 0;
    const char *gemm_name = GEMM_KERNEL_NAME;
    const char *gemv_name = GEMV_KERNEL_NAME;
    xrt_states.num_buffers = 0;
    // printf("Open the device %d\n", device_index);
    xrt_states.device = xrtDeviceOpen(device_index);
    if (xrt_states.device == NULL)
    {
        printf("Error: unable to open device %d\n", device_index);
        return EXIT_FAILURE;
    }

    // printf("Load xclbin %s\n", xclbin_file);
    if (xrtDeviceLoadXclbinFile(xrt_states.device, xclbin_file))
    {
        printf("Error: unable to load xclbin %s\n", xclbin_file);
        goto clean_device;
    }

    // printf("Get xclbin UUID\n");
    if (xrtDeviceGetXclbinUUID(xrt_states.device, xrt_states.uuid))
    {
        printf("Error: unable to get xclbin UUID\n");
        goto clean_device;
    }

    // printf("Open gemm kernel %s\n", gemm_name);
    xrt_states.gemm_kernel = xrtPLKernelOpen(xrt_states.device, xrt_states.uuid, gemm_name);
    if (xrt_states.gemm_kernel == NULL)
    {
        printf("Error: unable to open gemm kernel\n");
        goto clean_device;
    }

    // printf("Open gemv kernel %s\n", gemv_name);
    xrt_states.gemv_kernel = xrtPLKernelOpen(xrt_states.device, xrt_states.uuid, gemv_name);
    if (xrt_states.gemv_kernel == NULL)
    {
        printf("Error: unable to open gemv kernel\n");
        goto clean_gemm_kernel;
    }

    // printf("Open gemm run\n");
    xrt_states.gemm_run = xrtRunOpen(xrt_states.gemm_kernel);
    if (xrt_states.gemm_run == NULL)
    {
        printf("Error: unable to open gemm run\n");
        goto clean_gemv_kernel;
    }

    // printf("Open gemv run\n");
    xrt_states.gemv_run = xrtRunOpen(xrt_states.gemv_kernel);
    if (xrt_states.gemv_run == NULL)
    {
        printf("Error: unable to open gemv run\n");
        goto clean_gemm_run;
    }

    // printf("Setup success\n");
    return EXIT_SUCCESS;

clean_gemm_run:
    // printf("Close gemm run\n");
    xrtRunClose(xrt_states.gemm_run);
clean_gemv_kernel:
    // printf("Close gemv kernel\n");
    xrtKernelClose(xrt_states.gemv_kernel);
clean_gemm_kernel:
    // printf("Close gemm kernel\n");
    xrtKernelClose(xrt_states.gemm_kernel);
clean_device:
    // printf("Close device\n");
    xrtDeviceClose(xrt_states.device);
    exit(EXIT_FAILURE);
}

void xrt_free_buffers()
{
    for (unsigned i = 0; i < xrt_states.num_buffers; i++)
    {
        xrtBOFree(xrt_states.buffers[i].bo);
        xrt_states.buffers[i].ptr = NULL;
        xrt_states.buffers[i].size = 0;
    }
    xrt_states.num_buffers = 0;
}

void xrt_cleanup()
{
    xrt_free_buffers();
    xrtRunClose(xrt_states.gemv_run);
    xrtRunClose(xrt_states.gemm_run);
    xrtKernelClose(xrt_states.gemv_kernel);
    xrtKernelClose(xrt_states.gemm_kernel);
    xrtDeviceClose(xrt_states.device);
}

int compare_buffers(const void* a, const void* b) 
{
    xrt_buffer_t *buffer_a = (xrt_buffer_t *)a;
    xrt_buffer_t *buffer_b = (xrt_buffer_t *)b;
    if (buffer_a->ptr < buffer_b->ptr)
    {
        return -1;
    }
    else if (buffer_a->ptr > buffer_b->ptr)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

void xrt_sort_buffers()
{
    // for (int i = 0; i < xrt_states.num_buffers; i++)
    // {
    //     printf("%p %p %x\n", xrt_states.buffers[i].bo, xrt_states.buffers[i].ptr, xrt_states.buffers[i].size);
    // }
    // printf("--------------------------------------");
    qsort(xrt_states.buffers, xrt_states.num_buffers, sizeof(xrt_buffer_t), compare_buffers);
    // for (int i = 0; i < xrt_states.num_buffers; i++)
    // {
    //     printf("%p %p %x\n", xrt_states.buffers[i].bo, xrt_states.buffers[i].ptr, xrt_states.buffers[i].size);
    // }
    // assert(0);
}

xrt_buffer_t *find_buffer_binary_search(const void *ptr)
{
    int low = 0;
    int high = xrt_states.num_buffers - 1;
    while (low <= high) {
        int mid = (low + high) / 2;
        xrt_buffer_t *buffer = &xrt_states.buffers[mid];
        if (ptr < buffer->ptr) {
            high = mid - 1;
        } else if (ptr >= buffer->ptr + buffer->size) {
            low = mid + 1;
        } else {
            return buffer; // Found the buffer
        }
    }
    assert(0 && "Error: unable to find buffer\n");
    return NULL; // Not found
}

xrt_buffer_t *find_buffer_linear_search(const void *ptr)
{
    for (unsigned i = 0; i < xrt_states.num_buffers; i++)
    {
        xrt_buffer_t *buffer = &xrt_states.buffers[i];
        if (ptr >= buffer->ptr && ptr < buffer->ptr + buffer->size)
        {
            return buffer;
        }
    }
    printf("Searching %p, we have:\n", ptr);
    for (unsigned i = 0; i < xrt_states.num_buffers; i++)
    {
        xrt_buffer_t *buffer = &xrt_states.buffers[i];
        printf("offset %ld, size: %ld\n", buffer->ptr - ptr, buffer->size);
    }
    assert(0 && "Error: unable to find buffer\n");
    return NULL;
}

xrt_buffer_t *xrt_malloc_buffer(size_t size)
{
    // printf("Malloc buffer %zu\n", size);
    if (xrt_states.num_buffers >= MAX_XRT_BUFFER_NUM)
    {
        assert(0 && "Error: too many buffers\n");
        return NULL;
    }
    xrt_buffer_t *buffer = &xrt_states.buffers[xrt_states.num_buffers];
    buffer->bo = xrtBOAlloc(xrt_states.device, size, XRT_BO_FLAGS_NONE, 0);
    if (buffer->bo == NULL)
    {
        printf("Error: unable to allocate buffer\n");
        return NULL;
    }
    buffer->ptr = xrtBOMap(buffer->bo);
    if (buffer->ptr == NULL)
    {
        printf("Error: unable to map buffer\n");
        xrtBOFree(buffer->bo);
        return NULL;
    }
    buffer->size = size;
    xrt_states.num_buffers++;
    const void *ptr = buffer->ptr;
    xrt_sort_buffers();
    return find_buffer_binary_search(ptr);
}

void *xrt_malloc(size_t size)
{
    return xrt_malloc_ptr(size);
}

void *xrt_malloc_ptr(size_t size)
{
    xrt_buffer_t *buffer = xrt_malloc_buffer(size);
    assert(buffer);
    return buffer ? buffer->ptr : NULL;
}

xrtBufferHandle xrt_malloc_bo(size_t size)
{
    xrt_buffer_t *buffer = xrt_malloc_buffer(size);
    assert(buffer);
    return buffer ? buffer->bo : NULL;
}

xrtBufferHandle xrt_ptr_to_bo(const void *ptr)
{
    start_segment(XRT_PTR_TO_BO);
    xrt_buffer_t *buffer = find_buffer_binary_search(ptr);
    end_segment(XRT_PTR_TO_BO);
    start_segment(XRT_BO_SUB_ALLOC);
    size_t offset = ptr - buffer->ptr;
    xrtBufferHandle bo;
    if (offset == 0)
    {
        bo = buffer->bo;
    }
    else
    {
        bo = xrtBOSubAlloc(buffer->bo, buffer->size - offset, offset);
    }
    end_segment(XRT_BO_SUB_ALLOC);
    return bo;
}
