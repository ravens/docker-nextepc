#!/bin/sh

ip tuntap add name ogstun mode tun
ip addr add 45.45.0.1/16 dev ogstun
#ip addr add cafe::1/16 dev ogstun
ip link set ogstun up

# masquerade
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -I INPUT -i ogstun -j ACCEPT

touch /usr/local/var/log/open5gs/pgw.log

tail -f /usr/local/var/log/open5gs/pgw.log &

open5gs-pgwd -c /usr/local/etc/open5gs/pgw.yaml
