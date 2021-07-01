#!/bin/bash
APP_PATH=$(pwd)/app

export COMPSS_PYTHON_VERSION=3 #require python version >=3
module load COMPSs/2.7
module load DATACLAY
export TRACING=true
# Copying it to temporal path to protect it (e.g. multiple executions)
STORAGE_PROPS=`mktemp -p ~`
cp $PWD/execution_values $STORAGE_PROPS
enqueue_compss \
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
    --jvm_workers_opts="-javaagent:/apps/DATACLAY/dependencies/aspectjweaver.jar" \
    --jvm_master_opts="-javaagent:/apps/DATACLAY/dependencies/aspectjweaver.jar" \
	--prolog="$DATACLAY_HOME/bin/dataclayprepare,$(pwd)/model/,$(pwd)/app/,DemoNS,python" \
	$APP_PATH/hellopeople.py
