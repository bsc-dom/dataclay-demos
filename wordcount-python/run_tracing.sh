#!/bin/bash

### DATACLAY VERSIONS TO BE USED IN DEMO ####
export DATACLAY_CLIENT_CONTAINER_VERSION=2.0.dev22
export DATACLAY_JAVA_CONTAINER_VERSION=2.0.jdk11.dev22
export DATACLAY_PYTHON_CONTAINER_VERSION=2.0.py36.dev22

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
	--build-arg DATACLAY_DOCKER_TAG=$DATACLAY_CLIENT_CONTAINER_VERSION \
	-t bscdataclay/wordcount-python-demo .			
	
### RUN DEMO ####

# Word count
# Modify session configuration to add flag Tracing=True and mount trace volume to collect traces once done
docker run --network=docker-compose_default \
	-v `pwd`/cfgfiles/session.extrae.properties:/usr/src/demo/app/cfgfiles/session.properties \
    -v `pwd`/trace:/usr/src/demo/app/trace:rw \
    bscdataclay/wordcount-python-demo --tracing

echo "Traces created at $(pwd)/trace/"

### STOP DATACLAY ####
pushd docker-compose
#docker-compose down -v
popd
