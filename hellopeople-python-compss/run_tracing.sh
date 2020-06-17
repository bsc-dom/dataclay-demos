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
printMsg "Running Demo --consumer stage"

printMsg "Preparing COMPSs container"
docker run -d --name hellopeople-pycompss --network=dataclay_default $DEMO_IMG_NAME

printMsg " - Running the application onto COMPSs container"
docker exec hellopeople-pycompss /opt/COMPSs/Runtime/scripts/user/runcompss \
	--tracing=true \
	--task_execution=compss --graph=false \
    --lang=python \
    --python_interpreter=python3 \
    --pythonpath=/demo/:/opt/COMPSs/Dependencies/extrae/libexec:/opt/COMPSs/Dependencies/extrae/lib \
	--jvm_workers_opts="-javaagent:/demo/aspectj/aspectjweaver.jar" \
	--jvm_master_opts="-javaagent:/demo/aspectj/aspectjweaver.jar" \
	--storage_conf=/demo/cfgfiles/session.extrae.properties \
  --classpath=/demo/dataclay.jar \
  src/hellopeople.py 

rm -rf trace #sanity check 
docker cp hellopeople-pycompss:/root/.COMPSs/hellopeople.py_01/trace .

printMsg "Stopping the COMPSs container"
docker kill hellopeople-pycompss
docker rm -f -v hellopeople-pycompss

popd 

    