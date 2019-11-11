#!/bin/bash

### START DATACLAY WITH TRACING ####
export COMMAND_OPTS="--tracing"
pushd docker-compose
docker-compose kill
docker-compose down -v #sanity check
docker-compose up -d
popd

### BUILD ####
docker build --network=docker-compose_default \
	--build-arg CACHEBUST=$(date +%s) \
	-t bscdataclay/wordcount-python-demo .			
	
### RUN DEMO ####

# Word count
# Modify session configuration to add flag Tracing=True and mount trace volume to collect traces once done
docker run --network=docker-compose_default \
	-v `pwd`/cfgfiles/session.extrae.properties:/usr/src/demo/app/cfgfiles/session.properties \
    -v `pwd`/trace:/usr/src/demo/app/trace:rw \
    bscdataclay/wordcount-python-demo src/wordcount.py --tracing

echo "Traces created at $(pwd)/trace/"

### STOP DATACLAY ####
pushd docker-compose
#docker-compose down -v
popd
