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
printMsg "Running Demo --consumer stage"
printMsg "Preparing COMPSs container"
docker run -d --name wordcount-pycompss --network=dataclaynet dataclaydemos/wordcount-python-compss

printMsg " - Running the application onto COMPSs container"
docker exec wordcount-pycompss /opt/COMPSs/Runtime/scripts/user/runcompss \
    --tracing=true \
	  --task_execution=compss --graph=false \
    --lang=python \
    --python_interpreter=python3 \
    --pythonpath=/demo/ \
	  --storage_conf=/demo/cfgfiles/session.extrae.properties \
	  --jvm_workers_opts="-javaagent:/demo/aspectj/aspectjweaver.jar" \
	  --jvm_master_opts="-javaagent:/demo/aspectj/aspectjweaver.jar" \
    --classpath=/demo/dataclay.jar \
    src/wordcount.py

rm -rf trace #sanity check 
docker cp wordcount-pycompss:/root/.COMPSs/wordcount.py_01/trace .

printMsg "Stopping the COMPSs container"
docker kill wordcount-pycompss
docker rm -f -v wordcount-pycompss



    