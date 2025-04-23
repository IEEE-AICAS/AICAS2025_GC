import os
import numpy as np
from pack import load_packed_tensor
from constants import *

# check if "EMBEDDING" exists
if not os.path.exists("./unpack/PRUNED_EMBEDDING"):
    pruned_embedding = load_packed_tensor(bitwidth=10, unsigned=False, name="./bin/PRUNED_PACKED_EMBEDDING").astype(np.int16)
    embedding = pruned_embedding.flatten().reshape(VOCAB, C)
    # save to /tmp
    embedding.tofile("./unpack/PRUNED_EMBEDDING.bin")