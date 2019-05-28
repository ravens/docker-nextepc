FROM alpine:latest
MAINTAINER Yan Grunenberger <yan@grunenberger.net>
RUN apk add --no-cache dnsmasq iptables
COPY dnsmasq.conf /root/dnsmasq.conf
COPY run.sh /root/run.sh
ENTRYPOINT ["/bin/sh","/root/run.sh"] 