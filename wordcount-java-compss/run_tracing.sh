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

# Generate
printMsg "Running Demo --producer stage"
docker run --entrypoint /demo/entrypoints/dataclay-mvn-entry-point --rm --network=dataclaynet \
	-v `pwd`/app/text:/demo/text:ro \
  dataclaydemos/wordcount-java-compss -Dexec.mainClass="TextCollectionGen" words /demo/text

# Word count
printMsg "Running Demo --consumer stage"
printMsg " - Preparing COMPSs container"
# Mount compss trace result into local trace folder
docker run -d --name wordcount-java-compss --network=dataclaynet \
  dataclaydemos/wordcount-java-compss

printMsg " - Running the application onto COMPSs container"
docker exec  wordcount-java-compss /opt/COMPSs/Runtime/scripts/user/runcompss \
	--task_execution=compss --graph=false \
	--tracing=true \
	--storage_conf=/demo/cfgfiles/session.extrae.properties \
	--jvm_workers_opts="-javaagent:/demo/aspectj/aspectjweaver.jar" \
	--jvm_master_opts="-javaagent:/demo/aspectj/aspectjweaver.jar" \
  --classpath=/demo/dataclay.jar:/demo/target/dependency/*:/demo/target/wordcount-demo-latest.jar \
  Wordcount words

rm -rf trace #sanity check 
docker cp wordcount-java-compss:/root/.COMPSs/Wordcount_01/trace .

printMsg "Stopping the COMPSs container"
docker kill wordcount-java-compss
docker rm -f -v wordcount-java-compss
    
