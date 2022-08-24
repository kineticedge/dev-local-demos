#!/bin/bash

cd $(dirname $0)

if [ $# -lt 1 ]; then
 echo "usage: $0 -postgres|-mysql|--mysql5 [count]"
 exit
fi

if [ $1 == "--postgres" -o $1 == "-p" ]; then 
 DB=POSTGRES
 shift
elif [ $1 == "--mysql" -o $1 == "-m" ]; then
 DB=MYSQL
 shift
elif [ $1 == "--mysql5" -o $1 == "-m5" ]; then
 DB=MYSQL5
 shift
else
 echo "usage: $0 --postgres|--mysql|--mysql5 [count]"
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

for i in $(seq $COUNT); do

  order_id=$(random)
  store_id=$(number 100)
  user_id=$(number 1000)
  quantity=$(number 9999)
  amt=$(echo "scale=2; $(number 9999)/100" | bc)

  ts=$(date +"%Y-%m-%d %H:%M:%S")

  echo "creating order order_id=${order_id}, store_id=${store_id}, user_id=${user_id}, quantity=${quantity}, amt=${amt}, ts=${ts}"

  if [ "$DB" == "MYSQL" ]; then
    docker exec mysql sh -c "echo \"insert into orders values('${order_id}', '${store_id}', '${user_id}', ${quantity}, ${amt}, '${ts}')\" | mysql --user=user --password=userpw main"
  elif [ "$DB" == "MYSQL5" ]; then
    docker exec mysql5 sh -c "echo \"insert into orders values('${order_id}', '${store_id}', '${user_id}', ${quantity}, ${amt}, '${ts}')\" | mysql --user=user --password=userpw main"
  elif [ "$DB" == "POSTGRES" ]; then
    docker exec postgres sh -c "echo \"insert into orders values('${order_id}', '${store_id}', '${user_id}', ${quantity}, ${amt}, '${ts}')\" | psql --dbname=main --user=admin"
  fi

  #sleep 0.1

done
