#!/bin/bash
echo ""
echo ""
echo "======================================================================================"
echo "TEMPLATES"
echo "======================================================================================"
find /templates

echo "======================================================================================"
echo "BASE IMAGE CONFS - QFS Entrypoint - update configuration"
echo "======================================================================================"
 
dockerize -template /templates/qfs/chunkserver.prp.j2:${QFS_HOME}/conf/Chunkserver.prp
cat ${QFS_HOME}/conf/Chunkserver.prp

echo "======================================================================================"
echo "SPARK Entrypoint - update configuration"
echo "======================================================================================"
 
dockerize -template /templates/spark/spark-defaults.conf.j2:$SPARK_HOME/conf/spark-defaults.conf
cat $SPARK_HOME/conf/spark-defaults.conf
dockerize -template /templates/spark/spark-env.sh.j2:$SPARK_HOME/conf/spark-env.sh
cat $SPARK_HOME/conf/spark-env.sh


echo "======================================================================================"
echo "Data dir content"
echo "======================================================================================"
find  /data
echo "======================================================================================"
echo "Log dir content"
echo "======================================================================================"
ls -la $QFS_LOGS_DIR
sudo mkdir -p $QFS_LOGS_DIR
sudo chown spark $QFS_LOGS_DIR
sudo chmod -R ug+rw $QFS_LOGS_DIR

echo "======================================================================================"
echo "QFS Master node - update configuration"
echo "======================================================================================"

$QFS_HOME/bin/metaserver $QFS_HOME/conf/Metaserver.prp &> $QFS_LOGS_DIR/metaserver.log &

python2 $QFS_HOME/webui/qfsstatus.py $QFS_HOME/conf/webUI.cfg &> $QFS_LOGS_DIR/webui.log &

$QFS_HOME/bin/tools/qfs -fs qfs://qfs-master:20000 -D fs.trash.minPathDepth=2 -runEmptier &

# now do nothing and do not exit
while true; do sleep 3600; done

