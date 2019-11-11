#!/bin/bash

### START DATACLAY ####
pushd docker-compose
docker-compose kill
docker-compose down -v #sanity check
docker-compose up -d
popd

### BUILD ####
docker build --network=docker-compose_default \
	--build-arg CACHEBUST=$(date +%s) \
	-t bscdataclay/wordcount-java-demo .			
	
### RUN DEMO ####

# Generate
docker run --network=docker-compose_default \
	-v `pwd`/app/text:/usr/src/demo/app/text:ro \
    bscdataclay/wordcount-java-demo -Dexec.mainClass="TextCollectionGen" words /usr/src/demo/app/text

# Word count
docker run --network=docker-compose_default \
	-v `pwd`/app/text:/usr/src/demo/app/text:ro \
    bscdataclay/wordcount-java-demo -Dexec.mainClass="Wordcount" words

### STOP DATACLAY ####
pushd docker-compose
docker-compose down -v
popd
