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

FROM bscdataclay/client:develop-slim:develop-alpine:develop-alpine

## NOTE: GRPC security requires jdk 11 in alpine
RUN apk --no-cache --update add openjdk11

# Prepare environment
ENV DEMO_HOME=/city
WORKDIR ${DEMO_HOME}

ENV DATACLAYCLIENTCONFIG=${DEMO_HOME}/cfgfiles/client.properties
ENV DATACLAYGLOBALCONFIG=${DEMO_HOME}/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=${DEMO_HOME}/cfgfiles/session.properties
ENV NAMESPACE=SharedNS
ENV USER=CityUser
ENV PASS=CityPass
ENV DATASET=CityDS
ENV STUBSPATH=${DEMO_HOME}/stubs
ENV MODELBINPATH=${DEMO_HOME}/model/src

# Copy files
COPY ./model ${DEMO_HOME}/model
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
RUN dataclaycmd NewModel ${USER} ${PASS} ${NAMESPACE} ${MODELBINPATH} python

# Get stubs 
RUN mkdir -p ${STUBSPATH}
RUN dataclaycmd GetStubs ${USER} ${PASS} ${NAMESPACE} ${STUBSPATH}

# Run 
ENTRYPOINT ["dataclay-python-entry-point"] 

