#!/bin/bash

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh
. ../scripts/connector-install.sh

heading "installing connectors"

declare -a CONNECTORS=(
  "confluentinc-kafka-connect-s3;confluentinc/kafka-connect-s3:10.0.7"
)

installPlugins "${CONNECTORS[@]}"

heading "setting secrets/aws.properties"

# ensure that the aws secrets in connect cluster are set to minio's credentials.
#
cat > "${DEV_LOCAL}/connect/secrets/aws.properties" <<EOF
AWS_ACCESS_KEY_ID=druid
AWS_SECRET_ACCESS_KEY=druid_secret
EOF

