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


#
printMsg "Running Demo "
printMsg " - Preparing COMPSs container"
# Mount compss trace result into local trace folder
docker run -d --name hellopeople-java-compss --network=dataclay_default $DEMO_IMG_NAME

printMsg " - Running the application onto COMPSs container"

docker exec  hellopeople-java-compss /opt/COMPSs/Runtime/scripts/user/runcompss \
	--task_execution=compss --graph=false \
	--tracing=true \
	--storage_conf=/demo/cfgfiles/session.extrae.properties \
	--jvm_workers_opts="-javaagent:/demo/aspectj/aspectjweaver.jar" \
	--jvm_master_opts="-javaagent:/demo/aspectj/aspectjweaver.jar" \
    --classpath=/demo/dataclay.jar:/demo/target/dependency/*:/demo/target/hellopeople-demo-latest.jar \
    app.HelloPeople --tracing

rm -rf trace #sanity check 
docker cp hellopeople-java-compss:/root/.COMPSs/app.HelloPeople_01/trace .

printMsg " - Stopping the COMPSs container"
docker rm -f -v hellopeople-java-compss

popd 
    
