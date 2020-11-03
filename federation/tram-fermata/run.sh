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
FERMATA_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' fermata-logicmodule)
TRAM_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' tram-logicmodule)
FERMATA_PORT=11034
TRAM_PORT=21034
TRAM_NAME=florence2025
FERMATA_NAME=pontevecchio


echo " #################################### " 
echo " # RUNNING DEMO "
echo " #################################### " 
echo ""

printMsg "Fermata IP is $FERMATA_IP" 
printMsg "Tram IP is $TRAM_IP" 

printMsg "Tram creates and stores Tram object named florence2025 in its dataClay instance" 
docker run --rm --network dataclaynetwork dataclaydemo/tram \
	src/tram.py register_tram $TRAM_NAME

printMsg "Fermata creates and stores Fermata object named pontevecchio in its dataClay instance"
docker run --rm --network dataclaynetwork dataclaydemo/fermata \
	src/fermata.py register_fermata $FERMATA_NAME

printMsg "Tram is approaching to pontevecchio Fermata and federates 
its Tram object to Fermata using Fermata's IP and dataClay port"
docker run --rm --network dataclaynetwork dataclaydemo/tram \
	src/tram.py approach_to_fermata $TRAM_NAME $FERMATA_NAME $FERMATA_IP $FERMATA_PORT

printMsg "Fermata receives Tram object and adds it to the list of trams in Fermata using \
the when_federated method defined in Tram class (see data model)"
docker run --rm --network dataclaynetwork dataclaydemo/fermata \
	src/fermata.py print_fermata $FERMATA_NAME

printMsg "An ambulance is arriving from the left side of the fermata and the Camera detects it. \
Camera updates the information in CameraInFermata object which is referenced by Fermata object"  
docker run --rm --network dataclaynetwork dataclaydemo/fermata \
	src/fermata.py set_ambulances $FERMATA_NAME 1

printMsg "Fermata checks if tram must stop due to the presence of an ambulance. One ambulance was found! \
Fermata updates SemaforoInFermata object to color RED."
docker run --rm --network dataclaynetwork dataclaydemo/fermata \
	src/fermata.py priorize_ambulances $FERMATA_NAME

printMsg "The ambulance is not visible anymore from the camera. Camera updates the information in CameraInFermata"
docker run --rm --network dataclaynetwork dataclaydemo/fermata \
	src/fermata.py set_ambulances $FERMATA_NAME 0

printMsg "Fermata checks if tram must stop due to the presence of an ambulance. Fermata updates \
SemaforoInFermata object to color GREEN."
docker run --rm --network dataclaynetwork dataclaydemo/fermata \
	src/fermata.py priorize_ambulances $FERMATA_NAME

printMsg "Tram leaves pontevecchio and unfederates the Tram object with the Fermata."
docker run --rm --network dataclaynetwork dataclaydemo/tram \
	src/tram.py leave_fermata $TRAM_NAME $FERMATA_NAME $FERMATA_IP $FERMATA_PORT

printMsg "Fermata removes the tram in Fermata object using the when_unfederated method defined in Tram class (see data model) "
docker run --rm --network dataclaynetwork dataclaydemo/fermata \
	src/fermata.py print_fermata $FERMATA_NAME
	
