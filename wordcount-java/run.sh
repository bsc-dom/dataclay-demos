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
    dataclaydemos/wordcount-java -Dexec.mainClass="Wordcount" words
    