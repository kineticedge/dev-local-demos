#!/bin/bash

declare -a URLS=(http://localhost:18083/admin/loggers http://localhost:28083/admin/loggers)

CT="Content-Type:application/json"

for URL in "${URLS[@]}" ; do

echo $URL

curl -s -X PUT -H $CT ${URL}/io.confluent.connect.jdbc -d '{"level": "TRACE"}' | jq '.'
curl -s -X PUT -H $CT ${URL}/org.postgresql.Driver -d '{"level": "TRACE"}' | jq '.'

curl -s -X PUT -H $CT ${URL}/org.apache.kafka.connect.runtime.WorkerSinkTask -d '{"level": "TRACE"}' | jq '.'

done
