FROM danielporto/qfs-base:latest


ARG SPARK_VERSION=3.3.0
ARG HADOOP_MAJOR_VERSION=2
ARG HADOOP_VERSION=2.7.2
ARG SCALA_VERSION=2.12.15


# JAVA & SCALA
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
	&& apt update && apt-get install -y software-properties-common \
	&& add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
	&& apt-get update && apt-get install -y adoptopenjdk-8-hotspot \
	&& apt-get remove scala-library scala  \
	&& curl -o scala-${SCALA_VERSION}.deb https://www.scala-lang.org/files/archive/scala-${SCALA_VERSION}.deb \
	&& dpkg -i scala-${SCALA_VERSION}.deb \
	&& apt-get clean \
	&& rm scala-${SCALA_VERSION}.deb \
	&& rm -rf /var/lib/apt/lists/*

# create the user software will run from
RUN useradd -m -s /bin/bash spark

RUN mkdir -p /data/qfs/ && chown spark -R /data/qfs

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



# copy Spark configurations

COPY ./templates/* /templates/
COPY entrypoint.sh /docker-entrypoint.d/20-entrypoint.sh
RUN chmod ugo+x /docker-entrypoint.d/20-entrypoint.sh

# set up command
USER spark
WORKDIR /home/spark
CMD ["/bin/bash", "/start-worker-node.sh"]
