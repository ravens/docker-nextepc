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
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -I INPUT -i pgwtun -j ACCEPT
iptables -I INPUT -i pgwtun2 -j ACCEPT

#/nextepc/nextepc-epcd -f /config/nextepc.conf

touch /var/log/nextepc/nextepc.log

tail -f /var/log/nextepc/nextepc.log &

echo "Waiting for mongodb to be ready..."
sleep 5

/bin/nextepc-epcd -f /etc/nextepc/nextepc.conf