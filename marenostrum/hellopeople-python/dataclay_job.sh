#!/bin/bash
#SBATCH --job-name=singularityCompose
#SBATCH --output=job.out
#SBATCH --error=job.out
#SBATCH --nodes=3
#SBATCH --time=00:10:00
#SBATCH --qos=debug
#SBATCH --exclusive 
##########################################
set -e 

# Configurations
export DEBUG=False
NETWORK_SUFFIX=""

export DATACLAY_HOME=/apps/DATACLAY/2.1
export PATH=$DATACLAY_HOME/bin:$PATH 

# --- SLURM ---- 
JOB_HOSTS=$(scontrol show hostname $SBATCH_JOB_NODELIST)
# Get hosts and add infiniband suffix if needed
for HOST in $JOB_HOSTS; do
        HOSTS="$HOSTS ${HOST}${NETWORK_SUFFIX}"
done
#export DATACLAY_JOBID=$SLURM_JOBID
# -------------- 
# Run demo 

# Deploy dataClay
dataclaysrv start --hosts "$HOSTS" --prolog marenostrum 

# Register accounts, model and store stubs in client node
dataclayprepare $(pwd)/model/src DemoNS python

# Run app 
# pyclay <app src> <main> <args>
pyclay $(pwd)/app src/hellopeople.py forthepeople martin 33

# Stop dataClay 
dataclaysrv stop

echo $'\e[1;32m' "DEMO SUCCESSFULLY FINISHED!" $'\e[0m'

