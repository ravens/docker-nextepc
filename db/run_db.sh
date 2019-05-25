#!/bin/sh

# database export reference
#mongoexport  --host  192.168.26.5 --db nextepc --collection subscribers -o /tmp/imsi1.json --jsonArray

sleep 10
mongoimport --host  192.168.26.5 --db nextepc --collection subscribers --file /tmp/imsi1.json --type json  --jsonArray