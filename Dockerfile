FROM ubuntu:18.04
MAINTAINER Yan Grunenberger <yan@grunenberger.net>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -qqy install autoconf libtool gcc pkg-config git flex bison libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libmongoc-dev libbson-dev libyaml-dev iptables
RUN apt-get -qqy install libidn11-dev # since 18.04

RUN git clone --recursive https://github.com/open5gs/nextepc
RUN cd /nextepc && autoreconf -iv && ./configure --prefix=/  && make -j `nproc` install

RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y install nodejs

RUN cd nextepc/webui && npm install && npm run build

RUN apt-get -qy install tshark

WORKDIR /
