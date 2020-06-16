#!/usr/bin/env python
from dataclay import api, getRuntime
import dataclay_dislib as ds

def dbscan():
    from dislib.cluster import DBSCAN
    import numpy as np
    arr = np.array([[1, 2], [2, 2], [2, 3], [8, 7], [8, 8], [25, 80]])
    x = ds.array(arr, block_size=(2, 2))

    dbscan = DBSCAN(eps=3, min_samples=2)
    y = dbscan.fit_predict(x)
    print(y.collect())

if __name__ == "__main__":

    print("-- Executing dbscan --")
    dbscan()
        
    print("-- Executing dbscan using dClay blocks --")
    ds.USE_DATACLAY = True
    dbscan()

    
