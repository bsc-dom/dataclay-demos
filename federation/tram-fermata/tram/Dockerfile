FROM bscdataclay/client:develop

# Prepare environment
ENV DEMO_HOME=/tram
WORKDIR ${DEMO_HOME} 

## External info
ENV EXTERNAL_NAMESPACE=SharedNS
ENV EXTERNAL_DATACLAY_HOST=logicmodulefermata
ENV EXTERNAL_DATACLAY_PORT=11034

ENV DATACLAYCLIENTCONFIG=${DEMO_HOME}/cfgfiles/client.properties
ENV DATACLAYGLOBALCONFIG=${DEMO_HOME}/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=${DEMO_HOME}/cfgfiles/session.properties
ENV NAMESPACE=${EXTERNAL_NAMESPACE}
ENV USER=TramUser
ENV PASS=TramPass
ENV DATASET=TramDS
ENV STUBSPATH=${DEMO_HOME}/stubs

# Copy files
COPY ./cfgfiles ${DEMO_HOME}/cfgfiles
COPY ./app ${DEMO_HOME}
RUN cp ${DEMO_HOME}/cfgfiles/log4j2.xml ${DATACLAY_LOG_CONFIG}

# Wait for dataclay to be alive (max retries 10 and 5 seconds per retry)
RUN dataclaycmd WaitForDataClayToBeAlive 10 5

# Register account
RUN dataclaycmd NewAccount ${USER} ${PASS}

# Register datacontract
RUN dataclaycmd NewDataContract ${USER} ${PASS} ${DATASET} ${USER}

# Register model
RUN dataclaycmd RegisterDataClay ${EXTERNAL_DATACLAY_HOST} ${EXTERNAL_DATACLAY_PORT}
RUN dataclaycmd ImportModelsFromExternalDataClay ${EXTERNAL_DATACLAY_HOST} ${EXTERNAL_DATACLAY_PORT} ${EXTERNAL_NAMESPACE}
#RUN python -m dataclay.tool register_models_in_namespace_from_external_dataclay ${EXTERNAL_DATACLAY_HOST} ${EXTERNAL_DATACLAY_PORT} ${EXTERNAL_NAMESPACE}

# Get stubs 
RUN mkdir -p ${STUBSPATH}
RUN dataclaycmd GetStubs ${USER} ${PASS} ${NAMESPACE} ${STUBSPATH}

# Run 
ENTRYPOINT ["dataclay-python-entry-point"] 

