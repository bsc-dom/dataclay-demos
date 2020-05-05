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

printMsg "Running demo"
# Word count
# Modify session configuration to add flag Tracing=True and mount trace volume to collect traces once done
docker run --rm --network=dataclay_default \
	-v `pwd`/app/cfgfiles/session.extrae.properties:/demo/cfgfiles/session.properties \
	-v `pwd`/dataclay/extrae/extrae_config.xml:/home/dataclayusr/dataclay/extrae/extrae_basic.xml \
    -v `pwd`/trace:/demo/trace:rw \
    $DEMO_IMG_NAME src/wordcount.py --tracing
popd

