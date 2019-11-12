#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
IFS=$'\r\n' GLOBIGNORE='*' command eval  "MACHINES=($(cat $SCRIPTDIR/machines.txt))"

echo " ===== Saving image  dataclaydemo/dataclay-logicmodule  ====="
docker save -o /tmp/demo-dataclay-logicmodule.tar dataclaydemo/dataclay-logicmodule 
echo " ===== Saving image  dataclaydemo/dataclay-dsjava  ====="
docker save -o /tmp/demo-dataclay-dsjava.tar dataclaydemo/dataclay-dsjava 
echo " ===== Saving image  dataclaydemo/dataclay-dspython  ====="
docker save -o /tmp/demo-dataclay-dspython.tar dataclaydemo/dataclay-dspython 
echo " ===== Saving image  bscdataclay/client (used in machine's docker file build) ====="
docker save -o /tmp/dataclay-client.tar bscdataclay/client

for MACHINE in ${MACHINES[@]}; do
	echo " ===== Loading images into $MACHINE ====="
	eval $(docker-machine env $MACHINE)
	docker load -i /tmp/demo-dataclay-logicmodule.tar
	docker load -i /tmp/demo-dataclay-dsjava.tar
	docker load -i /tmp/demo-dataclay-dspython.tar
	docker load -i /tmp/client.tar

done

echo "Done!"

