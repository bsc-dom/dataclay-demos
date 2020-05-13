from dataclay.api import init, finish, register_dataclay

if __name__=="__main__":
    from dataclay.api import init, finish
    init()
    from DemoNS.classes import *
    try:
        KBob = DKB.get_by_alias("DKB")
        GEIC = GlobalEventsInCar.get_by_alias("GEIC")
    except Exception:
        KBob = DKB()
        KBob.make_persistent(alias="DKB")
        GEIC = GlobalEventsInCar()
        GEIC.make_persistent(alias="GEIC")
    KBob.initSubArea("roundabout")
    city_addr_ip = os.environ['DATACLAY_CITY_IP']
    elements = []
    element = Event(Vehicle("Car", 0, -1), Position(float(1), float(1)), 1000, 0, 1)
    elements.append(element)
    GEIC.add_events(elements)
    dataclay_cloud = register_dataclay(city_addr_ip, 11034)
    import traceback
    try:
        GEIC.federate(dataclay_cloud)
    except:
        traceback.print_exc()
    
    print("Exiting Application...")
    finish()
    sys.exit(0)
    
    

