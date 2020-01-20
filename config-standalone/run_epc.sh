#!/bin/sh

ip tuntap add name pgwtun mode tun
ip tuntap add name pgwtun2 mode tun
ip addr add 45.45.0.1/16 dev pgwtun
ip addr add 45.46.0.1/16 dev pgwtun2
ip addr add cafe::1/16 dev pgwtun
ip addr add cafe::2/16 dev pgwtun
ip link set pgwtun up
ip link set pgwtun2 up

# masquerade
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -I INPUT -i pgwtun -j ACCEPT
iptables -I INPUT -i pgwtun2 -j ACCEPT

# on AWS this seems to be necessary. TODO : YG to check default network config
iptables -A FORWARD -j ACCEPT

# to avoid fragmentation related issue, let's tune the MSS window
iptables -t mangle -A POSTROUTING -p tcp --tcp-flags SYN,RST SYN -o eth0 -j TCPMSS --set-mss 1300

touch /var/log/open5gs/open5gs.log

tail -f /var/log/open5gs/open5gs.log &

echo "Waiting for " ${MONGODB_STARTUP_TIME} "s for mongodb to be ready..."
sleep ${MONGODB_STARTUP_TIME}

sleep infinity
open5gs-epcd -f /usr/local/etc/open5gs.conf