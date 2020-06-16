#!/usr/bin/env python
from dataclay import api, getRuntime
import dataclay_dislib as ds
import numpy as np
from scipy import sparse as sp

def _equal_arrays(x1, x2):
    if sp.issparse(x1):
        return np.allclose(x1.toarray(), x2.toarray())
    else:
        return np.allclose(x1, x2)
    
def power():
    """ Tests ds-array power and sqrt """
    orig = np.array([[1, 2, 3], [4, 5, 6]])
    x = ds.array(orig, block_size=(2, 1))
    xp = x.__pow__(2)
    xs = xp.sqrt()

    expected = np.array([[1, 4, 9], [16, 25, 36]])

    assert _equal_arrays(expected, xp.collect()) == True
    assert _equal_arrays(orig, xs.collect()) == True

    orig = sp.csr_matrix([[1, 2, 3], [4, 5, 6]])
    x = ds.array(orig, block_size=(2, 1))
    xp = x.__pow__(2)
    xs = xp.sqrt()

    expected = sp.csr_matrix([[1, 4, 9], [16, 25, 36]])

    assert _equal_arrays(expected, xp.collect()) == True
    assert _equal_arrays(orig, xs.collect()) == True

if __name__ == "__main__":

    print("-- Executing power --")
    power()
        
    print("-- Executing power using dClay blocks --")
    ds.USE_DATACLAY = True
    power()

    
