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

printMsg "Checking requirements"
$SCRIPTDIR/check_requirements.sh
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
printMsg "Creating machines"
$SCRIPTDIR/create_machines.sh
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
printMsg "Generating certificates"
$SCRIPTDIR/generate_certs.sh
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
printMsg "Building model"
$SCRIPTDIR/build.sh
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
printMsg "Deploying model to machines"
$SCRIPTDIR/deploy_model.sh
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
printMsg "Building and deploying applications"
$SCRIPTDIR/deploy_apps.sh
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
printMsg "Running demo"
$SCRIPTDIR/run.sh
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi

echo ""
printMsg " DEMO SUCCESSFULLY FINISHED :) "
