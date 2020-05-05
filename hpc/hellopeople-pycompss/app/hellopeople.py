#!/usr/bin/env python
from dataclay.api import init, finish
from pycompss.api.task import task
from pycompss.api.api import compss_wait_on, compss_barrier
from pycompss.api.parameter import INOUT

# Init dataClay session
init()

from DemoNS.classes import Person, People


@task(people_collection=INOUT)
def addperson(people_collection, index):
    person = Person("Untitled Meatbag", 18 + index)
    people_collection.add(person)


if __name__ == "__main__":
    # Prepare the people collection
    people = People()
    people.make_persistent(alias="MeatbagMeeting")

    num_workers = 2
    num_persons = 48 * 2
    for i in range(num_persons):
        addperson(people, i)

    #people = compss_wait_on(people)
    compss_barrier()
    print(people)

    print("APPLICATION FINISHED! Wait for dataClay and COMPSs shutdown...")

    # Close session
    finish()
