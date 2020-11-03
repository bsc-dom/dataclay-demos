#!/bin/sh
set -e
echo "Creating new docker-machine dataclay-demo-city..."
docker-machine create --driver virtualbox dataclay-demo-city
echo "Creating new docker-machine dataclay-demo-car..."
docker-machine create --driver virtualbox dataclay-demo-car
echo "Done!"