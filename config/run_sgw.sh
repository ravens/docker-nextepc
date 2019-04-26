#!/bin/sh


echo "Launching SGW..."

touch /var/log/nextepc/sgw.log

tail -f /var/log/nextepc/sgw.log &

/bin/nextepc-sgwd -f /etc/nextepc/sgw.conf
