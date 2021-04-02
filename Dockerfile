# thanks to https://github.com/apache/spark/blob/master/resource-managers/kubernetes/docker/src/main/dockerfiles/spark/bindings/python/Dockerfile
ARG base_img


FROM $base_img

ARG hadoop_version=2.7
ARG spark_version=3.1.1

ARG spark_distro=spark-${spark_version}-bin-hadoop${hadoop_version}
ARG spark_artifact=${spark_distro}.tgz
ARG spark_download_url=https://downloads.apache.org/spark/spark-${spark_version}/${spark_artifact}


WORKDIR /

# Reset to root to run installation tasks
USER 0

RUN mkdir ${SPARK_HOME}/python
RUN apt-get update && \
    apt install -y python3 python3-pip && \
    pip3 install --upgrade pip setuptools && \
    # Removed the .cache to save space
    rm -r /root/.cache && rm -rf /var/cache/apt/*

RUN wget ${spark_download_url} && \
    tar -xf ${spark_artifact} && \
    mv /${spark_distro}/python ${SPARK_HOME}/python && \
    rm /${spark_artifact}

WORKDIR /opt/spark/work-dir
ENTRYPOINT [ "/opt/entrypoint.sh" ]

# Specify the User that the actual main process will run as
ARG spark_uid=185
USER ${spark_uid}
