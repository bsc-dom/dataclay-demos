#!/bin/sh
SCRIPTDIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
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
printMsg "Removing and cleaning dataClay dockers"
cd $SCRIPTDIR/city/dataclay_city
docker-compose kill
docker-compose down -v #sanity check

cd $SCRIPTDIR/car/dataclay_car
docker-compose kill
docker-compose down -v #sanity check

cd $SCRIPTDIR

# Clean build dockers
docker rmi -f dataclaydemo/city
docker rmi -f dataclaydemo/car
docker network rm dataclaynetwork

printMsg "Cleaned!"