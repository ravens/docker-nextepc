#!/bin/sh

echo "Waiting for mongodb to be ready..."
sleep 5

echo "Launching HSS..."

touch /var/log/nextepc/hss.log

tail -f /var/log/nextepc/hss.log &

/bin/nextepc-hssd -f /etc/nextepc/hss.conf