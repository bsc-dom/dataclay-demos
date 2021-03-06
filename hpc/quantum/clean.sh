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

# ensure that there is no COMPSs dangling container there
docker rm -f -v quantum-pycompss

printMsg "Removing and cleaning dataClay dockers"
pushd $SCRIPTDIR/dataclay
docker-compose kill
docker-compose down -v #sanity check
popd

# Clean build dockers
DEMO_IMG_NAME=bscdataclay/${PWD##*/}-demo
docker rmi -f $DEMO_IMG_NAME
docker rmi -f bscdataclay/quantum-demo

printMsg "Cleaned!"