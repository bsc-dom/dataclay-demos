# WordCount demo in Java with COMPSs

This demo attempts to show a WordCount application done in Java that uses both dataClay
and COMPSs framework. Note that this demo is very similar to the `wordcount-java` counterpart,
but with the addition of the COMPSs framework for distributed computing.

Remember that demos are intended to give a demonstration of typical dataClay applications and architectures: to show how dataClay works, is prepared, or is done while examples are used to learn how to use dataClay, to make something similar to the demos and match your requirements. You can find dataClay examples at https://github.com/bsc-dom/dataclay-examples

## Preflight check

You need:

  - **docker** Get it through https://www.docker.com/ > Get Docker
  - **docker-compose** Quickest way to get the latest release https://github.com/docker/compose/releases
  
## Running the whole demo

Execute the following to fully run the demo (it may take a while the first time) 

``` 
$> ./full_demo.sh
```


## Demo workflow

Each step of the demo has been defined in a script for better understanding and usage.

##### 1 - BUILD DEMO (`build.sh`)

First step is to build our containerized demo:

0. Clean previous dataClay services (sanity check) (check `clean.sh`)
1. Start dataClay using docker-compose (check `start.sh`)
2. Build the dataClay demo image using docker build. Dockerfile extends dataClay client tool which contains all necessary dependencies to use dataClay (alternatively you can check dataclay examples repository to see how to do it without extending the docker). Notice that the docker is build in the same docker network than the one used to bootstrap dataClay. Build steps are the following (check `Dockerfile` for more detailed calls):
   1. Define necessary environment variables 
   2. Wait for dataClay to be alive using dataClay command `WaitForDataClayToBeAlive`
   3. Create a new account using dataClay command `NewAccount`
   4. Create a data contract using dataClay command `NewDataContract`
   5. Register model using dataClay command `NewModel`
   6. Get stubs generated using dataClay command `GetStubs`
   7. Package them and install in local maven repository 
   8. Compile client application 
3. Build the COMPSs ready container --which is used in the consumer stage of the application. This container is a multi-stage Dockerfile (see `compss.Dockerfile`) which copies certain structures from the previous built docker image and adds the additional COMPSs files: `pom.xml` (added COMPSs dependency) and `WordcountItf.java` (COMPSs annotations).
4. Stop dataClay (check `stop.sh`)

Once the demo docker is build, we have a docker image with proper dataClay stubs.
   
##### 2 - START DATACLAY (`start.sh`)

Start dataClay before running our demo docker application. 

##### 3 - RUN DEMO (`run.sh`)

Run demo steps:
1. Run the producer stage of the Wordcount through the `bscdataclay/wordcount-java-demo` image.
2. Prepare the COMPSs framework through the `bscdataclay/wordcount-java-compss-demo` image.
3. Execute the `runcompss` into the COMPSs container. This runs the consumer stage of the Wordcount application.

##### 4 - STOP DATACLAY (`stop.sh`)

Do a graceful stop of dataClay. 

##### 5 - OPTIONAL: CLEAN UP (`clean.sh`)

Make sure no dataClay docker services are running and clean volumes.


## Model and Application

The whole Model (also the corresponding stubs) and the main application are the same
than the `wordcount-java` demo counterpart. Check that folder in order to understand
the model and application flow.

## Folder tree 
```
.
├── app: here you will find everything needed in the client application using dataClay. 
│   ├── cfgfiles: configuration files used to connect with dataClay, enable debugging...
│   │   ├── client.properties: File with host and port of dataClay's LogicModule service
│   │   ├── global.properties: Extra configurations for the dataClay client application
│   │   ├── log4j2.xml: dataClay logging configuration for Apache Logger 2.
│   │   └── session.properties: Session properties for the user.
│   ├── pom.xml: Application pom.xml including COMPSs engine JAR reference
│   └── src: Application source in Maven structure. 
│       └── main
│           └── java
│               └── app
│                   ├── TextCollectionGen.java: Generation of text collection.
│                   └── Wordcount.java: Application code using dataClay stubs. 
│   
├── dataclay: here you will find everything needed to bootstrap and configure dataClay 
│   ├── docker-compose.yml: docker-compose with all dataClay services
│   └── prop: Configuration files mounted in docker volumes for dataClay services
│       ├── global.properties: Extra configurations for the dataClay services
│       └── log4j2.xml: dataClay logging configuration for Apache Logger 2. 
├── Dockerfile: Dockerized demo with all the main steps.
├── compss.Dockerfile: Dockerized demo for the consumer stage.
├── paraver: Configuration files for paraver visualization of traces
├── model: Model to be registered in dataClay
│   ├── pom.xml: Model pom.xml
│   └── src: Model source in Maven structure. 
│       └── main
│           └── java
│               └── model
│                   ├── Text.java
│                   ├── TextCollection.java
│                   ├── TextCollectionIndex.java
│                   └── TextStats.java
├── pom-compss.xml: Application pom.xml with additional COMPSs dependency.
├── README.md
├── build.sh: Script to build demo docker image
├── clean.sh: Script to clean dataClay dockers
├── run.sh: Script to run demo
├── start.sh: Script to start dataClay
├── stop.sh: Script to stop dataClay
├── full_demo.sh: Script to execute the whole demo
└── WordcountItf.java: Interface with COMPSs annotations for the consumer stage
```

## Questions? 

If you have any questions, please feel free to ask to support-dataclay@bsc.es
