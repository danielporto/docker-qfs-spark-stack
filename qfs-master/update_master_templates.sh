#!/bin/bash
bash /update_worker_templates.sh
echo "======================================================================================"
echo "QFS update configuration - METASERVER"
dockerize -template /templates/qfs/Metaserver.prp.j2:${QFS_HOME}/conf/Metaserver.prp
cat ${QFS_HOME}/conf/Metaserver.prp

echo "-------------------------------------------------------------------------------------"

echo "QFS update configuration - WebSERVER"
dockerize -template /templates/qfs/webUI.cfg.j2:${QFS_HOME}/conf/webUI.cfg
cat ${QFS_HOME}/conf/webUI.cfg
echo "======================================================================================"

