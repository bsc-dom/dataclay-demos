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
    if len(sys.argv) != 3:
        print("ERROR: Missing parameters")
        usage()
        exit(2)

    attributes.p_name = sys.argv[1]
    attributes.p_age = int(sys.argv[2])


if __name__ == "__main__":
    attributes = Attributes()
    init_attributes(attributes)

    # Get backends info 
    backends_info = get_backends_info()
    print("Obtained backends info:")
    backends = list(backends_info)
    for backend_id, exec_env in backends_info.items():
        print(exec_env)
        if (exec_env.name == "DS1"):
            first_backend = backend_id
        if (exec_env.name == "DS2"):
            second_backend = exec_env.hostname

    # Create new person
    person = Person(attributes.p_name, attributes.p_age)
    person.make_persistent(alias=attributes.p_name, backend_id=first_backend)

    print("[LOG] Created person: ")
    print(str(person))
    
    print("Object ID: %s:%s:%s" % (person.get_object_id(), person.get_hint(), person.get_class_extradata().class_id))
    print("Version backend: %s" % second_backend)
    
    # Close session
    finish()
