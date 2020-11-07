#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BASEDIR=$SCRIPTDIR/..
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$BRANCH" != "master" ]]; then
  printError 'Branch is not master. Aborting script';
  exit 1;
fi


find $BASEDIR -type f -exec sed -i 's/bscdataclay\/logicmodule\:develop/bscdataclay\/logicmodule/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dsjava\:develop/bscdataclay\/dsjava/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dspython\:develop/bscdataclay\/dspython/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/client\:develop/bscdataclay\/client/g' {} \;
	 
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/logicmodule\:develop-alpine/bscdataclay\/logicmodule\:alpine/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dsjava\:develop-alpine/bscdataclay\/dsjava\:alpine/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dspython\:develop-alpine/bscdataclay\/dspython\:alpine/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/client\:develop-alpine/bscdataclay\/client\:alpine/g' {} \;

find $BASEDIR -type f -exec sed -i 's/bscdataclay\/logicmodule\:develop-slim/bscdataclay\/logicmodule\:slim/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dsjava\:develop-slim/bscdataclay\/dsjava\:slim/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dspython\:develop-slim/bscdataclay\/dspython\:slim/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/client\:develop-slim/bscdataclay\/client\:slim/g' {} \;
	 
find $BASEDIR -type f -exec sed -i 's/module load DATACLAY\/develop/module load DATACLAY/g' {} \;
find $BASEDIR -type f -exec sed -i 's/module load COMPSs\/Trunk/module load COMPSs/g' {} \;

git add -A
git commit -m "Modified docker images"
git push

# ============================== Develop branch update ==============================

git checkout develop
git merge master

find $BASEDIR -type f -exec sed -i 's/bscdataclay\/logicmodule/bscdataclay\/logicmodule\:develop/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dsjava/bscdataclay\/dsjava\:develop/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dspython/bscdataclay\/dspython\:develop/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/client/bscdataclay\/client\:develop/g' {} \;

find $BASEDIR -type f -exec sed -i 's/bscdataclay\/logicmodule/bscdataclay\/logicmodule\:develop-alpine/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dsjava/bscdataclay\/dsjava\:develop-alpine/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dspython/bscdataclay\/dspython\:develop-alpine/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/client/bscdataclay\/client\:develop-alpine/g' {} \;

find $BASEDIR -type f -exec sed -i 's/bscdataclay\/logicmodule/bscdataclay\/logicmodule\:develop-slim/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dsjava/bscdataclay\/dsjava\:develop-slim/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dspython/bscdataclay\/dspython\:develop-slim/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/client/bscdataclay\/client\:develop-slim/g' {} \;

find $BASEDIR -type f -exec sed -i 's/module load DATACLAY/module load DATACLAY\/develop/g' {} \;
find $BASEDIR -type f -exec sed -i 's/module load COMPSs/module load COMPSs\/Trunk/g' {} \;

git add -A
git commit -m "New development version"
git push
