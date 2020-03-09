#!/bin/bash
rm -f job.out
touch job.out
rm -f job.err
touch job.err
output=$(sbatch dataclay_job.sh)
JOBID=`echo $output | awk '{print $4}'`
echo "********* RUNNING JOB $JOBID ********** "
sh -c 'tail -f job.err -f job.out | { sed "/DEMO SUCCESSFULLY FINISHED!/ q" && kill $$ ;}'

