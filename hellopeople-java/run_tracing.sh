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
printMsg "Running demo"
docker run --rm --network=dataclaynet \
	-v `pwd`/app/text:/demo/text:ro \
	-v `pwd`/app/cfgfiles/global.properties:/demo/cfgfiles/global.properties \
	-v `pwd`/app/cfgfiles/log4j2.xml:/demo/cfgfiles/log4j2.xml \
	-v `pwd`/app/cfgfiles/session.extrae.properties:/demo/cfgfiles/session.properties \
  -v `pwd`/trace:/demo/trace:rw \
  dataclaydemos/hello-people-java -Dexec.mainClass="app.HelloPeople" --tracing forthepeople martin 33

    