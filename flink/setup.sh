#!/bin/sh

set -e

cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

heading "setup started."

subheading "installing avro specification to connect cluster for datagen"
cp -r ./application/src/main/avro/order.avsc ../../dev-local/connect/data/datagen

subheading "creating topics"
kt --create --if-not-exists --replication-factor 3 --partitions 4 --topic datagen.orders
kt --create --if-not-exists --replication-factor 3 --partitions 4 --topic purchase-orders

subheading "creating connector 'datagen-orders'"
$CONNECT create ./connectors/datagen-orders.json

subheading "launch application"
(cd application; gradle build shadowJar; cp ./build/libs/flink_application-all.jar ../../../dev-local/flink/jars)

docker exec -it flink_jobmanager sh -c "flink run --detached /jars/flink_application-all.jar"

footing "setup completed."
