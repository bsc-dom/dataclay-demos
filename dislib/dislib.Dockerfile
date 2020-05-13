FROM bscdataclay/dislib-python-demo
FROM compss/compss:2.6

# Prepare environment
ENV DEMO_HOME=/demo
WORKDIR ${DEMO_HOME} 

# Prepare (again) environment, just as the dataClay image
ENV DATACLAYCLIENTCONFIG=${DEMO_HOME}/cfgfiles/client.properties
ENV DATACLAYGLOBALCONFIG=${DEMO_HOME}/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=${DEMO_HOME}/cfgfiles/session.properties

# Get aspectj
RUN mkdir -p ${DEMO_HOME}/aspectj/
COPY --from=0 /usr/share/java/aspectjrt.jar ${DEMO_HOME}/aspectj/aspectjrt.jar
COPY --from=0 /usr/share/java/aspectjtools.jar ${DEMO_HOME}/aspectj/aspectjtools.jar
COPY --from=0 /usr/share/java/aspectjweaver.jar ${DEMO_HOME}/aspectj/aspectjweaver.jar

# Get dataClay JAR
COPY --from=0 /home/dataclayusr/dataclay/dataclay.jar ${DEMO_HOME}/dataclay.jar

# Reuse all the demo folder
COPY --from=0 ${DEMO_HOME} ${DEMO_HOME}

# Get pyclay 
COPY --from=0 /home/dataclayusr/dataclay/pyclay/ ${DEMO_HOME}/pyclay

# Get pyclay dependencies
RUN python3 --version 
RUN python3 -m pip install -r ${DEMO_HOME}/pyclay/requirements.txt

# Add pyclay source to pythonpath 
ENV PYTHONPATH=${DEMO_HOME}/pyclay/src:${PYTHONPATH}

# Compile Extrae wrapper for current extrae in use 
ENV EXTRAE_HOME=/opt/COMPSs/Dependencies/extrae
COPY --from=0 /home/dataclayusr/dataclay/pyextrae/ ${DEMO_HOME}/pyextrae/
ENV PYCLAY_EXTRAE_WRAPPER_LIB=${DEMO_HOME}/pyextrae/pyclay_extrae_wrapper.so
RUN cd ${DEMO_HOME}/pyextrae && gcc -L${EXTRAE_HOME}/lib -I${EXTRAE_HOME}/include extrae_wrapper.c -lpttrace --shared -fPIC -o ${PYCLAY_EXTRAE_WRAPPER_LIB}

ENV CLASSPATH=${DEMO_HOME}/dataclay.jar:${CLASSPATH}

# Install dislib
RUN python3 -m pip install dislib scipy matplotlib
RUN mkdir -p ${DEMO_HOME}/dislib 
RUN curl -SL https://github.com/bsc-wdc/dislib/archive/v0.5.0.tar.gz | tar -xzC ${DEMO_HOME}/dislib --strip-components=1
