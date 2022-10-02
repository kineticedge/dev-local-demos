#!/bin/bash

set -e

if [ $# -lt 1 ]; then
 COUNT=1
else
 COUNT=$1
 shift
fi

function number() {
  echo $((RANDOM % $1))
}

function random() {
  openssl rand -hex 5
}

for i in $(seq "$COUNT"); do

        order_id=$(random)
        store_id=$(number 100)
        user_id=$(number 1000)
        quantity=$(number 9999)
        ts=$(date +"%Y-%m-%d %H:%M:%S")

 	      echo "creating order order_id=${order_id}, store_id=${store_id}, user_id=${user_id}, quantity=${quantity}, ts=${ts}"

        DOC="{ \"order_id\" : \\\"${order_id}\\\", \"store_id\" : \\\"${store_id}\\\", \"user_id\" : \\\"${user_id}\\\", \"quantity\" : ${quantity}, \"ts\" : \\\"${ts}\\\", \"x\" : \\\"y\\\" }"

        docker exec mongo sh -c "echo \"use main\ndb.orders.insertOne(${DOC});\" |  mongosh --quiet 'mongodb://root:mongo@mongo:27017/?directConnection=true'"

done
