#!/bin/bash
#SBATCH --job-name=singularityCompose
#SBATCH --output=job.out
#SBATCH --error=job.out
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
STUBSPATH=./stubs
MODELBINPATH=./model/src
export DEBUG=True

python --version 
echo $PYTHONPATH
which python

# Get hosts
JOBHOSTS=`scontrol show hostname $SBATCH_JOB_NODELIST`

# Deploy dataClay
$DATACLAY_HOME/start_dataclay.sh $JOBHOSTS

# Register account  
$DATACLAYCMD_SINGULARITY NewAccount $USER $PASS

# Register datacontract
$DATACLAYCMD_SINGULARITY NewDataContract ${USER} ${PASS} ${DATASET} ${USER}

# Register model
$DATACLAYCMD_SINGULARITY NewModel ${USER} ${PASS} ${NAMESPACE} ${MODELBINPATH} python

# Get stubs 
mkdir -p ${STUBSPATH}
$DATACLAYCMD_SINGULARITY GetStubs ${USER} ${PASS} ${NAMESPACE} ${STUBSPATH}

# Run app 
python src/hellopeople.py forthepeople martin 33 

# Stop dataClay 

# Clean dataClay 


echo "Demo finished!"
