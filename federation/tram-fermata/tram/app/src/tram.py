 #!/usr/bin/env python3
import traceback
import sys
from dataclay.api import init, finish, register_dataclay, get_dataclay_id

# Init dataClay session
init()

from SharedNS.classes import Tram

def register_tram(tram_name):
    # Register
    tram = Tram(tram_name)
    tram.make_persistent(tram_name)
    print("Registered tram %s " % tram_name)

def approach_to_fermata(tram_name, fermata_name, fermata_ip, fermata_port):
    
    print("Registering external dataClay at %s:%s" % (fermata_ip, fermata_port))
    fermata_dataclay_id = register_dataclay(fermata_ip, fermata_port)
    print("Tram %s approaching to fermata %s" % (tram_name, fermata_name))

    tram = Tram.get_by_alias(tram_name)
    tram.set_current_fermata(fermata_name)
    tram.federate(fermata_dataclay_id)
    print("Tram was federated with Fermata")
       

def leave_fermata(tram_name, fermata_name, fermata_ip, fermata_port):
    fermata_dataclay_id = get_dataclay_id(fermata_ip, fermata_port)
    tram = Tram.get_by_alias(tram_name)
    print("Tram %s leaving fermata %s" % (tram_name, fermata_name))
    tram.unfederate(fermata_dataclay_id)
    tram.set_current_fermata("")
    print("Tram was unfederated with Fermata")

if __name__ == "__main__":
    print(sys.argv)
    if len(sys.argv) < 2 :
        print("Usage: python tram.py operation")
        sys.exit(1)
    try:
        operation = sys.argv[1]
        if operation == "register_tram":
            if len(sys.argv) != 3 :
                raise Exception("Usage: python tram.py register_tram tram_name")
            tram_name = sys.argv[2]
            register_tram(tram_name)
            
        elif operation == "approach_to_fermata":
            if len(sys.argv) != 6 :
                raise Exception("Usage: python tram.py approach_to_fermata tram_name fermata_name fermata_ip fermata_port")
            tram_name = sys.argv[2]
            fermata_name = sys.argv[3]
            fermata_ip = sys.argv[4]
            fermata_port = int(sys.argv[5])
            approach_to_fermata(tram_name, fermata_name, fermata_ip, fermata_port)
            
        elif operation == "leave_fermata":
            if len(sys.argv) != 6 :
                raise Exception("Usage: python tram.py leave_fermata tram_name fermata_name fermata_ip fermata_port")
            tram_name = sys.argv[2]
            fermata_name = sys.argv[3]
            fermata_ip = sys.argv[4]
            fermata_port = int(sys.argv[5])
            leave_fermata(tram_name, fermata_name, fermata_ip, fermata_port)
                       
        else:
            raise Exception("ERROR: operation not defined")
            
    except:
        traceback.print_exc()
    # Close session
    finish()
    exit(0)
