#!/bin/bash -e 

# Configurations
if [ -z $DATACLAY_HOME ]; then 
	echo "ERROR: DATACLAY_HOME not set. Aborting."
	exit 1
fi
export PATH=$DATACLAY_HOME/bin:$PATH 

# Deploy dataClay
dataclaysrv start --available-ports "3301 1234 1235"

# Register accounts, model and store stubs in client node
dataclayprepare $(pwd)/model/src $(pwd)/app/src DemoNS python

# Run app 
# pyclay <main> <args>
pyclay src/hellopeople.py forthepeople martin 33

# Change model

# Start again with clean environment
dataclaysrv restart --cleandeploy --available-ports "3301 1234 1235"

# Register accounts, model and store stubs in client node
dataclayprepare $(pwd)/updated-model/src $(pwd)/app/src DemoNS python

# Run app
# pyclay <main> <args>
pyclay src/hellopeople.py forthepeople martin 33

# Stop dataclay
dataclaysrv stop

echo $'\e[1;32m' "DEMO SUCCESSFULLY FINISHED!" $'\e[0m'

