#!/bin/sh

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

heading "creating topics"

subheading "creating 'orders'"
kt --create --if-not-exists --replication-factor 3 --partitions 4 --topic orders
subheading "creating 'skus'"
kt --create --if-not-exists --replication-factor 3 --partitions 4 --topic skus

MC="docker run -it --rm --network dev-local --volume $(pwd)/minio/mc-config.json:/root/.mc/config.json minio/mc:latest"

heading "configuring minio"

subheading "creating bucket 'sku'"
$MC mb minio/sku

subheading "creating bucket 'order'"
$MC mb minio/order

subheading "creating service account 'druid'"
$MC admin user svcacct add minio admin --access-key druid --secret-key druid_secret

subheading "creating druid datasources"
./druid.sh

