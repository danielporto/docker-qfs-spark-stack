FROM danielporto/qfs-master:latest

#
# Expected volumes:
#   /home/spark/jupyter/notebooks - where the Jupyter notebooks will be persisted
#   /data/spark - Spark's data directory
#

ENV GRAPHFRAMES_VERSION 0.8.2-spark3.2-s_2.12
ENV SPARK_NLP_VERSION spark-nlp-spark32_2.12:3.4.4

USER root
RUN apt-get install -y g++
RUN pip3 install \
        notebook \
        jupyter_nbextensions_configurator \
        jupyter_contrib_nbextensions \
        yapf wget

COPY start-jupyter.sh /

USER spark
RUN jupyter contrib nbextension install --user
RUN jupyter nbextensions_configurator enable --user
RUN jupyter nbextension enable toc2/main
RUN jupyter nbextension enable codefolding/main
RUN jupyter nbextension enable execute_time/ExecuteTime

RUN mkdir -p /home/spark/jupyter/runtime \
 &&	mkdir -p /home/spark/jupyter/notebooks \
 &&	mkdir -p /home/spark/jars/

CMD ["/bin/bash", "/start-jupyter.sh"]
