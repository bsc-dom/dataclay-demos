#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

### START DATACLAY ####
pushd $SCRIPTDIR/dataclay
docker-compose kill
docker-compose down -v #sanity check
docker-compose up -d
popd

pushd $SCRIPTDIR
### BUILD ####
docker build --network=dataclay_default \
	--build-arg CACHEBUST=$(date +%s) \
	-t bscdataclay/hellopeople-java-demo .			
	
### RUN DEMO ####
docker run --network=dataclay_default \
    bscdataclay/hellopeople-java-demo -Dexec.mainClass="app.HelloPeople" forthepeople martin 33

popd

### STOP DATACLAY ####
pushd $SCRIPTDIR/dataclay
docker-compose down -v
popd