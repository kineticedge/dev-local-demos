#!/bin/sh

cd $(dirname $0)
. ../scripts/dev-local.sh

#JAVA_HOME=$JAVA14_HOME

BIN=${DEV_LOCAL}/bin
KSQL=$BIN/ksql-shell

$KSQL ./ksql/mysql_users.ksql
$KSQL ./ksql/mysql_stores.ksql
$KSQL ./ksql/mysql_orders.ksql

$KSQL ./ksql/postgres_users.ksql
$KSQL ./ksql/postgres_stores.ksql
$KSQL ./ksql/postgres_orders.ksql

$KSQL ./ksql/mysql5_users.ksql
$KSQL ./ksql/mysql5_stores.ksql
$KSQL ./ksql/mysql5_orders.ksql

$KSQL ./ksql/mysql_orders_enriched.ksql
$KSQL ./ksql/postgres_orders_enriched.ksql
$KSQL ./ksql/mysql5_orders_enriched.ksql

$KSQL ./ksql/all_orders.ksql
$KSQL ./ksql/all_orders_converted.ksql
