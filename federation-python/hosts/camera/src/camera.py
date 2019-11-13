 #!/usr/bin/env python3
import traceback
import sys
from dataclay.api import init, finish, register_dataclay

# Init dataClay session
init()
from DemoNS.classes import CameraInfo

def register_camera(camera_name, fermata_name, fermata_ip, fermata_dataclay_port):
    # Register external fermata
    print("Registering external dataClay at %s:%s" % (fermata_ip, fermata_dataclay_port))
    fermata_id = register_dataclay(fermata_ip, fermata_dataclay_port)

    # Register camera
    camera = CameraInfo(camera_name, fermata_name)
    camera.make_persistent(camera_name)
    print("Registered camera %s " % camera_name)
    camera.federate(fermata_id)
    print("Camera was federated with fermata")

def set_ambulances(camera_name, num_ambulances):
    camera = CameraInfo.get_by_alias(camera_name)
    camera.set_ambulances(num_ambulances)
    
if __name__ == "__main__":
    print(sys.argv)
    if len(sys.argv) < 2 :
        print("Usage: python camera.py operation")
        sys.exit(1)
    try:
        operation = sys.argv[1]
        if operation == "register_camera":
            if len(sys.argv) != 6 :
                raise Exception("Usage: python camera.py register_camera camera_name fermata_name fermata_ip fermata_dataclay_port")
            camera_name = sys.argv[2]
            fermata_name = sys.argv[3]
            fermata_ip = sys.argv[4]
            fermata_dataclay_port = int(sys.argv[5])
            register_camera(camera_name, fermata_name, fermata_ip, fermata_dataclay_port)
        elif operation == "set_ambulances":
            if len(sys.argv) != 4 :
                raise Exception("Usage: python camera.py set_ambulances num_ambulances")
            camera_name = sys.argv[2]
            num_ambulances = int(sys.argv[3])
            set_ambulances(camera_name, num_ambulances)
        else:
            raise Exception("ERROR: operation not defined")
    except:
        traceback.print_exc()
    # Close session
    finish()
    exit(0)
