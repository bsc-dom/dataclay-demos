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
export COMMAND_OPTS="" # optional commands: --debug, --tracing, ...
./clean.sh
./start.sh
./build.sh
./run.sh
./stop.sh
./clean.sh
printMsg " DEMO SUCCESSFULLY FINISHED :) "
    
