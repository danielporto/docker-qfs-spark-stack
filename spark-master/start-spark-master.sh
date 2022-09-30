#!/bin/bash

echo "======================================================================================"
echo "TEMPLATES"
echo "======================================================================================"
ls /templates 

echo "BASE IMAGE CONFS - QFS Entrypoint - update configuration"
echo "======================================================================================"
 
dockerize -template /templates/chunkserver.prp.j2:${QFS_HOME}/conf/Chunkserver.prp


echo "======================================================================================"
echo "SPARK Entrypoint - update configuration"
echo "======================================================================================"
 
dockerize -template /templates/spark-defaults.conf.j2:$SPARK_HOME/conf/spark-defaults.conf
dockerize -template /templates/spark-env.sh.j2:$SPARK_HOME/conf/spark-env.sh


echo "======================================================================================"
echo "SPARK Master node - update configuration"
echo "======================================================================================"

dockerize -wait tcp://qfs-master:20000 -timeout 60m echo "QFS Master clientPort is online!"
dockerize -wait tcp://qfs-master:30000 -timeout 60m echo "QFS Master chunkServerPort is online!"

# start Spark master
$SPARK_HOME/sbin/start-master.sh

# start the Spark history server
$SPARK_HOME/sbin/start-history-server.sh

# now do nothing and do not exit
while true; do sleep 3600; done
