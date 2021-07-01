#!/usr/bin/env python
import dataclay_dislib as ds

def cascade_svm():
    import numpy as np
    x = np.array([[-1, -1], [-2, -1], [1, 1], [2, 1]])
    y = np.array([1, 1, 2, 2]).reshape(-1, 1)

    train_data = ds.array(x, block_size=(4, 2))
    train_labels = ds.array(y, block_size=(4, 1))
    from dislib.classification import CascadeSVM
    svm = CascadeSVM()
    svm.fit(train_data, train_labels)
    test_data = ds.array(np.array([[-0.8, -1]]), block_size=(1, 2))
    y_pred = svm.predict(test_data)

    print(y_pred)
    
if __name__ == "__main__":

    print("-- Executing cascade_svm --")
    cascade_svm()
        
    print("-- Executing cascade_svm using dClay blocks --")
    ds.use_dataclay = True
    cascade_svm()

    
