FROM bscdataclay/wordcount-java-demo

FROM compss/compss:2.6
# Prepare environment
ENV DEMO_HOME=/demo
WORKDIR ${DEMO_HOME} 

# Prepare (again) environment, just as the dataClay image
ENV DATACLAYCLIENTCONFIG=${DEMO_HOME}/cfgfiles/client.properties
ENV DATACLAYGLOBALCONFIG=${DEMO_HOME}/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=${DEMO_HOME}/cfgfiles/session.properties
ENV NAMESPACE=DemoNS
ENV USER=DemoUser
ENV PASS=DemoPass
ENV DATASET=DemoDS

# Reuse all the Maven stuff
COPY --from=0 /home/dataclayusr/dataclay/dataclay.jar ${DEMO_HOME}/dataclay.jar
COPY --from=0 /root/.m2 /root/.m2
# Reuse all the demo folder
COPY --from=0 ${DEMO_HOME} ${DEMO_HOME}

# Fix the pom.xml in order to include COMPSs
COPY pom-compss.xml ${DEMO_HOME}/pom.xml
# Put the interface file in its place
COPY WordcountItf.java ${DEMO_HOME}/src/main/java/

# Compile app
RUN cd ${DEMO_HOME} && mvn install dependency:copy-dependencies 
