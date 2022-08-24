#!/bin/sh

cd $(dirname $0)
. ../scripts/dev-local.sh

touch ../tmp/connect-distributed.properties

echo ""
echo "installing connectors needed to run this demo"
echo ""

if [ ! -d "${DEV_LOCAL}/connect/jars/mongodb-kafka-connect-mongodb" ]; then
  echo "installing connector: mongodb-kafka-connect-mongodb"
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ${DEV_LOCAL}/connect/jars --no-prompt mongodb/kafka-connect-mongodb:1.7.0
  echo ""
else
  echo "connector already installed: mongodb-kafka-connect-mongodb"
fi

if [ ! -d "${DEV_LOCAL}/connect/jars/datastax-kafka-connect-cassandra-sink" ]; then
  echo "installing connector: datastax-kafka-connect-cassandra-sink"
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ${DEV_LOCAL}/connect/jars --no-prompt datastax/kafka-connect-cassandra-sink:1.4.0
  echo""
else
  echo "connector already installed: datastax-kafka-connect-cassandra-sink"
fi

if [ ! -d "${DEV_LOCAL}/connect/jars/debezium-debezium-connector-mysql" ]; then
  echo "installing connector: debezium-debezium-connector-mysql"
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ${DEV_LOCAL}/connect/jars --no-prompt debezium/debezium-connector-mysql:1.9.2
  echo""
else
  echo "connector already installed: debezium-debezium-connector-mysql"
fi

if [ ! -d "${DEV_LOCAL}/connect/jars/debezium-debezium-connector-postgresql" ]; then
  echo "installing connector: debezium-debezium-connector-postgresql"
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ${DEV_LOCAL}/connect/jars --no-prompt debezium/debezium-connector-postgresql:1.9.2
  echo""
else
  echo "connector already installed: debezium-debezium-connector-postgresql"
fi

if [ ! -d "${DEV_LOCAL}/connect/jars/confluentinc-kafka-connect-elasticsearch" ]; then
  echo "installing connector: kafka-connect-elasticsearch"
  confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir ${DEV_LOCAL}/connect/jars --no-prompt confluentinc/kafka-connect-elasticsearch:14.0.0
  echo""
else
  echo "connector already installed: kafka-connect-elasticsearch"
fi



echo ""

rm -f ../tmp/connect-distributed.properties

