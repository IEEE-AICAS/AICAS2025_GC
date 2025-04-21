#include <torch/extension.h>
#include <cfloat>
#include <cuda.h>
#include <cuda_runtime.h>

const int ITER = 100;
const float RATE = 1 / float(ITER);


// __global__ void min_max_block(float *weight, float *weight_max, float *weight_min) {
//     int row = blockIdx.x;
//     int tid = threadIdx.x;

//     __shared__ float max_in_block;
//     __shared__ float min_in_block;
//     max_in_block = -FLT_MAX;
//     min_in_block = FLT_MAX;

//     max_in_block = fmaxf(max_in_block, weight[row * blockDim.x + tid]);
//     min_in_block = fminf(min_in_block, weight[row * blockDim.x + tid]);

//     // 每个线程只需要比较自己的最大值和最小值
//     __syncthreads();
//     weight_max[row] = fmaxf(0, max_in_block);
//     weight_min[row] = fminf(0, min_in_block);
// }
__global__ void min_max_block(float *weight, float *weight_max, float *weight_min) {
    int row = blockIdx.x;
    int tid = threadIdx.x;

    extern __shared__ float sharedData[];
    float *smin = sharedData;
    float *smax = sharedData + blockDim.x;

    smin[tid] = weight[row * blockDim.x + tid];
    smax[tid] = weight[row * blockDim.x + tid];

    __syncthreads();

    for (int s=blockDim.x /2; s>0; s>>=1){
        if (tid < s) {
            smin[tid] = fminf(smin[tid], smin[tid + s]);
            smax[tid] = fmaxf(smax[tid], smax[tid + s]);
        }

        //这里就是要求所有线程都执行完一个循环，然后再继续下一个循环
        __syncthreads();
    }

    if (tid == 0) {
        weight_max[row] = fmaxf(0.0, smax[0]);
        weight_min[row] = fminf(0.0, smin[0]);
    }
}

__device__ __forceinline__ float mse_calc(float now_mse, float weight1, float weight2, int count) {
    /*  避免和溢出
        self.H *= self.nsamples / (self.nsamples + tmp)
        self.nsamples += tmp
        self.H += self.nsamples * (inp.matmul(inp.t())).double()

        x = x * n/(n+1)
        n = n + 1
        x += n * y

        mean = (x1 + x2 + ... + xn) / n
        mean = [(x1 + x2) / 2] * 2 + x3] / 3 ...
     */

    float mse_tmp = (weight1 - weight2) * (weight1 - weight2);
    now_mse = now_mse * (count - 1);
    now_mse = (now_mse + mse_tmp) / float(count);

    return now_mse;
}

__device__ __forceinline__ float fake_quant(float weight, float scale, float zp, int q_min, int q_max) {
    float q_weight = roundf(weight / scale + zp);
    q_weight = fminf(q_max, fmaxf(q_min, q_weight));
    float dq_weight = q_weight * scale - zp;
    return dq_weight;
}


__global__ void quant_block_kernel_asym(float *weight, float *scale_arr, float *zp_arr,
                                        float *weight_max, float *weight_min,
                                        int row_count, int col_count,
                                        int q_min, int q_max) {
    /*
     * 代码有很多地方需要优化，要问 chatgpt
     */
    // 每个线程处理一行数据
    int row_id = blockIdx.x * blockDim.x + threadIdx.x;
    if (row_id < row_count) {
        int maxq = q_max - q_min;

        float scale = 0.0;
        float zp = 0.0;

        float best_mse = FLT_MAX;
        float best_scale = 0;
        float best_zp = 0;

        for (int i = 0; i < ITER; i++) {
            float now_mse = 0;
            float max_val = weight_max[row_id];
            float min_val = weight_min[row_id];
            float percent = 1.0 - i * RATE;
            max_val = max_val * percent;
            min_val = min_val * percent;
            scale = (max_val - min_val) / (float) maxq;
            zp = -min_val / scale;

            for (int j = 0; j < col_count; j++) {
                float now_weight = weight[row_id * col_count + j];
                float q_weight = fake_quant(now_weight, scale, zp, q_min, q_max);
                now_mse = mse_calc(now_mse, now_weight, q_weight, j + 1);
            }
            if (now_mse < best_mse) {
                best_mse = now_mse;
                best_scale = scale;
                best_zp = zp;
            }
        }
        scale_arr[row_id] = best_scale;
        zp_arr[row_id] = best_zp;
    }
}


