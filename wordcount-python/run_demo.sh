#!/bin/bash

### START DATACLAY ####
pushd docker-compose
docker-compose kill #sanity check
docker-compose down -v #sanity check
docker-compose up -d
popd

### BUILD ####
docker build --network=docker-compose_default \
	--build-arg CACHEBUST=$(date +%s) \
	-t bscdataclay/wordcount-python-demo .			

### RUN DEMO ####
docker run --network=docker-compose_default \
    bscdataclay/wordcount-python-demo src/wordcount.py
    
### STOP DATACLAY ####
pushd docker-compose
docker-compose down -v
popd
    