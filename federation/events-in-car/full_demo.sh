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
export COMMAND_OPTS="--debug"
bash $SCRIPTDIR/clean.sh
bash $SCRIPTDIR/build.sh
bash $SCRIPTDIR/start.sh city
bash $SCRIPTDIR/start.sh car
bash $SCRIPTDIR/run.sh
bash $SCRIPTDIR/stop.sh car
bash $SCRIPTDIR/stop.sh city
bash $SCRIPTDIR/clean.sh

printMsg " DEMO SUCCESSFULLY FINISHED :) "
    
