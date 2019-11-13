 #!/usr/bin/env python3
import traceback
import sys
from dataclay.api import init, finish, register_dataclay

# Init dataClay session
init()

from DemoNS.classes import SemaforoInfo

def register_semaforo(semaforo_name, fermata_name, fermata_ip, fermata_dataclay_port):
    print("Registering external dataClay at %s:%s" % (fermata_ip, fermata_dataclay_port))
    fermata_id = register_dataclay(fermata_ip, fermata_dataclay_port)

    semaforo_info = SemaforoInfo(semaforo_name, fermata_name)
    semaforo_info.make_persistent(semaforo_name)
    print("Registered semaforo %s " % semaforo_name)
    semaforo_info.federate(fermata_id)
    print("Semaforo was federated with Fermata")
   
def print_color(semaforo_name):
    semaforo_info = SemaforoInfo.get_by_alias(semaforo_name)
    print(semaforo_info)

if __name__ == "__main__":
    print(sys.argv)
    if len(sys.argv) < 2 :
        print("Usage: python semaforo.py operation")
        sys.exit(1)
    try:
        operation = sys.argv[1]
        if operation == "register_semaforo":
            if len(sys.argv) != 6 :
                raise Exception("Usage: python semaforo.py register_semaforo semaforo_name fermata_name fermata_ip fermata_dataclay_port")
            semaforo_name = sys.argv[2]
            fermata_name = sys.argv[3]
            fermata_ip = sys.argv[4]
            fermata_dataclay_port = int(sys.argv[5])
            register_semaforo(semaforo_name, fermata_name, fermata_ip, fermata_dataclay_port)
        elif operation == "print_color":
            if len(sys.argv) != 3 :
                raise Exception("Usage: python semaforo.py print_color semaforo_name")
            semaforo_name = sys.argv[2]
            print_color(semaforo_name)
        else:
            raise Exception("ERROR: operation not defined")
            
    except:
        traceback.print_exc()
    # Close session
    finish()
    exit(0)
