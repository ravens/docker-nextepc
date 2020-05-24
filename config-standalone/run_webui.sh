#!/bin/sh

until mongo --eval "print(\"waited for connection\")" 2>&1 >/dev/null
  do
    sleep 5
    echo "Trying to connect to MongoDB"
  done

npm run start --prefix /open5gs/webui
