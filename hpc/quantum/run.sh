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

if [ "$#" -ne 1 ]; then
    echo "Usage: run.sh <app>"
    exit 1
fi
APP=$1

DEMO_IMG_NAME=bscdataclay/${PWD##*/}-demo

# Word count
printMsg "Running Demo --consumer stage"

printMsg "Preparing COMPSs container"
docker run -d --name quantum-pycompss \
	--network=dataclay_default $DEMO_IMG_NAME
	
printMsg " - Running the application onto COMPSs container"
docker exec quantum-pycompss /opt/COMPSs/Runtime/scripts/user/runcompss \
	--task_execution=compss --graph=false \
    --lang=python \
    --python_interpreter=python3 \
    --pythonpath=/demo/:/demo/src:/demo/stubs \
	--storage_conf=/demo/cfgfiles/session.properties \
  --classpath=/demo/dataclay.jar \
  src/${APP}.py 

printMsg "Stopping the COMPSs container"
docker kill quantum-pycompss
docker rm -f -v quantum-pycompss

popd 

    
