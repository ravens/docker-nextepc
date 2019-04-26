FROM ubuntu:16.04
MAINTAINER Yan Grunenberger <yan@grunenberger.net>

# nextepc binary
RUN apt-get update
#RUN apt-get -y install software-properties-common
#RUN add-apt-repository ppa:acetcom/nextepc
#RUN apt-get update
#RUN apt-get -y install nextepc

# web interface
#RUN apt-get -y install curl
#RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
#RUN curl -sL http://nextepc.org/static/webui/install | bash -

#USER nextepc

RUN apt-get update
RUN apt-get -qqy install autoconf libtool gcc pkg-config git flex bison libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libmongoc-dev libbson-dev libyaml-dev mongodb-clients
RUN git clone https://github.com/acetcom/nextepc

RUN cd nextepc/ && autoreconf -iv && ./configure --prefix=/ && make -j `nproc` && make install


RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y install nodejs

RUN cd nextepc/webui && npm install && npm run build

WORKDIR /

EXPOSE 3000