#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#-----------------------------------------------------------------------
# Helper functions (miscellaneous)
#-----------------------------------------------------------------------
cyan=$'\e[1;36m'; end=$'\e[0m'; blu=$'\e[1;34m';
function printMsg { echo "${cyan}$1${end}"; }

#-----------------------------------------------------------------------
# MAIN
#-----------------------------------------------------------------------
CITY_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' city-logicmodule)
CAR_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' car-logicmodule)
CITY_PORT=11034
CAR_PORT=21034

echo " #################################### " 
echo " # RUNNING DEMO "
echo " #################################### " 
echo ""

printMsg "City IP is $CITY_IP" 
printMsg "Car IP is $CAR_IP" 

printMsg "City creates DKB"
docker run --rm --network dataclaynetwork dataclaydemo/city \
	city/src/create_dkb.py


printMsg "Car creates and federates events "
docker run --rm -e DATACLAY_CITY_IP=$CITY_IP --network dataclaynetwork dataclaydemo/car \
	car/src/tracker_ekf_nodisplay.py
	
printMsg "City get Events"
docker run --rm --network dataclaynetwork dataclaydemo/city \
	city/src/retrieve_objects.py
	
