#!/bin/sh

cd $(dirname $0)
. ../scripts/dev-local.sh

cd $DEV_LOCAL

./network.sh
(cd kafka; docker compose up -d)
(cd connect; docker compose up -d)
(cd cassandra; docker compose up -d)
(cd mongo; docker compose up -d)
(cd mysql; docker compose up -d)
(cd postgres; docker compose up -d)
(cd mysql5; docker compose up -d)
(cd ksqlDB; docker compose up -d)
(cd elasticsearch; docker compose up -d)
(cd connect; docker compose up -d --wait)
(cd cassandra; docker compose up -d --wait)
(cd mongo; docker compose up -d --wait)
