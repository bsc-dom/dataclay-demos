FROM bscdataclay/client:2.0
LABEL maintainer dataClay team <support-dataclay@bsc.es>

# Prepare environment
ENV DATACLAYCLIENTCONFIG=/usr/src/demo/app/cfgfiles/client.properties
ENV DATACLAYGLOBALCONFIG=/usr/src/demo/app/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=/usr/src/demo/app/cfgfiles/session.properties
ENV NAMESPACE=DemoNS
ENV USER=DemoUser
ENV PASS=DemoPass
ENV DATASET=DemoDS
ENV STUBSPATH=/usr/src/demo/app/stubs
ENV STUBS_JAR=/usr/src/demo/app/stubs.jar
ENV MODELBINPATH=/usr/src/demo/model/target/classes

# If we want to run demo again, argument must be modified 
ARG CACHEBUST=1

# Copy files 
COPY ./model /usr/src/demo/model
COPY ./app /usr/src/demo/app 
RUN cp /usr/src/demo/app/cfgfiles/log4j2.xml ${LOG4J_CLASSPATH}

# Wait for dataclay to be alive (max retries 10 and 5 seconds per retry)
RUN ${DATACLAYCMD} WaitForDataClayToBeAlive 10 5

# Register account
RUN ${DATACLAYCMD} NewAccount ${USER} ${PASS}

# Register datacontract
RUN ${DATACLAYCMD} NewDataContract ${USER} ${PASS} ${DATASET} ${USER}

# Register model
RUN cd /usr/src/demo/model && mvn package
RUN ${DATACLAYCMD} NewModel ${USER} ${PASS} ${NAMESPACE} ${MODELBINPATH} java

# Get stubs 
RUN mkdir -p ${STUBSPATH}
RUN ${DATACLAYCMD} GetStubs ${USER} ${PASS} ${NAMESPACE} ${STUBSPATH}

# Package stubs 
RUN jar cvf ${STUBS_JAR} -C ${STUBSPATH} .


# Install stubs in local repository to use it as a pom dependency
RUN mvn install:install-file -Dfile=${STUBS_JAR} -DgroupId=es.bsc.dataclay \
	-DartifactId=wordcount-demo-stubs -Dversion=2.0 -Dpackaging=jar -DcreateChecksum=true

# pom.xml is located here
WORKDIR /usr/src/demo/app

# Compile app
RUN mvn compile

# Run 
ENTRYPOINT ["/usr/src/dataclay/javaclay/mvn-entry-point.sh"] 


