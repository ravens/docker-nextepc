#!/bin/sh

echo "Waiting for " ${MONGODB_STARTUP_TIME} "s for mongodb to be ready..."
sleep ${MONGODB_STARTUP_TIME}

echo "Launching HSS..."

touch /usr/local/var/log/open5gs/hss.log

tail -f /usr/local/var/log/open5gs/hss.log &

open5gs-hssd -c /usr/local/etc/open5gs/hss.yaml