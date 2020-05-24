FROM ubuntu:18.04
MAINTAINER Yan Grunenberger <yan@grunenberger.net>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -yq dist-upgrade

RUN apt-get install --no-install-recommends -yq \
     cmake \
     libuhd-dev \
     uhd-host \
     libboost-program-options-dev \
     libvolk1-dev \
     libfftw3-dev \
     libmbedtls-dev \
     libsctp-dev \
     libconfig++-dev \
     curl \
     iputils-ping \
     unzip \
     libzmq3-dev \
     libpcsclite-dev
WORKDIR /root

RUN apt-get --no-install-recommends -qy install build-essential git ca-certificates
RUN git clone https://github.com/srsLTE/srsLTE.git && cd srsLTE 

RUN mkdir -p /root/srsLTE/build

WORKDIR /root/srsLTE/build
RUN cmake ../
RUN make -j `nproc`
RUN make install
RUN ldconfig

WORKDIR /root
RUN mkdir /config

# network tools we might need
RUN apt-get --no-install-recommends -qy install iproute2 tcpdump net-tools iperf iperf3

# basically the UE and eNB are run as commands over this
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENTRYPOINT [ "stdbuf", "-o", "L" ]
