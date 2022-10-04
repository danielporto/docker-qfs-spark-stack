#!/bin/bash
bash /update_worker_templates.sh

echo "======================================================================================"
echo "Data dir content"
echo "======================================================================================"

find  /data
echo "Ensure existence of spark dirs"
sudo mkdir -p "${SPARK_LOGS_DIR}"

sudo chown -R spark ${SPARK_LOGS_DIR}
sudo chown -R spark ${SPARK_LOGS_DIR}/..



echo "======================================================================================"
echo "START QFS CHUNKSERVER"
echo "======================================================================================"
# start the QFS chunk server
$QFS_HOME/bin/chunkserver $QFS_HOME/conf/Chunkserver.prp &> $QFS_LOGS_DIR/chunkserver.log &
sleep 2
tail $QFS_LOGS_DIR/chunkserver.log
echo "Chunkserver started"

echo "Ensure existence of QFS spark event dir"
qfs -mkdir /history/spark-event
qfs -mkdir /user
sleep 2

echo "======================================================================================"
echo "START SPARK WORKER"
echo "======================================================================================"
# start the spark worker 
$SPARK_HOME/sbin/start-worker.sh spark://${SPARK_MASTER_HOSTNAME}:${SPARK_MASTER_PORT}

# now do nothing and do not exit
while true; do sleep 3600; done
