#!/bin/sh

echo "Launching PCRF..."

touch /usr/local/var/log/open5gs/pcrf.log

tail -f /usr/local/var/log/open5gs/pcrf.log &

echo "Waiting for " ${MONGODB_STARTUP_TIME} "s for mongodb to be ready..."
sleep ${MONGODB_STARTUP_TIME}

open5gs-pcrfd -c /usr/local/etc/open5gs/pcrf.yaml
