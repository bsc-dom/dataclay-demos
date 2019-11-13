 #!/usr/bin/env python3
import traceback
import sys
from dataclay.api import init, finish

# Init dataClay session
init()

from DemoNS.classes import CittyInfo, TramSystem

def register_city():
    citty = CittyInfo()
    citty.make_persistent("citta")
    print("Registered citty")
    
def register_tram_system():
    tram_system = TramSystem()
    tram_system.make_persistent("tram-system")
    print("Registered tram system")

def print_city_info():
    citty = CittyInfo.get_by_alias("citta")
    print("%s" % str(citty))
    
def print_tram_system_info():
    tram_system = TramSystem.get_by_alias("tram-system")
    print("%s" % str(tram_system))    
    
if __name__ == "__main__":
    print(sys.argv)
    if len(sys.argv) < 2 :
        print("Usage: python citta.py operation")
        sys.exit(1)
    try:
        operation = sys.argv[1]
        if operation == "register_city":
            register_city()
        elif operation == "register_tram_system":
            register_tram_system()
        elif operation == "print_city_info":
            print_city_info()
        elif operation == "print_tram_system_info":
            print_tram_system_info()
        else:
            raise Exception("ERROR: operation not defined")
            
    except:
        traceback.print_exc()
    # Close session
    finish()
    exit(0)
