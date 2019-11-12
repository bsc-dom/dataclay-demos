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
	-t bscdataclay/wordcount-python-demo .			

### RUN DEMO ####
docker run --network=dataclay_default \
    bscdataclay/wordcount-python-demo src/wordcount.py
    
popd

### STOP DATACLAY ####
pushd $SCRIPTDIR/dataclay
docker-compose down -v
popd