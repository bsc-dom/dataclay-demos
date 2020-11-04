from dataclay import DataClayObject, dclayMethod


class Position(DataClayObject):
    """
    @ClassField x int
    @ClassField y int
    """

    @dclayMethod(x='int', y='int')
    def __init__(self, x, y):
        self.x = x
        self.y = y
        
    @dclayMethod(return_="str")
    def __str__(self):
        return "(%s,%s)" % (str(self.x), str(self.y))


class Event(DataClayObject):
    """
    @ClassField name
    @ClassField event_type int
    @ClassField timestamp str
    @ClassField position SharedNS.classes.Position
    """

    @dclayMethod(name='str', event_type='int', timestamp='str', position='SharedNS.classes.Position')
    def __init__(self, name, event_type, timestamp, position):
        self.name = name
        self.event_type = event_type
        self.timestamp = timestamp
        self.position = position
    
    @dclayMethod(return_="str")
    def __str__(self):
        return "{EVENT at position=%s, type=%s, timestamp = %s}" % (self.position, str(self.event_type), self.timestamp);


class AggregatedEvents(DataClayObject):
    """
    @ClassField total_events int
    """
    
    @dclayMethod()
    def __init__(self):
        self.total_events = 0

    @dclayMethod(delta="int")
    def increment_events(self, delta):
        self.total_events = self.total_events + delta
    

class City(DataClayObject):
    """
    @ClassField snapshots dict<str, SharedNS.classes.EventsInCar>
    @ClassField aggregation SharedNS.classes.AggregatedEvents
    """
    
    @dclayMethod()
    def __init__(self):
        self.snapshots = dict()
        self.aggregation = AggregatedEvents()
    
    @dclayMethod(snapshot_name="str", new_events="SharedNS.classes.EventsInCar")
    def add_snapshot(self, snapshot_name, new_events):
        self.snapshots[snapshot_name] = new_events
        
    @dclayMethod(return_="SharedNS.classes.AggregatedEvents")
    def get_aggregation(self):
        return self.aggregation

    @dclayMethod(snapshot_name="str")
    def remove_snapshot(self, snapshot_name):
        del self.snapshots[snapshot_name]

    @dclayMethod(return_="str")
    def __str__(self):
        result = ["["]
        for snapshot_name in self.snapshots:
            result.append("%s: %s \n" % (snapshot_name, self.snapshots[snapshot_name]))
        result.append("]")
        return str(result)

class EventsInCar(DataClayObject):
    """
    @ClassField name str
    @ClassField events list<SharedNS.classes.Event>
    """

    @dclayMethod(name="str")
    def __init__(self, name):
        self.events = list()
        self.name = name

    @dclayMethod(new_event="SharedNS.classes.Event")
    def add_event(self, new_event):
        self.events.append(new_event)

    @dclayMethod()  
    def when_federated(self):
        # This is executed in a city fog node. Since they are independent dataClays,
        # the alias can be fixed.
        print("Calling when federated in EventsInCar")
        city = City.get_by_alias("my-pycity")
        city.add_snapshot(self.name, self)

    @dclayMethod()
    def when_unfederated(self):
        print("Calling when unfederated in EventsInCar")
        city = City.get_by_alias("my-pycity")
        city.remove_snapshot(self.name)

    @dclayMethod(return_="str")
    def __str__(self):
        result = ["["]
        for event in self.events:
            result.append(" %s " % (event))
        result.append("]")
        return str(result)
