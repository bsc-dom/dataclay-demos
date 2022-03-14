#!/bin/bash -e
#SBATCH --job-name=dataclaydemo
#SBATCH --output=job-%A-%a.out
#SBATCH --error=job-%A-%a.out
#SBATCH --nodes=3
#SBATCH --time=00:10:00
#SBATCH --exclusive 
#SBATCH --qos=debug
##########################################

# Configurations
NETWORK_SUFFIX="-ib0"
module load DATACLAY/DevelMarc
module load EXTRAE/3.8.3

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
echo $'\e[1;32m' "dataclaysrv" $'\e[0m'
dataclaysrv start --hosts "$HOSTS" --debug $EXTRA_ARGS

# Register accounts, model and store stubs in client node
echo $'\e[1;32m' "dataclayprepare" $'\e[0m'
dataclayprepare $(pwd)/model/src $(pwd)/app/src DemoNS python 

# Run app 
# pyclay <main> <args>
echo $'\e[1;32m' "pyclay" $'\e[0m'
# pyclay src/hellopeople.py forthepeople martin 33 $EXTRA_ARGS
source $HOME/.dataClay/$SLURM_JOBID/client.config
python app/src/hellopeople.py forthepeople martin 33

# Stop dataClay 
echo $'\e[1;32m' "stop" $'\e[0m'
dataclaysrv stop

echo $'\e[1;32m' "DEMO SUCCESSFULLY FINISHED!" $'\e[0m'

