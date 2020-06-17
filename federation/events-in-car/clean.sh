#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#-----------------------------------------------------------------------
# Helper functions (miscellaneous)
#-----------------------------------------------------------------------
cyan=$'\e[1;36m'; end=$'\e[0m'
function printMsg { echo "${cyan}======== $1 ========${end}"; }

#-----------------------------------------------------------------------
# MAIN
#-----------------------------------------------------------------------
printMsg "Removing and cleaning dataClay dockers"
pushd $SCRIPTDIR/dataclay_city
docker-compose kill
docker-compose down -v #sanity check
popd

pushd $SCRIPTDIR/dataclay_car
docker-compose kill
docker-compose down -v #sanity check
popd

# Clean build dockers
docker rmi -f dataclaydemo/client
docker rmi -f dataclaydemo/city
docker rmi -f dataclaydemo/car
docker rmi -f dataclaydemo/dataclay-logicmodule
docker rmi -f dataclaydemo/dataclay-dsjava
docker rmi -f dataclaydemo/dataclay-dspython

docker network rm dataclaynetwork

printMsg "Cleaned!"