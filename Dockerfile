#Download base image ubuntu 16.04
FROM ubuntu:16.04 
MAINTAINER George Chilumbu

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Set timezone
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set the working directory to /app
WORKDIR ~/

# Install some necessary software/tools  
RUN apt-get update && apt-get install -y \
    wget \
    vim \
    less \
    unzip \
    inetutils-ping \
    inetutils-tools \
    net-tools \
    dnsutils \
    software-properties-common \
    python-software-properties \
    ntp \
    rsyslog \
    curl \
    telnet \
    xinetd \
    telnet

RUN apt-get -y upgrade

RUN add-apt-repository ppa:gaod/mcrouter \
    && apt-get -y update \
    && apt-get install -y mcrouter \
    && rm /etc/mcrouter.conf 
   
COPY mcrouter/mcrouter.conf /etc/mcrouter.conf

## INSTALL and setup redis_exporter

## INSTALL and setup node_exporter. Down from https://github.com/prometheus/node_exporter/releases
RUN wget https://github.com/prometheus/node_exporter/releases/download/v0.15.2/node_exporter-0.15.2.linux-amd64.tar.gz
RUN tar zxf node_exporter-0.15.2.linux-amd64.tar.gz -C /opt/

## INSTALL and setup consul
RUN wget https://releases.hashicorp.com/consul/1.0.6/consul_1.0.6_linux_amd64.zip
RUN unzip consul_*
RUN rm consul_*
RUN mv consul /usr/local/bin
RUN mkdir -p /etc/consul.d/scripts
RUN useradd -ms /bin/bash consul
RUN mkdir /var/consul
RUN chown consul:consul -R /var/consul

COPY consul/config.json /etc/consul.d
COPY consul/services.json /etc/consul.d
COPY consul/mcrouter.sh /etc/consul.d/scripts
COPY consul/consul.service /etc/systemd/system
COPY consul/consul.conf /etc/init

RUN chmod +x /etc/consul.d/scripts/mcrouter.sh
