 #!/usr/bin/env python3
import traceback
import sys
from dataclay.api import init, finish, register_external_dataclay

# Init dataClay session
init()

from DemoNS.classes import FermataInfo

def print_fermata(fermata_name):
    fermata = FermataInfo.get_by_alias(fermata_name)
    print(str(fermata))
    
def register_fermata(fermata_name, citta_ip, citta_dataclay_port):
    print("Registering external dataClay at %s:%s" % (citta_ip, citta_dataclay_port))
    citta_id = register_external_dataclay(citta_ip, citta_dataclay_port)

    fermata = FermataInfo(fermata_name)
    fermata.make_persistent(fermata_name)
    print("Registered fermata")
    fermata.federate(citta_id)
    print("Fermata was federated with citta")
   
def priorize_ambulances(fermata_name):
    fermata = FermataInfo.get_by_alias(fermata_name)
    for camera in fermata.get_cameras().values():
        # semaforo name is same than camera name replacing camera for semaforo
        semaforo_name = camera.get_name().replace("camera","semaforo")
        print("Checking semaforo %s" % semaforo_name)
        semaforo = fermata.get_semaforo(semaforo_name)
        if semaforo is not None:
            ambulances = camera.get_ambulances()
            print("Found %s ambulances. Checking semaforo %s" % (str(ambulances), semaforo_name))

            if ambulances > 0:
                semaforo.set_color("\033[0;31mRED\033[0m")
            if ambulances == 0:
                semaforo.set_color("\033[0;32mGREEN\033[0m")


if __name__ == "__main__":
    print(sys.argv)
    if len(sys.argv) < 2 :
        print("Usage: python fermata.py operation")
        sys.exit(1)
    try:
        operation = sys.argv[1]
        if operation == "register_fermata":
            if len(sys.argv) != 5 :
                raise Exception("Usage: python fermata.py register_fermata fermata_name citta_ip citta_dataclay_port")
            fermata_name = sys.argv[2]
            citta_ip = sys.argv[3]
            citta_dataclay_port = int(sys.argv[4])
            register_fermata(fermata_name, citta_ip, citta_dataclay_port)
        elif operation == "print_fermata":
            if len(sys.argv) != 3 :
                raise Exception("Usage: python fermata.py print_fermata fermata_name")
            fermata_name = sys.argv[2]
            print_fermata(fermata_name)
        elif operation == "priorize_ambulances":
            if len(sys.argv) != 3 :
                raise Exception("Usage: python fermata.py priorize_ambulances fermata_name")
            fermata_name = sys.argv[2]
            priorize_ambulances(fermata_name)
        else:
            raise Exception("ERROR: operation not defined")
            
    except:
        traceback.print_exc()
    # Close session
    finish()
    exit(0)
