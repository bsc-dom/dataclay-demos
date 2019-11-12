 #!/usr/bin/env python3
import traceback
import sys
from dataclay.api import init, finish, register_external_dataclay, get_external_dataclay_id

# Init dataClay session
init()

from DemoNS.classes import TramDynamicInfo, TramInfo, Position

def register_tram(tram_name, tramsystem_ip, tramsystem_dataclay_port):
    print("Registering external dataClay at %s:%s" % (tramsystem_ip, tramsystem_dataclay_port))
    tramsystem_id = register_external_dataclay(tramsystem_ip, tramsystem_dataclay_port)

    # Register
    position = Position(0, 0)
    tram_dynamic_info = TramDynamicInfo(position, tram_name)
    tram_info = TramInfo(tram_dynamic_info, tram_name)
    tram_info.make_persistent(tram_name)
    print("Registered tram %s " % tram_name)
    tram_info.federate(tramsystem_id)
    print("Tram was federated with TramSystem")

def approach_to_fermata(tram_name, fermata_name, fermata_ip, fermata_port):
    print("Registering external dataClay at %s:%s" % (fermata_ip, fermata_port))
    fermata_dataclay_id = register_external_dataclay(fermata_ip, fermata_port)
    print("Tram %s approaching to fermata %s" % (tram_name, fermata_name))

    tram_info = TramInfo.get_by_alias(tram_name)
    tram_info.get_dynamic_info().set_current_fermata(fermata_name)
    tram_info.get_dynamic_info().federate(fermata_dataclay_id)
    print("Tram was federated with Fermata")
       

def leave_fermata(tram_name, fermata_name, fermata_ip, fermata_port):
    fermata_dataclay_id = get_external_dataclay_id(fermata_ip, fermata_port)
    tram_info = TramInfo.get_by_alias(tram_name)
    print("Tram %s leaving fermata %s" % (tram_name, fermata_name))
    tram_info.get_dynamic_info().unfederate(fermata_dataclay_id)

    tram_info.get_dynamic_info().set_current_fermata("")
    print("Tram was unfederated with Fermata")

if __name__ == "__main__":
    print(sys.argv)
    if len(sys.argv) < 2 :
        print("Usage: python tram.py operation")
        sys.exit(1)
    try:
        operation = sys.argv[1]
        if operation == "register_tram":
            if len(sys.argv) != 5 :
                raise Exception("Usage: python tram.py register_tram tram_name tramsystem_ip tramsystem_dataclay_port")
            tram_name = sys.argv[2]
            tramsystem_ip = sys.argv[3]
            tramsystem_dataclay_port = int(sys.argv[4])
            register_tram(tram_name, tramsystem_ip, tramsystem_dataclay_port)
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
