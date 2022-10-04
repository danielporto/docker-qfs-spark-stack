#!/bin/bash
bash /update_master_templates.sh
echo "======================================================================================"
echo "Data dir content"
echo "======================================================================================"
find  /data

echo "Ensure existence of QFS LOGS AND CHECKPOINT dirs"
sudo mkdir -p "${QFS_LOGS_DIR}"
sudo mkdir -p "${QFS_CHECKPOINT_DIR}"
sudo mkdir -p "${QFS_CHUNK_DIR}"

sudo chown -R spark ${QFS_LOGS_DIR}
sudo chown -R spark ${QFS_CHECKPOINT_DIR}
sudo chown -R spark ${QFS_CHUNK_DIR}

if [ ! -f "${QFS_CHECKPOINT_DIR}/latest" ]; then 
    $QFS_HOME/bin/metaserver -c $QFS_HOME/conf/Metaserver.prp
    # qfs -mkdir /history/spark-event
fi 

echo "======================================================================================"
echo "START QFS METASERVER"
echo "======================================================================================"

$QFS_HOME/bin/metaserver $QFS_HOME/conf/Metaserver.prp &> $QFS_LOGS_DIR/metaserver.log &
sleep 2
tail $QFS_LOGS_DIR/metaserver.log

echo "======================================================================================"
echo "START QFS WEBUI"
echo "======================================================================================"
python2 $QFS_HOME/webui/qfsstatus.py $QFS_HOME/conf/webUI.cfg &> $QFS_LOGS_DIR/webui.log &
sleep 2
tail $QFS_LOGS_DIR/webui.log


echo "======================================================================================"
echo "START QFS FILESYSTEM"
echo "======================================================================================"
$QFS_HOME/bin/tools/qfs -fs qfs://${QFS_METASERVER_HOSTNAME}:${QFS_METASERVER_PORT} -D fs.trash.minPathDepth=${QFS_TRASH_MINPATHDEPTH} -runEmptier &
sleep 2
tail $QFS_LOGS_DIR/metaserver.log
echo "QFS METASERVER started"

# now do nothing and do not exit
while true; do sleep 3600; done

