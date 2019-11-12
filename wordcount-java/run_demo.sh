#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
grn=$'\e[1;32m'
blu=$'\e[1;34m'
red=$'\e[1;91m'
end=$'\e[0m'
function printError { 
  echo "${red}======== $1 ========${end}"
}
function printMsg { 
  echo "${grn}======== $1 ========${end}"
}

printMsg "Starting dataClay"
pushd $SCRIPTDIR/dataclay
docker-compose kill
docker-compose down -v #sanity check
docker-compose up -d
popd

pushd $SCRIPTDIR

printMsg "Building app"
docker build --network=dataclay_default \
	--build-arg CACHEBUST=$(date +%s) \
	-t bscdataclay/wordcount-java-demo .			
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
	
printMsg "Running demo"
# Generate
docker run --network=dataclay_default \
	-v `pwd`/app/text:/usr/src/demo/app/text:ro \
    bscdataclay/wordcount-java-demo -Dexec.mainClass="TextCollectionGen" words /usr/src/demo/app/text
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi

# Word count
docker run --network=dataclay_default \
	-v `pwd`/app/text:/usr/src/demo/app/text:ro \
    bscdataclay/wordcount-java-demo -Dexec.mainClass="Wordcount" words
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi

popd

printMsg "Stopping dataClay"
pushd $SCRIPTDIR/dataclay
docker-compose down -v
popd

echo ""
printMsg " DEMO SUCCESSFULLY FINISHED :) "
