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
printMsg "Building demo dataclaydemos/wordcount-python"
# Build #
docker build --network=dataclaynet \
	--build-arg CACHEBUST=$(date +%s) \
	-t dataclaydemos/wordcount-python .
printMsg "dataclaydemos/wordcount-python docker demo build!"
