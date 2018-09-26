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
    netcat \
    telnet

RUN apt-get -y update
RUN apt-get -y upgrade

RUN add-apt-repository ppa:gaod/mcrouter \
    && apt-get -y update \
    && apt-get install -y mcrouter \
    && rm /etc/mcrouter.conf 
   
COPY mcrouter/mcrouter.conf /etc/mcrouter.conf


## INSTALL and setup consul
RUN wget https://releases.hashicorp.com/consul/1.2.2/consul_1.2.2_linux_amd64.zip
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
