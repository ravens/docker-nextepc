#!/bin/sh


echo "Launching MME..."

touch /var/log/nextepc/mme.log

tail -f /var/log/nextepc/mme.log &

/bin/nextepc-mmed -f /etc/nextepc/mme.conf
