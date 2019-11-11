#!/bin/bash

### START DATACLAY ####
pushd docker-compose
docker-compose down -v #sanity check
docker-compose up -d
popd

### BUILD ####
docker build --network=docker-compose_default \
	--build-arg CACHEBUST=$(date +%s) \
	-t bscdataclay/hellopeople-java-demo .			
	
### RUN DEMO ####
docker run --network=docker-compose_default \
    bscdataclay/hellopeople-java-demo -Dexec.mainClass="app.HelloPeople" forthepeople martin 33

### STOP DATACLAY ####
pushd docker-compose
docker-compose down -v
popd