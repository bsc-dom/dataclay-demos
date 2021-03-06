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
# Build
pushd $SCRIPTDIR
printMsg "Building demo $DEMO_IMG_NAME"
docker build --network=dataclay_default \
	--build-arg CACHEBUST=$(date +%s) \
	-t bscdataclay/quantum-demo .			
printMsg "... producer image built successfully"

DEMO_IMG_NAME=bscdataclay/${PWD##*/}-demo
printMsg "Building demo $DEMO_IMG_NAME"
docker build --network=dataclay_default \
	--build-arg CACHEBUST=$(date +%s) \
	-f quantum.Dockerfile \
	-t $DEMO_IMG_NAME .			
printMsg "... consumer image built successfully"

printMsg "$DEMO_IMG_NAME docker demo build!"