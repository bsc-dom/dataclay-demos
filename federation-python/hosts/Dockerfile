FROM bscdataclay/client:2.0
LABEL maintainer dataClay team <support-dataclay@bsc.es>

# Same dockerfile for all apps
ARG APP_NAME
ENV APP_NAME=${APP_NAME}
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
ENV STUBSPATH=${DEMO_HOME}/stubs

# If we want to run demo again, argument must be modified 
ARG CACHEBUST=1 

# Copy app
COPY ./${APP_NAME}/src ${DEMO_HOME}/src
COPY ./common/cfgfiles ${DEMO_HOME}/cfgfiles
RUN cp ${DEMO_HOME}/cfgfiles/log4j2.xml ${DATACLAY_LOG_CONFIG}

# Wait for dataclay to be alive (max retries 10 and 5 seconds per retry)
RUN dataclaycmd WaitForDataClayToBeAlive 10 5

# Get stubs 
RUN mkdir -p ${STUBSPATH}
RUN dataclaycmd GetStubs ${USER} ${PASS} ${NAMESPACE} ${STUBSPATH}

# Run 
ENTRYPOINT ["dataclay-python-entry-point"] 

