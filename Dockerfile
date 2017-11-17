FROM openjdk:8u131-jre-alpine
MAINTAINER <Sparks Li>


ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TZ=Asia/Shanghai


RUN apk --update add curl unzip bash tzdata \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

# SPARK
ENV SPARK_VERSION 2.2.0
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-hadoop2.7
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
# ENV CLASS_PATH $CLASS_PATH:${SPARK_HOME}/jars
ENV PATH $PATH:${SPARK_HOME}/bin
ENV SPARK_HISTORY_HOME=/root/spark/history


RUN curl -sL --retry 3 \
  "http://d3kbcqa49mib13.cloudfront.net/${SPARK_PACKAGE}.tgz" \
  | gunzip \
  | tar x -C /usr/ \
 && mv /usr/$SPARK_PACKAGE $SPARK_HOME \
 && chown -R root:root $SPARK_HOME \
 && mkdir -p $SPARK_HISTORY_HOME

WORKDIR $SPARK_HOME

CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
