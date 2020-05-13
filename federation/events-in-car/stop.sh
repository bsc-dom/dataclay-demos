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

if [ "$#" -ne 1 ] ; then
	echo "ERROR: usage: $0 <fermata|tram> "
	exit 1
fi

HOSTNAME=$1

printMsg "Stopping dataClay at $HOSTNAME"
echo "Optional commands=$COMMAND_OPTS"
export COMMAND_OPTS=$COMMAND_OPTS

pushd $SCRIPTDIR/dataclay_$HOSTNAME
# first stop all dataclay services that are not logicmodule

# IMPORTANT: docker-compose stop will send a SIGTERM to ask dataClay to gracefully stop first, and then wait 5 minutes to 
# send a SIGKILL to kill dataClay. It is very importat to do a graceful stop of dataClay to make sure that all 
# objects created are flushed!!! 

# IMPORTANT: First we should stop all python services, always in the following order 1.python - 2.java - 3.logicmodule 
for SERVICE in $(docker-compose ps --all --services | grep python)
do
	STARTTIME=$(date +%s)
	docker-compose stop $SERVICE
	ENDTIME=$(date +%s)
	echo "$SERVICE stopped in $(($ENDTIME - $STARTTIME)) seconds"
done
# IMPORTANT: Now all java services
for SERVICE in $(docker-compose ps --all --services | grep java)
do
	STARTTIME=$(date +%s)
	docker-compose stop $SERVICE
	ENDTIME=$(date +%s)
	echo "$SERVICE stopped in $(($ENDTIME - $STARTTIME)) seconds"
done

# IMPORTANT: finally Logic module
STARTTIME=$(date +%s)
docker-compose stop logicmodule
ENDTIME=$(date +%s)
echo "logicmodule stopped in $(($ENDTIME - $STARTTIME)) seconds"
popd

docker network rm dataclaynetwork

printMsg "dataClay successfully stopped!"
    