#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
IFS=$'\r\n' GLOBIGNORE='*' command eval  "MACHINES=($(cat $SCRIPTDIR/machines.txt))"
for MACHINE in ${MACHINES[@]}; do
	if [[  $(docker-machine ls | grep $MACHINE) ]]; then
		echo "$MACHINE exists. Checking if it is running..."
		if docker-machine ls | grep $MACHINE | grep -q "Stopped"; then
			printf "Starting...\n"
			docker-machine start $MACHINE
			echo "Regenerating certs..."
			docker-machine regenerate-certs -f $MACHINE
		else
			printf "OK\n"
		fi
	else
		echo "Creating new $MACHINE..."
		docker-machine create --driver virtualbox $MACHINE
	fi
done
echo "Done!"

