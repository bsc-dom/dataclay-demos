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
for MACHINE in ${MACHINES}; do
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
 	MACHINE_IP=`docker-machine ip dataclay-demo-$MACHINE`
done

# ==================================== DATACLAY START ==================================== #
for MACHINE in ${MACHINES}; do
	echo " ****** Starting dataClay on $MACHINE... ******"
	cd $SCRIPTDIR/$MACHINE/dataclay
	MACHINE_IP=`docker-machine ip dataclay-demo-$MACHINE`
	export LOGICMODULE_HOST=$MACHINE_IP
	export EXPOSED_IP_FOR_CLIENT=$MACHINE_IP
	eval $(docker-machine env dataclay-demo-$MACHINE)
	docker-compose start
	cd "${SCRIPTDIR}"
done 



# ==================================== DEMO ==================================== #

CITY_IP=`docker-machine ip dataclay-demo-city`
CAR_IP=`docker-machine ip dataclay-demo-car`
DATACLAY_PORT=443 #all machines uses same port for dataclay in this demo

echo " #################################### " 
echo " # RUNNING DEMO "
echo " #################################### " 
echo ""

eval $(docker-machine env dataclay-demo-city)
docker run --rm --network=dataclay_default \
		-v /home/docker/cfgfiles/:/home/dataclayusr/dataclay/cfgfiles/:ro \
		-v dataclay_dataclay-certs:/ssl/:ro \
		bscdataclay/client:alpine WaitForDataClayToBeAlive 10 5

eval $(docker-machine env dataclay-demo-car)
docker run --rm --network=dataclay_default \
		-v /home/docker/cfgfiles/:/home/dataclayusr/dataclay/cfgfiles/:ro \
		-v dataclay_dataclay-certs:/ssl/:ro \
		bscdataclay/client:alpine WaitForDataClayToBeAlive 10 5

printMsg "City creates City object"
eval $(docker-machine env dataclay-demo-city)
docker run --rm --network=dataclay_default \
    -v dataclay_dataclay-certs:/ssl/:ro \
    dataclaydemos/city src/create_city.py

printMsg "Car arrives to the city and federate events"
eval $(docker-machine env dataclay-demo-car)
docker run --rm --network=dataclay_default \
     -e DATACLAY2_ADDR="$CITY_IP:$DATACLAY_PORT" \
     -v dataclay_dataclay-certs:/ssl/:ro \
     dataclaydemos/car src/generate_events.py

printMsg "City get Events"
eval $(docker-machine env dataclay-demo-city)
docker run --rm --network=dataclay_default \
     -v dataclay_dataclay-certs:/ssl/:ro \
     dataclaydemos/city src/get_events.py

printMsg "Car leaves the city and unfederates events"
eval $(docker-machine env dataclay-demo-car)
docker run --rm --network=dataclay_default \
     -e DATACLAY2_ADDR="$CITY_IP:$DATACLAY_PORT" \
     -v dataclay_dataclay-certs:/ssl/:ro \
     dataclaydemos/car src/unfederate.py

printMsg "City get Events"
eval $(docker-machine env dataclay-demo-city)
docker run --rm --network=dataclay_default \
     -v dataclay_dataclay-certs:/ssl/:ro \
     dataclaydemos/city src/get_events.py

# ==================================== DATACLAY DOWN ==================================== #
for MACHINE in ${MACHINES}; do
	echo " ****** Finishing dataClay on $MACHINE... ******"
	cd $SCRIPTDIR/$MACHINE/dataclay
	MACHINE_IP=`docker-machine ip dataclay-demo-$MACHINE`
	export LOGICMODULE_HOST=$MACHINE_IP
	export EXPOSED_IP_FOR_CLIENT=$MACHINE_IP
	eval $(docker-machine env dataclay-demo-$MACHINE)
	#docker-compose stop
	cd "${SCRIPTDIR}"
done