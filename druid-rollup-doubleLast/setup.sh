#!/bin/sh

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

heading "creating topics"

subheading "creating 'opensky'"
kt --create --if-not-exists --replication-factor 3 --partitions 4 --topic opensky

subheading "creating druid datasources"
./druid.sh

