#!/bin/sh

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

cd "$DEV_LOCAL"

./network.sh

(cd kafka; dc up -d $(docker-compose config --services | grep -v schema-registry))
(cd connect; dc up -d)
(cd druid; dc up -d)
(cd storage; dc up -d minio)

(cd druid; dc up -d --wait)
(cd connect; dc up -d --wait)
