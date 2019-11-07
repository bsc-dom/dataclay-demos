# WordCount application in Java using COMPSs

This folder contains a full example of how to run a WordCount application,
and executing it distributed through the use of COMPSs framework.

# Getting started

First of all, you will need to have a recent version of Docker and docker-compose
installed in your machine. Most dependencies are included in the containers.

You will need to clone or fork this repository. All commands are relative to the 
root folder of this example and it is intended to be a self-contained example.

## Preparing the docker network

Given that both COMPSs and dataClay should be able to interconnect, the most straightforward
way to achieve this is to make them share a docker network. We will pre-create them with:

```bash
$ docker network create dcwordcount
```

The previous command will create a _bridge_ network. The `docker-compose.yml` file assumes
that this network will be available.

**Remember:** You will need to clean up this network manually once you finish. This can be done
with the command `docker network rm`.

## Starting the dataClay services

The basic orchestration is done through docker-compose. You can simply start it by issuing:

```bash
$ docker-compose up -d
```

The services will begin in the background. To check the lifecycle of the applications just use
the usual docker-compose commands --i.e. `ps`, `logs`, etc.

## Compiling your model

We need to compile the model, and to do so we will use `javac`:

```bash
$ mkdir model-bin
$ javac src/model/*.java -d ./model-bin
```

## Registering the model

Now that dataClay has been initialized and we have compiled the model, we can use the
`dataclaycmd` to prepare all the dataClay environment and register the classes.

We will be using a container which contains the `dataclaycmd` and all its dependencies.

```bash
$ # Brevity mandates us to to this "dataClay Cmd Run" alias:
$ alias dccrun="docker run --network=dcwordcount --volume cfgfiles/client.properties:cfgfiles/client.properties --volume stubs:stubs --volume model-bin:model-bin bscdataclay/dataclaycmd"
$ dccrun NewAccount wcuser wcpass
$ dccrun NewDataContract wcuser wcpass wcdataset wcuser
$ # The following will work because
$ dccrun NewModel wcuser wcpass wcnamespace ./model-bin java
$ dccrun GetStubs wcuser wcpass wcnamespace ./stubs
```

## Loading the dataset

**ToDo:** Explain how to build the producer. Needs dataClay in CLASSPATH and some extra stuff, maybe a pom?

Then you can run the producer with the following command:

```bash
$ java ... TextCollectionGen mydatasetalias /text
```

Note that the folder **`text`** has been mounted in the **`/text`** path inside the 
Execution Environment container --you can see it by looking into the `docker-compose.yml` file.
This illustrates a "remote load", which is a typical scenario for environments in which the
Execution Environment has a parallel filesystem or access to some datasets.

## Building the Word Count application

**ToDo:** Explain how to build the consumer. Needs dataClay in CLASSPATH and some extra stuff, maybe a pom?

## Building the COMPSs-ready application container

Now we are able to build a new container, based in the COMPSs base container, which will contain the
Wordcount application and all the COMPSs framework.

You can check the contents of the `Dockerfile` file, and build it by doing:

```bash
$ docker build . -t wccompss
```

## Run the Wordcount

The Wordcount application can now be run, we only have to specify the alias of the collection:

```bash
$ docker run wccompss mydatasetalias
```

Note that this `mydatasetalias` is the alias of the persistent collection, as set in previous steps.
The alias is the mandatory parameter that the `Wordcount` application expects, but there are more parameters
available; just omit it and the application will give the usage instructions.