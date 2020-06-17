#!/usr/bin/env python
from dataclay.api import init, finish
from pycompss.api.task import task
from pycompss.api.api import compss_wait_on, compss_barrier
from pycompss.api.parameter import IN, INOUT, CONCURRENT

# Init dataClay session
init()

from DemoNS.classes import Person, People

@task(people_collection=IN)
def addperson(people_collection, index):
    person = Person("Untitled Meatbag", 18 + index)
    people_collection.add(person)


if __name__ == "__main__":
    # Prepare the people collection
    people = People()
    people.make_persistent(alias="MeatbagMeeting")

    for i in range(10):
        addperson(people, i)

    compss_barrier()
    print(people)

    # Close session
    finish()
