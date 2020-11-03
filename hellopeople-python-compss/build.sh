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
# Build
printMsg "Building demo dataclaydemos/hello-people-python"
docker build --network=dataclaynet \
	--build-arg CACHEBUST=$(date +%s) \
	-t dataclaydemos/hello-people-python .
printMsg "... producer image built successfully"

printMsg "Building demo dataclaydemos/hello-people-python-compss"
docker build --network=dataclaynet \
	--build-arg CACHEBUST=$(date +%s) \
	-f compss.Dockerfile \
	-t dataclaydemos/hello-people-python-compss .
printMsg "... consumer image built successfully"
