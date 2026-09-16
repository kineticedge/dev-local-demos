#!/bin/bash

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh
. ../scripts/connector-install.sh

heading "installing connectors"

declare -a CONNECTORS=(
  "confluentinc-kafka-connect-datagen;confluentinc/kafka-connect-datagen:latest"
)

installPlugins "${CONNECTORS[@]}"

heading "installing avro specification"

cp -r ./application/src/main/avro/order.avsc ../../dev-local/connect/data/datagen

footing "installation of connectors and needed data for connectors completed."
