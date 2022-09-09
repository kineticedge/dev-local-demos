#!/bin/sh

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

cd "$DEV_LOCAL"

./network.sh

(cd kafka; dc up -d)
(cd connect; dc up -d)

(cd connect; dc up -d --wait)
