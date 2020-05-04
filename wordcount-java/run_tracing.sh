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

pushd $SCRIPTDIR
DEMO_IMG_NAME=bscdataclay/${PWD##*/}-demo

printMsg "Generating words using $DEMO_IMG_NAME"
# Generate
docker run --network=dataclay_default \
	-v `pwd`/app/text:/demo/text:ro \
	--name ${PWD##*/}-demo-word-gen \
    $DEMO_IMG_NAME -Dexec.mainClass="TextCollectionGen" words /demo/text

# 	--mount type=tmpfs \
printMsg "Running wordcount in $DEMO_IMG_NAME"
docker run --rm --network=dataclay_default \
	-v `pwd`/app/text:/demo/text:ro \
	-v `pwd`/app/cfgfiles/session.extrae.properties:/demo/cfgfiles/session.properties \
    -v `pwd`/trace:/demo/trace:rw \
    $DEMO_IMG_NAME --tracing -Dexec.mainClass="Wordcount" words
popd 

docker rm -f -v ${PWD##*/}-demo-word-gen
    
