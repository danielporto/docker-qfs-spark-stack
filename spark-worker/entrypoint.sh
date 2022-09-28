#!/bin/bash

echo "======================================================================================"
echo "SPARK Entrypoint - update configuration"
echo "======================================================================================"
 
dockerize -template /templates/spark-defaults.conf.j2:$SPARK_HOME/conf/spark-defaults.conf
dockerize -template /templates/spark-env.sh.j2:$SPARK_HOME/conf/spark-env.sh

