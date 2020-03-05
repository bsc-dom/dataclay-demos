#!/bin/bash
rm -f job.out
touch job.out
output=$(sbatch dataclay_job.sh)
JOBID=`echo $output | awk '{print $4}'`
echo "********* RUNNING JOB $JOBID ********** "
sh -c 'tail -f job.out | { sed "/Demo finished!/ q" && kill $$ ;}'

echo "********* JOB FINISHED ********** "


