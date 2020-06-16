#!/usr/bin/env python
from dataclay import api, getRuntime
import dataclay_dislib as ds

def gridsearch_cv():
    import numpy as np
    from dislib.model_selection import GridSearchCV
    from dislib.classification import RandomForestClassifier
    from sklearn import datasets
    x_np, y_np = datasets.load_iris(return_X_y=True)
    x = ds.array(x_np, (30, 4))
    y = ds.array(y_np[:, np.newaxis], (30, 1))
    param_grid = {'n_estimators': (2, 4), 'max_depth': range(3, 5)}
    rf = RandomForestClassifier()
    searcher = GridSearchCV(rf, param_grid)
    searcher.fit(x, y)
    print(searcher.cv_results_)
    
if __name__ == "__main__":

    print("-- Executing gridsearch_cv --")
    gridsearch_cv()
        
    print("-- Executing gridsearch_cv using dClay blocks --")
    ds.USE_DATACLAY = True
    gridsearch_cv()

    
