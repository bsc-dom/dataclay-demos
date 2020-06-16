#!/usr/bin/env python
from dislib.data.array import Array
from DemoNS.classes import dClayBlock
import dislib

USE_DATACLAY=False

def use_dataclay():
    USE_DATACLAY=True

def array(x, block_size):
    dislibarr = dislib.array(x, block_size, use_dataclay=USE_DATACLAY)
    return dislibarr

def random_array(shape, block_size, random_state=None):
    dislibarr = dislib.random_array(shape, block_size, random_state=random_state, use_dataclay=USE_DATACLAY)
    return dislibarr
    
def zeros(shape, block_size, dtype=float):
    dislibarr = dislib.zeros(shape, block_size, dtype=dtype, use_dataclay=USE_DATACLAY)
    return dislibarr

    
    