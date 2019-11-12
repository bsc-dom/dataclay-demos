#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
IFS=$'\r\n' GLOBIGNORE='*' command eval  "MACHINES=($(cat $SCRIPTDIR/machines.txt))"
grn=$'\e[1;32m'
blu=$'\e[1;34m'
end=$'\e[0m'

function printMsg { 
  printf " \n\n  ${grn}[Demo step $1]${end} \n  ${blu}$2${end} \n\n\n"
}

# ==================================== REQUIREMENTS CHECK ==================================== #

declare -A MACHINES_IPS
# Check if docker machines exist 
for MACHINE in ${MACHINES[@]}; do
	printf "Checking if $MACHINE docker machine exists... "
	if docker-machine ls -q | grep -q $MACHINE; then
		printf "OK\n"
	else
		printf "ERROR: Not found\n"
		echo "Please make sure to call create_machines.sh script"
		exit -1
	fi
	printf "Checking if $MACHINE docker machine is running... "
	if docker-machine ls | grep $MACHINE | grep -q "Stopped"; then
		printf "Restarting...\n"
		docker-machine restart $MACHINE
	else
		printf "OK\n"
	fi
 	MACHINE_IP=`docker-machine ip $MACHINE`
	MACHINES_IPS+=([${MACHINE}]=${MACHINE_IP})
done 

echo "Machine ips: ${MACHINES_IPS[@]}"

# ==================================== DATACLAY START ==================================== #
for MACHINE in ${MACHINES[@]}; do
	echo " ****** Starting dataClay on $MACHINE... ******"
	pushd $SCRIPTDIR/hosts/common/dataclay
	MACHINE_IP=${MACHINES_IPS[$MACHINE]}
	export LOGICMODULE_HOST=$MACHINE_IP
	export EXPOSED_IP_FOR_CLIENT=$MACHINE_IP
	eval $(docker-machine env $MACHINE)
	docker-compose kill
	docker-compose down -v
	docker-compose up -d
	popd
done 



# ==================================== DEMO ==================================== #

CITY_IP=${MACHINES_IPS[city]}
CAR_IP=${MACHINES_IPS[car]}
DATACLAY_PORT=11034 #all machines uses same port for dataclay in this demo

echo " #################################### " 
echo " # RUNNING DEMO "
echo " #################################### " 
echo ""


printMsg "1" "City creates City object"
eval $(docker-machine env city)
docker run --network=dataclay_default dataclaydemo/city src/create_city.py

printMsg "2" "Car arrives to the city and federate events"
eval $(docker-machine env car)
docker run --network=dataclay_default dataclaydemo/car src/generate_events.py

printMsg "3" "City get Events"
eval $(docker-machine env city)
docker run --network=dataclay_default dataclaydemo/city src/get_events.py

printMsg "4" "Car leaves the city and unfederates events"
eval $(docker-machine env car)
docker run --network=dataclay_default dataclaydemo/car src/unfederate.py

printMsg "5" "City get Events"
eval $(docker-machine env city)
docker run --network=dataclay_default dataclaydemo/city src/get_events.py

# ==================================== DATACLAY STOP ==================================== #
for MACHINE in ${MACHINES[@]}; do
	echo " ****** Finishing dataClay on $MACHINE... ******"
	pushd $SCRIPTDIR/hosts/common/dataclay
	MACHINE_IP=${MACHINES_IPS[$MACHINE]}
	export LOGICMODULE_HOST=$MACHINE_IP
	export EXPOSED_IP_FOR_CLIENT=$MACHINE_IP
	eval $(docker-machine env $MACHINE)
	docker-compose down
	popd
done 