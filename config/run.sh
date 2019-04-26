#!/bin/sh

ip tuntap add name pgwtun mode tun
ip addr add 45.45.0.1/16 dev pgwtun
#ip addr add cafe::1/16 dev pgwtun
ip link set pgwtun up

sleep 5

# admin / 1423
DB_URI="mongodb://mongodb/nextepc" npm run start --prefix webui &

/nextepc/nextepc-epcd -f /config/nextepc.conf