#!/bin/bash

### DATACLAY VERSIONS TO BE USED IN DEMO ####
export DATACLAY_CLIENT_CONTAINER_VERSION=2.0.dev22
export DATACLAY_JAVA_CONTAINER_VERSION=2.0.jdk11.dev22

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
	-t bscdataclay/wordcount-java-demo .			
	
### RUN DEMO ####

mkdir -p trace
# Generate
docker run --network=docker-compose_default \
	-v `pwd`/app/text:/usr/src/demo/app/text:ro \
    bscdataclay/wordcount-java-demo -Dexec.mainClass="TextCollectionGen" words /usr/src/demo/app/text

# Word count
# Modify session configuration to add flag Tracing=True and mount trace volume to collect traces once done
docker run --network=docker-compose_default \
	-e DATACLAYSESSIONCONFIG=/usr/src/demo/app/cfgfiles/session.extrae.properties \
	-v `pwd`/app/text:/usr/src/demo/app/text:ro \
    -v `pwd`/trace:/usr/src/demo/app/trace:rw \
    bscdataclay/wordcount-java-demo --tracing -Dexec.mainClass="Wordcount" words

echo "Traces created at $(pwd)/trace/"

### STOP DATACLAY ####
pushd docker-compose
docker-compose down -v
popd
