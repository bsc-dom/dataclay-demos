#!/bin/bash -e
# Configurations
if [ -z $DATACLAY_HOME ]; then 
	echo "ERROR: DATACLAY_HOME not set. Aborting."
	exit 1
fi
export PATH=$DATACLAY_HOME/bin:$PATH 

# Deploy dataClay
dataclaysrv start --debug --python-ee-per-sl 0 # --java-version 8

# Register accounts, model and store stubs in client node
dataclayprepare $(pwd)/model/src $(pwd)/app/src model java

# Run app 
# javaclay <main> <args>
javaclay app.HelloPeople forthepeople martin 33

# Stop dataClay 
dataclaysrv stop

echo $'\e[1;32m' "DEMO SUCCESSFULLY FINISHED!" $'\e[0m'
