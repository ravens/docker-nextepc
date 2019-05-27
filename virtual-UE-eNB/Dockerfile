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
     unzip
WORKDIR /root

RUN apt-get --no-install-recommends -qy install build-essential git ca-certificates
RUN git clone https://github.com/jgiovatto/srsLTE.git && cd srsLTE && git checkout faux_rf

RUN mkdir -p /root/srsLTE/build

WORKDIR /root/srsLTE/build
RUN cmake ../
RUN make -j `nproc` install
RUN ldconfig

WORKDIR /root
RUN mkdir /config

# eNB specific files
RUN cp /root/srsLTE/srsenb/enb.conf.fauxrf.example /config/enb.conf.fauxrf
RUN cp /root/srsLTE/srsenb/drb.conf.example /config/drb.conf
RUN cp /root/srsLTE/srsenb/enb.conf.example /config/enb.conf
RUN cp /root/srsLTE/srsenb/rr.conf.example /config/rr.conf
RUN cp /root/srsLTE/srsenb/sib.conf.example /config/sib.conf
RUN cp /root/srsLTE/srsenb/sib.conf.mbsfn.example /config/sib.mbsfn.conf

# UE specific files
RUN cp /root/srsLTE/srsue/ue.conf.fauxrf.example /config/ue.conf.fauxrf
# patch to prevent overriding OPC/OP
RUN sed -i s,"opc  = 63BFA50EE6523365FF14C1F45F88737D","#opc  = 63BFA50EE6523365FF14C1F45F88737D",g /config/ue.conf.fauxrf

# network tools we might need
RUN apt-get --no-install-recommends -qy install iproute2 tcpdump net-tools iperf iperf3

# from https://github.com/pgorczak/srslte-docker-emulated/blob/master/Dockerfile
# basically the UE and eNB are run as commands over this
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENTRYPOINT [ "stdbuf", "-o", "L" ]

