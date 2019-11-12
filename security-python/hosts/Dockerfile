FROM bscdataclay/client:2.0
LABEL maintainer dataClay team <support-dataclay@bsc.es>

# Same dockerfile for all apps
ARG APP_NAME
ENV APP_NAME=${APP_NAME}

# Prepare environment
ENV DATACLAYCLIENTCONFIG=/usr/src/demo/app/cfgfiles/client.properties
ENV DATACLAYGLOBALCONFIG=/usr/src/demo/app/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=/usr/src/demo/app/cfgfiles/session.properties
ENV NAMESPACE=DemoNS
ENV USER=DemoUser
ENV PASS=DemoPass
ENV DATASET=DemoDS
ENV STUBSPATH=/usr/src/demo/app/stubs

# If we want to run demo again, argument must be modified 
ARG CACHEBUST=1 

# Copy app
COPY ./${APP_NAME}/src /usr/src/demo/app/src
COPY ./common/cfgfiles /usr/src/demo/app/cfgfiles
COPY ./${APP_NAME}/certs /usr/src/demo/app/certs

# Wait for dataclay to be alive (max retries 10 and 5 seconds per retry)
RUN ${DATACLAYCMD} WaitForDataClayToBeAlive 10 5 --debug

# Get stubs 
RUN mkdir -p ${STUBSPATH}
RUN ${DATACLAYCMD} GetStubs ${USER} ${PASS} ${NAMESPACE} ${STUBSPATH}

# Working dir
WORKDIR /usr/src/demo/app

# Run 
ENTRYPOINT ["/usr/src/dataclay/pyclay/python-entry-point.sh"] 

