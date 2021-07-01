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

docker-machine scp -r $SCRIPTDIR/city/cfgfiles dataclay-demo-city:~/cfgfiles
docker-machine scp -r $SCRIPTDIR/car/cfgfiles dataclay-demo-car:~/cfgfiles
docker-machine scp -r $SCRIPTDIR/city/dataclay dataclay-demo-city:~/dataclay
docker-machine scp -r $SCRIPTDIR/car/dataclay dataclay-demo-car:~/dataclay

# IPs
CERTIFICATE_AUTHORITY_IP=`docker-machine ip dataclay-demo-authority`
CITY_IP=`docker-machine ip dataclay-demo-city`
CAR_IP=`docker-machine ip dataclay-demo-car`

# Build certificate authority
cd $SCRIPTDIR/authority
eval $(docker-machine env dataclay-demo-authority)
docker-compose kill
docker-compose down -v #sanity check
docker-compose up -d
# Wait for authority to be up and running
sleep 5

# Build CITY
printMsg "Starting dataClay in City"
cd $SCRIPTDIR/city/dataclay
eval $(docker-machine env dataclay-demo-city)
export LOGICMODULE_HOST=$CITY_IP
export EXPOSED_IP_FOR_CLIENT=$CITY_IP
export CERTIFICATE_AUTHORITY_HOST=$CERTIFICATE_AUTHORITY_IP
docker-compose kill
docker-compose down -v #sanity check
docker-compose pull
docker-compose up -d

cd $SCRIPTDIR/city/
docker build --rm --network=dataclay_default --no-cache \
    --build-arg CERTIFICATE_AUTHORITY_HOST=$CERTIFICATE_AUTHORITY_HOST \
		-t dataclaydemos/city .

# Build Car
printMsg "Starting dataClay in Car"
cd $SCRIPTDIR/car/dataclay
eval $(docker-machine env dataclay-demo-car)
export LOGICMODULE_HOST=$CAR_IP
export EXPOSED_IP_FOR_CLIENT=$CAR_IP
export CERTIFICATE_AUTHORITY_HOST=$CERTIFICATE_AUTHORITY_IP
docker-compose kill
docker-compose down -v #sanity check
docker-compose pull
docker-compose up -d

cd $SCRIPTDIR/car/
docker build --rm --network=dataclay_default --no-cache \
    --build-arg CERTIFICATE_AUTHORITY_HOST=$CERTIFICATE_AUTHORITY_HOST \
    --build-arg EXTERNAL_DATACLAY_HOST=$CITY_IP \
    --build-arg EXTERNAL_DATACLAY_PORT=443 \
		-t dataclaydemos/car .
cd "${SCRIPTDIR}"

printMsg "Stopping dataClay in city"
eval $(docker-machine env dataclay-demo-city)
cd $SCRIPTDIR/city/dataclay
#docker-compose stop
docker images

printMsg "Stopping dataClay in car"
eval $(docker-machine env dataclay-demo-car)
cd $SCRIPTDIR/car/dataclay
#docker-compose stop
docker images
cd "${SCRIPTDIR}"

echo "Done!"

