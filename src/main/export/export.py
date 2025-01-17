import pickle
import os

import numpy as np


IN_VECTOR_FILE = "/veld/input/" + os.getenv("in_vector_file")
OUT_VECTOR_FILE = "/veld/output/" + os.getenv("out_vector_file")


# loading model
print("loading model")
VECTORS = {}
with open(IN_VECTOR_FILE, 'r') as f:
    for line in f:
        vals = line.rstrip().split(' ')
        VECTORS[vals[0]] = np.array([float(x) for x in vals[1:]])

# persisting dict to pickle
print("persisting dict to pickle")
with open(OUT_VECTOR_FILE, "wb") as f:
    pickle.dump(VECTORS, f)

