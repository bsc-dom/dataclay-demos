#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
grn=$'\e[1;32m'
blu=$'\e[1;34m'
red=$'\e[1;91m'
end=$'\e[0m'
function printError { 
  echo "${red}======== $1 ========${end}"
}
function printMsg { 
  echo "${grn}======== $1 ========${end}"
}

pushd $SCRIPTDIR
DEMO_IMG_NAME=bscdataclay/${PWD##*/}-demo
NEWVERSION_IMG_NAME=bscdataclay/${PWD##*/}-newversion-demo

uuid=$(uuidgen)
CREATE_PERSON_DOCKER_NAME=create_person_$uuid
NEW_VERSION_DOCKER_NAME=new_version_$uuid

sleep 5

printMsg "Creating person and getting IDs"
docker run --name $CREATE_PERSON_DOCKER_NAME --network=dataclay_default \
	-e PYTHONUNBUFFERED=1 \
    $DEMO_IMG_NAME src/create_person.py martin 33
docker logs $CREATE_PERSON_DOCKER_NAME > logs.txt
OBJECT_ID=$(cat logs.txt | grep "Object ID:" | awk '{print $3}')
VERSION_BACKEND=$(cat logs.txt | grep "Version backend:" | awk '{print $3}')

echo "$blu ** Obtained id : $OBJECT_ID $end"
echo "$blu ** Going to created version in backend $VERSION_BACKEND $end"

printMsg "Creating version"
docker run --name $NEW_VERSION_DOCKER_NAME --network=dataclay_default \
	 $NEWVERSION_IMG_NAME -Dexec.mainClass="app.NewVersion" --debug $OBJECT_ID $VERSION_BACKEND
docker logs $NEW_VERSION_DOCKER_NAME > logs.txt
VERSION_ID=$(cat logs.txt | grep "Version ID:" | awk '{print $3}')
echo "$blu ** Version id : $VERSION_ID $end"

printMsg "Checking version"
docker run --rm --network=dataclay_default \
	-e PYTHONUNBUFFERED=1 \
    $DEMO_IMG_NAME src/check_version.py $VERSION_ID martin 33

docker rm $CREATE_PERSON_DOCKER_NAME
docker rm $NEW_VERSION_DOCKER_NAME   
    
if [ $? -ne 0 ]; then printError "DEMO FAILED"; exit 1; fi
    
popd 
    