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

    