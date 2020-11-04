#!/bin/sh
set -e
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

HOSTNAME=$1
printMsg "Stopping dataClay at $HOSTNAME"
cd ./$HOSTNAME/dataclay_$HOSTNAME
STARTTIME=$(date +%s)
docker-compose stop
ENDTIME=$(date +%s)
cd $SCRIPTDIR

echo "dataClay stopped in $(($ENDTIME - $STARTTIME)) seconds"
printMsg "dataClay successfully stopped!"

    