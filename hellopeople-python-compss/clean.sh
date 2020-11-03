#!/bin/sh
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
# ensure that there is no COMPSs dangling container there
docker rm -f -v hellopeople-pycompss

printMsg "Removing and cleaning dataClay dockers"
docker-compose kill
docker-compose down -v #sanity check

# Clean build dockers
docker rmi -f dataclaydemos/hello-people-python
docker rmi -f dataclaydemos/hello-people-python-compss
printMsg "Cleaned!"
