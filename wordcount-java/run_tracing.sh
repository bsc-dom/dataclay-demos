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
printMsg "Generating words"
docker run --rm --network=dataclaynet \
	  -v `pwd`/app/text:/demo/text:ro \
    dataclaydemos/wordcount-java -Dexec.mainClass="TextCollectionGen" words /demo/text
printMsg "Running wordcount"
docker run --rm --network=dataclaynet \
	  -v `pwd`/app/text:/demo/text:ro \
	  -v `pwd`/app/cfgfiles/session.extrae.properties:/demo/cfgfiles/session.properties \
	  -v `pwd`/extrae/extrae_config.xml:/home/dataclayusr/dataclay/extrae/extrae_basic.xml \
    -v `pwd`/trace:/demo/trace:rw \
    dataclaydemos/wordcount-java --tracing -Dexec.mainClass="Wordcount" words

    
