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
printMsg "Building demo dataclaydemos/wordcount-java"
docker build --network=dataclaynet \
	--build-arg CACHEBUST=$(date +%s) \
	-t dataclaydemos/wordcount-java .
printMsg "... producer image built successfully"
printMsg "Building demo dataclaydemos/wordcount-java-compss"
docker build --network=dataclaynet \
	--build-arg CACHEBUST=$(date +%s) \
	-f compss.Dockerfile \
	-t dataclaydemos/wordcount-java-compss .
printMsg "... consumer image built successfully"
