#!/bin/sh

mkdir -p /usr/local/var/log/open5gs
touch /usr/local/var/log/open5gs/pcrf.log

tail -f /usr/local/var/log/open5gs/pcrf.log &

until mongo  --host 192.168.26.5 --eval "print(\"waited for connection\")" 2>&1 >/dev/null
  do
    sleep 5
    echo "Trying to connect to MongoDB"
  done

echo "Launching PCRF..."

open5gs-pcrfd -c /usr/local/etc/open5gs/pcrf.yaml
