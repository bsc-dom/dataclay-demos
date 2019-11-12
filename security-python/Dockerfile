FROM bscdataclay/client:2.0
LABEL maintainer dataClay team <support-dataclay@bsc.es>

# Prepare environment
ENV DATACLAYCLIENTCONFIG=/usr/src/demo/app/cfgfiles/client.properties
ENV DATACLAYGLOBALCONFIG=/usr/src/demo/app/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=/usr/src/demo/app/cfgfiles/session.properties
ENV NAMESPACE=DemoNS
ENV USER=DemoUser
ENV PASS=DemoPass
ENV DATASET=DemoDS
ENV MODELBINPATH=/usr/src/demo/model/src

# If we want to run demo again, argument must be modified 
ARG CACHEBUST=1 

# Copy files 
COPY ./model /usr/src/demo/model
RUN mkdir -p /usr/src/demo/app/
COPY ./app/cfgfiles /usr/src/demo/app/cfgfiles
RUN cp /usr/src/demo/app/cfgfiles/log4j2.xml ${LOG4J_CLASSPATH}

# Wait for dataclay to be alive (max retries 10 and 5 seconds per retry)
RUN ${DATACLAYCMD} WaitForDataClayToBeAlive 10 5

# Register account
RUN ${DATACLAYCMD} NewAccount ${USER} ${PASS}

# Register datacontract
RUN ${DATACLAYCMD} NewDataContract ${USER} ${PASS} ${DATASET} ${USER}

# Register model
RUN ${DATACLAYCMD} NewModel ${USER} ${PASS} ${NAMESPACE} ${MODELBINPATH} python

# Working dir
WORKDIR /usr/src/demo/app

# Run 
ENTRYPOINT ["/usr/src/dataclay/pyclay/python-entry-point.sh"] 

