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
	-t bscdataclay/wordcount-java-demo .			
	
### RUN DEMO ####

mkdir -p trace
# Generate
docker run --network=dataclay_default \
	-v `pwd`/app/text:/usr/src/demo/app/text:ro \
    bscdataclay/wordcount-java-demo -Dexec.mainClass="TextCollectionGen" words /usr/src/demo/app/text

# Word count
# Modify session configuration to add flag Tracing=True and mount trace volume to collect traces once done
docker run --network=dataclay_default \
	-e DATACLAYSESSIONCONFIG=/usr/src/demo/app/cfgfiles/session.extrae.properties \
	-v `pwd`/app/text:/usr/src/demo/app/text:ro \
    -v `pwd`/trace:/usr/src/demo/app/trace:rw \
    bscdataclay/wordcount-java-demo --tracing -Dexec.mainClass="Wordcount" words

echo "Traces created at $(pwd)/trace/"

### STOP DATACLAY ####
pushd $SCRIPTDIR/dataclay
docker-compose down -v
popd
