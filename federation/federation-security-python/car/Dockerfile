FROM alpine:3 as certificator
RUN apk --no-cache --update add openssl jq curl
## External info
ARG CERTIFICATE_AUTHORITY_HOST=127.0.0.1
ARG CERTIFICATES_DIR=/ssl
ENV CERTIFICATES_DIR=$CERTIFICATES_DIR \
    CERTIFICATE_AUTHORITY_HOST=$CERTIFICATE_AUTHORITY_HOST
# Get certificates from certificate authority
COPY ./dataclay/get_certificates.sh .
RUN ./get_certificates.sh

FROM bscdataclay/client:develop-alpine

## NOTE: GRPC security requires jdk 11 in alpine
RUN apk --no-cache --update add openjdk11

# Prepare environment
ENV DEMO_HOME=/car
WORKDIR ${DEMO_HOME} 

## External info
ARG EXTERNAL_DATACLAY_HOST=logicmodulecity
ARG EXTERNAL_DATACLAY_PORT=11034
ENV EXTERNAL_NAMESPACE=SharedNS

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
COPY --from=certificator /ssl /ssl

# Wait for dataclay to be alive (max retries 10 and 5 seconds per retry)
RUN dataclaycmd WaitForDataClayToBeAlive 10 5

# Register account
RUN dataclaycmd NewAccount ${USER} ${PASS}

# Register datacontract
RUN dataclaycmd NewDataContract ${USER} ${PASS} ${DATASET} ${USER}

# Register model
ENV DATACLAY_LOG_CONFIG=${DEMO_HOME}/cfgfiles/log4j2.xml
RUN dataclaycmd RegisterDataClay ${EXTERNAL_DATACLAY_HOST} ${EXTERNAL_DATACLAY_PORT}
RUN dataclaycmd ImportModelsFromExternalDataClay ${EXTERNAL_DATACLAY_HOST} ${EXTERNAL_DATACLAY_PORT} ${EXTERNAL_NAMESPACE}

# Get stubs 
RUN mkdir -p ${STUBSPATH}
RUN dataclaycmd GetStubs ${USER} ${PASS} ${NAMESPACE} ${STUBSPATH}

# Run 
ENTRYPOINT ["dataclay-python-entry-point"] 

