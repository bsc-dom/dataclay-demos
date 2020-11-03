#!/bin/sh
set -e
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
docker run --rm --network dataclaynetwork dataclaydemo/city src/create_dkb.py

printMsg "Car creates and federates events "
docker run --rm -e DATACLAY_CITY_IP=$CITY_IP --network dataclaynetwork dataclaydemo/car src/tracker_ekf_nodisplay.py
	
printMsg "City get Events"
docker run --rm --network dataclaynetwork dataclaydemo/city src/retrieve_objects.py
	
