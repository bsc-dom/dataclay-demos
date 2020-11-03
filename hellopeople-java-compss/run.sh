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
# Word count
printMsg "Running Demo"
printMsg "Preparing COMPSs container"
docker run -d --name hellopeople-java-compss --network=dataclaynet dataclaydemos/hello-people-java-compss

printMsg " - Running the application onto COMPSs container"
docker exec hellopeople-java-compss /opt/COMPSs/Runtime/scripts/user/runcompss \
	--task_execution=compss --graph=false \
	--storage_conf=/demo/cfgfiles/session.properties \
  --classpath=/demo/dataclay.jar:/demo/target/dependency/*:/demo/target/hellopeople-demo-latest.jar \
  app.HelloPeople

printMsg "Stopping the COMPSs container"
docker kill hellopeople-java-compss
docker rm -f -v hellopeople-java-compss
    