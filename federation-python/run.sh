#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
IFS=$'\r\n' GLOBIGNORE='*' command eval  "MACHINES=($(cat $SCRIPTDIR/machines.txt))"
#-----------------------------------------------------------------------
# Helper functions (miscellaneous)
#-----------------------------------------------------------------------
cyan=$'\e[1;36m'; end=$'\e[0m'; blu=$'\e[1;34m';
function printMsg { echo "\n  ${cyan}[Demo step $1]${end} \n  ${blu}$2${end} \n"; }

#-----------------------------------------------------------------------
# MAIN
#-----------------------------------------------------------------------
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
	docker-machine scp -r $SCRIPTDIR/hosts/common $MACHINE:~/
	eval $(docker-machine env $MACHINE)
	docker-compose down
	docker-compose up -d
	popd
done 

# ==================================== DEMO ==================================== #

CITTA_IP=${MACHINES_IPS[citta]}
CAMERA_IP=${MACHINES_IPS[camera]}
FERMATA_IP=${MACHINES_IPS[fermata]}
SEMAFORO_IP=${MACHINES_IPS[semaforo]}
TRAM_IP=${MACHINES_IPS[tram]}
DATACLAY_PORT=11034 #all machines uses same port for dataclay in this demo
TRAM_NAME=florence2025
FERMATA_NAME=pontevecchio
CAMERA_NAME=pontevecchio-camera-left
SEMAFORO_NAME=pontevecchio-semaforo-left

echo " #################################### " 
echo " # RUNNING DEMO "
echo " #################################### " 
echo ""

eval $(docker-machine env citta)
docker run --network=dataclay_default \
		-v /home/docker/common/cfgfiles/:/home/dataclayusr/dataclay/cfgfiles/:ro \
		bscdataclay/client WaitForDataClayToBeAlive 10 5 

eval $(docker-machine env camera)
docker run --network=dataclay_default \
		-v /home/docker/common/cfgfiles/:/home/dataclayusr/dataclay/cfgfiles/:ro \
		bscdataclay/client WaitForDataClayToBeAlive 10 5 
		
eval $(docker-machine env fermata)
docker run --network=dataclay_default \
		-v /home/docker/common/cfgfiles/:/home/dataclayusr/dataclay/cfgfiles/:ro \
		bscdataclay/client WaitForDataClayToBeAlive 10 5 

eval $(docker-machine env semaforo)
docker run --network=dataclay_default \
		-v /home/docker/common/cfgfiles/:/home/dataclayusr/dataclay/cfgfiles/:ro \
		bscdataclay/client WaitForDataClayToBeAlive 10 5 
		
eval $(docker-machine env tram)
docker run --network=dataclay_default \
		-v /home/docker/common/cfgfiles/:/home/dataclayusr/dataclay/cfgfiles/:ro \
		bscdataclay/client WaitForDataClayToBeAlive 10 5 

	
printMsg "1" "Citta creates and stores CittyInfo object named citta in its dataClay instance"
echo "NOTE: it may take a while waiting for dataclay to be alive"
eval $(docker-machine env citta)
docker run --network=dataclay_default dataclaydemo/citta src/citta.py register_city

printMsg "2" "Citta creates and stores TramSystem object named tram-system in its dataClay instance"
eval $(docker-machine env citta)
docker run --network=dataclay_default dataclaydemo/citta src/citta.py register_tram_system

printMsg "3" "Tram creates and stores TramInfo object named florence2025 in its dataClay instance. 
Note that this object also contains TramDynamicInfo and Position objects." 
printMsg "4"  "Tram federates object named florence2025 to Citta using Citta's IP and dataClay port"
printMsg "5" "Citta receives TramInfo object and adds it to the list of trams in TramSystem 
using the when_federated method defined in TramInfo class (see data model)"

eval $(docker-machine env tram)
docker run --network=dataclay_default dataclaydemo/tram src/tram.py register_tram $TRAM_NAME $CITTA_IP $DATACLAY_PORT


printMsg "6" "Fermata creates and stores FermataInfo object named pontevecchio in its dataClay instance"
printMsg "7" "Fermata federates object named pontevecchio to Citta using Citta's IP and dataClay port"
printMsg "8" "Citta receives FermataInfo object and adds it to the list of fermatas in Citta using the
when_federated method defined in FermataInfo class (see data model)"
 
eval $(docker-machine env fermata)
docker run --network=dataclay_default dataclaydemo/fermata src/fermata.py register_fermata $FERMATA_NAME $CITTA_IP $DATACLAY_PORT

printMsg "9" "Citta prints all fermatas and trams available"

