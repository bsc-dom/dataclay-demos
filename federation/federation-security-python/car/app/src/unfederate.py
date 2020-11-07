 #!/usr/bin/env python2
import traceback
import os
import datetime
from dataclay.api import init, finish, \
    get_dataclay_id, unfederate

# Init dataClay session
init()

from SharedNS.classes import EventsInCar, Position, Event

if __name__ == "__main__":

    try:
        # Unfederate all 
        unfederate()
       
    except:
        traceback.print_exc()

    # Close session
    finish()
    exit(0)