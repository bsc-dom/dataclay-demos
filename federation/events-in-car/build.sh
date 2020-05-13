#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
MODELDIR="$SCRIPTDIR/model"

# Build and start dataClay
pushd $MODELDIR/dataclay
docker-compose kill 
docker-compose down -v #sanity check
docker-compose up -d
popd

### BUILD ####
docker build --network=dataclay_default \
	--build-arg CACHEBUST=$(date +%s) \
	-t dataclaydemo/client .			

pushd $SCRIPTDIR/app
docker build --network=dataclay_default \
	-f host.Dockerfile \
	--build-arg DATACLAY_HOSTNAME=city \
	-t dataclaydemo/city .	
docker build --network=dataclay_default \
	-f host.Dockerfile \
	--build-arg DATACLAY_HOSTNAME=car \
	-t dataclaydemo/car .	
popd
	
echo " ===== Retrieving execution classes into $MODELDIR/deploy  ====="
# Copy execClasses from dsjava docker
rm -rf $MODELDIR/deploy
mkdir -p $MODELDIR/deploy
docker cp dataclay_dspython_1:/home/dataclayusr/dataclay/deploy/ $MODELDIR

echo " ===== Retrieving SQLITE LM into $MODELDIR/LM.sqlite  ====="
rm -f $MODELDIR/LM.sqlite
TABLES="account credential contract interface ifaceincontract opimplementations datacontract dataset accessedimpl accessedprop type java_type python_type memoryfeature cpufeature langfeature archfeature prefetchinginfo implementation python_implementation java_implementation annotation property java_property python_property operation java_operation python_operation metaclass java_metaclass python_metaclass namespace"
for table in $TABLES;
do
	docker exec -t dataclay_logicmodule_1 sqlite3 "//dataclay/storage/LM" ".dump $table" >> $MODELDIR/LM.sqlite
done

echo " ===== Stopping dataClay ====="
pushd $MODELDIR/dataclay
docker-compose -f docker-compose.yml down -v
popd

pushd $MODELDIR

echo " ===== Building docker dataclaydemo/logicmodule  ====="
docker build -f demo.LM.Dockerfile -t dataclaydemo/dataclay-logicmodule .

echo " ===== Building docker dataclaydemo/dsjava  ====="
docker tag bscdataclay/dsjava:2.4.dev dataclaydemo/dataclay-dsjava

echo " ===== Building docker dataclaydemo/dspython ====="
docker build -f demo.EE.Dockerfile -t dataclaydemo/dataclay-dspython .

popd
