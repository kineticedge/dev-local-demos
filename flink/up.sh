#!/bin/bash

set -e

cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

cd "$DEV_LOCAL"

./network.sh
(cd kafka; docker compose up -d)
(cd connect; docker compose up -d)
(cd flink; docker compose up -d)

(cd connect; docker compose up -d --wait)
