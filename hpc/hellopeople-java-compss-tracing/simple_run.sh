#!/bin/bash
APP_PATH=$(pwd)

export COMPSS_PYTHON_VERSION=3 #require python version >=3
export TRACING=true

module load COMPSs
module load DATACLAY

# Copying it to temporal path to protect it (e.g. multiple executions)
mkdir -p ./storagetmp
STORAGE_PROPS=`mktemp -p ./storagetmp/`
cp $PWD/execution_values $STORAGE_PROPS
enqueue_compss \
    --job_name=hellopeople \
        --tracing=$TRACING \
        --exec_time=30 \
    --classpath=$DATACLAY_JAR:$HOME/.dataClay/\$SLURM_JOBID/client/app/bin:$HOME/.dataClay/\$SLURM_JOBID/client/app/stubs \
        --lang=java \
        --num_nodes=3 \
        --worker_in_master_cpus=0 \
        --master_working_dir=. \
        --worker_working_dir=scratch \
        --storage_home=$COMPSS_STORAGE_HOME \
        --storage_props="$STORAGE_PROPS" \
    --jvm_workers_opts="-javaagent:/apps/DATACLAY/dependencies/aspectjweaver.jar" \
    --jvm_master_opts="-javaagent:/apps/DATACLAY/dependencies/aspectjweaver.jar" \
        --prolog="$DATACLAY_HOME/bin/dataclayprepare,$(pwd)/model/src,$(pwd)/app/src,DemoNS,java" \
        app.HelloPeople forthepeople martin 33

