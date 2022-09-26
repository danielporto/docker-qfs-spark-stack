FROM python:3.9.14-buster
LABEL org.opencontainers.image.authors="daniel.porto@gmail.com"


# Base image  cluster with QFS
#
# https://github.com/DIYBigData/personal-compute-cluster/tree/master/spark-qfs-swarm#
#
# Expected volumes:
#	/data/qfs - this is where QFS will store its data
#
# Expected service names:
#	qfs-master - the service where the QFS metaserver runs

ARG QFS_VERSION=2.2.5

RUN apt-get update \
 && apt-get install -y locales \
 && dpkg-reconfigure -f noninteractive locales \
 && locale-gen C.UTF-8 \
 && /usr/sbin/update-locale LANG=C.UTF-8 \
 && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update \
 && apt-get install -y less curl unzip procps \
    libboost-regex-dev \
 && pip3 install py4j \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV PYTHONIOENCODING UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK 1

# QFS
ARG QFS_PACKAGE=qfs-debian-9-${QFS_VERSION}-x86_64
ENV QFS_HOME /usr/qfs-${QFS_VERSION}
ENV QFS_LOGS_DIR /data/qfs/logs
ENV LD_LIBRARY_PATH ${QFS_HOME}/lib
ARG QFS_DOWNLOAD_URL="https://s3.amazonaws.com/quantcast-qfs/qfs-debian-9-${QFS_VERSION}-x86_64.tgz"
RUN echo "Downloading QFS from : ${QFS_DOWNLOAD_URL}\n" \
	&& curl -L --retry 3 -k \
	     $QFS_DOWNLOAD_URL \
	   | gunzip \
	   | tar x -C /usr/ \
	&& mv /usr/$QFS_PACKAGE $QFS_HOME \
	&& chown -R root:root $QFS_HOME \
	&& ln -s $QFS_HOME /usr/local/qfs
ENV PATH $PATH:${QFS_HOME}/bin:${QFS_HOME}/bin/tools
RUN mkdir -p /data/qfs/ \
 && chown spark -R /data/qfs

# SPARK
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR_VERSION}
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
ENV SPARK_DIST_CLASSPATH="$QFS_HOME/lib/hadoop-$HADOOP_VERSION-qfs-$QFS_VERSION.jar:$QFS_HOME/lib/qfs-access-$QFS_VERSION.jar"
ENV HADOOP_CONF_DIR=${SPARK_HOME}/conf/
ENV PATH $PATH:${SPARK_HOME}/bin
ARG SPARK_DOWNLOAD_URL="https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz"
RUN echo "Downloading Spark from : ${SPARK_DOWNLOAD_URL}\n" \
	&& curl -L --retry 3 \
	     $SPARK_DOWNLOAD_URL \
	   | gunzip \
	   | tar x -C /usr/ \
	&& mv /usr/$SPARK_PACKAGE $SPARK_HOME \
	&& chown -R root:root $SPARK_HOME \
	&& ln -s $SPARK_HOME /usr/local/spark
RUN mkdir -p /data/spark \
 && chown spark -R /data/spark


# add python libraries useful in PySpark
RUN python3 -mpip install matplotlib \
	&& pip3 install pandas seaborn pyarrow spark-nlp

# copy QFS and Spark configurations
COPY ./qfs-conf/* $QFS_HOME/conf/
COPY ./spark-conf/* $SPARK_HOME/conf/

# set up command
COPY start-worker-node.sh /
USER spark
WORKDIR /home/spark
CMD ["/bin/bash", "/start-worker-node.sh"]
