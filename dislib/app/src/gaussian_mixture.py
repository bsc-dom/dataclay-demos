#!/usr/bin/env python
import dataclay_dislib as ds

def gaussian_mixture():
    from pycompss.api.api import compss_wait_on
    from dislib.cluster import GaussianMixture
    x = ds.array([[1, 2], [1, 4], [1, 0], [4, 2], [4, 4], [4, 0]], (3, 2)) 
    gm = GaussianMixture(n_components=2, random_state=0)
    labels = gm.fit_predict(x).collect()
    print(labels)
    x_test = ds.array([[0, 0], [4, 4]], (2, 2))
    labels_test = gm.predict(x_test).collect()
    print(labels_test)
    print(compss_wait_on(gm.means_))
    
if __name__ == "__main__":

    print("-- Executing gaussian_mixture --")
    gaussian_mixture()
        
    print("-- Executing gaussian_mixture using dClay blocks --")
    ds.use_dataclay = True
    gaussian_mixture()

    
