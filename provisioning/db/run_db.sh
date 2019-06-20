#!/bin/sh

# database export reference
#mongoexport  --host  ${DB_HOST} --db nextepc --collection subscribers -o /tmp/imsi1.json --jsonArray

if [ -n "${DB_HOST}" ]; then
  echo "Database variable found"
else
  echo "Database variable not found, using default one"
  DB_HOST=mongodb
fi

echo "Will use ${DB_HOST}"

if [ -n "${MONGODB_STARTUP_TIME}" ]; then
  echo "Mongodb startup wait found"
else
  echo "Mongodb startup wait variable not found, using default one"
  MONGODB_STARTUP_TIME=5
fi
echo "Waiting for " ${MONGODB_STARTUP_TIME} "s for mongodb to be ready..."
sleep ${MONGODB_STARTUP_TIME}

mongoimport --host ${DB_HOST} --db nextepc --collection subscribers --file /tmp/imsi1.json --type json  --jsonArray
sleep infinity
