#!/bin/bash

cd $(dirname $0)


if [ $# -lt 1 ]; then
 echo "usage: $0 --order|--user [count]"
 exit
fi

if [ "$1" == "--order" -o "$1" == "-o" ]; then
 TYPE=ORDER
 shift
elif [ "$1" == "--user" -o "$1" == "-u" ]; then
 TYPE=USER
 shift
else
 echo "usage: $0 --order|--user [count]"
 exit
fi

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

if [ "$TYPE" == "ORDER" ]; then

for i in $(seq $COUNT); do

  order_id=$(random)
  store_id=$(number 100)
  user_id=$(number 1000)
  quantity=$(number 9999)
  amt=$(echo "scale=2; $(number 9999)/100" | bc)
  #amt=$(echo "scale=2; $(number 9999999)/100000" | bc)

  ts=$(date -u +"%Y-%m-%d %H:%M:%S")

  echo "creating order order_id=${order_id}, store_id=${store_id}, user_id=${user_id}, quantity=${quantity}, amt=${amt}, ts=${ts}"

  KEY="${order_id}"
  VALUE="{ \"order_id\": \"${order_id}\", \"store_id\": \"${store_id}\", \"user_id\": \"${user_id}\", \"quantity\": ${quantity}, \"amt\": ${amt}, \"ts\": \"${ts}\" }"

  echo "${KEY}|${VALUE}" | kafka-console-producer --bootstrap-server localhost:19092 --topic ORDERS --property parse.key=true --property key.separator=\| --producer-property acks=all
  #sleep 0.1

done

elif  [ "$TYPE" == "USER" ]; then

for i in $(seq $COUNT); do
  order_id=$(random)
  store_id=$(number 100)
  user_id=$(number 1000)
  first_name="FIRST_NAME_$user_id"
  last_name="LAST_NAME_$(random)"

  echo "creating order user_id=${user_id}, first_name=${first_name}, last_name=${last_name}"

  KEY="${user_id}"
  VALUE="{ \"user_id\": \"${user_id}\", \"first_name\": \"${first_name}\", \"last_name\": \"${last_name}\" }"

  echo "${KEY}|${VALUE}" | kafka-console-producer --bootstrap-server localhost:19092 --topic USERS --property parse.key=true --property key.separator=\| --producer-property acks=all
  #sleep 0.1

done

fi
