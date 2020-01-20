#!/bin/sh


echo "Launching SGW..."

touch /usr/local/var/log/open5gs/sgw.log

tail -f /usr/local/var/log/open5gs/sgw.log &

open5gs-sgwd -c /usr/local/etc/open5gs/sgw.yaml
