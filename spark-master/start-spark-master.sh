#!/bin/bash
bash /update_worker_templates.sh

echo "======================================================================================"
echo "SPARK Master node - update configuration"
echo "======================================================================================"

dockerize -wait tcp://${QFS_METASERVER_HOSTNAME}:${QFS_METASERVER_PORT} -timeout 60m echo "QFS Master clientPort is online!"
dockerize -wait tcp://${QFS_METASERVER_HOSTNAME}:${QFS_CHUNCKSERVER_SERVER_PORT} -timeout 60m echo "QFS Master chunkServerPort is online!"

# start Spark master
echo "======================================================================================"
echo "START SPARK MASTER"
echo "======================================================================================"

$SPARK_HOME/sbin/start-master.sh
echo "Spark master started"

echo "======================================================================================"
echo "START SPARK HISTORY SERVER"
echo "======================================================================================"
#start the Spark history server
$SPARK_HOME/sbin/start-history-server.sh
echo "Spark history server started"

# now do nothing and do not exit
while true; do sleep 3600; done
