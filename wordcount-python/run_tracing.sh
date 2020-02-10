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

printMsg "Running demo"
# Word count
# Modify session configuration to add flag Tracing=True and mount trace volume to collect traces once done
docker run --network=dataclay_default \
	-v `pwd`/app/cfgfiles/session.extrae.properties:/demo/cfgfiles/session.properties \
    -v `pwd`/trace:/demo/trace:rw \
    $DEMO_IMG_NAME src/wordcount.py --tracing
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
popd

