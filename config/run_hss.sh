#!/bin/sh

echo "Waiting for " ${MONGODB_STARTUP_TIME} "s for mongodb to be ready..."
sleep ${MONGODB_STARTUP_TIME}

echo "Launching HSS..."

touch /var/log/nextepc/hss.log

tail -f /var/log/nextepc/hss.log &

/bin/nextepc-hssd -f /etc/nextepc/hss.conf