FROM bscdataclay/wordcount-java-demo

FROM compss/compss:2.5

# Prepare (again) environment, just as the dataClay image
ENV DATACLAYCLIENTCONFIG=/usr/src/demo/app/cfgfiles/client.properties
ENV DATACLAYGLOBALCONFIG=/usr/src/demo/app/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=/usr/src/demo/app/cfgfiles/session.properties
ENV NAMESPACE=DemoNS
ENV USER=DemoUser
ENV PASS=DemoPass
ENV DATASET=DemoDS

# Reuse all the Maven stuff
COPY --from=0 /root/.m2 /root/.m2
# Reuse all the demo folder
COPY --from=0 /usr/src/demo /usr/src/demo

# Fix the pom.xml in order to include COMPSs
COPY pom-compss.xml /usr/src/demo/app/pom.xml
# Put the interface file in its place
COPY WordcountItf.java /usr/src/demo/app/src/main/java/

# Compile app
RUN cd /usr/src/demo/app && mvn install dependency:copy-dependencies 
