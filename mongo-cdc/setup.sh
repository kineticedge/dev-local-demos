#!/bin/bash

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

$CONNECT available
[ $? -ne 0 ] && echo "connector RESTful API is not yet available, aborting script. wait until connector is ready to run this script." && exit 1

$CONNECT create ./connectors/mongo-cdc.json
$CONNECT status ./connectors/mongo-cdc.json

$CONNECT create ./connectors/mongo.json
$CONNECT status ./connectors/mongo.json
