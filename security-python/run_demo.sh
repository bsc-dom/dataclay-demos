#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

$SCRIPTDIR/check_requirements.sh
$SCRIPTDIR/create_machines.sh
$SCRIPTDIR/build.sh
$SCRIPTDIR/deploy_model.sh
$SCRIPTDIR/deploy_apps.sh
$SCRIPTDIR/run.sh
