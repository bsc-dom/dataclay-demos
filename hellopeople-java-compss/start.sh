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
printMsg "Starting dataClay"
docker-compose up -d
# wait for dataClay to be alive
docker run --rm --network=dataclaynet -v $PWD/app/cfgfiles/:/home/dataclayusr/dataclay/cfgfiles/:ro \
	 bscdataclay/client WaitForDataClayToBeAlive 10 5
printMsg "dataClay successfully started!"

    