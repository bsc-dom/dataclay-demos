from dataclay import DataClayObject, dclayMethod

class dClayBlock(DataClayObject):
    """
    @ClassField block anything
    """
    @dclayMethod(block="anything")
    def __init__(self, block):
        self.block = block

    @dclayMethod(return_="anything")
    def __array__(self):
        return self.block
    
    @dclayMethod(func="anything",local_args="list<anything>",local_kw_args="dict<str,anything>",return_="anything")
    def dataclay_block_apply(self, func, local_args, local_kw_args):
        print("Calling block apply with args:")
        print(str(local_args))
        print(str(local_kw_args))
        import traceback
        try:
            result = func(self.block, *local_args, **local_kw_args)
        except:
            traceback.print_exc()
        print("Applied function %s to dataClay block" % func.__name__)
        print("Result = ")
        print(str(result))
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
    
    @dclayMethod(return_='str')
    def __repr__(self):
        return str(self.block)
    
    @dclayMethod(return_='str')
    def __str__(self):
        return str(self.block)
    