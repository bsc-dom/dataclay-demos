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
        # Get dataClay 2 ID
        dataclay2_addr = os.environ['DATACLAY2_ADDR']
        dataclay2_addr_split = dataclay2_addr.split(":")
        dataclay2_ip = dataclay2_addr_split[0]
        dataclay2_port = int(dataclay2_addr_split[1])
        print("Getting external dataClay id at %s" % dataclay2_addr)
        dataclay_id2 = get_dataclay_id(dataclay2_ip, dataclay2_port)
        # Unfederate all
        i = 0
        while i < 10:
            print("Unfederating events block%i" % i)
            federated_events = EventsInCar.get_by_alias("block%i" % i)
            federated_events.unfederate(dataclay_id2)
            i = i + 1

    except:
        traceback.print_exc()

    # Close session
    finish()
    exit(0)
