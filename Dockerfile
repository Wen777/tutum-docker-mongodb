FROM ubuntu:14.04

MAINTAINER wen777 <shih777577@gmail.com>

RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/mongodb.list && \
  apt-get update && \
  apt-get install -y mongodb-org pwgen && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data/db && mkdir -p /etc/mongo_conf

WORKDIR /

VOLUME /data/db

ENV AUTH yes

ENV KEYFILE false

# Add run scripts
ADD run.sh /run.sh
ADD set_mongodb_password.sh /set_mongodb_password.sh
RUN chmod 755 ./*.sh

EXPOSE 27017
EXPOSE 28017

CMD ["/run.sh"]
