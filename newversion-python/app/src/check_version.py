#!/usr/bin/env python2
import sys

from dataclay.api import init, finish, get_backends_info
from storage.api import getByID

# Init dataClay session
init()

from DemoNS.classes import Person, People


class Attributes(object):
    pass


def usage():
    print("Usage: newversion.py <colname> <personName> <personAge>")


def init_attributes(attributes):
    if len(sys.argv) != 4:
        print("ERROR: Missing parameters")
        usage()
        exit(2)
    attributes.object_id = sys.argv[1]
    attributes.p_name = sys.argv[2]
    attributes.p_age = int(sys.argv[3])

if __name__ == "__main__":
    attributes = Attributes()
    init_attributes(attributes)

    # Create new version 
    person_version = getByID(attributes.object_id)    
    
    print("[LOG] Check versioned person: ")
    print(person_version)
    
    # Close session
    finish()
