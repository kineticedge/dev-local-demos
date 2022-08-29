#!/bin/sh

cd $(dirname $0)
. ../scripts/dev-local.sh

is_connect_ready

heading "setup: started"

subheading "kafka: create topics"

declare -a topics=(
  ALL_ORDERS
  MYSQL_ORDERS_ENRICHED
  POSTGRES_ORDERS_ENRICHED
  MYSQL5_ORDERS_ENRICHED
  _mysql_.main.orders
  _mysql_.main.stores
  _mysql_.main.users
  _mysql5_.main.orders
  _mysql5_.main.stores
  _mysql5_.main.users
  _postgres_.public.orders
  _postgres_.public.stores
  _postgres_.public.users
)

for topic in "${topics[@]}"; do
   echo "creating topic: $topic"
   kt --if-not-exists --create --replication-factor 3 --partitions 4 --topic "$topic" | grep -v "WARNING: Due to limitations in metric names,"
done


subheading "mysql: create tables"
cat > ${DEV_LOCAL}/mysql/data/schema.sql <<EOF
drop table if exists \`orders\`;
create table \`orders\` (
    \`order_id\` varchar(10) NOT NULL,
    \`store_id\` varchar(10) NOT NULL,
    \`user_id\` varchar(10) NOT NULL,
    \`quantity\` integer NULL,
    \`amount\` decimal(4,2) NULL,
    \`ts\` datetime NULL,
    primary key (\`order_id\`)
);
drop table if exists \`stores\`;
create table \`stores\` (
    \`store_id\` varchar(10) NOT NULL,
    \`store_name\` varchar(400) NOT NULL,
    primary key (\`store_id\`)
);
drop table if exists \`users\`;
create table \`users\` (
    \`user_id\` varchar(10) NOT NULL,
    \`user_name\` varchar(400) NOT NULL,
    primary key (\`user_id\`)
);
EOF
cp ${DEV_LOCAL}/mysql/data/schema.sql ${DEV_LOCAL}/mysql5/data/schema.sql
docker exec -it mysql sh -c "cat /data/schema.sql | mysql --user=user --password=userpw main"
docker exec -it mysql5 sh -c "cat /data/schema.sql | mysql --user=user --password=userpw main"
rm -f ${DEV_LOCAL}/mysql/data/schema.sql
rm -f ${DEV_LOCAL}/mysql5/data/schema.sql

subheading "postgres: create tables"
cat > ${DEV_LOCAL}/postgres/data/schema.sql <<EOF
drop table if exists "orders";
create table "orders" (
    "order_id" varchar(10) NOT NULL,
    "store_id" varchar(10) NOT NULL,
    "user_id" varchar(10) NOT NULL,
    "quantity" integer NULL,
    "amount" decimal(4,2) NULL,
    "ts" timestamp NULL,
    primary key ("order_id")
);
drop table if exists "stores";
create table "stores" (
    "store_id" varchar(10) NOT NULL,
    "store_name" varchar(400) NOT NULL,
    primary key ("store_id")
);
drop table if exists "users";
create table "users" (
    "user_id" varchar(10) NOT NULL,
    "user_name" varchar(400) NOT NULL,
    primary key ("user_id")
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
rm -f ${DEV_LOCAL}/postgres/data/schema.sql


subheading "connect : start debezium mysql cdc source connector"
$CONNECT create ./connectors/mysql-cdc.json
$CONNECT status ./connectors/mysql-cdc.json

subheading "connect : start debezium postgres cdc source connector"
$CONNECT create ./connectors/postgres-cdc.json
$CONNECT status ./connectors/postgres-cdc.json

subheading "connect : start debezium mysql5 cdc source connector"
$CONNECT create ./connectors/mysql5-cdc.json
$CONNECT status ./connectors/mysql5-cdc.json

subheading "cassandra : create keyspace and tables"
cat > ${DEV_LOCAL}/cassandra/data/schema.sql <<EOF
create keyspace if not exists "main" with replication = {'class':'SimpleStrategy','replication_factor':1};
use "main";
create table "orders" (order_id text primary key, store_id text, user_id text, quantity int, amount decimal, ts timestamp);
create table "orders_enriched" (order_id text primary key, store_id text, store_name text, user_id text, user_name text, quantity int, amount decimal, ts timestamp);
create table "all_orders" (source_system text, order_id text, store_id text, store_name text, user_id text, user_name text, quantity int, amount decimal, ts timestamp, PRIMARY KEY (source_system, order_id));
create table "all_orders_converted" (source_system text, order_id text, store_id text, store_name text, user_id text, user_name text, quantity int, amount decimal, ts timestamp, PRIMARY KEY (source_system, order_id));
EOF
docker exec -it cassandra sh -c "cat /data/schema.sql | cqlsh --password=cassandra"
rm -f ${DEV_LOCAL}/cassandra/data/schema.sql

subheading "connect : start the datastax cassandra sink connector"
$CONNECT create ./connectors/cassandra.json
$CONNECT status ./connectors/cassandra.json

subheading "connect : start the Mongo mongoDB sink connector"
$CONNECT create ./connectors/mongo.json
$CONNECT status ./connectors/mongo.json

#
subheading "mysql : Load 100 stores into the 'stores' table and 1000 users into the 'users' table."
#
sleep 1
cp ./data/stores.csv ${DEV_LOCAL}/mysql/data/stores.csv
cp ./data/users.csv ${DEV_LOCAL}/mysql/data/users.csv
cat > ${DEV_LOCAL}/mysql/data/load.sql <<EOF
LOAD DATA LOCAL INFILE '/data/stores.csv' INTO TABLE stores FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
LOAD DATA LOCAL INFILE '/data/users.csv' INTO TABLE users FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
EOF
docker exec -it mysql sh -c "cat /data/load.sql | mysql --user=user --password=userpw main"
rm -f ${DEV_LOCAL}/mysql/data/load.sql
rm -f ${DEV_LOCAL}/mysql/data/stores.csv
rm -f ${DEV_LOCAL}/mysql/data/users.csv

#
subheading "postgres : Load 100 stores into the 'stores' table and 1000 users into the 'users' table."
sleep 1
cp ./data/stores.csv ${DEV_LOCAL}/postgres/data/stores.csv
cp ./data/users.csv ${DEV_LOCAL}/postgres/data/users.csv
cat > ${DEV_LOCAL}/postgres/data/load.sql <<EOF
truncate stores;
COPY stores(store_id, store_name) FROM '/data/stores.csv' DELIMITER ',' CSV HEADER;
truncate users;
COPY users(user_id, user_name) FROM '/data/users.csv' DELIMITER ',' CSV HEADER;
EOF
docker exec -it postgres sh -c "cat /data/load.sql | psql --dbname=main --user=admin"
rm -f ${DEV_LOCAL}/postgres/data/load.sql
rm -f ${DEV_LOCAL}/postgres/data/stores.csv
rm -f ${DEV_LOCAL}/postgres/data/users.csv

#
subheading "mysql5 : Load 100 stores into the 'stores' table and 1000 users into the 'users' table."
#
sleep 1
cp ./data/stores.csv ${DEV_LOCAL}/mysql5/data/stores.csv
cp ./data/users.csv ${DEV_LOCAL}/mysql5/data/users.csv
cat > ${DEV_LOCAL}/mysql5/data/load.sql <<EOF
LOAD DATA LOCAL INFILE '/data/stores.csv' INTO TABLE stores FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
LOAD DATA LOCAL INFILE '/data/users.csv' INTO TABLE users FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
EOF
docker exec -it mysql5 sh -c "cat /data/load.sql | mysql --user=user --password=userpw main"
rm -f ${DEV_LOCAL}/mysql5/data/load.sql
rm -f ${DEV_LOCAL}/mysql5/data/stores.csv
rm -f ${DEV_LOCAL}/mysql5/data/users.csv

#
# if schemas are not pre-registered, then ksqlDB streams and tables would not be configurable until after at least one message
# has been published to the respective topics (ensuring that the schema is associated to the topic and then can be referenced
# by ksqlDB when streams and tables are created).
#
subheading "schemas : register schemas necessary prior to running ksql scripts."
./register_schemas.sh

#
# only able to do this as part of setup script, because of the registration of schemas done above.
#
subheading "ksqldb : configurating tables and streams in ksqlDB"
./ksql.sh

footing "setup: completed"
