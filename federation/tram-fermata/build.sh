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
cd $SCRIPTDIR/fermata
docker build --network=dataclaynetwork --no-cache -t dataclaydemo/fermata .

cd $SCRIPTDIR/tram
docker build --network=dataclaynetwork --no-cache -t dataclaydemo/tram .

cd $SCRIPTDIR

