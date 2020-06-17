#!/bin/bash
APP_PATH=$(pwd)/app

export COMPSS_PYTHON_VERSION=3 #require python version >=3
export TRACING=false
module load COMPSs/Trunk
module load DATACLAY/develop

# Copying it to temporal path to protect it (e.g. multiple executions)
mkdir -p ./storagetmp
STORAGE_PROPS=`mktemp -p ./storagetmp/`
cp $PWD/execution_values $STORAGE_PROPS
enqueue_compss \
	--task_execution=compss --graph=false \
    --job_name=hellopeople \
	--tracing=$TRACING \
	--exec_time=30 \
    --classpath=$DATACLAY_JAR \
	--pythonpath=$APP_PATH:$PYCLAY_PATH \
	--lang=python \
	--num_nodes=3 \
	--worker_in_master_cpus=0 \
	--master_working_dir=. \
	--worker_working_dir=scratch \
	--storage_home=$COMPSS_STORAGE_HOME \
	--storage_props="$STORAGE_PROPS" \
	--prolog="$DATACLAY_HOME/bin/dataclayprepare,$(pwd)/model/,$(pwd)/app/,DemoNS,python" \
	$APP_PATH/hellopeople.py
