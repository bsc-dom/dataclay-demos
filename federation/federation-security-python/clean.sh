#!/bin/sh
#-----------------------------------------------------------------------
# Helper functions (miscellaneous)
#-----------------------------------------------------------------------
CONSOLE_CYAN="\033[1m\033[36m"; CONSOLE_NORMAL="\033[0m"
CONSOLE_YELLOW="\033[1m\033[33m"
printMsg() {
  printf "${CONSOLE_CYAN}### ${1}${CONSOLE_NORMAL}\n"
}
#-----------------------------------------------------------------------
# MAIN
#-----------------------------------------------------------------------
printMsg "Removing machine dataclay-demo-authority..."
yes | docker-machine rm dataclay-demo-authority
printMsg "Removing machine dataclay-demo-city..."
yes | docker-machine rm dataclay-demo-city
printMsg "Removing machine dataclay-demo-car	..."
yes | docker-machine rm dataclay-demo-car
printf "${CONSOLE_YELLOW}!! WARNING !! Restarting virtual box network calling \`sudo ifconfig vboxnet0 down && sudo ifconfig vboxnet0 up\`${CONSOLE_NORMAL}\n"
printf "${CONSOLE_YELLOW}NOTE: restarting virtualbox network avoid SSH problems with docker-machine${CONSOLE_NORMAL}\n"
sudo ifconfig vboxnet0 down && sudo ifconfig vboxnet0 up