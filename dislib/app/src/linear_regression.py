#!/usr/bin/env python
from dataclay import api, getRuntime
import dataclay_dislib as ds

def linear_regression():
    import numpy as np
    from dislib.regression import LinearRegression
    from pycompss.api.api import compss_wait_on
    x_data = np.array([1, 2, 3, 4, 5]).reshape(-1, 1)
    y_data = np.array([2, 1, 1, 2, 4.5]).reshape(-1, 1)
    bn, bm = 2, 2
    x = ds.array(x=x_data, block_size=(bn, bm))
    y = ds.array(x=y_data, block_size=(bn, bm))
    reg = LinearRegression()
    reg.fit(x, y)
    # y = 0.6 * x + 0.3
    reg.coef_
    #0.6
    reg.intercept_
    #0.3
    x_test = np.array([3, 5]).reshape(-1, 1)
    test_data = ds.array(x=x_test, block_size=(bn, bm))
    pred = reg.predict(test_data).collect()
    pred
    #array([2.1, 3.3])

    
if __name__ == "__main__":

    print("-- Executing linear_regression --")
    linear_regression()
        
    print("-- Executing linear_regression using dClay blocks --")
    ds.USE_DATACLAY = True
    linear_regression()

    
