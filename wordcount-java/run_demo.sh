#!/bin/bash

### DATACLAY VERSIONS TO BE USED IN DEMO ####
export DATACLAY_CLIENT_CONTAINER_VERSION=2.0.dev22
export DATACLAY_JAVA_CONTAINER_VERSION=2.0.jdk11.dev22

### START DATACLAY ####
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

# Generate
docker run --network=docker-compose_default \
	-v `pwd`/app/text:/usr/src/demo/app/text:ro \
    bscdataclay/wordcount-java-demo -Dexec.mainClass="TextCollectionGen" -Dexec.args="words /usr/src/demo/app/text"

# Word count
docker run --network=docker-compose_default \
	-v `pwd`/app/text:/usr/src/demo/app/text:ro \
    bscdataclay/wordcount-java-demo -Dexec.mainClass="Wordcount" -Dexec.args="words";

### STOP DATACLAY ####
pushd docker-compose
docker-compose down -v
popd
