#!/bin/bash

### DATACLAY VERSIONS TO BE USED IN DEMO ####
export DATACLAY_CLIENT_CONTAINER_VERSION=2.0.dev22
export DATACLAY_JAVA_CONTAINER_VERSION=2.0.jdk8.dev22
export DATACLAY_PYTHON_CONTAINER_VERSION=2.0.py36.dev22

### START DATACLAY ####
pushd docker-compose
docker-compose down -v #sanity check
docker-compose up -d
popd

### BUILD ####
docker build --network=docker-compose_default \
	--build-arg CACHEBUST=$(date +%s) \
	--build-arg DATACLAY_DOCKER_TAG=$DATACLAY_CLIENT_CONTAINER_VERSION \
	-t bscdataclay/hellopeople-demo .			

### RUN DEMO ####
docker run --network=docker-compose_default \
	-v `pwd`/cfgfiles/client.properties:/usr/src/hellopeople/app/cfgfiles/client.properties:ro \
	-v `pwd`/cfgfiles/session.properties:/usr/src/hellopeople/app/cfgfiles/session.properties:ro \
	-v `pwd`/cfgfiles/log4j2.xml:/usr/src/hellopeople/app/log4j2.xml:ro \
    bscdataclay/hellopeople-demo -Dexec.mainClass="app.HelloPeople" -Dexec.args="forthepeople martin 33"
