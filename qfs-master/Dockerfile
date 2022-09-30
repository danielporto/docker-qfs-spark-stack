FROM danielporto/spark-qfs-worker:latest

#
# Expected volumes:
#	/data/qfs - this is where QFS will store its data
#
# Instance should run on the swarm's master node so as to persist configuration
#

USER root
RUN apt-get update \
 && apt-get install -y wget vim openssh-client \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# set configuration
COPY ./templates/qfs/* /templates/qfs/
COPY start-qfs-master.sh /

# ensure permissions
RUN mkdir -p $QFS_HOME/conf \
	&& mkdir -p $QFS_LOGS_DIR \
	&& chown -R spark /data/qfs /data/spark $SPARK_HOME $QFS_HOME  $QFS_LOGS_DIR \
    && sudo chmod u+rw /data/qfs /data/spark $SPARK_HOME $QFS_HOME  $QFS_LOGS_DIR \
	&& chmod 755 /start-qfs-master.sh


USER spark
# create some useful bash aliases for when at bash shell prompt of this image
RUN echo 'export PATH=$PATH:$QFS_HOME/bin/:$QFS_HOME/bin/tools/' >> ~/.bash_aliases \
 && echo 'alias qfs="qfs -fs qfs://qfs-master:20000 -D fs.trash.minPathDepth=2 -D fs.createParams=2"' >> ~/.bash_aliases \
 && echo 'alias cptoqfs="cptoqfs -s qfs-master -p 20000"' >> ~/.bash_aliases \
 && echo 'alias cpfromqfs="cpfromqfs -s qfs-master -p 20000"' >> ~/.bash_aliases \
 && echo 'alias qfsshell="qfsshell -s qfs-master -p 20000"' >> ~/.bash_aliases \
 && echo 'alias qfsfsck="qfsfsck -s qfs-master -p 20000"' >> ~/.bash_aliases \
 && echo 'alias qfsfileenum="qfsfileenum -s qfs-master -p 20000"' >> ~/.bash_aliases

CMD ["/bin/bash", "/start-qfs-master.sh"]
