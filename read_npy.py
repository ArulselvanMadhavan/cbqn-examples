import numpy as np
import sys

if __name__ == "__main__":
    file_name = sys.argv[1]
    arr = np.load(file_name) * -1
    arr = arr.astype(np.uint32)
    if "hops" in file_name:
        arr = arr.reshape(arr.shape[0] // arr.shape[1], -1, arr.shape[-1])
    print(arr.shape)
    print(arr.dtype)
    print(arr)
