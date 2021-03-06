#!/usr/bin/env python
import dataclay_dislib as ds

def nearest_neighbors():
    import numpy as np
    from dislib.neighbors import NearestNeighbors
    data = ds.random_array((10, 6), block_size=(2, 2))
    knn = NearestNeighbors(n_neighbors=2)
    knn.fit(data)
    distances, indices = knn.kneighbors(data)
    print(distances.collect())
    print(indices.collect())
    
if __name__ == "__main__":
    
    
    print("-- Executing nearest neighbors --")
    nearest_neighbors()

    print("-- Executing nearest neighbors using dClay blocks --")
    ds.use_dataclay = True
    nearest_neighbors()

