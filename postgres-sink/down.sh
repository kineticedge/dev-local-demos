#!/bin/bash

set -e

cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

cd "$DEV_LOCAL"

# in case they were started
(cd dashboards; docker compose down -v)
(cd monitoring; docker compose down -v)

(cd ksqlDB; docker compose down -v)
(cd connect; docker compose down -v)
(cd kafka; docker compose down -v)
(cd postgres; docker compose down -v)
