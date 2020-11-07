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
	 
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/logicmodule\:-alpine/bscdataclay\/logicmodule\:alpine/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dsjava\:-alpine/bscdataclay\/dsjava\:alpine/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dspython\:-alpine/bscdataclay\/dspython\:alpine/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/client\:-alpine/bscdataclay\/client\:alpine/g' {} \;

find $BASEDIR -type f -exec sed -i 's/bscdataclay\/logicmodule\:-slim/bscdataclay\/logicmodule\:slim/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dsjava\:-slim/bscdataclay\/dsjava\:slim/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dspython\:-slim/bscdataclay\/dspython\:slim/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/client\:-slim/bscdataclay\/client\:slim/g' {} \;

find $BASEDIR -type f -exec sed -i 's/module load DATACLAY/develop\/develop/module load DATACLAY/develop/g' {} \;
find $BASEDIR -type f -exec sed -i 's/module load COMPSs/Trunk\/Trunk/module load COMPSs/Trunk/g' {} \;

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

find $BASEDIR -type f -exec sed -i 's/bscdataclay\/logicmodule\:alpine/bscdataclay\/logicmodule\:develop-alpine/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dsjava\:alpine/bscdataclay\/dsjava\:develop-alpine/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dspython\:alpine/bscdataclay\/dspython\:develop-alpine/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/client\:alpine/bscdataclay\/client\:develop-alpine/g' {} \;

find $BASEDIR -type f -exec sed -i 's/bscdataclay\/logicmodule\:slim/bscdataclay\/logicmodule\:develop-slim/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dsjava\:slim/bscdataclay\/dsjava\:develop-slim/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/dspython\:slim/bscdataclay\/dspython\:develop-slim/g' {} \;
find $BASEDIR -type f -exec sed -i 's/bscdataclay\/client\:slim/bscdataclay\/client\:develop-slim/g' {} \;

find $BASEDIR -type f -exec sed -i 's/module load DATACLAY/develop/module load DATACLAY/develop\/develop/g' {} \;
find $BASEDIR -type f -exec sed -i 's/module load COMPSs/Trunk/module load COMPSs/Trunk\/Trunk/g' {} \;

git add -A
git commit -m "New development version"
git push
