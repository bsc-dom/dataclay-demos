#!/bin/bash
APP_PATH=$(pwd)
#module load DATACLAY/2.1
export COMPSS_PYTHON_VERSION=3-ML
module load DATACLAY/2.1
module load COMPSs/2.6
#module load DATACLAY/2.1

export TRACING=false
# Copying it to temporal path to protect it (e.g. multiple executions)
 #IMPORTANT: protect --prolog command with backslash and provide --slurm option

STORAGE_PROPS=`mktemp -p ~`
cp $PWD/execution_values $STORAGE_PROPS
enqueue_compss \
	--debug \
    --job_name=wordcount \
	--qos=debug \
	--tracing=$TRACING \
	--exec_time=15 \
    --classpath=$DATACLAY_JAR \
	--pythonpath=$APP_PATH \
	--lang=python \
	--num_nodes=3 \
	--worker_in_master_cpus=0 \
	--master_working_dir=. \
	--worker_working_dir=scratch \
	--storage_home=$COMPSS_STORAGE_HOME \
	--storage_props="$STORAGE_PROPS" \
	--prolog="\"$DATACLAY_HOME/bin/dataclayprepare $(pwd)/model/ DemoNS python --marenostrum\"" \
	$APP_PATH/hellopeople.py