__global__ void get_best_percentile_asym(float *weight, float *percent_attr,
                                        float *weight_max, float *weight_min,
                                        int row_count, int col_count,
                                        int q_min, int q_max) {
    /*
     * 代码有很多地方需要优化，要问 chatgpt
     */
    // 每个线程处理一行数据
    int row_id = blockIdx.x * blockDim.x + threadIdx.x;
    if (row_id < row_count) {
        int maxq = q_max - q_min;

        float scale = 0.0;
        float zp = 0.0;

        float best_mse = FLT_MAX;
        float best_percent = 0.0;

        for (int i = 0; i < ITER; i++) {
            float now_mse = 0;
            float max_val = weight_max[row_id];
            float min_val = weight_min[row_id];
            float percent = 1.0 - i * RATE;
            max_val = max_val * percent;
            min_val = min_val * percent;
            scale = (max_val - min_val) / (float) maxq;
            zp = -min_val / scale;

            for (int j = 0; j < col_count; j++) {
                float now_weight = weight[row_id * col_count + j];
                float q_weight = fake_quant(now_weight, scale, zp, q_min, q_max);
                now_mse = mse_calc(now_mse, now_weight, q_weight, j + 1);
            }
            if (now_mse < best_mse) {
                best_mse = now_mse;
                best_percent = percent;
            }
        }
        percent_attr[row_id] = best_percent;
    }
}
__global__ void get_best_percentile_sym(float *weight, float *percent_attr,
                                        float *weight_max, float *weight_min,
                                        int row_count, int col_count,
                                        int q_min, int q_max) {
    /*
     * 代码有很多地方需要优化，要问 chatgpt
     */
    // 每个线程处理一行数据
    int row_id = blockIdx.x * blockDim.x + threadIdx.x;
    if (row_id < row_count) {
        int maxq = q_max - q_min;

        float scale = 0.0;
        float zp = 0.0;

        float best_mse = FLT_MAX;
        float best_percent = 0.0;

        for (int i = 0; i < ITER; i++) {
            float now_mse = 0;
            float max_val = weight_max[row_id];
            float min_val = weight_min[row_id];
            float percent = 1.0 - i * RATE;
            max_val = max_val * percent;
            min_val = min_val * percent;

            float f_max = fmaxf(fabs(max_val), fabs(min_val));
            scale = 2 * f_max / (float) maxq;
            zp = 0;

            for (int j = 0; j < col_count; j++) {
                float now_weight = weight[row_id * col_count + j];
                float q_weight = fake_quant(now_weight, scale, zp, q_min, q_max);
                now_mse = mse_calc(now_mse, now_weight, q_weight, j + 1);
            }
            if (now_mse < best_mse) {
                best_mse = now_mse;
                best_percent = percent;
            }
        }
        percent_attr[row_id] = best_percent;
    }
}

__global__ void quant_block_kernel_sym(float *weight, float *scale_arr, float *zp_arr,
                                       float *weight_max, float *weight_min,
                                       int row_count, int col_count,
                                       int q_min, int q_max) {
    /*
     * 代码有很多地方需要优化，要问 chatgpt
     */
    // 每个线程处理一行数据
    int row_id = blockIdx.x * blockDim.x + threadIdx.x;
    if (row_id < row_count) {
        int maxq = q_max - q_min;
        float scale = 0.0;
        float zp = 0;

        float best_mse = FLT_MAX;
        float best_scale = 0;
        float best_zp = 0;

        for (int i = 0; i < ITER; i++) {
            float now_mse = 0;
            float max_val = weight_max[row_id];
            float min_val = weight_min[row_id];
            float percent = 1.0 - i * RATE;
            max_val = max_val * percent;
            min_val = min_val * percent;

            float f_max = fmaxf(fabs(max_val), fabs(min_val));
            scale = 2 * f_max / (float) maxq;
            zp = 0;

            for (int j = 0; j < col_count; j++) {
                float now_weight = weight[row_id * col_count + j];
                float q_weight = fake_quant(now_weight, scale, zp, q_min, q_max);
                now_mse = mse_calc(now_mse, now_weight, q_weight, j + 1);
            }
            if (now_mse < best_mse) {
                best_mse = now_mse;
                best_scale = scale;
                best_zp = zp;
            }
        }
        scale_arr[row_id] = best_scale;
        zp_arr[row_id] = best_zp;
    }
}

