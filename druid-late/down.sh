#!/bin/sh

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

cd "$DEV_LOCAL"

# in case they were started
(cd monitoring; dc down -v)
(cd dashboards; dc down -v)

(cd storage; dc down -v)
(cd connect; dc down -v)
(cd druid; dc down -v)
(cd kafka; dc down -v)
