#!/usr/bin/env python
from dataclay.api import init, finish
from pycompss.api.task import task
from pycompss.api.api import compss_wait_on, compss_barrier
from pycompss.api.parameter import INOUT, IN, CONCURRENT
import os 

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

    num_workers = 2
    num_persons = 48 * 2
    for i in range(num_persons):
        addperson(people, i)

    #people = compss_wait_on(people)
    compss_barrier()
    print(people)
        
    print("APPLICATION FINISHED! Wait for dataClay and COMPSs shutdown...")
    
    home_dir =  os.getenv('HOME')
    job_id = os.getenv('SLURM_JOBID')

    print("REMEMBER: Traces will be stored at %s/.COMPSs/%s/trace" % (home_dir, job_id))
    # Close session
    finish()
