import os
import numpy as np

binary_path = "C:/projects/AAAProjects/PROJ17_LLM_QWEN/LLM_CPP/cmake-build-debug/binaries/"
target_path = "C:/projects/AAAProjects/PROJ17_LLM_QWEN/HLS/src/ref/"

print("binary_path: ", binary_path)
print("target_path: ", target_path)

if not os.path.exists(target_path):
    os.makedirs(target_path)

NUM_DECODERS = 24

bin_names = [
    "DECODER_HYPERPARAMS.bin",
    "MHA_TRUNCS.bin",
    "MHA_RMSNORM_HYPERPARAMS.bin",
    "MHA_RMSNORM_LOG2DENOMS.bin",
    "MHA_RMSNORM_ALPHAS.bin",
    "MHA_RMSNORM_TABLES.bin",
    "MHA_RMSNORM_OFFSETS_DIFF.bin",
    "MHA_RMSNORM_LNW.bin",
    # "MHA_BQ.bin",
    # "MHA_BK_RAW.bin",
    # "MHA_BV_RAW.bin",
    "MHA_CORDIC_HYPERPARAMS.bin",
    "MHA_CORDIC_THETAS.bin",
    "MHA_ROPE_HYPERPARAMS.bin",
    "MHA_ROPE_THETAS.bin",
    "MHA_SOFTMAX_HYPERPARAMS.bin",
    "MHA_SOFTMAX_EXP_TABLE.bin",
    "MHA_SOFTMAX_RECIP_TABLES.bin",
    "MHA_SOFTMAX_RECIP_ALPHAS.bin",
    "MHA_SOFTMAX_RECIP_LOG2DENOMS.bin",
    "MHA_SOFTMAX_RECIP_OFFSETS_DIFF.bin",
    "MLP_RMSNORM_HYPERPARAMS.bin",
    "MLP_RMSNORM_LOG2DENOMS.bin",
    "MLP_RMSNORM_ALPHAS.bin",
    "MLP_RMSNORM_TABLES.bin",
    "MLP_RMSNORM_OFFSETS_DIFF.bin",
    "MLP_RMSNORM_LNW.bin",
    "MLP_SILU_HYPERPARAMS.bin",
    "MLP_SILU_TABLE.bin",
    "MLP_TRUNCS.bin"
]


def savetxt(data, path):
    with open(path, "w") as f:
        f.write(','.join([f"{d: 4d}" for d in data]))
        
            
MHA_RMSNORM_FILES = [bin_name for bin_name in bin_names if "MHA_RMSNORM" in bin_name and "LNW" not in bin_name]
MLP_RMSNORM_FILES = [bin_name.replace("MHA", "MLP") for bin_name in MHA_RMSNORM_FILES]

# check, if RMSNORM in the name, MHA and MLP should be the same
for decoder_id in range(NUM_DECODERS):
    # compare MHA and MLP
    for MHA_FILE, MLP_FILE in zip(MHA_RMSNORM_FILES, MLP_RMSNORM_FILES):
        print(f"comparing {MHA_FILE} and {MLP_FILE}")
        MHA_PATH = os.path.join(binary_path, f"decoder_{decoder_id}", MHA_FILE)
        MLP_PATH = os.path.join(binary_path, f"decoder_{decoder_id}", MLP_FILE)
        MHA_DATA = np.fromfile(MHA_PATH, dtype=np.int64).reshape(-1)
        MLP_DATA = np.fromfile(MLP_PATH, dtype=np.int64).reshape(-1)
        assert np.array_equal(MHA_DATA, MLP_DATA), f"decoder_{decoder_id} {MHA_FILE} not equal to {MLP_FILE}"
        savetxt(MHA_DATA, os.path.join(target_path, MHA_FILE.replace(".bin", ".txt").replace("MHA_", "")))

