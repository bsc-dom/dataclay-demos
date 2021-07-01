from dataclay import DataClayObject, dclayMethod
from dataclay.contrib.synchronization import SequentialConsistencyMixin


class CameraInFermata(DataClayObject, SequentialConsistencyMixin):
    """
    @dclayReplication(afterUpdate='synchronize', inMaster='False')
    @ClassField ambulances int
    """

    @dclayMethod()
    def __init__(self):
        self.ambulances = 0

    @dclayMethod(ambulances='int')
    def set_ambulances(self, ambulances):
        self.ambulances = ambulances

    @dclayMethod(return_='int')
    def get_ambulances(self):
        return self.ambulances


class SemaforoInFermata(DataClayObject, SequentialConsistencyMixin):
    """
    @dclayReplication(afterUpdate='synchronize', inMaster='False')
    @ClassField color str
    """
    @dclayMethod()
    def __init__(self):
        self.color = "GREEN"

    @dclayMethod(color='str')
    def set_color(self, color):
        self.color = color

    @dclayMethod(return_='str')
    def get_color(self):
        return self.color
    
    @dclayMethod(return_='str')
    def __str__(self):
        return self.color

class Fermata(DataClayObject):
    """
    @ClassField name str
    @ClassField camera_left SharedNS.classes.CameraInFermata
    @ClassField semaforo_left SharedNS.classes.SemaforoInFermata
    @ClassField camera_right SharedNS.classes.CameraInFermata
    @ClassField semaforo_right SharedNS.classes.SemaforoInFermata
    @ClassField trams dict<str,SharedNS.classes.Tram>
    """
    
    @dclayMethod(name='str')
    def __init__(self, name):
        self.camera_left = CameraInFermata()
        self.semaforo_left = SemaforoInFermata()
        self.trams = dict()
        self.name = name
        
    @dclayMethod(return_='str')
    def get_name(self):
        return self.name        
           
    @dclayMethod(tram='SharedNS.classes.Tram')
    def add_tram(self, tram):
        self.trams[tram.get_name()] = tram
    
    @dclayMethod(tram_name='str')
    def remove_tram(self, tram_name):
        del self.trams[tram_name]
    
    @dclayMethod(return_='dict<str,SharedNS.classes.Tram>')        
    def get_trams(self):
        return self.trams
        
    @dclayMethod(return_='SharedNS.classes.SemaforoInFermata')
    def get_semaforo_left(self):
        return self.semaforo_left

    @dclayMethod(return_='SharedNS.classes.CameraInFermata')
    def get_camera_left(self):
        return self.camera_left

    @dclayMethod(return_='str')
    def __str__(self):
        result = ["", "{ Fermata: "] 
        result.append("       - name : %s " % self.name)
        result.append("       - approaching_trams : {")
        for tram_name, tram in self.trams.items():
            result.append("           - %s" % (str(tram)))
        result.append("       }")
        result.append("       - semaforos : {")
        result.append("           - semaforo_left: %s" % (str(self.semaforo_left)))
        result.append("       }")
        result.append("}")
        return "\n".join(result)


class Tram(DataClayObject):
    """
    @ClassField name str
    @ClassField x_pos int
    @ClassField y_pos int
    @ClassField on_time bool
    @ClassField current_fermata str
    """

    @dclayMethod(name='str')
    def __init__(self, name):
        self.name = name
        self.x_pos = 0
        self.y_pos = 0
        self.on_time = True
        self.current_fermata = ""
        
    @dclayMethod(return_='str')
    def get_name(self):
        return self.name

    @dclayMethod(x='int', y='int')  
    def set_position(self, x, y):
        self.x_pos = x
        self.y_pos = y
        
    @dclayMethod(on_time='bool')  
    def set_on_time(self, on_time):
        self.on_time = on_time 

    @dclayMethod(current_fermata='str')  
    def set_current_fermata(self, current_fermata):
        self.current_fermata = current_fermata 

    @dclayMethod()  
    def when_federated(self):
        # This is executed in a fog node. Since they are independent dataClays,
        # the alias can be fixed.
        import traceback
        try:
            fermata = Fermata.get_by_alias(self.current_fermata)
            fermata.add_tram(self)
        except:
            traceback.print_exc()
        print("***** Tram was federated!")

    @dclayMethod()  
    def when_unfederated(self):
        fermata = Fermata.get_by_alias(self.current_fermata)
        fermata.remove_tram(self.name)
        print("***** Tram was unfederated!")

    @dclayMethod(return_='str')
    def __str__(self):
        return "{name=%s,position=%i,%i,on_time=%s}" % (str(self.name), self.x_pos, self.y_pos, str(self.on_time))

   