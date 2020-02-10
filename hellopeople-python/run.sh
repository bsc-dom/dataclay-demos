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

pushd $SCRIPTDIR
DEMO_IMG_NAME=bscdataclay/${PWD##*/}-demo

printMsg "Running demo $DEMO_IMG_NAME"
docker run --network=dataclay_default \
    $DEMO_IMG_NAME src/hellopeople.py forthepeople martin 33
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
    
popd 
    