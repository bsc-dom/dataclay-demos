from dataclay import DataClayObject, dclayMethod

class dClayDisBlocks(DataClayObject):
    """
    @ClassField blocks list<DemoNS.classes.dClayBlock>
    """
    
    @dclayMethod(blocks="list<DemoNS.classes.dClayBlock>")
    def __init__(self, blocks):
        self.blocks = blocks

    @dclayMethod(return_="anything")
    def __array__(self):
        np_blocks = []
        for dataclay_block in self.blocks:
            blocks.append(dataclay_block)
        return np_blocks
    
    @dclayMethod(return_="anything")
    def __iter__(self):
        for dataclay_block in self.blocks:
            yield dataclay_block.block

    @dclayMethod(key=int,return_="anything")
    def __getitem__(self, key):
        return self.blocks[key].block
    
    @dclayMethod(index=int,value="anything")
    def __setitem__(self,index, value):
        self.blocks[index] = dClayBlock(value)
        # make persistent?
    
    @dclayMethod(index=int)
    def __delitem__(self, index):
        """Delete an item"""
        del self.blocks[index]
    
    @dclayMethod(return_=int)
    def __len__(self):
        return len(self.blocks)


class dClayBlock(DataClayObject):
    """
    @ClassField block anything
    """
    @dclayMethod(block="anything")
    def __init__(self, block):
        self.block = block

    @dclayMethod(return_="anything")
    def __array__(self):
        return self.bock
    
    @dclayMethod(return_="anything")
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
    