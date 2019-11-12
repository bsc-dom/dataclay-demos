#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
IFS=$'\r\n' GLOBIGNORE='*' command eval  "MACHINES=($(cat $SCRIPTDIR/machines.txt))"
for MACHINE in ${MACHINES[@]}; do
	echo " ======================= Building $MACHINE application ======================="

	eval $(docker-machine env $MACHINE)
	# copy dataclay configurations
	docker-machine ssh $MACHINE -f 'rm -rf dataclay' #sanity check
	docker-machine scp -r $SCRIPTDIR/dataclay/ $MACHINE:~/ # log42j.xml and global.properties files
	
	pushd $SCRIPTDIR/dataclay
	MACHINE_IP=`docker-machine ip $MACHINE`
	export LOGICMODULE_HOST=$MACHINE_IP
	export EXPOSED_IP_FOR_CLIENT=$MACHINE_IP
	docker-compose kill
	docker-compose down -v #sanity check
	docker-compose up -d #Starting dockers to get stubs
	popd 

	# Build
	pushd $SCRIPTDIR/app/
	docker build --network=dataclay_default \
		--build-arg APP_NAME=${MACHINE} \
		--build-arg CACHEBUST=$(date +%s) \
		-t dataclaydemo/$MACHINE .
	popd 
	
	pushd $SCRIPTDIR/dataclay
	docker-compose down
	popd
	
done

echo "Done!"

