from dataclay import DataClayObject, dclayMethod
from datetime import datetime

class DKB(DataClayObject):
    """
    @ClassField KB dict<str, list<SharedNS.classes.ObjectKB>>
    @ClassField identifiedObjects list<SharedNS.classes.Event>
    @ClassField objectsInOSM dict<SharedNS.classes.Position, SharedNS.classes.Event>
    @ClassField objectsInAllegro list<SharedNS.classes.Event>
    """
    @dclayMethod()
    def __init__(self):
        self.KB = dict()
        self.identifiedObjects = []
        self.objectsInOSM = dict()
        self.objectsInAllegro = []

    @dclayMethod(subarea='str')
    def initSubArea(self, subarea):
        if subarea not in self.KB:
            self.KB[subarea] = []
            for i in range(7*24):
                self.KB[subarea].append(ObjectKB())

    @dclayMethod(event='SharedNS.classes.Event', subarea='str')
    def aggregatte(self, event, subarea):
        print("Aggreggatting event to subarea %s" % subarea)
        try:
            minute = (event.dt.hour)+event.dt.minute
            day = event.dt.weekday()
            if subarea in self.KB:
                self.KB[subarea][(day*24)+minute].update(event)

            else:
                print("Creating subarea %s" % subarea)
                self.KB[subarea] = []
                
                for i in range(7*24):
                    self.KB[subarea].append(ObjectKB())
                print("Finished subarea with %i objectkbs" % len(self.KB[subarea]))
                print("Updating minute in ObjectKB")
                self.KB[subarea][(day*24)+minute].update(event)
                
        except Exception as e:
            print("Some error: %s" % e)
            print(event.dt)
            #Event datetime no reconocido"

    @dclayMethod(event='SharedNS.classes.Event')
    def updateOSMObject(self, event):
        self.objectsInOSM[event.pos] = event

    @dclayMethod(return_='str')
    def __str__(self):
        string = "KB size = %i" % len(self.KB)
        for key, value in self.KB.items():
            string +='@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ \n'
            string += 'Sub-area: ' + key + '\n'
            for v in value:
                if v.toPrint == 1:
                    string += str(v) + '\n'
        #string += '\nIdentified Objects: \n'
        #for a in self.identifiedObjects:
        #    string += str(a) + ", "
        #string += '\nObjects in Allegro:\n'
        #for a in self.objectsInAllegro:
        #    string += str(a) + ", "
        return string

    @dclayMethod(events='anything', subarea='str')
    def updateKB(self, events, subarea):
        print("Calling aggreggate events in subarea")
        self.aggregatteEvents(events, subarea)
        print("Calling appendIdentified")
        self.appendIdentified(events)
        print("Calling updateOSMObjects")
        self.updateOSMObjects(events)
        print("Calling updateAllegroObjects")
        self.updateAllegroObjects(events)

    @dclayMethod(events='anything', subarea='str')
    def aggregatteEvents(self, events, subarea):
        print("Aggreggatting events")
        for event in events:
            self.aggregatte(event,subarea)


    @dclayMethod(events='anything')
    def appendIdentified(self, events):
        self.identifiedObjects.extend(events)

    @dclayMethod(events='anything')
    def updateOSMObjects(self,events):
        for event in events:
            self.updateOSMObject(event)
    
    @dclayMethod(events='anything')
    def updateAllegroObjects(self, events):
        self.objectsInAllegro = events 

    @dclayMethod()
    def resetDKB(self):
        self.KB = dict()
        self.identifiedObjects = []
        self.objectsInOSM = dict()
        self.objectsInAllegro = []

