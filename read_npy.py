import numpy as np
import sys

if __name__ == "__main__":
    file_name = sys.argv[1]
    arr = np.load(file_name) * -1
    arr = arr.astype(np.uint32)
    print(arr.shape)
    print(arr.dtype)
    print(arr)
