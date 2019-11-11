#!/bin/bash

### DATACLAY VERSIONS TO BE USED IN DEMO ####
export DATACLAY_CLIENT_CONTAINER_VERSION=2.0.dev22
export DATACLAY_JAVA_CONTAINER_VERSION=2.0.jdk11.dev22

### START DATACLAY ####
pushd docker-compose
docker-compose down -v #sanity check
docker-compose up -d
popd

### BUILD ####
docker build --network=docker-compose_default \
	--build-arg CACHEBUST=$(date +%s) \
	--build-arg DATACLAY_DOCKER_TAG=$DATACLAY_CLIENT_CONTAINER_VERSION \
	-t bscdataclay/hellopeople-java-demo .			
	
### RUN DEMO ####
docker run --network=docker-compose_default \
    bscdataclay/hellopeople-java-demo -Dexec.mainClass="app.HelloPeople" -Dexec.args="forthepeople martin 33"

### STOP DATACLAY ####
pushd docker-compose
docker-compose down -v
popd