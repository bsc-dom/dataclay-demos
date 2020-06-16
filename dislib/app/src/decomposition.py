#!/usr/bin/env python
from dataclay import api, getRuntime
import dataclay_dislib as ds

def decomposition():
    from dislib.decomposition import PCA
    import numpy as np
    x = np.array([[1, 2], [1, 4], [1, 0], [4, 2], [4, 4], [4, 0]])
    bn, bm = 2, 2
    data = ds.array(x=x, block_size=(bn, bm))
    pca = PCA()
    transformed_data = pca.fit_transform(data)
    print(transformed_data)
    print(pca.components_)
    print(pca.explained_variance_)


if __name__ == "__main__":
    
    print("-- Executing decomposition --")
    decomposition()
        
    print("-- Executing decomposition using dClay blocks --")
    ds.USE_DATACLAY = True
    decomposition()
    
