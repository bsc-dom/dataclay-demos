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
# Word count
printMsg "Running Demo"

printMsg "Preparing COMPSs container"
docker run -d --name hellopeople-java-compss --network=dataclay_default $DEMO_IMG_NAME

printMsg " - Running the application onto COMPSs container"
docker exec hellopeople-java-compss /opt/COMPSs/Runtime/scripts/user/runcompss \
	--task_execution=compss --graph=false \
	--storage_conf=/demo/cfgfiles/session.properties \
  --classpath=/demo/dataclay.jar:/demo/target/dependency/*:/demo/target/hellopeople-demo-latest.jar \
  app.HelloPeople

printMsg "Stopping the COMPSs container"
docker kill hellopeople-java-compss
popd 

docker rm -f -v hellopeople-java-compss
    