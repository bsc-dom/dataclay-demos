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
printMsg "Preparing COMPSs container"
docker run -d --name wordcount-java-compss --network=dataclaynet dataclaydemos/wordcount-java-compss

printMsg " - Running the application onto COMPSs container"
docker exec wordcount-java-compss /opt/COMPSs/Runtime/scripts/user/runcompss \
	--task_execution=compss --graph=false \
	--storage_conf=/demo/cfgfiles/session.properties \
  --classpath=/demo/dataclay.jar:/demo/target/dependency/*:/demo/target/wordcount-demo-latest.jar \
  Wordcount words

printMsg "Stopping the COMPSs container"
docker kill wordcount-java-compss
docker rm -f -v wordcount-java-compss
    