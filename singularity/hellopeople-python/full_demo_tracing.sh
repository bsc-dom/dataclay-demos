#!/bin/bash -e 

# Configurations
if [ -z $DATACLAY_HOME ]; then 
	echo "ERROR: DATACLAY_HOME not set. Aborting."
	exit 1
fi
export PATH=$DATACLAY_HOME/bin:$PATH 

# sanity check
rm -rf trace

# Deploy dataClay
dataclaysrv start --tracing

# Register accounts, model and store stubs in client node
dataclayprepare $(pwd)/model/src $(pwd)/app/src DemoNS python

# Run app 
# pyclay <main> <args>
pyclay src/hellopeople.py --tracing forthepeople martin 33

# Stop dataClay 
dataclaysrv stop

echo $'\e[1;32m' "DEMO SUCCESSFULLY FINISHED!" $'\e[0m'

