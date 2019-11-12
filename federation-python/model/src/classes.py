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

    @dclayMethod(return_="int")
    def get_x(self):
        return self.x

    @dclayMethod(return_="int")
    def get_y(self):
        return self.y

    @dclayMethod(x="int")
    def set_x(self, x):
        self.x = x

    @dclayMethod(y="int")
    def set_y(self, y):
        self.y = y

    @dclayMethod(return_="str")
    def __str__(self):
        return "(%s,%s)" % (str(self.x), str(self.y))

class CameraInfo(DataClayObject):
    """
    @ClassField name str
    @dclayReplication(afterUpdate='replicateToFederated', inMaster='False')
    @ClassField ambulances int
    @ClassField fermata_name str
    """

    @dclayMethod(name="str", fermata_name="str")
    def __init__(self, name, fermata_name):
        self.name = name
        self.ambulances = 0
        self.fermata_name = fermata_name
        
    @dclayMethod(return_="str")
    def get_name(self):
        return self.name

    @dclayMethod(ambulances='int')
    def set_ambulances(self, ambulances):
        self.ambulances = ambulances

    @dclayMethod(return_='int')
    def get_ambulances(self):
        return self.ambulances

    @dclayMethod()  
    def when_federated(self):
        # This is executed in a fog node. Since they are independent dataClays,
        # the alias can be fixed.
        fermata = FermataInfo.get_by_alias(self.fermata_name);
        fermata.add_camera_info(self);
        
    @dclayMethod(attribute="str", value="anything")
    def replicateToFederated(self, attribute, value):
        from dataclay.DataClayObjProperties import DCLAY_SETTER_PREFIX
        for dataclay_id in self.get_dataclays_object_is_federated_with():
            self.synchronize_federated(dataclay_id, DCLAY_SETTER_PREFIX + attribute, [value])
        dataclay_id = self.get_external_source_of_dataclay_object()
        if dataclay_id is not None:
            self.synchronize_federated(dataclay_id, DCLAY_SETTER_PREFIX + attribute, [value])
               
class SemaforoInfo(DataClayObject):
    """
    @ClassField name str
    @dclayReplication(afterUpdate='replicateToFederated', inMaster='False')
    @ClassField color str
    @ClassField fermata_name str
    """
    @dclayMethod(name='str', fermata_name='str')
    def __init__(self, name, fermata_name):
        self.name = name
        self.color = "GREEN"
        self.fermata_name = fermata_name

    @dclayMethod(return_='str')
    def get_name(self):
        return self.name

    @dclayMethod(color='str')
    def set_color(self, color):
        self.color = color
        
    @dclayMethod()  
    def when_federated(self):
        fermata = FermataInfo.get_by_alias(self.fermata_name);
        fermata.add_semaforo_info(self);

    @dclayMethod(return_="str")
    def __str__(self):
        return "{name=%s,color=%s}" % (self.name, self.color)
    
    @dclayMethod(attribute="str", value="anything")
    def replicateToFederated(self, attribute, value):
        from dataclay.DataClayObjProperties import DCLAY_SETTER_PREFIX
        for dataclay_id in self.get_dataclays_object_is_federated_with():
            self.synchronize_federated(dataclay_id, DCLAY_SETTER_PREFIX + attribute, [value])
        dataclay_id = self.get_external_source_of_dataclay_object()
        if dataclay_id is not None:
            self.synchronize_federated(dataclay_id, DCLAY_SETTER_PREFIX + attribute, [value])
    
class TramDynamicInfo(DataClayObject):
    """
    @ClassField position DemoNS.classes.Position
    @ClassField name str
    @ClassField on_time bool
    @ClassField current_fermata str
    """

    @dclayMethod(position='DemoNS.classes.Position', name='str')
    def __init__(self, position, name):
        self.position = position
        self.name = name
        self.on_time = True
        self.current_fermata = ""
        
    
    @dclayMethod(return_='DemoNS.classes.Position')
    def get_position(self):
        return self.position
    
    @dclayMethod(return_='str')
    def get_name(self):
        return self.name
    
    @dclayMethod(x='int', y='int')  
    def set_position(self, x, y):
        self.position.set_x(x)
        self.position.set_y(y)
        
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
        fermata = FermataInfo.get_by_alias(self.current_fermata);
        fermata.add_tram_dynamic_info(self);

    @dclayMethod()  
    def when_unfederated(self):
        fermata = FermataInfo.get_by_alias(self.current_fermata);
        fermata.remove_tram_dynamic_info(self.name);

    @dclayMethod(return_='str')
    def __str__(self):
        return "{name=%s,position=%s,on_time=%s}" % (str(self.name), str(self.position), str(self.on_time))

