#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

### START DATACLAY WITH TRACING ####
export COMMAND_OPTS="--tracing"
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

# Word count
# Modify session configuration to add flag Tracing=True and mount trace volume to collect traces once done
docker run --network=dataclay_default \
	-v `pwd`/cfgfiles/session.extrae.properties:/usr/src/demo/app/cfgfiles/session.properties \
    -v `pwd`/trace:/usr/src/demo/app/trace:rw \
    bscdataclay/wordcount-python-demo src/wordcount.py --tracing

echo "Traces created at $(pwd)/trace/"

### STOP DATACLAY ####
pushd $SCRIPTDIR/dataclay
docker-compose down -v
popd