void quant_block(torch::Tensor weight, torch::Tensor scale, torch::Tensor zp, int bits = 8, bool sym = true) {
    /* 整体流程分为：
     * 1. 计算每个 block （行）的最大值和最小值
     * 2. 根据最大值和最小值，进行 omse 搜索
     *
     * 输入：
     *  weight: 二维张量，形状为 [block_count, block_size]
     * 输出：
     *  scale: 一维张量，形状为 [block_count]
     *  zp: 一维张量，形状为 [block_count]
     */
    if (!weight.is_cuda()) {
        throw std::invalid_argument("weight must be in cuda");
    }
    if (!scale.is_cuda()) {
        throw std::invalid_argument("scale must be in cuda");
    }
    if (!zp.is_cuda()) {
        throw std::invalid_argument("zp must be in cuda");
    }

    if (weight.dim() != 2) {
        throw std::invalid_argument("weight must be 2D tensor");
    }
    int block_count = weight.size(0);
    int block_size = weight.size(1);
    // 确保 scale 和 zp 的形状和 weight 的形状一致
    if (scale.dim() != 1 || scale.size(0) != block_count) {
        throw std::invalid_argument("scale must be 1D tensor with the same size as the first dimension of weight");
    }
    if (zp.dim() != 1 || zp.size(0) != block_count) {
        throw std::invalid_argument("zp must be 1D tensor with the same size as the first dimension of weight");
    }

    if (bits < 2 || bits > 8) {
        throw std::invalid_argument("bits must be between 2 and 8");
    }

    float *weight_data = weight.data_ptr<float>();
    float *scale_data = scale.data_ptr<float>();
    float *zp_data = zp.data_ptr<float>();

    int q_min, q_max;
    if (sym) {
        q_min = -(1 << (bits - 1)) + 1;
        q_max = (1 << (bits - 1)) - 1;
    } else {
        q_min = 0;
        q_max = (1 << bits) - 1;
    }

    /*
     * 每个线程块负责处理一行数据，总共需要 block_count 个线程块, 也就是 grid 的大小
     * 每个线程块中的线程数为 block_size，也就是 block 的大小
     */
    torch::Tensor weight_max = torch::zeros({block_count}, torch::dtype(torch::kFloat32).device(weight.device()));
    torch::Tensor weight_min = torch::zeros({block_count}, torch::dtype(torch::kFloat32).device(weight.device()));


    // 这里乘以 2 是因为要存储最大值和最小值
    // 注意，由于我们让每个线程块处理一行，并且每个线程处理一个元素，所以情况得到简化
    // 因为不需要考虑矩阵列数比线程数多的情况
    int sharedMemSize = 2 * block_size * sizeof(float);
    // min_max_block<<<block_count, block_size, sharedMemSize>>>(weight_data,
    //     weight_max.data_ptr<float>(),
    //     weight_min.data_ptr<float>());
    min_max_block<<<block_count, block_size, sharedMemSize>>>(weight_data,
                                               weight_max.data_ptr<float>(),
                                               weight_min.data_ptr<float>());


    /* 为了最大化性能，块内线程数要大于 32, 可以取 64 或 128等
     * 量化以 block 为单位进行，如果此时还是每个 block 处理一行，那么每个 block 的线程数只有 1，这样会导致性能下降
     */
    int kernel_block_size = 256;
    int kernel_grid_size = (block_count + kernel_block_size - 1) / kernel_block_size;


    // 矩阵总共多少行
    int rowCount = block_count;
    int colCount = block_size;
    if (sym) {
        quant_block_kernel_sym<<<kernel_grid_size, kernel_block_size>>>(weight_data,
                                                                        scale_data, zp_data,
                                                                        weight_max.data_ptr<float>(),
                                                                        weight_min.data_ptr<float>(),
                                                                        rowCount, colCount,
                                                                        q_min, q_max);
    } else {
        quant_block_kernel_asym<<<kernel_grid_size, kernel_block_size>>>(weight_data,
                                                                         scale_data, zp_data,
                                                                         weight_max.data_ptr<float>(),
                                                                         weight_min.data_ptr<float>(),
                                                                         rowCount, colCount,
                                                                         q_min, q_max);
    }
}


