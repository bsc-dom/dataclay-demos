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
  echo "${grn}======== $1 ========${end}"
}

export COMMAND_OPTS="--tracing"

# ============= BUILD DEMO ================== #
bash $SCRIPTDIR/build.sh

# ============= START DATACLAY ================== #
bash $SCRIPTDIR/start.sh

# ============= RUN DEMO ================== #
bash $SCRIPTDIR/run_tracing.sh

# ============= STOP DATACLAY ================== #
bash $SCRIPTDIR/stop.sh

echo ""
printMsg " DEMO SUCCESSFULLY FINISHED :) "
    