#!/usr/bin/env python
from dataclay import api, getRuntime
import dataclay_dislib as ds

def nearest_neighbors(shape, block_size, random_state=None, use_dataclay=False):
    import numpy as np
    from dislib.neighbors import NearestNeighbors
    data = ds.random_array((10, 6), block_size=(2, 2), use_dataclay=use_dataclay)
    knn = NearestNeighbors(n_neighbors=2)
    knn.fit(data)
    distances, indices = knn.kneighbors(data)
    print(distances.collect())
    print(indices.collect())
    
if __name__ == "__main__":
    
    
    print("-- Executing nearest neighbors --")
    nearest_neighbors(False)

    print("-- Executing nearest neighbors using dClay blocks --")
    nearest_neighbors(True)

