ARG DATACLAY_DOCKER_TAG
FROM bscdataclay/client:${DATACLAY_DOCKER_TAG}
LABEL maintainer dataClay team <support-dataclay@bsc.es>

# Prepare environment
ENV DATACLAYCLIENTCONFIG=/usr/src/hellopeople/cfgfiles/client.properties
#ENV DATACLAYGLOBALCONFIG=/usr/src/hellopeople/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=/usr/src/hellopeople/cfgfiles/session.properties

ENV NAMESPACE=HelloPeopleNS
ENV USER=HelloPeopleUser
ENV PASS=HelloPeoplePass
ENV DATASET=HelloPeopleDS
ENV STUBSPATH=/usr/src/hellopeople/app/stubs
ENV STUBS_JAR=/usr/src/hellopeople/app/stubs.jar
ENV BINPATH=/usr/src/hellopeople/bin
ENV MODELBINPATH=/usr/src/hellopeople/model/target/classes

RUN mkdir -p ${STUBSPATH}
RUN mkdir -p ${BINPATH}

# Copy files 
COPY ./model /usr/src/hellopeople/model
COPY ./app /usr/src/hellopeople/app 
COPY ./cfgfiles /usr/src/hellopeople/cfgfiles

# If we want to run demo again, argument must be modified 
ARG CACHEBUST=1 

# Wait for dataclay to be alive (max retries 10 and 5 seconds per retry)
RUN ${DATACLAYCMD} WaitForDataClayToBeAlive 10 5

# Register account
RUN ${DATACLAYCMD} NewAccount ${USER} ${PASS}

# Register datacontract
RUN ${DATACLAYCMD} NewDataContract ${USER} ${PASS} ${DATASET} ${USER}

# Register model
RUN cd /usr/src/hellopeople/model && mvn package
RUN ${DATACLAYCMD} NewModel ${USER} ${PASS} ${NAMESPACE} ${MODELBINPATH} java

# Get stubs 
RUN ${DATACLAYCMD} GetStubs ${USER} ${PASS} ${NAMESPACE} ${STUBSPATH}

# Package stubs 
RUN jar cvf ${STUBS_JAR} -C ${STUBSPATH} .

# pom.xml is located here
WORKDIR /usr/src/hellopeople/app

# Install stubs in local repository to use it as a pom dependency
RUN mvn install:install-file -Dfile=${STUBS_JAR} -DgroupId=es.bsc.dataclay \
	-DartifactId=hellopeople-demo-stubs -Dversion=2.0 -Dpackaging=jar -DcreateChecksum=true

# Compile app
RUN mvn compile

# Run 
ENTRYPOINT ["mvn", "exec:java", "-q", "-Dlog4j.configurationFile=/usr/src/hellopeople/app/log4j2.xml"] 



