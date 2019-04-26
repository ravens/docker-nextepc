FROM ubuntu:18.04
MAINTAINER Yan Grunenberger <yan@grunenberger.net>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -yq dist-upgrade
RUN apt-get install -yq \
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

# srsLTE with shared memory element
ARG COMMIT=5d82f19988bc148d7f4cec7a0f29184375a64b40
RUN curl -LO https://github.com/jgiovatto/srsLTE/archive/${COMMIT}.zip \
 && unzip ${COMMIT}.zip

RUN mkdir -p /root/srsLTE-${COMMIT}/build

WORKDIR /root/srsLTE-${COMMIT}/build
RUN cmake ../
RUN make install
RUN ldconfig

WORKDIR /root
RUN mkdir /config

# eNB specific files
RUN cp /root/srsLTE-${COMMIT}/srsenb/enb.conf.fauxrf.example /config/enb.conf.fauxrf
RUN cp /root/srsLTE-${COMMIT}/srsenb/drb.conf.example /config/drb.conf
RUN cp /root/srsLTE-${COMMIT}/srsenb/enb.conf.example /config/enb.conf
RUN cp /root/srsLTE-${COMMIT}/srsenb/rr.conf.example /config/rr.conf
RUN cp /root/srsLTE-${COMMIT}/srsenb/sib.conf.example /config/sib.conf
RUN cp /root/srsLTE-${COMMIT}/srsenb/sib.conf.mbsfn.example /config/sib.mbsfn.conf

# UE specific files
RUN cp /root/srsLTE-${COMMIT}/srsue/ue.conf.fauxrf.example /config/ue.conf.fauxrf
# patch to prevent overriding OPC/OP
RUN sed -i s,"opc  = 63BFA50EE6523365FF14C1F45F88737D","#opc  = 63BFA50EE6523365FF14C1F45F88737D",g /config/ue.conf.fauxrf

# network tools we might need
RUN apt-get -qy install iproute2 tcpdump net-tools iperf iperf3

# from https://github.com/pgorczak/srslte-docker-emulated/blob/master/Dockerfile
# basically the UE and eNB are run as commands over this
ENTRYPOINT [ "stdbuf", "-o", "L" ]
