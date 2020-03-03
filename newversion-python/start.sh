#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
grn=$'\e[1;32m'
blu=$'\e[1;34m'
red=$'\e[1;91m'
end=$'\e[0m'
function printError { 
  echo "${red}======== $1 ========${end}"
}
function printMsg { 
  echo "${blu}======== $1 ========${end}"
}

printMsg "Starting dataClay"
echo "Optional commands=$COMMAND_OPTS"
export COMMAND_OPTS=$COMMAND_OPTS
pushd $SCRIPTDIR/dataclay
docker-compose up -d
popd

# wait for dataClay to be alive
docker run --rm --network=dataclay_default -v $PWD/app/cfgfiles/:/home/dataclayusr/dataclay/cfgfiles/:ro \
	 bscdataclay/client:2.1 WaitForDataClayToBeAlive 10 5
	 
printMsg "dataClay successfully started!"

    