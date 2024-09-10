import os
import subprocess

import yaml


TRAIN_DATA_PATH = "/veld/input/" + os.getenv("in_corpus_file")
OUT_MODEL_PATH = "/veld/output/"
DURATION = float(os.getenv("DURATION"))
TRAINING_ARCHITECTURE = "glove"
TRAIN_DATA_DESCRIPTION = None
VERBOSE = os.getenv("verbose")
MEMORY = os.getenv("memory")
VOCAB_MIN_COUNT = os.getenv("vocab_min_count")
VECTOR_SIZE = os.getenv("vector_size")
MAX_ITER = os.getenv("max_iter")
WINDOW_SIZE = os.getenv("window_size")
BINARY = os.getenv("binary")
NUM_THREADS = os.getenv("num_threads")
X_MAX = os.getenv("x_max")


def get_description():
    veld_file = None
    for file in os.listdir("/veld/input/"):
        if file.startswith("veld") and file.endswith("yaml"):
            if veld_file is not None:
                raise Exception("Multiple veld yaml files found.")
            else:
                veld_file = file
    if veld_file is None:
        raise Exception("No veld yaml file found.")
    with open("/veld/input/" + veld_file, "r") as f:
        input_veld_metadata = yaml.safe_load(f)
        global TRAIN_DATA_DESCRIPTION
        try:
            TRAIN_DATA_DESCRIPTION = input_veld_metadata["x-veld"]["data"]["description"]
        except:
            pass


def write_metadata():

    # calculate size of training and model data
    def calc_size(file_or_folder):
        size = subprocess.run(["du", "-sh", file_or_folder], capture_output=True, text=True)
        size = size.stdout.split()[0]
        return size
    train_data_size = calc_size(TRAIN_DATA_PATH)
    model_data_size = calc_size(OUT_MODEL_PATH)

    # calculate hash of training data
    train_data_md5_hash = subprocess.run(["md5sum", TRAIN_DATA_PATH], capture_output=True, text=True)
    train_data_md5_hash = train_data_md5_hash.stdout.split()[0]

    # aggregate into metadata dictionary
    out_veld_metadata = {
        "x-veld": {
            "data": {
                "description": "glove test model",
                "file_types": [
                    "bin",
                    "txt"
                ],
                "contents": [
                    "word embeddings model",
                    "glove model",
                ],
                "additional": {
                    "train_data_description": TRAIN_DATA_DESCRIPTION,
                    "training_architecture": TRAINING_ARCHITECTURE,
                    "train_data_size": train_data_size,
                    "train_data_md5_hash": train_data_md5_hash,
                    "verbose": VERBOSE,
                    "memory": MEMORY,
                    "vocab_min_count": VOCAB_MIN_COUNT,
                    "vector_size": VECTOR_SIZE,
                    "max_iter": MAX_ITER,
                    "window_size": WINDOW_SIZE,
                    "binary": BINARY,
                    "num_threads": NUM_THREADS,
                    "x_max": X_MAX,
                    "training_duration (minutes)": DURATION,
                    "model_data_size": model_data_size,
                }
            }
        }
    }

    # write to yaml
    with open("/veld/output/veld.yaml", "w") as f:
        yaml.dump(out_veld_metadata, f, sort_keys=False)


if __name__ == "__main__":
    get_description()
    write_metadata()

