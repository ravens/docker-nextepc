#!/bin/sh

ip tuntap add name pgwtun mode tun
ip addr add 45.45.0.1/16 dev pgwtun
#ip addr add cafe::1/16 dev pgwtun
ip link set pgwtun up

# masquerade
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -I INPUT -i pgwtun -j ACCEPT

#/nextepc/nextepc-epcd -f /config/nextepc.conf

touch /var/log/nextepc/nextepc.log

tail -f /var/log/nextepc/nextepc.log &

/bin/nextepc-epcd -f /etc/nextepc/nextepc.conf