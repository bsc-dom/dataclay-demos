#!/bin/sh
set -e
echo "Creating new docker-machine dataclay-demo-authority..."
docker-machine create --driver virtualbox dataclay-demo-authority
echo "Creating new docker-machine dataclay-demo-city..."
docker-machine create --driver virtualbox dataclay-demo-city
echo "Creating new docker-machine dataclay-demo-car..."
docker-machine create --driver virtualbox dataclay-demo-car
# Deploying certificates and configurations
sudo cp /usr/local/share/ca-certificates/dom-ci.bsc.es.crt .
echo "sudo mkdir -p /var/lib/boot2docker/certs; \
   echo "\""$(cat dom-ci.bsc.es.crt)"\"" | \
   sudo tee -a /var/lib/boot2docker/certs/dom-ci.bsc.es.crt" \
   | docker-machine ssh dataclay-demo-city
docker-machine restart dataclay-demo-city
echo "sudo mkdir -p /var/lib/boot2docker/certs; \
   echo "\""$(cat dom-ci.bsc.es.crt)"\"" | \
   sudo tee -a /var/lib/boot2docker/certs/dom-ci.bsc.es.crt" \
   | docker-machine ssh dataclay-demo-car
docker-machine restart dataclay-demo-car
echo "Done!"