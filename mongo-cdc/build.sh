#!/bin/bash

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh
. ../scripts/connector-install.sh

declare -a CONNECTORS=(
  "debezium-debezium-connector-mongodb;debezium/debezium-connector-mongodb:1.9.2"
  "mongodb-kafka-connect-mongodb;mongodb/kafka-connect-mongodb:1.7.0"
)

installPlugins "${CONNECTORS[@]}"
