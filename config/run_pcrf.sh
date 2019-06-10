#!/bin/sh


echo "Launching PCRF..."

touch /var/log/nextepc/pcrf.log

tail -f /var/log/nextepc/pcrf.log &

echo "Waiting for " ${MONGODB_STARTUP_TIME} "s for mongodb to be ready..."
sleep ${MONGODB_STARTUP_TIME}

/bin/nextepc-pcrfd -f /etc/nextepc/pcrf.conf
