#!/bin/bash

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

cd "$DEV_LOCAL"

(cd monitoring; docker compose down -v)
(cd ksqlDB; docker compose down -v)
(cd connect; docker compose down -v)
(cd kafka; docker compose down -v)
(cd mongo; docker compose down -v)
