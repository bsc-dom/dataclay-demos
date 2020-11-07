FROM bscdataclay/client:develop-alpine

# Prepare environment
ENV DEMO_HOME=/car
WORKDIR ${DEMO_HOME} 

## External info
ARG EXTERNAL_DATACLAY_HOST=logicmodulecity
ENV EXTERNAL_NAMESPACE=SharedNS
ENV EXTERNAL_DATACLAY_PORT=11034

ENV DATACLAYCLIENTCONFIG=${DEMO_HOME}/cfgfiles/client.properties
ENV DATACLAYGLOBALCONFIG=${DEMO_HOME}/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=${DEMO_HOME}/cfgfiles/session.properties
ENV NAMESPACE=${EXTERNAL_NAMESPACE}
ENV USER=CarUser
ENV PASS=CarPass
ENV DATASET=CarDS
ENV STUBSPATH=${DEMO_HOME}/stubs

# Copy files
COPY ./cfgfiles ${DEMO_HOME}/cfgfiles
COPY ./app ${DEMO_HOME}

# Wait for dataclay to be alive (max retries 10 and 5 seconds per retry)
RUN dataclaycmd WaitForDataClayToBeAlive 10 5

# Register account
RUN dataclaycmd NewAccount ${USER} ${PASS}

# Register datacontract
RUN dataclaycmd NewDataContract ${USER} ${PASS} ${DATASET} ${USER}

# Register model
RUN dataclaycmd RegisterDataClay ${EXTERNAL_DATACLAY_HOST} ${EXTERNAL_DATACLAY_PORT}
RUN dataclaycmd ImportModelsFromExternalDataClay ${EXTERNAL_DATACLAY_HOST} ${EXTERNAL_DATACLAY_PORT} ${EXTERNAL_NAMESPACE}

# Get stubs 
RUN mkdir -p ${STUBSPATH}
RUN dataclaycmd GetStubs ${USER} ${PASS} ${NAMESPACE} ${STUBSPATH}

# Run 
ENTRYPOINT ["dataclay-python-entry-point"] 

