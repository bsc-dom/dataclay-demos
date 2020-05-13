#!/usr/bin/env python
from dataclay import api, getRuntime
from dislib.cluster import KMeans
from scipy import sparse as sp
from scipy.sparse import issparse, csr_matrix
import numpy as np
import dislib as ds
from dislib.data.array import Array

from DemoNS.classes import dClayBlock, dClayDisBlocks

def disclayarray(x, block_size):
    """
    Loads data into a Distributed Array.
    Parameters
    ----------
    x : spmatrix or array-like, shape=(n_samples, n_features)
        Array of samples.
    block_size : (int, int)
        Block sizes in number of samples.
    Returns
    -------
    dsarray : ds-array
        A distributed representation of the data divided in blocks.
    """
    sparse = issparse(x)

    if sparse:
        x = csr_matrix(x, copy=True)
    else:
        x = np.array(x, copy=True)

    if len(x.shape) < 2:
        raise ValueError("Input array must have two dimensions.")

    bn, bm = block_size

    blocks = []
    for i in range(0, x.shape[0], bn):
        row = [x[i: i + bn, j: j + bm] for j in range(0, x.shape[1], bm)]
        dislib_block = dClayBlock(row)
        dislib_block.make_persistent()        
        blocks.append(dislib_block)

    sparse = issparse(x)
    
    dataclay_blocks = dClayDisBlocks(blocks)
#    dataclay_blocks.make_persistent() 
    
    arr = Array(blocks=dataclay_blocks, top_left_shape=block_size,
                reg_shape=block_size, shape=x.shape, sparse=sparse)

    return arr
    
    

if __name__ == "__main__":
    
    x = np.array([[1, 2], [1, 4], [1, 0], [4, 2], [4, 4], [4, 0]])
    x_train = ds.array(x, (2, 2))
    xclay_train = disclayarray(x, (2, 2))
    
    print("-- Executing Kmeans using normal blocks --")
    kmeans = KMeans(n_clusters=2, random_state=0)
    labels = kmeans.fit_predict(x_train)
    print(labels)
    x_test = ds.array(np.array([[0, 0], [4, 4]]), (2, 2))
    labels = kmeans.predict(x_test)
    print(labels)
    print(kmeans.centers)
    
    print("-- Executing Kmeans using dClay blocks --")
    kmeans = KMeans(n_clusters=2, random_state=0)
    labels = kmeans.fit_predict(xclay_train)
    print(labels)
    x_test = ds.array(np.array([[0, 0], [4, 4]]), (2, 2))
    labels = kmeans.predict(x_test)
    print(labels)
    print(kmeans.centers)
    
