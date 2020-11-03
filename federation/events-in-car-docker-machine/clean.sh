#!/bin/sh
echo "Removing machine dataclay-demo-city..."
yes | docker-machine rm dataclay-demo-city
echo "Removing machine dataclay-demo-car	..."
yes | docker-machine rm dataclay-demo-car
echo "Done!"