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
if [ "$#" -ne 1 ] ; then
	echo "ERROR: usage: $0 <machine> "
	exit 1
fi

# create network if not created
docker network create dataclaynetwork 

HOSTNAME=$1
printMsg "Starting dataClay in $HOSTNAME"
cd ./$HOSTNAME/dataclay_$HOSTNAME
docker-compose up -d
cd $SCRIPTDIR

# wait for dataClay to be alive
docker run --rm --network dataclaynetwork -v $PWD/$HOSTNAME/cfgfiles/:/home/dataclayusr/dataclay/cfgfiles/:ro \
	 bscdataclay/client:develop WaitForDataClayToBeAlive 10 5
