#!/bin/sh

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

$DRUID load ./druid/orders.json
$DRUID load ./druid/skus.json
