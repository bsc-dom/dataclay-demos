#!/bin/sh
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
printMsg "Removing and cleaning dataClay dockers"
docker-compose kill
docker-compose down -v #sanity check

# Clean build dockers
docker rmi -f dataclaydemos/wordcount-java
printMsg "Cleaned!"