void best_percentile(torch::Tensor weight, torch::Tensor percentile_attr, int bits = 8, bool sym = true) {
    /* 整体流程分为：
     * 1. 计算每个 block （行）的最大值和最小值
     * 2. 根据最大值和最小值，进行 omse 搜索
     *
     * 输入：
     *  weight: 二维张量，形状为 [block_count, block_size]
     * 输出：
     *  scale: 一维张量，形状为 [block_count]
     *  zp: 一维张量，形状为 [block_count]
     */
    if (!weight.is_cuda()) {
        throw std::invalid_argument("weight must be in cuda");
    }
    if (!percentile_attr.is_cuda()) {
        throw std::invalid_argument("scale must be in cuda");
    }

    if (weight.dim() != 2) {
        throw std::invalid_argument("weight must be 2D tensor");
    }
    int block_count = weight.size(0);
    int block_size = weight.size(1);
    // 确保 scale 和 zp 的形状和 weight 的形状一致
    if (percentile_attr.dim() != 1 || percentile_attr.size(0) != block_count) {
        throw std::invalid_argument("scale must be 1D tensor with the same size as the first dimension of weight");
    }

    if (bits < 2 || bits > 8) {
        throw std::invalid_argument("bits must be between 2 and 8");
    }


    float *weight_data = weight.data_ptr<float>();
    float *percentile_data = percentile_attr.data_ptr<float>();
    int q_min, q_max;
    if (sym) {
        q_min = -(1 << (bits - 1)) + 1;
        q_max = (1 << (bits - 1)) - 1;
    } else {
        q_min = 0;
        q_max = (1 << bits) - 1;
    }

    /*
     * 每个线程块负责处理一行数据，总共需要 block_count 个线程块, 也就是 grid 的大小
     * 每个线程块中的线程数为 block_size，也就是 block 的大小
     */
    torch::Tensor weight_max = torch::zeros({block_count}, torch::dtype(torch::kFloat32).device(weight.device()));
    torch::Tensor weight_min = torch::zeros({block_count}, torch::dtype(torch::kFloat32).device(weight.device()));


    // 这里乘以 2 是因为要存储最大值和最小值
    // 注意，由于我们让每个线程块处理一行，并且每个线程处理一个元素，所以情况得到简化
    // 因为不需要考虑矩阵列数比线程数多的情况
    int sharedMemSize = 2 * block_size * sizeof(float);
    // min_max_block<<<block_count, block_size, sharedMemSize>>>(weight_data,
    //     weight_max.data_ptr<float>(),
    //     weight_min.data_ptr<float>());
    min_max_block<<<block_count, block_size, sharedMemSize>>>(weight_data,
                                               weight_max.data_ptr<float>(),
                                               weight_min.data_ptr<float>());


    /* 为了最大化性能，块内线程数要大于 32, 可以取 64 或 128等
     * 量化以 block 为单位进行，如果此时还是每个 block 处理一行，那么每个 block 的线程数只有 1，这样会导致性能下降
     */
    int kernel_block_size = 256;
    int kernel_grid_size = (block_count + kernel_block_size - 1) / kernel_block_size;

    // 矩阵总共多少行
    int rowCount = block_count;
    int colCount = block_size;
    if (sym) {
        get_best_percentile_sym<<<kernel_grid_size, kernel_block_size>>>(weight_data,
                                                                        percentile_data,
                                                                        weight_max.data_ptr<float>(),
                                                                        weight_min.data_ptr<float>(),
                                                                        rowCount, colCount,
                                                                        q_min, q_max);
    } else {
        get_best_percentile_asym<<<kernel_grid_size, kernel_block_size>>>(weight_data,
                                                                         percentile_data, 
                                                                         weight_max.data_ptr<float>(),
                                                                         weight_min.data_ptr<float>(),
                                                                         rowCount, colCount,
                                                                         q_min, q_max);
    }
}
