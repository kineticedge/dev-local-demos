#!/bin/sh

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

heading "setup started."

subheading "creating 'users'"
kt --create --if-not-exists --replication-factor 3 --partitions 4 --topic users

subheading "creating connector 'datagen-users'"
$CONNECT create ./datagen-users.json

footing "setup completed."
