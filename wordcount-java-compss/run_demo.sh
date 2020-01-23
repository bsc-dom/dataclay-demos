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

# ensure that there is no COMPSs dangling container there
docker rm -f wordcount-compss

docker-compose down -v
docker-compose up -d
popd

pushd $SCRIPTDIR

printMsg "Building app"
docker build --network=dataclay_default \
	--build-arg CACHEBUST=$(date +%s) \
	-t bscdataclay/wordcount-java-demo .			
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
printMsg "... producer image built successfully"

docker build --network=dataclay_default \
	--build-arg CACHEBUST=$(date +%s) \
  -f compss.Dockerfile \
	-t bscdataclay/wordcount-java-compss-demo .
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
printMsg "... consumer image built successfully"

# Generate
printMsg "Running Demo --producer stage"
docker run --rm --network=dataclay_default \
	-v `pwd`/app/text:/demo/text:ro \
    bscdataclay/wordcount-java-demo -Dexec.mainClass="TextCollectionGen" words /demo/text
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi

# Word count
printMsg "Running Demo --consumer stage"

printMsg " - Preparing COMPSs container"
docker run -d --rm --name wordcount-compss --network=dataclay_default bscdataclay/wordcount-java-compss-demo

printMsg " - Running the application onto COMPSs container"
docker exec wordcount-compss /opt/COMPSs/Runtime/scripts/user/runcompss \
	--storage_conf=/demo/cfgfiles/session.properties \
  --classpath=/demo/dataclay.jar:/demo/target/dependency/*:/demo/target/wordcount-demo-2.1.jar \
  Wordcount words

if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi

printMsg " - Stopping the COMPSs container"
docker kill wordcount-compss

popd

printMsg "Stopping dataClay"
pushd $SCRIPTDIR/dataclay
docker-compose down -v
popd

echo ""
printMsg " DEMO SUCCESSFULLY FINISHED :) "
