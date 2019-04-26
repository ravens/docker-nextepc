#!/bin/sh


echo "Launching PCRF..."

touch /var/log/nextepc/pcrf.log

tail -f /var/log/nextepc/pcrf.log &

/bin/nextepc-pcrfd -f /etc/nextepc/pcrf.conf
