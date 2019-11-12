#!/bin/bash
grn=$'\e[1;32m'
blu=$'\e[1;34m'
end=$'\e[0m'

printMsg() {
  #clear
  ACCUMMSG="  $ACCUMMSG\n  $1"
  printf "\n\n  ${blu}[dataClay requirements checker]${end} \n  ${grn}$ACCUMMSG${end} \n\n\n"
}

# Check dockers is installed 
if ! [ -x "$(command -v docker)" ]; then
  printMsg "Error: Docker command not found or not supported. Please check it is installed" >&2
  exit 1
fi

# Check docker-compose is installed
if ! [ -x "$(command -v docker-compose)" ]; then
  printMsg "Error: Docker-compose not found. Please check it is installed" >&2
  exit 1
fi

# Check docker-machine is installed
if ! [ -x "$(command -v docker-machine)" ]; then
  printMsg "Error: Docker-machine not found. Please check it is installed" >&2
  exit 1
fi

printMsg "\n  Congratulations! dataClay dependencies are accomplished."
