#--------------------------------------------------------------------------------
# build and install dockerize to the current proper architecture
#--------------------------------------------------------------------------------
# build and install dockerize to the current proper architecture
FROM golang:1.17.5-bullseye AS dependencies
RUN apt update && apt install -y openssl git
WORKDIR /go/src/github.com/jwilder/dockerize
ENV GO111MODULE=on

RUN set -ex; \
    git clone https://github.com/jwilder/dockerize.git . ;\
    go mod tidy ;\
    go install


#--------------------------------------------------------------------------------
# build step
#--------------------------------------------------------------------------------
# Base image  cluster with QFS
#
# https://github.com/DIYBigData/personal-compute-cluster/tree/master/spark-qfs-swarm#
#
# Expected volumes:
#	/data/qfs - this is where QFS will store its data
#
# Expected service names:
#	qfs-master - the service where the QFS metaserver runs
FROM python:3.9.14-buster
LABEL org.opencontainers.image.authors="daniel.porto@gmail.com"

COPY --from=dependencies /go/bin/dockerize /usr/local/bin



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
ARG QFS_PACKAGE=qfs-debian-10-${QFS_VERSION}-x86_64
ENV QFS_HOME /usr/qfs-${QFS_VERSION}
ENV QFS_LOGS_DIR /data/qfs/logs
ENV LD_LIBRARY_PATH ${QFS_HOME}/lib
ARG QFS_DOWNLOAD_URL="https://s3.amazonaws.com/quantcast-qfs/${QFS_PACKAGE}.tgz"
RUN echo "Downloading QFS from : ${QFS_DOWNLOAD_URL}\n" \
	&& curl -L --retry 3 -k \
	     $QFS_DOWNLOAD_URL \
	   | gunzip \
	   | tar x -C /usr/ \
	&& mv /usr/$QFS_PACKAGE $QFS_HOME \
	&& chown -R root:root $QFS_HOME \
	&& ln -s $QFS_HOME /usr/local/qfs
ENV PATH $PATH:${QFS_HOME}/bin:${QFS_HOME}/bin/tools
RUN mkdir -p /data/qfs/ 

# add python libraries useful in PySpark
RUN python3 -m pip install matplotlib \
						   pandas \
						   seaborn \
						   pyarrow \
						   spark-nlp \
						   pyyaml

ENV METASERVER_HOSTNAME=qfs-master
ENV METASERVER_PORT=30000
ENV CLUSTER_KEY=qfs-personal-compute-cluster
# copy QFS configurations
COPY ./templates/* /templates/
COPY entrypoint.sh /docker-entrypoint.d/10-entrypoint.sh
RUN chmod ugo+x /docker-entrypoint.d/10-entrypoint.sh

CMD ["bash"] 