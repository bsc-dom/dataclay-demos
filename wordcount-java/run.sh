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

printMsg "Generating words using $DEMO_IMG_NAME"
# Generate
docker run --network=dataclay_default \
	-v `pwd`/app/text:/demo/text:ro \
    $DEMO_IMG_NAME -Dexec.mainClass="TextCollectionGen" words /demo/text
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi

printMsg "Running wordcount in $DEMO_IMG_NAME"
docker run --network=dataclay_default \
	-v `pwd`/app/text:/demo/text:ro \
    $DEMO_IMG_NAME -Dexec.mainClass="Wordcount" words
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
    
popd 
    