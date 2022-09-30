#!/bin/bash
echo "======================================================================================"
echo "TEMPLATES:"
echo "======================================================================================"
ls /templates


echo "======================================================================================"
echo "BASE IMAGE CONFS - QFS Entrypoint - update configuration"
echo "======================================================================================"
 
dockerize -template /templates/qfs/chunkserver.prp.j2:${QFS_HOME}/conf/Chunkserver.prp


echo "======================================================================================"
echo "SPARK Entrypoint - update configuration"
echo "======================================================================================"
 
dockerize -template /templates/spark/spark-defaults.conf.j2:$SPARK_HOME/conf/spark-defaults.conf
dockerize -template /templates/spark/spark-env.sh.j2:$SPARK_HOME/conf/spark-env.sh


echo "======================================================================================"
echo "SPARK Workner node - update configuration"
echo "======================================================================================"

# start the QFS chunk server
$QFS_HOME/bin/chunkserver $QFS_HOME/conf/Chunkserver.prp &> $QFS_LOGS_DIR/chunkserver.log &

# start the spark worker 
$SPARK_HOME/sbin/start-slave.sh spark://spark-master:7077

# now do nothing and do not exit
while true; do sleep 3600; done
