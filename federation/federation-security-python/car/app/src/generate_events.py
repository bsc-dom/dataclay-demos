 #!/usr/bin/env python2
import traceback
import os
import datetime
from dataclay.api import init, finish, register_dataclay

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
        print("Registering external dataClay at %s" % dataclay2_addr)
        dataclay_id2 = register_dataclay(dataclay2_ip, dataclay2_port)
    
        # Create thousands of event
        current_date = datetime.datetime.now().strftime("%d-%m-%Y %I:%M:%S")
        event_type = 1
        i = 0
        while i < 10:
            print("Creating events %i" % i)
            events_to_federate = EventsInCar("Events%i" % i)
            position = Position(0, i)
            event = Event(f"event{i}", event_type, current_date, position)
        
            # add event to car
            events_to_federate.add_event(event)
        
            # Federate events
            events_to_federate.make_persistent(alias="block%i" % i)
            print("Federating events %i" % i)
            events_to_federate.federate(dataclay_id2)
            i = i + 1

    except:
        traceback.print_exc()

    # Close session
    finish()
    exit(0)
