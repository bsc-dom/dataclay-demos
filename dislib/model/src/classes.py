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
        print(self.block)
        return self.block[0]
    
    @dclayMethod(return_="anything",_local=True)
    def __iter__(self):
        for elem in self.block:
            yield elem

    @dclayMethod(key=int,return_="anything")
    def __getitem__(self, key):
        return self.block[key]
    
    @dclayMethod(index=int,value="anything")
    def __setitem__(self,index, value):
        self.block[index] = value
    
    @dclayMethod(index=int)
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
    