#!/usr/bin/env python
import os
import sys
from itertools import cycle

from dataclay import api, getRuntime

api.init()

from DemoNS.classes import TextCollection


def generate_text(text_collection_alias, num_texts):
    text_collection = TextCollection()
    text_collection.make_persistent(text_collection_alias)
    for i in range(int(num_texts)):
        text_collection.add_text("Should do a Lorem Ipsum here, but instead I will repeat here some do and do nots and so on.")
    

if __name__ == "__main__":
    if len(sys.argv) < 2 or len(sys.argv) > 4:
        print("""
    Usage:

        ./textcollectiongen.py [text_collection_alias] [num_texts]
    """)
        exit(1)

    print(" ###################################")
    print(" # Start TextCollection generation #")
    print(" ###################################")
    
    generate_text(sys.argv[1], sys.argv[2])
    

    print()
    print(" # TextCollection generated")
