#!/bin/bash

set -e

DOCKER_BUILD_ARGS=

while getopts b: option
do
case "${option}"
in
b) DOCKER_BUILD_ARGS=${OPTARG};;
esac
done

if [ -z "$DOCKER_BUILD_ARGS" ]
then
	echo "Building with default docker options"
else
	echo "Building with docker arguments = '$DOCKER_BUILD_ARGS'"
fi

# build images
echo "BUILDING danielporto/qfs-base...."
docker build -t danielporto/qfs-base:latest $DOCKER_BUILD_ARGS ./qfs-base
echo "BUILDING danielporto/spark-qfs-worker...."
docker build -t danielporto/spark-qfs-worker:latest $DOCKER_BUILD_ARGS ./spark-worker
echo "BUILDING danielporto/spark-qfs-master...."
docker build -t danielporto/spark-qfs-master:latest $DOCKER_BUILD_ARGS ./spark-master
echo "BUILDING danielporto/qfs-master...."
docker build -t danielporto/qfs-master:latest $DOCKER_BUILD_ARGS ./qfs-master


# push the images to local repository
# docker push master:5000/worker-node:latest
# docker push master:5000/qfs-master:latest
# docker push master:5000/spark-master:latest
# docker push master:5000/jupyter-server:latest
