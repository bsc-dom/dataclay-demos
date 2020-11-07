#!/bin/bash
#SBATCH --job-name=dataclaydemo
#SBATCH --output=job.out
#SBATCH --error=job.out
#SBATCH --nodes=3
#SBATCH --time=00:10:00
#SBATCH --exclusive 
##########################################
# Configurations
NETWORK_SUFFIX="-ib0"
module load DATACLAY/develop/develop

# --- SLURM ---- 
JOB_HOSTS=$(scontrol show hostname $SBATCH_JOB_NODELIST)
# Get hosts and add infiniband suffix if needed
for HOST in $JOB_HOSTS; do
        HOSTS="$HOSTS ${HOST}${NETWORK_SUFFIX}"
done
export DATACLAY_JOBID=$SLURM_JOBID
# -------------- 
# Run demo 

# Deploy dataClay
dataclaysrv start --hosts "$HOSTS" --python-ee-per-node 0 $EXTRA_ARGS

# Register accounts, model and store stubs in client node
dataclayprepare $(pwd)/model/src $(pwd)/app model java

# Run app 
# javaclay <main> <args>
javaclay app.HelloPeople forthepeople martin 33 $EXTRA_ARGS

# Stop dataClay 
dataclaysrv stop

echo $'\e[1;32m' "DEMO SUCCESSFULLY FINISHED!" $'\e[0m'
