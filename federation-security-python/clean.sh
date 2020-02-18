#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
IFS=$'\r\n' GLOBIGNORE='*' command eval  "MACHINES=($(cat $SCRIPTDIR/machines.txt))"
for MACHINE in ${MACHINES[@]}; do
		echo "Removing machine $MACHINE..."
		docker-machine rm $MACHINE	
done
echo "Done!"