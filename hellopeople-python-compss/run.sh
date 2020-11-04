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
printMsg "Running Demo"
printMsg "Preparing COMPSs container"
docker run -d --name hellopeople-pycompss --network=dataclaynet dataclaydemos/hello-people-python-compss

printMsg " - Running the application onto COMPSs container"
docker exec hellopeople-pycompss /opt/COMPSs/Runtime/scripts/user/runcompss \
	  --task_execution=compss --graph=false \
    --lang=python \
    --python_interpreter=python3 \
    --pythonpath=/demo/ \
	  --storage_conf=/demo/cfgfiles/session.properties \
    --classpath=/demo/dataclay.jar \
    src/hellopeople.py

printMsg "Stopping the COMPSs container"
docker kill hellopeople-pycompss
docker rm -f -v hellopeople-pycompss

    