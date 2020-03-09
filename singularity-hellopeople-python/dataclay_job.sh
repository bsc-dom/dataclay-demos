#!/bin/bash
#SBATCH --job-name=hellopeople-demo
#SBATCH --output=job.out
#SBATCH --error=job.err
#SBATCH --nodes=3
#SBATCH --time=00:15:00
#SBATCH --qos=debug
#SBATCH --exclusive 

######################################## PREPARE ########################################

# Export dataclay client config for dataclaycmd
export DATACLAYCLIENTCONFIG=$HOME/.dataClay/job$SLURM_JOBID/client/cfgfiles/client.properties 

# Load dataClay module
module load DATACLAY/2.1

NAMESPACE=DemoNS
USER=DemoUser
PASS=DemoPass
DATASET=DemoDS
STUBSPATH=./app/stubs
MODELBINPATH=./model/src
export DEBUG=False

# Get hosts
JOBHOSTS=`scontrol show hostname $SBATCH_JOB_NODELIST`

# Deploy dataClay
dataclaysrv start $JOBHOSTS

# Register account  
dataclay NewAccount $USER $PASS

# Register datacontract
dataclay NewDataContract ${USER} ${PASS} ${DATASET} ${USER}

# Register model
dataclay NewModel ${USER} ${PASS} ${NAMESPACE} ${MODELBINPATH} python

# Get stubs 
mkdir -p ${STUBSPATH}
dataclay GetStubs ${USER} ${PASS} ${NAMESPACE} ${STUBSPATH}

# Run app
pushd app 
pyclay src/hellopeople.py forthepeople martin 33 
popd 

# Stop dataClay 

# Clean dataClay

echo $'\e[1;32m' "DEMO SUCCESSFULLY FINISHED!" $'\e[0m'
