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
  echo "${blu}======== $1 ========${end}"
}
function printResultMsg { 
  echo "${grn}======== $1 ========${end}"
}

# ============= CLEAN DATACLAY ================== #
bash $SCRIPTDIR/clean.sh

# ============= START DATACLAY ================== #
bash $SCRIPTDIR/start.sh

# ============= BUILD DEMO ================== #
pushd $SCRIPTDIR
printMsg "Building demo $DEMO_IMG_NAME"
docker build --network=dataclay_default \
	--build-arg CACHEBUST=$(date +%s) \
	-t bscdataclay/wordcount-java-demo .			
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
printMsg "... producer image built successfully"

DEMO_IMG_NAME=bscdataclay/${PWD##*/}-demo
printMsg "Building demo $DEMO_IMG_NAME"
docker build --network=dataclay_default \
	--build-arg CACHEBUST=$(date +%s) \
	-f compss.Dockerfile \
	-t $DEMO_IMG_NAME .			
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
printMsg "... consumer image built successfully"

# ============= STOP DATACLAY ================== #
bash $SCRIPTDIR/stop.sh    

printResultMsg "$DEMO_IMG_NAME docker demo build!"