#!/bin/bash

set -e

cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

cd "$DEV_LOCAL"

./network.sh
(cd kafka; docker compose up -d)
(cd connect; docker compose up -d)
(cd ksqlDB; docker compose up -d)
(cd postgres; docker compose up -d)

# get both connect and ksqlDB running, but then wait on them at the end to ensure they are actually up.
(cd connect; docker compose up -d --wait)
(cd ksqlDB; docker compose up -d --wait)
