#include <torch/extension.h>
void quant_block(torch::Tensor weight, torch::Tensor scale, torch::Tensor zp, int bits = 8, bool sym = true);
void best_percentile(torch::Tensor weight, torch::Tensor percentile_attr, int bits = 8, bool sym = true);
PYBIND11_MODULE(TORCH_EXTENSION_NAME, m) {
    m.def("quant_block", &quant_block, "quant in block");
    m.def("best_percentile", &best_percentile, "best_percentile in block");
}
