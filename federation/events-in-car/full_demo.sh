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
./clean.sh
./start.sh city
./start.sh car
./build.sh
./run.sh
./stop.sh car
./stop.sh city
./clean.sh
printMsg " DEMO SUCCESSFULLY FINISHED :) "
    
