#!/bin/sh
set -e
#-----------------------------------------------------------------------
# Helper functions (miscellaneous)
#-----------------------------------------------------------------------
CONSOLE_CYAN="\033[1m\033[36m"; CONSOLE_NORMAL="\033[0m"
printMsg() {
  printf "${CONSOLE_CYAN}### ${1}${CONSOLE_NORMAL}\n"
}
#-----------------------------------------------------------------------
# MAIN
#-----------------------------------------------------------------------

printMsg "Running Demo "
printMsg " - Preparing COMPSs container"
# Mount compss trace result into local trace folder
docker run -d --name hellopeople-java-compss --network=dataclaynet \
  dataclaydemos/hello-people-java-compss

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

