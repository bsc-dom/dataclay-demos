#!/usr/bin/env python
from dataclay import api, getRuntime
import dataclay_dislib as ds

def kmeans(use_dataclay):
    import numpy as np
    from dislib.cluster import KMeans
    x = np.array([[1, 2], [1, 4], [1, 0], [4, 2], [4, 4], [4, 0]])
    x_train = ds.array(x, (2, 2), use_dataclay=use_dataclay)
    kmeans = KMeans(n_clusters=2, random_state=0)
    labels = kmeans.fit_predict(x_train)
    print(labels)
    x_test = ds.array(np.array([[0, 0], [4, 4]]), (2, 2), use_dataclay)
    labels = kmeans.predict(x_test)
    print(labels)
    print(kmeans.centers)
    
if __name__ == "__main__":
    
   
    print("-- Executing Kmeans using normal blocks --")
    kmeans(False)
    print("-- Executing Kmeans using dClay blocks --")
    kmeans(True)
    
