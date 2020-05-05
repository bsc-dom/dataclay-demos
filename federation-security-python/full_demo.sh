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

printMsg "Checking requirements"
$SCRIPTDIR/check_requirements.sh

printMsg "Creating machines"
$SCRIPTDIR/create_machines.sh

printMsg "Generating certificates"
$SCRIPTDIR/generate_certs.sh

printMsg "Building model"
$SCRIPTDIR/build.sh

printMsg "Deploying model to machines"
$SCRIPTDIR/deploy_model.sh

printMsg "Building and deploying applications"
$SCRIPTDIR/deploy_apps.sh

printMsg "Running demo"
$SCRIPTDIR/run.sh

printMsg " DEMO SUCCESSFULLY FINISHED :) "
