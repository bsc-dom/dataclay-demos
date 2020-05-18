#!/usr/bin/env python
from dataclay import api, getRuntime
import dataclay_dislib as ds


def recommendation_als(use_dataclay):
    import numpy as np
    from scipy.sparse import csr_matrix
    data = np.array([[0, 0, 5], [3, 0, 5], [3, 1, 2]])
    ratings = csr_matrix(data).transpose().tocsr()
    train = ds.array(ratings, block_size=(1, 3), use_dataclay=use_dataclay)
    from dislib.recommendation import ALS
    als = ALS()
    als.fit(train)
    print('Ratings for user 0: %s' % als.predict_user(user_id=0))
    
if __name__ == "__main__":

    print("-- Executing recommendation_als --")
    recommendation_als(False)
        
    print("-- Executing recommendation_als using dClay blocks --")
    recommendation_als(True)

    
