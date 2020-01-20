#!/bin/sh

echo "Launching MME..."

touch /usr/local/var/log/open5gs/mme.log

tail -f /usr/local/var/log/open5gs/mme.log &

open5gs-mmed -c /usr/local/etc/open5gs/mme.yaml
