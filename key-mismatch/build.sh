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

