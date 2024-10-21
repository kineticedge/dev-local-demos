#!/bin/sh

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

$CONNECT recreate ./connect/opensky.json
$CONNECT status ./connect/opensky.json
