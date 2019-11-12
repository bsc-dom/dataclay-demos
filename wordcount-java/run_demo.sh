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
	-t bscdataclay/wordcount-java-demo .			
	
### RUN DEMO ####

# Generate
docker run --network=dataclay_default \
	-v `pwd`/app/text:/usr/src/demo/app/text:ro \
    bscdataclay/wordcount-java-demo -Dexec.mainClass="TextCollectionGen" words /usr/src/demo/app/text

# Word count
docker run --network=dataclay_default \
	-v `pwd`/app/text:/usr/src/demo/app/text:ro \
    bscdataclay/wordcount-java-demo -Dexec.mainClass="Wordcount" words

popd

### STOP DATACLAY ####
pushd $SCRIPTDIR/dataclay
docker-compose down -v
popd
