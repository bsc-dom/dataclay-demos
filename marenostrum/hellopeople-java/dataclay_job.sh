#!/bin/bash
#SBATCH --job-name=singularityCompose
#SBATCH --output=job.out
#SBATCH --error=job.out
#SBATCH --nodes=3
#SBATCH --time=00:10:00
#SBATCH --qos=debug
#SBATCH --exclusive 
##########################################
# Configurations
export DEBUG=False
NETWORK_SUFFIX=""

if [ -z $DATACLAY_HOME ]; then 
	echo "ERROR: DATACLAY_HOME not set. Aborting."
	exit 1
fi
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
dataclayprepare $(pwd)/model/src model java

# Run app 
# javaclay <app src> <main> <args>
javaclay $(pwd)/app app.HelloPeople forthepeople martin 33

# Stop dataClay 
dataclaysrv stop

echo $'\e[1;32m' "DEMO SUCCESSFULLY FINISHED!" $'\e[0m'