class ObjectKB(DataClayObject):
    """
    @ClassField dt anything
    @ClassField totalTrafficFlow int
    @ClassField trafficFlow dict<str, SharedNS.classes.ObjectTrafficFlow>
    @ClassField pedestrianFlow int
    @ClassField toPrint int
    """
    @dclayMethod()
    def __init__(self):
        self.dt = None
        self.totalTrafficFlow = 0
        self.trafficFlow = dict()
        self.pedestrianFlow = 0
        self.toPrint= 0

    @dclayMethod(event = 'SharedNS.classes.Event')
    def update(self, event):
        self.toPrint = 1
        self.dt = event.dt
        if isinstance(event.object, Vehicle):
            self.totalTrafficFlow += 1
            if event.object.type in self.trafficFlow:
                self.trafficFlow[event.object.type].update(event.object.speed)
            else:
                self.trafficFlow[event.object.type] = ObjectTrafficFlow(event.object.speed)
        elif isinstance(event.object, PedestrianFlow):
            self.pedestrianFlow += event.object.value
        else:
                print('error: evento no reconocido durante la aggregacion')

    @dclayMethod(return_='str')
    def __str__(self):
        string = '########################################################### \n'
        string +=   'Hour: ' + str(self.dt.hour) + ' Minute: '+ str(self.dt.minute)
        string +='\n----------------------------------------------------------- \n'
        string+='Traffic Flow: \n Total vehicles registered: ' + str(self.totalTrafficFlow) +   '\n '
        for key, value in self.trafficFlow.items():
            string += '--> Vehicle Type: ' + key + ' ' + str(value) + '\n'
        string +='----------------------------------------------------------- \n'
        string += ' Pedestrian Flow: \n'
        string +=  '-->  Total Pedestrian Flow: ' + str(self.pedestrianFlow) + '\n'
        string += '########################################################### \n'
        return string




class Event(DataClayObject):
    """
    @ClassField object anything
    @ClassField pos SharedNS.classes.Position
    @ClassField dt anything
    @ClassField idEvent int
    @ClassField idClass int
    """
    @dclayMethod(eventType='anything', pos='SharedNS.classes.Position', dtime='anything', idEvent='int', idClass='int')
    def __init__(self, eventType, pos, dtime, idEvent, idClass):
        self.object = eventType
        self.pos = pos
        self.dt = dtime
        self.idEvent = idEvent
        self.idClass = idClass
        print('Init Event ' + str(dtime))

    @dclayMethod(return_='str')
    def __str__(self):
        return'Event Type: ' + self.object.__class__.__name__ + ', Position: [' + str(self.pos) + '], Datetime: ' +  str(self.dt) + ', idEvent: ' + str(self.idEvent) + ', idClass: ' + str(self.idClass)+ ' '+ str(self.object) + '\n'

class Position(DataClayObject):
    """
    @ClassField lon anything
    @ClassField lat anything
    """
    @dclayMethod(lon='anything', lat='anything')
    def __init__(self, lon, lat):
        self.lon = lon
        self.lat = lat

    @dclayMethod(other='SharedNS.classes.Position', return_='bool')
    def __eq__(self, other):
        return isinstance(other, self.__class__) and self.lon == other.lon and self.lat == other.lat

    @dclayMethod(return_='anything')
    def __hash__(self):
        return hash(self.lon) ^ hash(self.lat)

    @dclayMethod(return_='str')
    def __str__(self):
        return 'Longitude: ' + str(self.lon) + ', Latitude: ' + str(self.lat)


class Vehicle(DataClayObject):
    """
    @ClassField type str
    @ClassField speed float
    @ClassField yaw float
    """
    @dclayMethod(vehicleType='str', speed='float', yaw='float')
    def __init__(self, vehicleType, speed, yaw):
        self.type = vehicleType
        self.speed = speed
        self.yaw = yaw

    @dclayMethod(return_='str')
    def __str__(self):
        return 'Predicted speed: ' + str(self.speed) + ', Predicted Yaw: ' + str(self.yaw)


class PedestrianFlow(DataClayObject):
    """
    @ClassField value int
    """
    @dclayMethod(value='int')
    def __init__(self, value):
        self.value = value

class ObjectTrafficFlow(DataClayObject):
    """
    @ClassField sum int
    @ClassField totalSpeed float
    @ClassField averageSpeed float
    """
    @dclayMethod(speed='float')
    def __init__(self, speed):
        self.sum = 1
        self.totalSpeed = speed
        self.averageSpeed = speed


    @dclayMethod(speed = 'float')
    def update(self, speed):
        self.sum+=1
        self.totalSpeed += speed
        self.averageSpeed = self.totalSpeed / float(self.sum)

    @dclayMethod(return_='str')
    def __str__(self):
        return 'Total Vehicles: ' + str(self.sum) + ' Average Speed: ' + str(self.averageSpeed)

