#!/bin/bash

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh
. ../scripts/connector-install.sh

declare -a CONNECTORS=(
  "confluentinc-kafka-connect-avro-converter;confluentinc/kafka-connect-avro-converter:7.3.0"
  "confluentinc-kafka-connect-jdbc;confluentinc/kafka-connect-jdbc:10.6.1"
)

# shellcheck disable=SC2068
# actually need elements split as they are arguments into a function expected them as elements
installPlugins ${CONNECTORS[@]}
