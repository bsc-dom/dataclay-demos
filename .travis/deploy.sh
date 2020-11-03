#!/bin/bash

if [ "$TRAVIS_BRANCH" == "master" ]; then 
	 find . -type f -exec sed -i 's/bscdataclay\/logicmodule\:develop/bscdataclay\/logicmodule/g' {} \;
	 find . -type f -exec sed -i 's/bscdataclay\/dsjava\:develop/bscdataclay\/dsjava/g' {} \;
	 find . -type f -exec sed -i 's/bscdataclay\/dspython\:develop/bscdataclay\/dspython/g' {} \;
	 find . -type f -exec sed -i 's/bscdataclay\/client\:develop/bscdataclay\/client/g' {} \;
	 
	 find . -type f -exec sed -i 's/bscdataclay\/logicmodule\:develop-alpine/bscdataclay\/logicmodule\:alpine/g' {} \;
	 find . -type f -exec sed -i 's/bscdataclay\/dsjava\:develop-alpine/bscdataclay\/dsjava\:alpine/g' {} \;
	 find . -type f -exec sed -i 's/bscdataclay\/dspython\:develop-alpine/bscdataclay\/dspython\:alpine/g' {} \;
	 find . -type f -exec sed -i 's/bscdataclay\/client\:develop-alpine/bscdataclay\/client\:alpine/g' {} \;

	 find . -type f -exec sed -i 's/bscdataclay\/logicmodule\:develop-slim/bscdataclay\/logicmodule\:slim/g' {} \;
	 find . -type f -exec sed -i 's/bscdataclay\/dsjava\:develop-slim/bscdataclay\/dsjava\:slim/g' {} \;
	 find . -type f -exec sed -i 's/bscdataclay\/dspython\:develop-slim/bscdataclay\/dspython\:slim/g' {} \;
	 find . -type f -exec sed -i 's/bscdataclay\/client\:develop-slim/bscdataclay\/client\:slim/g' {} \;
	 
	 find . -type f -exec sed -i 's/module load DATACLAY\/develop/module load DATACLAY/g' {} \;
	 find . -type f -exec sed -i 's/module load COMPSs\/Trunk/module load COMPSs/g' {} \;

   git add -A
	 git commit -m "Modified docker images"
	 git push origin HEAD:$TRAVIS_BRANCH
else
     echo "Skipping prepare version tag because current branch is not master";
fi
