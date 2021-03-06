FROM bscdataclay/client

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
ENV MODELBINPATH=${DEMO_HOME}/model/src

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
RUN dataclaycmd NewModel ${USER} ${PASS} ${NAMESPACE} ${MODELBINPATH} python

# Get stubs 
RUN mkdir -p ${STUBSPATH}
RUN dataclaycmd GetStubs ${USER} ${PASS} ${NAMESPACE} ${STUBSPATH}

# Generate text
RUN python src/textcollectiongen.py Words 10

# Run 
ENTRYPOINT ["dataclay-python-entry-point"] 