# use decoder_0 as reference
# all the parameters should be the same, except the MHA_RMSNORM_LNW and MLP_RMSNORM_LNW
ref_decoder_id = 0
for decoder_id in range(NUM_DECODERS):
    for bin_name in bin_names:
        bin_path        = os.path.join(binary_path, f"decoder_{decoder_id}", bin_name)
        bin_ref_path    = os.path.join(binary_path, f"decoder_{ref_decoder_id}", bin_name)
        txt_path        = os.path.join(target_path, f"decoder_{decoder_id}", bin_name.replace(".bin", ".txt"))
        # use np fromfile to read binary file
        data        = np.fromfile(bin_path, dtype=np.int64).reshape(-1)
        data_ref    = np.fromfile(bin_ref_path, dtype=np.int64).reshape(-1)
        # compare with reference
        if "LNW" in bin_name:
            pass
        else:
            assert np.array_equal(data, data_ref), f"decoder_{decoder_id} {bin_name} not equal to ref_decoder_{ref_decoder_id}"


# convert shared hyperparameters
for bin_name in bin_names:
    if bin_name in MHA_RMSNORM_FILES or bin_name in MLP_RMSNORM_FILES:
        continue
    bin_path = os.path.join(binary_path, f"decoder_{ref_decoder_id}", bin_name)
    txt_path = os.path.join(target_path, bin_name.replace(".bin", ".txt"))
    print(f"converting {bin_path} to {txt_path}")
    data = np.fromfile(bin_path, dtype=np.int64).reshape(-1)
    savetxt(data, txt_path)


# for LNW, concat them together, order is MHA0 -> MLP0 -> MHA1 -> MLP1 -> ...
data = []
for decoder_id in range(NUM_DECODERS):
    for bin_name in ["MHA_RMSNORM_LNW.bin", "MLP_RMSNORM_LNW.bin"]:
        bin_path = os.path.join(binary_path, f"decoder_{decoder_id}", bin_name)
        data.append(np.fromfile(bin_path, dtype=np.int64).reshape(-1))
data = np.concatenate(data)
txt_path = os.path.join(target_path, "RMSNORM_LNW.txt")
print(f"converting all LNW to {txt_path}")
savetxt(data, txt_path)

# special handling CLS LNW
data = []
for decoder_id in [NUM_DECODERS]:
    for bin_name in ["CLS_RMSNORM_LNW.bin"]:
        bin_path = os.path.join(binary_path, f"decoder_{decoder_id}", bin_name)
        data.append(np.fromfile(bin_path, dtype=np.int64).reshape(-1))
data = np.concatenate(data)
txt_path = os.path.join(target_path, "CLS_RMSNORM_LNW.txt")
savetxt(data, txt_path)

# for qkv bias, concat them together, order is MHA0 -> MHA1 -> ...
q_bias = []
k_raw_bias = []
v_raw_bias = []
for decoder_id in range(NUM_DECODERS):
    q_bias    .append(np.fromfile(os.path.join(binary_path, f"decoder_{decoder_id}", "MHA_BQ.bin"    ), dtype=np.int64).reshape(-1))
    k_raw_bias.append(np.fromfile(os.path.join(binary_path, f"decoder_{decoder_id}", "MHA_BK_RAW.bin"), dtype=np.int64).reshape(-1))
    v_raw_bias.append(np.fromfile(os.path.join(binary_path, f"decoder_{decoder_id}", "MHA_BV_RAW.bin"), dtype=np.int64).reshape(-1))
q_bias     = np.concatenate(q_bias)
k_raw_bias = np.concatenate(k_raw_bias)
v_raw_bias = np.concatenate(v_raw_bias)
savetxt(q_bias,     os.path.join(target_path, "MHA_BQ.txt"))
savetxt(k_raw_bias, os.path.join(target_path, "MHA_BK_RAW.txt"))
savetxt(v_raw_bias, os.path.join(target_path, "MHA_BV_RAW.txt"))


