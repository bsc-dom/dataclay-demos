FROM bscdataclay/client:develop-slim:develop-alpine:develop

# Prepare environment
ENV DEMO_HOME=/demo
WORKDIR ${DEMO_HOME} 

# Since client app is maven we install the dependencies
# Install dataclay jar in local repository	
RUN mvn install:install-file -Dfile=${DATACLAY_JAR} -DgroupId=es.bsc.dataclay \
	-DartifactId=dataclay -Dversion=latest -Dpackaging=jar -DcreateChecksum=true

ENV DATACLAYCLIENTCONFIG=${DEMO_HOME}/cfgfiles/client.properties
ENV DATACLAYGLOBALCONFIG=${DEMO_HOME}/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=${DEMO_HOME}/cfgfiles/session.properties
ENV NAMESPACE=DemoNS
ENV USER=DemoUser
ENV PASS=DemoPass
ENV DATASET=DemoDS
ENV STUBSPATH=${DEMO_HOME}/stubs
ENV STUBS_JAR=${DEMO_HOME}/stubs.jar
ENV MODELBINPATH=${DEMO_HOME}/model/target/classes

# If we want to run demo again, argument must be modified 
ARG CACHEBUST=1 

# Copy files 
COPY ./model ${DEMO_HOME}/model
COPY ./app ${DEMO_HOME}
RUN cp ${DEMO_HOME}/cfgfiles/log4j2.xml ${DATACLAY_LOG_CONFIG}

# Wait for dataclay to be alive (max retries 10 and 5 seconds per retry)
RUN dataclaycmd WaitForDataClayToBeAlive 10 5

# Register account
RUN dataclaycmd NewAccount ${USER} ${PASS}

# Register datacontract
RUN dataclaycmd NewDataContract ${USER} ${PASS} ${DATASET} ${USER}

# Register model
RUN cd ${DEMO_HOME}/model && mvn package
RUN dataclaycmd NewModel ${USER} ${PASS} ${NAMESPACE} ${MODELBINPATH} java

# Get stubs 
RUN mkdir -p ${STUBSPATH}
RUN dataclaycmd GetStubs ${USER} ${PASS} ${NAMESPACE} ${STUBSPATH}

# Package stubs 
RUN jar cvf ${STUBS_JAR} -C ${STUBSPATH} .

# Install stubs in local repository to use it as a pom dependency
RUN mvn install:install-file -Dfile=${STUBS_JAR} -DgroupId=es.bsc.dataclay \
	-DartifactId=hellopeople-demo-stubs -Dversion=latest -Dpackaging=jar -DcreateChecksum=true
	
# Compile app
RUN mvn compile

# Run 
ENTRYPOINT ["dataclay-mvn-entry-point"] 


