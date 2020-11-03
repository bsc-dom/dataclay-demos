FROM dataclaydemos/hello-people-java
FROM compss/compss:2.7
# Prepare environment
ENV DEMO_HOME=/demo
WORKDIR ${DEMO_HOME} 

# Prepare (again) environment, just as the dataClay image
ENV DATACLAYCLIENTCONFIG=${DEMO_HOME}/cfgfiles/client.properties
ENV DATACLAYGLOBALCONFIG=${DEMO_HOME}/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=${DEMO_HOME}/cfgfiles/session.properties

# Install compss jar in maven local repository 
RUN mvn install:install-file -Dfile=/opt/COMPSs/Runtime/compss-engine.jar -DgroupId=es.bsc \
	-DartifactId=compss -Dversion=latest -Dpackaging=jar -DcreateChecksum=true

# Get aspectj
RUN mkdir -p ${DEMO_HOME}/aspectj/
COPY --from=0 /usr/share/java/aspectjrt.jar ${DEMO_HOME}/aspectj/aspectjrt.jar
COPY --from=0 /usr/share/java/aspectjtools.jar ${DEMO_HOME}/aspectj/aspectjtools.jar
COPY --from=0 /usr/share/java/aspectjweaver.jar ${DEMO_HOME}/aspectj/aspectjweaver.jar

# Reuse all the Maven stuff
COPY --from=0 /home/dataclayusr/dataclay/dataclay.jar ${DEMO_HOME}/dataclay.jar
COPY --from=0 /root/.m2 /root/.m2

# Get entrypoints 
COPY --from=0 /home/dataclayusr/dataclay/entrypoints ${DEMO_HOME}/entrypoints

# Reuse all the demo folder
COPY --from=0 ${DEMO_HOME} ${DEMO_HOME}
RUN mvn compile

# Get dependencies
RUN cd ${DEMO_HOME} && mvn install dependency:copy-dependencies 
