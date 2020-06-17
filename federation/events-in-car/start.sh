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
if [ "$#" -ne 1 ] ; then
	echo "ERROR: usage: $0 <fermata|tram> "
	exit 1
fi

# create network if not created
docker network create dataclaynetwork 

HOSTNAME=$1
printMsg "Starting dataClay in $HOSTNAME"
echo "Optional commands=$COMMAND_OPTS"
export COMMAND_OPTS=$COMMAND_OPTS
pushd $SCRIPTDIR/dataclay_$HOSTNAME
docker-compose up -d
popd

# wait for dataClay to be alive
docker run --rm --network dataclaynetwork -v $PWD/app/$HOSTNAME/cfgfiles/:/home/dataclayusr/dataclay/cfgfiles/:ro \
	 bscdataclay/client WaitForDataClayToBeAlive 10 5
