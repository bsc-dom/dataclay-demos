#!/usr/bin/env python
from dataclay import api, getRuntime
import dataclay_dislib as ds

def cascade_svm(use_dataclay):
    import numpy as np
    x = np.array([[-1, -1], [-2, -1], [1, 1], [2, 1]])
    y = np.array([1, 1, 2, 2])

    train_data = ds.array(x, block_size=(4, 2), use_dataclay=use_dataclay)
    train_labels = ds.array(y, block_size=(4, 2), use_dataclay=use_dataclay)
    
    from dislib.classification import CascadeSVM
    svm = CascadeSVM()
    svm.fit(train_data, train_labels)
    test_data = ds.array(np.array([[-0.8, -1]]), block_size=(1, 2), use_dataclay=use_dataclay)
    y_pred = svm.predict(test_data)
    print(y_pred)
    
if __name__ == "__main__":

    print("-- Executing cascade_svm --")
    cascade_svm(False)
        
    print("-- Executing cascade_svm using dClay blocks --")
    cascade_svm(True)

    
