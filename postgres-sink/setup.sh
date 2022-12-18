#!/bin/bash

cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

# want to error out of connector isn't up and running (set -e will cause this not to work, looking to redesign).
is_connect_ready

heading "setup: started"

subheading "kafka: create topics"

declare -a topics=(
  ORDERS
)

for topic in "${topics[@]}"; do
   echo "creating topic: $topic"
   kt --if-not-exists --create --replication-factor 3 --partitions 4 --topic "$topic" | grep -v "WARNING: Due to limitations in metric names,"
done

subheading "postgres: create tables"
cat > "${DEV_LOCAL}/postgres/data/schema.sql" <<EOF
drop table if exists "ORDERS";
create table "ORDERS" (
    "ORDER_ID" varchar(10) NOT NULL,
    "STORE_ID" varchar(10) NOT NULL,
    "USER_ID" varchar(10) NOT NULL,
    "QUANTITY" integer NULL,
    "AMT" decimal(4,2) NULL,
    "TS" timestamp NULL,
    primary key ("ORDER_ID")
);

DO
\$do\$
BEGIN
   IF EXISTS ( SELECT FROM pg_catalog.pg_roles WHERE  rolname = 'main') THEN
      RAISE NOTICE 'Role "main" already exists. Skipping.';
   ELSE
      CREATE ROLE main REPLICATION LOGIN;
   END IF;
END;
\$do$\;

EOF
docker exec -it postgres sh -c "cat /data/schema.sql | psql --dbname=main --user=admin"
rm -f "${DEV_LOCAL}/postgres/data/schema.sql"

subheading "ksql : configuration tables and streams in ksqlDB"

$KSQL_SHELL ./ksql/input.ksql
$KSQL_SHELL ./ksql/orders.ksql

subheading "connect : start postgres sink connector"

$CONNECT create ./connectors/postgres.json

footing "setup: completed"
