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

bash $SCRIPTDIR/clean.sh
bash $SCRIPTDIR/start.sh
bash $SCRIPTDIR/build.sh
bash $SCRIPTDIR/run.sh
bash $SCRIPTDIR/stop.sh
bash $SCRIPTDIR/clean.sh

printMsg " DEMO SUCCESSFULLY FINISHED :) "
    