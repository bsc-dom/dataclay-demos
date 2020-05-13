FROM dataclaydemo/client
LABEL maintainer dataClay team <support-dataclay@bsc.es>

ARG DATACLAY_HOSTNAME=fermata

# Prepare environment
ENV DEMO_HOME=/demo
WORKDIR ${DEMO_HOME} 

ENV DATACLAYCLIENTCONFIG=${DEMO_HOME}/cfgfiles/client.properties
ENV DATACLAYGLOBALCONFIG=${DEMO_HOME}/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=${DEMO_HOME}/cfgfiles/session.properties
ENV NAMESPACE=DemoNS
ENV USER=DemoUser
ENV PASS=DemoPass
ENV DATASET=DemoDS
ENV STUBSPATH=${DEMO_HOME}/stubs

# Copy files 
COPY ./${DATACLAY_HOSTNAME} ${DEMO_HOME} 
RUN cp ${DEMO_HOME}/cfgfiles/log4j2.xml ${DATACLAY_LOG_CONFIG}

# Run 
ENTRYPOINT ["dataclay-python-entry-point"] 

