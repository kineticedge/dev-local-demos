#!/bin/bash

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh

KACC='kafka-avro-console-consumer \
	--bootstrap-server localhost:19092 \
	--property schema.registry.url=http://localhost:8081 \
	--property print.key=true \
	--property key.separator=| \
	--from-beginning \
	--skip-message-on-error \
	--key-deserializer=org.apache.kafka.common.serialization.BytesDeserializer \
	--max-messages 10 \
	--topic'

KACC_string='kafka-avro-console-consumer \
	--bootstrap-server localhost:19092 \
	--property schema.registry.url=http://localhost:8081 \
	--property print.key=true \
	--property key.separator=| \
	--from-beginning \
	--skip-message-on-error \
	--key-deserializer=org.apache.kafka.common.serialization.StringDeserializer \
	--max-messages 10 \
	--topic'


heading "String Deserializer"

$KACC_string users

heading "BytesDeserializer"

$KACC users