eval $(docker-machine env citta)
docker run --network=dataclay_default dataclaydemo/citta src/citta.py print_city_info
docker run --network=dataclay_default dataclaydemo/citta src/citta.py print_tram_system_info

printMsg "10" "Camera creates and stores CameraInfo object named pontevecchio-camera-left 
in its dataClay instance"
printMsg "11" "Camera federates CameraInfo object named pontevecchio-camera-left to Fermata
using Fermata's IP and dataClay port"
printMsg "12" "Fermata receives CameraInfo object and adds it to the list of cameras in Fermata 
using the when_federated method defined in CameraInfo class (see data model)"

eval $(docker-machine env camera)
docker run --network=dataclay_default dataclaydemo/camera src/camera.py register_camera $CAMERA_NAME $FERMATA_NAME $FERMATA_IP $DATACLAY_PORT

printMsg "13" "Semaforo creates and stores SemaforoInfo object named pontevecchio-semaforo-left in its 
 dataClay instance"
printMsg "14" "Semaforo federates SemaforoInfo object named pontevecchio-semaforo-left to Fermata
using Fermata's IP and dataClay port"
printMsg "15" "Fermata receives SemaforoInfo object and adds it to the list of semaforos in Fermata using
the when_federated method defined in SemaforoInfo class (see data model)" 
 
eval $(docker-machine env semaforo)
docker run --network=dataclay_default dataclaydemo/semaforo src/semaforo.py register_semaforo $SEMAFORO_NAME $FERMATA_NAME $FERMATA_IP $DATACLAY_PORT

printMsg "16" "Tram is approaching to pontevecchio Fermata and federates 
its TramDynamicInfo (only the dynamic information) to Fermata using Fermata's IP and dataClay port"
printMsg "17" "Fermata receives TramDynamicInfo object and adds it to the list of trams
in Fermata using the when_federated method defined in TramDynamicInfo class (see data model)"

eval $(docker-machine env tram)
docker run --network=dataclay_default dataclaydemo/tram src/tram.py approach_to_fermata $TRAM_NAME $FERMATA_NAME $FERMATA_IP $DATACLAY_PORT
eval $(docker-machine env fermata)
docker run --network=dataclay_default dataclaydemo/fermata src/fermata.py print_fermata $FERMATA_NAME 

printMsg "18" "An ambulance is arriving from the left side of the fermata and the Camera detects it."
printMsg "19" "Camera updates the information in CameraInfo. This information is automatically synchronized
with the Fermata"  

eval $(docker-machine env camera)
docker run --network=dataclay_default dataclaydemo/camera src/camera.py set_ambulances $CAMERA_NAME 1

printMsg "20" "Fermata checks if tram must stop due to the presence of an ambulance"
printMsg "21" "Fermata updates SemaforoInfo object to color RED. This information is automatically synchronized
with the Semaforo"
 
eval $(docker-machine env fermata)
docker run --network=dataclay_default dataclaydemo/fermata src/fermata.py priorize_ambulances $FERMATA_NAME 

printMsg "22" "Semaforo checks the color of the light and set it to red." 
eval $(docker-machine env semaforo)
docker run --network=dataclay_default dataclaydemo/semaforo src/semaforo.py print_color $SEMAFORO_NAME


printMsg "23" "The ambulance is not visible anymore from the camera"
printMsg "24" "Camera updates the information in CameraInfo. This information is automatically synchronized
with the Fermata"

eval $(docker-machine env camera)
docker run --network=dataclay_default dataclaydemo/camera src/camera.py set_ambulances $CAMERA_NAME 0

printMsg "25" "Fermata checks if tram must stop due to the presence of an ambulance"
printMsg "26" "Fermata updates SemaforoInfo object to color GREEN. This information is automatically synchronized 
with the Semaforo "

eval $(docker-machine env fermata)
docker run --network=dataclay_default dataclaydemo/fermata src/fermata.py priorize_ambulances $FERMATA_NAME 

printMsg "27" "Semaforo checks the color of the light and set it to green. "

eval $(docker-machine env semaforo)
docker run --network=dataclay_default dataclaydemo/semaforo src/semaforo.py print_color $SEMAFORO_NAME

printMsg "28" "Tram leaves pontevecchio and unfederates the TramDynamicInfo with the Fermata."

eval $(docker-machine env tram)
docker run --network=dataclay_default dataclaydemo/tram src/tram.py leave_fermata $TRAM_NAME $FERMATA_NAME $FERMATA_IP $DATACLAY_PORT

printMsg "29" "Fermata removes the tram in Fermata using the when_unfederated method defined in TramDynamicInfo
 class (see data model) "
 
eval $(docker-machine env fermata)
docker run --network=dataclay_default dataclaydemo/fermata src/fermata.py print_fermata $FERMATA_NAME 

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
