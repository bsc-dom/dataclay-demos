 #!/usr/bin/env python3
import traceback
import sys
from dataclay.api import init, finish, register_dataclay

# Init dataClay session
init()

from DemoNS.classes import Fermata

def print_fermata(fermata_name):
    fermata = Fermata.get_by_alias(fermata_name)
    print(str(fermata))
    
def register_fermata(fermata_name):
    fermata = Fermata(fermata_name)
    fermata.make_persistent(fermata_name)
    print("Registered fermata")

def set_ambulances(fermata_name, num_ambulances):
    fermata = Fermata.get_by_alias(fermata_name)
    camera_left = fermata.get_camera_left() 
    camera_left.set_ambulances(num_ambulances)
    ambulances = camera_left.get_ambulances()
    print("Set %s ambulances detected from camera left" % (str(ambulances)))

def priorize_ambulances(fermata_name):
    fermata = Fermata.get_by_alias(fermata_name)
    semaforo_left = fermata.get_semaforo_left() 
    camera_left = fermata.get_camera_left() 
    print("Checking semaforo left")
    
    ambulances = camera_left.get_ambulances()
    print("Found %s ambulances" % (str(ambulances)))
    
    if ambulances > 0:
        semaforo_left.set_color("\033[0;31mRED\033[0m")
    if ambulances == 0:
        semaforo_left.set_color("\033[0;32mGREEN\033[0m")

    print("Semaforo left light is %s" % semaforo_left.get_color())

if __name__ == "__main__":
    print(sys.argv)
    if len(sys.argv) < 2 :
        print("Usage: python fermata.py operation")
        sys.exit(1)
    try:
        operation = sys.argv[1]
        if operation == "register_fermata":
            
            if len(sys.argv) != 3 :
                raise Exception("Usage: python fermata.py register_fermata fermata_name")
            fermata_name = sys.argv[2]
            register_fermata(fermata_name)
            
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
            
        elif operation == "set_ambulances":
            if len(sys.argv) != 4 :
                raise Exception("Usage: python fermata.py set_ambulances fermata_name num_ambulances")
            fermata_name = sys.argv[2]
            num_ambulances = int(sys.argv[3])
            set_ambulances(fermata_name, num_ambulances)
            
        else:
            raise Exception("ERROR: operation not defined")
            
    except:
        traceback.print_exc()
    # Close session
    finish()
    exit(0)
