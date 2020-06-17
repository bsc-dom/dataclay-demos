#!/bin/bash -e
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#-----------------------------------------------------------------------
# Helper functions (miscellaneous)
#-----------------------------------------------------------------------
cyan=$'\e[1;36m'; end=$'\e[0m'
function printMsg { echo "${cyan}======== $1 ========${end}"; }

#-----------------------------------------------------------------------
# MAIN
#-----------------------------------------------------------------------

printMsg "Starting dataClay"
echo "Optional commands=$COMMAND_OPTS"
export COMMAND_OPTS=$COMMAND_OPTS
pushd $SCRIPTDIR/dataclay
docker-compose up -d logicmodule 
docker-compose up -d dsjava
sleep 5 # to make sure dsjava is registered 
docker-compose up -d dspython 
popd

# wait for dataClay to be alive
docker run --rm --network=dataclay_default -v $PWD/app/cfgfiles/:/home/dataclayusr/dataclay/cfgfiles/:ro \
	 bscdataclay/client:develop WaitForDataClayToBeAlive 10 5
	 
printMsg "dataClay successfully started!"

    