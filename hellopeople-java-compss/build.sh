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
	-t bscdataclay/hellopeople-java-demo .			
printMsg "... image built successfully"

DEMO_IMG_NAME=bscdataclay/${PWD##*/}-demo
printMsg "Building demo $DEMO_IMG_NAME"
docker build --network=dataclay_default \
	--build-arg CACHEBUST=$(date +%s) \
	-f compss.Dockerfile \
	-t $DEMO_IMG_NAME .			
printMsg "... image built successfully"


printMsg "$DEMO_IMG_NAME docker demo build!"