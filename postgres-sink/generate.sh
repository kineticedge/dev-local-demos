#!/bin/bash

cd $(dirname $0)


if [ $# -lt 1 ]; then
 COUNT=1
else
 COUNT=$1
 shift
fi

function number() {
  echo $(($RANDOM % $1))
}

function random() {
  echo $(openssl rand -hex 5)
}

for i in $(seq $COUNT); do

  order_id=$(random)
  store_id=$(number 100)
  user_id=$(number 1000)
  quantity=$(number 9999)
  amt=$(echo "scale=2; $(number 9999)/100" | bc)

  ts=$(date -u +"%Y-%m-%d %H:%M:%S")

  echo "creating order order_id=${order_id}, store_id=${store_id}, user_id=${user_id}, quantity=${quantity}, amt=${amt}, ts=${ts}"

  KEY="${order_id}"
  VALUE="{ \"order_id\": \"${order_id}\", \"store_id\": \"${store_id}\", \"user_id\": \"${user_id}\", \"quantity\": ${quantity}, \"amt\": ${amt}, \"ts\": \"${ts}\" }"

  echo "${KEY}|${VALUE}" | kafka-console-producer --bootstrap-server localhost:19092 --topic ORDERS --property parse.key=true --property key.separator=\| --producer-property acks=all
  #sleep 0.1

done
