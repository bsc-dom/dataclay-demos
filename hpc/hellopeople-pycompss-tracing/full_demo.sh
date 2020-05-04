#!/bin/bash
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT
function ctrl_c() {
        echo "** Cancelling job $JOBID"
        scancel $JOBID
}
rm -rf ./storagetmp #clean previous temporary files
rm -f compss*
./simple_run.sh
JOBID=`squeue | grep bsc25731 | awk '{print $1}'`
echo "********* RUNNING JOB $JOBID ********** "
touch compss-${JOBID}.out
touch compss-${JOBID}.err
sh -c 'tail -f compss* | { sed "/dataClay stopped!/ q" && kill $$ ;}'

