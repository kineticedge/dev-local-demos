#!/bin/sh

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

cd "$DEV_LOCAL"

(cd connect; dc down -v)
(cd kafka; dc down -v)
