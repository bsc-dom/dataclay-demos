FROM bscdataclay/dislib-python-demo
FROM compss/compss:2.7

# Prepare environment
ENV DEMO_HOME=/demo
WORKDIR ${DEMO_HOME} 

# Prepare (again) environment, just as the dataClay image
ENV DATACLAYCLIENTCONFIG=${DEMO_HOME}/cfgfiles/client.properties
ENV DATACLAYGLOBALCONFIG=${DEMO_HOME}/cfgfiles/global.properties
ENV DATACLAYSESSIONCONFIG=${DEMO_HOME}/cfgfiles/session.properties

# Reuse all the demo folder
COPY --from=0 ${DEMO_HOME} ${DEMO_HOME}

# Get dataClay JAR
COPY --from=0 /home/dataclayusr/dataclay/dataclay.jar ${DEMO_HOME}/dataclay.jar

# Get pyclay 
COPY --from=0 /home/dataclayusr/dataclay/pyclay/ ${DEMO_HOME}/pyclay
RUN python3 -m pip install -r ${DEMO_HOME}/pyclay/requirements.txt

# Add pyclay source to pythonpath 
ENV PYTHONPATH=${DEMO_HOME}/pyclay/src:${PYTHONPATH}
ENV CLASSPATH=${DEMO_HOME}/dataclay.jar:${CLASSPATH}

# Install dislib
RUN python3 -m pip install scipy==1.3.1 matplotlib scikit-learn
RUN mkdir -p ${DEMO_HOME}/dislib 
RUN git clone https://github.com/bsc-wdc/dislib.git ${DEMO_HOME}/dislib
# Checkout to specific working commit for current dataclay modifications in array.py
RUN cd ${DEMO_HOME}/dislib && git checkout f5959149b2849ed2514467027bd9c2a31ddaea74
ENV PYTHONPATH=${DEMO_HOME}/dislib:${PYTHONPATH}

# Get modified Dislib array code 
#COPY ./binding.py /opt/COMPSs/Bindings/python/3/pycompss/runtime/binding.py
COPY ./array.py ${DEMO_HOME}/dislib/dislib/data/array.py
