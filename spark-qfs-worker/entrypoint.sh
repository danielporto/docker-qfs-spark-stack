#!/bin/bash

echo "======================================================================================"
echo "QFS Entrypoint - update configuration"
echo "======================================================================================"
 
dockerize -template /templates/qfs/chunkserver.prp.j2:${QFS_HOME}/conf/Chunkserver.prp

