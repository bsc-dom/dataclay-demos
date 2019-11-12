#!/bin/bash

# Check dockers is installed 
if ! [ -x "$(command -v docker)" ]; then
  echo "Error: Docker command not found or not supported. Please check it is installed" >&2
  exit 1
fi

# Check docker-compose is installed
if ! [ -x "$(command -v docker-compose)" ]; then
  echo "Error: Docker-compose not found. Please check it is installed" >&2
  exit 1
fi

# Check docker-machine is installed
if ! [ -x "$(command -v docker-machine)" ]; then
  echo "Error: Docker-machine not found. Please check it is installed" >&2
  exit 1
fi