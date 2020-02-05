#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
grn=$'\e[1;32m'
blu=$'\e[1;34m'
end=$'\e[0m'
function printError { 
  echo "${red}======== $1 ========${end}"
}
function printMsg { 
  echo "${blu}======== $1 ========${end}"
}

# ensure that there is no COMPSs dangling container there
docker rm -f wordcount-compss

printMsg "Removing and cleaning dataClay dockers"
pushd $SCRIPTDIR/dataclay
docker-compose kill
docker-compose down -v #sanity check
popd
printMsg "Cleaned!"