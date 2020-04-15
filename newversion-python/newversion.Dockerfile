FROM bscdataclay/client:2.1
LABEL maintainer dataClay team <support-dataclay@bsc.es>

# Prepare environment
ENV DEMO_HOME=/demo
WORKDIR ${DEMO_HOME} 

# Prepare environment
ENV DATACLAYCLIENTCONFIG=${DEMO_HOME}/cfgfiles/client.properties
ENV DATACLAYGLOBALCONFIG=${DEMO_HOME}/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=${DEMO_HOME}/cfgfiles/session.properties
ENV NAMESPACE=DemoNS
ENV USER=DemoUser
ENV PASS=DemoPass
ENV DATASET=DemoDS

# Copy files 
COPY ./storageitf ${DEMO_HOME} 
RUN cp ${DEMO_HOME}/cfgfiles/log4j2.xml ${DATACLAY_LOG_CONFIG}

# Compile storageitf
RUN mvn compile

# Run 
ENTRYPOINT ["dataclay-mvn-entry-point"] 


