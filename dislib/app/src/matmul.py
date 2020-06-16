#!/usr/bin/env python
from dataclay import api, getRuntime
import dataclay_dislib as ds

def matmul():
    import numpy as np
    """ Tests ds-array multiplication """

    shape_a = (20, 30)
    shape_b = (30, 10)
    
    a_np = np.random.random(shape_a)
    b_np = np.random.random(shape_b)

    b0 = np.random.randint(1, a_np.shape[0] + 1)
    b1 = np.random.randint(1, a_np.shape[1] + 1)
    b2 = np.random.randint(1, b_np.shape[1] + 1)

    a = ds.array(a_np, (b0, b1))
    b = ds.array(b_np, (b1, b2))

    expected = a_np.__matmul__(b_np)
    computed = a.__matmul__(b)
    print("Expected:")
    print(expected)
    print("Result:")
    print(computed.collect(False))

if __name__ == "__main__":

    print("-- Executing matmul --")
    matmul()
        
    print("-- Executing matmul using dClay blocks --")
    ds.USE_DATACLAY = True
    matmul()

    
