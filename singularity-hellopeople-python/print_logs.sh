#!/bin/bash
if [[ $# -eq 0 ]] ; then
    echo 'Usage print_logs.sh <job id>'
    exit 0
fi
JOBID=$1

for NODE in `ls -a $HOME/.dataClay/job$JOBID/`; do 
    echo "Checking $NODE folder"
    if [[ $NODE == .* ]] && [[ $NODE != ".." ]] && [[ $NODE != "." ]]; then
        echo "******* LOGS IN $NODE *******"
        echo "cd $HOME/.dataClay/job$JOBID/$NODE; module load DATACLAY/2.1; cat singularity-compose.yml; singularity-compose logs; singularity-compose ps" | ssh "${NODE:1}" bash -s
    fi
done 



