#!/usr/bin/env python
from dislib.data.array import Array
from DemoNS.classes import dClayBlock
import dislib

def array(x, block_size, use_dataclay=False):
    dislibarr = dislib.array(x, block_size)
    if use_dataclay:
        to_dataclay_array(dislibarr)
    return dislibarr

def random_array(shape, block_size, random_state=None, use_dataclay=False):
    dislibarr = dislib.random_array(shape, block_size, random_state=random_state)
    if use_dataclay:
        to_dataclay_array(dislibarr)
    return dislibarr

def to_dataclay_array(dislibarr):
    dataclay_blocks_list = []
    blocks = dislibarr._blocks
    shape = dislibarr._shape
    bn, bm = dislibarr._reg_shape
    
    for block in blocks:
        dc_block = dClayBlock(block)
        dc_block.make_persistent()
        dataclay_blocks_list.append(dc_block)
    
    dislibarr._blocks = dataclay_blocks_list
        
    #for i in range(0, shape[0], bn):
        #row = [blocks[i: i + bn, j: j + bm] for j in range(0, shape[1], bm)]
        #dc_block = dClayBlock(row)
        #dc_block.make_persistent()        
        #dataclay_blocks_list.append(dc_block)
    
#    print("========")
#    print(dislibarr._blocks)
#    print("========")
#    print(dataclay_blocks_list)
#    print("========")

    #return Array(blocks=dataclay_blocks_list, top_left_shape=dislibarr._top_left_shape,
    #            reg_shape=dislibarr._reg_shape, shape=dislibarr._shape, sparse=dislibarr._sparse)
    
    