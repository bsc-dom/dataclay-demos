# Federation demo

Welcome! This demo attempts to show an example of an architecture for 
data collection and processing based on dataClay (https://www.bsc.es/dataclay) 
to optimize tram traffic. You can use it to familiarize that with
**dataClay's federation** feature, to start developing applications, to explore the different
components, etc.

To read the usage manual, go to https://www.bsc.es/dataclay or https://www.bsc.es/compss. 
To bootstrap your environment and start testing and hacking, keep reading.

## Preflight check

You need:

  - **docker** Get it through https://www.docker.com/ > Get Docker
  - **docker-compose** Quickest way to get the latest release https://github.com/docker/compose/releases
  - **docker-machine** Check https://docs.docker.com/machine/install-machine/#install-machine-directly
  - **virtualbox** Driver to simulate hosts `sudo apt install virtualbox`
  - **java 8+**
  
## Running the whole demo

Execute the following to fully run the demo (it may take a while the first time) 

``` 
$> ./run_demo.sh
```

## Deployment

**NOTE: Deployment is only needed first time and when you modify the model or the applications**

###### Creating machines 

First step is to create a docker machine for each simulated host. We will simulate the following hosts:

 - **dataclay.federation-demo.fermata** This simulates a host located in a tram station 
 - **dataclay.federation-demo.camera** This simulates a camera host located next to a tram station
 - **dataclay.federation-demo.tram** This simulates a tram host 
 - **dataclay.federation-demo.semaforo** This simulates traffic lights next to a tram station
 - **dataclay.federation-demo.citta** This simulates a citty cloud 
	
In order to create them, run `create_machines.sh` 

**NOTE: this script will remove previous machines with same name**

###### Building the data model

In order to use dataClay, we need a user account, a namespace for our data model, a dataset where to store de data and a data contract to allow users to access our data set (more information about dataClay accounts, namespaces... at https://www.bsc.es/dataclay). 

In this section we will see how to extend dataClay docker images to avoid registering accounts and data model everytime and making it more accessible i.e. we will build a set of docker images with already registered accounts, namespaces, datasets and contracts. In this example, this is simplified by having one unique account, namespace and a public dataset.  

Also, in this example we need to use dataClay's `federation` feature which requires to have same model deployed in all nodes. 

The module `data_model/src/classes.py` contains the set of classes to be registered and used in dataClay. 

To build the model we just call `build.sh`. Once build, unless we modify the model we do not need to build it again. 

**NOTE: Remember that if we modify the model, we need to build it and deploy the model again (next section).**

###### Deploying dataClay model 

At this point we have to deploy our dataclay docker images (see section 2). Each docker machine needs to pull the docker image we created. 

One option would be to push each image into DockerHub and pull them for each machine. This is interesting for a production environment. However, since this is an example, we will save a docker image into a tarball and load it into each image.

For that, we call `deploy_model.sh`. 

**NOTE: it may take a while**

###### Building and deploying applications 

Now, for each machine we will create an **application docker image** so we won't need to define any environment variable or any extra configuration to run our application (just docker run will be used)

In `apps`folder we will find the following: 

 - Dockerfile: docker file to create the application in an isolated way. We use one unique docker file with a build argument to change the entrypoint application and keep the configurations. Each application is developed in **python 3.6** 
 - dClayTool.sh: dataClay script to get stubs (explained below)

Per each host, we have a sub-folder with the following structure:
 - cfgfiles: contains dataClay configuration files
 - src: contains code of the application using dataClay model (register the tram, print information...)

At this point we have N machines with dataClay docker images. 

"When we implement a class model we do not take into account 
anything about persistence, but when using it persistent objects
have methods such as makePersistent that have not been defined as part of the class. In order to
be able to use such methods, and thus enable persistence of objects, the application needs to be
linked with an automatically modified version of the classes. This modified version is what we
refer as stub classes or simply stubs. A stub is a class file containing the modified version of the
original class in order to be compatible with dataClay. It is important to understand that, besides
the newly added methods, the rest of the class behaves just like the original one." - dataClay manual section 3.4

To ease this process we will obtain the stubs and copy them into our **application docker image** as defined in the application Dockerfile.

This step is done by calling `deploy_apps.sh`

**NOTE: if you change any application you need to call deploy_apps.sh again.**
**NOTE: It might take a while** 
**NOTE: steps 1 to 5 are only needed first time and when you modify the model or the applications**
 
## The demo 

Finally, run the demo with the script `run_demo.sh` which will do the following: 

* 1. **Citta** creates and stores CittyInfo object named "citta" in its dataClay instance
* 2. **Citta** creates and stores TramSystem object named "tram-system" in its dataClay instance
* 3. **Tram** creates and stores TramInfo object named "florence2025" in its dataClay instance. Note that this object also contains TramDynamicInfo and Position objects. 
* 4. **Tram** federates object named "florence2025" to **Citta** using Citta's IP and dataClay port
* 5. **Citta** receives TramInfo object and adds it to the list of trams in TramSystem using the `when_federated` method defined in TramInfo class (see data model) 
* 6. **Fermata** creates and stores FermataInfo object named "pontevecchio" in its dataClay instance
* 7. **Fermata** federates object named "pontevecchio" to **Citta** using Citta's IP and dataClay port
* 8. **Citta** receives FermataInfo object and adds it to the list of fermatas in Citta using the `when_federated` method defined in FermataInfo class (see data model) 
* 9. **Citta** prints all fermatas and trams available
* 10. **Camera** creates and stores CameraInfo object named "pontevecchio-camera-left" in its dataClay instance
* 11. **Camera** federates CameraInfo object named "pontevecchio-camera-left" to **Fermata** using Fermata's IP and dataClay port
* 12. **Fermata** receives CameraInfo object and adds it to the list of cameras in Fermata using the `when_federated` method defined in CameraInfo class (see data model) 
* 13. **Semaforo** creates and stores SemaforoInfo object named "pontevecchio-semaforo-left" in its dataClay instance
* 14. **Semaforo** federates SemaforoInfo object named "pontevecchio-semaforo-left" to **Fermata** using Fermata's IP and dataClay port
* 15. **Fermata** receives SemaforoInfo object and adds it to the list of semaforos in Fermata using the `when_federated` method defined in SemaforoInfo class (see data model) 
* 16. **Tram** is approaching to "pontevecchio" Fermata and federates its TramDynamicInfo (only the dynamic information) to **Fermata** using Fermata's IP and dataClay port
* 17. **Fermata** receives TramDynamicInfo object and adds it to the list of trams in Fermata using the `when_federated` method defined in TramDynamicInfo class (see data model) 
* 18. An ambulance is arriving from the left side of the fermata and the **Camera** detects it.
* 19. **Camera** updates the information in CameraInfo. This information is **automatically synchronized** with the **Fermata**  
* 20. **Fermata** checks if tram must stop due to the presence of an ambulance
* 21. **Fermata** updates SemaforoInfo object to color RED. This information is **automatically synchronized** with the **Semaforo** 
* 22. **Semaforo** checks the color of the light and set it to red. 
* 23. The ambulance is not visible anymore from the camera
* 24. **Camera** updates the information in CameraInfo. This information is **automatically synchronized** with the **Fermata** 
* 25. **Fermata** checks if tram must stop due to the presence of an ambulance
* 26. **Fermata** updates SemaforoInfo object to color GREEN. This information is **automatically synchronized** with the **Semaforo** 
* 27. **Semaforo** checks the color of the light and set it to red. 
* 28. **Tram** leaves "pontevecchio" and unfederates the TramDynamicInfo with the **Fermata**.
* 29. **Fermata** removes the tram in Fermata using the `when_unfederated` method defined in TramDynamicInfo class (see data model) 

With this demo we can see how `federation`,`unfederation` and `synchronization` works in dataClay.

**NOTE: after rebooting, make sure docker-machines are running before running the demo**

## Structure

- apps: contains all the applications per simulated host
    - Dockerfile: docker file to build application docker images 
    - dClayTool.sh: dataclay script to get stubs for application docker images 
- data_model: contains the data model and docker files to extend dataclay docker images 
    - tools: set of tools to register accounts, namespaces, model ... 
    - src: the data model itself
    - dockers: docker-compose and properties to be used during the extension of dataclay images (section 2)
- dockers: contains dataclay docker-compose to start in each simulated host 
- build.sh: script to build the data model as dataclay docker images
- check_requirements.sh: script to check if the host accomplishes the requirements to use dataclay
- create_machines.sh: script to create simulated hosts using docker-machine
- deploy_model.sh: script to deploy dataclay docker images with data model in each simulated host (docker-machine)
- deploy_apps.sh: script to build application docker images in each docker-machine
- run_demo.sh: script to run the demo 
