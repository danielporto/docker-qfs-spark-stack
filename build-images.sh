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

cd certs
bash generate-certs.sh 
cd ..
. .env
# build images
echo "BUILDING danielporto/traefik:v2.8.1...."
docker build --rm -t danielporto/traefik:v2.8.1 $DOCKER_BUILD_ARGS ./traefik
echo "BUILDING danielporto/spark-qfs-worker...."
docker build --rm -t danielporto/spark-qfs-worker:latest $DOCKER_BUILD_ARGS ./spark-qfs-worker
echo "BUILDING danielporto/spark-master...."
docker build --rm -t danielporto/spark-qfs-master:latest $DOCKER_BUILD_ARGS ./spark-master
echo "BUILDING danielporto/qfs-master...."
docker build --rm -t danielporto/qfs-master:latest $DOCKER_BUILD_ARGS ./qfs-master


# echo "BUILDING danielporto/jupyter-server...."
# docker build -t danielporto/jupyter-server:latest $DOCKER_BUILD_ARGS ./jupyter-server


# push the images to local repository
# docker push master:5000/worker-node:latest
# docker push master:5000/qfs-master:latest
# docker push master:5000/spark-master:latest
# docker push master:5000/jupyter-server:latest
