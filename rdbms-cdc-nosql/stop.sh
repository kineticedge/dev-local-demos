#!/bin/sh

cd $(dirname $0)
. ../scripts/dev-local.sh

cd $DEV_LOCAL

# in case they were started
(cd dashboards; docker compose down)
(cd monitoring; docker compose down)

(cd ksqlDB; docker compose down)
(cd connect; docker compose down)
(cd kafka; docker compose down)
(cd mysql; docker compose down)
(cd mysql5; docker compose down)
(cd postgres; docker compose down)
(cd cassandra; docker compose down)
(cd mongo; docker compose down)
(cd elasticsearch; docker compose down)