class FermataInfo(DataClayObject):
    """
    @ClassField name str
    @ClassField cameras dict<str, DemoNS.classes.CameraInfo>
    @ClassField semaforos dict<str, DemoNS.classes.SemaforoInfo>
    @ClassField trams dict<str,DemoNS.classes.TramDynamicInfo>
    """
    
    @dclayMethod(name='str')
    def __init__(self, name):
        self.cameras = dict()
        self.semaforos = dict()
        self.trams = dict()
        self.name = name
        
    @dclayMethod(return_='str')
    def get_name(self):
        return self.name        
    
    @dclayMethod(camera_info='DemoNS.classes.CameraInfo')
    def add_camera_info(self, camera_info):
        self.cameras[camera_info.get_name()] = camera_info

    @dclayMethod(semaforo_info='DemoNS.classes.SemaforoInfo')
    def add_semaforo_info(self, semaforo_info):
        self.semaforos[semaforo_info.get_name()] = semaforo_info
        
    @dclayMethod(tram_dynamic_info='DemoNS.classes.TramDynamicInfo')
    def add_tram_dynamic_info(self, tram_dynamic_info):
        self.trams[tram_dynamic_info.get_name()] = tram_dynamic_info
    
    @dclayMethod(tram_name='str')
    def remove_tram_dynamic_info(self, tram_name):
        del self.trams[tram_name]
    
    @dclayMethod(return_='dict<str, DemoNS.classes.TramDynamicInfo>')        
    def get_trams(self):
        return self.trams

    @dclayMethod(return_='dict<str, DemoNS.classes.CameraInfo>')
    def get_cameras(self):
        return self.cameras
        
    @dclayMethod(return_='dict<str, DemoNS.classes.SemaforoInfo>')
    def get_semaforos(self):
        return self.semaforos

    @dclayMethod(return_='DemoNS.classes.SemaforoInfo', semaforo_name='str')
    def get_semaforo(self, semaforo_name):
        for cur_semaforo_name, semaforo in self.semaforos.items():
            if cur_semaforo_name == semaforo_name:
                return semaforo
        return None

    @dclayMethod()  
    def when_federated(self):
        # This is executed in a city fog node. Since they are independent dataClays,
        # the alias can be fixed.
        citty = CittyInfo.get_by_alias("citta");
        citty.add_fermata_info(self);

    @dclayMethod(return_='str')
    def __str__(self):
        result = ["", "{ FermataInfo"] 
        result.append("        name : %s " % self.name)
        result.append("        approaching_trams : {")
        for tram_name, tram in self.trams.items():
            result.append("            %s" % (str(tram)))
        result.append("}")
        result.append("       semaforos : {")
        for semaforo_name, semaforo in self.semaforos.items():
            result.append("            %s" % (str(semaforo)))
        result.append("}")
        result.append("")
        return "\n".join(result)

class TramInfo(DataClayObject):
    """
    @ClassField dynamic_info DemoNS.classes.TramDynamicInfo
    @ClassField name str
    """

    @dclayMethod(dynamic_info='DemoNS.classes.TramDynamicInfo', name='str')
    def __init__(self, dynamic_info, name):
        self.dynamic_info = dynamic_info
        self.name = name
        
    @dclayMethod(return_='str')
    def get_name(self):
        return self.name
        
    @dclayMethod(return_='DemoNS.classes.TramDynamicInfo')  
    def get_dynamic_info(self):
        return self.dynamic_info

    @dclayMethod(x='int', y='int')  
    def set_position(self, x, y):
        self.dynamic_info.set_position(x, y)
        
    @dclayMethod()  
    def when_federated(self):
        # This is executed in a fog node. Since they are independent dataClays,
        # the alias can be fixed.
        tram_system = TramSystem.get_by_alias("tram-system");
        tram_system.add_tram_info(self);

    @dclayMethod(return_='str')
    def __str__(self):
        return "{name=%s,dynamic_info=%s}" % (str(self.name), str(self.dynamic_info))

class TramSystem(DataClayObject):
    """
    @ClassField trams list<DemoNS.classes.TramInfo>
    """
    
    @dclayMethod()
    def __init__(self):
        self.trams = list()
    
    @dclayMethod(tram_info='DemoNS.classes.TramInfo')
    def add_tram_info(self, tram_info):
        self.trams.append(tram_info)
        
    @dclayMethod(return_='list<DemoNS.classes.TramInfo>')
    def get_trams(self):
        return self.trams
    
    @dclayMethod(return_='str')
    def __str__(self):
        result = ["", "TramSystem {"]
        for tram in self.trams:
            result.append("    %s" % (str(tram)))
        result.append("}")
        result.append("")
        return "\n".join(result)
    
class CittyInfo(DataClayObject):
    """
    @ClassField fermatas list<DemoNS.classes.FermataInfo>
    """
    
    @dclayMethod()
    def __init__(self):
        self.fermatas = list()
    
    @dclayMethod(fermata_info='DemoNS.classes.FermataInfo')
    def add_fermata_info(self, fermata_info):
        self.fermatas.append(fermata_info)

    @dclayMethod(return_='list<DemoNS.classes.FermataInfo>')
    def get_fermatas(self):
        return self.fermatas
    
    @dclayMethod(return_='str')
    def __str__(self):
        result = ["", "CittyInfo {"]
        for fermata in self.fermatas:
            result.append("    %s" % (str(fermata)))
        result.append("}")
        result.append("")
        return "\n".join(result)
    
