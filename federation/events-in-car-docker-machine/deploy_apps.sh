#!/bin/sh
set -e
SCRIPTDIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
echo " == Starting dataClay in City =="
cd $SCRIPTDIR/city/dataclay
eval $(docker-machine env dataclay-demo-city)
CITY_IP=`docker-machine ip dataclay-demo-city`
export LOGICMODULE_HOST=$CITY_IP
export EXPOSED_IP_FOR_CLIENT=$CITY_IP
docker-compose kill
docker-compose down -v #sanity check
docker-compose up -d #Starting dockers to get stubs

# Build
cd $SCRIPTDIR/city/
docker build --network=dataclay_default --no-cache \
		-t dataclaydemo/city .

echo " == Starting dataClay in Car =="

cd $SCRIPTDIR/car/dataclay
eval $(docker-machine env dataclay-demo-car)
CAR_IP=`docker-machine ip dataclay-demo-car`
export LOGICMODULE_HOST=$CAR_IP
export EXPOSED_IP_FOR_CLIENT=$CAR_IP
docker-compose kill
docker-compose down -v #sanity check
docker-compose up -d #Starting dockers to get stubs


# Build
cd $SCRIPTDIR/car/
docker build --network=dataclay_default --no-cache \
    --build-arg EXTERNAL_DATACLAY_HOST=$CITY_IP \
		-t dataclaydemo/car .


echo " == Stopping dataClay in city  =="
eval $(docker-machine env dataclay-demo-city)
cd $SCRIPTDIR/city/dataclay
docker-compose stop
docker images


echo " == Stopping dataClay in car  =="
eval $(docker-machine env dataclay-demo-car)
cd $SCRIPTDIR/car/dataclay
docker-compose stop
docker images

cd $SCRIPTDIR

echo "Done!"

