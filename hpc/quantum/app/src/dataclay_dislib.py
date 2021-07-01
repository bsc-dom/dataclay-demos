#!/usr/bin/env python
from dislib.data.array import Array
import dislib

use_dataclay = False

def array(x, block_size):
    dislibarr = dislib.array(x, block_size, use_dataclay=use_dataclay)
    return dislibarr

def random_array(shape, block_size, random_state=None):
    dislibarr = dislib.random_array(shape, block_size, random_state=random_state, use_dataclay=use_dataclay)
    return dislibarr
    
def zeros(shape, block_size, dtype=float):
    dislibarr = dislib.zeros(shape, block_size, dtype=dtype, use_dataclay=use_dataclay)
    return dislibarr

    
    