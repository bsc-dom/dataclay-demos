#!/bin/sh
set -e
SCRIPTDIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

#-----------------------------------------------------------------------
# Helper functions (miscellaneous)
#-----------------------------------------------------------------------
CONSOLE_CYAN="\033[1m\033[36m"; CONSOLE_NORMAL="\033[0m"
printMsg() {
  printf "${CONSOLE_CYAN}### ${1}${CONSOLE_NORMAL}\n"
}
#-----------------------------------------------------------------------
# MAIN
#-----------------------------------------------------------------------
# ==================================== REQUIREMENTS CHECK ==================================== #

MACHINES="city car"
# Check if docker machines exist
for MACHINE in $MACHINES; do
	printf "Checking if dataclay-demo-$MACHINE docker machine exists... "
	if docker-machine ls -q | grep -q "dataclay-demo-$MACHINE"; then
		printf "OK\n"
	else
		printf "ERROR: Not found\n"
		echo "Please make sure to call create_machines.sh script"
		exit 1
	fi
	printf "Checking if dataclay-demo-$MACHINE docker machine is running... "
	if docker-machine ls | grep "dataclay-demo-$MACHINE" | grep -q "Stopped"; then
		printf "Restarting...\n"
		docker-machine restart "dataclay-demo-$MACHINE"
	else
		printf "OK\n"
	fi
done


# ==================================== DATACLAY START ==================================== #
for MACHINE in $MACHINES; do
	echo " ****** Starting dataClay on $MACHINE... ******"
	cd $SCRIPTDIR/$MACHINE/dataclay
	MACHINE_IP=`docker-machine ip dataclay-demo-$MACHINE`
	export LOGICMODULE_HOST=$MACHINE_IP
	export EXPOSED_IP_FOR_CLIENT=$MACHINE_IP
	docker-machine scp -r $SCRIPTDIR/$MACHINE/cfgfiles dataclay-demo-$MACHINE:~/
	eval $(docker-machine env dataclay-demo-$MACHINE)
	docker-compose up -d
done


# ==================================== DEMO ==================================== #

CITY_IP=`docker-machine ip dataclay-demo-city`
CAR_IP=`docker-machine ip dataclay-demo-car`

echo " #################################### " 
echo " # RUNNING DEMO "
echo " #################################### " 
echo ""

eval $(docker-machine env dataclay-demo-city)
docker run --rm --network=dataclay_default \
    -v /home/docker/cfgfiles/:/home/dataclayusr/dataclay/cfgfiles/:ro \
		bscdataclay/client:develop-slim:develop-alpine:develop-alpine WaitForDataClayToBeAlive 10 5

eval $(docker-machine env dataclay-demo-car)
docker run --rm --network=dataclay_default \
    -v /home/docker/cfgfiles/:/home/dataclayusr/dataclay/cfgfiles/:ro \
		bscdataclay/client:develop-slim:develop-alpine:develop-alpine WaitForDataClayToBeAlive 10 5

printMsg "City creates DKB"
eval $(docker-machine env dataclay-demo-city)
docker run --rm --network=dataclay_default dataclaydemo/city src/create_dkb.py

printMsg "Car creates and federates events "
eval $(docker-machine env dataclay-demo-car)
docker run --rm --network=dataclay_default -e DATACLAY_CITY_IP="$CITY_IP" dataclaydemo/car src/tracker_ekf_nodisplay.py

printMsg "City get Events"
eval $(docker-machine env dataclay-demo-city)
docker run --rm --network=dataclay_default dataclaydemo/city src/retrieve_objects.py

# Unset docker-machine
eval $(docker-machine env --unset)

# ==================================== DATACLAY STOP ==================================== #
for MACHINE in $MACHINES; do
	echo " ****** Finishing dataClay on $MACHINE... ******"
	cd $SCRIPTDIR/$MACHINE/dataclay
	MACHINE_IP=`docker-machine ip dataclay-demo-$MACHINE`
	export LOGICMODULE_HOST=$MACHINE_IP
	export EXPOSED_IP_FOR_CLIENT=$MACHINE_IP
	eval $(docker-machine env dataclay-demo-$MACHINE)
	docker-compose down
done