#!/bin/bash

if [ "$TRAVIS_BRANCH" == "master" ]; then 
	 find . -type f -exec sed -i 's/bscdataclay\/logicmodule\:develop/bscdataclay\/logicmodule/g' {} \;
	 find . -type f -exec sed -i 's/bscdataclay\/dsjava\:develop/bscdataclay\/dsjava/g' {} \;
	 find . -type f -exec sed -i 's/bscdataclay\/dspython\:develop/bscdataclay\/dspython/g' {} \;
	 find . -type f -exec sed -i 's/bscdataclay\/client\:develop/bscdataclay\/client/g' {} \;
	 find . -type f -exec sed -i 's/bscdataclay\/client\:develop/bscdataclay\/client/g' {} \;
	 find . -type f -exec sed -i 's/module load DATACLAY\/develop/module load DATACLAY/g' {} \;
	 find . -type f -exec sed -i 's/module load COMPSs\/Trunk/module load COMPSs/g' {} \;
     git add -A
	 git commit -m "Updating dataclay versions"
	 git push origin HEAD:$TRAVIS_BRANCH
else
     echo "Skipping prepare version tag because current branch is not master";
fi
