#!/bin/sh
set -e
#-----------------------------------------------------------------------
# Helper functions (miscellaneous)
#-----------------------------------------------------------------------
CONSOLE_CYAN="\033[1m\033[36m"; CONSOLE_NORMAL="\033[0m"
printMsg() {
  printf "${CONSOLE_CYAN}### ${1}${CONSOLE_NORMAL}\n"
}
#-----------------------------------------------------------------------
# MAIN
#-----------------------------------------------------------------------

printMsg "Checking requirements"
./check_requirements.sh

printMsg "Cleaning"
./clean.sh

printMsg "Creating virtual machines"
./create_machines.sh

printMsg "Building and deploying"
./deploy.sh

printMsg "Running demo"
./run.sh

printMsg "Cleaning"
./clean.sh

printMsg " DEMO SUCCESSFULLY FINISHED :) "