class EventsInCar(DataClayObject):
    """
    @ClassField events list<SharedNS.classes.Event>
    @ClassField eventsById dict<int, SharedNS.classes.Event>
    @ClassFIeld eventsByTS dict<int, SharedNS.classes.Event>
    """

    @dclayMethod(new_events="anything")
    def __init__(self, new_events = []):
        self.events = new_events
        self.eventsById = dict()
        self.eventsByTS = dict()
        if len(new_events) > 0:
            for e in new_events:
                self.eventsById[e.idEvent] = e
                self.eventsByTS[int(e.dt.strftime('%s'))] = e

    @dclayMethod(new_event="SharedNS.classes.Event")
    def add_event(self, new_event):
        self.events.append(new_event)
        self.eventsById[new_event.idEvent] = new_event
        self.eventsByTS[int(new_event.dt.strftime('%s'))] = new_event

    @dclayMethod(new_events="anything")
    def add_events(self, new_events):
        self.events.extend(new_events)
        for e in new_events:
            self.eventsById[e.idEvent] = e
            self.eventsByTS[int(e.dt.strftime('%s'))] = e

    
    @dclayMethod()  
    def when_federated(self):
        print("Calling when federated in EventsInCar")
        kb = DKB.get_by_alias("DKB");
        kb.updateKB(self.events, "roundabout");#provisional
        print("Finished when federated in EventsInCar")

    @dclayMethod()
    def when_undeferated(self):
        self.events = list()
        self.eventsById = dict()
        self.eventsByTS = dict()
    

    @dclayMethod()
    def delete(self):
        self.events = list()
        self.eventsById = dict()
        self.eventsByTS = dict()

class ObjMove(DataClayObject):
    """
    @ClassField events list<SharedNS.classes.Event>
    """

    @dclayMethod(size = 'int')
    def __init__(self, size = 21):
        self.events = list()
        self.size = size

    @dclayMethod(new_event="SharedNS.classes.Event")
    def add_event(self, new_event):
        self.events.append(new_event)
        if len(self.events) > self.size:
            self.events[:1] = []



class GlobalEventsInCar(DataClayObject):
    """
    @ClassField events list<SharedNS.classes.Event>
    @ClassField eventsById dict<int, SharedNS.classes.ObjMove>
    @ClassField tpById dict<int, str>
    """

    @dclayMethod(new_events="anything")
    def __init__(self, new_events = []):
        self.events = new_events
        self.eventsById = dict()
        self.tpById = dict()
        if len(new_events) > 0:
            for e in new_events:
                ievents = self.eventsById.get(e.idEvent)
                if ievents is None:
                    ievents = ObjMove()
                    self.eventsById[e.idEvent] = ievents
                ievents.add_event(e)
 #               self.eventsByTS[int(e.dt.strftime('%s'))] = e


    @dclayMethod(oid="int")
    def get_by_id(self, oid):
        return self.eventsById[oid]

    @dclayMethod(return_="str")
    def get_ids(self):
        return self.eventsById.keys()

    @dclayMethod(new_event="SharedNS.classes.Event")
    def add_event(self, new_event):
        self.events.append(new_event)
        ievents = self.eventsById.get(new_event.idEvent)
        if ievents is None:
            ievents = ObjMove()
            self.eventsById[new_event.idEvent] = ievents
        ievents.add_event(new_event)
  #      self.eventsByTS[int(new_event.dt.strftime('%s'))] = new_event

    @dclayMethod(oid='int', pred='str')
    def add_prediction(self, oid, pred):
        self.tpById[oid] = pred

    @dclayMethod(new_events="anything")
    def add_events(self, new_events):
        self.events.extend(new_events)
        for e in new_events:
            ievents = self.eventsById.get(e.idEvent)
            if ievents is None:
                ievents = ObjMove()
                self.eventsById[e.idEvent] = ievents
            ievents.add_event(e)
   #         self.eventsByTS[int(e.dt.strftime('%s'))] = e
        #kb = DKB.get_by_alias("DKB");
        #kb.updateKB(new_events, "roundabout");


    @dclayMethod()
    def when_federated(self):
        print("Calling when federated in EventsInCar")
        kb = DKB.get_by_alias("DKB");
        kb.updateKB(self.events, "roundabout");#provisional


    @dclayMethod()
    def when_undeferated(self):
        self.events = list()
        self.eventsById = dict()
    #    self.eventsByTS = dict()


    @dclayMethod()
    def delete(self):
        self.events = list()
        self.eventsById = dict()
     #   self.eventsByTS = dict()