from dataclay import DataClayObject, dclayMethod

class dClayBlock(DataClayObject):
    """
    @ClassField block anything
    @ClassField shape anything
    @ClassField ndim anything
    @ClassField nbytes anything
    @ClassField itemsize anything
    @ClassField size anything
    """
    @dclayMethod(block="anything")
    def __init__(self, block):
        self.block = block
        # FIXME: Required field for direct access like dClayBlock.shpae (not a dataClay object field)
        if hasattr(block, 'shape'):
            self.shape = block.shape
        if hasattr(block, 'ndim'):
            self.ndim = block.ndim
        if hasattr(block, 'size'):
            self.size = block.size
        if hasattr(block, 'itemsize'):
            self.itemsize = block.itemsize
        if hasattr(block, 'nbytes'):
            self.nbytes = block.nbytes
        
    @dclayMethod(return_="anything")
    def __array__(self):
        return self.block
    
    @dclayMethod(return_="anything")
    def transpose(self):
        # FIXME: This function is not using __array__ : dClayBlock.T
        return self.block.transpose()

    @dclayMethod(return_="bool")
    def dataclay_issparse(self):
        # FIXME: scipy isparse(dClayBlock)
        from scipy.sparse import issparse, csr_matrix
        return issparse(self.block)
    
    @dclayMethod(i="anything",j="anything",return_="anything")
    def get_item(self, i, j):
        # FIXME: This function is needed for direct access dClayBlock[i, j]
        return self.block[i, j]
    
    @dclayMethod(i="anything",j="anything",value="anything")
    def set_value(self, i, j, value):
        # FIXME: This function is needed for direct access dClayBlock[i][j] = value (setitem not working in this case)
        self.block[i][j] = value
    
    @dclayMethod(return_="anything")
    def get_block(self):
        return self.block
    
    @dclayMethod(func="anything",local_args="list<anything>",local_kw_args="dict<str,anything>",return_="anything")
    def dataclay_block_apply(self, func, local_args, local_kw_args):
        result = func(self.block, *local_args, **local_kw_args)
        return result
    
    @dclayMethod(return_="anything",_local=True)
    def __iter__(self):
        for elem in self.block:
            yield elem

    @dclayMethod(key="anything",return_="anything")
    def __getitem__(self, key):
        return self.block[key]
    
    @dclayMethod(index="anything",value="anything")
    def __setitem__(self, index, value):
        self.block[index] = value
    
    @dclayMethod(index="anything")
    def __delitem__(self, index):
        """Delete an item"""
        del self.block[index]
    
    @dclayMethod(return_=int)
    def __len__(self):
        return len(self.block)
    