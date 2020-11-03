# WordCount demo in Java

This demo attempts to show a WordCount application done in Java that uses dataClay.

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
3. Stop dataClay (check `stop.sh`)

Once the demo docker is build, we have a docker image with proper dataClay stubs.
   
##### 2 - START DATACLAY (`start.sh`)

Start dataClay before running our demo docker application. 

##### 3 - RUN DEMO (`run.sh`)

Execute our application with dataClay using `docker run`. 

##### 4 - STOP DATACLAY (`stop.sh`)

Do a graceful stop of dataClay. 

##### 5 - OPTIONAL: CLEAN UP (`clean.sh`)

Make sure no dataClay docker services are running and clean volumes.

## Model

Registered model has the following representation:

```
+--------------------------+     +-----------------------+
| TextCollection           |     | TextCollectionIndex   |
+--------------------------+     +-----------------------+
| textPrefix: string       |*   *|                       |
| textTitles: list<string> +<----+ nextCollection: int   |
|                          |     |                       |
+--------------------------+     +-----------------------+
| getTextPrefix()          |     |  getTextCollections() |
| getTextTitles()          |     |  getTextTitles()      |
| addTextTitle(textTitle)  |     |  getSize()            |
| getSize()                |     |  getNextCollection()  |
|                          |     |  setNextCollection()  |
|                          |     |                       |
+--------------------------+     +-----------------------+
           |
+--------------------------+     +---------------------------+
| Text                     |     | TextStats                 |
+--------------------------+     +---------------------------+
|                          |     |                           |
| title: string            |     | wordcount: map^str, int^  |
| words: list<string>      |     +---------------------------+
|                          |     | getSize()                 |
+--------------------------+     | getSummary()              |
| addWords(words)          |     | getWordcount()            |
| getTitle()               |     | setWordcount(wordcount)   |
| wordCount()              |     | mergeWordCounts(textStats)|
|                          |     |                           |
+--------------------------+     +---------------------------+
```

## Stubs 

Once the model is registered and we obtain the stubs, we have the following: 

```
+--------------------------+     +-----------------------+
| TextCollection           |     | TextCollectionIndex   |
+--------------------------+     +-----------------------+
| textPrefix: string       |*   *|                       |
| textTitles: list<string> +<----+ nextCollection: int   |
|                          |     |                       |
+--------------------------+     +-----------------------+
| getTextPrefix()          |     |  getTextCollections() |
| getTextTitles()          |     |  getTextTitles()      |
| addTextTitle(textTitle)  |     |  getSize()            |
| getSize()                |     |  getNextCollection()  |
|                          |     |  setNextCollection()  |
+--------------------------+     +-----------------------+
| makePersistent()         |     |  makePersistent()     |
| makePersistent(alias)    |     |  makePersistent(alias)|
| getByAlias(alias)        |     |  getByAlias(alias)    |
+--------------------------+     +-----------------------+
          |
+--------------------------+     +---------------------------+
| Text                     |     | TextStats                 |
+--------------------------+     +---------------------------+
|                          |     |                           |
| title: string            |     | wordcount: map^str, int^  |
| words: list<string>      |     +---------------------------+
|                          |     | getSize()                 |
+--------------------------+     | getSummary()              |
| addWords(words)          |     | getWordcount()            |
| getTitle()               |     | setWordcount(wordcount)   |
| wordCount()              |     | mergeWordCounts(textStats)|
|                          |     |                           |
|                          |     |                           |
| makePersistent()         |     |  makePersistent()         |
| makePersistent(alias)    |     |  makePersistent(alias)    |
| getByAlias(alias)        |     |  getByAlias(alias)        |
+--------------------------+     +---------------------------+

```

## Application

There is two main entrypoints for the application: TextCollectionGen and WordCount. 

### TextCollectionGen 

This application do the following:

1. Creates a set of `TextCollection` one per dataClay java backend available in order to prepare the environment for parallelism. Each `TextCollection` is persisted with alias provided by the user + dataClay backend ID.
2. Creates a `TextCollectionIndex` which is an index for all `TextCollection` objects. The index is persisted with alias provided by the user. 
3. Parses the files in a provided directory path and generate a collection of `Text` objects. A `Text` object contains a list of words in the file. The `Text` is persisted with an specific alias.  
4. Per each `Text`, we add its title to a `TextCollection` , then next `Text` will be added to next `TextCollection` (remember that each one is created in a different backend) 
5. We repeat steps 3 and 4 N times (configuration specified by the user) so a `TextCollection` will have N copies of the same `Text`

For an environment with N backends, X files and Y repeated executions we will have: 

- 1 TextCollectionIndex 
- N TextCollections distributed in different backends with:
   - X files * Y copies

For an environment with 2 backends, 16 files and 3 executions: 

- 1 TextCollectionIndex
- 2 TextCollectons with: 
    - 16 x 3 Text objects 

### Wordcount 

Wordcount application counts all the words in all the files a certain number of executions provided by the user.

## Folder tree 
```
.
├── app: here you will find everything needed in the client application using dataClay. 
│   ├── cfgfiles: configuration files used to connect with dataClay, enable debugging...
│   │   ├── client.properties: File with host and port of dataClay's LogicModule service
│   │   ├── global.properties: Extra configurations for the dataClay client application
│   │   ├── log4j2.xml: dataClay logging configuration for Apache Logger 2. 
│   │   └── session.properties: Sess
│   ├── pom.xml: Application pom.xml
│   └── src: Application source in Maven structure. 
│       └── main
│           └── java
│               └── app
│                   └── Wordcount.java: Application code using dataClay stubs. 
│                   └── TextCollectionGen.java: Generation of text collection
│   
├── docker-compose.yml: docker-compose with all dataClay services
└── prop: Configuration files mounted in docker volumes for dataClay services
│  ├── global.properties: Extra configurations for the dataClay services
│  └── log4j2.xml: dataClay logging configuration for Apache Logger 2. 
├── Dockerfile: Dockerized demo with all steps done by the demo
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
├── README.md
├── build.sh: Script to build demo docker image
├── clean.sh: Script to clean dataClay dockers
├── run.sh: Script to run demo
├── start.sh: Script to start dataClay
├── stop.sh: Script to stop dataClay
├── full_demo.sh: Script to execute the whole demo
└── full_demo_tracing.sh: Script to execute the whole demo with tracing option enabled

```

## Questions? 

If you have any questions, please feel free to ask to support-dataclay@bsc.es

![dataClay logo](https://www.bsc.es/sites/default/files/public/styles/bscw2_-_simple_crop_style/public/bscw2/content/software-app/logo/logo_dataclay_web_bsc.jpg)