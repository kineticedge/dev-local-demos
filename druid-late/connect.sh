#!/bin/sh

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

$CONNECT recreate ./connect/s3.json
$CONNECT status ./connect/s3.json
