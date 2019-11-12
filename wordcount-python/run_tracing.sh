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

printMsg "Starting dataClay with tracing"
export COMMAND_OPTS="--tracing"
pushd $SCRIPTDIR/dataclay
docker-compose kill
docker-compose down -v #sanity check
docker-compose up -d
popd

pushd $SCRIPTDIR

printMsg "Building app"
docker build --network=dataclay_default \
	--build-arg CACHEBUST=$(date +%s) \
	-t bscdataclay/wordcount-python-demo .			
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
	
printMsg "Running demo"

# Word count
# Modify session configuration to add flag Tracing=True and mount trace volume to collect traces once done
docker run --network=dataclay_default \
	-v `pwd`/cfgfiles/session.extrae.properties:/usr/src/demo/app/cfgfiles/session.properties \
    -v `pwd`/trace:/usr/src/demo/app/trace:rw \
    bscdataclay/wordcount-python-demo src/wordcount.py --tracing
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi

printMsg "Traces created at $(pwd)/trace/"

printMsg "Stopping dataClay"
pushd $SCRIPTDIR/dataclay
docker-compose down -v
popd

echo ""
printMsg " DEMO SUCCESSFULLY FINISHED :) "
