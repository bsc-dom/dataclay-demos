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
export COMMAND_OPTS=""
printMsg "Checking requirements"
./check_requirements.sh

printMsg "Cleaning"
./clean.sh

printMsg "Creating virtual machines"
./create_machines.sh

printMsg "Building and deploying applications"
./deploy_apps.sh

printMsg "Running demo"
./run.sh

printMsg "Cleaning"
./clean.sh

printMsg " DEMO SUCCESSFULLY FINISHED :) "
