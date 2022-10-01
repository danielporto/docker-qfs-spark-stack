#!/bin/bash
echo ""
echo ""
echo "======================================================================================"
echo "TEMPLATES"
echo "======================================================================================"
find /templates

echo "======================================================================================"
echo "COMMOM CONFIGURATION (Worker image)- update templates shared between workers and masters"
echo "======================================================================================"
echo "QFS update configuration - CHUNCKSERVER"
 dockerize -template /templates/qfs/chunkserver.prp.j2:${QFS_HOME}/conf/Chunkserver.prp
echo "-------------------------------------------------------------------------------------"
cat ${QFS_HOME}/conf/Chunkserver.prp
echo "======================================================================================"

echo "======================================================================================"
echo "SPARK update configuration - ENVS and DEFAULT CONF"
dockerize -template /templates/spark/spark-defaults.conf.j2:$SPARK_HOME/conf/spark-defaults.conf
cat $SPARK_HOME/conf/spark-defaults.conf
echo "-------------------------------------------------------------------------------------"
dockerize -template /templates/spark/spark-env.sh.j2:$SPARK_HOME/conf/spark-env.sh
cat $SPARK_HOME/conf/spark-env.sh
echo "======================================================================================"
