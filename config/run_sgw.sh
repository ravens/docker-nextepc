#!/bin/sh


echo "Launching SGW..."

mkdir -p /usr/local/var/log
touch /usr/local/var/log/open5gs/sgw.log

tail -f /usr/local/var/log/open5gs/sgw.log &

open5gs-sgwd -c /usr/local/etc/open5gs/sgw.yaml
