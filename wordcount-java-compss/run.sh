#!/bin/bash -e
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#-----------------------------------------------------------------------
# Helper functions (miscellaneous)
#-----------------------------------------------------------------------
cyan=$'\e[1;36m'; end=$'\e[0m'
function printMsg { echo "${cyan}======== $1 ========${end}"; }

#-----------------------------------------------------------------------
# MAIN
#-----------------------------------------------------------------------

pushd $SCRIPTDIR
DEMO_IMG_NAME=bscdataclay/${PWD##*/}-demo

# Generate
printMsg "Running Demo --producer stage"
docker run --network=dataclay_default \
	-v `pwd`/app/text:/demo/text:ro \
	--name ${PWD##*/}-demo-word-gen \
    bscdataclay/wordcount-java-demo -Dexec.mainClass="TextCollectionGen" words /demo/text

# Word count
printMsg "Running Demo --consumer stage"

printMsg "Preparing COMPSs container"
docker run -d --name wordcount-compss --network=dataclay_default $DEMO_IMG_NAME

printMsg " - Running the application onto COMPSs container"
docker exec wordcount-compss /opt/COMPSs/Runtime/scripts/user/runcompss \
	--task_execution=compss --graph=false \
	--storage_conf=/demo/cfgfiles/session.properties \
  --classpath=/demo/dataclay.jar:/demo/target/dependency/*:/demo/target/wordcount-demo-latest.jar \
  Wordcount words

printMsg "Stopping the COMPSs container"
docker kill wordcount-compss
popd 

docker rm -f -v ${PWD##*/}-demo-word-gen
docker rm -f -v wordcount-compss
    